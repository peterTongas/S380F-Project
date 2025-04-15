package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.PollOption;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.model.UserRole;
import com.example.s380fproject_3103_2.service.PollService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.ConcurrentModificationException;
import java.util.List;

@Controller
@RequestMapping("/poll")
public class PollController {
    @Autowired
    private PollService pollService;

    @GetMapping("/{id}")
    public String viewPoll(@PathVariable Long id, 
                           @RequestParam(name = "error", required = false) String error, 
                           HttpSession session,
                           Model model) {
        Poll poll = pollService.getPollById(id);
        
        // 確保重置投票狀態，避免多人共用
        if (poll != null) {
            poll.setUserVotedOptionId(null);
            poll.setAccessible(true);
        }
        
        model.addAttribute("poll", poll);
        
        // 如果有錯誤參數，添加錯誤消息
        if ("noSelection".equals(error)) {
            model.addAttribute("errorMessage", "請選擇一個選項後再提交投票");
        } else if ("alreadyVoted".equals(error)) {
            model.addAttribute("errorMessage", "您已經對此投票問題投過票了");
        }
        
        // 檢查當前用戶是否已對該問題投票
        User currentUser = (User) session.getAttribute("currentUser");
        boolean hasVoted = false;
        
        if (currentUser != null && poll != null) {
            try {
                // 確保我們正確檢查用戶是否對此特定投票投過票
                hasVoted = pollService.hasUserVotedInPollSafe(currentUser.getUsername(), id);
                
                // 如果用戶已投票，查詢他們投票的選項ID
                if (hasVoted) {
                    Long votedOptionId = pollService.findVotedOptionId(currentUser.getUsername(), id);
                    poll.setUserVotedOptionId(votedOptionId);
                }
                
                // 調試輸出，幫助識別問題
                System.out.println("用戶 " + currentUser.getUsername() + " 對投票 #" + id + " 的投票狀態: " + 
                                  hasVoted + ", 選項ID: " + poll.getUserVotedOptionId());
            } catch (ConcurrentModificationException cme) {
                // 特別處理並發修改異常
                System.err.println("檢查投票狀態時發生並發修改異常，可能是因為同時有人正在投票。用戶: " 
                        + currentUser.getUsername() + ", 投票ID: " + id);
                // 採取保守策略，查詢數據庫確認
                hasVoted = pollService.hasUserVotedInPollSafe(currentUser.getUsername(), id);
                if (hasVoted) {
                    Long votedOptionId = pollService.findVotedOptionId(currentUser.getUsername(), id);
                    poll.setUserVotedOptionId(votedOptionId);
                }
            } catch (Exception e) {
                // 處理其他例外，避免應用程序崩潰
                System.err.println("檢查投票狀態時發生錯誤: " + e.getMessage() + ", 類型: " + e.getClass().getName());
                e.printStackTrace(); // 添加完整堆疊追蹤以幫助調試
                // 採取保守策略，查詢數據庫確認
                hasVoted = pollService.hasUserVotedInPollSafe(currentUser.getUsername(), id);
                if (hasVoted) {
                    Long votedOptionId = pollService.findVotedOptionId(currentUser.getUsername(), id);
                    poll.setUserVotedOptionId(votedOptionId);
                }
            }
            model.addAttribute("hasVoted", hasVoted);
        } else {
            // 未登入用戶默認未投票
            model.addAttribute("hasVoted", false);
        }
        
        model.addAttribute("pageTitle", "Poll Details");
        model.addAttribute("contentPage", "poll/view.jsp");
        return "layout";
    }

