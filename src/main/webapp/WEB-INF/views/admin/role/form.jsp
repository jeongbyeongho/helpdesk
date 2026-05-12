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
            max-width: 600px;
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
        .required {
            color: red;
        }
        .help-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h2>${pageTitle}</h2>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/role/${empty roleInfo ? 'insert' : 'update'}">
            <c:if test="${not empty roleInfo}">
                <input type="hidden" name="roleSeq" value="${roleInfo.role_seq}">
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label for="roleCode">권한코드 <span class="required">*</span></label>
                    <input type="number" id="roleCode" name="roleCode" value="${roleInfo.role_code}" 
                           ${not empty roleInfo ? 'readonly' : ''} required min="1" max="99">
                    <div class="help-text">숫자가 낮을수록 높은 권한 (1: 최고관리자, 99: 일반사용자)</div>
                </div>
                <div class="form-group">
                    <label for="roleNm">권한명 <span class="required">*</span></label>
                    <input type="text" id="roleNm" name="roleNm" value="${roleInfo.role_nm}" required 
                           placeholder="예: 시스템관리자">
                </div>
            </div>

            <div class="form-group">
                <label for="roleDesc">권한설명</label>
                <textarea id="roleDesc" name="roleDesc" placeholder="권한에 대한 설명을 입력하세요">${roleInfo.role_desc}</textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="useYn">사용여부</label>
                    <select id="useYn" name="useYn">
                        <option value="Y" ${empty roleInfo || roleInfo.use_yn eq 'Y' ? 'selected' : ''}>사용</option>
                        <option value="N" ${roleInfo.use_yn eq 'N' ? 'selected' : ''}>미사용</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="sortOrder">정렬순서</label>
                    <input type="number" id="sortOrder" name="sortOrder" value="${roleInfo.sort_order}" min="1">
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    ${empty roleInfo ? '등록' : '수정'}
                </button>
                <a href="${pageContext.request.contextPath}/admin/role/list" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <script>
        // 권한코드 중복 체크 (등록시에만)
        <c:if test="${empty roleInfo}">
        document.getElementById('roleCode').addEventListener('blur', function() {
            const roleCode = this.value;
            if (roleCode) {
                // TODO: Ajax로 중복 체크 구현
                console.log('권한코드 중복 체크:', roleCode);
            }
        });
        </c:if>
    </script>
</body>
</html>