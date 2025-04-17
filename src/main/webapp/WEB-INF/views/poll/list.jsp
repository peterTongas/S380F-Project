<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="mb-4"><i class="fas fa-poll me-2"></i><span data-i18n="allPolls">所有投票</span></h1>

<div class="row g-4">
    <c:forEach items="${polls}" var="poll">
        <div class="col-md-6 fade-in">
            <div class="card h-100 shadow-sm">
                <div class="card-header bg-transparent">
                    <h5 class="card-title mb-0">${poll.question}</h5>
                </div>
                <div class="card-body">
                    <div>
                        <c:forEach items="${poll.options}" var="option" varStatus="status">
                            <div class="poll-option">
                                <div class="poll-progress">
                                    <div class="progress-bar ${status.index % 4 == 0 ? 'bg-primary' : status.index % 4 == 1 ? 'bg-success' : status.index % 4 == 2 ? 'bg-warning' : 'bg-info'}" 
                                         role="progressbar" 
                                         style="width: ${poll.totalVotes > 0 ? (option.voteCount * 100 / poll.totalVotes) : 0}%" 
                                         aria-valuenow="${option.voteCount}" aria-valuemin="0" 
                                         aria-valuemax="${poll.totalVotes}">
                                    </div>
                                </div>
                                <span class="poll-option-text">${option.text}</span>
                                <span class="poll-option-count">${option.voteCount} <span data-i18n="votes">票</span></span>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mt-3 text-muted">
                        <small><i class="fas fa-users me-1"></i>${poll.totalVotes} <span data-i18n="totalVotes">總票數</span></small>
                        <small><i class="fas fa-comments me-1"></i>${poll.comments.size()} <span data-i18n="commentsCount">條評論</span></small>
                    </div>
                </div>
                <div class="card-footer bg-transparent">
                    <a href="/poll/${poll.id}" class="btn btn-primary w-100">
                        <i class="fas fa-vote-yea me-2"></i><span data-i18n="viewDetails">查看詳情</span>
                    </a>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<c:if test="${empty polls}">
    <div class="alert alert-info">
        <i class="fas fa-info-circle me-2"></i><span data-i18n="noPolls">目前還沒有任何投票。</span>
    </div>
</c:if>

<c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
    <div class="mt-4">
        <a href="/poll/add" class="btn btn-success">
            <i class="fas fa-plus-circle me-2"></i><span data-i18n="createNewPoll">建立新投票</span>
        </a>
    </div>
</c:if>
