package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.CourseMaterial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface CourseMaterialRepository extends JpaRepository<CourseMaterial, Long> {
    @Query("SELECT c FROM CourseMaterial c LEFT JOIN FETCH c.comments WHERE c.id = :id")
    CourseMaterial findWithID(@Param("id") Long id);
}