package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.CourseService;
import com.example.s380fproject_3103_2.model.UserRole;
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

@Controller
@RequestMapping("/course")
public class CourseController {

    @Autowired
    private CourseService courseService;

    @Autowired
    private FileStorageService fileStorageService;

    @GetMapping("/{id}")
    public String viewCourse(@PathVariable Long id, Model model, HttpSession session) {
        model.addAttribute("course", courseService.getCourseById(id));
        model.addAttribute("contentPage", "course/view.jsp");
        model.addAttribute("pageTitle", "Course Details");
        return "layout";
    }

    // File Download
    @GetMapping("/download/{fileName}")
    public ResponseEntity<Resource> downloadFile(@PathVariable String fileName) {
        try {
            Path filePath = fileStorageService.loadFile(fileName);
            Resource resource = new UrlResource(filePath.toUri());

            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION,
                            "attachment; filename=\"" + resource.getFilename() + "\"")
                    .body(resource);
        } catch (Exception ex) {
            throw new RuntimeException("File download failed", ex);
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

    // Teacher: Submit New Course with Files
    @PostMapping("/add")
    public String addCourseSubmit(
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam("files") MultipartFile[] files,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            courseService.addCourseWithFiles(title, description, files);
        }
        return "redirect:/";
    }

    // Teacher: Delete Course
    @PostMapping("/delete/{id}")
    public String deleteCourse(@PathVariable Long id, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            courseService.deleteCourse(id);
        }
        return "redirect:/";
    }
    
    // Delete individual course file
    @PostMapping("/{courseId}/deleteFile/{fileId}")
    public String deleteFile(@PathVariable Long courseId, @PathVariable Long fileId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            courseService.deleteCourseFile(courseId, fileId);
        }
        return "redirect:/course/" + courseId;
    }

    // Teacher: Edit Course Form
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

    // Teacher: Update Course
    @PostMapping("/update/{id}")
    public String updateCourse(
            @PathVariable Long id,
            @RequestParam String title,
            @RequestParam String description,
            @RequestParam(required = false) MultipartFile[] files,
            HttpSession session) {

        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            CourseMaterial existingCourse = courseService.getCourseById(id);
            existingCourse.setTitle(title);
            existingCourse.setDescription(description);

            courseService.updateCourseWithFiles(existingCourse, files);
        }
        return "redirect:/course/" + id;
    }

    // Helper method for role checking
    private boolean isTeacher(User user) {
        return user != null && user.getRole() == UserRole.TEACHER;
    }
}