<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .container {
            max-width: 1000px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .page-header {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .page-header h2 {
            color: #333;
            margin: 0;
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 10px;
        }
        .info-card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .info-table {
            width: 100%;
            border-collapse: collapse;
        }
        .info-table th, .info-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .info-table th {
            background: #f8f9fa;
            font-weight: bold;
            width: 150px;
        }
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
            margin: 0 5px;
        }
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background: #45a049;
        }
        .btn-secondary {
            background: #999;
            color: white;
        }
        .btn-secondary:hover {
            background: #777;
        }
        .btn-danger {
            background: #f44336;
            color: white;
        }
        .btn-danger:hover {
            background: #d32f2f;
        }
        .btn-warning {
            background: #ff9800;
            color: white;
        }
        .btn-warning:hover {
            background: #f57c00;
        }
        .btn-info {
            background: #2196F3;
            color: white;
        }
        .btn-info:hover {
            background: #1976D2;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-approved {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .status-pending {
            background: #fff3e0;
            color: #ef6c00;
        }
        .status-rejected {
            background: #ffebee;
            color: #c62828;
        }
        .status-active {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .status-inactive {
            background: #ffebee;
            color: #c62828;
        }
        .user-type-internal {
            background: #e3f2fd;
            color: #1565c0;
        }
        .user-type-external {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        .user-type-partner {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .user-type-customer {
            background: #fff3e0;
            color: #ef6c00;
        }
        .email-link {
            color: #2196F3;
            text-decoration: none;
        }
        .email-link:hover {
            text-decoration: underline;
        }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: white;
            margin: 10% auto;
            padding: 30px;
            border-radius: 8px;
            width: 400px;
            max-width: 90%;
        }
        .modal-header {
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .modal-header h3 {
            margin: 0;
            color: #333;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover {
            color: black;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .required {
            color: red;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h2>${pageTitle}</h2>
        </div>

        <!-- 회원 정보 -->
        <div class="info-card">
            <table class="info-table">
                <tr>
                    <th>사용자ID</th>
                    <td>${memberInfo.user_id}</td>
                    <th>사용자명</th>
                    <td>${memberInfo.user_nm}</td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td>
                        <c:if test="${not empty memberInfo.email}">
                            <a href="mailto:${memberInfo.email}" class="email-link">${memberInfo.email}</a>
                        </c:if>
                    </td>
                    <th>휴대폰번호</th>
                    <td>${memberInfo.mobile_no}</td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td>${memberInfo.tel_no}</td>
                    <th>부서명</th>
                    <td>${memberInfo.dept_nm}</td>
                </tr>
                <tr>
                    <th>직급</th>
                    <td>${memberInfo.position_nm}</td>
                    <th>사용자타입</th>
                    <td>
                        <c:choose>
                            <c:when test="${memberInfo.user_type eq 'INTERNAL'}">
                                <span class="status-badge user-type-internal">내부사용자</span>
                            </c:when>
                            <c:when test="${memberInfo.user_type eq 'EXTERNAL'}">
                                <span class="status-badge user-type-external">외부사용자</span>
                            </c:when>
                            <c:when test="${memberInfo.user_type eq 'PARTNER'}">
                                <span class="status-badge user-type-partner">협력업체</span>
                            </c:when>
                            <c:when test="${memberInfo.user_type eq 'CUSTOMER'}">
                                <span class="status-badge user-type-customer">고객</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge">${memberInfo.user_type}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>승인여부</th>
                    <td colspan="3">
                        <c:choose>
                            <c:when test="${memberInfo.approval_yn eq 'Y'}">
                                <span class="status-badge status-approved">승인</span>
                            </c:when>
                            <c:when test="${memberInfo.approval_yn eq 'N'}">
                                <span class="status-badge status-pending">미승인</span>
                            </c:when>
                            <c:when test="${memberInfo.approval_yn eq 'R'}">
                                <span class="status-badge status-rejected">반려</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-approved">승인</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>등록일</th>
                    <td><fmt:formatDate value="${memberInfo.reg_dt}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <th>최종로그인</th>
                    <td>
                        <c:choose>
                            <c:when test="${not empty memberInfo.last_login_dt}">
                                <fmt:formatDate value="${memberInfo.last_login_dt}" pattern="yyyy-MM-dd HH:mm"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>승인일</th>
                    <td>
                        <c:choose>
                            <c:when test="${not empty memberInfo.approval_dt}">
                                <fmt:formatDate value="${memberInfo.approval_dt}" pattern="yyyy-MM-dd HH:mm"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                        </c:choose>
                    </td>
                    <th>승인자</th>
                    <td>${memberInfo.approval_nm}</td>
                </tr>
                <tr>
                    <th>사용자설명</th>
                    <td colspan="3">${memberInfo.user_desc}</td>
                </tr>
            </table>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/admin/member/form/${memberInfo.user_id}" class="btn btn-primary">수정</a>
                
                <c:if test="${memberInfo.approval_yn eq 'N'}">
                    <button type="button" class="btn btn-info" onclick="approveMember()">승인</button>
                </c:if>
                
                <button type="button" class="btn btn-warning" onclick="showResetPwdModal()">비밀번호 초기화</button>
                <button type="button" class="btn btn-danger" onclick="deleteMember()">삭제</button>
                <a href="${pageContext.request.contextPath}/admin/member/list" class="btn btn-secondary">목록</a>
            </div>
        </div>
    </div>

    <!-- 비밀번호 초기화 모달 -->
    <div id="resetPwdModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>비밀번호 초기화</h3>
                <span class="close" onclick="closeResetPwdModal()">&times;</span>
            </div>
            <form id="resetPwdForm">
                <div class="form-group">
                    <label for="newPwd">새 비밀번호 <span class="required">*</span></label>
                    <input type="password" id="newPwd" name="newPwd" required 
                           placeholder="8자 이상, 영문/숫자/특수문자 조합">
                </div>

                <div class="form-group">
                    <label for="newPwdConfirm">새 비밀번호 확인 <span class="required">*</span></label>
                    <input type="password" id="newPwdConfirm" name="newPwdConfirm" required 
                           placeholder="비밀번호를 다시 입력하세요">
                </div>

                <div style="text-align: center; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">초기화</button>
                    <button type="button" class="btn btn-secondary" onclick="closeResetPwdModal()">취소</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function approveMember() {
            if (confirm('${memberInfo.user_nm}님을 승인하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/admin/member/approve', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'userId=${memberInfo.user_id}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('회원이 승인되었습니다.');
                        location.reload();
                    } else {
                        alert('승인 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('승인 중 오류가 발생했습니다.');
                });
            }
        }

        function deleteMember() {
            if (confirm('정말로 ${memberInfo.user_nm}님을 삭제하시겠습니까?\n삭제된 회원 정보는 복구할 수 없습니다.')) {
                fetch('${pageContext.request.contextPath}/admin/member/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'userId=${memberInfo.user_id}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('회원이 삭제되었습니다.');
                        location.href = '${pageContext.request.contextPath}/admin/member/list';
                    } else {
                        alert('삭제 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('삭제 중 오류가 발생했습니다.');
                });
            }
        }

        function showResetPwdModal() {
            document.getElementById('resetPwdModal').style.display = 'block';
            document.getElementById('newPwd').focus();
        }

        function closeResetPwdModal() {
            document.getElementById('resetPwdModal').style.display = 'none';
            document.getElementById('resetPwdForm').reset();
        }

        // 비밀번호 초기화 폼 제출
        document.getElementById('resetPwdForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const newPwd = document.getElementById('newPwd').value;
            const newPwdConfirm = document.getElementById('newPwdConfirm').value;

            if (newPwd.length < 8) {
                alert('비밀번호는 8자 이상이어야 합니다.');
                return;
            }

            if (newPwd !== newPwdConfirm) {
                alert('새 비밀번호가 일치하지 않습니다.');
                return;
            }

            if (confirm('${memberInfo.user_nm}님의 비밀번호를 초기화하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/admin/member/resetPwd', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'userId=${memberInfo.user_id}&newPwd=' + encodeURIComponent(newPwd)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('비밀번호가 초기화되었습니다.');
                        closeResetPwdModal();
                    } else {
                        alert('비밀번호 초기화 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('비밀번호 초기화 중 오류가 발생했습니다.');
                });
            }
        });

        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('resetPwdModal');
            if (event.target == modal) {
                closeResetPwdModal();
            }
        }
    </script>
</body>
</html>