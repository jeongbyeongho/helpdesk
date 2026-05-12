package com.helpdesk.admin.main.controller;

import com.helpdesk.admin.main.service.AdminMainService;
import com.helpdesk.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminMainController {

    @Autowired
    private AdminMainService adminMainService;

    /**
     * 관리자 메인 페이지
     */
    @GetMapping({"", "/", "/main"})
    public String main(HttpServletRequest request, Model model) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        
        // 권한 체크 (관리자만 접근 가능)
        Object roleCodeObj = loginUser.get("roleCode");
        if (roleCodeObj == null) roleCodeObj = loginUser.get("role_code");
        
        int roleCode = 999;
        if (roleCodeObj != null) {
            if (roleCodeObj instanceof Integer) {
                roleCode = (Integer) roleCodeObj;
            } else if (roleCodeObj instanceof String) {
                try {
                    roleCode = Integer.parseInt((String) roleCodeObj);
                } catch (NumberFormatException e) {
                    roleCode = 999;
                }
            }
        }
        
        // 관리자 권한이 없으면 사용자 메인으로 리다이렉트
        if (roleCode > 2) {
            return "redirect:/main";
        }
        
        // 실제 통계 데이터 조회
        Map<String, Object> stats = adminMainService.getDashboardStats();
        
        model.addAttribute("stats", stats);
        model.addAttribute("pageTitle", "관리자 대시보드");
        
        return "admin/main";
    }
}
