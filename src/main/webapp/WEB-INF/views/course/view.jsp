<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Hero banner for course with gradient background -->
<div class="course-hero position-relative mb-5 overflow-hidden">
    <div class="course-hero-bg"></div>
    <div class="container position-relative py-5">
        <div class="row">
            <div class="col-lg-8">
                <nav aria-label="breadcrumb" class="mb-3">
                    <ol class="breadcrumb breadcrumb-light">
                        <li class="breadcrumb-item"><a href="/"><i class="fas fa-home"></i></a></li>
                        <li class="breadcrumb-item"><a href="/course/list" data-i18n="courses">課程</a></li>
                        <li class="breadcrumb-item active" aria-current="page">${course.title}</li>
                    </ol>
                </nav>
                
                <h1 class="display-5 fw-bold text-white mb-3">${course.title}</h1>
                
                <div class="d-flex flex-wrap gap-4 text-white-50 mb-4">
                    <div class="d-flex align-items-center">
                        <span class="badge badge-light-primary rounded-pill">
                            <i class="fas fa-calendar-alt me-1"></i>
                            <fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd" />
                        </span>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="badge badge-light-primary rounded-pill">
                            <i class="fas fa-file-alt me-1"></i>
                            ${course.courseFiles.size()} <span data-i18n="files">個檔案</span>
                        </span>
                    </div>
                    <div class="d-flex align-items-center">
                        <span class="badge badge-light-primary rounded-pill">
                            <i class="fas fa-comments me-1"></i>
                            ${course.comments.size()} <span data-i18n="comments">條評論</span>
                        </span>
                    </div>
                </div>
                
                <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
                    <div class="d-flex flex-wrap gap-2 mt-4">
                        <a href="/course/edit/${course.id}" class="btn btn-warning">
                            <i class="fas fa-pencil-alt me-2"></i> <span data-i18n="editCourse">編輯課程</span>
                        </a>
                        <a href="/course/delete/${course.id}" class="btn btn-danger">
                            <i class="fas fa-trash-alt me-2"></i> <span data-i18n="deleteCourse">刪除課程</span>
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!-- Course content with tabs for better organization -->
    <div class="row">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-header bg-white border-0 p-4">
                    <ul class="nav nav-tabs card-header-tabs" id="courseTab" role="tablist">
                        <li class="nav-item" role="presentation">
                            <button class="nav-link active" id="description-tab" data-bs-toggle="tab" data-bs-target="#description" 
                                    type="button" role="tab" aria-controls="description" aria-selected="true">
                                <i class="fas fa-info-circle me-2"></i><span data-i18n="description">描述</span>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="files-tab" data-bs-toggle="tab" data-bs-target="#files" 
                                    type="button" role="tab" aria-controls="files" aria-selected="false">
                                <i class="fas fa-file-alt me-2"></i><span data-i18n="materials">教材</span>
                                <span class="badge rounded-pill bg-primary ms-1">${course.courseFiles.size()}</span>
                            </button>
                        </li>
                        <li class="nav-item" role="presentation">
                            <button class="nav-link" id="comments-tab" data-bs-toggle="tab" data-bs-target="#comments" 
                                    type="button" role="tab" aria-controls="comments" aria-selected="false">
                                <i class="fas fa-comments me-2"></i><span data-i18n="discussions">討論</span>
                                <span class="badge rounded-pill bg-primary ms-1">${course.comments.size()}</span>
                            </button>
                        </li>
                    </ul>
                </div>
                <div class="card-body p-4">
                    <div class="tab-content" id="courseTabContent">
                        <!-- Description Tab -->
                        <div class="tab-pane fade show active" id="description" role="tabpanel" aria-labelledby="description-tab">
                            <c:choose>
                                <c:when test="${not empty course.description}">
                                    <div class="course-description">
                                        <h3 class="h4 mb-4" data-i18n="aboutCourse">關於本課程</h3>
                                        <div class="lead mb-4">${course.description}</div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <div class="empty-state">
                                            <i class="fas fa-file-alt fa-4x text-muted mb-3"></i>
                                            <h3 class="h5 text-muted" data-i18n="noDescription">暫無課程描述</h3>
                                            <p class="text-muted" data-i18n="checkMaterials">請查看課程教材獲取更多信息</p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Files Tab -->
                        <div class="tab-pane fade" id="files" role="tabpanel" aria-labelledby="files-tab">
                            <h3 class="h4 mb-4" data-i18n="courseMaterials">課程教材</h3>
                            
                            <c:choose>
                                <c:when test="${not empty course.courseFiles}">
                                    <div class="mb-3 d-flex justify-content-between align-items-center">
                                        <div>
                                            <span class="badge bg-secondary me-2">${course.courseFiles.size()}</span>
                                            <span data-i18n="availableFiles">個可用文件</span>
                                        </div>
                                        <c:if test="${course.courseFiles.size() > 1}">
                                            <a href="/course/${course.id}/download-all" class="btn btn-sm btn-outline-primary">
                                                <i class="fas fa-download me-2"></i><span data-i18n="downloadAll">下載全部</span>
                                            </a>
                                        </c:if>
                                    </div>

                                    <div class="file-cards">
                                        <div class="row g-3">
                                            <c:forEach items="${course.courseFiles}" var="file">
                                                <div class="col-md-6">
                                                    <div class="card h-100 file-card border-0">
                                                        <div class="card-body d-flex align-items-center p-3">
                                                            <div class="file-icon flex-shrink-0 ${file.fileName.toLowerCase().endsWith('.pdf') ? 'file-pdf' : 
                                                                                    file.fileName.toLowerCase().endsWith('.doc') || file.fileName.toLowerCase().endsWith('.docx') ? 'file-word' :
                                                                                    file.fileName.toLowerCase().endsWith('.ppt') || file.fileName.toLowerCase().endsWith('.pptx') ? 'file-powerpoint' : 'file-generic'}">
                                                                <c:choose>
                                                                    <c:when test="${file.fileName.toLowerCase().endsWith('.pdf')}">
                                                                        <i class="fas fa-file-pdf"></i>
                                                                    </c:when>
                                                                    <c:when test="${file.fileName.toLowerCase().endsWith('.doc') || file.fileName.toLowerCase().endsWith('.docx')}">
                                                                        <i class="fas fa-file-word"></i>
                                                                    </c:when>
                                                                    <c:when test="${file.fileName.toLowerCase().endsWith('.ppt') || file.fileName.toLowerCase().endsWith('.pptx')}">
                                                                        <i class="fas fa-file-powerpoint"></i>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <i class="fas fa-file"></i>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div class="ms-3 file-info flex-grow-1">
                                                                <h5 class="card-title file-name mb-1">${file.fileName}</h5>
                                                                <p class="card-text file-size mb-0 text-muted">
                                                                    <c:choose>
                                                                        <c:when test="${file.fileSize < 1024}">
                                                                            ${file.fileSize} B
                                                                        </c:when>
                                                                        <c:when test="${file.fileSize < 1024 * 1024}">
                                                                            <fmt:formatNumber value="${file.fileSize / 1024}" maxFractionDigits="1" /> KB
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <fmt:formatNumber value="${file.fileSize / 1024 / 1024}" maxFractionDigits="1" /> MB
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </p>
                                                            </div>
                                                            <div class="ms-auto">
                                                                <a href="/course/download/${file.filePath}" class="btn btn-sm btn-primary download-btn">
                                                                    <i class="fas fa-download"></i>
                                                                </a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-5">
                                        <div class="empty-state">
                                            <i class="fas fa-folder-open fa-4x text-muted mb-3"></i>
                                            <h3 class="h5 text-muted" data-i18n="noFiles">這個課程暫時沒有檔案</h3>
                                            <p class="text-muted" data-i18n="checkLater">請稍後再查看，或聯繫教師了解更多信息</p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <!-- Comments/Discussion Tab -->
                        <div class="tab-pane fade" id="comments" role="tabpanel" aria-labelledby="comments-tab">
                            <h3 class="h4 mb-4" data-i18n="discussions">課程討論區</h3>
                            
                            <!-- New comment form -->
                            <c:if test="${not empty sessionScope.currentUser}">
                                <div class="mb-4 comment-form-container">
                                    <form action="/comment/add/course/${course.id}" method="post" id="commentForm" class="comment-form">
                                        <div class="d-flex">
                                            <div class="flex-shrink-0">
                                                <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center">
                                                    ${sessionScope.currentUser.fullName.charAt(0)}
                                                </div>
                                            </div>
                                            <div class="ms-3 flex-grow-1">
                                                <div class="form-floating mb-3">
                                                    <textarea class="form-control" id="content" name="content" 
                                                            style="height: 100px; border-radius: 0.75rem;" 
                                                            placeholder="Share your thoughts..." data-i18n-placeholder="writeComment" required></textarea>
                                                    <label for="content"><span data-i18n="writeComment">分享您的想法...</span></label>
                                                </div>
                                                <div class="text-end">
                                                    <button type="submit" class="btn btn-primary px-4">
                                                        <i class="fas fa-paper-plane me-2"></i><span data-i18n="postComment">發表評論</span>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </div>
                                <hr class="my-4">
                            </c:if>
                            
                            <!-- Comments listing -->
                            <div id="comments-list">
                                <c:choose>
                                    <c:when test="${not empty course.comments}">
                                        <div class="comments-container">
                                            <c:forEach items="${course.comments}" var="comment">
                                                <div class="comment-item ${sessionScope.currentUser.username == comment.user.username ? 'comment-item-own' : ''} fade-in mb-4">
                                                    <div class="d-flex">
                                                        <div class="flex-shrink-0">
                                                            <div class="avatar ${sessionScope.currentUser.username == comment.user.username ? 'bg-primary' : 'bg-secondary'} text-white rounded-circle d-flex align-items-center justify-content-center">
                                                                ${comment.user.fullName.charAt(0)}
                                                            </div>
                                                        </div>
                                                        <div class="flex-grow-1 ms-3">
                                                            <div class="comment-bubble">
                                                                <div class="d-flex justify-content-between align-items-center mb-2">
                                                                    <div>
                                                                        <h6 class="mb-0 fw-bold">${comment.user.fullName}</h6>
                                                                        <small class="text-muted">
                                                                            <fmt:formatDate value="${comment.createdAt}" pattern="yyyy-MM-dd HH:mm" />
                                                                        </small>
                                                                    </div>
                                                                    <c:if test="${sessionScope.currentUser.role == 'TEACHER' || sessionScope.currentUser.username == comment.user.username}">
                                                                        <div class="dropdown">
                                                                            <button class="btn btn-sm btn-icon" type="button" data-bs-toggle="dropdown" aria-expanded="false">
                                                                                <i class="fas fa-ellipsis-v"></i>
                                                                            </button>
                                                                            <ul class="dropdown-menu dropdown-menu-end">
                                                                                <li>
                                                                                    <form action="/comment/delete/${comment.id}" method="post">
                                                                                        <button type="submit" class="dropdown-item text-danger">
                                                                                            <i class="fas fa-trash-alt me-2"></i><span data-i18n="delete">刪除</span>
                                                                                        </button>
                                                                                    </form>
                                                                                </li>
                                                                            </ul>
                                                                        </div>
                                                                    </c:if>
                                                                </div>
                                                                <div class="comment-content">
                                                                    <p class="mb-0">${comment.content}</p>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <div class="empty-state">
                                                <i class="fas fa-comments fa-4x text-muted mb-3"></i>
                                                <h3 class="h5 text-muted" data-i18n="noCommentsYet">目前還沒有評論</h3>
                                                <p class="text-muted" data-i18n="beFirstToComment">成為第一個留言的人吧！</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Sidebar -->
        <div class="col-lg-4">
            <!-- Course Actions Card -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body p-4">
                    <h5 class="card-title mb-3" data-i18n="courseActions">課程操作</h5>
                    <div class="d-grid gap-2">
                        <a href="/course/list" class="btn btn-outline-primary">
                            <i class="fas fa-arrow-left me-2"></i><span data-i18n="backToCourses">返回課程列表</span>
                        </a>
                        <c:if test="${not empty course.courseFiles}">
                            <a href="/course/${course.id}/download-all" class="btn btn-outline-success">
                                <i class="fas fa-download me-2"></i><span data-i18n="downloadAllMaterials">下載全部教材</span>
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
            
            <!-- Course Information Card -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body p-4">
                    <h5 class="card-title mb-3" data-i18n="courseInfo">課程信息</h5>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                            <span data-i18n="creationDate">創建日期</span>
                            <span class="badge bg-light text-dark">
                                <fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd" />
                            </span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                            <span data-i18n="fileCount">文件數量</span>
                            <span class="badge bg-primary">${course.courseFiles.size()}</span>
                        </li>
                        <li class="list-group-item d-flex justify-content-between align-items-center px-0">
                            <span data-i18n="commentsCount">評論數量</span>
                            <span class="badge bg-primary">${course.comments.size()}</span>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Custom styling for the course detail page -->
