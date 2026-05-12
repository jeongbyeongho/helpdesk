<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - IT 서비스데스크</title>
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

        .post-view {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            overflow: hidden;
        }
        .post-header {
            padding: 30px;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
        }
        .post-title {
            font-size: 28px;
            margin-bottom: 20px;
            font-weight: 600;
        }
        .post-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 8px;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .meta-label {
            font-weight: 600;
            opacity: 0.9;
        }
        .meta-value {
            opacity: 0.8;
        }
        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-W { background: #ff9800; color: white; }
        .status-R { background: #2196f3; color: white; }
        .status-P { background: #9c27b0; color: white; }
        .status-C { background: #4caf50; color: white; }
        .status-H { background: #f44336; color: white; }
        .post-content {
            padding: 40px 30px;
            min-height: 300px;
            line-height: 1.8;
            font-size: 16px;
            color: #333;
        }
        .post-files {
            padding: 25px 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }
        .post-files h4 {
            margin-bottom: 15px;
            color: #495057;
            font-size: 18px;
        }
        .file-list {
            list-style: none;
        }
        .file-item {
            display: flex;
            align-items: center;
            padding: 12px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .file-item:last-child {
            border-bottom: none;
        }
        .file-icon {
            font-size: 20px;
            margin-right: 10px;
            color: #4CAF50;
        }
        .file-info {
            flex: 1;
        }
        .file-name {
            font-weight: 500;
            color: #333;
        }
        .file-size {
            font-size: 14px;
            color: #666;
            margin-top: 2px;
        }
        .file-download {
            color: #4CAF50;
            text-decoration: none;
            padding: 8px 15px;
            border: 1px solid #4CAF50;
            border-radius: 4px;
            transition: all 0.3s;
        }
        .file-download:hover {
            background: #4CAF50;
            color: white;
        }
        .post-actions {
            padding: 25px 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        .btn-group {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
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
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background: #c82333;
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
        .status-selector {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .status-selector select {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: white;
        }
        .reply-section {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .reply-header {
            padding: 25px 30px;
            background: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }
        .reply-header h3 {
            font-size: 22px;
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .reply-count {
            background: #4CAF50;
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 14px;
        }
        .reply-list {
            max-height: 600px;
            overflow-y: auto;
        }
        .reply-item {
            padding: 25px 30px;
            border-bottom: 1px solid #e9ecef;
            transition: background 0.3s;
        }
        .reply-item:hover {
            background: #f8f9fa;
        }
        .reply-item:last-child {
            border-bottom: none;
        }
        .reply-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #e9ecef;
        }
        .reply-author {
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .reply-date {
            color: #666;
            font-size: 14px;
        }
        .reply-content {
            line-height: 1.7;
            color: #555;
            font-size: 15px;
        }
        .reply-form {
            padding: 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
        }
        .reply-form h4 {
            margin-bottom: 20px;
            color: #333;
            font-size: 18px;
        }
        .reply-form textarea {
            width: 100%;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            resize: vertical;
            font-size: 14px;
            line-height: 1.6;
            min-height: 120px;
        }
        .reply-form textarea:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
        }
        .reply-form .btn-group {
            margin-top: 15px;
            justify-content: flex-end;
        }
        .empty-state {
            text-align: center;
            padding: 60px 30px;
            color: #666;
        }
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            opacity: 0.5;
        }
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }
            .post-header {
                padding: 20px;
            }
            .post-title {
                font-size: 22px;
            }
            .post-meta {
                grid-template-columns: 1fr;
            }
            .post-content {
                padding: 25px 20px;
            }
            .post-actions {
                flex-direction: column;
                align-items: stretch;
            }
            .btn-group {
                justify-content: center;
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
            <a href="${pageContext.request.contextPath}/user/post/list?boardId=${postInfo.board_id}">${postInfo.board_title}</a>
            <span>></span>
            <span>게시물 상세</span>
        </div>

        <h2 class="page-title">${postInfo.board_title}</h2>
        <!-- 게시물 정보 -->
        <div class="post-view">
            <div class="post-header">
                <h3 class="post-title">${postInfo.post_title}</h3>
                <div class="post-meta">
                    <div class="meta-item">
                        <span class="meta-label">👤 작성자:</span>
                        <span class="meta-value">${postInfo.reg_nm}</span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">📅 등록일:</span>
                        <span class="meta-value"><fmt:formatDate value="${postInfo.reg_dt}" pattern="yyyy-MM-dd HH:mm"/></span>
                    </div>
                    <div class="meta-item">
                        <span class="meta-label">👁️ 조회수:</span>
                        <span class="meta-value">${postInfo.read_cnt}</span>
                    </div>
                    <c:if test="${postInfo.status_use_yn == 'Y'}">
                        <div class="meta-item">
                            <span class="meta-label">📊 상태:</span>
                            <span class="meta-value">
                                <c:choose>
                                    <c:when test="${postInfo.post_status == 'W'}">
                                        <span class="status-badge status-W">대기</span>
                                    </c:when>
                                    <c:when test="${postInfo.post_status == 'R'}">
                                        <span class="status-badge status-R">접수</span>
                                    </c:when>
                                    <c:when test="${postInfo.post_status == 'P'}">
                                        <span class="status-badge status-P">처리중</span>
                                    </c:when>
                                    <c:when test="${postInfo.post_status == 'C'}">
                                        <span class="status-badge status-C">완료</span>
                                    </c:when>
                                    <c:when test="${postInfo.post_status == 'H'}">
                                        <span class="status-badge status-H">보류</span>
                                    </c:when>
                                </c:choose>
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>

            <div class="post-content">
                ${postInfo.post_content}
            </div>

            <!-- 첨부파일 -->
            <c:if test="${not empty fileList}">
                <div class="post-files">
                    <h4>📎 첨부파일 (${fileList.size()}개)</h4>
                    <ul class="file-list">
                        <c:forEach items="${fileList}" var="file">
                            <li class="file-item">
                                <div class="file-icon">📄</div>
                                <div class="file-info">
                                    <div class="file-name">${file.file_nm}</div>
                                    <div class="file-size">
                                        <fmt:formatNumber value="${file.file_size / 1024}" pattern="#,##0"/>KB
                                        • 다운로드 ${file.download_cnt}회
                                    </div>
                                </div>
                                <a href="${pageContext.request.contextPath}/user/post/file/download?fileSeq=${file.file_seq}" 
                                   class="file-download">다운로드</a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>

            <!-- 액션 버튼 -->
            <div class="post-actions">
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/user/post/list?boardId=${postInfo.board_id}" 
                       class="btn btn-outline">📋 목록</a>
                </div>
                
                <div class="btn-group">
                    <c:if test="${postInfo.status_use_yn == 'Y' && isAdmin}">
                        <div class="status-selector">
                            <label>상태 변경:</label>
                            <select id="postStatus">
                                <option value="W" ${postInfo.post_status == 'W' ? 'selected' : ''}>대기</option>
                                <option value="R" ${postInfo.post_status == 'R' ? 'selected' : ''}>접수</option>
                                <option value="P" ${postInfo.post_status == 'P' ? 'selected' : ''}>처리중</option>
                                <option value="C" ${postInfo.post_status == 'C' ? 'selected' : ''}>완료</option>
                                <option value="H" ${postInfo.post_status == 'H' ? 'selected' : ''}>보류</option>
                            </select>
                        </div>
                    </c:if>
                    
                    <c:if test="${isOwner || isAdmin}">
                        <a href="${pageContext.request.contextPath}/user/post/form?boardId=${postInfo.board_id}&postSeq=${postInfo.post_seq}" 
                           class="btn btn-primary">✏️ 수정</a>
                        <button type="button" onclick="deletePost()" class="btn btn-danger">🗑️ 삭제</button>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 답변 섹션 -->
        <div class="reply-section">
            <div class="reply-header">
                <h3>💬 답변 <span class="reply-count">${replyList.size()}</span></h3>
            </div>
            
            <c:choose>
                <c:when test="${empty replyList}">
                    <div class="empty-state">
                        <i>💭</i>
                        <p>등록된 답변이 없습니다.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="reply-list">
                        <c:forEach items="${replyList}" var="reply" varStatus="status">
                            <div class="reply-item">
                                <div class="reply-meta">
                                    <div class="reply-author">
                                        <span>👤 ${reply.reply_nm}</span>
                                        <c:if test="${reply.reg_id == sessionScope.LOGIN_USER.user_id || reply.reg_id == sessionScope.LOGIN_USER.userId}">
                                            <span style="color: #4CAF50; font-size: 12px;">(나)</span>
                                        </c:if>
                                    </div>
                                    <div class="reply-date">
                                        <fmt:formatDate value="${reply.reg_dt}" pattern="yyyy-MM-dd HH:mm"/>
                                    </div>
                                </div>
                                <div class="reply-content">
                                    ${reply.reply_content}
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- 답변 작성 폼 -->
            <c:if test="${postInfo.reply_yn == 'Y'}">
                <div class="reply-form">
                    <h4>✍️ 답변 작성</h4>
                    <textarea id="replyContent" placeholder="답변 내용을 입력하세요...&#10;&#10;• 정확하고 도움이 되는 답변을 작성해주세요&#10;• 욕설이나 비방은 삼가해주세요"></textarea>
                    <div class="btn-group">
                        <button type="button" onclick="clearReply()" class="btn btn-secondary">초기화</button>
                        <button type="button" onclick="insertReply()" class="btn btn-primary">📝 답변 등록</button>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <script>
        // 상태 변경
        $('#postStatus').change(function() {
            var postStatus = $(this).val();
            var statusText = $(this).find('option:selected').text();
            
            if (!confirm('상태를 "' + statusText + '"로 변경하시겠습니까?')) {
                location.reload();
                return;
            }

            $.ajax({
                url: '${pageContext.request.contextPath}/user/post/status',
                type: 'POST',
                data: {
                    boardId: ${postInfo.board_id},
                    postSeq: ${postInfo.post_seq},
                    postStatus: postStatus
                },
                success: function(result) {
                    if (result.success) {
                        alert('상태가 "' + statusText + '"로 변경되었습니다.');
                        location.reload();
                    } else {
                        alert('상태 변경에 실패했습니다.');
                        location.reload();
                    }
                },
                error: function() {
                    alert('상태 변경 중 오류가 발생했습니다.');
                    location.reload();
                }
            });
        });

        // 게시물 삭제
        function deletePost() {
            if (!confirm('⚠️ 정말로 이 게시물을 삭제하시겠습니까?\n\n삭제된 게시물은 복구할 수 없습니다.')) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/user/post/delete',
                type: 'POST',
                data: {
                    boardId: ${postInfo.board_id},
                    postSeq: ${postInfo.post_seq}
                },
                success: function(result) {
                    if (result.success) {
                        alert('✅ 게시물이 삭제되었습니다.');
                        location.href = '${pageContext.request.contextPath}/user/post/list?boardId=${postInfo.board_id}';
                    } else {
                        alert('❌ ' + (result.message || '삭제 중 오류가 발생했습니다.'));
                    }
                },
                error: function() {
                    alert('❌ 삭제 중 오류가 발생했습니다.');
                }
            });
        }

        // 답변 등록
        function insertReply() {
            var replyContent = $('#replyContent').val().trim();
            if (!replyContent) {
                alert('답변 내용을 입력하세요.');
                $('#replyContent').focus();
                return;
            }

            if (replyContent.length < 10) {
                alert('답변은 최소 10자 이상 입력해주세요.');
                $('#replyContent').focus();
                return;
            }

            if (!confirm('답변을 등록하시겠습니까?')) return;

            $.ajax({
                url: '${pageContext.request.contextPath}/user/post/reply/insert',
                type: 'POST',
                data: {
                    boardId: ${postInfo.board_id},
                    postSeq: ${postInfo.post_seq},
                    replyContent: replyContent,
                    replyTitle: '답변'
                },
                success: function(result) {
                    if (result.success) {
                        alert('✅ 답변이 등록되었습니다.');
                        location.reload();
                    } else {
                        alert('❌ 답변 등록에 실패했습니다.');
                    }
                },
                error: function() {
                    alert('❌ 답변 등록 중 오류가 발생했습니다.');
                }
            });
        }

        // 답변 초기화
        function clearReply() {
            if ($('#replyContent').val().trim() && !confirm('작성 중인 답변을 초기화하시겠습니까?')) {
                return;
            }
            $('#replyContent').val('');
            $('#replyContent').focus();
        }

        // 페이지 로드 시 실행
        $(document).ready(function() {
            // 답변 텍스트 영역 자동 높이 조절
            $('#replyContent').on('input', function() {
                this.style.height = 'auto';
                this.style.height = (this.scrollHeight) + 'px';
            });

            // 파일 다운로드 클릭 추적
            $('.file-download').click(function() {
                var fileName = $(this).closest('.file-item').find('.file-name').text();
                console.log('파일 다운로드:', fileName);
            });
        });
    </script>
</body>
</html>
