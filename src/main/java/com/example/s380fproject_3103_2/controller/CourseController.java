package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.model.UserRole;
import com.example.s380fproject_3103_2.repository.CourseFileRepository;
import com.example.s380fproject_3103_2.service.CourseService;
import com.example.s380fproject_3103_2.service.FileStorageService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseService courseService;

    @Autowired
    private FileStorageService fileStorageService;
    
    @Autowired
    private CourseFileRepository courseFileRepository;

    @GetMapping("/{id}")
    public String viewCourse(@PathVariable Long id, Model model, HttpSession session) {
        CourseMaterial course = courseService.getCourseById(id);
        if (course == null) {
            return "redirect:/";
        }
        model.addAttribute("course", course);
        model.addAttribute("contentPage", "course/view.jsp");
        model.addAttribute("pageTitle", course.getTitle());
        return "layout";
    }

    // 獲取所有課程列表
    @GetMapping("/list")
    public String listCourses(Model model) {
        model.addAttribute("courses", courseService.getAllCourses());
        model.addAttribute("pageTitle", "所有課程");
        model.addAttribute("contentPage", "course/list.jsp");
        return "layout";
    }

    // File Download
    @GetMapping("/download/{fileName:.+}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName) {
        try {
            // Remove leading slash if present to avoid path issues
            if (fileName.startsWith("/")) {
                fileName = fileName.substring(1);
            }
            
            Path filePath = fileStorageService.loadFile(fileName);
            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists()) {
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION,
                                "attachment; filename=\"" + resource.getFilename() + "\"")
                        .body(resource);
            } else {
                throw new RuntimeException("File not found");
            }
        } catch (Exception ex) {
            throw new RuntimeException("File download failed", ex);
        }
    }

    // 下載課程的所有檔案（打包成 zip）
    @GetMapping("/{id}/download-all")
    public ResponseEntity<Resource> downloadAllFiles(@PathVariable Long id) {
        try {
            CourseMaterial course = courseService.getCourseById(id);
            if (course == null || course.getCourseFiles().isEmpty()) {
                throw new RuntimeException("沒有找到課程或課程沒有檔案");
            }
            
            // 創建包含所有課程檔案的 ZIP
            Resource zipResource = fileStorageService.createZipWithAllCourseFiles(course);
            
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, 
                            "attachment; filename=\"" + course.getTitle() + "-全部檔案.zip\"")
                    .header(HttpHeaders.CONTENT_TYPE, "application/zip")
                    .body(zipResource);
        } catch (Exception ex) {
            throw new RuntimeException("批量檔案下載失敗", ex);
        }
    }

    @GetMapping("/add")
    public String addCourseForm(HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER) {
            return "redirect:/";
        }
        model.addAttribute("course", new CourseMaterial());
        model.addAttribute("contentPage", "course/add.jsp");
        model.addAttribute("pageTitle", "Add New Course");
        return "layout";
    }

    // 修改為處理多個文件上傳，文件變為可選
    @PostMapping("/add")
    public String addCourseSubmit(
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam(value = "files", required = false) List<MultipartFile> files,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            // 初始化一個空的有效檔案列表
            List<MultipartFile> validFiles = new ArrayList<>();
            
            // 過濾空檔案（如果有提供檔案）
            if (files != null && !files.isEmpty()) {
                for (MultipartFile file : files) {
                    if (file != null && !file.isEmpty()) {
                        validFiles.add(file);
                    }
                }
            }
            
            // 即使沒有檔案，也建立課程
            courseService.addCourse(title, description, validFiles);
        }
        return "redirect:/";
    }
    
    // 顯示刪除課程確認頁面
    @GetMapping("/delete/{id}")
    public String deleteConfirmation(@PathVariable Long id, HttpSession session, Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER) {
            return "redirect:/";
        }
        
        CourseMaterial course = courseService.getCourseById(id);
        if (course == null) {
            return "redirect:/";
        }
        
        model.addAttribute("course", course);
        model.addAttribute("contentPage", "course/delete_confirmation.jsp");
        model.addAttribute("pageTitle", "deleteCourseConfirmation");
        return "layout";
    }

    // 教師：刪除課程
    @PostMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            courseService.deleteCourse(id);
        }
        return "redirect:/";
    }

    // 教師：編輯課程表單
    @GetMapping("/edit/{id}")
    public String editCourseForm(@PathVariable Long id,
                                 HttpSession session,
                                 Model model) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER) {
            return "redirect:/";
        }

        model.addAttribute("course", courseService.getCourseById(id));
        model.addAttribute("pageTitle", "Edit Course Material");
        model.addAttribute("contentPage", "course/edit_content.jsp");
        return "layout";
    }

    // 教師：更新課程
    @PostMapping("/update/{id}")
    public String updateCourse(
            @PathVariable Long id,
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam(value = "files", required = false) MultipartFile[] files,
            HttpSession session,
            Model model) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getRole() != UserRole.TEACHER) {
            return "redirect:/";
        }
        
        // 處理 files 參數，避免 null
        List<MultipartFile> filesList = new ArrayList<>();
        List<MultipartFile> validFiles = new ArrayList<>();
        if (files != null) {
            filesList = Arrays.asList(files);
            System.out.println("接收到檔案數量: " + files.length);
            
            // 添加遺漏的循環結構來處理每個文件
            for (MultipartFile file : filesList) {
                if (file != null && !file.isEmpty()) {
                    validFiles.add(file);
                    System.out.println("添加有效文件: " + file.getOriginalFilename() + ", 大小: " + file.getSize() + " bytes");
                }
            }
        }
        
        try {
            // 記錄更詳細的日誌
            System.out.println("開始更新課程 ID: " + id);
            System.out.println("標題: " + title);
            System.out.println("描述長度: " + (description != null ? description.length() : 0) + " 字符");
            System.out.println("收到檔案數量: " + (files != null ? files.length : 0));
            System.out.println("有效檔案數量: " + validFiles.size());
            
            CourseMaterial updatedCourse = courseService.updateCourse(id, title, description, validFiles);
            System.out.println("課程更新成功，檔案總數: " + updatedCourse.getCourseFiles().size());
            
            return "redirect:/course/" + id;
        } catch (Exception e) {
            System.err.println("課程更新錯誤: " + e.getMessage());
            e.printStackTrace();
            
            // 發生錯誤時返回編輯頁面並顯示錯誤信息
            model.addAttribute("error", "更新失敗: " + e.getMessage());
            model.addAttribute("course", courseService.getCourseById(id));
            model.addAttribute("contentPage", "course/edit_content.jsp");
            model.addAttribute("pageTitle", "Edit Course Material");
            return "layout";
        }
    }
    
    // 刪除特定課程文件
    @PostMapping("/{courseId}/file/delete/{fileId}")
    public String deleteFile(
            @PathVariable Long courseId,
            @PathVariable Long fileId,
            HttpSession session) {
            
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            courseService.deleteCourseFile(courseId, fileId);
        }
        return "redirect:/course/" + courseId;
    }

    // Special handler for files in the /files/ directory
    @GetMapping("/files/{filename:.+}")
    public ResponseEntity<Resource> serveFileFromFilesDirectory(@PathVariable String filename) {
        try {
            // Create a path to the actual file in the project's files directory
            Path filePath = Paths.get("files", filename).toAbsolutePath().normalize();
            Resource resource = new UrlResource(filePath.toUri());

            if (resource.exists()) {
                String contentType = "application/octet-stream";
                
                if (filename.toLowerCase().endsWith(".pdf")) {
                    contentType = "application/pdf";
                } else if (filename.toLowerCase().endsWith(".txt")) {
                    contentType = "text/plain";
                }
                
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_TYPE, contentType)
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                        .body(resource);
            } else {
                throw new RuntimeException("File not found: " + filename);
            }
        } catch (Exception ex) {
            throw new RuntimeException("Error serving file: " + filename, ex);
        }
    }

    // 輔助方法
    private boolean isTeacher(User user) {
        return user != null && user.getRole() == UserRole.TEACHER;
    }
}