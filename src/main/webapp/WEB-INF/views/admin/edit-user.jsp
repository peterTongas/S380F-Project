<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2><span data-i18n="editUser">Edit User</span></h2>
<form action="/admin/update" method="post" class="border p-4 rounded">
  <input type="hidden" name="username" value="${user.username}">

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label"><span data-i18n="username">Username</span>:</label>
    <div class="col-sm-10">
      <input type="text" class="form-control-plaintext" value="${user.username}" readonly>
    </div>
  </div>

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label"><span data-i18n="fullName">Full Name</span>:</label>
    <div class="col-sm-10">
      <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
    </div>
  </div>

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label"><span data-i18n="email">Email</span>:</label>
    <div class="col-sm-10">
      <input type="email" name="email" class="form-control" value="${user.email}" required>
    </div>
  </div>
  
  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label"><span data-i18n="phoneField">Phone</span>:</label>
    <div class="col-sm-10">
      <input type="tel" name="phone" class="form-control" value="${user.phone}" required>
    </div>
  </div>

  <div class="mb-3 row">
    <label class="col-sm-2 col-form-label"><span data-i18n="role">Role</span>:</label>
    <div class="col-sm-10">
      <select name="role" class="form-select" required>
        <option value="STUDENT" ${user.role == 'STUDENT' ? 'selected' : ''}><span data-i18n="student">Student</span></option>
        <option value="TEACHER" ${user.role == 'TEACHER' ? 'selected' : ''}><span data-i18n="teacher">Teacher</span></option>
      </select>
    </div>
  </div>

  <div class="text-end">
    <a href="/admin" class="btn btn-secondary"><span data-i18n="cancel">Cancel</span></a>
    <button type="submit" class="btn btn-primary"><span data-i18n="saveChanges">Save Changes</span></button>
  </div>
</form>