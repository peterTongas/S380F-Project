package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.service.PollService;
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

    @GetMapping("/{id}")
    public String viewPoll(@PathVariable Long id, Model model) {
        model.addAttribute("poll", pollService.getPollById(id));
        model.addAttribute("pageTitle", "Poll Details");
        model.addAttribute("contentPage", "poll/view.jsp");
        return "layout";
    }

    @PostMapping("/vote/{pollId}")
    public String vote(@PathVariable Long pollId, @RequestParam int optionIndex) {
        pollService.voteForOption(pollId, optionIndex);
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
    public String addPollSubmit(@ModelAttribute Poll poll, HttpSession session) {
        if (session.getAttribute("currentUser") != null) {
            pollService.addPoll(poll);
        }
        return "redirect:/";
    }

    @PostMapping("/delete/{id}")
    public String deletePoll(@PathVariable Long id, HttpSession session) {
        if (session.getAttribute("currentUser") != null) {
            pollService.deletePoll(id);
        }
        return "redirect:/";
    }
}