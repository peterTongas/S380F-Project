package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.service.CourseService;
import com.example.s380fproject_3103_2.service.PollService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    @Autowired
    private CourseService courseService;
    @Autowired
    private PollService pollService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("courses", courseService.getAllCourses());
        model.addAttribute("polls", pollService.getAllPolls());
        return "index";
    }
}
