<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../layout/header.jsp"/>

<style>
    .form-container {
        max-width: 1000px;
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
    .form-section {
        margin-bottom: 30px;
    }
    .form-section h3 {
        color: #4CAF50;
        margin: 0 0 20px 0;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
        font-size: 18px;
    }
    .form-table {
        width: 100%;
        border-collapse: collapse;
    }
    .form-table th,
    .form-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }
    .form-table th {
        background: #f8f9fa;
        font-weight: bold;
        width: 200px;
        color: #555;
    }
    .form-control {
        width: 100%;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
        box-sizing: border-box;
    }
    .form-control:focus {
        outline: none;
        border-color: #4CAF50;
    }
    textarea.form-control {
        resize: vertical;
        font-family: inherit;
    }
    .required {
        color: red;
        margin-left: 3px;
    }
    .radio-inline {
        display: inline-block;
        margin-right: 20px;
    }
    .radio-inline input[type="radio"] {
        margin-right: 5px;
    }
    .form-actions {
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
    .help-text {
        font-size: 12px;
        color: #666;
        margin-top: 5px;
    }
</style>

<div class="form-container">
    <div class="form-header">
        <h2>${empty boardInfo ? '게시판 등록' : '게시판 수정'}</h2>
    </div>

    <form id="boardForm" method="post" action="${pageContext.request.contextPath}/admin/board/${empty boardInfo ? 'insert' : 'update'}">
        <c:if test="${not empty boardInfo}">
            <input type="hidden" name="boardId" value="${boardInfo.board_id}">
        </c:if>

        <div class="form-section">
            <h3>기본 설정</h3>
            <table class="form-table">
                <tr>
                    <th><label for="sysId">시스템 <span class="required">*</span></label></th>
                    <td>
                        <select id="sysId" name="sysId" class="form-control" required>
                            <option value="">시스템 선택</option>
                            <c:forEach items="${sysList}" var="sys">
                                <option value="${sys.sysId}" ${boardInfo.sys_id == sys.sysId ? 'selected' : ''}>${sys.sysNm}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><label for="boardTitle">게시판명 <span class="required">*</span></label></th>
                    <td>
                        <input type="text" id="boardTitle" name="boardTitle" class="form-control"
                               value="${boardInfo.board_title}" required maxlength="200"
                               placeholder="게시판 이름을 입력하세요">
                    </td>
                </tr>
                <tr>
                    <th><label for="boardType">게시판유형 <span class="required">*</span></label></th>
                    <td>
                        <select id="boardType" name="boardType" class="form-control" required>
                            <option value="NORMAL" ${boardInfo.board_type == 'NORMAL' ? 'selected' : ''}>일반게시판</option>
                            <option value="FAQ"    ${boardInfo.board_type == 'FAQ'    ? 'selected' : ''}>FAQ</option>
                            <option value="GAL"    ${boardInfo.board_type == 'GAL'    ? 'selected' : ''}>갤러리</option>
                            <option value="QNA"    ${boardInfo.board_type == 'QNA'    ? 'selected' : ''}>Q&A</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th><label for="boardDesc">게시판설명</label></th>
                    <td>
                        <textarea id="boardDesc" name="boardDesc" class="form-control" rows="3"
                                  placeholder="게시판에 대한 설명을 입력하세요">${boardInfo.board_desc}</textarea>
                    </td>
                </tr>
                <tr>
                    <th><label for="pagePostCnt">페이지당 게시물수</label></th>
                    <td>
                        <input type="number" id="pagePostCnt" name="pagePostCnt" class="form-control"
                               value="${empty boardInfo.page_post_cnt ? 10 : boardInfo.page_post_cnt}" min="1" max="100">
                        <div class="help-text">한 페이지에 표시할 게시물 수 (기본값: 10)</div>
                    </td>
                </tr>
            </table>
        </div>

        <div class="form-section">
            <h3>기능 설정</h3>
            <table class="form-table">
                <tr>
                    <th>에디터 사용</th>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="editorUseYn" value="Y" ${empty boardInfo.editor_use_yn || boardInfo.editor_use_yn == 'Y' ? 'checked' : ''}> 사용
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="editorUseYn" value="N" ${boardInfo.editor_use_yn == 'N' ? 'checked' : ''}> 미사용
                        </label>
                        <div class="help-text">HTML 에디터를 사용하여 게시물 작성</div>
                    </td>
                </tr>
                <tr>
                    <th>상태관리 사용</th>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="statusUseYn" value="Y" ${empty boardInfo.status_use_yn || boardInfo.status_use_yn == 'Y' ? 'checked' : ''}> 사용
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="statusUseYn" value="N" ${boardInfo.status_use_yn == 'N' ? 'checked' : ''}> 미사용
                        </label>
                        <div class="help-text">게시물 상태 관리 (대기, 접수, 처리중, 완료)</div>
                    </td>
                </tr>
                <tr>
                    <th>답변 사용</th>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="replyYn" value="Y" ${empty boardInfo.reply_yn || boardInfo.reply_yn == 'Y' ? 'checked' : ''}> 사용
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="replyYn" value="N" ${boardInfo.reply_yn == 'N' ? 'checked' : ''}> 미사용
                        </label>
                        <div class="help-text">게시물에 답변 작성 기능</div>
                    </td>
                </tr>
                <tr>
                    <th>비밀글 사용</th>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="secretUseYn" value="Y" ${boardInfo.secret_use_yn == 'Y' ? 'checked' : ''}> 사용
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="secretUseYn" value="N" ${empty boardInfo.secret_use_yn || boardInfo.secret_use_yn == 'N' ? 'checked' : ''}> 미사용
                        </label>
                        <div class="help-text">비밀글 작성 기능</div>
                    </td>
                </tr>
                <tr>
                    <th><label for="fileMaxCnt">파일첨부 최대수</label></th>
                    <td>
                        <input type="number" id="fileMaxCnt" name="fileMaxCnt" class="form-control"
                               value="${empty boardInfo.file_max_cnt ? 5 : boardInfo.file_max_cnt}" min="0" max="20">
                        <div class="help-text">게시물당 첨부 가능한 최대 파일 수 (0: 첨부 불가)</div>
                    </td>
                </tr>
                <tr>
                    <th><label for="allowedExt">허용 확장자</label></th>
                    <td>
                        <input type="text" id="allowedExt" name="allowedExt" class="form-control"
                               value="${boardInfo.allowed_ext}"
                               placeholder="jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,zip">
                        <div class="help-text">쉼표(,)로 구분하여 입력 (예: jpg,png,pdf)</div>
                    </td>
                </tr>
                <tr>
                    <th>이메일 알림</th>
                    <td>
                        <label class="radio-inline">
                            <input type="radio" name="emailUseYn" value="Y" ${boardInfo.email_use_yn == 'Y' ? 'checked' : ''}> 사용
                        </label>
                        <label class="radio-inline">
                            <input type="radio" name="emailUseYn" value="N" ${empty boardInfo.email_use_yn || boardInfo.email_use_yn == 'N' ? 'checked' : ''}> 미사용
                        </label>
                        <div class="help-text">새 게시물 등록 시 이메일 알림</div>
                    </td>
                </tr>
            </table>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn btn-primary">저장</button>
            <button type="button" class="btn btn-secondary" onclick="location.href='${pageContext.request.contextPath}/admin/board/list'">취소</button>
        </div>
    </form>
</div>

<script>
    // 폼 제출 전 검증
    document.getElementById('boardForm').addEventListener('submit', function(e) {
        const sysId = document.getElementById('sysId').value;
        const boardTitle = document.getElementById('boardTitle').value.trim();
        
        if (!sysId) {
            e.preventDefault();
            alert('시스템을 선택해주세요.');
            document.getElementById('sysId').focus();
            return false;
        }
        
        if (!boardTitle) {
            e.preventDefault();
            alert('게시판명을 입력해주세요.');
            document.getElementById('boardTitle').focus();
            return false;
        }
    });
</script>

<jsp:include page="../layout/footer.jsp"/>
