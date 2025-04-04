package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "COMMENTS")
@Data
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String content;

    @ManyToOne
    private User user;

    @ManyToOne
    private CourseMaterial courseMaterial;

    @ManyToOne
    private Poll poll;
}