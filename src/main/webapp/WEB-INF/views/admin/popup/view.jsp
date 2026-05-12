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
        .content-card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .content-area {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 20px;
            background: #f9f9f9;
            min-height: 200px;
            line-height: 1.6;
        }
        .preview-card {
            background: white;
            padding: 25px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .popup-preview {
            border: 2px solid #333;
            border-radius: 8px;
            background: white;
            margin: 20px auto;
            position: relative;
            box-shadow: 0 4px 20px rgba(0,0,0,0.3);
        }
        .popup-header {
            background: #f0f0f0;
            padding: 8px 15px;
            border-bottom: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-radius: 6px 6px 0 0;
        }
        .popup-title {
            font-weight: bold;
            font-size: 14px;
        }
        .popup-close {
            background: #ff5f56;
            color: white;
            border: none;
            border-radius: 50%;
            width: 16px;
            height: 16px;
            font-size: 10px;
            cursor: pointer;
        }
        .popup-body {
            padding: 20px;
            overflow: auto;
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
        .btn-test {
            background: #2196F3;
            color: white;
        }
        .btn-test:hover {
            background: #1976D2;
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
        .status-expired {
            background: #fff3e0;
            color: #ef6c00;
        }
        .status-scheduled {
            background: #e3f2fd;
            color: #1565c0;
        }
        .url-link {
            color: #2196F3;
            text-decoration: none;
        }
        .url-link:hover {
            text-decoration: underline;
        }
        .card-header {
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .card-header h3 {
            margin: 0;
            color: #333;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h2>${pageTitle}</h2>
        </div>

        <!-- 팝업 정보 -->
        <div class="info-card">
            <table class="info-table">
                <tr>
                    <th>팝업제목</th>
                    <td>${popupInfo.popup_title}</td>
                    <th>팝업타입</th>
                    <td>
                        <c:choose>
                            <c:when test="${popupInfo.popup_type eq 'NOTICE'}">공지사항</c:when>
                            <c:when test="${popupInfo.popup_type eq 'EVENT'}">이벤트</c:when>
                            <c:when test="${popupInfo.popup_type eq 'SYSTEM'}">시스템</c:when>
                            <c:when test="${popupInfo.popup_type eq 'MAINTENANCE'}">점검</c:when>
                            <c:otherwise>${popupInfo.popup_type}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>팝업크기</th>
                    <td>${popupInfo.popup_width} × ${popupInfo.popup_height} px</td>
                    <th>팝업위치</th>
                    <td>
                        <c:choose>
                            <c:when test="${popupInfo.popup_position eq 'TOP_LEFT'}">좌상단</c:when>
                            <c:when test="${popupInfo.popup_position eq 'TOP_CENTER'}">상단중앙</c:when>
                            <c:when test="${popupInfo.popup_position eq 'TOP_RIGHT'}">우상단</c:when>
                            <c:when test="${popupInfo.popup_position eq 'CENTER_LEFT'}">좌중앙</c:when>
                            <c:when test="${popupInfo.popup_position eq 'CENTER'}">정중앙</c:when>
                            <c:when test="${popupInfo.popup_position eq 'CENTER_RIGHT'}">우중앙</c:when>
                            <c:otherwise>${popupInfo.popup_position}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>시작일시</th>
                    <td><fmt:formatDate value="${popupInfo.start_dt}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <th>종료일시</th>
                    <td><fmt:formatDate value="${popupInfo.end_dt}" pattern="yyyy-MM-dd HH:mm"/></td>
                </tr>
                <tr>
                    <th>링크URL</th>
                    <td>
                        <c:if test="${not empty popupInfo.link_url}">
                            <a href="${popupInfo.link_url}" target="${popupInfo.link_target}" class="url-link">
                                ${popupInfo.link_url}
                            </a>
                        </c:if>
                    </td>
                    <th>링크타겟</th>
                    <td>
                        <c:choose>
                            <c:when test="${popupInfo.link_target eq '_self'}">현재창</c:when>
                            <c:when test="${popupInfo.link_target eq '_blank'}">새창</c:when>
                            <c:otherwise>${popupInfo.link_target}</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>오늘하루 보지않기</th>
                    <td>
                        <span class="status-badge ${popupInfo.today_close_yn eq 'Y' ? 'status-active' : 'status-inactive'}">
                            ${popupInfo.today_close_yn eq 'Y' ? '사용' : '미사용'}
                        </span>
                    </td>
                    <th>사용여부</th>
                    <td>
                        <c:set var="now" value="<%= new java.util.Date() %>" />
                        <c:choose>
                            <c:when test="${popupInfo.use_yn eq 'N'}">
                                <span class="status-badge status-inactive">미사용</span>
                            </c:when>
                            <c:when test="${popupInfo.start_dt > now}">
                                <span class="status-badge status-scheduled">예약</span>
                            </c:when>
                            <c:when test="${popupInfo.end_dt < now}">
                                <span class="status-badge status-expired">만료</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-active">활성</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>등록일</th>
                    <td><fmt:formatDate value="${popupInfo.reg_dt}" pattern="yyyy-MM-dd HH:mm"/></td>
                    <th>등록자</th>
                    <td>${popupInfo.reg_nm}</td>
                </tr>
            </table>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="${pageContext.request.contextPath}/admin/popup/form?popupSeq=${popupInfo.popup_seq}" class="btn btn-primary">수정</a>
                <button type="button" class="btn btn-test" onclick="testPopup()">팝업 테스트</button>
                <button type="button" class="btn btn-danger" onclick="deletePopup()">삭제</button>
                <a href="${pageContext.request.contextPath}/admin/popup/list" class="btn btn-secondary">목록</a>
            </div>
        </div>

        <!-- 팝업 내용 -->
        <div class="content-card">
            <div class="card-header">
                <h3>팝업 내용</h3>
            </div>
            <div class="content-area">
                ${popupInfo.popup_content}
            </div>
        </div>

        <!-- 팝업 미리보기 -->
        <div class="preview-card">
            <div class="card-header">
                <h3>팝업 미리보기</h3>
            </div>
            <div class="popup-preview" style="width: ${popupInfo.popup_width}px; height: ${popupInfo.popup_height}px;">
                <div class="popup-header">
                    <span class="popup-title">${popupInfo.popup_title}</span>
                    <button class="popup-close">×</button>
                </div>
                <div class="popup-body">
                    ${popupInfo.popup_content}
                </div>
            </div>
        </div>
    </div>

    <script>
        function deletePopup() {
            if (confirm('정말로 이 팝업을 삭제하시겠습니까?')) {
                fetch('${pageContext.request.contextPath}/admin/popup/delete', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'popupSeq=${popupInfo.popup_seq}'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('팝업이 삭제되었습니다.');
                        location.href = '${pageContext.request.contextPath}/admin/popup/list';
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

        function testPopup() {
            const popupWidth = ${popupInfo.popup_width};
            const popupHeight = ${popupInfo.popup_height};
            const popupTitle = '${popupInfo.popup_title}';
            const popupContent = `${popupInfo.popup_content}`;
            const linkUrl = '${popupInfo.link_url}';
            const linkTarget = '${popupInfo.link_target}';
            
            // 팝업 위치 계산
            const screenWidth = window.screen.width;
            const screenHeight = window.screen.height;
            let left, top;
            
            switch('${popupInfo.popup_position}') {
                case 'TOP_LEFT':
                    left = 0;
                    top = 0;
                    break;
                case 'TOP_CENTER':
                    left = (screenWidth - popupWidth) / 2;
                    top = 0;
                    break;
                case 'TOP_RIGHT':
                    left = screenWidth - popupWidth;
                    top = 0;
                    break;
                case 'CENTER_LEFT':
                    left = 0;
                    top = (screenHeight - popupHeight) / 2;
                    break;
                case 'CENTER':
                    left = (screenWidth - popupWidth) / 2;
                    top = (screenHeight - popupHeight) / 2;
                    break;
                case 'CENTER_RIGHT':
                    left = screenWidth - popupWidth;
                    top = (screenHeight - popupHeight) / 2;
                    break;
                default:
                    left = (screenWidth - popupWidth) / 2;
                    top = (screenHeight - popupHeight) / 2;
            }
            
            // 팝업 HTML 생성
            const popupHtml = `
                <!DOCTYPE html>
                <html>
                <head>
                    <meta charset="UTF-8">
                    <title>\${popupTitle}</title>
                    <style>
                        body { margin: 0; padding: 20px; font-family: 'Malgun Gothic', sans-serif; }
                        .popup-content { line-height: 1.6; }
                        .popup-footer { text-align: center; margin-top: 20px; padding-top: 15px; border-top: 1px solid #eee; }
                        .btn { padding: 8px 16px; margin: 0 5px; border: none; border-radius: 4px; cursor: pointer; }
                        .btn-close { background: #999; color: white; }
                        .btn-today { background: #4CAF50; color: white; }
                    </style>
                </head>
                <body>
                    <div class="popup-content">
                        \${popupContent}
                    </div>
                    <div class="popup-footer">
                        <button class="btn btn-today" onclick="todayClose()">오늘 하루 보지 않기</button>
                        <button class="btn btn-close" onclick="window.close()">닫기</button>
                    </div>
                    <script>
                        function todayClose() {
                            alert('오늘 하루 보지 않기가 설정되었습니다.');
                            window.close();
                        }
                        
                        \${linkUrl ? `
                        document.querySelector('.popup-content').addEventListener('click', function() {
                            if (confirm('링크로 이동하시겠습니까?')) {
                                window.open('\${linkUrl}', '\${linkTarget}');
                            }
                        });
                        ` : ''}
                    </script>
                </body>
                </html>
            `;
            
            // 팝업 창 열기
            const popup = window.open('', 'popupTest', 
                `width=\${popupWidth},height=\${popupHeight},left=\${left},top=\${top},scrollbars=yes,resizable=yes`);
            
            if (popup) {
                popup.document.write(popupHtml);
                popup.document.close();
                popup.focus();
            } else {
                alert('팝업이 차단되었습니다. 브라우저의 팝업 차단 설정을 확인해주세요.');
            }
        }
    </script>
</body>
</html>