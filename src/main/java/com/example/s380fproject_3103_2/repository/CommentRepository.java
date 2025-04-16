package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface CommentRepository extends JpaRepository<Comment, Long> {
    // Find all comments by a specific user (sorted by newest first)
    @Query("SELECT c FROM Comment c WHERE c.user.username = :username ORDER BY c.createdAt DESC")
    List<Comment> findByUserUsernameOrderByCreatedAtDesc(@Param("username") String username);

    // Find comments on a specific course material
    @Query("SELECT c FROM Comment c WHERE c.courseMaterial.id = :courseId ORDER BY c.createdAt DESC")
    List<Comment> findByCourseMaterialId(@Param("courseId") Long courseId);

    // Find comments on a specific poll
    @Query("SELECT c FROM Comment c WHERE c.poll.id = :pollId ORDER BY c.createdAt DESC")
    List<Comment> findByPollId(@Param("pollId") Long pollId);

    // Find comments containing specific text (for future search functionality)
    @Query("SELECT c FROM Comment c WHERE c.content LIKE %:searchTerm%")
    List<Comment> searchByContent(@Param("searchTerm") String searchTerm);
}