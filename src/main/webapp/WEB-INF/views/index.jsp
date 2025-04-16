<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 首頁橫幅 -->
<div class="bg-primary text-white py-5 mb-5 rounded-3 shadow">
    <div class="container">
        <h1 class="display-5 fw-bold"><i class="fas fa-graduation-cap me-2"></i><span data-i18n="welcome">歡迎來到課程管理系統</span></h1>
        <p class="fs-4" data-i18n="explore">探索課程、參與投票，提升您的學習體驗</p>
        <c:if test="${empty sessionScope.currentUser}">
            <div class="mt-4">
                <a href="/user/register" class="btn btn-light btn-lg px-4 me-md-2">
                    <i class="fas fa-user-plus me-2"></i><span data-i18n="registerNow">立即註冊</span>
                </a>
                <a href="/user/login" class="btn btn-outline-light btn-lg px-4">
                    <i class="fas fa-sign-in-alt me-2"></i><span data-i18n="login">登入</span>
                </a>
            </div>
        </c:if>
    </div>
</div>

<!-- 課程區段 -->
<h2 class="mb-4"><i class="fas fa-book me-2"></i><span data-i18n="latestCourses">最新課程</span></h2>
<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4 mb-5">
    <c:forEach items="${courses}" var="course">
        <div class="col">
            <div class="card h-100 shadow-sm course-card">
                <c:choose>
                    <c:when test="${not empty course.courseFiles && course.courseFiles.size() > 0}">
                        <div class="card-img-top bg-light d-flex align-items-center justify-content-center p-3">
                            <i class="fas fa-file-alt fa-4x text-primary"></i>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="card-img-top bg-light d-flex align-items-center justify-content-center p-3">
                            <i class="fas fa-book fa-4x text-secondary"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="card-body">
                    <h5 class="card-title">${course.title}</h5>
                    <p class="card-text text-truncate">${course.description}</p>
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <c:if test="${not empty course.courseFiles}">
                            <small class="text-body-secondary">
                                <i class="fas fa-file me-1"></i>${course.courseFiles.size()} <span data-i18n="files">個檔案</span>
                            </small>
                        </c:if>
                        <small class="text-body-secondary">
                            <i class="fas fa-comments me-1"></i>${course.comments.size()} <span data-i18n="comments">條評論</span>
                        </small>
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
</div>

<!-- 投票區段 -->
<h2 class="mb-4"><i class="fas fa-poll me-2"></i><span data-i18n="latestPolls">最新投票</span></h2>
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
                                         style="width: ${empty poll.totalVotes || poll.totalVotes == 0 ? 0 : (option.voteCount / poll.totalVotes) * 100}%" 
                                         aria-valuenow="${option.voteCount}" aria-valuemin="0" aria-valuemax="100"></div>
                                </div>
                                <span class="poll-option-text">${option.text}</span>
                                <span class="poll-option-count">${option.voteCount}</span>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <div class="card-footer bg-transparent border-top-0 text-center">
                    <a href="/poll/${poll.id}" class="btn btn-outline-primary">
                        <i class="fas fa-vote-yea me-2"></i><span data-i18n="participate">參與投票</span>
                    </a>
                </div>
            </div>
        </div>
    </c:forEach>
</div>