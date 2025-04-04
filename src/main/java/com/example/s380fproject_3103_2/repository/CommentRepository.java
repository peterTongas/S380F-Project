package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {

    // Find comments by course material ID
    @Query("SELECT c FROM Comment c WHERE c.courseMaterial.id = :courseId ORDER BY c.id DESC")
    List<Comment> findByCourseMaterialId(@Param("courseId") Long courseId);

    // Find comments by poll ID
    @Query("SELECT c FROM Comment c WHERE c.poll.id = :pollId ORDER BY c.id DESC")
    List<Comment> findByPollId(@Param("pollId") Long pollId);

    // Find comments by user
    List<Comment> findByUserUsername(String username);
}