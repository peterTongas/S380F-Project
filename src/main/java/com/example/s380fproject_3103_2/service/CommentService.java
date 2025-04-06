package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.*;
import com.example.s380fproject_3103_2.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class CommentService {
    @Autowired
    private CommentRepository commentRepository;

    public Comment addCourseComment(User user, CourseMaterial course, String content) {
        Comment comment = new Comment();
        comment.setUser(user);
        comment.setCourseMaterial(course);
        comment.setContent(content);
        return commentRepository.save(comment);
    }

    public Comment addPollComment(User user, Poll poll, String content) {
        Comment comment = new Comment();
        comment.setUser(user);
        comment.setPoll(poll);
        comment.setContent(content);
        return commentRepository.save(comment);
    }

    public void deleteComment(Long commentId) {
        commentRepository.deleteById(commentId);
    }
}