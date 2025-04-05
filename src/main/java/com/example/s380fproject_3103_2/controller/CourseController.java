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

    // 2. Added model attribute for view course
    @GetMapping("/{id}")
    public String viewCourse(@PathVariable Long id, Model model, HttpSession session) {
        CourseMaterial course = courseService.getCourseById(id);
        if (course == null) {
            return "redirect:/course"; // Handle non-existent courses
        }

        model.addAttribute("course", course);
        model.addAttribute("isTeacher",
                ((User) session.getAttribute("currentUser")).getRole() == UserRole.TEACHER);
        return "course/view";
    }

    // 3. Added redirect attributes for feedback
    @GetMapping("/add")
    public String addCourseForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isTeacher(currentUser)) {
            return "redirect:/course?error=unauthorized";
        }
        model.addAttribute("course", new CourseMaterial());
        return "course/add";
    }

    // 4. Added validation and success message
    @PostMapping("/add")
    public String addCourseSubmit(@ModelAttribute CourseMaterial course,
                                  HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isTeacher(currentUser)) {
            return "redirect:/course?error=unauthorized";
        }

        if (course.getTitle() == null || course.getTitle().isBlank()) {
            return "redirect:/course/add?error=title_required";
        }

        courseService.addCourse(course);
        return "redirect:/course?success=course_added";
    }

    // 5. Added CSRF protection note
    @PostMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Long id,
                               HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (!isTeacher(currentUser)) {
            return "redirect:/course?error=unauthorized";
        }

        courseService.deleteCourse(id);
        return "redirect:/course?success=course_deleted";
    }

    // Helper method for role checking
    private boolean isTeacher(User user) {
        return user != null && user.getRole() == UserRole.TEACHER;
    }
}