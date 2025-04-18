package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    // Registration Form
    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        model.addAttribute("contentPage", "user/register.jsp");
        return "layout";
    }

    // Process Registration
    @PostMapping("/register")
    public String processRegistration(@ModelAttribute User user) {
        userService.registerUser(user);
        return "redirect:/user/login";
    }

    // Login Form
    @GetMapping("/login")
    public String showLoginForm(Model model) {
        model.addAttribute("pageTitle", "使用者登入");
        model.addAttribute("contentPage", "user/login.jsp");
        return "layout";
    }

    // 注意：移除了原本的 @PostMapping("/login") 處理方法
    // 現在完全由 Spring Security 處理登入

    // Profile Page
    @GetMapping("/profile")
    public String showProfile(Model model) {
        // 使用 Spring Security 獲取當前用戶
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return "redirect:/user/login";
        }
        
        User currentUser = userService.getUserByUsername(authentication.getName());
        if (currentUser == null) return "redirect:/user/login";

        model.addAttribute("user", currentUser);
        model.addAttribute("contentPage", "user/profile.jsp");
        return "layout";
    }

    // Update Profile
    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute User updatedUser) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            userService.updateUserProfile(authentication.getName(), updatedUser);
        }
        return "redirect:/user/profile";
    }
}
