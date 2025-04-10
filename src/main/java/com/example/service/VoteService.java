package com.example.service;

import org.springframework.stereotype.Service;
import jakarta.transaction.Transactional;

@Service
public class VoteService {

    @Transactional
    public void processVote(Long userId, Long optionId) {
        // ...existing code...
    }

    // 其他需要訪問 votedOptions 的方法也添加 @Transactional

}