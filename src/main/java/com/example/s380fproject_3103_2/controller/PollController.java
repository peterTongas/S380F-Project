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
                       @RequestParam(name = "changeVote", required = false) Boolean changeVote,
                       @RequestParam(name = "previousVoteOptionId", required = false) Long previousVoteOptionId,
                       HttpSession session,
                       Model model) {
        Poll poll = pollService.getPollById(id);
        
        System.out.println("Debug - viewPoll: id=" + id + ", changeVote=" + changeVote + ", previousVoteOptionId=" + previousVoteOptionId);
        
        // 確保重置投票狀態，避免多人共用
        if (poll != null) {
            poll.setUserVotedOptionId(null);
            poll.setAccessible(true);
            
            // If user is changing their vote, set the previousVoteOptionId as their userVotedOptionId
            // to preselect their previous choice, and override hasVoted to allow voting again
            if (changeVote != null && changeVote && previousVoteOptionId != null) {
                poll.setUserVotedOptionId(previousVoteOptionId);
                // Set special flag to indicate we're in change vote mode
                model.addAttribute("changeVoteMode", true);
                // Override the hasVoted flag since we're showing the voting form
                model.addAttribute("hasVoted", false);
                System.out.println("Debug - Change Vote Mode Enabled: changeVoteMode=true, previousVoteOptionId=" + previousVoteOptionId);
            }
        }
        
        model.addAttribute("poll", poll);
        
        // Add confirmation message for the delete poll dialog
        model.addAttribute("confirmDeletePoll", "確定要刪除此投票嗎？");
        
        // 如果有錯誤參數，添加錯誤消息
        if ("noSelection".equals(error)) {
            model.addAttribute("errorMessage", "請選擇一個選項後再提交投票");
        } else if ("alreadyVoted".equals(error)) {
            model.addAttribute("errorMessage", "您已經對此投票問題投過票了");
        } else if ("invalidOptionText".equals(error)) {
            model.addAttribute("errorMessage", "無法選擇含有「選項」文字的選項");
        } else if ("processingError".equals(error)) {
            model.addAttribute("errorMessage", "處理投票時發生錯誤，請稍後再試");
        } else if ("invalidOption".equals(error)) {
            model.addAttribute("errorMessage", "選擇的選項無效");
        }
        
        // 檢查當前用戶是否已對該問題投票
        User currentUser = (User) session.getAttribute("currentUser");
        boolean hasVoted = false;
        
        if (currentUser != null && poll != null) {
            try {
                // 確保我們正確檢查用戶是否對此特定投票投過票
                hasVoted = pollService.hasUserVotedInPollSafe(currentUser.getUsername(), id);
                
                // 如果用戶已投票，查詢他們投票的選項ID
                if (hasVoted && !Boolean.TRUE.equals(changeVote)) {
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
                try {
                    hasVoted = pollService.hasUserVotedInPollSafe(currentUser.getUsername(), id);
                } catch (Exception e) {
                    System.err.println("檢查投票狀態時發生錯誤: " + e.getMessage() + ", 類型: " + e.getClass().getName());
                    e.printStackTrace(); // 添加完整堆疊追蹤以幫助調試
                    // 採取保守策略，查詢數據庫確認
                    hasVoted = false;
                }
            } catch (Exception e) {
                // 處理其他例外，避免應用程序崩潰
                System.err.println("檢查投票狀態時發生錯誤: " + e.getMessage());
                e.printStackTrace();
                hasVoted = false;
            }
            
            // Skip setting hasVoted if we're in changeVote mode (already set above)
            if (!Boolean.TRUE.equals(changeVote)) {
                model.addAttribute("hasVoted", hasVoted);
            }
        } else {
            // 未登入用戶默認未投票
            model.addAttribute("hasVoted", false);
        }
        
        model.addAttribute("pageTitle", "Poll Details");
        model.addAttribute("contentPage", "poll/view.jsp");
        return "layout";
    }

    @GetMapping("/change-vote/{pollId}")
    public String changeVoteForm(@PathVariable Long pollId,
                           @RequestParam(name = "previousVoteOptionId", required = false) Long previousVoteOptionId,
                           HttpSession session,
                           Model model) {
        // Check if user is logged in
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/user/login?redirect=/poll/" + pollId;
        }
        
        // Get the poll
        Poll poll = pollService.getPollById(pollId);
        if (poll == null) {
            return "redirect:/";
        }
        
        // Check if user has actually voted for this poll
        boolean hasVoted = pollService.hasUserVotedInPollSafe(currentUser.getUsername(), pollId);
        if (!hasVoted) {
            return "redirect:/poll/" + pollId + "?error=notVoted";
        }
        
        // If previousVoteOptionId is not provided, try to look it up
        if (previousVoteOptionId == null) {
            previousVoteOptionId = pollService.findVotedOptionId(currentUser.getUsername(), pollId);
        }
        
        // Set the previously voted option ID for pre-selection
        poll.setUserVotedOptionId(previousVoteOptionId);
        model.addAttribute("poll", poll);
        model.addAttribute("changeVoteMode", true);
        
        // Set page title and content
        model.addAttribute("pageTitle", "變更投票 - " + poll.getQuestion());
        model.addAttribute("contentPage", "poll/change_vote.jsp");
        return "layout";
    }

    @PostMapping("/vote/{pollId}")
    public String vote(@PathVariable Long pollId, 
                       @RequestParam(required = false) Integer optionIndex, 
                       @RequestParam(required = false) Boolean changeVote,
                       @RequestParam(required = false) Long previousVoteOptionId,
                       HttpSession session,
                       Model model) {
        // 檢查是否選擇了選項
        if (optionIndex == null && (changeVote != null && changeVote)) {
            // If this is a change vote request, redirect to the poll page with the previously selected option
            return "redirect:/poll/" + pollId + "?changeVote=true&previousVoteOptionId=" + previousVoteOptionId;
        } else if (optionIndex == null) {
            return "redirect:/poll/" + pollId + "?error=noSelection";
        }
        
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            // 先記錄當前用戶和投票信息，便於診斷
            System.out.println("用戶 " + currentUser.getUsername() + " 正在嘗試投票，投票ID: " + pollId + ", 選項索引: " + optionIndex + ", 變更投票: " + changeVote);
            
            try {
                // 獲取投票實體以進行檢查
                Poll poll = pollService.getPollById(pollId);
                if (poll == null || optionIndex < 0 || optionIndex >= poll.getOptions().size()) {
                    return "redirect:/poll/" + pollId + "?error=invalidOption";
                }
                
                // 取得選項供後續使用
                PollOption option = poll.getOptions().get(optionIndex);
            } catch (Exception e) {
                System.err.println("檢查選項時發生錯誤: " + e.getMessage());
                return "redirect:/poll/" + pollId + "?error=processingError";
            }
            
            // 檢查是否為更改投票的請求
            if (changeVote == null || !changeVote) {
                // 非變更投票的請求需要先檢查用戶是否已投票
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
            } else {
                // 如果是變更投票，則需要先刪除之前的投票
                System.out.println("用戶要求變更投票: " + currentUser.getUsername() + ", 投票ID: " + pollId);
                try {
                    // 刪除現有投票
                    pollService.deleteUserVote(currentUser.getUsername(), pollId);
                    System.out.println("成功刪除用戶先前的投票");
                } catch (Exception e) {
                    System.err.println("刪除用戶先前投票時出錯: " + e.getMessage());
                    e.printStackTrace();
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