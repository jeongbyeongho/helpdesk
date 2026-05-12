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
        .required {
            color: red;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h2>${pageTitle}</h2>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/menu/${empty menuInfo ? 'insert' : 'update'}">
            <c:if test="${not empty menuInfo}">
                <input type="hidden" name="menuId" value="${menuInfo.menu_id}">
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label for="menuNm">메뉴명 <span class="required">*</span></label>
                    <input type="text" id="menuNm" name="menuNm" value="${menuInfo.menu_nm}" required>
                </div>
                <div class="form-group">
                    <label for="menuType">메뉴타입 <span class="required">*</span></label>
                    <select id="menuType" name="menuType" required>
                        <option value="">선택하세요</option>
                        <option value="FOLDER" ${menuInfo.menu_type eq 'FOLDER' ? 'selected' : ''}>폴더</option>
                        <option value="BOARD" ${menuInfo.menu_type eq 'BOARD' ? 'selected' : ''}>게시판</option>
                        <option value="LINK" ${menuInfo.menu_type eq 'LINK' ? 'selected' : ''}>링크</option>
                        <option value="PROGRAM" ${menuInfo.menu_type eq 'PROGRAM' ? 'selected' : ''}>프로그램</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="upperMenuId">상위메뉴</label>
                    <select id="upperMenuId" name="upperMenuId">
                        <option value="">최상위 메뉴</option>
                        <c:forEach items="${upperMenuList}" var="menu">
                            <option value="${menu.menu_id}" ${menuInfo.upper_menu_id eq menu.menu_id ? 'selected' : ''}>
                                ${menu.menu_nm}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="form-group">
                    <label for="sortOrder">정렬순서</label>
                    <input type="number" id="sortOrder" name="sortOrder" value="${menuInfo.sort_order != null ? menuInfo.sort_order : nextSortOrder}" min="1">
                </div>
            </div>

            <div class="form-group">
                <label for="menuUrl">메뉴URL</label>
                <input type="text" id="menuUrl" name="menuUrl" value="${menuInfo.menu_url}" placeholder="예: /admin/board/list">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="menuIcon">메뉴아이콘</label>
                    <input type="text" id="menuIcon" name="menuIcon" value="${menuInfo.menu_icon}" placeholder="예: fa-home">
                </div>
                <div class="form-group">
                    <label for="useYn">사용여부</label>
                    <select id="useYn" name="useYn">
                        <option value="Y" ${empty menuInfo || menuInfo.use_yn eq 'Y' ? 'selected' : ''}>사용</option>
                        <option value="N" ${menuInfo.use_yn eq 'N' ? 'selected' : ''}>미사용</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="menuDesc">메뉴설명</label>
                <textarea id="menuDesc" name="menuDesc" placeholder="메뉴에 대한 설명을 입력하세요">${menuInfo.menu_desc}</textarea>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    ${empty menuInfo ? '등록' : '수정'}
                </button>
                <a href="${pageContext.request.contextPath}/admin/menu/list" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <script>
        document.getElementById('menuType').addEventListener('change', function() {
            const menuUrl = document.getElementById('menuUrl');
            const value = this.value;
            
            if (value === 'BOARD') {
                menuUrl.placeholder = '예: /user/post/list?boardId=1';
            } else if (value === 'LINK') {
                menuUrl.placeholder = '예: https://example.com';
            } else if (value === 'PROGRAM') {
                menuUrl.placeholder = '예: /admin/system/list';
            } else {
                menuUrl.placeholder = '예: /admin/board/list';
            }
        });
    </script>
</body>
</html>