<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title><c:out value="${pageTitle}" default="Online Course Website"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
        <a class="navbar-brand" href="/">Course Website</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/">Home</a>
                </li>
            </ul>
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty sessionScope.currentUser}">
                        <li class="nav-item">
                            <span class="nav-link">Welcome, ${currentUser.fullName}!</span>
                        </li>
                        <c:if test="${currentUser.role == 'TEACHER'}">
                            <li class="nav-item">
                                <a class="nav-link" href="/admin">Admin Dashboard</a>
                            </li>
                        </c:if>
                        <li class="nav-item">
                            <a class="nav-link" href="/user/profile">Profile</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/user/logout">Logout</a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="/user/login">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/user/register">Register</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <%-- Main content will be inserted here --%>
    <jsp:include page="${contentPage}"/>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>