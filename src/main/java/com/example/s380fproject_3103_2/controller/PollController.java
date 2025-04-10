package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.PollOption;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.model.UserRole;
import com.example.s380fproject_3103_2.service.PollService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

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
    public String addPollSubmit(
            @RequestParam String question,
            @RequestParam String[] optionTexts,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            Poll poll = new Poll();
            poll.setQuestion(question);

            List<PollOption> options = new ArrayList<>();
            for (String text : optionTexts) {
                PollOption option = new PollOption();
                option.setText(text);
                option.setPoll(poll);
                options.add(option);
            }
            poll.setOptions(options);
            pollService.addPoll(poll);
        }
        return "redirect:/";
    }

    @PostMapping("/delete/{id}")
    public String deletePoll(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            pollService.deletePoll(id);
        }
        return "redirect:/";
    }
}