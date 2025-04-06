<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="container mt-5">
  <h2>My Profile</h2>
  <form action="/user/profile" method="post">
    <div class="mb-3">
      <label class="form-label">Username</label>
      <input type="text" class="form-control" value="${user.username}" readonly>
    </div>
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
    <button type="submit" class="btn btn-primary">Update Profile</button>
    <a href="/" class="btn btn-secondary">Cancel</a>
  </form>
</div>