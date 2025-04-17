<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<h2><span data-i18n="addnewcoursematerial">Add New Course Material</span></h2>
<form action="/course/add" method="post" enctype="multipart/form-data">
    <div class="mb-3">
        <label class="form-label"><span data-i18n="ctitle">Course Title</span></label>
        <input type="text" name="title" class="form-control" required>
    </div>
    <div class="mb-3">
        <label class="form-label"><span data-i18n="cdescription">Description</span></label>
        <textarea name="description" class="form-control" rows="3"></textarea>
    </div>
    <div class="mb-3">
        <label class="form-label"><span data-i18n="LectureNotes">Notes (PDFs, Documents, etc.)</span></label>
        <input type="file" name="files" multiple class="form-control" accept=".pdf,.doc,.docx,.ppt,.pptx" required>
        <small class="text-muted"><span data-i18n="multipleFileUpload">您可以一次選擇多個檔案進行上傳。</span></small>
    </div>
    <button type="submit" class="btn btn-primary"><span data-i18n="addCourse">Add Course</span></button>
    <a href="/" class="btn btn-secondary"><span data-i18n="cancel">Cancel</span></a>
</form>