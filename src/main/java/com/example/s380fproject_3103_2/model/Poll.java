package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;

@Entity
@Table(name = "POLLS")
@Data
public class Poll {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String question;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "poll")
    private List<PollOption> options;

    @OneToMany(mappedBy = "poll")
    private List<Comment> comments;
}