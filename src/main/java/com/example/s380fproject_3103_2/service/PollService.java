package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.PollOption;
import com.example.s380fproject_3103_2.repository.PollRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class PollService {
    @Autowired
    private PollRepository pollRepository;

    // Get all polls (for index page)
    public List<Poll> getAllPolls() {
        return pollRepository.findAll();
    }

    // Get a specific poll by ID
    public Poll getPollById(Long id) {
        return pollRepository.findById(id).orElse(null);
    }

    // Vote for a poll option
    public void voteForOption(Long pollId, int optionIndex) {
        Poll poll = pollRepository.findById(pollId).orElse(null);
        if (poll != null && optionIndex >= 0 && optionIndex < poll.getOptions().size()) {
            PollOption option = poll.getOptions().get(optionIndex);
            option.setVoteCount(option.getVoteCount() + 1);
            pollRepository.save(poll);
        }
    }

    // Teacher-only: Add new poll
    public Poll addPoll(Poll poll) {
        return pollRepository.save(poll);
    }

    // Teacher-only: Delete poll
    public void deletePoll(Long id) {
        pollRepository.deleteById(id);
    }
}
