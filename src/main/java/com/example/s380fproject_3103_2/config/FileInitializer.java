package com.example.s380fproject_3103_2.config;

import com.example.s380fproject_3103_2.model.CourseFile;
import com.example.s380fproject_3103_2.repository.CourseFileRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

@Component
public class FileInitializer {

    @Autowired
    private CourseFileRepository courseFileRepository;

    @PostConstruct
    public void initializeFileSizes() {
        List<CourseFile> courseFiles = courseFileRepository.findAll();
        
        for (CourseFile courseFile : courseFiles) {
            try {
                String filePath = courseFile.getFilePath();
                
                // Remove leading slash if present
                if (filePath.startsWith("/")) {
                    filePath = filePath.substring(1);
                }
                
                // Try to find the file in different locations
                File file = null;
                
                // Try direct path
                Path directPath = Paths.get(filePath).toAbsolutePath().normalize();
                if (Files.exists(directPath)) {
                    file = directPath.toFile();
                } 
                // Try in uploads directory
                else {
                    Path uploadsPath = Paths.get("uploads", filePath.contains("/") 
                           ? filePath.substring(filePath.lastIndexOf("/") + 1) 
                           : filePath).toAbsolutePath().normalize();
                    if (Files.exists(uploadsPath)) {
                        file = uploadsPath.toFile();
                    }
                }
                
                // If still not found, try in files directory
                if (file == null || !file.exists()) {
                    Path filesPath = Paths.get("files", filePath.contains("/") 
                           ? filePath.substring(filePath.lastIndexOf("/") + 1) 
                           : filePath).toAbsolutePath().normalize();
                    if (Files.exists(filesPath)) {
                        file = filesPath.toFile();
                    }
                }

                // If file exists, update the size
                if (file != null && file.exists()) {
                    courseFile.setFileSize(file.length());
                    courseFileRepository.save(courseFile);
                    System.out.println("Updated file size for " + courseFile.getFileName() + ": " + file.length() + " bytes");
                } else {
                    System.out.println("Could not find file: " + filePath);
                }
            } catch (Exception e) {
                System.err.println("Error updating file size for " + courseFile.getFileName() + ": " + e.getMessage());
            }
        }
    }
}