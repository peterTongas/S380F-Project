package com.example.s380fproject_3103_2.security;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.repository.UserRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class CustomAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    @Autowired
    private UserRepository userRepository;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        
        // 獲取已認證的用戶名
        String username = authentication.getName();
        
        // 從數據庫獲取完整的用戶對象
        User user = userRepository.findByUsername(username);
        
        // 將用戶對象存入 session
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
            System.out.println("已將用戶信息存入session: " + user.getUsername());
        }
        
        // 調用父類方法完成默認的重定向邏輯
        super.onAuthenticationSuccess(request, response, authentication);
    }
}