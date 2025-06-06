<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="mb-4"><i class="fas fa-poll me-2"></i>所有投票</h1>

<div class="row g-4">
    <c:forEach items="${polls}" var="poll">
        <div class="col-md-6">
            <div class="card h-100 shadow-sm">
                <div class="card-body">
                    <h5 class="card-title">${poll.question}</h5>
                    <div class="mt-3">
                        <c:forEach items="${poll.options}" var="option">
                            <div class="poll-option">
                                <div class="poll-progress">
                                    <div class="progress-bar bg-primary" role="progressbar" 
                                         style="width: ${poll.totalVotes > 0 ? (option.voteCount * 100 / poll.totalVotes) : 0}%" 
                                         aria-valuenow="${option.voteCount}" aria-valuemin="0" 
                                         aria-valuemax="${poll.totalVotes}">
                                    </div>
                                    <span class="poll-option-text">${option.text}</span>
                                    <span class="poll-option-count">${option.voteCount} 票</span>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="mt-3 text-muted">
                        <small><i class="fas fa-calendar-alt me-1"></i>
                            <fmt:formatDate value="${poll.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                        </small>
                        <small class="ms-3"><i class="fas fa-comments me-1"></i>${poll.comments.size()} 條評論</small>
                        <small class="ms-3"><i class="fas fa-chart-bar me-1"></i>${poll.totalVotes} 總票數</small>
                    </div>
                </div>
                <div class="card-footer bg-transparent border-top-0">
                    <a href="/poll/${poll.id}" class="btn btn-primary w-100">
                        <i class="fas fa-vote-yea me-2"></i>查看詳情
                    </a>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<c:if test="${empty polls}">
    <div class="alert alert-info">
        <i class="fas fa-info-circle me-2"></i>目前還沒有任何投票。
    </div>
</c:if>

<c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
    <div class="mt-4">
        <a href="/poll/add" class="btn btn-success">
            <i class="fas fa-plus-circle me-2"></i>建立新投票
        </a>
    </div>
</c:if>
