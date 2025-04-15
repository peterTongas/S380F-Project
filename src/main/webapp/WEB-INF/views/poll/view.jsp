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
                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
            </div>
        </c:if>
        
        <c:choose>
            <c:when test="${hasVoted && not empty sessionScope.currentUser}">
                <div class="alert alert-info mb-4">
                    <i class="fas fa-info-circle me-2"></i>您已對此投票進行了投票
                </div>
                
                <h4 class="mb-3">投票結果</h4>
                <div class="mb-4">
                    <c:forEach items="${poll.options}" var="option" varStatus="loop">
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
                                ${option.voteCount} (${empty poll.totalVotes || poll.totalVotes == 0 ? 0 : Math.round((option.voteCount / poll.totalVotes) * 100)}%)
                            </span>
                        </div>
                    </c:forEach>
                    
                    <p class="text-muted mt-3">
                        <small><i class="fas fa-users me-1"></i>總投票數: ${poll.totalVotes}</small>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <form action="/poll/vote/${poll.id}" method="post" class="mb-4">
                    <div class="mb-3">
                        <label class="form-label">選擇一個選項:</label>
                        <c:forEach items="${poll.options}" var="option" varStatus="loop">
                            <div class="form-check mb-2">
                                <input class="form-check-input" type="radio" name="optionIndex" 
                                       id="option${loop.index}" value="${loop.index}" required>
                                <label class="form-check-label" for="option${loop.index}">
                                    ${option.text}
                                </label>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <c:if test="${not empty sessionScope.currentUser}">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-vote-yea me-2"></i>提交投票
                        </button>
                    </c:if>
                    
                    <c:if test="${empty sessionScope.currentUser}">
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>請先登入才能投票
                            <a href="/user/login?redirect=/poll/${poll.id}" class="btn btn-sm btn-outline-primary ms-3">
                                <i class="fas fa-sign-in-alt me-1"></i>登入
                            </a>
                        </div>
                    </c:if>
                </form>
            </c:otherwise>
        </c:choose>
        
        <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
            <div class="mt-4 d-flex justify-content-end">
                <form action="/poll/delete/${poll.id}" method="post" onsubmit="return confirm('確定要刪除此投票？');">
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-trash-alt me-2"></i>刪除投票
                    </button>
                </form>
            </div>
        </c:if>
    </div>
</div>

<!-- 評論區 -->
<div class="card shadow-sm">
    <div class="card-header bg-light">
        <h3 class="h5 mb-0"><i class="fas fa-comments me-2"></i>評論討論</h3>
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
                                        <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                    </small>
                                </div>
                                <p class="mb-0">${comment.content}</p>
                            </div>
                            
                            <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
                                <div class="mt-1 text-end">
                                    <form action="/comment/delete/${comment.id}" method="post" class="d-inline">
                                        <button type="submit" class="btn btn-sm text-danger border-0 bg-transparent">
                                            <i class="fas fa-trash-alt"></i> 刪除
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
                    <label for="content" class="form-label">新增評論</label>
                    <textarea class="form-control" id="content" name="content" rows="3" required></textarea>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane me-2"></i>提交評論
                </button>
            </form>
        </c:if>
        
        <c:if test="${empty sessionScope.currentUser && empty poll.comments}">
            <div class="text-center py-4">
                <p class="text-muted mb-0">目前還沒有評論</p>
            </div>
        </c:if>
        
        <c:if test="${empty sessionScope.currentUser && not empty poll.comments}">
            <div class="alert alert-light mt-3">
                <i class="fas fa-info-circle me-2"></i>請<a href="/user/login?redirect=/poll/${poll.id}">登入</a>後參與討論
            </div>
        </c:if>
    </div>
</div>