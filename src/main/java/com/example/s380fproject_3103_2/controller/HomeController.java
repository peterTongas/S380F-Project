package com.example.s380fproject_3103_2.controller;

import com.example.s380fproject_3103_2.service.CourseService;
import com.example.s380fproject_3103_2.service.PollService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import jakarta.servlet.http.HttpServletRequest;

@Controller
public class HomeController {
    @Autowired
    private CourseService courseService;
    @Autowired
    private PollService pollService;

    @GetMapping("/")
    public String index(Model model, HttpServletRequest request) {
        // 記錄請求信息，幫助診斷
        System.out.println("首頁請求路徑: " + request.getRequestURI());
        System.out.println("首頁請求查詢參數: " + request.getQueryString());
        System.out.println("首頁請求會話ID: " + request.getSession(false) != null ? 
                        request.getSession().getId() : "無會話");
        
        // 原有的業務邏輯...
        model.addAttribute("courses", courseService.getAllCourses());
        model.addAttribute("polls", pollService.getAllPolls());
        
        model.addAttribute("contentPage", "index.jsp");
        return "layout";
    }
    // 添加一個備用的首頁路徑，以防問題出在特定URL處理上
    @GetMapping("/home")
    public String home(Model model, HttpServletRequest request) {
        System.out.println("訪問 /home 路徑");
        return index(model, request);
    }
}