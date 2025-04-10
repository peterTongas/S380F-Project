<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2>Edit Course Material</h2>
<form
  action="/course/update/${course.id}"
  method="post"
  enctype="multipart/form-data"
>
  <div class="mb-3">
    <label class="form-label">Title</label>
    <input
      type="text"
      name="title"
      class="form-control"
      value="${course.title}"
      required
    />
  </div>

  <div class="mb-3">
    <label class="form-label">Description</label>
    <textarea name="description" class="form-control" rows="5">
${course.description}</textarea
    >
  </div>

  <div class="mb-3">
    <label class="form-label">Current Files</label>
    <ul class="list-group mb-3">
      <c:if test="${not empty course.filePath}">
        <li
          class="list-group-item d-flex justify-content-between align-items-center"
        >
          Legacy File: ${course.filePath}
          <a
            href="/course/download/${course.filePath}"
            class="btn btn-sm btn-primary"
            >Download</a
          >
        </li>
      </c:if>

      <c:forEach items="${course.files}" var="file">
        <li
          class="list-group-item d-flex justify-content-between align-items-center"
        >
          ${file.fileName}
          <div>
            <a
              href="/course/download/${file.filePath}"
              class="btn btn-sm btn-primary"
              >Download</a
            >
            <form
              action="/course/${course.id}/deleteFile/${file.id}"
              method="post"
              class="d-inline"
            >
              <button
                type="submit"
                class="btn btn-sm btn-danger"
                onclick="return confirm('Delete this file permanently?')"
              >
                Delete
              </button>
            </form>
          </div>
        </li>
      </c:forEach>
    </ul>

    <label class="form-label">Add New Files</label>
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

  <div class="d-flex justify-content-between">
    <a href="/course/${course.id}" class="btn btn-secondary">Cancel</a>
    <button type="submit" class="btn btn-primary">Save Changes</button>
  </div>
</form>
