package com.helpdesk.user.auth.controller;

import com.helpdesk.common.util.SessionUtil;
import com.helpdesk.user.auth.service.LoginService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@Controller
@RequestMapping("/auth")
public class LoginController {

    @Autowired
    private LoginService loginService;

    @Value("${system.password-change-cycle:6}")
    private int pwdChangeCycle;

    /** 로그인 페이지 */
    @GetMapping("/login")
    public String loginPage(HttpServletRequest request, Model model) {
        if (SessionUtil.isLoggedIn(request)) {
            return "redirect:/main";
        }
        return "common/login";
    }

    /** 로그인 처리 */
    @PostMapping("/login")
    public String loginProcess(
            @RequestParam String userId,
            @RequestParam String userPwd,
            @RequestParam(defaultValue = "helpdesk") String sysId,
            HttpServletRequest request,
            Model model) {

        Map<String, Object> userInfo = loginService.login(userId, userPwd, sysId);

        if (userInfo == null) {
            model.addAttribute("errorMsg", "아이디 또는 비밀번호가 올바르지 않습니다.");
            return "common/login";
        }

        // 비승인 사용자 체크
        String approvalYn = (String) userInfo.get("approvalYn");
        if (approvalYn == null) approvalYn = (String) userInfo.get("approval_yn");
        if ("N".equals(approvalYn)) {
            model.addAttribute("errorMsg", "승인 대기 중인 계정입니다. 관리자에게 문의하세요.");
            return "common/login";
        }

        SessionUtil.setLoginUser(request, userInfo);

        // 비밀번호 변경 주기 체크
        if (loginService.isPwdChangeRequired(userId, pwdChangeCycle)) {
            return "redirect:/auth/change-password";
        }

        // 이전 요청 URL로 리다이렉트
        String redirectUrl = (String) request.getSession().getAttribute("redirectUrl");
        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            request.getSession().removeAttribute("redirectUrl");
            return "redirect:" + redirectUrl;
        }

        return "redirect:/main";
    }

    /** 로그아웃 */
    @GetMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        SessionUtil.removeLoginUser(request);
        return "redirect:/auth/login";
    }

    /** 비밀번호 변경 페이지 */
    @GetMapping("/change-password")
    public String changePwdPage() {
        return "common/change_password";
    }

    /** 비밀번호 변경 처리 */
    @PostMapping("/change-password")
    public String changePwdProcess(
            @RequestParam String newPwd,
            @RequestParam String confirmPwd,
            HttpServletRequest request,
            Model model) {

        if (!newPwd.equals(confirmPwd)) {
            model.addAttribute("errorMsg", "새 비밀번호가 일치하지 않습니다.");
            return "common/change_password";
        }

        String userId = SessionUtil.getLoginUserId(request);
        loginService.changePassword(userId, newPwd);

        return "redirect:/main";
    }
}
