package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.CourseService;
import com.example.s380fproject_3103_2.model.UserRole;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseService courseService;

    // 1. Fixed endpoint consistency
    @GetMapping("")  // Changed from "/courses" to "" to match base /course mapping
    public String showCourses(Model model) {
        model.addAttribute("courses", courseService.getAllCourses()); // Added data
        return "course/list"; // Changed to direct view (not using layout.jsp injection)
    }

    @GetMapping("/{id}")
    public String viewCourse(@PathVariable Long id, Model model, HttpSession session) {
        model.addAttribute("course", courseService.getCourseById(id));
        model.addAttribute("contentPage", "course/view.jsp");
        model.addAttribute("pageTitle", "Course Details");
        return "layout";
    }

    @GetMapping("/add")
    public String showAddForm(Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || !currentUser.getRole().equals("TEACHER")) {
            return "redirect:/";
        }

        model.addAttribute("course", new CourseMaterial());
        model.addAttribute("contentPage", "course/add.jsp");
        model.addAttribute("pageTitle", "Add New Course");
        return "layout";
    }

    @PostMapping("/add")
    public String addCourse(@ModelAttribute CourseMaterial course, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole().equals("TEACHER")) {
            courseService.saveCourse(course);
        }
        return "redirect:/";
    }

    @PostMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole().equals("TEACHER")) {
            courseService.deleteCourse(id);
        }
        return "redirect:/";
    }

    // Helper method for role checking
    private boolean isTeacher(User user) {
        return user != null && user.getRole() == UserRole.TEACHER;
    }
}