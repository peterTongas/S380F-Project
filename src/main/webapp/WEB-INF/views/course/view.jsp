<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>${course.title}</h2>
<a href="/course/download/${course.filePath}" class="btn btn-primary mb-3">
  <i class="bi bi-download"></i> Download Notes
</a>
<div class="card mb-4">
  <div class="card-body">
    <h5 class="card-title">Description</h5>
    <p class="card-text">${course.description}</p>

    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
      <a href="/course/edit/${course.id}" class="btn btn-sm btn-warning">
        <i class="bi bi-pencil"></i> Edit Content
      </a>
    </c:if>
  </div>
</div>


<h3 class="mt-4">Comments</h3>
<c:forEach items="${course.comments}" var="comment">
  <div class="card mb-2">
    <div class="card-body">
      <h5 class="card-title">${comment.user.fullName}</h5>
      <p class="card-text">${comment.content}</p>
      <small class="text-muted">
          ${comment.createdAt} <!-- Add timestamp field to Comment entity -->
      </small>
      <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
        <form action="/comment/delete/${comment.id}" method="post" class="mt-2">
          <button type="submit" class="btn btn-sm btn-danger">Delete</button>
        </form>
      </c:if>
    </div>
  </div>
</c:forEach>

<c:if test="${not empty sessionScope.currentUser}">
  <form action="/comment/add/course/${course.id}" method="post" class="mt-3">
    <div class="mb-3">
      <textarea name="content" class="form-control" placeholder="Add a comment..." required></textarea>
    </div>
    <button type="submit" class="btn btn-primary">Post Comment</button>
  </form>
</c:if>