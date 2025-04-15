<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h2 class="h4 mb-0"><i class="fas fa-plus-circle me-2"></i>建立新投票</h2>
    </div>
    <div class="card-body">
        <form action="/poll/add" method="post" id="pollForm">
            <div class="mb-4">
                <label for="question" class="form-label">投票問題</label>
                <input type="text" class="form-control form-control-lg" id="question" 
                       name="question" placeholder="輸入問題..." required>
                <div class="form-text">設計一個清晰、明確的問題</div>
            </div>

            <h4 class="mb-3">投票選項</h4>
            <div id="optionsContainer">
                <div class="mb-3">
                    <div class="input-group">
                        <span class="input-group-text">1</span>
                        <input type="text" name="optionTexts" class="form-control" 
                               placeholder="選項 1" required>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="input-group">
                        <span class="input-group-text">2</span>
                        <input type="text" name="optionTexts" class="form-control" 
                               placeholder="選項 2" required>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="input-group">
                        <span class="input-group-text">3</span>
                        <input type="text" name="optionTexts" class="form-control" 
                               placeholder="選項 3" required>
                    </div>
                </div>
                <div class="mb-3">
                    <div class="input-group">
                        <span class="input-group-text">4</span>
                        <input type="text" name="optionTexts" class="form-control" 
                               placeholder="選項 4" required>
                    </div>
                </div>
            </div>
            
            <div class="mb-4">
                <button type="button" id="addOptionBtn" class="btn btn-outline-secondary">
                    <i class="fas fa-plus me-2"></i>新增選項
                </button>
            </div>
            
            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-check-circle me-2"></i>建立投票
                </button>
                <a href="/" class="btn btn-outline-secondary">
                    <i class="fas fa-times me-2"></i>取消
                </a>
            </div>
        </form>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    // 添加更多選項的功能
    const optionsContainer = document.getElementById('optionsContainer');
    const addOptionBtn = document.getElementById('addOptionBtn');
    
    addOptionBtn.addEventListener('click', function() {
        const optionCount = optionsContainer.children.length + 1;
        const newOption = document.createElement('div');
        newOption.className = 'mb-3';
        newOption.innerHTML = `
            <div class="input-group">
                <span class="input-group-text">${optionCount}</span>
                <input type="text" name="optionTexts" class="form-control" 
                       placeholder="選項 ${optionCount}" required>
                <button type="button" class="btn btn-outline-danger remove-option">
                    <i class="fas fa-trash"></i>
                </button>
            </div>
        `;
        optionsContainer.appendChild(newOption);
        
        // 添加刪除選項的功能
        const removeBtn = newOption.querySelector('.remove-option');
        removeBtn.addEventListener('click', function() {
            optionsContainer.removeChild(newOption);
            updateOptionNumbers();
        });
    });
    
    // 更新選項編號
    function updateOptionNumbers() {
        const options = optionsContainer.children;
        for (let i = 0; i < options.length; i++) {
            const numSpan = options[i].querySelector('.input-group-text');
            const input = options[i].querySelector('input');
            numSpan.textContent = i + 1;
            input.placeholder = `選項 ${i + 1}`;
        }
    }
});
</script>