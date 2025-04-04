<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h2>Edit User</h2>
<form action="/admin/update" method="post">
  <input type="hidden" name="username" value="${user.username}">

  <div class="mb-3">
    <label class="form-label">Full Name</label>
    <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
  </div>
  <div class="mb-3">
    <label class="form-label">Email</label>
    <input type="email" name="email" class="form-control" value="${user.email}" required>
  </div>
  <div class="mb-3">
    <label class="form-label">Phone</label>
    <input type="tel" name="phone" class="form-control" value="${user.phone}" required>
  </div>
  <div class="mb-3">
    <label class="form-label">Role</label>
    <select name="role" class="form-select" required>
      <option value="STUDENT" ${user.role == 'STUDENT' ? 'selected' : ''}>Student</option>
      <option value="TEACHER" ${user.role == 'TEACHER' ? 'selected' : ''}>Teacher</option>
    </select>
  </div>
  <button type="submit" class="btn btn-primary">Save Changes</button>
  <a href="/admin" class="btn btn-secondary">Cancel</a>
</form>