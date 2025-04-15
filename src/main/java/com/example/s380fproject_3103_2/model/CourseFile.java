package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

@Entity
@Table(name = "COURSE_FILES")
@Data
@ToString(exclude = "courseMaterial")
@EqualsAndHashCode(exclude = "courseMaterial")
public class CourseFile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String fileName;
    private String filePath;
    private String fileType;
    private Long fileSize;
    
    @ManyToOne
    @JoinColumn(name = "course_material_id")
    private CourseMaterial courseMaterial;
}