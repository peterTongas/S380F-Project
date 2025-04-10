<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Edit User</h2>
<form action="/admin/update" method="post" class="border p-4 rounded">
  <input type="hidden" name="username" value="${user.username}">

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label">Username:</label>
    <div class="col-sm-10">
      <input type="text" class="form-control-plaintext" value="${user.username}" readonly>
    </div>
  </div>

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label">Full Name:</label>
    <div class="col-sm-10">
      <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
    </div>
  </div>

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label">Email:</label>
    <div class="col-sm-10">
      <input type="email" name="email" class="form-control" value="${user.email}" required>
    </div>
  </div>

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label">Role:</label>
    <div class="col-sm-10">
      <select name="role" class="form-select" required>
        <option value="STUDENT" ${user.role == 'STUDENT' ? 'selected' : ''}>Student</option>
        <option value="TEACHER" ${user.role == 'TEACHER' ? 'selected' : ''}>Teacher</option>
      </select>
    </div>
  </div>

  <div class="text-end">
    <a href="/admin" class="btn btn-secondary">Cancel</a>
    <button type="submit" class="btn btn-primary">Save Changes</button>
  </div>
</form>