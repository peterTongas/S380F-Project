package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
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
    public String registerForm(Model model) {
        model.addAttribute("user", new User());
        return "user/register";
    }

    // Submit Registration
    @PostMapping("/register")
    public String registerSubmit(@ModelAttribute User user) {
        userService.registerUser(user);
        return "redirect:/user/login";
    }

    // Login Form
    @GetMapping("/login")
    public String loginForm() {
        return "user/login";
    }

    // Submit Login
    @PostMapping("/login")
    public String loginSubmit(String username, String password, HttpSession session) {
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("currentUser", user);
            return "redirect:/";
        }
        return "redirect:/user/login?error";
    }

    // Logout
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/?logout=true";
    }

    // Student Profile Edit Form
    @GetMapping("/profile")
    public String profileForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) return "redirect:/user/login";
        model.addAttribute("user", currentUser);
        return "user/profile";
    }

    // Submit Profile Updates
    @PostMapping("/profile")
    public String profileUpdate(@ModelAttribute User updatedUser, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            userService.updateStudentProfile(currentUser.getUsername(), updatedUser);
            session.setAttribute("currentUser",
                    userService.login(currentUser.getUsername(), currentUser.getPassword()));
        }
        return "redirect:/user/profile";
    }
}
