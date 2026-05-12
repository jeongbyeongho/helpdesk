package com.helpdesk.common.interceptor;

import com.helpdesk.common.util.SessionUtil;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Map;

@Component
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);

        if (loginUser == null || loginUser.isEmpty()) {
            String requestUri = request.getRequestURI();
            String queryString = request.getQueryString();
            String redirectUrl = requestUri + (queryString != null ? "?" + queryString : "");

            request.getSession().setAttribute("redirectUrl", redirectUrl);
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return false;
        }

        // 관리자 경로 접근 권한 체크
        if (requestUri(request).startsWith("/admin/")) {
            String roleCode = (String) loginUser.get("roleCode");
            if (roleCode == null || Integer.parseInt(roleCode) > 2) {
                response.sendRedirect(request.getContextPath() + "/error/403");
                return false;
            }
        }

        return true;
    }

    private String requestUri(HttpServletRequest request) {
        return request.getRequestURI().replace(request.getContextPath(), "");
    }
}
