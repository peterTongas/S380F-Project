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
        model.addAttribute("contentPage", "user/login.jsp");
        return "layout";
    }

    // Process Login
    @PostMapping("/login")
    public String processLogin(@RequestParam String username,
                               @RequestParam String password,
                               HttpSession session) {
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
        return "redirect:/";
    }

    // Profile Page
    @GetMapping("/profile")
    public String showProfile(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null) return "redirect:/user/login";

        model.addAttribute("user", currentUser);
        model.addAttribute("contentPage", "user/profile.jsp");
        return "layout";
    }

    // Update Profile
    @PostMapping("/profile")
    public String updateProfile(@ModelAttribute User updatedUser,
                                HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null) {
            userService.updateUserProfile(currentUser.getUsername(), updatedUser);
            session.setAttribute("currentUser",
                    userService.getUserByUsername(currentUser.getUsername()));
        }
        return "redirect:/user/profile";
    }
}
