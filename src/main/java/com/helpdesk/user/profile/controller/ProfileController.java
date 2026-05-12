package com.helpdesk.user.profile.controller;

import com.helpdesk.common.util.SessionUtil;
import com.helpdesk.common.util.PasswordUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/user/profile")
public class ProfileController {

    /** 프로필 페이지 */
    @GetMapping("")
    public String profile(HttpServletRequest request, Model model) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        
        // 사용자 통계 정보 (임시 데이터)
        Map<String, Object> userStats = new HashMap<>();
        userStats.put("totalPosts", 15);
        userStats.put("resolvedPosts", 12);
        userStats.put("totalFiles", 8);
        userStats.put("loginCount", 45);
        
        model.addAttribute("userStats", userStats);
        model.addAttribute("pageTitle", "내 정보 관리");
        
        return "user/profile";
    }

    /** 비밀번호 변경 (Ajax) */
    @PostMapping("/changePassword")
    @ResponseBody
    public Map<String, Object> changePassword(@RequestParam String currentPassword,
                                              @RequestParam String newPassword,
                                              HttpServletRequest request) {
        
        Map<String, Object> result = new HashMap<>();
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        
        try {
            // 현재 비밀번호 확인 (실제 구현에서는 DB에서 확인)
            String currentPasswordHash = PasswordUtil.encrypt(currentPassword);
            
            // 새 비밀번호 유효성 검사
            if (newPassword.length() < 8) {
                result.put("success", false);
                result.put("message", "새 비밀번호는 8자 이상이어야 합니다.");
                return result;
            }
            
            // 비밀번호 복잡성 검사
            if (!isValidPassword(newPassword)) {
                result.put("success", false);
                result.put("message", "비밀번호는 대소문자, 숫자, 특수문자를 포함해야 합니다.");
                return result;
            }
            
            // 새 비밀번호 해시화
            String newPasswordHash = PasswordUtil.encrypt(newPassword);
            
            // 실제 구현에서는 여기서 DB 업데이트
            // userService.updatePassword(loginUser.get("userId"), newPasswordHash);
            
            result.put("success", true);
            result.put("message", "비밀번호가 성공적으로 변경되었습니다.");
            
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "비밀번호 변경 중 오류가 발생했습니다.");
        }
        
        return result;
    }
    
    /**
     * 비밀번호 복잡성 검사
     */
    private boolean isValidPassword(String password) {
        // 최소 8자, 대문자, 소문자, 숫자, 특수문자 중 3가지 이상 포함
        int complexity = 0;
        
        if (password.matches(".*[a-z].*")) complexity++;
        if (password.matches(".*[A-Z].*")) complexity++;
        if (password.matches(".*[0-9].*")) complexity++;
        if (password.matches(".*[^a-zA-Z0-9].*")) complexity++;
        
        return complexity >= 3;
    }
}