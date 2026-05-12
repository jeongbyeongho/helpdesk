<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:useBean id="now" class="java.util.Date" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background: #f5f5f5;
        }
        .header {
            background: white;
            border-bottom: 2px solid #4CAF50;
            padding: 15px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        .header h1 {
            color: #4CAF50;
            font-size: 24px;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info span {
            color: #555;
        }
        .btn-logout {
            padding: 8px 15px;
            background: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-logout:hover {
            background: #d32f2f;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .dashboard {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .card h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #4CAF50;
        }
        .stat-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        .stat-item:last-child {
            border-bottom: none;
        }
        .stat-label {
            color: #666;
        }
        .stat-value {
            font-weight: bold;
            color: #4CAF50;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 20px;
        }
        .menu-item {
            background: white;
            padding: 30px 20px;
            border-radius: 8px;
            text-align: center;
            text-decoration: none;
            color: #333;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        .menu-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            background: #4CAF50;
            color: white;
        }
        .menu-item i {
            font-size: 40px;
            margin-bottom: 10px;
            display: block;
        }
        .menu-item span {
            font-size: 16px;
            font-weight: bold;
        }
        .notice-list {
            list-style: none;
        }
        .notice-list li {
            padding: 12px 0;
            border-bottom: 1px solid #eee;
        }
        .notice-list li:last-child {
            border-bottom: none;
        }
        .notice-list a {
            text-decoration: none;
            color: #333;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .notice-list a:hover {
            color: #4CAF50;
        }
        .notice-title {
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        .notice-date {
            color: #999;
            font-size: 14px;
            margin-left: 10px;
        }
        .badge-new {
            background: #f44336;
            color: white;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 11px;
            margin-left: 5px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>IT 서비스데스크</h1>
            <div class="user-info">
                <span><strong>${sessionScope.LOGIN_USER.user_nm != null ? sessionScope.LOGIN_USER.user_nm : sessionScope.LOGIN_USER.userNm}</strong>님 환영합니다</span>
                <a href="${pageContext.request.contextPath}/auth/logout" class="btn-logout">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="dashboard">
            <div class="card">
                <h2>나의 요청 현황 (<fmt:formatDate value="${now}" pattern="yyyy"/>년)</h2>
                <div class="stat-item">
                    <span class="stat-label">대기중</span>
                    <span class="stat-value">${myStats.waiting != null ? myStats.waiting : 0}건</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">접수</span>
                    <span class="stat-value">${myStats.received != null ? myStats.received : 0}건</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">처리중</span>
                    <span class="stat-value">${myStats.processing != null ? myStats.processing : 0}건</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">완료</span>
                    <span class="stat-value">${myStats.completed != null ? myStats.completed : 0}건</span>
                </div>
            </div>

            <div class="card">
                <h2>전체 현황 (<fmt:formatDate value="${now}" pattern="yyyy"/>년)</h2>
                <div class="stat-item">
                    <span class="stat-label">대기중</span>
                    <span class="stat-value">${totalStats.waiting != null ? totalStats.waiting : 0}건</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">접수</span>
                    <span class="stat-value">${totalStats.received != null ? totalStats.received : 0}건</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">처리중</span>
                    <span class="stat-value">${totalStats.processing != null ? totalStats.processing : 0}건</span>
                </div>
                <div class="stat-item">
                    <span class="stat-label">완료</span>
                    <span class="stat-value">${totalStats.completed != null ? totalStats.completed : 0}건</span>
                </div>
            </div>

            <div class="card">
                <h2>공지사항</h2>
                <ul class="notice-list">
                    <c:choose>
                        <c:when test="${empty noticeList}">
                            <li style="text-align: center; color: #999; padding: 20px 0;">
                                등록된 공지사항이 없습니다.
                            </li>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${noticeList}" var="notice" begin="0" end="4">
                                <li>
                                    <a href="${pageContext.request.contextPath}/user/post/view?postSeq=${notice.post_seq}">
                                        <span class="notice-title">
                                            ${notice.post_title}
                                            <c:if test="${notice.is_new eq 'Y'}">
                                                <span class="badge-new">NEW</span>
                                            </c:if>
                                        </span>
                                        <span class="notice-date">
                                            <fmt:formatDate value="${notice.reg_dt}" pattern="yyyy-MM-dd"/>
                                        </span>
                                    </a>
                                </li>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </div>
        </div>

        <div class="card">
            <h2>메뉴</h2>
            <div class="menu-grid">
                <!-- 동적 게시판 목록 -->
                <c:forEach items="${boardList}" var="board">
                    <a href="${pageContext.request.contextPath}/user/post/list?boardId=${board.board_id}" class="menu-item">
                        <i>
                            <c:choose>
                                <c:when test="${board.board_type == 'QNA'}">❓</c:when>
                                <c:when test="${board.board_type == 'FAQ'}">💡</c:when>
                                <c:when test="${board.board_type == 'GAL'}">🖼️</c:when>
                                <c:otherwise>📝</c:otherwise>
                            </c:choose>
                        </i>
                        <span>${board.board_title}</span>
                    </a>
                </c:forEach>
                
                <!-- 고정 메뉴 -->
                <a href="${pageContext.request.contextPath}/user/post/list?searchOnlyMine=Y" class="menu-item">
                    <i>📋</i>
                    <span>내 문의</span>
                </a>
                <a href="${pageContext.request.contextPath}/user/profile" class="menu-item">
                    <i>👤</i>
                    <span>내 정보</span>
                </a>
                <c:if test="${sessionScope.LOGIN_USER.roleCode <= 2 or sessionScope.LOGIN_USER.role_code <= 2}">
                    <a href="${pageContext.request.contextPath}/admin" class="menu-item">
                        <i>⚙️</i>
                        <span>관리자</span>
                    </a>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
