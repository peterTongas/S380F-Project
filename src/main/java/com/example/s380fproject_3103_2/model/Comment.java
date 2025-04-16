package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;
import org.hibernate.annotations.CreationTimestamp;

import java.util.Date;

@Data
@Entity
@Table(name = "COMMENTS")
@ToString(exclude = {"user", "courseMaterial", "poll"})
@EqualsAndHashCode(exclude = {"user", "courseMaterial", "poll"})
public class Comment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String content;

    @Column(name = "created_at")
    @CreationTimestamp
    private Date createdAt;

    @ManyToOne
    @JoinColumn(name = "user_username")
    private User user;

    @ManyToOne
    @JoinColumn(name = "course_material_id")
    private CourseMaterial courseMaterial;

    @ManyToOne
    @JoinColumn(name = "poll_id")
    private Poll poll;
}