<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 대시보드 - IT 서비스데스크</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background: #f5f6fa;
            line-height: 1.6;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px 0;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header-content {
            max-width: 1400px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 30px;
        }
        .header h1 {
            font-size: 28px;
            font-weight: 600;
        }
        .header h1 a {
            color: white;
            text-decoration: none;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        .user-info span {
            font-size: 15px;
            opacity: 0.95;
        }
        .user-info a {
            padding: 10px 20px;
            background: rgba(255,255,255,0.2);
            color: white;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.3s;
        }
        .user-info a:hover {
            background: rgba(255,255,255,0.3);
        }
        .container {
            max-width: 1400px;
            margin: 30px auto;
            padding: 0 30px;
        }
        .page-title {
            font-size: 32px;
            color: #2c3e50;
            margin-bottom: 30px;
            font-weight: 600;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: all 0.3s;
            border-left: 4px solid;
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.12);
        }
        .stat-card.blue { border-left-color: #3498db; }
        .stat-card.green { border-left-color: #2ecc71; }
        .stat-card.orange { border-left-color: #f39c12; }
        .stat-card.red { border-left-color: #e74c3c; }
        .stat-card.purple { border-left-color: #9b59b6; }
        .stat-card.teal { border-left-color: #1abc9c; }
        
        .stat-icon {
            font-size: 40px;
            margin-bottom: 15px;
        }
        .stat-label {
            font-size: 14px;
            color: #7f8c8d;
            margin-bottom: 10px;
            font-weight: 500;
        }
        .stat-value {
            font-size: 36px;
            font-weight: 700;
            color: #2c3e50;
        }
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 30px;
        }
        .menu-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            text-decoration: none;
            color: #2c3e50;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;
        }
        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        .menu-icon {
            font-size: 50px;
            margin-bottom: 15px;
        }
        .menu-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 10px;
        }
        .menu-desc {
            font-size: 14px;
            color: #7f8c8d;
            line-height: 1.5;
        }
        .section-title {
            font-size: 24px;
            color: #2c3e50;
            margin: 40px 0 20px 0;
            font-weight: 600;
            padding-bottom: 10px;
            border-bottom: 3px solid #667eea;
        }
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
            .menu-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1><a href="${pageContext.request.contextPath}/admin">🛠️ 관리자 페이지</a></h1>
            <div class="user-info">
                <span>${sessionScope.LOGIN_USER.user_nm != null ? sessionScope.LOGIN_USER.user_nm : sessionScope.LOGIN_USER.userNm}님 (관리자)</span>
                <a href="${pageContext.request.contextPath}/main">사용자 페이지</a>
                <a href="${pageContext.request.contextPath}/auth/logout">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <h2 class="page-title">📊 대시보드</h2>

        <div class="stats-grid">
            <div class="stat-card blue">
                <div class="stat-icon">👥</div>
                <div class="stat-label">전체 사용자</div>
                <div class="stat-value">${stats.totalUsers}</div>
            </div>
            <div class="stat-card green">
                <div class="stat-icon">📝</div>
                <div class="stat-label">전체 문의</div>
                <div class="stat-value">${stats.totalPosts}</div>
            </div>
            <div class="stat-card orange">
                <div class="stat-icon">⏳</div>
                <div class="stat-label">대기중</div>
                <div class="stat-value">${stats.waitingPosts}</div>
            </div>
            <div class="stat-card red">
                <div class="stat-icon">🔄</div>
                <div class="stat-label">처리중</div>
                <div class="stat-value">${stats.processingPosts}</div>
            </div>
            <div class="stat-card purple">
                <div class="stat-icon">✅</div>
                <div class="stat-label">완료</div>
                <div class="stat-value">${stats.completedPosts}</div>
            </div>
            <div class="stat-card teal">
                <div class="stat-icon">📅</div>
                <div class="stat-label">오늘 문의</div>
                <div class="stat-value">${stats.todayPosts}</div>
            </div>
        </div>

        <h3 class="section-title">⚙️ 시스템 관리</h3>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/admin/system/list" class="menu-card">
                <div class="menu-icon">🖥️</div>
                <div class="menu-title">시스템 관리</div>
                <div class="menu-desc">시스템 정보 및 설정 관리</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/menu/list" class="menu-card">
                <div class="menu-icon">📋</div>
                <div class="menu-title">메뉴 관리</div>
                <div class="menu-desc">메뉴 구조 및 권한 설정</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/role/list" class="menu-card">
                <div class="menu-icon">🔐</div>
                <div class="menu-title">권한 관리</div>
                <div class="menu-desc">사용자 권한 및 역할 관리</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/code/list" class="menu-card">
                <div class="menu-icon">🏷️</div>
                <div class="menu-title">코드 관리</div>
                <div class="menu-desc">공통 코드 및 분류 관리</div>
            </a>
        </div>

        <h3 class="section-title">👥 사용자 관리</h3>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/admin/member/list" class="menu-card">
                <div class="menu-icon">👤</div>
                <div class="menu-title">회원 관리</div>
                <div class="menu-desc">사용자 계정 및 정보 관리</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/board/list" class="menu-card">
                <div class="menu-icon">📰</div>
                <div class="menu-title">게시판 관리</div>
                <div class="menu-desc">게시판 생성 및 설정 관리</div>
            </a>
            <a href="${pageContext.request.contextPath}/admin/popup/list" class="menu-card">
                <div class="menu-icon">🔔</div>
                <div class="menu-title">팝업 관리</div>
                <div class="menu-desc">공지 팝업 등록 및 관리</div>
            </a>
        </div>

        <h3 class="section-title">📊 통계 및 모니터링</h3>
        <div class="menu-grid">
            <a href="${pageContext.request.contextPath}/admin/stats/access" class="menu-card">
                <div class="menu-icon">📈</div>
                <div class="menu-title">접속 통계</div>
                <div class="menu-desc">사용자 접속 및 활동 통계</div>
            </a>
            <a href="${pageContext.request.contextPath}/user/post/list?boardId=1" class="menu-card">
                <div class="menu-icon">📝</div>
                <div class="menu-title">문의 관리</div>
                <div class="menu-desc">사용자 문의 확인 및 답변</div>
            </a>
        </div>
    </div>
</body>
</html>
