<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보 관리 - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background: #f5f5f5;
            line-height: 1.6;
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
        .header h1 a {
            color: inherit;
            text-decoration: none;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info span {
            color: #555;
        }
        .user-info a {
            padding: 8px 15px;
            background: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
        }
        .user-info a:hover {
            background: #d32f2f;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .breadcrumb {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .breadcrumb a {
            color: #4CAF50;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        .breadcrumb span {
            color: #666;
            margin: 0 8px;
        }
        .page-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px solid #4CAF50;
        }
        .profile-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
        }
        .profile-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .card-header {
            padding: 25px 30px;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
        }
        .card-header h3 {
            font-size: 20px;
            margin-bottom: 5px;
        }
        .card-header p {
            opacity: 0.9;
            font-size: 14px;
        }
        .card-content {
            padding: 30px;
        }
        .info-group {
            margin-bottom: 25px;
        }
        .info-label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .info-value {
            padding: 12px 15px;
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 6px;
            color: #495057;
            font-size: 15px;
        }
        .form-group {
            margin-bottom: 25px;
        }
        .form-group label {
            display: block;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .form-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            transition: all 0.3s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
        }
        .required {
            color: #dc3545;
            margin-left: 3px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .btn-outline {
            background: transparent;
            color: #4CAF50;
            border: 2px solid #4CAF50;
        }
        .btn-outline:hover {
            background: #4CAF50;
            color: white;
        }
        .password-strength {
            margin-top: 8px;
            font-size: 12px;
        }
        .strength-weak { color: #dc3545; }
        .strength-medium { color: #ffc107; }
        .strength-strong { color: #28a745; }
        .activity-list {
            max-height: 400px;
            overflow-y: auto;
        }
        .activity-item {
            padding: 15px 0;
            border-bottom: 1px solid #e9ecef;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .activity-item:last-child {
            border-bottom: none;
        }
        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            color: white;
        }
        .activity-login { background: #4CAF50; }
        .activity-post { background: #2196F3; }
        .activity-file { background: #FF9800; }
        .activity-info {
            flex: 1;
        }
        .activity-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 3px;
        }
        .activity-desc {
            font-size: 13px;
            color: #666;
        }
        .activity-time {
            font-size: 12px;
            color: #999;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #4CAF50;
            margin-bottom: 5px;
        }
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }
            .profile-container {
                grid-template-columns: 1fr;
            }
            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1><a href="${pageContext.request.contextPath}/main">IT 서비스데스크</a></h1>
            <div class="user-info">
                <span>${sessionScope.LOGIN_USER.user_nm != null ? sessionScope.LOGIN_USER.user_nm : sessionScope.LOGIN_USER.userNm}님</span>
                <a href="${pageContext.request.contextPath}/auth/logout">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/main">홈</a>
            <span>></span>
            <span>내 정보 관리</span>
        </div>

        <h2 class="page-title">👤 내 정보 관리</h2>

        <div class="profile-container">
            <!-- 기본 정보 -->
            <div class="profile-card">
                <div class="card-header">
                    <h3>📋 기본 정보</h3>
                    <p>계정의 기본 정보를 확인할 수 있습니다</p>
                </div>
                <div class="card-content">
                    <div class="info-group">
                        <span class="info-label">사용자 ID</span>
                        <div class="info-value">${sessionScope.LOGIN_USER.user_id != null ? sessionScope.LOGIN_USER.user_id : sessionScope.LOGIN_USER.userId}</div>
                    </div>
                    <div class="info-group">
                        <span class="info-label">이름</span>
                        <div class="info-value">${sessionScope.LOGIN_USER.user_nm != null ? sessionScope.LOGIN_USER.user_nm : sessionScope.LOGIN_USER.userNm}</div>
                    </div>
                    <div class="info-group">
                        <span class="info-label">부서</span>
                        <div class="info-value">${sessionScope.LOGIN_USER.dept_nm != null ? sessionScope.LOGIN_USER.dept_nm : '미설정'}</div>
                    </div>
                    <div class="info-group">
                        <span class="info-label">이메일</span>
                        <div class="info-value">${sessionScope.LOGIN_USER.email != null ? sessionScope.LOGIN_USER.email : '미설정'}</div>
                    </div>
                    <div class="info-group">
                        <span class="info-label">연락처</span>
                        <div class="info-value">${sessionScope.LOGIN_USER.mobile_no != null ? sessionScope.LOGIN_USER.mobile_no : '미설정'}</div>
                    </div>
                    <div class="info-group">
                        <span class="info-label">가입일</span>
                        <div class="info-value">
                            <fmt:formatDate value="${sessionScope.LOGIN_USER.reg_dt}" pattern="yyyy년 MM월 dd일"/>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 비밀번호 변경 -->
            <div class="profile-card">
                <div class="card-header">
                    <h3>🔒 비밀번호 변경</h3>
                    <p>보안을 위해 정기적으로 비밀번호를 변경해주세요</p>
                </div>
                <div class="card-content">
                    <form id="passwordForm">
                        <div class="form-group">
                            <label for="currentPassword">현재 비밀번호 <span class="required">*</span></label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="newPassword">새 비밀번호 <span class="required">*</span></label>
                            <input type="password" id="newPassword" name="newPassword" required>
                            <div id="passwordStrength" class="password-strength"></div>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">새 비밀번호 확인 <span class="required">*</span></label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required>
                        </div>
                        <button type="submit" class="btn btn-primary">🔐 비밀번호 변경</button>
                    </form>
                </div>
            </div>
        </div>

        <!-- 활동 통계 -->
        <div class="profile-card" style="margin-top: 30px;">
            <div class="card-header">
                <h3>📊 나의 활동 통계</h3>
                <p>최근 활동 현황을 확인할 수 있습니다</p>
            </div>
            <div class="card-content">
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-number">${userStats.totalPosts != null ? userStats.totalPosts : 0}</div>
                        <div class="stat-label">총 문의 수</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${userStats.resolvedPosts != null ? userStats.resolvedPosts : 0}</div>
                        <div class="stat-label">해결된 문의</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${userStats.totalFiles != null ? userStats.totalFiles : 0}</div>
                        <div class="stat-label">첨부 파일 수</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-number">${userStats.loginCount != null ? userStats.loginCount : 0}</div>
                        <div class="stat-label">로그인 횟수</div>
                    </div>
                </div>

                <!-- 최근 활동 -->
                <h4 style="margin-bottom: 20px; color: #333;">🕒 최근 활동</h4>
                <div class="activity-list">
                    <c:choose>
                        <c:when test="${empty recentActivities}">
                            <div style="text-align: center; padding: 40px; color: #666;">
                                최근 활동 내역이 없습니다.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${recentActivities}" var="activity">
                                <div class="activity-item">
                                    <div class="activity-icon activity-${activity.type}">
                                        <c:choose>
                                            <c:when test="${activity.type == 'login'}">🔑</c:when>
                                            <c:when test="${activity.type == 'post'}">📝</c:when>
                                            <c:when test="${activity.type == 'file'}">📎</c:when>
                                            <c:otherwise>📋</c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="activity-info">
                                        <div class="activity-title">${activity.title}</div>
                                        <div class="activity-desc">${activity.description}</div>
                                    </div>
                                    <div class="activity-time">
                                        <fmt:formatDate value="${activity.regDt}" pattern="MM-dd HH:mm"/>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // 비밀번호 강도 체크
            $('#newPassword').on('input', function() {
                checkPasswordStrength($(this).val());
            });

            // 비밀번호 확인 체크
            $('#confirmPassword').on('input', function() {
                checkPasswordMatch();
            });

            // 폼 제출
            $('#passwordForm').on('submit', function(e) {
                e.preventDefault();
                changePassword();
            });
        });

        function checkPasswordStrength(password) {
            var strength = 0;
            var strengthText = '';
            var strengthClass = '';

            if (password.length >= 8) strength++;
            if (/[a-z]/.test(password)) strength++;
            if (/[A-Z]/.test(password)) strength++;
            if (/[0-9]/.test(password)) strength++;
            if (/[^A-Za-z0-9]/.test(password)) strength++;

            if (strength < 3) {
                strengthText = '약함 - 대소문자, 숫자, 특수문자를 포함해주세요';
                strengthClass = 'strength-weak';
            } else if (strength < 4) {
                strengthText = '보통 - 더 안전한 비밀번호를 사용해보세요';
                strengthClass = 'strength-medium';
            } else {
                strengthText = '강함 - 안전한 비밀번호입니다';
                strengthClass = 'strength-strong';
            }

            $('#passwordStrength').text(strengthText).attr('class', 'password-strength ' + strengthClass);
        }

        function checkPasswordMatch() {
            var newPassword = $('#newPassword').val();
            var confirmPassword = $('#confirmPassword').val();

            if (confirmPassword && newPassword !== confirmPassword) {
                $('#confirmPassword')[0].setCustomValidity('비밀번호가 일치하지 않습니다.');
            } else {
                $('#confirmPassword')[0].setCustomValidity('');
            }
        }

        function changePassword() {
            var currentPassword = $('#currentPassword').val();
            var newPassword = $('#newPassword').val();
            var confirmPassword = $('#confirmPassword').val();

            if (!currentPassword || !newPassword || !confirmPassword) {
                alert('모든 필드를 입력해주세요.');
                return;
            }

            if (newPassword !== confirmPassword) {
                alert('새 비밀번호가 일치하지 않습니다.');
                return;
            }

            if (newPassword.length < 8) {
                alert('새 비밀번호는 8자 이상이어야 합니다.');
                return;
            }

            if (!confirm('비밀번호를 변경하시겠습니까?')) {
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/user/profile/changePassword',
                type: 'POST',
                data: {
                    currentPassword: currentPassword,
                    newPassword: newPassword
                },
                success: function(result) {
                    if (result.success) {
                        alert('✅ 비밀번호가 성공적으로 변경되었습니다.');
                        $('#passwordForm')[0].reset();
                        $('#passwordStrength').text('');
                    } else {
                        alert('❌ ' + (result.message || '비밀번호 변경에 실패했습니다.'));
                    }
                },
                error: function() {
                    alert('❌ 비밀번호 변경 중 오류가 발생했습니다.');
                }
            });
        }
    </script>
</body>
</html>