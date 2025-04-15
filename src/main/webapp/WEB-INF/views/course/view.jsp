<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>${course.title}</h2>

<!-- 文件下載區 -->
<div class="card mb-4">
    <div class="card-header d-flex justify-content-between align-items-center">
        <span>課程檔案</span>
        <!-- 批量下載按鈕 -->
        <c:if test="${not empty course.courseFiles}">
            <a href="/course/${course.id}/download-all" class="btn btn-primary btn-sm">
                <i class="bi bi-download"></i> 下載所有檔案
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
                                <span class="badge bg-info">${file.fileSize / 1024} KB</span>
                                <!-- 單個文件下載按鈕 -->
                                <a href="/course/download/${file.filePath.substring(file.filePath.lastIndexOf('/') + 1)}" 
                                   class="btn btn-outline-primary btn-sm ms-2">
                                    <i class="bi bi-download"></i> 下載
                                </a>
                                <c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
                                    <form style="display: inline;" action="/course/${course.id}/file/delete/${file.id}" method="post">
                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-trash"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <p class="text-muted">此課程暫無檔案</p>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- 課程描述 -->
<div class="card mb-4">
  <div class="card-header">
    <h5 class="card-title mb-0">課程描述</h5>
  </div>
  <div class="card-body">
    <p class="card-text">${course.description != null ? course.description : "暫無描述"}</p>

    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
      <a href="/course/edit/${course.id}" class="btn btn-sm btn-warning">
        <i class="bi bi-pencil"></i> 編輯課程
      </a>
    </c:if>
  </div>
</div>

<!-- 評論區塊 -->
<h3 class="mt-4">評論區</h3>
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
          <button type="submit" class="btn btn-sm btn-danger">刪除評論</button>
        </form>
      </c:if>
    </div>
  </div>
</c:forEach>

<!-- 新增評論表單 -->
<c:if test="${not empty sessionScope.currentUser}">
  <form action="/comment/add/course/${course.id}" method="post" class="mt-3">
    <div class="mb-3">
      <textarea name="content" class="form-control" placeholder="發表評論..." required></textarea>
    </div>
    <button type="submit" class="btn btn-primary">發布評論</button>
  </form>
</c:if>