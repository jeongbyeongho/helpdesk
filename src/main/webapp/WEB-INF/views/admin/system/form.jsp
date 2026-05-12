<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-header {
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        .form-header h2 {
            color: #333;
            margin: 0;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group textarea {
            height: 100px;
            resize: vertical;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .btn-group {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .btn {
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
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
        .btn-check {
            background: #2196F3;
            color: white;
            padding: 8px 16px;
            font-size: 12px;
            margin-left: 10px;
        }
        .btn-check:hover {
            background: #1976D2;
        }
        .required {
            color: red;
        }
        .help-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .input-group {
            display: flex;
            align-items: center;
        }
        .input-group input {
            flex: 1;
            margin-right: 10px;
        }
        .validation-msg {
            font-size: 12px;
            margin-top: 5px;
        }
        .validation-success {
            color: #4CAF50;
        }
        .validation-error {
            color: #f44336;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h2>${pageTitle}</h2>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/system/${empty systemInfo ? 'insert' : 'update'}">
            <c:if test="${not empty systemInfo}">
                <input type="hidden" name="originalSysId" value="${systemInfo.sys_id}">
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label for="sysId">시스템ID <span class="required">*</span></label>
                    <div class="input-group">
                        <input type="text" id="sysId" name="sysId" value="${systemInfo.sys_id}" 
                               ${not empty systemInfo ? 'readonly' : ''} required 
                               placeholder="영문, 숫자, 하이픈만 사용 (예: helpdesk)">
                        <c:if test="${empty systemInfo}">
                            <button type="button" class="btn btn-check" onclick="checkSysId()">중복확인</button>
                        </c:if>
                    </div>
                    <div id="sysIdValidation" class="validation-msg"></div>
                    <div class="help-text">시스템을 구분하는 고유 식별자입니다. 등록 후 변경할 수 없습니다.</div>
                </div>
                <div class="form-group">
                    <label for="sysNm">시스템명 <span class="required">*</span></label>
                    <input type="text" id="sysNm" name="sysNm" value="${systemInfo.sys_nm}" required 
                           placeholder="예: IT 서비스데스크">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="sysType">시스템타입</label>
                    <select id="sysType" name="sysType">
                        <option value="HELPDESK" ${systemInfo.sys_type eq 'HELPDESK' ? 'selected' : ''}>헬프데스크</option>
                        <option value="PORTAL" ${systemInfo.sys_type eq 'PORTAL' ? 'selected' : ''}>포털</option>
                        <option value="ADMIN" ${systemInfo.sys_type eq 'ADMIN' ? 'selected' : ''}>관리시스템</option>
                        <option value="API" ${systemInfo.sys_type eq 'API' ? 'selected' : ''}>API</option>
                        <option value="OTHER" ${systemInfo.sys_type eq 'OTHER' ? 'selected' : ''}>기타</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="sysStatus">시스템상태</label>
                    <select id="sysStatus" name="sysStatus">
                        <option value="O" ${empty systemInfo || systemInfo.sys_status eq 'O' ? 'selected' : ''}>운영</option>
                        <option value="T" ${systemInfo.sys_status eq 'T' ? 'selected' : ''}>테스트</option>
                        <option value="D" ${systemInfo.sys_status eq 'D' ? 'selected' : ''}>개발</option>
                        <option value="S" ${systemInfo.sys_status eq 'S' ? 'selected' : ''}>중단</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="sysUrl">시스템URL</label>
                    <input type="url" id="sysUrl" name="sysUrl" value="${systemInfo.sys_url}" 
                           placeholder="https://helpdesk.example.com">
                </div>
                <div class="form-group">
                    <label for="sysPort">포트</label>
                    <input type="number" id="sysPort" name="sysPort" value="${systemInfo.sys_port}" 
                           min="1" max="65535" placeholder="8080">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="dbType">DB타입</label>
                    <select id="dbType" name="dbType">
                        <option value="">선택하세요</option>
                        <option value="MSSQL" ${systemInfo.db_type eq 'MSSQL' ? 'selected' : ''}>MS SQL Server</option>
                        <option value="MYSQL" ${systemInfo.db_type eq 'MYSQL' ? 'selected' : ''}>MySQL</option>
                        <option value="ORACLE" ${systemInfo.db_type eq 'ORACLE' ? 'selected' : ''}>Oracle</option>
                        <option value="POSTGRESQL" ${systemInfo.db_type eq 'POSTGRESQL' ? 'selected' : ''}>PostgreSQL</option>
                        <option value="MARIADB" ${systemInfo.db_type eq 'MARIADB' ? 'selected' : ''}>MariaDB</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="dbName">DB명</label>
                    <input type="text" id="dbName" name="dbName" value="${systemInfo.db_name}" 
                           placeholder="helpdesk">
                </div>
            </div>

            <div class="form-group">
                <label for="sysDesc">시스템설명</label>
                <textarea id="sysDesc" name="sysDesc" placeholder="시스템에 대한 설명을 입력하세요">${systemInfo.sys_desc}</textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="managerNm">담당자명</label>
                    <input type="text" id="managerNm" name="managerNm" value="${systemInfo.manager_nm}" 
                           placeholder="홍길동">
                </div>
                <div class="form-group">
                    <label for="managerEmail">담당자이메일</label>
                    <input type="email" id="managerEmail" name="managerEmail" value="${systemInfo.manager_email}" 
                           placeholder="admin@example.com">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="managerTel">담당자연락처</label>
                    <input type="tel" id="managerTel" name="managerTel" value="${systemInfo.manager_tel}" 
                           placeholder="02-1234-5678">
                </div>
                <div class="form-group">
                    <label for="useYn">사용여부</label>
                    <select id="useYn" name="useYn">
                        <option value="Y" ${empty systemInfo || systemInfo.use_yn eq 'Y' ? 'selected' : ''}>사용</option>
                        <option value="N" ${systemInfo.use_yn eq 'N' ? 'selected' : ''}>미사용</option>
                    </select>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    ${empty systemInfo ? '등록' : '수정'}
                </button>
                <a href="${pageContext.request.contextPath}/admin/system/list" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <script>
        let sysIdChecked = ${not empty systemInfo ? 'true' : 'false'};

        function checkSysId() {
            const sysId = document.getElementById('sysId').value.trim();
            const validationDiv = document.getElementById('sysIdValidation');
            
            if (!sysId) {
                validationDiv.innerHTML = '<span class="validation-error">시스템ID를 입력하세요.</span>';
                return;
            }

            // 영문, 숫자, 하이픈만 허용
            const pattern = /^[a-zA-Z0-9-]+$/;
            if (!pattern.test(sysId)) {
                validationDiv.innerHTML = '<span class="validation-error">영문, 숫자, 하이픈만 사용할 수 있습니다.</span>';
                sysIdChecked = false;
                return;
            }

            fetch('${pageContext.request.contextPath}/admin/system/checkId?sysId=' + encodeURIComponent(sysId))
                .then(response => response.json())
                .then(isDuplicate => {
                    if (isDuplicate) {
                        validationDiv.innerHTML = '<span class="validation-error">이미 사용 중인 시스템ID입니다.</span>';
                        sysIdChecked = false;
                    } else {
                        validationDiv.innerHTML = '<span class="validation-success">사용 가능한 시스템ID입니다.</span>';
                        sysIdChecked = true;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    validationDiv.innerHTML = '<span class="validation-error">중복 확인 중 오류가 발생했습니다.</span>';
                    sysIdChecked = false;
                });
        }

        // 시스템ID 변경시 중복확인 초기화
        document.getElementById('sysId').addEventListener('input', function() {
            if (${empty systemInfo ? 'true' : 'false'}) {
                sysIdChecked = false;
                document.getElementById('sysIdValidation').innerHTML = '';
            }
        });

        // 폼 제출 전 검증
        document.querySelector('form').addEventListener('submit', function(e) {
            if (${empty systemInfo ? 'true' : 'false'} && !sysIdChecked) {
                e.preventDefault();
                alert('시스템ID 중복확인을 해주세요.');
                return false;
            }
        });
    </script>
</body>
</html>