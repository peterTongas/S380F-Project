package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Table(name = "COURSE_MATERIALS")
@Data
public class CourseMaterial {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String title;
    private String filePath; // Store lecture note file path

    @OneToMany(mappedBy = "courseMaterial")
    private List<Comment> comments;
}