package com.helpdesk.common.controller;

import com.helpdesk.common.util.SessionUtil;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
public class RootController {

    /**
     * 루트 경로 접근 시 로그인 여부에 따라 리다이렉트
     */
    @GetMapping("/")
    public String root(HttpServletRequest request) {
        // 로그인 되어 있으면 메인으로, 아니면 로그인 페이지로
        if (SessionUtil.isLoggedIn(request)) {
            return "redirect:/main";
        }
        return "redirect:/auth/login";
    }

    /**
     * 에러 페이지
     */
    @GetMapping("/error")
    public String error() {
        return "common/error";
    }
}
