<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-TW" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - <span data-i18n="courseManagement">課程管理系統</span></title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- 自訂CSS -->
    <link rel="stylesheet" href="/css/style.css">
    
    <!-- Font Awesome 圖標 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <!-- 頁首導航 -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="/">
                <i class="fas fa-graduation-cap me-2"></i><span data-i18n="courseManagement">課程管理系統</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
                <span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse" id="navbarContent">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/"><i class="fas fa-home me-1"></i><span data-i18n="home">首頁</span></a>
                    </li>
                    
                    <c:if test="${not empty sessionScope.currentUser}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="resourcesDropdown" 
                               role="button" data-bs-toggle="dropdown">
                               <i class="fas fa-book me-1"></i><span data-i18n="learningResources">學習資源</span>
                            </a>
                            <ul class="dropdown-menu shadow-sm">
                                <li><a class="dropdown-item" href="/course/list"><span data-i18n="allCourses">所有課程</span></a></li>
                                <li><a class="dropdown-item" href="/poll/list"><span data-i18n="allPolls">所有投票</span></a></li>
                            </ul>
                        </li>
                    </c:if>
                    
                    <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="teacherDropdown" 
                               role="button" data-bs-toggle="dropdown">
                               <i class="fas fa-chalkboard-teacher me-1"></i><span data-i18n="teacherFeatures">教師功能</span>
                            </a>
                            <ul class="dropdown-menu shadow-sm">
                                <li><a class="dropdown-item" href="/course/add"><span data-i18n="addCourse">新增課程</span></a></li>
                                <li><a class="dropdown-item" href="/poll/add"><span data-i18n="createPoll">建立投票</span></a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="/admin"><span data-i18n="adminPanel">管理面板</span></a></li>
                            </ul>
                        </li>
                    </c:if>
                </ul>
                
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <button class="btn btn-sm btn-outline-light me-2" id="themeSwitcher">
                            <i class="fas fa-moon"></i>
                        </button>
                    </li>
                    <li class="nav-item dropdown">
                        <button class="btn btn-sm btn-outline-light me-2" id="languageSwitcher">
                            <i class="fas fa-globe"></i>
                        </button>
                    </li>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.currentUser}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="userDropdown" 
                                   role="button" data-bs-toggle="dropdown">
                                   <i class="fas fa-user-circle me-1"></i>${sessionScope.currentUser.fullName}
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end shadow-sm">
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
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="nav-item">
                                <a href="/user/login" class="btn btn-outline-light me-2">
                                    <i class="fas fa-sign-in-alt me-1"></i><span data-i18n="login">登入</span>
                                </a>
                            </li>
                            <li class="nav-item">
                                <a href="/user/register" class="btn btn-light">
                                    <i class="fas fa-user-plus me-1"></i><span data-i18n="register">註冊</span>
                                </a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>
    </nav>

    <!-- 錯誤或成功訊息顯示區 -->
    <c:if test="${not empty errorMessage}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" data-i18n="close">關閉</button>
        </div>
    </c:if>
    
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close" data-i18n="close">關閉</button>
        </div>
    </c:if>

    <!-- 主要內容區 -->
    <main class="container py-4">
        <c:if test="${not empty contentPage}">
            <jsp:include page="${contentPage}" />
        </c:if>
    </main>

    <!-- 頁尾 -->
    <footer class="bg-dark text-white py-4 mt-5">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5 data-i18n="courseManagement">課程管理系統</h5>
                    <p class="text-muted" data-i18n="qualityLearning">提供最優質的線上學習體驗</p>
                </div>
                <div class="col-md-3">
                    <h5 data-i18n="quickLinks">快速連結</h5>
                    <ul class="list-unstyled">
                        <li><a href="/" class="text-decoration-none text-white-50"><span data-i18n="home">首頁</span></a></li>
                    </ul>
                </div>
                <div class="col-md-3">
                    <h5 data-i18n="contactInfo">聯絡資訊</h5>
                    <address class="text-white-50">
                        <i class="fas fa-map-marker-alt me-2"></i><span data-i18n="hongKong">香港</span><br>
                        <i class="fas fa-envelope me-2"></i><span data-i18n="email">info@example.com</span><br>
                        <i class="fas fa-phone me-2"></i><span data-i18n="phone">(123) 456-7890</span>
                    </address>
                </div>
            </div>
            <hr class="my-4">
            <div class="text-center text-white-50">
                <small>&copy; 2023 <span data-i18n="courseManagement">課程管理系統</span>. <span data-i18n="copyright">保留所有權利</span>.</small>
            </div>
        </div>
    </footer>

    <!-- JavaScript依賴 -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- 自訂JavaScript -->
    <script src="/js/theme-switcher.js"></script>
    <script src="/js/language-switcher.js"></script>
    <script src="/js/app.js"></script>
</body>
</html>