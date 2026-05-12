<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="wrapper">
        <!-- Header -->
        <header class="header">
            <div class="header-inner">
                <h1 class="logo">
                    <a href="${pageContext.request.contextPath}/main">IT 서비스데스크</a>
                </h1>
                <nav class="gnb">
                    <ul>
                        <li><a href="${pageContext.request.contextPath}/admin/board/list">게시판관리</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/member/list">회원관리</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/menu/list">메뉴관리</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/system/list">시스템관리</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/role/list">권한관리</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/code/list">코드관리</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/popup/list">팝업관리</a></li>
                        <li><a href="${pageContext.request.contextPath}/admin/stats/access">통계</a></li>
                    </ul>
                </nav>
                <div class="user-info">
                    <span>${sessionScope.loginUser.userNm}님</span>
                    <a href="${pageContext.request.contextPath}/auth/logout">로그아웃</a>
                </div>
            </div>
        </header>

        <!-- Content -->
        <main class="content">
            <div class="content-inner">
                <h2 class="page-title">${pageTitle}</h2>
                <jsp:include page="${contentPage}" />
            </div>
        </main>

        <!-- Footer -->
        <footer class="footer">
            <p>&copy; 2024 IT Service Desk. All rights reserved.</p>
        </footer>
    </div>
</body>
</html>
