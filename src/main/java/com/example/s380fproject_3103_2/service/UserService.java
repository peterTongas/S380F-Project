package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.model.UserRole;
import com.example.s380fproject_3103_2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public void registerUser(User user) {
        // 檢查用戶名是否已存在
        if (userRepository.findByUsername(user.getUsername()) != null) {
            throw new IllegalArgumentException("用戶名已存在");
        }

        // 加密密碼
        user.setPassword(passwordEncoder.encode(user.getPassword()));

        // 設定預設角色
        if (user.getRole() == null) {
            user.setRole(UserRole.STUDENT);
        }

        userRepository.save(user);
    }

    @Deprecated
    public User login(String username, String password) {
        // 此方法不應再被使用
        return null;
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
}