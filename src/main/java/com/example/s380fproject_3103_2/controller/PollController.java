package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.PollService;
import com.example.s380fproject_3103_2.model.UserRole;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/poll")
public class PollController {
    @Autowired
    private PollService pollService;

    // View Poll
    @GetMapping("/{id}")
    public String viewPoll(@PathVariable Long id, Model model) {
        model.addAttribute("poll", pollService.getPollById(id));
        return "poll/view";
    }

    // Submit Vote
    @PostMapping("/vote/{pollId}")
    public String vote(@PathVariable Long pollId, @RequestParam int optionIndex) {
        pollService.voteForOption(pollId, optionIndex);
        return "redirect:/poll/" + pollId;
    }

    // Teacher: Add Poll Form
    @GetMapping("/add")
    public String addPollForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER)
            return "redirect:/";
        model.addAttribute("poll", new Poll());
        return "poll/add";
    }

    // Teacher: Submit New Poll
    @PostMapping("/add")
    public String addPollSubmit(@ModelAttribute Poll poll, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            pollService.addPoll(poll);
        }
        return "redirect:/";
    }

    // Teacher: Delete Poll
    @PostMapping("/delete/{id}")
    public String deletePoll(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            pollService.deletePoll(id);
        }
        return "redirect:/";
    }
}