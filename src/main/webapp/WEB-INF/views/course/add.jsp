<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<h2>Add New Course Material</h2>
<form action="/course/add" method="post" enctype="multipart/form-data">
  <div class="mb-3">
    <label class="form-label">Title</label>
    <input type="text" name="title" class="form-control" required />
  </div>
  <div class="mb-3">
    <label class="form-label">Description</label>
    <textarea name="description" class="form-control" rows="3"></textarea>
  </div>
  <div class="mb-3">
    <label class="form-label">Course Files</label>
    <input
      type="file"
      name="files"
      class="form-control"
      multiple
      accept=".pdf,.doc,.docx,.ppt,.pptx,.xls,.xlsx,.zip"
    />
    <small class="text-muted"
      >You can select multiple files by holding Ctrl or Command key while
      selecting</small
    >
  </div>
  <button type="submit" class="btn btn-primary">Add Course</button>
  <a href="/" class="btn btn-secondary">Cancel</a>
</form>
