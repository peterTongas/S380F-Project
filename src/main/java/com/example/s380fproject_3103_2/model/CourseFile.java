package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "COURSE_FILES")
@Data
public class CourseFile {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String fileName; // Original file name
    private String filePath; // Stored file path
    private String fileType; // MIME type
    
    @ManyToOne
    @JoinColumn(name = "course_material_id")
    private CourseMaterial courseMaterial;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public CourseMaterial getCourseMaterial() {
        return courseMaterial;
    }

    public void setCourseMaterial(CourseMaterial courseMaterial) {
        this.courseMaterial = courseMaterial;
    }
}
