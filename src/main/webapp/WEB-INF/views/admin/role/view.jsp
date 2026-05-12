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
        .user-list-card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #4CAF50;
        }
        .card-header h3 {
            margin: 0;
            color: #333;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        .data-table th, .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .data-table th {
            background: #f8f9fa;
            font-weight: bold;
        }
        .data-table tbody tr:hover {
            background: #f8f9fa;
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
        .btn-sm {
            padding: 5px 10px;
            font-size: 12px;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: bold;
        }
        .status-active {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .status-inactive {
            background: #ffebee;
            color: #c62828;
        }
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 2px;
            text-decoration: none;
            border: 1px solid #ddd;
            color: #333;
        }
        .pagination .current {
            background: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        .pagination a:hover {
            background: #f5f5f5;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h2>${pageTitle}</h2>
        </div>

        <!-- 권한 정보 -->
        <div class="info-card">
            <table class="info-table">
                <tr>
                    <th>권한코드</th>
                    <td>${roleInfo.role_code}</td>
                    <th>권한명</th>
                    <td>${roleInfo.role_nm}</td>
                </tr>
                <tr>
                    <th>사용여부</th>
                    <td>
                        <span class="status-badge ${roleInfo.use_yn eq 'Y' ? 'status-active' : 'status-inactive'}">
                            ${roleInfo.use_yn eq 'Y' ? '사용' : '미사용'}
                        </span>
                    </td>
                    <th>등록일</th>
                    <td><fmt:formatDate value="${roleInfo.reg_dt}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>권한설명</th>
                    <td colspan="3">${roleInfo.role_desc}</td>
                </tr>
            </table>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/admin/role/form?roleSeq=${roleInfo.role_seq}" class="btn btn-primary">수정</a>
                <button type="button" class="btn btn-danger" onclick="deleteRole()">삭제</button>
                <a href="${pageContext.request.contextPath}/admin/role/list" class="btn btn-secondary">목록</a>
            </div>
        </div>

        <!-- 권한 보유 사용자 목록 -->
        <div class="user-list-card">
            <div class="card-header">
                <h3>권한 보유 사용자 (총 ${totalCount}명)</h3>
                <button type="button" class="btn btn-primary btn-sm" onclick="showGrantModal()">권한 부여</button>
            </div>

            <c:choose>
                <c:when test="${empty userList}">
                    <div class="no-data">
                        이 권한을 보유한 사용자가 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>사용자ID</th>
                                <th>사용자명</th>
                                <th>이메일</th>
                                <th>부서</th>
                                <th>권한부여일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${userList}" var="user">
                                <tr>
                                    <td>${user.user_id}</td>
                                    <td>${user.user_nm}</td>
                                    <td>${user.email}</td>
                                    <td>${user.dept_nm}</td>
                                    <td><fmt:formatDate value="${user.grant_dt}" pattern="yyyy-MM-dd"/></td>
                                    <td>
                                        <button type="button" class="btn btn-danger btn-sm" 
                                                onclick="revokeRole('${user.user_role_seq}', '${user.user_nm}')">
                                            권한회수
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- 페이징 -->
                    <div class="pagination">
                        <c:if test="${currentPage > 1}">
                            <a href="?roleSeq=${roleInfo.role_seq}&page=${currentPage - 1}">&laquo; 이전</a>
                        </c:if>
                        
                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="current">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?roleSeq=${roleInfo.role_seq}&page=${i}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <c:if test="${currentPage < totalPages}">
                            <a href="?roleSeq=${roleInfo.role_seq}&page=${currentPage + 1}">다음 &raquo;</a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function deleteRole() {
            if (confirm('정말로 이 권한을 삭제하시겠습니까?\n권한을 보유한 사용자가 있는 경우 삭제할 수 없습니다.')) {
                fetch('${pageContext.request.contextPath}/admin/role/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'roleSeq=${roleInfo.role_seq}&roleCode=${roleInfo.role_code}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('권한이 삭제되었습니다.');
                        location.href = '${pageContext.request.contextPath}/admin/role/list';
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

        function revokeRole(userRoleSeq, userName) {
            if (confirm(userName + '님의 권한을 회수하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/admin/role/revoke', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'userRoleSeq=' + userRoleSeq
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('권한이 회수되었습니다.');
                        location.reload();
                    } else {
                        alert('권한 회수 중 오류가 발생했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('권한 회수 중 오류가 발생했습니다.');
                });
            }
        }

        function showGrantModal() {
            // TODO: 권한 부여 모달 구현
            alert('권한 부여 기능은 추후 구현 예정입니다.');
        }
    </script>
</body>
</html>