<style>
    /* Hero banner styling */
    .course-hero {
        background-color: #2193b0;
        color: white;
        min-height: 280px;
        display: flex;
        align-items: center;
        border-radius: 0 0 30px 30px;
    }
    
    .course-hero-bg {
        position: absolute;
        top: 0;
        right: 0;
        bottom: 0;
        left: 0;
        background: linear-gradient(135deg, #2193b0, #6dd5ed);
        opacity: 1;
        z-index: 0;
    }
    
    .breadcrumb-light .breadcrumb-item, 
    .breadcrumb-light .breadcrumb-item a {
        color: rgba(255, 255, 255, 0.8);
    }
    
    .breadcrumb-light .breadcrumb-item.active {
        color: white;
    }
    
    .breadcrumb-light .breadcrumb-item+.breadcrumb-item::before {
        color: rgba(255, 255, 255, 0.6);
    }
    
    /* Badge styling */
    .badge-light-primary {
        background-color: rgba(255, 255, 255, 0.2);
        color: white;
        font-weight: normal;
        padding: 0.5rem 1rem;
    }
    
    /* File cards styling */
    .file-cards .card {
        transition: all 0.3s ease;
        box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
    }
    
    .file-cards .card:hover {
        transform: translateY(-3px);
        box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
    }
    
    .file-icon {
        width: 45px;
        height: 45px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
    }
    
    .file-pdf {
        background-color: rgba(234, 84, 85, 0.1);
        color: #ea5455;
    }
    
    .file-word {
        background-color: rgba(13, 110, 253, 0.1);
        color: #0d6efd;
    }
    
    .file-powerpoint {
        background-color: rgba(255, 159, 67, 0.1);
        color: #ff9f43;
    }
    
    .file-generic {
        background-color: rgba(108, 117, 125, 0.1);
        color: #6c757d;
    }
    
    .download-btn {
        opacity: 0.8;
        transition: all 0.3s ease;
    }
    
    .file-card:hover .download-btn {
        opacity: 1;
    }
    
    /* Comment styling */
    .avatar {
        width: 45px;
        height: 45px;
    }
    
    .comment-bubble {
        background-color: #f8f9fa;
        padding: 1rem;
        border-radius: 0.75rem;
        position: relative;
    }
    
    .comment-item-own .comment-bubble {
        background-color: #e7f5ff;
    }
    
    .comment-content {
        line-height: 1.5;
    }
    
    /* Empty state styling */
    .empty-state {
        padding: 2rem;
    }
    
    /* Tab styling */
    .nav-tabs .nav-link {
        color: #6c757d;
        padding: 0.75rem 1rem;
        border: none;
        border-bottom: 2px solid transparent;
        transition: all 0.3s ease;
    }
    
    .nav-tabs .nav-link.active, 
    .nav-tabs .nav-link:hover {
        color: #2193b0;
        background: transparent;
        border-bottom: 2px solid #2193b0;
    }
    
    .tab-content {
        padding-top: 1.5rem;
    }
</style>

<!-- Script for tab activation and comment form enhancement -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Comment form enhancement
        const commentForm = document.getElementById('commentForm');
        if (commentForm) {
            commentForm.addEventListener('submit', function() {
                // Add loading state
                const submitBtn = this.querySelector('button[type="submit"]');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> 發送中...';
            });
        }
        
        // Allow linking directly to specific tabs using URL hash
        if (window.location.hash) {
            const hash = window.location.hash.substring(1);
            const tabTrigger = document.querySelector(`#${hash}-tab`);
            if (tabTrigger) {
                const tab = new bootstrap.Tab(tabTrigger);
                tab.show();
            }
        }
        
        // Update URL when tab changes
        const tabs = document.querySelectorAll('button[data-bs-toggle="tab"]');
        tabs.forEach(tab => {
            tab.addEventListener('shown.bs.tab', function(event) {
                const id = event.target.id.replace('-tab', '');
                history.replaceState(null, null, `#${id}`);
            });
        });
    });
</script>