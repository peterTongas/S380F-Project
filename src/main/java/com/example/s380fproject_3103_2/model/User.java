package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Entity
@Table(name = "APP_USERS")
@Data
@ToString(exclude = {"comments", "votedOptions"})
@EqualsAndHashCode(exclude = {"comments", "votedOptions"})
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

    @ManyToMany(mappedBy = "votes")
    private Set<PollOption> votedOptions = new HashSet<>();
}