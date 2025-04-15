<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="container mt-5">
    <h2>Register</h2>
    <form action="/user/register" method="post">
        <div class="mb-3">
            <label class="form-label">Username</label>
            <input type="text" name="username" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Full Name</label>
            <input type="text" name="fullName" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Phone</label>
            <input type="tel" name="phone" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary">Register</button>
        <a href="/user/login" class="btn btn-link">Already have an account?</a>
    </form>
</div>