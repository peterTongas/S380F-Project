<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<h2>My Voting History</h2>

<c:choose>
  <c:when test="${not empty voteHistory}">
    <table class="table table-striped">
      <thead>
        <tr>
          <th>Poll Question</th>
          <th>Your Vote</th>
          <th>Date</th>
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
    <div class="alert alert-info">You haven't voted on any polls yet.</div>
  </c:otherwise>
</c:choose>
