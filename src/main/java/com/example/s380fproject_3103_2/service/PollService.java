package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.PollOption;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.repository.PollRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Map;

@Service
public class PollService {
    @Autowired
    private PollRepository pollRepository;

    public List<Poll> getAllPolls() {
        return pollRepository.findAll();
    }

    public Poll getPollById(Long id) {
        return pollRepository.findPollWithOptions(id);
    }

    @Transactional
    public boolean hasUserVotedForPoll(String username, Long pollId) {
        return pollRepository.hasUserVotedForPoll(username, pollId);
    }

    @Transactional
    public void voteForOption(Long pollId, int optionIndex, User user) {
        // 檢查使用者是否已經投過票
        if (user == null || hasUserVotedForPoll(user.getUsername(), pollId)) {
            return; // 已投過票或未登入，不允許投票
        }

        Poll poll = pollRepository.findPollWithOptions(pollId);
        if (poll != null && optionIndex >= 0 && optionIndex < poll.getOptions().size()) {
            PollOption option = poll.getOptions().get(optionIndex);
            option.setVoteCount(option.getVoteCount() + 1);
            option.getVotes().add(user); // 記錄用戶投票
            pollRepository.save(poll);
        }
    }

    public Poll addPoll(Poll poll) {
        // Set bi-directional relationship
        poll.getOptions().forEach(option -> option.setPoll(poll));
        return pollRepository.save(poll);
    }

    public void deletePoll(Long id) {
        pollRepository.deleteById(id);
    }

    public List<Map<String, Object>> getVoteHistory(String username) {
        return pollRepository.findVoteHistoryByUsername(username);
    }
}