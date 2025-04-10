<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<h2>Add New Course Material</h2>
<form action="/course/add" method="post" enctype="multipart/form-data">
    <div class="mb-3">
        <label class="form-label">Title</label>
        <input type="text" name="title" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label">Lecture Notes (PDF)</label>
        <input type="file" name="file" class="form-control" accept=".pdf" required>
    </div>
    <button type="submit" class="btn btn-primary">Add Course</button>
    <a href="/" class="btn btn-secondary">Cancel</a>
</form>