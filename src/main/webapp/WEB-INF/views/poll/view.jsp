<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card shadow-sm mb-4">
    <div class="card-header bg-primary text-white">
        <h2 class="h3 mb-0"><i class="fas fa-poll me-2"></i>${poll.question}</h2>
    </div>
    <div class="card-body">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><span data-i18n="errorMessage">${errorMessage}</span>
            </div>
        </c:if>
        
        <c:choose>
            <c:when test="${hasVoted && not empty sessionScope.currentUser && !changeVoteMode}">
                <div class="alert alert-info mb-4">
                    <i class="fas fa-info-circle me-2"></i><span data-i18n="alreadyVoted">您已對此投票進行了投票</span>
                </div>
                
                <h4 class="mb-3"><span data-i18n="pollResults">投票結果</span></h4>
                <div class="mb-4">
                    <!-- Always display exactly 4 options -->
                    <c:forEach begin="0" end="3" varStatus="loop">
                        <c:choose>
                            <c:when test="${loop.index < poll.options.size()}">
                                <c:set var="option" value="${poll.options[loop.index]}"/>
                                <div class="poll-option">
                                    <div class="poll-progress">
                                        <div class="progress-bar ${poll.userVotedOptionId == option.id ? 'bg-success' : 'bg-primary'}" 
                                             role="progressbar" 
                                             style="width: ${empty poll.totalVotes || poll.totalVotes == 0 ? 0 : (option.voteCount / poll.totalVotes) * 100}%" 
                                             aria-valuenow="${option.voteCount}" 
                                             aria-valuemin="0" 
                                             aria-valuemax="100"></div>
                                    </div>
                                    <span class="poll-option-text">
                                        ${option.text}
                                        <c:if test="${poll.userVotedOptionId == option.id}">
                                            <i class="fas fa-check-circle text-success ms-2"></i>
                                        </c:if>
                                    </span>
                                    <span class="poll-option-count">
                                        ${option.voteCount} <span data-i18n="votes">票</span> (${empty poll.totalVotes || poll.totalVotes == 0 ? 0 : Math.round((option.voteCount / poll.totalVotes) * 100)}%)
                                    </span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Display placeholder for missing options -->
                                <div class="poll-option disabled">
                                    <div class="poll-progress">
                                        <div class="progress-bar bg-light" role="progressbar" 
                                             style="width: 0%" 
                                             aria-valuenow="0" 
                                             aria-valuemin="0" 
                                             aria-valuemax="100"></div>
                                    </div>
                                    <span class="poll-option-text text-muted">Option ${loop.index + 1} (Not available)</span>
                                    <span class="poll-option-count">0 <span data-i18n="votes">票</span> (0%)</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <p class="text-muted mt-3">
                        <small><i class="fas fa-users me-1"></i><span data-i18n="totalVotes">總投票數</span>: ${poll.totalVotes}</small>
                    </p>
                </div>
                
                <!-- Add option to change vote -->
                <c:if test="${not empty sessionScope.currentUser}">
                    <a href="/poll/change-vote/${poll.id}?previousVoteOptionId=${poll.userVotedOptionId}" class="btn btn-outline-primary">
                        <i class="fas fa-exchange-alt me-2"></i><span data-i18n="changeVote">Change My Vote</span>
                    </a>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:if test="${changeVoteMode}">
                    <div class="alert alert-info mb-4">
                        <i class="fas fa-info-circle me-2"></i><span data-i18n="selectNewVote">請選擇您想要更改的新投票選項</span>
                    </div>
                    
                    <!-- Debug information - only visible in debug mode -->
                    <c:if test="${param.debug == 'true'}">
                        <div class="alert alert-secondary small">
                            <p class="mb-1"><strong>Debug Info:</strong></p>
                            <p class="mb-1">changeVoteMode: ${changeVoteMode}</p>
                            <p class="mb-1">hasVoted: ${hasVoted}</p>
                            <p class="mb-1">previousVoteOptionId: ${poll.userVotedOptionId}</p>
                            <p class="mb-0">sessionUser: ${sessionScope.currentUser.username}</p>
                        </div>
                    </c:if>
                </c:if>
            
                <form action="/poll/vote/${poll.id}" method="post" class="mb-4">
                    <div class="mb-3">
                        <label class="form-label">
                            <c:choose>
                                <c:when test="${changeVoteMode}">
                                    <span data-i18n="changeOption">更改投票選項</span>
                                </c:when>
                                <c:otherwise>
                                    <span data-i18n="chooseOption">Choose an Option</span>
                                </c:otherwise>
                            </c:choose>
                        </label>
                        <!-- Always display exactly 4 options -->
                        <c:forEach begin="0" end="3" varStatus="loop">
                            <c:choose>
                                <c:when test="${loop.index < poll.options.size()}">
                                    <c:set var="option" value="${poll.options[loop.index]}"/>
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="optionIndex" 
                                               id="option${loop.index}" value="${loop.index}" 
                                               ${poll.userVotedOptionId == option.id ? 'checked' : ''}
                                               ${changeVoteMode ? '' : (hasVoted ? 'disabled' : '')}>
                                        <label class="form-check-label w-100" for="option${loop.index}" style="cursor: pointer;">
                                            ${option.text} <span class="text-muted">(${option.voteCount} votes)</span>
                                        </label>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Display disabled placeholder for missing options -->
                                    <div class="form-check mb-2">
                                        <input class="form-check-input" type="radio" name="optionIndex"
                                               id="option${loop.index}" value="${loop.index}" disabled>
                                        <label class="form-check-label text-muted" for="option${loop.index}">
                                            Option ${loop.index + 1} (Not available) <span class="text-muted">(0 votes)</span>
                                        </label>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                    
                    <c:if test="${not empty sessionScope.currentUser}">
                        <c:if test="${changeVoteMode}">
                            <input type="hidden" name="changeVote" value="true">
                            <input type="hidden" name="previousVoteOptionId" value="${poll.userVotedOptionId}">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-exchange-alt me-2"></i><span data-i18n="submitNewVote">提交新投票</span>
                            </button>
                            <a href="/poll/${poll.id}" class="btn btn-outline-secondary ms-2">
                                <i class="fas fa-times me-2"></i><span data-i18n="cancel">取消</span>
                            </a>
                        </c:if>
                        <c:if test="${!changeVoteMode}">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-vote-yea me-2"></i><span data-i18n="submitVote">Submit Vote</span>
                            </button>
                        </c:if>
                    </c:if>
                    
                    <c:if test="${empty sessionScope.currentUser}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i><span data-i18n="loginToVote">請先登入才能投票</span>
                            <a href="/user/login?redirect=/poll/${poll.id}" class="btn btn-sm btn-outline-primary ms-3">
                                <i class="fas fa-sign-in-alt me-1"></i><span data-i18n="login">登入</span>
                            </a>
                        </div>
                    </c:if>
                </form>
            </c:otherwise>
        </c:choose>
        
        <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
            <div class="mt-4 d-flex justify-content-end">
                <form action="/poll/delete/${poll.id}" method="post" onsubmit="return confirm('${confirmDeletePoll}');">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash-alt me-2"></i><span data-i18n="deletePoll">刪除投票</span>
                    </button>
                </form>
            </div>
        </c:if>
    </div>
