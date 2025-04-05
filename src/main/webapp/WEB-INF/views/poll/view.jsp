<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>${poll.question}</h2>
<form action="/poll/vote/${poll.id}" method="post">
    <c:forEach items="${poll.options}" var="option" varStatus="loop">
        <div class="form-check mb-2">
            <input class="form-check-input" type="radio" name="optionIndex"
                   id="option${loop.index}" value="${loop.index}">
            <label class="form-check-label" for="option${loop.index}">
                    ${option.text} (Votes: ${option.voteCount})
            </label>
        </div>
    </c:forEach>
    <c:if test="${not empty sessionScope.currentUser}">
        <button type="submit" class="btn btn-primary">Submit Vote</button>
    </c:if>
</form>
<!-- Display comments -->
<h3>Comments</h3>
<c:forEach var="comment" items="${poll.comments}">
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
<form action="/comment/poll/${poll.id}" method="post">
    <textarea name="content" placeholder="Write a comment..." required></textarea>
    <button type="submit">Submit</button>
</form>
<%--<h3 class="mt-4">Comments</h3>--%>
<%--<!-- Similar comment section as course/view.jsp -->--%>
<%--<c:if test="${sessionScope.currentUser.role == 'TEACHER'}">--%>
<%--    <form action="<c:url value='/poll/delete/${poll.id}'/>" method="post" class="mt-3">--%>
<%--        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>--%>
<%--        <button type="submit" class="btn btn-danger"--%>
<%--                onclick="return confirm('Are you sure you want to delete this poll?')">--%>
<%--            Delete Poll--%>
<%--        </button>--%>
<%--    </form>--%>
<%--</c:if>--%>