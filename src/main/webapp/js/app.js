/**
 * 網站主要JavaScript功能
 */
document.addEventListener('DOMContentLoaded', function() {
    // 啟用所有提示框
    const tooltips = document.querySelectorAll('[data-bs-toggle="tooltip"]');
    tooltips.forEach(tooltip => {
        new bootstrap.Tooltip(tooltip);
    });
    
    // 啟用所有彈出框
    const popovers = document.querySelectorAll('[data-bs-toggle="popover"]');
    popovers.forEach(popover => {
        new bootstrap.Popover(popover);
    });
    
    // 添加動畫效果到頁面元素
    animateElements();
    
    // 投票表單提交前確認
    const voteForm = document.querySelector('form[action^="/poll/vote/"]');
    if (voteForm) {
        voteForm.addEventListener('submit', function(e) {
            const selected = this.querySelector('input[name="optionIndex"]:checked');
            if (!selected) {
                e.preventDefault();
                alert('請選擇一個選項再提交 / Please select an option before submitting');
            }
        });
    }
});

// 添加滾動動畫效果
function animateElements() {
    const cards = document.querySelectorAll('.card');
    
    // 使用Intersection Observer API來觀察元素是否進入視口
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1
    });
    
    cards.forEach(card => {
        observer.observe(card);
    });
}
