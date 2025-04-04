package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Table(name = "APP_USERS")
@Data
public class User {
    @Id
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;

    @Enumerated(EnumType.STRING)
    private UserRole role; // STUDENT or TEACHER

    @OneToMany(mappedBy = "user")
    private List<Comment> comments;
}