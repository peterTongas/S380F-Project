<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="mb-4"><i class="fas fa-poll me-2"></i><span data-i18n="allPolls">所有投票</span></h1>

<div class="row g-4">
    <c:forEach items="${polls}" var="poll" varStatus="pollStatus">
        <div class="col-md-6 fade-in">
            <div class="card h-100 shadow-sm">
                <div class="card-header bg-transparent">
                    <h5 class="card-title mb-0">${poll.question}</h5>
                </div>
                <div class="card-body">
                    <!-- Options legend -->
                    <div class="mt-3">
                        <c:forEach items="${poll.options}" var="option" varStatus="status">
                            <div class="d-flex align-items-center mb-2">
                                <div class="me-2" style="width: 14px; height: 14px; background-color: ${status.index % 4 == 0 ? 'rgba(13, 110, 253, 0.8)' : status.index % 4 == 1 ? 'rgba(25, 135, 84, 0.8)' : status.index % 4 == 2 ? 'rgba(255, 193, 7, 0.8)' : 'rgba(13, 202, 240, 0.8)'}; border-radius: 50%;"></div>
                                <div class="small text-truncate me-auto">${option.text}</div>
                                <div class="small ms-2 fw-bold">${option.voteCount} <span data-i18n="votes">票</span></div>
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

<!-- JavaScript to create line charts -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    <c:forEach items="${polls}" var="poll" varStatus="pollStatus">
        // Get poll data
        const pollLabels${pollStatus.index} = [<c:forEach items="${poll.options}" var="option" varStatus="status">'${option.text}'<c:if test="${!status.last}">, </c:if></c:forEach>];
        const pollData${pollStatus.index} = [<c:forEach items="${poll.options}" var="option" varStatus="status">${option.voteCount}<c:if test="${!status.last}">, </c:if></c:forEach>];
        
        // Create chart
        const ctx${pollStatus.index} = document.getElementById('pollChart${pollStatus.index}').getContext('2d');
        new Chart(ctx${pollStatus.index}, {
            type: 'line',
            data: {
                labels: pollLabels${pollStatus.index},
                datasets: [{
                    label: '得票數',
                    data: pollData${pollStatus.index},
                    borderColor: 'rgb(75, 192, 192)',
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderWidth: 2,
                    tension: 0.3,
                    pointBackgroundColor: 'rgb(75, 192, 192)',
                    pointBorderColor: '#fff',
                    pointBorderWidth: 1,
                    pointRadius: 5,
                    pointHoverRadius: 7,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            precision: 0
                        }
                    }
                }
            }
        });
    </c:forEach>
});
</script>
