package com.example.s380fproject_3103_2.service;

import com.example.s380fproject_3103_2.model.Comment;
import com.example.s380fproject_3103_2.model.CourseMaterial;
import com.example.s380fproject_3103_2.model.Poll;
import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class CommentService {
    @Autowired
    private CommentRepository commentRepository;

    // Add comment to a course
    public Comment addCourseComment(User user, CourseMaterial course, String content) {
        Comment comment = new Comment();
        comment.setUser(user);
        comment.setCourseMaterial(course);
        comment.setContent(content);
        return commentRepository.save(comment);
    }

    // Add comment to a poll
    public Comment addPollComment(User user, Poll poll, String content) {
        Comment comment = new Comment();
        comment.setUser(user);
        comment.setPoll(poll);
        comment.setContent(content);
        return commentRepository.save(comment);
    }

    // Get all comments for a course
    public List<Comment> getCommentsByCourseId(Long courseId) {
        return commentRepository.findByCourseMaterialId(courseId);
    }

    // Get all comments for a poll
    public List<Comment> getCommentsByPollId(Long pollId) {
        return commentRepository.findByPollId(pollId);
    }

    // Teacher-only: Delete comment
    public void deleteComment(Long commentId) {
        commentRepository.deleteById(commentId);
    }
}
