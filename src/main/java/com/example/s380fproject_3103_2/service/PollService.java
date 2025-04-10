package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.PollOption;
import com.example.s380fproject_3103_2.repository.PollRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
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

    public void voteForOption(Long pollId, int optionIndex) {
        Poll poll = pollRepository.findPollWithOptions(pollId);
        if (poll != null && optionIndex >= 0 && optionIndex < poll.getOptions().size()) {
            PollOption option = poll.getOptions().get(optionIndex);
            option.setVoteCount(option.getVoteCount() + 1);
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

//    // For recording votes
//    public void recordVote(String username, Long optionId) {
//        pollOptionRepository.findById(optionId).ifPresent(option -> {
//            User user = userRepository.findById(username).orElseThrow();
//            option.getVotes().add(user);
//            option.setVoteCount(option.getVoteCount() + 1);
//            pollOptionRepository.save(option);
//        });
//    }
}