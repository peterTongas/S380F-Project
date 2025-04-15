package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.PollOption;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PollOptionRepository extends JpaRepository<PollOption, Long> {
    // 基本的 CRUD 操作由 JpaRepository 提供
    // 如有需要，可在此處添加自定義的查詢方法
}
