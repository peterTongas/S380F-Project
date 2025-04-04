<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<h2>Add New Course</h2>
<form action="/course/add" method="post">
    <div class="mb-3">
        <label class="form-label">Title</label>
        <input type="text" name="title" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label">Lecture Notes (URL)</label>
        <input type="text" name="filePath" class="form-control" placeholder="https://..." required>
    </div>
    <button type="submit" class="btn btn-primary">Add Course</button>
    <a href="/" class="btn btn-secondary">Cancel</a>
</form>