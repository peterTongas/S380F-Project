<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h1 class="mb-4"><i class="fas fa-book me-2"></i><span data-i18n="allCoursesTitle">所有課程</span></h1>

<div class="list-group shadow-sm mb-4">
    <c:forEach items="${courses}" var="course">
        <a href="/course/${course.id}" class="list-group-item list-group-item-action d-flex justify-content-between align-items-center p-3 fade-in">
            <div class="d-flex align-items-center flex-grow-1">
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
                <div class="flex-grow-1">
                    <h5 class="mb-1">${course.title}</h5>
                    <p class="mb-1 text-muted text-truncate">${course.description}</p>
                    <div class="d-flex align-items-center small text-muted flex-wrap">
                        <span class="me-3">
                            <i class="fas fa-calendar-alt me-1"></i>
                            <fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd" />
                        </span>
                        <c:if test="${not empty course.courseFiles}">
                            <span class="me-3">
                                <i class="fas fa-file me-1"></i>${course.courseFiles.size()} <span data-i18n="filesCount">個檔案</span>
                            </span>
                        </c:if>
                        <span>
                            <i class="fas fa-comments me-1"></i>${course.comments.size()} <span data-i18n="commentsCount">條評論</span>
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
    
    <c:if test="${empty courses}">
        <div class="list-group-item">
            <div class="alert alert-info mb-0">
                <i class="fas fa-info-circle me-2"></i><span data-i18n="noCoursesYet">目前還沒有任何課程。</span>
            </div>
        </div>
    </c:if>
</div>

<c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
    <div class="mt-3">
        <a href="/course/add" class="btn btn-success">
            <i class="fas fa-plus-circle me-2"></i><span data-i18n="createNewCourse">建立新課程</span>
        </a>
    </div>
</c:if>