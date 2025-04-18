<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh-TW" data-bs-theme="dark" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Course Management System - Learn, interact, and grow with our online learning platform">
    <title>My Online Course Website</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<!-- Sidebar Navigation -->
<nav id="sidebar" class="sidebar">
    <div class="sidebar-header d-flex justify-content-between align-items-center">
        <a class="navbar-brand d-flex align-items-center" href="/">
            <i class="fas fa-laptop-code me-2"></i><span data-i18n="courseManagement">課程管理系統</span>
        </a>
        <button class="btn btn-link d-lg-none text-white" id="close-sidebar">
            <i class="fas fa-times"></i>
        </button>
    </div>

    <div class="px-3 py-2">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link ${pageContext.request.requestURI == '/' ? 'active' : ''}" href="/">
                    <i class="fas fa-home me-2"></i><span data-i18n="home">首頁</span>
                </a>
            </li>

            <c:if test="${not empty sessionScope.currentUser}">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#resourcesSubmenu" data-bs-toggle="collapse" role="button" aria-expanded="false">
                        <i class="fas fa-book me-2"></i><span data-i18n="learningResources">學習資源</span>
                    </a>
                    <ul class="collapse list-unstyled" id="resourcesSubmenu">
                        <li>
                            <a class="nav-link ms-3" href="/course/list">
                                <i class="fas fa-list me-2"></i><span data-i18n="allCourses">所有課程</span>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link ms-3" href="/poll/list">
                                <i class="fas fa-poll me-2"></i><span data-i18n="allPolls">所有投票</span>
                            </a>
                        </li>
                    </ul>
                </li>
            </c:if>

            <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#teacherSubmenu" data-bs-toggle="collapse" role="button" aria-expanded="false">
                        <i class="fas fa-chalkboard-teacher me-2"></i><span data-i18n="teacherFeatures">教師功能</span>
                    </a>
                    <ul class="collapse list-unstyled" id="teacherSubmenu">
                        <li>
                            <a class="nav-link ms-3" href="/course/add">
                                <i class="fas fa-plus-circle me-2"></i><span data-i18n="addCourse">新增課程</span>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link ms-3" href="/poll/add">
                                <i class="fas fa-chart-bar me-2"></i><span data-i18n="createPoll">建立投票</span>
                            </a>
                        </li>
                        <li>
                            <a class="nav-link ms-3" href="/admin">
                                <i class="fas fa-shield-alt me-2"></i><span data-i18n="adminPanel">管理面板</span>
                            </a>
                        </li>
                    </ul>
                </li>
            </c:if>

            <li class="nav-item mt-2">
                <hr class="dropdown-divider bg-secondary">
            </li>
        </ul>

        <div class="d-flex justify-content-around my-3">
            <button class="btn btn-outline-secondary" id="themeSwitcher" aria-label="Toggle dark/light mode">
                <i class="fas fa-sun"></i>
            </button>
            <button class="btn btn-outline-secondary" id="languageSwitcher" aria-label="Change language">
                <i class="fas fa-globe"></i>
            </button>
        </div>
    </div>

    <div class="sidebar-footer mt-auto">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <div class="d-flex align-items-center mb-3">
                    <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2"
                         style="width: 42px; height: 42px;">
                            ${sessionScope.currentUser.fullName.charAt(0)}
                    </div>
                    <div>
                        <div class="fw-bold">${sessionScope.currentUser.fullName}</div>
                        <small class="text-muted">${sessionScope.currentUser.role}</small>
                    </div>
                </div>

                <div class="list-group list-group-flush">
                    <a href="/user/profile" class="list-group-item list-group-item-action bg-transparent border-0 text-white-50">
                        <i class="fas fa-id-card me-2"></i><span data-i18n="profile">個人資料</span>
                    </a>
                    <a href="/user/comment-history" class="list-group-item list-group-item-action bg-transparent border-0 text-white-50">
                        <i class="fas fa-comments me-2"></i><span data-i18n="myComments">我的評論</span>
                    </a>
                    <a href="/user/vote-history" class="list-group-item list-group-item-action bg-transparent border-0 text-white-50">
                        <i class="fas fa-poll me-2"></i><span data-i18n="myVotes">我的投票</span>
                    </a>
                    <a href="/user/logout" class="list-group-item list-group-item-action bg-transparent border-0 text-white-50">
                        <i class="fas fa-sign-out-alt me-2"></i><span data-i18n="logout">登出</span>
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-grid gap-2">
                    <a href="/user/login" class="btn btn-outline-light">
                        <i class="fas fa-sign-in-alt me-1"></i><span data-i18n="login">登入</span>
                    </a>
                    <a href="/user/register" class="btn btn-primary">
                        <i class="fas fa-user-plus me-1"></i><span data-i18n="register">註冊</span>
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<!-- Mobile toggle button -->
<button id="sidebar-toggle" class="btn btn-primary sidebar-toggle d-lg-none">
    <i class="fas fa-bars"></i>
</button>

<!-- Main content -->
<div class="content-wrapper">
    <div class="alert-container">
        <!-- Sidebar Toggle Button (placed outside of sidebar) -->
        <button id="sidebarToggleButton" class="btn btn-primary m-3" aria-label="Toggle Sidebar">
            <i class="fas fa-bars"></i>
        </button>
    </div>

    <!-- Page content -->
    <jsp:include page="${contentPage}" />
</div>

<!-- Footer -->
<footer class="footer text-center">
    <p>&copy; 2025 My Online Course Website</p>
</footer>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/js/layout.js"></script>
<!-- Custom JavaScript -->
<script src="/js/theme-switcher.js"></script>
<script src="/js/language-switcher.js"></script>
<script src="/js/app.js"></script>

</body>
</html>
