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

    public List<CourseMaterial> getAllCourses() {
        return courseMaterialRepository.findAll();
    }

    public CourseMaterial getCourseById(Long id) {
        return courseMaterialRepository.findById(id).orElse(null);
    }

    public CourseMaterial addCourse(String title, String filePath) {
        CourseMaterial course = new CourseMaterial();
        course.setTitle(title);
        course.setFilePath(filePath);
        return courseMaterialRepository.save(course);
    }
    public CourseMaterial updateCourse(CourseMaterial course) {
        return courseMaterialRepository.save(course);
    }

    public void deleteCourse(Long id) {
        courseMaterialRepository.deleteById(id);
    }

}