<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Course Materials</h2>
<div class="row">
    <c:forEach items="${courses}" var="course">
        <div class="col-md-4 mb-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">${course.title}</h5>
                    <a href="/course/${course.id}" class="btn btn-primary">View Details</a>
                    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
                        <form action="/course/delete/${course.id}" method="post" class="d-inline">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<h2 class="mt-4">Current Polls</h2>
<c:forEach items="${polls}" var="poll">
    <div class="card mb-3">
        <div class="card-body">
            <h5 class="card-title">${poll.question}</h5>
            <a href="/poll/${poll.id}" class="btn btn-primary">View Poll</a>
        </div>
    </div>
</c:forEach>

<c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
    <div class="mt-3">
        <a href="/course/add" class="btn btn-success">Add New Course</a>
        <a href="/poll/add" class="btn btn-success">Add New Poll</a>
    </div>
</c:if>