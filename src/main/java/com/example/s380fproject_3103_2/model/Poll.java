package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.util.Date;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

@Entity
@Table(name = "POLLS")
@Data
@ToString(exclude = {"options", "comments"})
@EqualsAndHashCode(exclude = {"options", "comments"})
public class Poll {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String question;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "poll", fetch = FetchType.LAZY)
    private List<PollOption> options;

    @OneToMany(mappedBy = "poll", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Comment> comments;

    @Column(name = "created_at")
    @CreationTimestamp
    private Date createdAt;

    @Transient
    private Long userVotedOptionId;

    @Transient
    private boolean isAccessible = true;  // 新增標記欄位，用於指示投票是否可訪問

    // 移除所有標準的 getter/setter 方法，因為 @Data 已經提供了它們
    // 只保留含有特殊邏輯的方法

    // 新添加的方法來計算投票總數
    public int getTotalVotes() {
        if (options == null || options.isEmpty()) {
            return 0;
        }

        try {
            return options.stream()
                    .mapToInt(PollOption::getVoteCount)
                    .sum();
        } catch (Exception e) {
            // 避免因為並發修改異常導致整個應用程序崩潰
            System.err.println("計算總投票數時發生錯誤: " + e.getMessage());

            // 使用替代方法計算總票數 (更安全但效率較低)
            AtomicInteger total = new AtomicInteger(0);
            for (PollOption option : options) {
                try {
                    total.addAndGet(option.getVoteCount());
                } catch (Exception ex) {
                    // 忽略單個選項的錯誤，繼續處理
                }
            }
            return total.get();
        }
    }

    // 重設投票狀態，用於錯誤恢復
    public void resetVotingState() {
        this.isAccessible = true;
        this.userVotedOptionId = null;
    }
}