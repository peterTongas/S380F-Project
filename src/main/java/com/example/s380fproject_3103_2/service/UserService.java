package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.model.UserRole;
import com.example.s380fproject_3103_2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    // Register a new user (default role: STUDENT)
    public User registerUser(User user) {
        user.setRole(UserRole.STUDENT); // Default role
        return userRepository.save(user);
    }

    // Login (temporary, replace with Spring Security later)
    public User login(String username, String password) {
        Optional<User> user = userRepository.findById(username);
        return user.filter(u -> u.getPassword().equals(password)).orElse(null);
    }

    // Update student profile (username cannot be changed)
    public User updateStudentProfile(String username, User updatedUser) {
        return userRepository.findById(username)
                .map(user -> {
                    if (user.getRole() == UserRole.STUDENT) {
                        user.setFullName(updatedUser.getFullName());
                        user.setEmail(updatedUser.getEmail());
                        user.setPhone(updatedUser.getPhone());
                        return userRepository.save(user);
                    }
                    return null; // Only students can update profiles
                })
                .orElse(null);
    }

    // Teacher-only: Get all users
    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public User updateUser(User updatedUser) {
        return userRepository.findById(updatedUser.getUsername())
                .map(existingUser -> {
                    // Preserve the original password if not changed
                    if (updatedUser.getPassword() == null || updatedUser.getPassword().isEmpty()) {
                        updatedUser.setPassword(existingUser.getPassword());
                    }
                    return userRepository.save(updatedUser);
                })
                .orElse(null);
    }

}
