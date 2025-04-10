package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.Poll;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Map;

public interface PollRepository extends JpaRepository<Poll, Long> {
    @Query("SELECT p FROM Poll p LEFT JOIN FETCH p.options WHERE p.id = :id")
    Poll findPollWithOptions(@Param("id") Long id);

    @Query("SELECT new map(p.question as question, o.text as selectedOption, o.poll.createdAt as voteDate) " +
            "FROM PollOption o JOIN o.votes v JOIN o.poll p " +
            "WHERE v.username = :username " +
            "ORDER BY p.createdAt DESC")
    List<Map<String, Object>> findVoteHistoryByUsername(@Param("username") String username);

    // 檢查用戶是否已對特定 poll 投票
    @Query("SELECT COUNT(v) > 0 FROM Poll p JOIN p.options o JOIN o.votes v " +
           "WHERE v.username = :username AND p.id = :pollId")
    boolean hasUserVotedForPoll(@Param("username") String username, @Param("pollId") Long pollId);

    // Alternative version if you prefer entity-based results:
    @Query("SELECT p FROM Poll p JOIN FETCH p.options o JOIN FETCH o.votes v " +
            "WHERE v.username = :username")
    List<Poll> findPollsVotedByUser(@Param("username") String username);
}