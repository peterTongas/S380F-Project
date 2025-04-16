<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<h2><span data-i18n="editCourse">Edit Course Material</span></h2>

<c:if test="${not empty error}">
  <div class="alert alert-danger">
    ${error}
  </div>
</c:if>

<form action="/course/update/${course.id}" method="post" enctype="multipart/form-data" id="editCourseForm">
  <div class="mb-3">
    <label class="form-label"><span data-i18n="courseTitle">Title</span></label>
    <input type="text" name="title" class="form-control"
           value="${course.title}" required>
  </div>

  <div class="mb-3">
    <label class="form-label"><span data-i18n="description">Description</span></label>
    <textarea name="description" class="form-control" rows="5">${course.description}</textarea>
  </div>

  <div class="mb-3">
    <label class="form-label"><span data-i18n="uploadFiles">Upload Additional Files</span></label>
    <!-- 確保 name 屬性正確設置為 "files" -->
    <input type="file" name="files" multiple class="form-control" accept=".pdf,.doc,.docx,.ppt,.pptx">
    <small class="text-muted"><span data-i18n="multipleFileUpload">您可以選擇要添加的多個檔案，現有檔案將保留。</span></small>
  </div>

  <!-- 顯示現有檔案列表 -->
  <div class="mb-4">
    <label class="form-label"><span data-i18n="currentFiles">Current Files</span>:</label>
    <div class="list-group">
      <c:forEach items="${course.courseFiles}" var="file">
        <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-center">
          <div>
            <i class="bi bi-file-earmark"></i> ${file.fileName}
          </div>
          <div>
            <a href="/course/download/${file.filePath}" class="btn btn-sm btn-info me-2">
              <i class="bi bi-download"></i> <span data-i18n="download">下載</span>
            </a>
            <form action="/course/${course.id}/file/delete/${file.id}" method="post" class="d-inline">
              <button type="submit" class="btn btn-sm btn-danger" 
                      onclick="return confirm('確定要刪除此檔案？')">
                <i class="bi bi-trash"></i> <span data-i18n="delete">刪除</span>
              </button>
            </form>
          </div>
        </div>
      </c:forEach>
      <c:if test="${empty course.courseFiles}">
        <div class="list-group-item text-muted"><span data-i18n="noFiles">暫無檔案</span></div>
      </c:if>
    </div>
  </div>

  <div class="d-flex justify-content-between">
    <a href="/course/${course.id}" class="btn btn-secondary"><span data-i18n="cancel">取消</span></a>
    <button type="submit" class="btn btn-primary" id="saveButton"><span data-i18n="saveChanges">儲存更改</span></button>
  </div>
</form>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    // 獲取表單與儲存按鈕
    const editForm = document.getElementById('editCourseForm');
    const saveButton = document.getElementById('saveButton');
    
    // 確保刪除按鈕不會干擾主表單提交
    const deleteButtons = document.querySelectorAll('.btn-danger');
    deleteButtons.forEach(function(btn) {
      btn.onclick = function(e) {
        // 不干擾主表單，只執行確認刪除的邏輯
        return confirm('確定要刪除此檔案？');
      };
    });
    
    // 處理主表單提交
    editForm.addEventListener('submit', function(event) {
      // 顯示處理中狀態
      saveButton.querySelector('span').innerHTML = '處理中...';
      saveButton.classList.add('disabled');
      
      // 確保表單正常提交
      return true;
    });
    
    // 添加額外的儲存按鈕點擊事件以確保表單提交
    saveButton.addEventListener('click', function(event) {
      // 防止事件冒泡和默認行為
      event.stopPropagation();
      
      // 手動提交表單
      editForm.submit();
    });
  });
</script>