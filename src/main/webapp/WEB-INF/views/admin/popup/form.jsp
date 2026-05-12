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
        .form-container {
            max-width: 900px;
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
            height: 200px;
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
        .date-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .date-group input {
            flex: 1;
        }
        .checkbox-group {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .checkbox-item input[type="checkbox"] {
            width: auto;
        }
        .preview-area {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 15px;
            background: #f9f9f9;
            margin-top: 10px;
            min-height: 100px;
        }
        .position-selector {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin-top: 10px;
        }
        .position-item {
            padding: 20px;
            border: 2px solid #ddd;
            border-radius: 4px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .position-item:hover {
            border-color: #4CAF50;
            background: #f8f9fa;
        }
        .position-item.selected {
            border-color: #4CAF50;
            background: #e8f5e8;
            color: #2e7d32;
        }
        .position-item input[type="radio"] {
            display: none;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h2>${pageTitle}</h2>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/popup/${empty popupInfo ? 'insert' : 'update'}">
            <c:if test="${not empty popupInfo}">
                <input type="hidden" name="popupSeq" value="${popupInfo.popup_seq}">
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label for="popupTitle">팝업제목 <span class="required">*</span></label>
                    <input type="text" id="popupTitle" name="popupTitle" value="${popupInfo.popup_title}" required 
                           placeholder="팝업 제목을 입력하세요">
                </div>
                <div class="form-group">
                    <label for="popupType">팝업타입</label>
                    <select id="popupType" name="popupType">
                        <option value="NOTICE" ${popupInfo.popup_type eq 'NOTICE' ? 'selected' : ''}>공지사항</option>
                        <option value="EVENT" ${popupInfo.popup_type eq 'EVENT' ? 'selected' : ''}>이벤트</option>
                        <option value="SYSTEM" ${popupInfo.popup_type eq 'SYSTEM' ? 'selected' : ''}>시스템</option>
                        <option value="MAINTENANCE" ${popupInfo.popup_type eq 'MAINTENANCE' ? 'selected' : ''}>점검</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="popupWidth">팝업너비 (px)</label>
                    <input type="number" id="popupWidth" name="popupWidth" value="${popupInfo.popup_width != null ? popupInfo.popup_width : 500}" 
                           min="300" max="1200" placeholder="500">
                </div>
                <div class="form-group">
                    <label for="popupHeight">팝업높이 (px)</label>
                    <input type="number" id="popupHeight" name="popupHeight" value="${popupInfo.popup_height != null ? popupInfo.popup_height : 400}" 
                           min="200" max="800" placeholder="400">
                </div>
            </div>

            <div class="form-group">
                <label>팝업위치</label>
                <div class="position-selector">
                    <label class="position-item ${popupInfo.popup_position eq 'TOP_LEFT' || empty popupInfo.popup_position ? 'selected' : ''}">
                        <input type="radio" name="popupPosition" value="TOP_LEFT" ${popupInfo.popup_position eq 'TOP_LEFT' || empty popupInfo.popup_position ? 'checked' : ''}>
                        좌상단
                    </label>
                    <label class="position-item ${popupInfo.popup_position eq 'TOP_CENTER' ? 'selected' : ''}">
                        <input type="radio" name="popupPosition" value="TOP_CENTER" ${popupInfo.popup_position eq 'TOP_CENTER' ? 'checked' : ''}>
                        상단중앙
                    </label>
                    <label class="position-item ${popupInfo.popup_position eq 'TOP_RIGHT' ? 'selected' : ''}">
                        <input type="radio" name="popupPosition" value="TOP_RIGHT" ${popupInfo.popup_position eq 'TOP_RIGHT' ? 'checked' : ''}>
                        우상단
                    </label>
                    <label class="position-item ${popupInfo.popup_position eq 'CENTER_LEFT' ? 'selected' : ''}">
                        <input type="radio" name="popupPosition" value="CENTER_LEFT" ${popupInfo.popup_position eq 'CENTER_LEFT' ? 'checked' : ''}>
                        좌중앙
                    </label>
                    <label class="position-item ${popupInfo.popup_position eq 'CENTER' ? 'selected' : ''}">
                        <input type="radio" name="popupPosition" value="CENTER" ${popupInfo.popup_position eq 'CENTER' ? 'checked' : ''}>
                        정중앙
                    </label>
                    <label class="position-item ${popupInfo.popup_position eq 'CENTER_RIGHT' ? 'selected' : ''}">
                        <input type="radio" name="popupPosition" value="CENTER_RIGHT" ${popupInfo.popup_position eq 'CENTER_RIGHT' ? 'checked' : ''}>
                        우중앙
                    </label>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="startDt">시작일시 <span class="required">*</span></label>
                    <input type="datetime-local" id="startDt" name="startDt" 
                           value="<fmt:formatDate value='${popupInfo.start_dt}' pattern='yyyy-MM-ddTHH:mm'/>" required>
                </div>
                <div class="form-group">
                    <label for="endDt">종료일시 <span class="required">*</span></label>
                    <input type="datetime-local" id="endDt" name="endDt" 
                           value="<fmt:formatDate value='${popupInfo.end_dt}' pattern='yyyy-MM-ddTHH:mm'/>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="linkUrl">링크URL</label>
                    <input type="url" id="linkUrl" name="linkUrl" value="${popupInfo.link_url}" 
                           placeholder="https://example.com">
                    <div class="help-text">팝업 클릭시 이동할 URL (선택사항)</div>
                </div>
                <div class="form-group">
                    <label for="linkTarget">링크타겟</label>
                    <select id="linkTarget" name="linkTarget">
                        <option value="_self" ${popupInfo.link_target eq '_self' ? 'selected' : ''}>현재창</option>
                        <option value="_blank" ${popupInfo.link_target eq '_blank' || empty popupInfo.link_target ? 'selected' : ''}>새창</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="popupContent">팝업내용 <span class="required">*</span></label>
                <textarea id="popupContent" name="popupContent" required 
                          placeholder="팝업에 표시할 내용을 입력하세요. HTML 태그 사용 가능합니다.">${popupInfo.popup_content}</textarea>
                <div class="help-text">HTML 태그를 사용하여 서식을 지정할 수 있습니다.</div>
            </div>

            <div class="form-group">
                <label>미리보기</label>
                <div class="preview-area" id="previewArea">
                    <c:choose>
                        <c:when test="${not empty popupInfo.popup_content}">
                            ${popupInfo.popup_content}
                        </c:when>
                        <c:otherwise>
                            팝업 내용을 입력하면 여기에 미리보기가 표시됩니다.
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="todayCloseYn">오늘하루 보지않기</label>
                    <select id="todayCloseYn" name="todayCloseYn">
                        <option value="Y" ${empty popupInfo || popupInfo.today_close_yn eq 'Y' ? 'selected' : ''}>사용</option>
                        <option value="N" ${popupInfo.today_close_yn eq 'N' ? 'selected' : ''}>미사용</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="useYn">사용여부</label>
                    <select id="useYn" name="useYn">
                        <option value="Y" ${empty popupInfo || popupInfo.use_yn eq 'Y' ? 'selected' : ''}>사용</option>
                        <option value="N" ${popupInfo.use_yn eq 'N' ? 'selected' : ''}>미사용</option>
                    </select>
                </div>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary">
                    ${empty popupInfo ? '등록' : '수정'}
                </button>
                <a href="${pageContext.request.contextPath}/admin/popup/list" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <script>
        // 팝업 내용 실시간 미리보기
        document.getElementById('popupContent').addEventListener('input', function() {
            const content = this.value;
            const previewArea = document.getElementById('previewArea');
            
            if (content.trim()) {
                previewArea.innerHTML = content;
            } else {
                previewArea.innerHTML = '팝업 내용을 입력하면 여기에 미리보기가 표시됩니다.';
            }
        });

        // 팝업 위치 선택
        document.querySelectorAll('.position-item').forEach(item => {
            item.addEventListener('click', function() {
                // 모든 선택 해제
                document.querySelectorAll('.position-item').forEach(p => p.classList.remove('selected'));
                // 현재 선택
                this.classList.add('selected');
                // 라디오 버튼 체크
                this.querySelector('input[type="radio"]').checked = true;
            });
        });

        // 종료일시가 시작일시보다 빠르지 않도록 검증
        document.getElementById('startDt').addEventListener('change', function() {
            const startDt = new Date(this.value);
            const endDtInput = document.getElementById('endDt');
            const endDt = new Date(endDtInput.value);
            
            if (endDtInput.value && endDt <= startDt) {
                const newEndDt = new Date(startDt.getTime() + 24 * 60 * 60 * 1000); // 시작일 + 1일
                endDtInput.value = newEndDt.toISOString().slice(0, 16);
            }
        });

        document.getElementById('endDt').addEventListener('change', function() {
            const endDt = new Date(this.value);
            const startDt = new Date(document.getElementById('startDt').value);
            
            if (endDt <= startDt) {
                alert('종료일시는 시작일시보다 늦어야 합니다.');
                this.focus();
            }
        });

        // 폼 제출 전 검증
        document.querySelector('form').addEventListener('submit', function(e) {
            const startDt = new Date(document.getElementById('startDt').value);
            const endDt = new Date(document.getElementById('endDt').value);
            
            if (endDt <= startDt) {
                e.preventDefault();
                alert('종료일시는 시작일시보다 늦어야 합니다.');
                return false;
            }
        });
    </script>
</body>
</html>