package com.example.s380fproject_3103_2.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.ToString;

import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "POLL_OPTIONS")
@Data
@ToString(exclude = {"poll", "votes"})
@EqualsAndHashCode(exclude = {"poll", "votes"})
public class PollOption {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String text;
    private int voteCount;

    @ManyToOne
    private Poll poll;

    @ManyToMany
    @JoinTable(
            name = "user_votes",
            joinColumns = @JoinColumn(name = "poll_option_id"),
            inverseJoinColumns = @JoinColumn(name = "user_username"))
    private Set<User> votes = new HashSet<>();
}