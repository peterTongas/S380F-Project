<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2><span data-i18n="userManagement">User Management</span></h2>
<table class="table table-striped">
  <thead class="table-dark">
  <tr>
    <th><span data-i18n="username">Username</span></th>
    <th><span data-i18n="fullName">Full Name</span></th>
    <th><span data-i18n="email">Email</span></th>
    <th><span data-i18n="role">Role</span></th>
    <th><span data-i18n="actions">Actions</span></th>
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
          <i class="bi bi-pencil"></i> <span data-i18n="edit">Edit</span>
        </a>
      </td>
    </tr>
  </c:forEach>
  </tbody>
</table>