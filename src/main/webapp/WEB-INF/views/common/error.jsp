<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>오류 - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
</head>
<body>
    <div class="wrapper">
        <header class="header">
            <div class="header-inner">
                <h1 class="logo">
                    <a href="${pageContext.request.contextPath}/">IT 서비스데스크</a>
                </h1>
            </div>
        </header>

        <main class="content">
            <div class="content-inner">
                <div class="error-page">
                    <h1>⚠️ 오류가 발생했습니다</h1>
                    <p>요청하신 페이지를 찾을 수 없거나 오류가 발생했습니다.</p>
                    <c:if test="${not empty errorMsg}">
                        <div style="background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; margin: 20px 0; border: 1px solid #f5c6cb;">
                            ${errorMsg}
                        </div>
                    </c:if>
                    
                    <div class="error-actions">
                        <a href="${pageContext.request.contextPath}/" class="btn-primary">홈으로 가기</a>
                        <a href="javascript:history.back()" class="btn">이전 페이지</a>
                    </div>
                </div>
            </div>
        </main>

        <footer class="footer">
            <p>&copy; 2024 IT Service Desk. All rights reserved.</p>
        </footer>
    </div>

    <style>
        .error-page {
            text-align: center;
            padding: 100px 20px;
        }

        .error-page h1 {
            font-size: 48px;
            color: #dc3545;
            margin-bottom: 20px;
        }

        .error-page p {
            font-size: 18px;
            color: #666;
            margin-bottom: 40px;
        }

        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
        }

        .error-actions a {
            padding: 12px 30px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 16px;
        }

        .btn-primary {
            background: #0066cc;
            color: #fff;
        }

        .btn {
            background: #6c757d;
            color: #fff;
        }
    </style>
</body>
</html>
