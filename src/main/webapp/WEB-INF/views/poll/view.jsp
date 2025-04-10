<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>${poll.question}</h2>

<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<c:choose>
    <c:when test="${empty sessionScope.currentUser}">
        <div class="alert alert-warning">請登入後參與投票</div>
        <!-- 顯示目前投票結果 -->
        <div class="list-group mb-3">
            <c:forEach items="${poll.options}" var="option">
                <div class="list-group-item">
                    ${option.text} (票數: ${option.voteCount})
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:when test="${hasVoted}">
        <div class="alert alert-info">您已經參與過此投票</div>
        <!-- 顯示投票結果 -->
        <div class="list-group mb-3">
            <c:forEach items="${poll.options}" var="option">
                <div class="list-group-item">
                    ${option.text} (票數: ${option.voteCount})
                </div>
            </c:forEach>
        </div>
    </c:when>
    <c:otherwise>
        <form action="/poll/vote/${poll.id}" method="post">
            <div class="list-group mb-3">
                <c:forEach items="${poll.options}" var="option" varStatus="loop">
                    <label class="list-group-item">
                        <input class="form-check-input me-1" type="radio"
                               name="optionIndex" value="${loop.index}" required>
                            ${option.text} (票數: ${option.voteCount})
                    </label>
                </c:forEach>
            </div>
            <button type="submit" class="btn btn-primary">提交投票</button>
        </form>
    </c:otherwise>
</c:choose>

<h3 class="mt-4">評論</h3>
<c:forEach items="${poll.comments}" var="comment">
    <div class="card mb-2">
        <div class="card-body">
            <h5 class="card-title">${comment.user.fullName}</h5>
            <p class="card-text">${comment.content}</p>
            <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
                <form action="/comment/delete/${comment.id}" method="post">
                    <button type="submit" class="btn btn-sm btn-danger">刪除</button>
                </form>
            </c:if>
        </div>
    </div>
</c:forEach>

<c:if test="${not empty sessionScope.currentUser}">
    <form action="/comment/add/poll/${poll.id}" method="post" class="mt-3">
        <div class="mb-3">
            <textarea name="content" class="form-control" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">新增評論</button>
    </form>
</c:if>