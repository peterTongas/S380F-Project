package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "COURSE_MATERIALS")
@Data
public class CourseMaterial {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;
    private String description;
    private String filePath; // Keep for backward compatibility

    @OneToMany(mappedBy = "courseMaterial", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CourseFile> files = new ArrayList<>();

    @OneToMany(mappedBy = "courseMaterial", cascade = CascadeType.ALL)
    private List<Comment> comments;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public List<CourseFile> getFiles() {
        return files;
    }

    public void setFiles(List<CourseFile> files) {
        this.files = files;
    }

    public List<Comment> getComments() {
        return comments;
    }

    public void setComments(List<Comment> comments) {
        this.comments = comments;
    }
    
    public void addFile(CourseFile file) {
        files.add(file);
        file.setCourseMaterial(this);
    }
    
    public void removeFile(CourseFile file) {
        files.remove(file);
        file.setCourseMaterial(null);
    }
}