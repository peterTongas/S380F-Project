package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.model.Comment;
import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.service.CommentService;
import com.example.s380fproject_3103_2.service.CourseService;
import com.example.s380fproject_3103_2.service.PollService;
import com.example.s380fproject_3103_2.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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

    // Add comment to a course
    @PostMapping("/course/{courseId}")
    public String addCourseComment(@PathVariable Long courseId, @RequestParam String content, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        CourseMaterial course = courseService.getCourseById(courseId);
        if (currentUser != null && course != null) {
            commentService.addCourseComment(currentUser, course, content);
        }
        return "redirect:/course/" + courseId;  // Redirect back to course view page
    }

    // Add comment to a poll
    @PostMapping("/poll/{pollId}")
    public String addPollComment(@PathVariable Long pollId, @RequestParam String content, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        Poll poll = pollService.getPollById(pollId);
        if (currentUser != null && poll != null) {
            commentService.addPollComment(currentUser, poll, content);
        }
        return "redirect:/poll/" + pollId;  // Redirect back to poll view page
    }

    // Teacher: Delete comment
    @PostMapping("/delete/{commentId}")
    public String deleteComment(@PathVariable Long commentId, HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.getRole().name().equals("TEACHER")) {
            commentService.deleteComment(commentId);
        }
        return "redirect:/";  // Redirect to home page or wherever you want
    }
}
