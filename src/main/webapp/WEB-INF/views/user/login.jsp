<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<h2>Login</h2>
<c:if test="${param.error != null}">
  <div class="alert alert-danger">Invalid username or password!</div>
</c:if>
<form action="/user/login" method="post">
  <div class="mb-3">
    <label class="form-label">Username</label>
    <input type="text" name="username" class="form-control" required>
  </div>
  <div class="mb-3">
    <label class="form-label">Password</label>
    <input type="password" name="password" class="form-control" required>
  </div>
  <button type="submit" class="btn btn-primary">Login</button>
  <a href="/user/register" class="btn btn-link">Register</a>
</form>