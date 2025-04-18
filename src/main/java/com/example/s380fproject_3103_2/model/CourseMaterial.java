package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "COURSE_MATERIALS")
@Data
@ToString(exclude = {"courseFiles", "comments"})
@EqualsAndHashCode(exclude = {"courseFiles", "comments"})
public class CourseMaterial {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    private String description;
    private String filePath;
    
    @Column(name = "created_at")
    @CreationTimestamp
    private Date createdAt;

    @OneToMany(mappedBy = "courseMaterial", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseFile> courseFiles = new ArrayList<>();
    
    @OneToMany(mappedBy = "courseMaterial", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Comment> comments;
}