<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h2><span data-i18n="MyCommentHistory" >My Comment History</span></h2>

<c:choose>
  <c:when test="${not empty comments}">
    <div class="list-group">
      <c:forEach items="${comments}" var="comment">
        <div class="list-group-item">
          <div class="d-flex w-100 justify-content-between">
            <h5 class="mb-1">
              <c:choose>
                <c:when test="${not empty comment.courseMaterial}">
                  On: ${comment.courseMaterial.title}
                </c:when>
                <c:when test="${not empty comment.poll}">
                  On: ${comment.poll.question}
                </c:when>
              </c:choose>
            </h5>
            <small>
              <fmt:formatDate value="${comment.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
            </small>
          </div>
          <p class="mb-1">${comment.content}</p>
          <c:if test="${not empty comment.courseMaterial}">
            <a href="/course/${comment.courseMaterial.id}" class="btn btn-sm btn-outline-primary"><span data-i18n="ViewCourse">View Course</span></a>
          </c:if>
          <c:if test="${not empty comment.poll}">
            <a href="/poll/${comment.poll.id}" class="btn btn-sm btn-outline-primary"><spam data-i18n="ViewPoll">View Poll</spam></a>
          </c:if>
        </div>
      </c:forEach>
    </div>
  </c:when>
  <c:otherwise>
    <div class="alert alert-info"><span data-i18n="noCommentHistory">You haven't posted any comments yet.</span></div>
  </c:otherwise>
</c:choose>