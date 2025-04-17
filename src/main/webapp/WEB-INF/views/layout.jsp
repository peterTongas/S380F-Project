<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-TW" data-bs-theme="light" class="h-100">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Course Management System - Learn, interact, and grow with our online learning platform">
    <title>${pageTitle} - <span data-i18n="courseManagement">課程管理系統</span></title>
    
    <!-- Modern Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Custom CSS -->
    <link rel="stylesheet" href="/css/style.css">
    
    <!-- Theme color for mobile devices -->
    <meta name="theme-color" content="#4361ee">
</head>
<body class="d-flex flex-column h-100">
    <!-- Skip to main content link for accessibility -->
    <a href="#main-content" class="visually-hidden-focusable">Skip to main content</a>
    
    <!-- Header Navigation -->
    <header>
        <nav class="navbar navbar-expand-lg navbar-dark sticky-top shadow-sm">
            <div class="container">
                <a class="navbar-brand d-flex align-items-center" href="/">
                    <i class="fas fa-graduation-cap me-2"></i><span data-i18n="courseManagement">課程管理系統</span>
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent" 
                    aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                
                <div class="collapse navbar-collapse" id="navbarContent">
                    <ul class="navbar-nav me-auto">
                        <li class="nav-item">
                            <a class="nav-link" href="/" aria-current="${pageContext.request.requestURI == '/' ? 'page' : 'false'}">
                                <i class="fas fa-home me-1"></i><span data-i18n="home">首頁</span>
                            </a>
                        </li>
                        
                        <c:if test="${not empty sessionScope.currentUser}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="resourcesDropdown" 
                                   role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                   <i class="fas fa-book me-1"></i><span data-i18n="learningResources">學習資源</span>
                                </a>
                                <ul class="dropdown-menu shadow" aria-labelledby="resourcesDropdown">
                                    <li><a class="dropdown-item" href="/course/list"><i class="fas fa-list me-2"></i><span data-i18n="allCourses">所有課程</span></a></li>
                                    <li><a class="dropdown-item" href="/poll/list"><i class="fas fa-poll me-2"></i><span data-i18n="allPolls">所有投票</span></a></li>
                                </ul>
                            </li>
                        </c:if>
                        
                        <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="teacherDropdown" 
                                   role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                   <i class="fas fa-chalkboard-teacher me-1"></i><span data-i18n="teacherFeatures">教師功能</span>
                                </a>
                                <ul class="dropdown-menu shadow" aria-labelledby="teacherDropdown">
                                    <li><a class="dropdown-item" href="/course/add"><i class="fas fa-plus-circle me-2"></i><span data-i18n="addCourse">新增課程</span></a></li>
                                    <li><a class="dropdown-item" href="/poll/add"><i class="fas fa-chart-bar me-2"></i><span data-i18n="createPoll">建立投票</span></a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="/admin"><i class="fas fa-shield-alt me-2"></i><span data-i18n="adminPanel">管理面板</span></a></li>
                                </ul>
                            </li>
                        </c:if>
                    </ul>
                    
                    <div class="d-flex align-items-center">
                        <!-- Theme Switcher -->
                        <button class="btn btn-icon me-2" id="themeSwitcher" aria-label="Toggle dark/light mode">
                            <i class="fas fa-moon"></i>
                        </button>
                        
                        <!-- Language Switcher -->
                        <button class="btn btn-icon me-3" id="languageSwitcher" aria-label="Change language">
                            <i class="fas fa-globe"></i>
                        </button>
                        
                        <c:choose>
                            <c:when test="${not empty sessionScope.currentUser}">
                                <!-- User Dropdown Menu -->
                                <div class="dropdown">
                                    <a class="btn btn-outline-light dropdown-toggle d-flex align-items-center" href="#" 
                                       id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                       <div class="avatar bg-light text-primary rounded-circle d-flex align-items-center justify-content-center me-2" 
                                            style="width: 32px; height: 32px;">
                                            ${sessionScope.currentUser.fullName.charAt(0)}
                                       </div>
                                       <span class="d-none d-md-inline">${sessionScope.currentUser.fullName}</span>
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="userDropdown">
                                        <li><a class="dropdown-item" href="/user/profile">
                                            <i class="fas fa-id-card me-2"></i><span data-i18n="profile">個人資料</span>
                                        </a></li>
                                        <li><a class="dropdown-item" href="/user/comment-history">
                                            <i class="fas fa-comments me-2"></i><span data-i18n="myComments">我的評論</span>
                                        </a></li>
                                        <li><a class="dropdown-item" href="/user/vote-history">
                                            <i class="fas fa-poll me-2"></i><span data-i18n="myVotes">我的投票</span>
                                        </a></li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li><a class="dropdown-item" href="/user/logout">
                                            <i class="fas fa-sign-out-alt me-2"></i><span data-i18n="logout">登出</span>
                                        </a></li>
                                    </ul>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Login/Register Buttons -->
                                <a href="/user/login" class="btn btn-outline-light me-2">
                                    <i class="fas fa-sign-in-alt me-1"></i><span data-i18n="login">登入</span>
                                </a>
                                <a href="/user/register" class="btn btn-light">
                                    <i class="fas fa-user-plus me-1"></i><span data-i18n="register">註冊</span>
                                </a>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </nav>
    </header>

    <!-- Alert Messages -->
    <div class="alert-container fixed-top w-100 d-flex justify-content-center pt-3" style="z-index: 1050; pointer-events: none;">
        <div class="container" style="max-width: 600px;">
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert" style="pointer-events: auto;">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-exclamation-circle me-2"></i>
                        <div>${errorMessage}</div>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close" data-i18n="close">關閉</button>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert" style="pointer-events: auto;">
                    <div class="d-flex align-items-center">
                        <i class="fas fa-check-circle me-2"></i>
                        <div>${successMessage}</div>
                        <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert" aria-label="Close" data-i18n="close">關閉</button>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Main Content Area -->
    <main id="main-content" class="flex-shrink-0 py-4">
        <div class="container">
            <c:if test="${not empty contentPage}">
                <div class="fade-in">
                    <jsp:include page="${contentPage}" />
                </div>
            </c:if>
        </div>
    </main>

    <!-- Modern Footer with Social Links -->
    <footer class="footer mt-auto">
        <div class="container">
            <div class="row">
                <div class="col-lg-5 mb-4 mb-lg-0">
                    <h5 data-i18n="courseManagement">課程管理系統</h5>
                    <p class="text-muted mb-4" data-i18n="qualityLearning">提供最優質的線上學習體驗</p>
                </div>
                <div class="col-md-3 col-lg-2 mb-4 mb-md-0">
                    <h5 data-i18n="quickLinks">快速連結</h5>
                    <ul class="list-unstyled footer-links">
                        <li><a href="/" class="footer-link"><i class="fas fa-home me-2"></i><span data-i18n="home">首頁</span></a></li>
                        <li><a href="/course/list" class="footer-link"><i class="fas fa-book me-2"></i><span data-i18n="allCourses">所有課程</span></a></li>
                        <li><a href="/poll/list" class="footer-link"><i class="fas fa-poll me-2"></i><span data-i18n="allPolls">所有投票</span></a></li>
                    </ul>
                </div>
                <div class="col-md-4 col-lg-3">
                    <h5 data-i18n="contactInfo">聯絡資訊</h5>
                    <ul class="list-unstyled footer-contact">
                        <li><i class="fas fa-map-marker-alt me-2"></i><span data-i18n="hongKong">Hong Kong Metropolitan University</span></li>
                        <li><i class="fas fa-envelope me-2"></i><span data-i18n="myemail">https://www.hkmu.edu.hk/</span></li>
                        <li><i class="fas fa-phone me-2"></i><span data-i18n="phone">(852) 2711 2100</span></li>
                    </ul>
                </div>
            </div>
            <hr class="my-4">
            <div class="text-center">
                <small class="text-muted">&copy; 2025 <span data-i18n="courseManagement">課程管理系統</span>. <span data-i18n="copyright">保留所有權利</span>.</small>
            </div>
        </div>
    </footer>

    <!-- JavaScript Dependencies -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script src="/js/theme-switcher.js"></script>
    <script src="/js/language-switcher.js"></script>
    <script src="/js/app.js"></script>
    
    <!-- Accessibility Enhancement Script -->
    <script>
        // Add keyboard focus class to body when tab is used
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Tab') {
                document.body.classList.add('keyboard-navigation');
            }
        });
        
        // Remove class when mouse is used
        document.addEventListener('mousedown', function() {
            document.body.classList.remove('keyboard-navigation');
        });
        
        // Auto-dismiss alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert-dismissible');
                alerts.forEach(function(alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        });
    </script>
</body>
</html>