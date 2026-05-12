package com.helpdesk.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Map;

public class SessionUtil {

    private static final String LOGIN_USER_KEY = "LOGIN_USER";

    public static void setLoginUser(HttpServletRequest request, Map<String, Object> userInfo) {
        request.getSession().setAttribute(LOGIN_USER_KEY, userInfo);
    }

    @SuppressWarnings("unchecked")
    public static Map<String, Object> getLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        return (Map<String, Object>) session.getAttribute(LOGIN_USER_KEY);
    }

    public static void removeLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }

    public static String getLoginUserId(HttpServletRequest request) {
        Map<String, Object> user = getLoginUser(request);
        if (user == null) return null;
        return (String) user.get("userId");
    }

    public static String getLoginUserName(HttpServletRequest request) {
        Map<String, Object> user = getLoginUser(request);
        if (user == null) return null;
        return (String) user.get("userNm");
    }

    public static String getLoginSysId(HttpServletRequest request) {
        Map<String, Object> user = getLoginUser(request);
        if (user == null) return null;
        return (String) user.get("sysId");
    }

    public static boolean isLoggedIn(HttpServletRequest request) {
        return getLoginUser(request) != null;
    }
}
