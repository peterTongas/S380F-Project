package com.example.s380fproject_3103_2.service;


import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.repository.CourseMaterialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CourseService {
    @Autowired
    private CourseMaterialRepository repository;

    public List<CourseMaterial> getAllCourses() {
        return repository.findAll();
    }

    public CourseMaterial getCourseById(Long id) {
        return repository.findWithID(id);
    }

    public CourseMaterial saveCourse(CourseMaterial course) {
        return repository.save(course);
    }

    public void deleteCourse(Long id) {
        repository.deleteById(id);
    }
    
}