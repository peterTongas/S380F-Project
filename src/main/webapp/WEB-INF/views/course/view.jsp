<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>${course.title}</h2>

<!-- 文件下載區 -->
<div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span data-i18n="courseFiles">Course Files</span>
        <!-- 批量下載按鈕 -->
        <c:if test="${not empty course.courseFiles}">
            <a href="/course/${course.id}/download-all" class="btn btn-primary btn-sm">
                <i class="bi bi-download"></i> <span data-i18n="downloadAllFiles">Download All Files</span>
            </a>
        </c:if>
    </div>
    <div class="card-body">
        <c:choose>
            <c:when test="${not empty course.courseFiles}">
                <ul class="list-group">
                    <c:forEach items="${course.courseFiles}" var="file">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span>${file.fileName}</span>
                            <div>
                                <span class="badge bg-info">${file.fileSize / 1024} <span data-i18n="kb">KB</span></span>
                                <!-- 單個文件下載按鈕 -->
                                <a href="/course/download/${file.filePath.substring(file.filePath.lastIndexOf('/') + 1)}" 
                                   class="btn btn-outline-primary btn-sm ms-2">
                                    <i class="bi bi-download"></i> <span data-i18n="download">Download</span>
                                </a>
                                <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
                                    <form style="display: inline;" action="/course/${course.id}/file/delete/${file.id}" method="post">
                                        <button type="submit" class="btn btn-outline-danger btn-sm" onclick="return confirm(confirmDeleteFileMessage)">
                                            <i class="bi bi-trash"></i> <span data-i18n="delete">刪除</span>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p class="text-muted"><span data-i18n="noFiles">此課程暫無檔案</span></p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 課程描述 -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="card-title mb-0"><span data-i18n="courseDescription">Course Description</span></h5>
  </div>
  <div class="card-body">
    <p class="card-text">${course.description != null ? course.description : '<span data-i18n="noDescription">暫無描述</span>'}</p>

    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
      <div class="d-flex mt-3">
        <a href="/course/edit/${course.id}" class="btn btn-warning me-2">
          <i class="fas fa-pencil-alt me-1"></i> <span data-i18n="editCourse">編輯課程</span>
        </a>
        <a href="/course/delete/${course.id}" class="btn btn-danger">
          <i class="fas fa-trash-alt me-1"></i> <span data-i18n="deleteCourse">刪除課程</span>
        </a>
      </div>
    </c:if>
  </div>
</div>

<!-- 評論區塊 -->
<h3 class="mt-4"><span data-i18n="commentsSection">Comments</span></h3>
<c:forEach items="${course.comments}" var="comment">
  <div class="card mb-2">
    <div class="card-body">
      <h5 class="card-title">${comment.user.fullName}</h5>
      <p class="card-text">${comment.content}</p>
      <small class="text-muted">
          ${comment.createdAt}
      </small>
      <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
        <form action="/comment/delete/${comment.id}" method="post" class="mt-2">
          <button type="submit" class="btn btn-sm btn-danger">
            <span data-i18n="deleteComment">刪除評論</span>
          </button>
        </form>
      </c:if>
    </div>
  </div>
</c:forEach>

<!-- 新增評論表單 -->
<c:if test="${not empty sessionScope.currentUser}">
  <form action="/comment/add/course/${course.id}" method="post" class="mt-3">
    <div class="mb-3">
      <textarea name="content" class="form-control" placeholder="Write a comment..." data-i18n-placeholder="writeComment" required></textarea>
    </div>
    <button type="submit" class="btn btn-primary">
      <span data-i18n="postComment">發布評論</span>
    </button>
  </form>
</c:if>

<c:if test="${empty sessionScope.currentUser}">
    <div class="alert alert-light mt-3">
        <i class="fas fa-info-circle me-2"></i>
        <span data-i18n="loginToComment">請</span>
        <a href="/user/login?redirect=/course/${course.id}">
            <span data-i18n="login">登入</span>
        </a>
        <span data-i18n="afterLoginComment">後參與討論</span>
    </div>
</c:if>

<script>
    const confirmDeleteFileMessage = '確定要刪除此檔案？';
</script>