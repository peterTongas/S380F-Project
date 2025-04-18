<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="container mt-5">
  <h2><span data-i18n="Profile">Profile</span> </h2>
  <form action="/user/profile" method="post">
    <div class="mb-3">
      <label class="form-label"><span data-i18n="username">Username</span></label>
      <input type="text" class="form-control" value="${user.username}" readonly>
      <input type="hidden" name="username" value="${user.username}">
    </div>
    <div class="mb-3">
      <label class="form-label"><span data-i18n="fullName">Full Name</span></label>
      <input type="text" name="fullName" class="form-control" value="${user.fullName}" required>
    </div>
    <div class="mb-3">
      <label class="form-label"><span data-i18n="pemail">Email</span></label>
      <input type="email" name="email" class="form-control" value="${user.email}" required>
    </div>
    <div class="mb-3">
      <label class="form-label"><span data-i18n="pphone">Phone</span></label>
      <input type="tel" name="phone" class="form-control" value="${user.phone}" required>
    </div>
    <button type="submit" class="btn btn-primary"><span data-i18n="UpdateProfile">Update Profile</span></button>
    <a href="/" class="btn btn-secondary"><span data-i18n="cancel">Cancel</span></a>
  </form>
</div>