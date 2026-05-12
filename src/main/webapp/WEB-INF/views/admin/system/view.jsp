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
            max-width: 1200px;
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
        .domain-card {
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
        .status-operation {
            background: #e3f2fd;
            color: #1565c0;
        }
        .status-test {
            background: #fff3e0;
            color: #ef6c00;
        }
        .status-dev {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        .status-stop {
            background: #ffebee;
            color: #c62828;
        }
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
        }
        .url-link {
            color: #2196F3;
            text-decoration: none;
        }
        .url-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h2>${pageTitle}</h2>
        </div>

        <!-- 시스템 정보 -->
        <div class="info-card">
            <table class="info-table">
                <tr>
                    <th>시스템ID</th>
                    <td>${systemInfo.sys_id}</td>
                    <th>시스템명</th>
                    <td>${systemInfo.sys_nm}</td>
                </tr>
                <tr>
                    <th>시스템타입</th>
                    <td>
                        <c:choose>
                            <c:when test="${systemInfo.sys_type eq 'HELPDESK'}">헬프데스크</c:when>
                            <c:when test="${systemInfo.sys_type eq 'PORTAL'}">포털</c:when>
                            <c:when test="${systemInfo.sys_type eq 'ADMIN'}">관리시스템</c:when>
                            <c:when test="${systemInfo.sys_type eq 'API'}">API</c:when>
                            <c:otherwise>기타</c:otherwise>
                        </c:choose>
                    </td>
                    <th>시스템상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${systemInfo.sys_status eq 'O'}">
                                <span class="status-badge status-operation">운영</span>
                            </c:when>
                            <c:when test="${systemInfo.sys_status eq 'T'}">
                                <span class="status-badge status-test">테스트</span>
                            </c:when>
                            <c:when test="${systemInfo.sys_status eq 'D'}">
                                <span class="status-badge status-dev">개발</span>
                            </c:when>
                            <c:when test="${systemInfo.sys_status eq 'S'}">
                                <span class="status-badge status-stop">중단</span>
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>시스템URL</th>
                    <td>
                        <c:if test="${not empty systemInfo.sys_url}">
                            <a href="${systemInfo.sys_url}" target="_blank" class="url-link">${systemInfo.sys_url}</a>
                        </c:if>
                    </td>
                    <th>포트</th>
                    <td>${systemInfo.sys_port}</td>
                </tr>
                <tr>
                    <th>DB타입</th>
                    <td>
                        <c:choose>
                            <c:when test="${systemInfo.db_type eq 'MSSQL'}">MS SQL Server</c:when>
                            <c:when test="${systemInfo.db_type eq 'MYSQL'}">MySQL</c:when>
                            <c:when test="${systemInfo.db_type eq 'ORACLE'}">Oracle</c:when>
                            <c:when test="${systemInfo.db_type eq 'POSTGRESQL'}">PostgreSQL</c:when>
                            <c:when test="${systemInfo.db_type eq 'MARIADB'}">MariaDB</c:when>
                            <c:otherwise>${systemInfo.db_type}</c:otherwise>
                        </c:choose>
                    </td>
                    <th>DB명</th>
                    <td>${systemInfo.db_name}</td>
                </tr>
                <tr>
                    <th>담당자명</th>
                    <td>${systemInfo.manager_nm}</td>
                    <th>담당자이메일</th>
                    <td>
                        <c:if test="${not empty systemInfo.manager_email}">
                            <a href="mailto:${systemInfo.manager_email}" class="url-link">${systemInfo.manager_email}</a>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <th>담당자연락처</th>
                    <td>${systemInfo.manager_tel}</td>
                    <th>사용여부</th>
                    <td>
                        <span class="status-badge ${systemInfo.use_yn eq 'Y' ? 'status-active' : 'status-inactive'}">
                            ${systemInfo.use_yn eq 'Y' ? '사용' : '미사용'}
                        </span>
                    </td>
                </tr>
                <tr>
                    <th>등록일</th>
                    <td><fmt:formatDate value="${systemInfo.reg_dt}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <th>등록자</th>
                    <td>${systemInfo.reg_nm}</td>
                </tr>
                <tr>
                    <th>시스템설명</th>
                    <td colspan="3">${systemInfo.sys_desc}</td>
                </tr>
            </table>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/admin/system/form?sysId=${systemInfo.sys_id}" class="btn btn-primary">수정</a>
                <button type="button" class="btn btn-danger" onclick="deleteSystem()">삭제</button>
                <a href="${pageContext.request.contextPath}/admin/system/list" class="btn btn-secondary">목록</a>
            </div>
        </div>

        <!-- 도메인 목록 -->
        <div class="domain-card">
            <div class="card-header">
                <h3>도메인 목록</h3>
                <button type="button" class="btn btn-primary btn-sm" onclick="showDomainModal()">도메인 추가</button>
            </div>

            <c:choose>
                <c:when test="${empty domainList}">
                    <div class="no-data">
                        등록된 도메인이 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>도메인명</th>
                                <th>도메인URL</th>
                                <th>포트</th>
                                <th>SSL사용</th>
                                <th>사용여부</th>
                                <th>등록일</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${domainList}" var="domain">
                                <tr>
                                    <td>${domain.domain_nm}</td>
                                    <td>
                                        <c:if test="${not empty domain.domain_url}">
                                            <a href="${domain.domain_url}" target="_blank" class="url-link">${domain.domain_url}</a>
                                        </c:if>
                                    </td>
                                    <td>${domain.domain_port}</td>
                                    <td>
                                        <span class="status-badge ${domain.ssl_yn eq 'Y' ? 'status-active' : 'status-inactive'}">
                                            ${domain.ssl_yn eq 'Y' ? 'SSL' : 'HTTP'}
                                        </span>
                                    </td>
                                    <td>
                                        <span class="status-badge ${domain.use_yn eq 'Y' ? 'status-active' : 'status-inactive'}">
                                            ${domain.use_yn eq 'Y' ? '사용' : '미사용'}
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${domain.reg_dt}" pattern="yyyy-MM-dd"/></td>
                                    <td>
                                        <button type="button" class="btn btn-primary btn-sm" 
                                                onclick="editDomain('${domain.domain_seq}', '${domain.domain_nm}', '${domain.domain_url}', '${domain.domain_port}', '${domain.ssl_yn}', '${domain.use_yn}', '${domain.domain_desc}')">
                                            수정
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" 
                                                onclick="deleteDomain('${domain.domain_seq}', '${domain.domain_nm}')">
                                            삭제
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function deleteSystem() {
            if (confirm('정말로 이 시스템을 삭제하시겠습니까?\n관련된 모든 데이터가 삭제됩니다.')) {
                fetch('${pageContext.request.contextPath}/admin/system/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'sysId=${systemInfo.sys_id}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('시스템이 삭제되었습니다.');
                        location.href = '${pageContext.request.contextPath}/admin/system/list';
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

        function showDomainModal() {
            // TODO: 도메인 추가 모달 구현
            alert('도메인 추가 기능은 추후 구현 예정입니다.');
        }

        function editDomain(domainSeq, domainNm, domainUrl, domainPort, sslYn, useYn, domainDesc) {
            // TODO: 도메인 수정 모달 구현
            alert('도메인 수정 기능은 추후 구현 예정입니다.');
        }

        function deleteDomain(domainSeq, domainNm) {
            if (confirm(domainNm + ' 도메인을 삭제하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/admin/system/domain/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'domainSeq=' + domainSeq
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('도메인이 삭제되었습니다.');
                        location.reload();
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
    </script>
</body>
</html>