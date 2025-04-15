<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container">
    <h2>我的投票歷史</h2>
    
    <c:if test="${empty voteHistory}">
        <div class="alert alert-info">
            您尚未參與任何投票。
        </div>
    </c:if>
    
    <c:if test="${not empty voteHistory}">
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead>
                    <tr>
                        <th>投票問題</th>
                        <th>您的選擇</th>
                        <th>投票時間</th>
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
        <a href="/" class="btn btn-primary">返回首頁</a>
    </div>
</div>