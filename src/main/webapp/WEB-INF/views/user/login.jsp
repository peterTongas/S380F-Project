<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h2 class="h4 mb-0" data-i18n="userLogin">使用者登入</h2>
                </div>
                <div class="card-body">
                    <c:if test="${param.error != null}">
                        <div class="alert alert-danger">
                            <i class="fas fa-exclamation-circle me-2"></i><span data-i18n="loginFailed">登入失敗：用戶名或密碼不正確。</span>
                        </div>
                    </c:if>
                    
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i><span data-i18n="logoutSuccess">您已成功登出。</span>
                        </div>
                    </c:if>
                    
                    <form action="${pageContext.request.contextPath}/user/process-login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label" data-i18n="username">用戶名:</label>
                            <input type="text" id="username" name="username" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label" data-i18n="password">密碼:</label>
                            <input type="password" id="password" name="password" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-sign-in-alt me-2"></i><span data-i18n="loginButton">登入</span>
                        </button>
                    </form>
                    
                    <div class="mt-3">
                        <a href="${pageContext.request.contextPath}/user/register">
                            <i class="fas fa-user-plus me-1"></i><span data-i18n="registerNewAccount">註冊新帳號</span>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>