    @PostMapping("/vote/{pollId}")
    public String vote(@PathVariable Long pollId, 
                       @RequestParam(required = false) Integer optionIndex, 
                       HttpSession session,
                       Model model) {
        // 檢查是否選擇了選項
        if (optionIndex == null) {
            return "redirect:/poll/" + pollId + "?error=noSelection";
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            // 先記錄當前用戶和投票信息，便於診斷
            System.out.println("用戶 " + currentUser.getUsername() + " 正在嘗試投票，投票ID: " + pollId + ", 選項索引: " + optionIndex);
            
            // 先檢查用戶是否有權限投票
            try {
                // 使用更可靠的方法檢查是否已投票（直接使用SQL查詢而不是檢查集合）
                boolean hasVoted = pollService.hasUserVotedInPollSafe(currentUser.getUsername(), pollId);
                System.out.println("檢查投票狀態（安全）: 用戶 " + currentUser.getUsername() + " 對投票 #" + pollId + " 的投票狀態: " + hasVoted);
                
                if (hasVoted) {
                    System.out.println("用戶已對此投票投過票: " + currentUser.getUsername() + ", 投票ID: " + pollId);
                    return "redirect:/poll/" + pollId + "?error=alreadyVoted";
                }
                
            } catch (Exception e) {
                // 安全檢查方法失敗，但不阻止用戶投票
                System.err.println("安全投票檢查失敗: " + e.getMessage());
                System.err.println("嘗試使用備用檢查方法");
                
                // 嘗試使用標準的檢查方法做第二次驗證
                try {
                    boolean hasVotedBackup = pollService.hasUserVotedInPoll(currentUser.getUsername(), pollId);
                    if (hasVotedBackup) {
                        System.out.println("備用檢查: 用戶已對此投票投過票");
                        return "redirect:/poll/" + pollId + "?error=alreadyVoted";
                    } else {
                        System.out.println("備用檢查: 用戶尚未對此投票投票，允許繼續");
                    }
                } catch (Exception ex) {
                    System.err.println("備用檢查也失敗，假設用戶未投票，允許繼續: " + ex.getMessage());
                }
            }

            try {
                // 獲取投票實體
                Poll poll = pollService.getPollById(pollId);
                if (poll == null || optionIndex < 0 || optionIndex >= poll.getOptions().size()) {
                    return "redirect:/poll/" + pollId + "?error=invalidOption";
                }
                
                // 獲取選項ID
                Long optionId = poll.getOptions().get(optionIndex).getId();
                System.out.println("嘗試為用戶投票: " + currentUser.getUsername() + ", 選項ID: " + optionId);
                
                // 不需要重試邏輯，直接執行投票操作
                pollService.vote(currentUser.getUsername(), optionId);
                System.out.println("投票成功: " + currentUser.getUsername() + ", 投票ID: " + pollId);
                
                // 重導向以避免重複提交
                return "redirect:/poll/" + pollId + "?success=true";
                
            } catch (IllegalStateException ise) {
                System.err.println("投票失敗 (已投票): " + ise.getMessage());
                return "redirect:/poll/" + pollId + "?error=alreadyVoted";
            } catch (Exception e) {
                System.err.println("處理投票請求時發生錯誤: " + e.getClass().getName() + " - " + e.getMessage());
                e.printStackTrace();
                return "redirect:/poll/" + pollId + "?error=processingError";
            }
        }
        
        return "redirect:/poll/" + pollId;
    }

    @GetMapping("/add")
    public String addPollForm(HttpSession session, Model model) {
        if (session.getAttribute("currentUser") == null) {
            return "redirect:/user/login";
        }
        model.addAttribute("poll", new Poll());
        model.addAttribute("pageTitle", "Create New Poll");
        model.addAttribute("contentPage", "poll/add.jsp");
        return "layout";
    }

    @PostMapping("/add")
    public String addPollSubmit(
            @RequestParam String question,
            @RequestParam String[] optionTexts,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            Poll poll = new Poll();
            poll.setQuestion(question);

            List<PollOption> options = new ArrayList<>();
            for (String text : optionTexts) {
                PollOption option = new PollOption();
                option.setText(text);
                option.setPoll(poll);
                options.add(option);
            }
            poll.setOptions(options);
            pollService.addPoll(poll);
        }
        return "redirect:/";
    }

    @PostMapping("/delete/{id}")
    public String deletePoll(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            pollService.deletePoll(id);
        }
        return "redirect:/";
    }

    // 獲取所有投票列表
    @GetMapping("/list")
    public String listPolls(Model model) {
        model.addAttribute("polls", pollService.getAllPolls());
        model.addAttribute("pageTitle", "所有投票");
        model.addAttribute("contentPage", "poll/list.jsp");
        return "layout";
    }
}