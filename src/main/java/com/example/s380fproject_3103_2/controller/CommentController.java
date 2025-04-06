package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.*;
import com.example.s380fproject_3103_2.service.CommentService;
import com.example.s380fproject_3103_2.service.CourseService;
import com.example.s380fproject_3103_2.service.PollService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/comment")
public class CommentController {
    @Autowired
    private CommentService commentService;
    @Autowired
    private CourseService courseService;
    @Autowired
    private PollService pollService;

    // Add comment to course
    @PostMapping("/add/course/{courseId}")
    public String addCourseComment(@PathVariable Long courseId,
                                   @RequestParam String content,
                                   HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        CourseMaterial course = courseService.getCourseById(courseId);

        if (currentUser != null && course != null) {
            commentService.addCourseComment(currentUser, course, content);
        }
        return "redirect:/course/" + courseId;
    }

    // Add comment to poll
    @PostMapping("/add/poll/{pollId}")
    public String addPollComment(@PathVariable Long pollId,
                                 @RequestParam String content,
                                 HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        Poll poll = pollService.getPollById(pollId);

        if (currentUser != null && poll != null) {
            commentService.addPollComment(currentUser, poll, content);
        }
        return "redirect:/poll/" + pollId;
    }

    // Delete comment (teacher only)
    @PostMapping("/delete/{commentId}")
    public String deleteComment(@PathVariable Long commentId,
                                HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole() == UserRole.TEACHER) {
            commentService.deleteComment(commentId);
        }
        return "redirect:/";
    }
}