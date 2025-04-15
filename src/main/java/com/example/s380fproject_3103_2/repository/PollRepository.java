package com.example.s380fproject_3103_2.repository;

import com.example.s380fproject_3103_2.model.Poll;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Repository
public interface PollRepository extends JpaRepository<Poll, Long> {
    @Query("SELECT p FROM Poll p LEFT JOIN FETCH p.options WHERE p.id = :id")
    Poll findPollWithOptions(@Param("id") Long id);

    @Query("SELECT new map(p.question as question, o.text as selectedOption, p.createdAt as voteDate) " +
            "FROM Poll p JOIN p.options o JOIN o.votes v " +
            "WHERE v.username = :username " +
            "ORDER BY p.createdAt DESC")
    List<Map<String, Object>> findVoteHistoryByUsername(@Param("username") String username);

    // Alternative version if you prefer entity-based results:
    @Query("SELECT p FROM Poll p JOIN FETCH p.options o JOIN FETCH o.votes v " +
            "WHERE v.username = :username")
    List<Poll> findPollsVotedByUser(@Param("username") String username);

    @Query(value = "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM USER_VOTES uv " +
            "JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
            "WHERE uv.user_username = :username AND po.poll_id = :pollId", nativeQuery = true)
    boolean existsVoteByUsernameAndPollId(@Param("username") String username, @Param("pollId") Long pollId);

    /**
     * 直接插入投票記錄到USER_VOTES表，避免通過實體關係修改導致的並發修改異常
     */
    @Modifying
    @Transactional
    @Query(value = "INSERT INTO USER_VOTES (poll_option_id, user_username) VALUES (:optionId, :username)", 
           nativeQuery = true)
    void insertVoteRecord(@Param("optionId") Long optionId, @Param("username") String username);
    
    /**
     * 直接更新投票選項的計數，避免實體關係修改
     */
    @Modifying
    @Transactional
    @Query(value = "UPDATE POLL_OPTIONS SET vote_count = vote_count + 1 WHERE id = :optionId", 
           nativeQuery = true)
    void incrementVoteCount(@Param("optionId") Long optionId);
    
    /**
     * 安全的投票操作 - 檢查用戶是否已經投過票
     * 
     * @param username 用戶名
     * @param pollId 投票ID
     * @param optionId 選項ID
     * @return 成功投票的數量 (0表示未能投票，可能已經投過)
     */
    @Modifying
    @Transactional
    @Query(value = 
        "INSERT INTO USER_VOTES (poll_option_id, user_username) " +
        "SELECT :optionId, :username FROM dual " +
        "WHERE NOT EXISTS (SELECT 1 FROM USER_VOTES uv " +
        "                 JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
        "                 WHERE uv.user_username = :username AND po.poll_id = :pollId)",
        nativeQuery = true)
    int safeVoteForOption(@Param("optionId") Long optionId, 
                           @Param("username") String username, 
                           @Param("pollId") Long pollId);
    
    /**
     * 綜合投票操作 - 安全版本，避免ConcurrentModificationException
     * 在單一事務中執行兩個獨立SQL語句，而非一個複合SQL
     * 
     * @param optionId 選項ID
     * @param username 用戶名
     * @param pollId 投票ID
     * @return 成功投票的數量 (0表示未能投票，可能已經投過)
     */
    @Modifying
    @Transactional
    @Query(value = 
        "INSERT INTO USER_VOTES (poll_option_id, user_username) " +
        "SELECT :optionId, :username FROM dual " +
        "WHERE NOT EXISTS (SELECT 1 FROM USER_VOTES uv " +
        "                 JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
        "                 WHERE uv.user_username = :username AND po.poll_id = :pollId)",
        nativeQuery = true)
    int safeInsertVoteRecord(@Param("optionId") Long optionId, 
                           @Param("username") String username, 
                           @Param("pollId") Long pollId);
    
