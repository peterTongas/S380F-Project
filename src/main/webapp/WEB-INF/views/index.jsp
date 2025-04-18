<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Hero section with redesigned background and visual elements -->
<div class="home-banner mb-5 position-relative overflow-hidden">
    <!-- Animated background elements -->
    <div class="banner-animated-bg">
        <div class="animated-circle circle-1"></div>
        <div class="animated-circle circle-2"></div>
        <div class="animated-shape shape-1"></div>
        <div class="animated-shape shape-2"></div>
        <div class="animated-shape shape-3"></div>
    </div>
    
    <div class="container position-relative" style="z-index: 10;">
        <div class="row align-items-center">
            <div class="col-lg-12 text-center">
                <div class="banner-content">
                    <h1 class="display-3 fw-bold text-white mb-4 fade-in">
                        <span data-i18n="welcome">歡迎來到課程管理系統</span>
                    </h1>
                    
                    <c:if test="${empty sessionScope.currentUser}">
                        <div class="mt-5 fade-in d-flex justify-content-center gap-4">
                            <a href="/user/register" class="btn btn-light btn-lg px-5 py-2 rounded-pill shadow">
                                <span data-i18n="registerNow">立即註冊</span>
                            </a>
                            <a href="/user/login" class="btn btn-outline-light btn-lg px-5 py-2 rounded-pill border-2">
                                <span data-i18n="login">登入</span>
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Add animation styles for the banner -->
<style>
    .home-banner {
        background: linear-gradient(135deg, #2193b0, #6dd5ed);
        padding: 7rem 0;
        border-radius: 0 0 50px 50px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.12);
        position: relative;
        overflow: hidden;
    }

    .banner-animated-bg {
        position: absolute;
        width: 100%;
        height: 100%;
        top: 0;
        left: 0;
        background-image:
            radial-gradient(circle at 20% 20%, rgba(255, 255, 255, 0.2) 0%, transparent 40%),
            radial-gradient(circle at 80% 80%, rgba(255, 255, 255, 0.15) 0%, transparent 40%);
    }

    .animated-circle {
        position: absolute;
        border-radius: 50%;
        opacity: 0.25;
    }

    .circle-1 {
        width: 400px;
        height: 400px;
        background: rgba(255,255,255,0.1);
        top: -150px;
        left: -150px;
        animation: float 12s infinite ease-in-out;
    }

    .circle-2 {
        width: 300px;
        height: 300px;
        background: rgba(255,255,255,0.15);
        bottom: -100px;
        right: 5%;
        animation: float 15s infinite ease-in-out reverse;
    }

    .animated-shape {
        position: absolute;
        opacity: 0.2;
    }

    .shape-1 {
        width: 150px;
        height: 150px;
        background: rgba(255,255,255,0.2);
        transform: rotate(45deg);
        top: 15%;
        right: -50px;
        animation: spin 30s infinite linear;
    }

    .shape-2 {
        width: 100px;
        height: 100px;
        border: 3px solid rgba(255,255,255,0.3);
        transform: rotate(20deg);
        bottom: 15%;
        left: 15%;
        animation: spin 20s infinite linear reverse;
    }

    .shape-3 {
        width: 80px;
        height: 80px;
        background: rgba(255,255,255,0.25);
        border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
        top: 30%;
        left: 20%;
        animation: morphing 15s infinite ease-in-out alternate;
    }

    .banner-content {
        animation: fadeUp 1.2s ease-out;
    }

    @keyframes morphing {
        0% { border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%; }
        25% { border-radius: 58% 42% 75% 25% / 76% 46% 54% 24%; }
        50% { border-radius: 50% 50% 33% 67% / 55% 27% 73% 45%; }
        75% { border-radius: 33% 67% 58% 42% / 63% 68% 32% 37%; }
        100% { border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%; }
    }

    @keyframes float {
        0%, 100% { transform: translateY(0) rotate(0deg); }
        50% { transform: translateY(-25px) rotate(2deg); }
    }

    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }

    @keyframes fadeUp {
        from { opacity: 0; transform: translateY(30px); }
        to { opacity: 1; transform: translateY(0); }
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    .btn {
        transition: all 0.3s ease;
    }

    .btn:hover {
        transform: translateY(-3px);
    }

    .btn-light {
        background: rgba(255, 255, 255, 0.9);
    }
</style>

<!-- Dashboard stats for logged in users -->
<c:if test="${not empty sessionScope.currentUser}">
    <div class="row g-4 mb-5">
        <div class="col-md-4 fade-in" style="animation-delay: 0.1s;">
            <div class="card border-0 h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="display-4 text-primary mb-3">
                        <i class="fas fa-book-open"></i>
                    </div>
                    <h3 class="card-title h5 fw-bold">${courses.size()}</h3>
                    <p class="card-text text-muted"><span data-i18n="availableCourses">可用課程</span></p>
                </div>
            </div>
        </div>
        <div class="col-md-4 fade-in" style="animation-delay: 0.2s;">
            <div class="card border-0 h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="display-4 text-primary mb-3">
                        <i class="fas fa-chart-bar"></i>
                    </div>
                    <h3 class="card-title h5 fw-bold">${polls.size()}</h3>
                    <p class="card-text text-muted"><span data-i18n="activePolls">進行中的投票</span></p>
                </div>
            </div>
        </div>
        <div class="col-md-4 fade-in" style="animation-delay: 0.3s;">
            <div class="card border-0 h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="display-4 text-primary mb-3">
                        <i class="fas fa-users"></i>
                    </div>
                    <h3 class="card-title h5 fw-bold">${sessionScope.currentUser.role}</h3>
                    <p class="card-text text-muted"><span data-i18n="accountType">帳戶類型</span></p>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- Course section with improved list design -->
<div class="mb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0 d-flex align-items-center">
            <i class="fas fa-book me-2"></i>
            <span data-i18n="latestCourses">最新課程</span>
            <span class="ms-2 badge rounded-pill bg-primary">${courses.size()}</span>
        </h2>
        <a href="/course/list" class="btn btn-outline-primary btn-sm">
            <span data-i18n="viewAll">檢視全部</span>
            <i class="fas fa-arrow-right ms-2"></i>
        </a>
    </div>
    
    <div class="list-group shadow-sm">
        <c:choose>
            <c:when test="${not empty courses}">
                <c:forEach items="${courses}" var="course" begin="0" end="5">
                    <a href="/course/${course.id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center p-3 fade-in">
                        <div class="d-flex align-items-center">
                            <div class="me-3 fs-4">
                                <c:choose>
                                    <c:when test="${not empty course.courseFiles && course.courseFiles.size() > 0}">
                                        <i class="fas fa-file-alt text-primary"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-book text-secondary"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <h5 class="mb-1">${course.title}</h5>
                                <p class="mb-1 text-muted text-truncate">${course.description}</p>
                                <div class="d-flex align-items-center small text-muted">
                                    <span class="me-3">
                                        <i class="fas fa-calendar-alt me-1"></i>
                                        <fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd" />
                                    </span>
                                    <c:if test="${not empty course.courseFiles}">
                                        <span class="me-3">
                                            <i class="fas fa-file me-1"></i>${course.courseFiles.size()} <span data-i18n="files">個檔案</span>
                                        </span>
                                    </c:if>
                                    <span>
                                        <i class="fas fa-comments me-1"></i>${course.comments.size()} <span data-i18n="comments">條評論</span>
                                    </span>
                                </div>
                            </div>
                        </div>
                        <div>
                            <span class="btn btn-sm btn-primary">
                                <i class="fas fa-eye"></i> <span data-i18n="viewDetails">查看詳情</span>
                            </span>
                        </div>
                    </a>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="list-group-item">
                    <div class="alert alert-info mb-0">
                        <i class="fas fa-info-circle me-2"></i><span data-i18n="noCoursesYet">目前還沒有任何課程。</span>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Polls section with interactive visual elements -->
<div>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0 d-flex align-items-center">
            <i class="fas fa-poll me-2"></i>
            <span data-i18n="latestPolls">最新投票</span>
            <span class="ms-2 badge rounded-pill bg-primary">${polls.size()}</span>
        </h2>
        <a href="/poll/list" class="btn btn-outline-primary btn-sm">
            <span data-i18n="viewAll">檢視全部</span>
            <i class="fas fa-arrow-right ms-2"></i>
        </a>
    </div>
    
    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty polls}">
                <c:forEach items="${polls}" var="poll" begin="0" end="3" varStatus="pollStatus">
                    <div class="col-md-6 fade-in">
                        <div class="card h-100 shadow-sm">
                            <div class="card-header bg-transparent">
                                <h5 class="card-title mb-0">${poll.question}</h5>
                            </div>
                            <div class="card-body">
                                
                                <!-- Options legend -->
                                <div class="mt-2">
                                    <c:forEach items="${poll.options}" var="option" varStatus="status">
                                        <div class="d-flex align-items-center mb-1">
                                            <div class="me-2" style="width: 12px; height: 12px; background-color: ${status.index % 4 == 0 ? 'rgba(13, 110, 253, 0.8)' : status.index % 4 == 1 ? 'rgba(25, 135, 84, 0.8)' : status.index % 4 == 2 ? 'rgba(255, 193, 7, 0.8)' : 'rgba(13, 202, 240, 0.8)'}; border-radius: 50%;"></div>
                                            <div class="small text-truncate me-auto">${option.text}</div>
                                            <div class="small ms-2">${option.voteCount} <span data-i18n="votes">票</span></div>
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
                                    <i class="fas fa-vote-yea me-2"></i><span data-i18n="voteNow">立即投票</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i><span data-i18n="noPollsYet">目前還沒有任何投票。</span>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- JavaScript for creating poll charts on the index page -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    <c:forEach items="${polls}" var="poll" begin="0" end="3" varStatus="pollStatus">
        // Get poll data
        const pollLabels${pollStatus.index} = [<c:forEach items="${poll.options}" var="option" varStatus="status">'${option.text}'<c:if test="${!status.last}">, </c:if></c:forEach>];
        const pollData${pollStatus.index} = [<c:forEach items="${poll.options}" var="option" varStatus="status">${option.voteCount}<c:if test="${!status.last}">, </c:if></c:forEach>];
        
        // Create chart
        const ctx${pollStatus.index} = document.getElementById('indexPollChart${pollStatus.index}').getContext('2d');
        new Chart(ctx${pollStatus.index}, {
            type: 'line',
            data: {
                labels: pollLabels${pollStatus.index},
                datasets: [{
                    label: '投票數',
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