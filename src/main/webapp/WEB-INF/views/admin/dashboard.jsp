<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>User Management</h2>
<table class="table table-striped">
  <thead class="table-dark">
  <tr>
    <th>Username</th>
    <th>Full Name</th>
    <th>Email</th>
    <th>Role</th>
    <th>Actions</th>
  </tr>
  </thead>
  <tbody>
  <c:forEach items="${users}" var="user">
    <tr>
      <td>${user.username}</td>
      <td>${user.fullName}</td>
      <td>${user.email}</td>
      <td>${user.role}</td>
      <td>
        <a href="/admin/edit/${user.username}" class="btn btn-sm btn-warning">
          <i class="bi bi-pencil"></i> Edit
        </a>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>