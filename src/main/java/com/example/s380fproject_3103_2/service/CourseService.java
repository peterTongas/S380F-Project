package com.example.s380fproject_3103_2.service;


import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.CourseFile;
import com.example.s380fproject_3103_2.repository.CourseFileRepository;
import com.example.s380fproject_3103_2.repository.CourseMaterialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
public class CourseService {
    @Autowired
    private CourseMaterialRepository courseMaterialRepository;
    
    @Autowired
    private CourseFileRepository courseFileRepository;
    
    @Autowired
    private FileStorageService fileStorageService;

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
    
    public CourseMaterial addCourseWithFiles(String title, String description, MultipartFile[] files) {
        CourseMaterial course = new CourseMaterial();
        course.setTitle(title);
        course.setDescription(description);
        
        // Store the first file path in the legacy field for backward compatibility
        if (files.length > 0 && !files[0].isEmpty()) {
            course.setFilePath(fileStorageService.storeFile(files[0]));
        }
        
        // Save the course first to get an ID
        course = courseMaterialRepository.save(course);
        
        // Process all files and create CourseFile entities
        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty()) {
                CourseFile courseFile = new CourseFile();
                courseFile.setFileName(file.getOriginalFilename());
                courseFile.setFileType(file.getContentType());
                courseFile.setFilePath(fileStorageService.storeFile(file));
                courseFile.setCourseMaterial(course);
                course.getFiles().add(courseFile);
            }
        }
        
        // Save again to persist the file associations
        return courseMaterialRepository.save(course);
    }
    
    public CourseMaterial updateCourse(CourseMaterial course) {
        return courseMaterialRepository.save(course);
    }
    
    public CourseMaterial updateCourseWithFiles(CourseMaterial course, MultipartFile[] files) {
        // Process new files if provided
        if (files != null) {
            for (MultipartFile file : files) {
                if (file != null && !file.isEmpty()) {
                    CourseFile courseFile = new CourseFile();
                    courseFile.setFileName(file.getOriginalFilename());
                    courseFile.setFileType(file.getContentType());
                    courseFile.setFilePath(fileStorageService.storeFile(file));
                    courseFile.setCourseMaterial(course);
                    course.getFiles().add(courseFile);
                }
            }
        }
        
        return courseMaterialRepository.save(course);
    }

    public void deleteCourse(Long id) {
        CourseMaterial course = getCourseById(id);
        if (course != null) {
            // Delete all associated files from storage
            if (course.getFilePath() != null) {
                fileStorageService.deleteFile(course.getFilePath());
            }
            
            for (CourseFile file : course.getFiles()) {
                fileStorageService.deleteFile(file.getFilePath());
            }
            
            courseMaterialRepository.deleteById(id);
        }
    }
    
    public void deleteCourseFile(Long courseId, Long fileId) {
        CourseFile file = courseFileRepository.findById(fileId).orElse(null);
        if (file != null && file.getCourseMaterial().getId().equals(courseId)) {
            fileStorageService.deleteFile(file.getFilePath());
            courseFileRepository.deleteById(fileId);
        }
    }
}