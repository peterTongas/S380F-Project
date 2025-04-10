package com.example.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class VoteService {

    @Transactional
    public void processVote(Long userId, Long optionId) {
        // 此方法內的所有操作都在同一事務中，
        // 因此訪問 user.getVotedOptions() 時會話仍然開啟
        // ...existing code...
    }

    // 其他需要訪問 votedOptions 的方法也添加 @Transactional

}