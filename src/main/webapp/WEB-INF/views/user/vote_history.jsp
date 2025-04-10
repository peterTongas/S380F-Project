<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<h2>我的投票歷史</h2>

<c:choose>
  <c:when test="${not empty voteHistory}">
    <table class="table table-striped">
      <thead>
        <tr>
          <th>投票問題</th>
          <th>您的選擇</th>
          <th>日期</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach items="${voteHistory}" var="vote">
          <tr>
            <td>${vote.question}</td>
            <td>${vote.selectedOption}</td>
            <td>
              <fmt:formatDate
                value="${vote.voteDate}"
                pattern="MMM dd, yyyy HH:mm"
              />
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:when>
  <c:otherwise>
    <div class="alert alert-info">您還沒有參與任何投票。</div>
  </c:otherwise>
</c:choose>
