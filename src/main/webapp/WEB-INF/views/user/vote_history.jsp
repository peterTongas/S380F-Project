<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container">
    <h2><span data-i18n="myVoteHistory">我的投票歷史</span></h2>
    
    <c:if test="${empty voteHistory}">
        <div class="alert alert-info">
            <span data-i18n="noVoteHistory">您尚未參與任何投票。</span>
        </div>
    </c:if>
    
    <c:if test="${not empty voteHistory}">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th><span data-i18n="pollQuestion">投票問題</span></th>
                        <th><span data-i18n="yourChoice">您的選擇</span></th>
                        <th><span data-i18n="voteTime">投票時間</span></th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="vote" items="${voteHistory}">
                        <tr>
                            <td>${vote.question}</td>
                            <td>${vote.selectedOption}</td>
                            <td>
                                <fmt:formatDate value="${vote.voteDate}" pattern="yyyy-MM-dd HH:mm:ss" />
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </c:if>
    
    <div class="mt-3">
        <a href="/" class="btn btn-primary">
            <i class="fas fa-home me-2"></i><span data-i18n="returnHome">返回首頁</span>
        </a>
    </div>
</div>