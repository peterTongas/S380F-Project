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

<h3 class="mt-4">Comments</h3>
<!-- Similar comment section as course/view.jsp -->