    /**
     * 完全安全的投票操作 - 避免任何ConcurrentModificationException
     * 使用單一SQL查詢完成檢查、插入和計數更新操作，不依賴實體關聯
     *
     * @param optionId 選項ID
     * @param username 用戶名
     * @param pollId 投票ID
     * @return 更新的記錄數 (0表示未能投票，可能已投票)
     */
    @Modifying
    @Transactional
    @Query(value = 
        "INSERT INTO USER_VOTES (poll_option_id, user_username) " +
        "SELECT :optionId, :username FROM dual " +
        "WHERE NOT EXISTS (SELECT 1 FROM USER_VOTES uv " +
        "                 JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
        "                 WHERE po.poll_id = :pollId AND uv.user_username = :username); " +
        "UPDATE POLL_OPTIONS SET vote_count = vote_count + 1 " +
        "WHERE id = :optionId " +
        "AND EXISTS (SELECT 1 FROM USER_VOTES " +
        "           WHERE poll_option_id = :optionId AND user_username = :username)",
        nativeQuery = true)
    int completeVotingOperation(@Param("optionId") Long optionId, 
                              @Param("username") String username, 
                              @Param("pollId") Long pollId);
    
    /**
     * 新增安全的投票操作 - 確保每個用戶只能對一個投票問題投一次票
     */
    @Modifying
    @Transactional
    @Query(value = 
        "INSERT INTO USER_VOTES (poll_option_id, user_username) " +
        "SELECT :optionId, :username FROM dual " +
        "WHERE NOT EXISTS (SELECT 1 FROM USER_VOTES uv " +
        "                 JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
        "                 WHERE po.poll_id = :pollId AND uv.user_username = :username); " +
        "UPDATE POLL_OPTIONS SET vote_count = vote_count + 1 " +
        "WHERE id = :optionId " +
        "AND EXISTS (SELECT 1 FROM USER_VOTES " +
        "           WHERE poll_option_id = :optionId AND user_username = :username)",
        nativeQuery = true)
    int oneUserPerPollVoting(@Param("optionId") Long optionId, 
                           @Param("username") String username, 
                           @Param("pollId") Long pollId);
    
    /**
     * 檢查投票問題是否已有任何用戶投票
     */
    @Query(value = 
        "SELECT CASE WHEN COUNT(*) > 0 THEN true ELSE false END FROM USER_VOTES uv " +
        "JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
        "WHERE po.poll_id = :pollId", 
        nativeQuery = true)
    boolean isPollVotedByAnyUser(@Param("pollId") Long pollId);
    
    /**
     * 投票後更新計數 - 安全版本
     * 
     * @param optionId 選項ID
     * @return 更新的記錄數 
     */
    @Modifying
    @Transactional
    @Query(value = "UPDATE POLL_OPTIONS SET vote_count = vote_count + 1 WHERE id = :optionId", 
           nativeQuery = true)
    int safeUpdateVoteCount(@Param("optionId") Long optionId);

    /**
     * 綜合投票操作 - 在單一事務中同時添加投票記錄和更新票數
     * 
     * @param optionId 選項ID
     * @param username 用戶名
     * @param pollId 投票ID
     * @return 成功投票的數量 (0表示未能投票，可能已經投過)
     */
    @Modifying
    @Transactional
    @Query(value = 
        "INSERT INTO USER_VOTES (poll_option_id, user_username) " +
        "SELECT :optionId, :username FROM dual " +
        "WHERE NOT EXISTS (SELECT 1 FROM USER_VOTES uv " +
        "                 JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
        "                 WHERE po.poll_id = :pollId AND uv.user_username = :username); " +
        "UPDATE POLL_OPTIONS SET vote_count = vote_count + 1 " +
        "WHERE id = :optionId " +
        "AND EXISTS (SELECT 1 FROM USER_VOTES " +
        "           WHERE poll_option_id = :optionId AND user_username = :username)",
        nativeQuery = true)
    int safeVoteAndIncrementCount(@Param("optionId") Long optionId, 
                                  @Param("username") String username, 
                                  @Param("pollId") Long pollId);
    
    /**
     * 獲取用戶對特定投票的選項ID (如果已投票)
     */
    @Query(value = 
        "SELECT po.id FROM USER_VOTES uv " +
        "JOIN POLL_OPTIONS po ON uv.poll_option_id = po.id " +
        "WHERE uv.user_username = :username AND po.poll_id = :pollId " +
        "LIMIT 1", 
        nativeQuery = true)
    Long findVotedOptionId(@Param("username") String username, @Param("pollId") Long pollId);
}