package com.example.s380fproject_3103_2.config;

import com.example.s380fproject_3103_2.service.CustomUserDetailsService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.beans.factory.annotation.Autowired;
import com.example.s380fproject_3103_2.security.CustomAuthenticationProvider;
import com.example.s380fproject_3103_2.security.CustomAuthenticationSuccessHandler;
import com.example.s380fproject_3103_2.security.CustomLogoutSuccessHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity // 啟用方法級安全
public class SecurityConfig {
    
    private final CustomUserDetailsService userDetailsService;
    private final PasswordEncoder passwordEncoder;
    
    @Autowired
    private CustomAuthenticationProvider authProvider;
    
    @Autowired
    private CustomAuthenticationSuccessHandler successHandler;
    
    @Autowired
    private CustomLogoutSuccessHandler logoutSuccessHandler;
    
    public SecurityConfig(CustomUserDetailsService userDetailsService, PasswordEncoder passwordEncoder) {
        this.userDetailsService = userDetailsService;
        this.passwordEncoder = passwordEncoder;
    }
    
    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
        // 創建一個 AuthenticationManagerBuilder 實例
        AuthenticationManagerBuilder auth = http.getSharedObject(AuthenticationManagerBuilder.class);
        
        // 先添加自定義認證提供者
        auth.authenticationProvider(authProvider);
        
        // 然後配置 userDetailsService 和 passwordEncoder
        auth.userDetailsService(userDetailsService)
            .passwordEncoder(passwordEncoder);
        
        return auth.build();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/", "/index", "/home").permitAll()
                .requestMatchers("/user/login", "/user/register", 
                                "/js/**", "/css/**", "/h2-console/**", "/images/**", 
                                "/webjars/**", "/public/**", "/error").permitAll()
                .requestMatchers("/course/list", "/poll/list", "/course/*/download/**", 
                                "/course/*/download-all", "/course/download/**").permitAll()
                .requestMatchers(AntPathRequestMatcher.antMatcher("/WEB-INF/views/**")).permitAll()
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/user/login")
                .loginProcessingUrl("/user/process-login")
                .successHandler(successHandler)  // 使用自定義的成功處理器
                .failureUrl("/user/login?error=true")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/user/logout")
                .logoutSuccessUrl("/")
                .logoutSuccessHandler(logoutSuccessHandler)  // 使用自定義的登出成功處理器
                .invalidateHttpSession(true)
                .clearAuthentication(true)
                .deleteCookies("JSESSIONID")
                .permitAll()
            )
            .headers(headers -> headers.frameOptions(frameOptionsConfig -> frameOptionsConfig.disable()));
        
        return http.build();
    }
}