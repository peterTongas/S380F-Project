package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.repository.CourseMaterialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CourseService {
    @Autowired
    private CourseMaterialRepository courseMaterialRepository;

    // Get all course materials (for index page)
    public List<CourseMaterial> getAllCourses() {
        return courseMaterialRepository.findAll();
    }

    // Get a specific course by ID
    public CourseMaterial getCourseById(Long id) {
        return courseMaterialRepository.findById(id).orElse(null);
    }

    // Teacher-only: Add new course material
    public CourseMaterial addCourse(CourseMaterial course) {
        return courseMaterialRepository.save(course);
    }

    // Teacher-only: Delete course material
    public void deleteCourse(Long id) {
        courseMaterialRepository.deleteById(id);
    }
}