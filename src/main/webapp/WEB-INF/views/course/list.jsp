<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h1 class="mb-4"><i class="fas fa-book me-2"></i><span data-i18n="allCoursesTitle">所有課程</span></h1>

<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
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
                                <i class="fas fa-file me-1"></i>${course.courseFiles.size()} <span data-i18n="filesCount">個檔案</span>
                            </small>
                        </c:if>
                        <small class="text-body-secondary">
                            <i class="fas fa-comments me-1"></i>${course.comments.size()} <span data-i18n="commentsCount">條評論</span>
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

<c:if test="${empty courses}">
    <div class="alert alert-info">
        <i class="fas fa-info-circle me-2"></i><span data-i18n="noCoursesYet">目前還沒有任何課程。</span>
    </div>
</c:if>
