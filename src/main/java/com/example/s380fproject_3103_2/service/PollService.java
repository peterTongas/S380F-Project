package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.PollOption;
import com.example.s380fproject_3103_2.repository.PollRepository;
import com.example.s380fproject_3103_2.repository.PollOptionRepository;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Map;

@Service
public class PollService {
    @Autowired
    private PollRepository pollRepository;

    @Autowired
    private PollOptionRepository pollOptionRepository;

    @Autowired
    private UserRepository userRepository;

    // 獲取當前登入用戶名稱
    private String getCurrentUsername() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return null;
        }
        return authentication.getName();
    }

    public List<Poll> getAllPolls() {
        return pollRepository.findAll();
    }

    public Poll getPollById(Long id) {
        return pollRepository.findPollWithOptions(id);
    }

    @PreAuthorize("hasAnyRole('STUDENT', 'TEACHER')")
    public void voteForOption(Long pollId, int optionIndex) {
        Poll poll = pollRepository.findPollWithOptions(pollId);
        if (poll != null && optionIndex >= 0 && optionIndex < poll.getOptions().size()) {
            PollOption option = poll.getOptions().get(optionIndex);
            option.setVoteCount(option.getVoteCount() + 1);
            pollRepository.save(poll);
        }
    }

    @PreAuthorize("hasRole('TEACHER')")
    public Poll addPoll(Poll poll) {
        // Set bi-directional relationship
        poll.getOptions().forEach(option -> option.setPoll(poll));
        return pollRepository.save(poll);
    }

    @PreAuthorize("hasRole('TEACHER')")
    public void deletePoll(Long id) {
        pollRepository.deleteById(id);
    }

    public List<Map<String, Object>> getVoteHistory(String username) {
        return pollRepository.findVoteHistoryByUsername(username);
    }
    
    // 獲取當前登入用戶的投票記錄
    public List<Map<String, Object>> getCurrentUserVoteHistory() {
        String username = getCurrentUsername();
        if (username == null) {
            return List.of();
        }
        return getVoteHistory(username);
    }

    /**
     * 檢查用戶是否已經對特定投票問題投過票
     */
    public boolean hasUserVotedInPoll(String username, Long pollId) {
        Poll poll = getPollById(pollId);
        User user = userRepository.findByUsername(username);
        
        if (poll == null || user == null) {
            return false;
        }
        
        // 檢查用戶是否在任何一個選項的投票列表中
        return poll.getOptions().stream()
                .anyMatch(option -> option.getVotes() != null && 
                        option.getVotes().contains(user));
    }
    
    // 檢查當前用戶是否已投票
    public boolean hasCurrentUserVotedInPoll(Long pollId) {
        String username = getCurrentUsername();
        if (username == null) {
            return false;
        }
        return hasUserVotedInPollSafe(username, pollId);
    }

    /**
     * 安全檢查用戶是否已經對特定投票問題投過票，避免並發修改異常
     */
    public boolean hasUserVotedInPollSafe(String username, Long pollId) {
        try {
            // 直接通過資料庫查詢，避免使用集合迭代
            return pollRepository.existsVoteByUsernameAndPollId(username, pollId);
        } catch (Exception e) {
            System.err.println("安全檢查投票狀態時發生錯誤: " + e.getMessage());
            // 如果無法確定，為保險起見假設用戶已經投票
            return true;
        }
    }

    /**
     * 使用事務確保投票操作的原子性
     * 修改為使用直接SQL操作，避免並發修改異常
     */
    @PreAuthorize("hasAnyRole('STUDENT', 'TEACHER')")
    @Transactional
    public void vote(String username, Long optionId) {
        try {
            // 獲取必要資訊
            PollOption option = pollOptionRepository.findById(optionId).orElseThrow();
            Poll poll = option.getPoll();
            
            // 檢查用戶是否已對此投票投過票
            if (hasUserVotedInPollSafe(username, poll.getId())) {
                System.err.println("用戶 " + username + " 已經對投票 #" + poll.getId() + " 投過票了");
                throw new IllegalStateException("用戶已經對此問題投過票");
            }
            
            // 打印投票前的狀態以進行診斷
            System.out.println("投票前 - 選項: " + option.getText() + ", 當前票數: " + option.getVoteCount() + ", 用戶: " + username);
            
            // 使用安全的SQL操作來處理投票
            int result = pollRepository.safeVoteAndIncrementCount(optionId, username, poll.getId());
            
            if (result <= 0) {
                throw new IllegalStateException("投票操作失敗，可能用戶已經投過票");
            }
            
            // 重新加載選項以獲取最新票數
            option = pollOptionRepository.findById(optionId).orElseThrow();
            
            // 打印投票後的狀態以進行診斷
            System.out.println("投票後 - 選項: " + option.getText() + ", 更新後票數: " + option.getVoteCount() + ", 用戶: " + username);
        } catch (IllegalStateException ise) {
            throw ise; // 直接重新拋出已定義的異常
        } catch (Exception e) {
            System.err.println("投票操作出現異常: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("處理投票時發生錯誤", e);
        }
    }
    
    // 提供一個使用Spring Security上下文進行投票的便利方法
    @PreAuthorize("hasAnyRole('STUDENT', 'TEACHER')")
    @Transactional
    public void voteWithAuthenticatedUser(Long optionId) {
        String username = getCurrentUsername();
        if (username == null) {
            throw new IllegalStateException("需要登入才能進行投票");
        }
        vote(username, optionId);
    }

    /**
     * 查詢用戶對特定投票的選項ID
     *
     * @param username 用戶名
     * @param pollId 投票ID
     * @return 用戶投票的選項ID，如果未投票則返回null
     */
    public Long findVotedOptionId(String username, Long pollId) {
        return pollRepository.findVotedOptionId(username, pollId);
    }
    
    // 查詢當前用戶的投票選項ID
    public Long findCurrentUserVotedOptionId(Long pollId) {
        String username = getCurrentUsername();
        if (username == null) {
            return null;
        }
        return findVotedOptionId(username, pollId);
    }

    /**
     * 刪除用戶的投票，用於更改投票功能
     *
     * @param username 用戶名稱
     * @param pollId 投票ID
     * @return 是否成功刪除投票
     */
    @PreAuthorize("hasAnyRole('STUDENT', 'TEACHER')")
    @Transactional
    public boolean deleteUserVote(String username, Long pollId) {
        try {
            // 檢查用戶是否確實對此投票有過投票
            if (!hasUserVotedInPollSafe(username, pollId)) {
                System.out.println("用戶 " + username + " 未對投票 #" + pollId + " 投過票，無需刪除");
                return false;
            }
            
            // 查找用戶投票的選項ID，以便更新票數
            Long votedOptionId = findVotedOptionId(username, pollId);
            if (votedOptionId == null) {
                System.err.println("找不到用戶 " + username + " 對投票 #" + pollId + " 的選項ID");
                return false;
            }
            
            // 獲取投票選項，以便更新計數
            PollOption option = pollOptionRepository.findById(votedOptionId).orElse(null);
            if (option == null) {
                System.err.println("找不到選項ID: " + votedOptionId);
                return false;
            }
            
            System.out.println("刪除投票 - 選項: " + option.getText() + ", 當前票數: " + option.getVoteCount() + ", 用戶: " + username);
            
            // 刪除用戶投票記錄並減少計數
            int result = pollRepository.deleteUserVoteAndDecrementCount(username, pollId, votedOptionId);
            
            System.out.println("刪除投票結果: " + result + " 筆記錄已更新");
            
            return result > 0;
        } catch (Exception e) {
            System.err.println("刪除用戶投票時發生錯誤: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // 刪除當前已認證用戶的投票
    @PreAuthorize("hasAnyRole('STUDENT', 'TEACHER')")
    @Transactional
    public boolean deleteCurrentUserVote(Long pollId) {
        String username = getCurrentUsername();
        if (username == null) {
            throw new IllegalStateException("需要登入才能刪除投票");
        }
        return deleteUserVote(username, pollId);
    }

    public long countAllPolls() {
        return pollRepository.count();
    }
}