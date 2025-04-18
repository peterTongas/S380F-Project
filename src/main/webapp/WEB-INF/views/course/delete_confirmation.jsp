<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card shadow-sm mb-4">
    <div class="card-header bg-danger text-white">
        <h2 class="h3 mb-0"><i class="fas fa-exclamation-triangle me-2"></i><span data-i18n="deleteCourse">刪除課程</span></h2>
    </div>
    <div class="card-body">
        <div class="alert alert-warning">
            <i class="fas fa-exclamation-circle me-2"></i><span data-i18n="deleteWarning">警告：此操作無法撤銷。刪除課程將同時刪除所有相關文件和評論。</span>
        </div>
        
        <div class="mb-4">
            <h4><span data-i18n="courseDetails">課程詳情</span>：</h4>
            <table class="table table-bordered">
                <tr>
                    <th width="20%"><span data-i18n="courseTitle">課程標題</span></th>
                    <td>${course.title}</td>
                </tr>
                <tr>
                    <th><span data-i18n="description">描述</span></th>
                    <td>${course.description != null ? course.description : '<span data-i18n="noDescription">暫無描述</span>'}</td>
                </tr>
                <tr>
                    <th><span data-i18n="fileCount">檔案數量</span></th>
                    <td>${course.courseFiles.size()} <span data-i18n="files">個檔案</span></td>
                </tr>
                <tr>
                    <th><span data-i18n="commentCount">評論數量</span></th>
                    <td>${course.comments.size()} <span data-i18n="comments">條評論</span></td>
                </tr>
                <tr>
                    <th><span data-i18n="createdAt">創建時間</span></th>
                    <td><fmt:formatDate value="${course.createdAt}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
            </table>
        </div>
        
        <form action="/course/delete/${course.id}" method="post" id="deleteCourseForm" class="mt-4">
            <div class="form-check mb-4">
                <input class="form-check-input" type="checkbox" id="confirmDelete" required>
                <label class="form-check-label" for="confirmDelete">
                    <span data-i18n="confirmDeleteText">我已了解此操作的風險，並確認要刪除此課程及其所有相關內容。</span>
                </label>
            </div>
            
            <div class="d-flex justify-content-between">
                <a href="/course/${course.id}" class="btn btn-secondary">
                    <i class="fas fa-times me-2"></i><span data-i18n="cancel">取消</span>
                </a>
                <button type="submit" class="btn btn-danger" id="deleteButton">
                    <i class="fas fa-trash-alt me-2"></i><span data-i18n="confirmDelete">確認刪除</span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const deleteCourseForm = document.getElementById('deleteCourseForm');
    const confirmCheckbox = document.getElementById('confirmDelete');
    const deleteButton = document.getElementById('deleteButton');
    
    // Initially disable the delete button
    deleteButton.classList.add('disabled');
    
    // Enable button only when checkbox is checked
    confirmCheckbox.addEventListener('change', function() {
        if (this.checked) {
            deleteButton.classList.remove('disabled');
        } else {
            deleteButton.classList.add('disabled');
        }
    });
    
    // Final validation before form submission
    deleteCourseForm.addEventListener('submit', function(event) {
        if (!confirmCheckbox.checked) {
            event.preventDefault();
            alert('請確認您了解刪除操作的風險後再繼續。');
            return false;
        }
    });
});
</script>