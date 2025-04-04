package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.UserService;
import com.example.s380fproject_3103_2.model.UserRole;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private final UserService userService;

    public AdminController(UserService userService) {
        this.userService = userService;
    }

    // Teacher Dashboard
    @GetMapping
    public String adminDashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER)
            return "redirect:/";

        model.addAttribute("users", userService.getAllUsers());
        return "admin/dashboard";
    }

    // Edit User Form
    @GetMapping("/edit/{username}")
    public String editUserForm(@PathVariable String username, Model model, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER)
            return "redirect:/";

        model.addAttribute("user", userService.getAllUsers().stream()
                .filter(u -> u.getUsername().equals(username))
                .findFirst().orElse(null));
        return "admin/edit-user";
    }

    // Update User
    @PostMapping("/update")
    public String updateUser(@ModelAttribute User user, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            userService.updateUser(user); // Add this method to UserService
        }
        return "redirect:/admin";
    }
}