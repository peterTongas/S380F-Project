package com.example.s380fproject_3103_2.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomLogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler {

    @Override
    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response,
                                Authentication authentication) throws IOException, ServletException {
        
        // 清除 session 中的用戶信息
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("currentUser");
            System.out.println("已從 session 中移除用戶信息");
        }
        
        // 調用父類方法完成默認的重定向邏輯
        super.onLogoutSuccess(request, response, authentication);
    }
}