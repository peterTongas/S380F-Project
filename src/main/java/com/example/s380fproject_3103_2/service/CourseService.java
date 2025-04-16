package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.CourseFile;
import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.repository.CourseFileRepository;
import com.example.s380fproject_3103_2.repository.CourseMaterialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
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

    @Transactional
    public CourseMaterial addCourse(String title, String description, List<MultipartFile> files) {
        CourseMaterial course = new CourseMaterial();
        course.setTitle(title);
        course.setDescription(description);
        
        // 保存課程以獲取 ID
        course = courseMaterialRepository.save(course);
        
        // 處理並保存多個文件
        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty()) {
                String filePath = fileStorageService.storeFile(file);
                
                CourseFile courseFile = new CourseFile();
                courseFile.setFileName(file.getOriginalFilename());
                courseFile.setFilePath(filePath);
                courseFile.setFileType(file.getContentType());
                courseFile.setFileSize(file.getSize());
                courseFile.setCourseMaterial(course);
                
                course.getCourseFiles().add(courseFile);
            }
        }
        
        // 保留向後兼容性，將第一個文件路徑設置為主路徑
        if (!course.getCourseFiles().isEmpty()) {
            course.setFilePath(course.getCourseFiles().get(0).getFilePath());
        }
        
        return courseMaterialRepository.save(course);
    }
    
    @Transactional
    public CourseMaterial updateCourse(Long courseId, String title, String description, List<MultipartFile> newFiles) {
        CourseMaterial course = courseMaterialRepository.findById(courseId).orElseThrow(() -> 
            new RuntimeException("無法找到課程，ID: " + courseId));
            
        course.setTitle(title);
        course.setDescription(description);
        
        // 處理新上傳的文件
        if (newFiles != null && !newFiles.isEmpty()) {
            System.out.println("處理新上傳檔案，數量: " + newFiles.size());
            for (MultipartFile file : newFiles) {
                if (file != null && !file.isEmpty()) {
                    try {
                        System.out.println("存儲文件: " + file.getOriginalFilename() + ", 大小: " + file.getSize() + " bytes");
                        String filePath = fileStorageService.storeFile(file);
                        
                        // 創建新的 CourseFile 對象
                        CourseFile courseFile = new CourseFile();
                        courseFile.setFileName(file.getOriginalFilename());
                        courseFile.setFilePath(filePath);
                        courseFile.setFileType(file.getContentType());
                        courseFile.setFileSize(file.getSize());
                        courseFile.setCourseMaterial(course);
                        
                        course.getCourseFiles().add(courseFile);
                    } catch (Exception e) {
                        throw new RuntimeException("無法處理檔案: " + file.getOriginalFilename() + " - " + e.getMessage(), e);
                    }
                }
            }
        }
        
        // 更新主文件路徑（如果有新文件且原本沒有主路徑）
        if (course.getFilePath() == null && !course.getCourseFiles().isEmpty()) {
            course.setFilePath(course.getCourseFiles().get(0).getFilePath());
        }
        
        // 保存課程更新
        return courseMaterialRepository.save(course);
    }

    public CourseMaterial updateCourse(CourseMaterial course) {
        return courseMaterialRepository.save(course);
    }
    
    @Transactional
    public void deleteCourseFile(Long courseId, Long fileId) {
        CourseFile file = courseFileRepository.findById(fileId).orElseThrow(() ->
            new RuntimeException("File not found with ID: " + fileId));
            
        // 確保文件屬於指定的課程
        if (file.getCourseMaterial().getId().equals(courseId)) {
            // 刪除實際文件
            fileStorageService.deleteFile(file.getFilePath());
            
            // 從數據庫中刪除記錄
            courseFileRepository.delete(file);
        }
    }

    @Transactional
    public void deleteCourse(Long id) {
        CourseMaterial course = courseMaterialRepository.findById(id).orElse(null);
        if (course != null) {
            // 刪除所有相關的文件
            for (CourseFile file : course.getCourseFiles()) {
                fileStorageService.deleteFile(file.getFilePath());
            }
            
            // 刪除主文件（如果存在且不在 courseFiles 中）
            if (course.getFilePath() != null) {
                boolean foundInCourseFiles = false;
                for (CourseFile file : course.getCourseFiles()) {
                    if (course.getFilePath().equals(file.getFilePath())) {
                        foundInCourseFiles = true;
                        break;
                    }
                }
                if (!foundInCourseFiles) {
                    fileStorageService.deleteFile(course.getFilePath());
                }
            }
            
            courseMaterialRepository.deleteById(id);
        }
    }
    
    public long countAllCourses() {
        return courseMaterialRepository.count();
    }
}