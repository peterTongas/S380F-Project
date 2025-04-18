<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Hero section with animated gradient background -->
<div class="home-banner mb-5">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-7 mb-4 mb-lg-0">
                <h1 class="display-4 fw-bold text-white mb-3 fade-in">
                    <i class="fas fa-graduation-cap me-2"></i>
                    <span data-i18n="welcome">歡迎來到課程管理系統</span>
                </h1>
                <p class="lead text-white-75 mb-4 fade-in" data-i18n="explore">探索課程、參與投票，提升您的學習體驗</p>
                <c:if test="${empty sessionScope.currentUser}">
                    <div class="mt-4 fade-in">
                        <a href="/user/register" class="btn btn-light btn-lg px-4 me-md-3">
                            <i class="fas fa-user-plus me-2"></i><span data-i18n="registerNow">立即註冊</span>
                        </a>
                        <a href="/user/login" class="btn btn-outline-light btn-lg px-4">
                            <i class="fas fa-sign-in-alt me-2"></i><span data-i18n="login">登入</span>
                        </a>
                    </div>
                </c:if>
            </div>
            <div class="col-lg-5 d-none d-lg-block text-center">
                <div class="banner-image">
                    <i class="fas fa-laptop-code fa-5x text-white-50 pulse"></i>
                </div>
            </div>
        </div>
    </div>
</div>

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

<!-- Course section with improved card design -->
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
    
    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <c:choose>
            <c:when test="${not empty courses}">
                <c:forEach items="${courses}" var="course" begin="0" end="5">
                    <div class="col fade-in">
                        <div class="card h-100 course-card shadow-sm">
                            <div class="card-img-top">
                                <c:choose>
                                    <c:when test="${not empty course.courseFiles && course.courseFiles.size() > 0}">
                                        <i class="fas fa-file-alt fa-3x text-primary"></i>
                                    </c:when>
                                    <c:otherwise>
                                        <i class="fas fa-book fa-3x text-secondary"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">${course.title}</h5>
                                <p class="card-text text-truncate">${course.description}</p>
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <small class="text-body-secondary">
                                        <i class="fas fa-calendar-alt me-1"></i>
                                        <fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd" />
                                    </small>
                                </div>
                                <div class="d-flex justify-content-between align-items-center">
                                    <div>
                                        <c:if test="${not empty course.courseFiles}">
                                            <span class="badge bg-light text-dark me-2">
                                                <i class="fas fa-file me-1"></i>${course.courseFiles.size()} <span data-i18n="files">個檔案</span>
                                            </span>
                                        </c:if>
                                        <span class="badge bg-light text-dark">
                                            <i class="fas fa-comments me-1"></i>${course.comments.size()} <span data-i18n="comments">條評論</span>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="card-footer bg-transparent border-top-0">
                                <a href="/course/${course.id}" class="btn btn-primary w-100">
                                    <i class="fas fa-eye me-2"></i><span data-i18n="viewDetails">查看詳情</span>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="alert alert-info">
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
                <c:forEach items="${polls}" var="poll" begin="0" end="3">
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
                                                     style="width: ${empty poll.totalVotes || poll.totalVotes == 0 ? 0 : (option.voteCount / poll.totalVotes) * 100}%" 
                                                     aria-valuenow="${option.voteCount}" aria-valuemin="0" aria-valuemax="100">
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

<!-- Call-to-action section for teachers -->
<c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
    <div class="mt-5 pt-3">
        <div class="card bg-primary text-white shadow">
            <div class="card-body p-4">
                <div class="row align-items-center">
                    <div class="col-lg-8">
                        <h3 class="mb-3"><i class="fas fa-chalkboard-teacher me-2"></i><span data-i18n="teacherTools">教師工具</span></h3>
                        <p class="mb-lg-0" data-i18n="teacherToolsDesc">作為教師，您可以建立新課程、管理現有課程，並創建投票活動。充分利用這些功能，為您的學生提供最佳學習體驗。</p>
                    </div>
                    <div class="col-lg-4 text-lg-end mt-3 mt-lg-0">
                        <a href="/course/add" class="btn btn-light me-2">
                            <i class="fas fa-plus-circle me-1"></i><span data-i18n="addCourse">新增課程</span>
                        </a>
                        <a href="/poll/add" class="btn btn-outline-light">
                            <i class="fas fa-chart-bar me-1"></i><span data-i18n="createPoll">建立投票</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</c:if>

<!-- Login prompt for non-logged users -->
<c:if test="${empty sessionScope.currentUser}">
    <div class="mt-5 pt-4 fade-in" style="animation-delay: 0.6s;">
        <div class="alert border p-4 d-flex align-items-center justify-content-between shadow-sm">
            <div>
                <h4 class="alert-heading mb-2"><i class="fas fa-sign-in-alt me-2"></i><span data-i18n="alreadyMember">已有帳號？</span></h4>
                <p class="mb-0" data-i18n="loginPrompt">登入以獲得個人化的學習體驗、參與討論並存取所有課程內容。</p>
            </div>
            <div class="ms-3">
                <a href="/user/login" class="btn btn-primary">
                    <i class="fas fa-sign-in-alt me-2"></i><span data-i18n="loginNow">立即登入</span>
                </a>
            </div>
        </div>
    </div>
</c:if>

<!-- Make cards clickable script -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Make course cards clickable
        const courseCards = document.querySelectorAll('.course-card');
        courseCards.forEach(card => {
            card.style.cursor = 'pointer'; // Change cursor to pointer to indicate clickable
            card.addEventListener('click', function(e) {
                // Don't trigger if clicking on a button or link inside the card
                if (e.target.tagName === 'BUTTON' || e.target.tagName === 'A' || 
                    e.target.closest('button') || e.target.closest('a')) {
                    return;
                }
                // Get the link from the card footer
                const link = this.querySelector('.card-footer a');
                if (link) {
                    window.location.href = link.getAttribute('href');
                }
            });
        });
        
        // Also make poll cards clickable using the same logic
        const pollCards = document.querySelectorAll('.card:not(.course-card)');
        pollCards.forEach(card => {
            // Only apply to cards with a footer link
            const link = card.querySelector('.card-footer a');
            if (!link) return;
            
            card.style.cursor = 'pointer';
            card.addEventListener('click', function(e) {
                if (e.target.tagName === 'BUTTON' || e.target.tagName === 'A' || 
                    e.target.closest('button') || e.target.closest('a')) {
                    return;
                }
                
                window.location.href = link.getAttribute('href');
            });
        });
    });
</script>