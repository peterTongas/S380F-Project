package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.CommentService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class UserCommentHistoryController {

    @Autowired
    private CommentService commentService;

    @GetMapping("/user/comment-history")
    public String showCommentHistory(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        model.addAttribute("comments", commentService.getUserComments(currentUser.getUsername()));
        model.addAttribute("pageTitle", "My Comment History");
        model.addAttribute("contentPage", "user/comment_history.jsp");
        return "layout";
    }
}