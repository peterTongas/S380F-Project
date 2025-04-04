package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User, String> {
}