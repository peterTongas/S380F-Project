<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>${poll.question}</h2>

<form action="/poll/vote/${poll.id}" method="post">
    <div class="list-group mb-3">
        <c:forEach items="${poll.options}" var="option" varStatus="loop">
            <label class="list-group-item">
                <input class="form-check-input me-1" type="radio"
                       name="optionIndex" value="${loop.index}">
                    ${option.text} (Votes: ${option.voteCount})
            </label>
        </c:forEach>
    </div>

    <c:if test="${not empty sessionScope.currentUser}">
        <button type="submit" class="btn btn-primary">Submit Vote</button>
    </c:if>
</form>

<h3 class="mt-4">Comments</h3>
<c:forEach items="${poll.comments}" var="comment">
    <div class="card mb-2">
        <div class="card-body">
            <h5 class="card-title">${comment.user.fullName}</h5>
            <p class="card-text">${comment.content}</p>
        </div>
    </div>
</c:forEach>

<c:if test="${not empty sessionScope.currentUser}">
    <form action="/comment/add/poll/${poll.id}" method="post" class="mt-3">
        <div class="mb-3">
            <textarea name="content" class="form-control" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Add Comment</button>
    </form>
</c:if>