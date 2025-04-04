package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "POLL_OPTIONS")
@Data
public class PollOption {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String text;
    private int voteCount;

    @ManyToOne
    private Poll poll;
}