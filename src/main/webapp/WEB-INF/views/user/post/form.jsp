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
        .form-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .form-header {
            padding: 25px 30px;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
        }
        .form-header h3 {
            font-size: 22px;
            margin-bottom: 8px;
        }
        .form-header p {
            opacity: 0.9;
            font-size: 14px;
        }
        .form-content {
            padding: 40px 30px;
        }
        .form-group {
            margin-bottom: 30px;
        }
        .form-group label {
            display: block;
            margin-bottom: 10px;
            font-weight: 600;
            color: #333;
            font-size: 15px;
        }
        .required {
            color: #dc3545;
            margin-left: 3px;
        }
        .form-group input[type="text"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
            background: #fff;
        }
        .form-group input[type="text"]:focus,
        .form-group textarea:focus,
        .form-group select:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
        }
        .form-group textarea {
            resize: vertical;
            min-height: 200px;
            line-height: 1.6;
        }
        .form-group input[type="file"] {
            padding: 10px;
            border: 2px dashed #ddd;
            border-radius: 8px;
            background: #f8f9fa;
            cursor: pointer;
            transition: all 0.3s;
        }
        .form-group input[type="file"]:hover {
            border-color: #4CAF50;
            background: #f0f8f0;
        }
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }
        .checkbox-group input[type="checkbox"] {
            width: auto;
            margin: 0;
            transform: scale(1.2);
        }
        .checkbox-group label {
            margin: 0;
            font-weight: 500;
            cursor: pointer;
        }
        .help-text {
            margin-top: 8px;
            font-size: 13px;
            color: #666;
            line-height: 1.4;
        }
        .help-text strong {
            color: #4CAF50;
        }
        .file-list {
            background: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
            padding: 20px;
            margin-top: 10px;
        }
        .file-list h5 {
            margin-bottom: 15px;
            color: #495057;
            font-size: 16px;
        }
        .file-list ul {
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
        .file-item input[type="checkbox"] {
            margin-right: 12px;
            transform: scale(1.1);
        }
        .file-info {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .file-icon {
            color: #4CAF50;
            font-size: 18px;
        }
        .file-name {
            font-weight: 500;
            color: #333;
        }
        .file-size {
            color: #666;
            font-size: 13px;
        }
        .form-actions {
            padding: 25px 30px;
            background: #f8f9fa;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: center;
            gap: 15px;
        }
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            min-width: 120px;
            justify-content: center;
        }
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(76, 175, 80, 0.3);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
        }
        .char-counter {
            text-align: right;
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .char-counter.warning {
            color: #ff9800;
        }
        .char-counter.danger {
            color: #f44336;
        }
        .form-tips {
            background: #e8f5e8;
            border: 1px solid #c8e6c9;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
        }
        .form-tips h4 {
            color: #2e7d32;
            margin-bottom: 10px;
            font-size: 16px;
        }
        .form-tips ul {
            margin-left: 20px;
            color: #2e7d32;
        }
        .form-tips li {
            margin-bottom: 5px;
            font-size: 14px;
        }
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }
            .form-content {
                padding: 25px 20px;
            }
            .form-actions {
                flex-direction: column;
            }
            .btn {
                width: 100%;
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
            <a href="${pageContext.request.contextPath}/user/post/list?boardId=${boardId}">${boardInfo.board_title}</a>
            <span>></span>
            <span>${pageTitle}</span>
        </div>

        <h2 class="page-title">${pageTitle}</h2>

        <div class="form-tips">
            <h4>💡 작성 가이드</h4>
            <ul>
                <li>제목은 문제 상황을 명확하게 표현해주세요</li>
                <li>내용은 구체적인 증상과 발생 시점을 포함해주세요</li>
                <li>관련 파일이 있다면 첨부해주시면 빠른 해결에 도움됩니다</li>
                <li>개인정보가 포함된 내용은 비밀글로 설정해주세요</li>
            </ul>
        </div>

        <div class="form-container">
            <div class="form-header">
                <h3>${pageTitle}</h3>
                <p>${boardInfo.board_title}에 ${postInfo != null ? '수정할' : '새로운'} 게시물을 작성합니다</p>
            </div>

            <form id="postForm" method="post" enctype="multipart/form-data"
                  action="${pageContext.request.contextPath}/user/post/${postInfo != null ? 'update' : 'insert'}">
                
                <div class="form-content">
                    <input type="hidden" name="boardId" value="${boardId}">
                    <c:if test="${postInfo != null}">
                        <input type="hidden" name="postSeq" value="${postInfo.post_seq}">
                    </c:if>

                    <div class="form-group">
                        <label for="postTitle">📝 제목 <span class="required">*</span></label>
                        <input type="text" id="postTitle" name="postTitle" value="${postInfo.post_title}" 
                               placeholder="문제 상황을 명확하게 표현해주세요" required maxlength="200">
                        <div class="char-counter">
                            <span id="titleCount">0</span>/200자
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="postContent">📄 내용 <span class="required">*</span></label>
                        <textarea id="postContent" name="postContent" required 
                                  placeholder="다음 정보를 포함해서 작성해주세요:&#10;&#10;1. 문제 상황 (언제, 어디서, 무엇을)&#10;2. 발생 빈도 (항상, 가끔, 처음)&#10;3. 오류 메시지 (있다면)&#10;4. 시도해본 해결 방법&#10;5. 긴급도 (높음, 보통, 낮음)">${postInfo.post_content}</textarea>
                        <div class="char-counter">
                            <span id="contentCount">0</span>/4000자
                        </div>
                    </div>

                    <c:if test="${boardInfo.secret_use_yn == 'Y'}">
                        <div class="form-group">
                            <div class="checkbox-group">
                                <input type="checkbox" id="secretYn" name="secretYn" value="Y" 
                                       ${postInfo.secret_yn == 'Y' ? 'checked' : ''}>
                                <label for="secretYn">🔒 비밀글로 설정 (관리자와 작성자만 볼 수 있습니다)</label>
                            </div>
                        </div>
                    </c:if>

                    <div class="form-group">
                        <label for="files">📎 첨부파일</label>
                        <input type="file" id="files" name="files" multiple accept="${boardInfo.allowed_ext}">
                        <div class="help-text">
                            <strong>허용 확장자:</strong> ${boardInfo.allowed_ext}<br>
                            <strong>최대 파일 수:</strong> ${boardInfo.file_max_cnt}개<br>
                            <strong>파일 크기:</strong> 개당 최대 10MB
                        </div>
                    </div>

                    <c:if test="${not empty fileList}">
                        <div class="file-list">
                            <h5>📁 기존 첨부파일</h5>
                            <ul>
                                <c:forEach items="${fileList}" var="file">
                                    <li class="file-item">
                                        <input type="checkbox" id="deleteFile_${file.file_seq}" 
                                               name="deleteFileSeqs" value="${file.file_seq}">
                                        <div class="file-info">
                                            <span class="file-icon">📄</span>
                                            <span class="file-name">${file.file_nm}</span>
                                            <span class="file-size">
                                                (<fmt:formatNumber value="${file.file_size / 1024}" pattern="#,##0"/>KB)
                                            </span>
                                        </div>
                                    </li>
                                </c:forEach>
                            </ul>
                            <div class="help-text">
                                <strong>삭제할 파일을 선택하세요.</strong> 체크된 파일은 저장 시 삭제됩니다.
                            </div>
                        </div>
                    </c:if>
                </div>

                <div class="form-actions">
                    <button type="button" onclick="history.back()" class="btn btn-secondary">
                        ↩️ 취소
                    </button>
                    <button type="submit" class="btn btn-primary">
                        💾 ${postInfo != null ? '수정' : '등록'}
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // 문자 수 카운터 초기화
            updateCharCount();
            
            // 실시간 문자 수 카운터
            $('#postTitle').on('input', function() {
                updateTitleCount();
            });
            
            $('#postContent').on('input', function() {
                updateContentCount();
                autoResize(this);
            });
            
            // 파일 선택 시 유효성 검사
            $('#files').on('change', function() {
                validateFiles(this.files);
            });
            
            // 폼 제출 시 유효성 검사
            $('#postForm').on('submit', function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                    return false;
                }
                
                // 제출 버튼 비활성화 (중복 제출 방지)
                $(this).find('button[type="submit"]').prop('disabled', true).text('저장 중...');
            });
            
            // 텍스트 영역 자동 크기 조절
            autoResize(document.getElementById('postContent'));
        });
        
        function updateCharCount() {
            updateTitleCount();
            updateContentCount();
        }
        
        function updateTitleCount() {
            var title = $('#postTitle').val();
            var count = title.length;
            var counter = $('#titleCount');
            
            counter.text(count);
            counter.parent().removeClass('warning danger');
            
            if (count > 180) {
                counter.parent().addClass('danger');
            } else if (count > 150) {
                counter.parent().addClass('warning');
            }
        }
        
        function updateContentCount() {
            var content = $('#postContent').val();
            var count = content.length;
            var counter = $('#contentCount');
            
            counter.text(count);
            counter.parent().removeClass('warning danger');
            
            if (count > 3800) {
                counter.parent().addClass('danger');
            } else if (count > 3500) {
                counter.parent().addClass('warning');
            }
        }
        
        function autoResize(textarea) {
            textarea.style.height = 'auto';
            textarea.style.height = textarea.scrollHeight + 'px';
        }
        
        function validateFiles(files) {
            var maxFiles = parseInt('${boardInfo.file_max_cnt}');
            var allowedExts = '${boardInfo.allowed_ext}'.toLowerCase().split(',');
            var maxSize = 10 * 1024 * 1024; // 10MB
            
            console.log('파일 검증 시작');
            console.log('최대 파일 수:', maxFiles);
            console.log('허용 확장자:', allowedExts);
            console.log('업로드 파일 수:', files.length);
            
            if (files.length > maxFiles) {
                alert('최대 ' + maxFiles + '개의 파일만 첨부할 수 있습니다.');
                $('#files').val('');
                return false;
            }
            
            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                var fileName = file.name.toLowerCase();
                var fileExt = fileName.substring(fileName.lastIndexOf('.') + 1);
                
                console.log('파일명:', file.name);
                console.log('확장자:', fileExt);
                
                // 확장자 검사
                var isAllowed = false;
                for (var j = 0; j < allowedExts.length; j++) {
                    var allowedExt = allowedExts[j].trim();
                    console.log('비교:', fileExt, 'vs', allowedExt);
                    if (allowedExt === fileExt) {
                        isAllowed = true;
                        break;
                    }
                }
                
                if (!isAllowed) {
                    alert('허용되지 않는 파일 형식입니다: ' + file.name + '\n허용 확장자: ${boardInfo.allowed_ext}');
                    $('#files').val('');
                    return false;
                }
                
                // 파일 크기 검사
                if (file.size > maxSize) {
                    alert('파일 크기가 너무 큽니다: ' + file.name + '\n최대 크기: 10MB');
                    $('#files').val('');
                    return false;
                }
            }
            
            console.log('파일 검증 통과');
            return true;
        }
        
        function validateForm() {
            var title = $('#postTitle').val().trim();
            var content = $('#postContent').val().trim();
            var boardId = $('input[name="boardId"]').val();
            
            console.log('=== 폼 유효성 검사 ===');
            console.log('제목:', title);
            console.log('내용:', content);
            console.log('boardId:', boardId);
            
            if (!boardId) {
                alert('게시판 정보가 없습니다.');
                return false;
            }
            
            if (!title) {
                alert('제목을 입력하세요.');
                $('#postTitle').focus();
                return false;
            }
            
            if (title.length < 5) {
                alert('제목은 최소 5자 이상 입력해주세요.');
                $('#postTitle').focus();
                return false;
            }
            
            if (title.length > 200) {
                alert('제목은 200자를 초과할 수 없습니다.');
                $('#postTitle').focus();
                return false;
            }
            
            if (!content) {
                alert('내용을 입력하세요.');
                $('#postContent').focus();
                return false;
            }
            
            if (content.length < 10) {
                alert('내용은 최소 10자 이상 입력해주세요.');
                $('#postContent').focus();
                return false;
            }
            
            if (content.length > 4000) {
                alert('내용은 4000자를 초과할 수 없습니다.');
                $('#postContent').focus();
                return false;
            }
            
            // 저장 확인
            var action = '${postInfo != null ? "수정" : "등록"}';
            if (!confirm('게시물을 ' + action + '하시겠습니까?')) {
                return false;
            }
            
            console.log('유효성 검사 통과');
            return true;
        }
        
        // 페이지 이탈 시 경고 (작성 중인 내용이 있을 때)
        var initialTitle = '${postInfo.post_title != null ? postInfo.post_title : ""}';
        var initialContent = '${postInfo.post_content != null ? postInfo.post_content : ""}';
        var formSubmitted = false;
        
        function beforeUnloadHandler(e) {
            if (formSubmitted) {
                return; // 폼이 제출되었으면 경고하지 않음
            }
            
            var currentTitle = $('#postTitle').val();
            var currentContent = $('#postContent').val();
            
            if (currentTitle !== initialTitle || currentContent !== initialContent) {
                e.preventDefault();
                e.returnValue = '';
                return '';
            }
        }
        
        window.addEventListener('beforeunload', beforeUnloadHandler);
        
        // 폼 제출 시에는 경고 해제
        $('#postForm').on('submit', function() {
            formSubmitted = true;
            window.removeEventListener('beforeunload', beforeUnloadHandler);
        });
    </script>
</body>
</html>
