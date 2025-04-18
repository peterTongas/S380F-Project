package com.example.s380fproject_3103_2.security;

import com.example.s380fproject_3103_2.model.User;
import com.example.s380fproject_3103_2.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

@Component
public class CustomAuthenticationProvider implements AuthenticationProvider {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        String username = authentication.getName();
        String password = authentication.getCredentials().toString();

        System.out.println("嘗試認證用戶: " + username);

        try {
            User user = userRepository.findByUsername(username);
            System.out.println("查找到用戶: " + (user != null ? user.getUsername() : "null"));

            if (user == null) {
                System.out.println("認證失敗: 用戶不存在");
                throw new BadCredentialsException("無效的用戶名或密碼");
            }

            // 改進的密碼驗證邏輯 - 首先嘗試使用加密方式驗證，如果失敗則嘗試直接比較
            boolean passwordMatch = false;
            
            // 嘗試使用加密驗證
            try {
                if (passwordEncoder.matches(password, user.getPassword())) {
                    passwordMatch = true;
                }
            } catch (Exception e) {
                // 如果加密驗證失敗（例如格式不正確），則忽略錯誤繼續
                System.out.println("加密密碼驗證失敗: " + e.getMessage());
            }
            
            // 如果加密驗證失敗，嘗試直接比較（用於處理未加密的密碼）
            if (!passwordMatch && password.equals(user.getPassword())) {
                passwordMatch = true;
                // 考慮在這裡將明文密碼轉換為加密格式並更新用戶記錄
                System.out.println("使用明文密碼登入成功，建議更新為加密格式");
            }
            
            if (!passwordMatch) {
                System.out.println("認證失敗: 密碼不匹配");
                throw new BadCredentialsException("無效的用戶名或密碼");
            }

            System.out.println("認證成功: " + username + ", 角色: " + user.getRole());

            List<GrantedAuthority> authorities = new ArrayList<>();
            authorities.add(new SimpleGrantedAuthority("ROLE_" + user.getRole().name()));

            return new UsernamePasswordAuthenticationToken(username, password, authorities);
        } catch (BadCredentialsException e) {
            throw e; // 直接重新拋出認證異常
        } catch (Exception e) {
            System.out.println("認證過程中發生異常: " + e.getMessage());
            e.printStackTrace();
            throw new AuthenticationServiceException("認證過程中發生錯誤", e);
        }
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}
