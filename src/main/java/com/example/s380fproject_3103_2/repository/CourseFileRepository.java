package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.CourseFile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseFileRepository extends JpaRepository<CourseFile, Long> {
    List<CourseFile> findByCourseMaterialId(Long courseMaterialId);
}