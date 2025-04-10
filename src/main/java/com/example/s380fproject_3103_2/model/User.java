package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

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

    @ManyToMany(mappedBy = "votes", fetch = FetchType.EAGER)
    private Set<PollOption> votedOptions = new HashSet<>();

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public UserRole getRole() {
        return role;
    }

    public void setRole(UserRole role) {
        this.role = role;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }

    public Set<PollOption> getVotedOptions() {
        return votedOptions;
    }

    public void setVotedOptions(Set<PollOption> votedOptions) {
        this.votedOptions = votedOptions;
    }
}