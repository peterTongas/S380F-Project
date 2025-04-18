<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card shadow-sm mb-4">
    <div class="card-header bg-warning text-white">
        <h2 class="h3 mb-0"><i class="fas fa-exchange-alt me-2"></i><span data-i18n="changeVote">變更投票</span>: ${poll.question}</h2>
    </div>
    <div class="card-body">
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i><span data-i18n="errorMessage">${errorMessage}</span>
            </div>
        </c:if>
        
        <div class="alert alert-info mb-4">
            <i class="fas fa-info-circle me-2"></i><span data-i18n="selectNewVote">請選擇您想要變更為的新投票選項</span>
        </div>
        
        <!-- 顯示投票表單 -->
        <form action="/poll/vote/${poll.id}" method="post" class="mb-4">
            <div class="mb-3">
                <h4 class="mb-3"><span data-i18n="currentResults">目前投票結果</span></h4>
                <div class="mb-4">
                    <!-- Display the current voting results -->
                    <c:forEach begin="0" end="3" varStatus="loop">
                        <c:choose>
                            <c:when test="${loop.index < poll.options.size()}">
                                <c:set var="option" value="${poll.options[loop.index]}"/>
                                <div class="poll-option">
                                    <div class="poll-progress">
                                        <div class="progress-bar ${poll.userVotedOptionId == option.id ? 'bg-success' : 'bg-primary'}" 
                                             role="progressbar" 
                                             style="width: ${empty poll.totalVotes || poll.totalVotes == 0 ? 0 : (option.voteCount / poll.totalVotes) * 100}%" 
                                             aria-valuenow="${option.voteCount}" 
                                             aria-valuemin="0" 
                                             aria-valuemax="100"></div>
                                    </div>
                                    <span class="poll-option-text">
                                        ${option.text}
                                        <c:if test="${poll.userVotedOptionId == option.id}">
                                            <i class="fas fa-check-circle text-success ms-2"></i> <span class="badge bg-success"><span data-i18n="yourCurrentChoice">您目前的選擇</span></span>
                                        </c:if>
                                    </span>
                                    <span class="poll-option-count">
                                        ${option.voteCount} <span data-i18n="votes">票</span> (${empty poll.totalVotes || poll.totalVotes == 0 ? 0 : Math.round((option.voteCount / poll.totalVotes) * 100)}%)
                                    </span>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <!-- Display placeholder for missing options -->
                                <div class="poll-option disabled">
                                    <div class="poll-progress">
                                        <div class="progress-bar bg-light" role="progressbar" 
                                             style="width: 0%" 
                                             aria-valuenow="0" 
                                             aria-valuemin="0" 
                                             aria-valuemax="100"></div>
                                    </div>
                                    <span class="poll-option-text text-muted">Option ${loop.index + 1} (Not available)</span>
                                    <span class="poll-option-count">0 <span data-i18n="votes">票</span> (0%)</span>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>

                <h4 class="mb-3"><span data-i18n="selectNewOption">選擇新選項</span></h4>
                <!-- Always display exactly 4 options -->
                <c:forEach begin="0" end="3" varStatus="loop">
                    <c:choose>
                        <c:when test="${loop.index < poll.options.size()}">
                            <c:set var="option" value="${poll.options[loop.index]}"/>
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" name="optionIndex" 
                                       id="option${loop.index}" value="${loop.index}" 
                                       ${poll.userVotedOptionId == option.id ? 'checked' : ''}>
                                <label class="form-check-label w-100" for="option${loop.index}" style="cursor: pointer;">
                                    ${option.text}
                                    <c:if test="${poll.userVotedOptionId == option.id}">
                                        <span class="badge bg-success ms-2"><span data-i18n="yourCurrentChoice">您目前的選擇</span></span>
                                    </c:if>
                                </label>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Display disabled placeholder for missing options -->
                            <div class="form-check mb-3">
                                <input class="form-check-input" type="radio" name="optionIndex"
                                       id="option${loop.index}" value="${loop.index}" disabled>
                                <label class="form-check-label text-muted" for="option${loop.index}">
                                    Option ${loop.index + 1} (Not available)
                                </label>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
            </div>
            
            <input type="hidden" name="changeVote" value="true">
            <input type="hidden" name="previousVoteOptionId" value="${poll.userVotedOptionId}">
            
            <div class="d-flex mt-4">
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-exchange-alt me-2"></i><span data-i18n="submitNewVote">提交變更投票</span>
                </button>
                <a href="/poll/${poll.id}" class="btn btn-outline-secondary ms-2">
                    <i class="fas fa-times me-2"></i><span data-i18n="cancel">取消</span>
                </a>
            </div>
        </form>
    </div>
</div>

<script>
// Enhance poll option selection UX
document.addEventListener('DOMContentLoaded', function() {
    const pollOptions = document.querySelectorAll('.form-check');
    
    // Make the entire option area clickable
    pollOptions.forEach(function(option) {
        if (!option.querySelector('input:disabled')) {
            option.addEventListener('click', function(e) {
                const radio = this.querySelector('input[type="radio"]');
                if (radio) {
                    radio.checked = true;
                }
            });
            
            // Add hover effect for better UX
            option.addEventListener('mouseover', function() {
                this.style.backgroundColor = 'rgba(0,0,0,0.05)';
            });
            
            option.addEventListener('mouseout', function() {
                this.style.backgroundColor = '';
            });
        }
    });
    
    // Validate form before submission
    const voteForm = document.querySelector('form[action^="/poll/vote/"]');
    if (voteForm) {
        voteForm.addEventListener('submit', function(e) {
            // For the voting form, require a selection
            const selected = this.querySelector('input[name="optionIndex"]:checked');
            if (!selected) {
                e.preventDefault();
                alert('請選擇一個選項再提交 / Please select an option before submitting');
                return false;
            }
        });
    }
});
</script>