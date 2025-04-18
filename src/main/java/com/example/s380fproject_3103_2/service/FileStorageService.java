package com.example.s380fproject_3103_2.service;

import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.CourseFile;

@Service
public class FileStorageService {
    private final Path fileStorageLocation;

    public FileStorageService() {
        this.fileStorageLocation = Paths.get("uploads")
                .toAbsolutePath().normalize();

        try {
            Files.createDirectories(this.fileStorageLocation);
        } catch (IOException ex) {
            throw new RuntimeException("Could not create upload directory", ex);
        }
    }

    public String storeFile(MultipartFile file) {
        String originalFileName = StringUtils.cleanPath(file.getOriginalFilename());
        String fileName = UUID.randomUUID() + "_" + originalFileName;

        try {
            Path targetLocation = this.fileStorageLocation.resolve(fileName);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);
            return fileName;
        } catch (IOException ex) {
            throw new RuntimeException("Could not store file " + fileName, ex);
        }
    }
    
    // 新增批量存儲方法
    public List<String> storeFiles(List<MultipartFile> files) {
        List<String> storedFileNames = new ArrayList<>();
        for (MultipartFile file : files) {
            if (file != null && !file.isEmpty()) {
                storedFileNames.add(storeFile(file));
            }
        }
        return storedFileNames;
    }

    public Path loadFile(String fileName) {
        return fileStorageLocation.resolve(fileName).normalize();
    }

    public void deleteFile(String fileName) {
        try {
            Path filePath = loadFile(fileName);
            Files.deleteIfExists(filePath);
        } catch (IOException ex) {
            throw new RuntimeException("Could not delete file " + fileName, ex);
        }
    }
    
    // 新增批量刪除方法
    public void deleteFiles(List<String> fileNames) {
        for (String fileName : fileNames) {
            deleteFile(fileName);
        }
    }

    public Resource createZipWithAllCourseFiles(CourseMaterial course) throws IOException {
        // 創建臨時文件來存儲ZIP
        Path zipPath = Files.createTempFile("course_files_" + course.getId() + "_", ".zip");
        
        try (FileOutputStream fos = new FileOutputStream(zipPath.toFile());
             ZipOutputStream zos = new ZipOutputStream(fos)) {
            
            for (CourseFile courseFile : course.getCourseFiles()) {
                Path filePath = loadFile(courseFile.getFilePath().substring(courseFile.getFilePath().lastIndexOf("/") + 1));
                if (Files.exists(filePath)) {
                    ZipEntry zipEntry = new ZipEntry(courseFile.getFileName());
                    zos.putNextEntry(zipEntry);
                    
                    Files.copy(filePath, zos);
                    zos.closeEntry();
                }
            }
        }
        
        return new UrlResource(zipPath.toUri());
    }
}