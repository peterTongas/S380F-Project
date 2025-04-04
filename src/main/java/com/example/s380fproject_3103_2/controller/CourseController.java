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

    // View Course Details
    @GetMapping("/{id}")
    public String viewCourse(@PathVariable Long id, Model model) {
        model.addAttribute("course", courseService.getCourseById(id));
        return "course/view";
    }

    // Teacher: Add Course Form
    @GetMapping("/add")
    public String addCourseForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER)
            return "redirect:/";
        model.addAttribute("course", new CourseMaterial());
        return "course/add";
    }

    // Teacher: Submit New Course
    @PostMapping("/add")
    public String addCourseSubmit(@ModelAttribute CourseMaterial course, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            courseService.addCourse(course);
        }
        return "redirect:/";
    }

    // Teacher: Delete Course
    @PostMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            courseService.deleteCourse(id);
        }
        return "redirect:/";
    }
}