</div>

<script>
// Enhance poll option selection UX
document.addEventListener('DOMContentLoaded', function() {
    const pollOptions = document.querySelectorAll('.form-check');
    
    // Make the entire option area clickable
    pollOptions.forEach(function(option) {
        if (!option.querySelector('input:disabled')) {
            option.addEventListener('click', function(e) {
                const radio = this.querySelector('input[type="radio"]');
                if (radio) {
                    radio.checked = true;
                }
            });
            
            // Add hover effect for better UX
            option.addEventListener('mouseover', function() {
                this.style.backgroundColor = 'rgba(0,0,0,0.05)';
            });
            
            option.addEventListener('mouseout', function() {
                this.style.backgroundColor = '';
            });
        }
    });
    
    // Validate form before submission
    const voteForms = document.querySelectorAll('form[action^="/poll/vote/"]');
    voteForms.forEach(function(form) {
        form.addEventListener('submit', function(e) {
            // Skip validation for the "Change My Vote" button form (the one with changeVote input and no radio buttons)
            const isChangeVoteButtonForm = this.querySelector('input[name="changeVote"]') && !this.querySelector('.form-check-input');
            if (isChangeVoteButtonForm) {
                return true;
            }
            
            // For the voting form, require a selection
            const selected = this.querySelector('input[name="optionIndex"]:checked');
            if (!selected) {
                e.preventDefault();
                alert('請選擇一個選項再提交');
                return false;
            }
        });
    });
});
</script>

<!-- 評論區 -->
<div class="card shadow-sm">
    <div class="card-header bg-light">
        <h3 class="h5 mb-0"><i class="fas fa-comments me-2"></i><span data-i18n="commentsDiscussion">Comments</span></h3>
    </div>
    <div class="card-body">
        <c:if test="${not empty poll.comments}">
            <div class="mb-4">
                <c:forEach items="${poll.comments}" var="comment">
                    <div class="d-flex mb-3">
                        <div class="flex-shrink-0">
                            <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" 
                                style="width: 45px; height: 45px;">
                                ${comment.user.fullName.charAt(0)}
                            </div>
                        </div>
                        <div class="ms-3 flex-grow-1">
                            <div class="comment-bubble">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="mb-0">${comment.user.fullName}</h6>
                                    <small class="text-muted">
                                        <span data-i18n="createdAt">Created at</span> <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </small>
                                </div>
                                <p class="mb-0">${comment.content}</p>
                            </div>
                            
                            <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
                                <div class="mt-1 text-end">
                                    <form action="/comment/delete/${comment.id}" method="post" class="d-inline">
                                        <button type="submit" class="btn btn-sm text-danger border-0 bg-transparent">
                                            <i class="fas fa-trash-alt"></i> <span data-i18n="delete">刪除</span>
                                        </button>
                                    </form>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
        
        <!-- 新增評論 -->
        <c:if test="${not empty sessionScope.currentUser}">
            <form action="/comment/add/poll/${poll.id}" method="post">
                <div class="mb-3">
                    <label for="content" class="form-label"><span data-i18n="postComment">Post Comment</span></label>
                    <textarea class="form-control" id="content" name="content" rows="3" placeholder="Write a comment..." data-i18n-placeholder="writeComment" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane me-2"></i><span data-i18n="postComment">Post Comment</span>
                </button>
            </form>
        </c:if>
        
        <c:if test="${empty sessionScope.currentUser && empty poll.comments}">
            <div class="text-center py-4">
                <p class="text-muted mb-0"><span data-i18n="noCommentsYet">目前還沒有評論</span></p>
            </div>
        </c:if>
        
        <c:if test="${empty sessionScope.currentUser && not empty poll.comments}">
            <div class="alert alert-light mt-3">
                <i class="fas fa-info-circle me-2"></i><span data-i18n="loginToComment">請</span><a href="/user/login?redirect=/poll/${poll.id}"><span data-i18n="login">登入</span></a><span data-i18n="afterLoginComment">後參與討論</span>
            </div>
        </c:if>
    </div>
</div>