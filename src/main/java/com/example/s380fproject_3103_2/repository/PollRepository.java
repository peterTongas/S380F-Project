package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.Poll;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface PollRepository extends JpaRepository<Poll, Long> {

    // Custom query to fetch a poll with its options eagerly
    @Query("SELECT p FROM Poll p LEFT JOIN FETCH p.options WHERE p.id = :id")
    Poll findPollWithOptions(@Param("id") Long id);

    // Standard CRUD methods are inherited from JpaRepository
    // (save, findById, findAll, deleteById, etc.)
}
