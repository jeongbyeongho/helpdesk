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
        .detail-card {
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
        .no-data {
            text-align: center;
            padding: 40px;
            color: #999;
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
            margin: 5% auto;
            padding: 30px;
            border-radius: 8px;
            width: 500px;
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
        .form-group input, .form-group select, .form-group textarea {
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

        <!-- 코드 그룹 정보 -->
        <div class="info-card">
            <table class="info-table">
                <tr>
                    <th>코드그룹</th>
                    <td>${codeGroupInfo.code_group}</td>
                    <th>그룹명</th>
                    <td>${codeGroupInfo.code_group_nm}</td>
                </tr>
                <tr>
                    <th>사용여부</th>
                    <td>
                        <span class="status-badge ${codeGroupInfo.use_yn eq 'Y' ? 'status-active' : 'status-inactive'}">
                            ${codeGroupInfo.use_yn eq 'Y' ? '사용' : '미사용'}
                        </span>
                    </td>
                    <th>설명</th>
                    <td>${codeGroupInfo.code_group_desc}</td>
                </tr>
            </table>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/admin/code/list" class="btn btn-secondary">목록</a>
            </div>
        </div>

        <!-- 코드 상세 목록 -->
        <div class="detail-card">
            <div class="card-header">
                <h3>코드 상세 목록</h3>
                <button type="button" class="btn btn-primary btn-sm" onclick="showAddModal()">코드 추가</button>
            </div>

            <c:choose>
                <c:when test="${empty codeDetailList}">
                    <div class="no-data">
                        등록된 코드가 없습니다.
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>코드값</th>
                                <th>코드명</th>
                                <th>정렬순서</th>
                                <th>사용여부</th>
                                <th>관리</th>
                            </tr>
                        </thead>
                        <tbody id="codeDetailTable">
                            <c:forEach items="${codeDetailList}" var="code">
                                <tr data-code="${code.code_value}">
                                    <td>${code.code_value}</td>
                                    <td>${code.code_nm}</td>
                                    <td>${code.sort_order}</td>
                                    <td>
                                        <span class="status-badge ${code.use_yn eq 'Y' ? 'status-active' : 'status-inactive'}">
                                            ${code.use_yn eq 'Y' ? '사용' : '미사용'}
                                        </span>
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-primary btn-sm" 
                                                onclick="showEditModal('${code.code_value}', '${code.code_nm}', '${code.sort_order}', '${code.use_yn}', '${code.code_desc}')">
                                            수정
                                        </button>
                                        <button type="button" class="btn btn-danger btn-sm" 
                                                onclick="deleteCode('${code.code_value}', '${code.code_nm}')">
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

    <!-- 코드 추가/수정 모달 -->
    <div id="codeModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3 id="modalTitle">코드 추가</h3>
                <span class="close" onclick="closeModal()">&times;</span>
            </div>
            <form id="codeForm">
                <input type="hidden" id="codeGroup" name="codeGroup" value="${codeGroupInfo.code_group}">
                <input type="hidden" id="isEdit" value="false">
                <input type="hidden" id="originalCode" value="">

                <div class="form-group">
                    <label for="codeValue">코드값 <span class="required">*</span></label>
                    <input type="text" id="codeValue" name="codeValue" required>
                </div>

                <div class="form-group">
                    <label for="codeNm">코드명 <span class="required">*</span></label>
                    <input type="text" id="codeNm" name="codeNm" required>
                </div>

                <div class="form-group">
                    <label for="sortOrder">정렬순서</label>
                    <input type="number" id="sortOrder" name="sortOrder" min="1">
                </div>

                <div class="form-group">
                    <label for="useYn">사용여부</label>
                    <select id="useYn" name="useYn">
                        <option value="Y">사용</option>
                        <option value="N">미사용</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="codeDesc">코드설명</label>
                    <textarea id="codeDesc" name="codeDesc" rows="3"></textarea>
                </div>

                <div style="text-align: center; margin-top: 20px;">
                    <button type="submit" class="btn btn-primary">저장</button>
                    <button type="button" class="btn btn-secondary" onclick="closeModal()">취소</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function showAddModal() {
            document.getElementById('modalTitle').textContent = '코드 추가';
            document.getElementById('isEdit').value = 'false';
            document.getElementById('codeForm').reset();
            document.getElementById('codeGroup').value = '${codeGroupInfo.code_group}';
            document.getElementById('codeValue').readOnly = false;
            document.getElementById('codeModal').style.display = 'block';
        }

        function showEditModal(codeValue, codeNm, sortOrder, useYn, codeDesc) {
            document.getElementById('modalTitle').textContent = '코드 수정';
            document.getElementById('isEdit').value = 'true';
            document.getElementById('originalCode').value = codeValue;
            document.getElementById('codeGroup').value = '${codeGroupInfo.code_group}';
            document.getElementById('codeValue').value = codeValue;
            document.getElementById('codeValue').readOnly = true;
            document.getElementById('codeNm').value = codeNm;
            document.getElementById('sortOrder').value = sortOrder;
            document.getElementById('useYn').value = useYn;
            document.getElementById('codeDesc').value = codeDesc || '';
            document.getElementById('codeModal').style.display = 'block';
        }

        function closeModal() {
            document.getElementById('codeModal').style.display = 'none';
        }

        function deleteCode(codeValue, codeNm) {
            if (confirm(codeNm + ' 코드를 삭제하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/admin/code/detail/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'codeGroup=${codeGroupInfo.code_group}&codeValue=' + codeValue
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('코드가 삭제되었습니다.');
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

        // 폼 제출 처리
        document.getElementById('codeForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const isEdit = document.getElementById('isEdit').value === 'true';
            const url = isEdit ? 
                '${pageContext.request.contextPath}/admin/code/detail/update' : 
                '${pageContext.request.contextPath}/admin/code/detail/insert';
            
            const formData = new FormData(this);
            
            fetch(url, {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(isEdit ? '코드가 수정되었습니다.' : '코드가 추가되었습니다.');
                    location.reload();
                } else {
                    alert('처리 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('처리 중 오류가 발생했습니다.');
            });
        });

        // 모달 외부 클릭시 닫기
        window.onclick = function(event) {
            const modal = document.getElementById('codeModal');
            if (event.target == modal) {
                closeModal();
            }
        }
    </script>
</body>
</html>