<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h2 class="h4 mb-0"><i class="fas fa-plus-circle me-2"></i><span data-i18n="createNewPoll">建立新投票</span></h2>
    </div>
    <div class="card-body">
        <form action="/poll/add" method="post" id="pollForm">
            <div class="mb-4">
                <label for="question" class="form-label"><span data-i18n="pollQuestion">投票問題</span></label>
                <input type="text" class="form-control form-control-lg" id="question" 
                       name="question" placeholder="Enter question..." data-i18n-placeholder="enterQuestion" required>
                <div class="form-text"><span data-i18n="clearQuestion">設計一個清晰、明確的問題</span></div>
            </div>

            <h4 class="mb-3"><span data-i18n="pollOptions">投票選項</span></h4>
            <div id="optionsContainer">
                <div class="mb-3">
                    <label class="form-label"><span data-i18n="option">選項</span> 1</label>
                    <input type="text" class="form-control" name="optionTexts" 
                           placeholder="Enter option..." data-i18n-placeholder="enterOption" required>
                </div>
                <div class="mb-3">
                    <label class="form-label"><span data-i18n="option">選項</span> 2</label>
                    <input type="text" class="form-control" name="optionTexts" 
                           placeholder="Enter option..." data-i18n-placeholder="enterOption" required>
                </div>
                <div class="mb-3">
                    <label class="form-label"><span data-i18n="option">選項</span> 3</label>
                    <input type="text" class="form-control" name="optionTexts" 
                           placeholder="Enter option..." data-i18n-placeholder="enterOption" required>
                </div>
                <div class="mb-3">
                    <label class="form-label"><span data-i18n="option">選項</span> 4</label>
                    <input type="text" class="form-control" name="optionTexts" 
                           placeholder="Enter option..." data-i18n-placeholder="enterOption" required>
                </div>
            </div>
            
            <div class="mb-4">
                <label for="endDate" class="form-label"><span data-i18n="endDate">結束日期</span></label>
                <input type="datetime-local" class="form-control" id="endDate" name="endDate" required>
                <div class="form-text"><span data-i18n="endDateHint">設定投票的結束時間</span></div>
            </div>
            
            <div class="d-flex justify-content-between">
                <button type="button" class="btn btn-secondary" onclick="history.back()">
                    <i class="fas fa-arrow-left me-2"></i><span data-i18n="back">返回</span>
                </button>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check me-2"></i><span data-i18n="createPoll">建立投票</span>
                </button>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // No additional functionality needed as we're restricting to exactly 4 options
});
</script>