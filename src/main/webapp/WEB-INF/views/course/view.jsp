<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!-- Modern course header with action buttons -->
<div class="course-header mb-4">
    <div class="row align-items-center">
        <div class="col-lg-8 mb-3 mb-lg-0">
            <h1 class="h2 mb-2 fw-bold">${course.title}</h1>
            <div class="d-flex align-items-center text-muted flex-wrap">
                <div class="me-3">
                    <i class="fas fa-calendar-alt me-1"></i> 
                    <span data-i18n="createdAt">建立於</span>
                    <fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd" />
                </div>
                <div class="me-3">
                    <i class="fas fa-file-alt me-1"></i>
                    <span>${course.courseFiles.size()}</span> <span data-i18n="files">個檔案</span>
                </div>
                <div>
                    <i class="fas fa-comments me-1"></i>
                    <span>${course.comments.size()}</span> <span data-i18n="comments">條評論</span>
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
                <div class="d-flex flex-wrap justify-content-lg-end gap-2">
                    <a href="/course/edit/${course.id}" class="btn btn-warning">
                        <i class="fas fa-pencil-alt me-1"></i> <span data-i18n="editCourse">編輯課程</span>
                    </a>
                    <a href="/course/delete/${course.id}" class="btn btn-danger">
                        <i class="fas fa-trash-alt me-1"></i> <span data-i18n="deleteCourse">刪除課程</span>
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<!-- Course content in card-based layout -->
<div class="row">
    <!-- Left column: Description -->
    <div class="col-lg-7 mb-4">
        <div class="card h-100 shadow-sm">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h2 class="h5 mb-0"><i class="fas fa-info-circle me-2"></i><span data-i18n="courseDescription">課程描述</span></h2>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty course.description}">
                        <p class="card-text lead">${course.description}</p>
                    </c:when>
                    <c:otherwise>
                        <div class="text-muted text-center py-4 mb-0">
                            <i class="fas fa-file-alt fa-3x mb-3"></i>
                            <br><span data-i18n="noDescription">暫無描述</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Right column: Files -->
    <div class="col-lg-5 mb-4">
        <div class="card h-100 shadow-sm">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h2 class="h5 mb-0"><i class="fas fa-file-alt me-2"></i><span data-i18n="courseFiles">課程檔案</span></h2>
                <c:if test="${not empty course.courseFiles && course.courseFiles.size() > 0}">
                    <a href="/course/${course.id}/download-all" class="btn btn-sm btn-success">
                        <i class="fas fa-download me-1"></i><span data-i18n="downloadAll">下載全部</span>
                    </a>
                </c:if>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty course.courseFiles}">
                        <div class="list-group list-group-flush">
                            <c:forEach items="${course.courseFiles}" var="file">
                                <div class="list-group-item list-group-item-action border-0 px-0 d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center">
                                        <div class="file-icon me-3 rounded bg-light">
                                            <c:choose>
                                                <c:when test="${file.fileName.toLowerCase().endsWith('.pdf')}">
                                                    <i class="fas fa-file-pdf text-danger"></i>
                                                </c:when>
                                                <c:when test="${file.fileName.toLowerCase().endsWith('.doc') || file.fileName.toLowerCase().endsWith('.docx')}">
                                                    <i class="fas fa-file-word text-primary"></i>
                                                </c:when>
                                                <c:when test="${file.fileName.toLowerCase().endsWith('.ppt') || file.fileName.toLowerCase().endsWith('.pptx')}">
                                                    <i class="fas fa-file-powerpoint text-warning"></i>
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-file text-secondary"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div>
                                            <span class="d-block mb-1">${file.fileName}</span>
                                            <small class="text-muted">
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
                                            </small>
                                        </div>
                                    </div>
                                    <a href="/course/download/${file.filePath}" class="btn btn-sm btn-primary">
                                        <i class="fas fa-download me-1"></i><span data-i18n="download">下載</span>
                                    </a>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="text-muted text-center py-4 mb-0">
                            <i class="fas fa-folder-open fa-3x mb-3"></i>
                            <br><span data-i18n="noFiles">這個課程暫時沒有檔案</span>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Comments section with improved styling -->
<div class="card shadow-sm mt-3">
    <div class="card-header">
        <h2 class="h5 mb-0">
            <i class="fas fa-comments me-2"></i>
            <span data-i18n="commentsSection">評論區</span>
            <span class="badge rounded-pill bg-primary ms-2">${course.comments.size()}</span>
        </h2>
    </div>
    <div class="card-body">
        <!-- New comment form -->
        <c:if test="${not empty sessionScope.currentUser}">
            <div class="mb-4 fade-in">
                <form action="/comment/add/course/${course.id}" method="post" id="commentForm">
                    <div class="d-flex mb-3">
                        <div class="flex-shrink-0">
                            <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" 
                                style="width: 45px; height: 45px;">
                                ${sessionScope.currentUser.fullName.charAt(0)}
                            </div>
                        </div>
                        <div class="ms-3 flex-grow-1">
                            <div class="form-floating">
                                <textarea class="form-control" id="content" name="content" 
                                          style="height: 100px; border-radius: 1rem;" 
                                          placeholder="Write a comment..." data-i18n-placeholder="writeComment" required></textarea>
                                <label for="content"><span data-i18n="writeComment">輸入評論...</span></label>
                            </div>
                            <div class="text-end mt-2">
                                <button type="submit" class="btn btn-primary">
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
                    <c:forEach items="${course.comments}" var="comment">
                        <div class="d-flex ${sessionScope.currentUser.username == comment.user.username ? 'comment-item my-comment' : 'comment-item'} fade-in">
                            <div class="flex-shrink-0 comment-user-avatar">
                                <div class="avatar bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" 
                                    style="width: 45px; height: 45px;">
                                    ${comment.user.fullName.charAt(0)}
                                </div>
                            </div>
                            <div class="flex-grow-1">
                                <div class="comment-bubble ${sessionScope.currentUser.username == comment.user.username ? 'my-comment' : ''}">
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
                                    <p class="mb-0">${comment.content}</p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                        <p class="lead text-muted" data-i18n="noCommentsYet">目前還沒有評論，成為第一個留言的人吧！</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Return to list button -->
<div class="mt-4 text-center">
    <a href="/course/list" class="btn btn-outline-primary">
        <i class="fas fa-arrow-left me-2"></i><span data-i18n="backToCourseList">返回課程列表</span>
    </a>
</div>

<!-- Script for comment form enhancement -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const commentForm = document.getElementById('commentForm');
        if (commentForm) {
            commentForm.addEventListener('submit', function() {
                // Add loading state
                const submitBtn = this.querySelector('button[type="submit"]');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span> 發送中...';
            });
        }

        // Make cards clickable - adds click event to course cards
        const makeCardsClickable = function() {
            const courseCards = document.querySelectorAll('.course-card');
            courseCards.forEach(card => {
                card.style.cursor = 'pointer'; // Change cursor to indicate clickable
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
        };

        // Call the function to make cards clickable
        makeCardsClickable();
    });
</script>