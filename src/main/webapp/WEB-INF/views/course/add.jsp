<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<h2>Add New Course Material</h2>
<form action="/course/add" method="post" enctype="multipart/form-data">
    <div class="mb-3">
        <label class="form-label">Title</label>
        <input type="text" name="title" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label">Description</label>
        <textarea name="description" class="form-control" rows="3"></textarea>
    </div>
    <div class="mb-3">
        <label class="form-label">Lecture Notes (PDFs, Documents, etc.)</label>
        <input type="file" name="files" multiple class="form-control" accept=".pdf,.doc,.docx,.ppt,.pptx" required>
        <small class="text-muted">您可以一次選擇多個檔案進行上傳。</small>
    </div>
    <button type="submit" class="btn btn-primary">Add Course</button>
    <a href="/" class="btn btn-secondary">Cancel</a>
</form>