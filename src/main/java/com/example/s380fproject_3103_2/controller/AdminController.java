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

    @Autowired
    private UserService userService;

    @GetMapping
    public String dashboard(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER) {
            return "redirect:/";
        }
        model.addAttribute("users", userService.getAllUsers());
        model.addAttribute("pageTitle", "Admin Dashboard");
        model.addAttribute("contentPage", "admin/dashboard.jsp");
        return "layout";
    }

    @GetMapping("/edit/{username}")
    public String editForm(@PathVariable String username, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER) {
            return "redirect:/";
        }
        model.addAttribute("user", userService.getUserByUsername(username));
        model.addAttribute("pageTitle", "Edit User");
        model.addAttribute("contentPage", "admin/edit-user.jsp");
        return "layout";
    }

    @PostMapping("/update")
    public String updateUser(@ModelAttribute User updatedUser, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            userService.updateUser(updatedUser);
        }
        return "redirect:/admin";
    }

}