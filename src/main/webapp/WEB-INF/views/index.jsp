<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Course Materials</h2>
<h2>Login</h2>
<a href="/user/login" class="btn btn-success">Login</a>
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

<h2 class="mt-5">Current Polls</h2>
<div class="row">
    <c:forEach items="${polls}" var="poll">
        <div class="col-md-6 mb-3">
            <div class="card">
                <div class="card-body">
                    <h5 class="card-title">${poll.question}</h5>
                    <a href="/poll/${poll.id}" class="btn btn-primary">View Poll</a>
                    <c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
                        <form action="/poll/delete/${poll.id}" method="post" class="d-inline">
                            <button type="submit" class="btn btn-danger">Delete</button>
                        </form>
                    </c:if>
                </div>
            </div>
        </div>
    </c:forEach>
</div>

<c:if test="${not empty sessionScope.currentUser && sessionScope.currentUser.role == 'TEACHER'}">
    <div class="mt-3">
        <a href="/course/add" class="btn btn-success">Add New Course</a>
        <a href="/poll/add" class="btn btn-success">Add New Poll</a>
    </div>
</c:if>

<c:if test="${not empty sessionScope.currentUser}">
    <li class="nav-item">
        <a class="nav-link" href="<c:url value='/user/logout'/>">Logout</a>
    </li>
</c:if>
