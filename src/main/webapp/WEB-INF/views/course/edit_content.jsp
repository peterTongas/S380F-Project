<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Edit Course Material</h2>
<form action="/course/update/${course.id}" method="post" enctype="multipart/form-data">
  <div class="mb-3">
    <label class="form-label">Title</label>
    <input type="text" name="title" class="form-control"
           value="${course.title}" required>
  </div>

  <div class="mb-3">
    <label class="form-label">Description</label>
    <textarea name="description" class="form-control" rows="5">${course.description}</textarea>
  </div>

  <div class="mb-3">
    <label class="form-label">Current File: ${course.filePath}</label>
    <input type="file" name="file" class="form-control" accept=".pdf">
    <small class="text-muted">Leave blank to keep current file</small>
  </div>

  <div class="d-flex justify-content-between">
    <a href="/course/${course.id}" class="btn btn-secondary">Cancel</a>
    <button type="submit" class="btn btn-primary">Save Changes</button>
  </div>
</form>