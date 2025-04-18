package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.PollService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserVoteHistoryController {

    @Autowired
    private PollService pollService;

    @GetMapping("/user/vote-history")
    public String showVoteHistory(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        model.addAttribute("voteHistory", pollService.getVoteHistory(currentUser.getUsername()));
        model.addAttribute("pageTitle", "myVoteHistory");  // Use translation key instead of hardcoded string
        model.addAttribute("contentPage", "user/vote_history.jsp");
        return "layout";
    }
}