package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.model.UserRole;
import com.example.s380fproject_3103_2.repository.UserRepository;
import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.transaction.Transactional;
import java.util.List;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    public User registerUser(User user) {
        user.setRole(UserRole.STUDENT); // Default role
        return userRepository.save(user);
    }

    public User login(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }

    public User updateUserProfile(String username, User updatedUser) {
        return userRepository.findById(username).map(user -> {
            user.setFullName(updatedUser.getFullName());
            user.setEmail(updatedUser.getEmail());
            user.setPhone(updatedUser.getPhone());
            // Password update would be handled separately
            return userRepository.save(user);
        }).orElse(null);
    }

    public User getUserByUsername(String username) {
        return userRepository.findById(username).orElse(null);
    }

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

    @Transactional
    public User getUserWithVotedOptions(Long userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user != null) {
            // 強制初始化集合
            Hibernate.initialize(user.getVotedOptions());
        }
        return user;
    }
}