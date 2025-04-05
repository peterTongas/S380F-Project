<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>${course.title}</h2>
<a href="${course.filePath}" class="btn btn-primary mb-3">Download Notes</a>


<!-- Display comments -->
<h3>Comments</h3>
<c:forEach var="comment" items="${course.comments}">
  <div>
    <strong>${comment.user.fullName}</strong>: ${comment.content}
    <c:if test="${isTeacher}">
      <form action="/comment/delete/${comment.id}" method="post">
        <button type="submit">Delete</button>
      </form>
    </c:if>
  </div>
</c:forEach>

<!-- Add comment form -->
<h3>Add a Comment</h3>
<form action="/comment/course/${course.id}" method="post">
  <textarea name="content" placeholder="Write a comment..." required></textarea>
  <button type="submit">Submit</button>
</form>

<c:if test="${sessionScope.currentUser.role == 'TEACHER'}">
  <form action="/course/delete/${course.id}" method="post">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    <button type="submit" class="btn btn-danger"
            onclick="return confirm('Are you sure you want to delete this course?')">
      Delete Course
    </button>
  </form>
</c:if>