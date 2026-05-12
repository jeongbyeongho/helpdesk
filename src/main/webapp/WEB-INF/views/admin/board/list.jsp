<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<div class="content-box">
    <!-- 검색 필터 -->
    <div style="margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius: 4px;">
        <form method="get" action="${pageContext.request.contextPath}/admin/board/list" style="display: flex; gap: 10px; align-items: center;">
            <label>시스템:</label>
            <select name="sysId" class="form-control" style="width: 200px;">
                <option value="">전체</option>
                <c:forEach items="${sysList}" var="sys">
                    <option value="${sys.sysId}" ${selectedSysId == sys.sysId ? 'selected' : ''}>${sys.sysNm}</option>
                </c:forEach>
            </select>
            
            <label>게시판유형:</label>
            <select name="boardType" class="form-control" style="width: 150px;">
                <option value="">전체</option>
                <option value="NORMAL" ${param.boardType == 'NORMAL' ? 'selected' : ''}>일반게시판</option>
                <option value="FAQ" ${param.boardType == 'FAQ' ? 'selected' : ''}>FAQ</option>
                <option value="GAL" ${param.boardType == 'GAL' ? 'selected' : ''}>갤러리</option>
                <option value="QNA" ${param.boardType == 'QNA' ? 'selected' : ''}>Q&A</option>
            </select>
            
            <label>검색:</label>
            <input type="text" name="keyword" value="${param.keyword}" class="form-control" style="width: 200px;" placeholder="게시판명 검색">
            
            <button type="submit" class="btn btn-primary">조회</button>
        </form>
    </div>

    <div style="margin-bottom: 20px; text-align: right;">
        <a href="${pageContext.request.contextPath}/admin/board/form" class="btn btn-success">게시판 등록</a>
    </div>

    <table class="table">
        <thead>
            <tr>
                <th>게시판ID</th>
                <th>시스템</th>
                <th>게시판명</th>
                <th>게시판유형</th>
                <th>대기</th>
                <th>접수</th>
                <th>완료</th>
                <th>사용여부</th>
                <th>등록일</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${boardList}" var="board">
                <tr>
                    <td>${board.board_id}</td>
                    <td>${board.sys_nm}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/board/view?boardId=${board.board_id}">
                            ${board.board_title}
                        </a>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${board.board_type == 'NORMAL'}">일반게시판</c:when>
                            <c:when test="${board.board_type == 'NOTICE'}">공지사항</c:when>
                            <c:when test="${board.board_type == 'FAQ'}">FAQ</c:when>
                            <c:when test="${board.board_type == 'QNA'}">Q&A</c:when>
                            <c:when test="${board.board_type == 'GAL'}">갤러리</c:when>
                            <c:otherwise>${board.board_type}</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${board.ntt_wait}</td>
                    <td>${board.ntt_rcept}</td>
                    <td>${board.ntt_compt}</td>
                    <td>
                        <c:choose>
                            <c:when test="${board.board_use_yn == 'Y'}">
                                <span class="badge badge-success">사용</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">미사용</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${board.reg_dt}" pattern="yyyy-MM-dd"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/board/form?boardId=${board.board_id}" class="btn btn-sm btn-info">수정</a>
                        <button onclick="deleteBoard(${board.board_id})" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty boardList}">
                <tr>
                    <td colspan="10" class="empty-message">등록된 게시판이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <!-- 페이징 영역 -->
    <div class="paging-area">
        <c:if test="${paging.totalPage > 0}">
            <c:if test="${paging.currentPage > 1}">
                <a href="?page=1">처음</a>
                <a href="?page=${paging.currentPage - 1}">이전</a>
            </c:if>
            
            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
                <c:choose>
                    <c:when test="${i == paging.currentPage}">
                        <strong>${i}</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:if test="${paging.currentPage < paging.totalPage}">
                <a href="?page=${paging.currentPage + 1}">다음</a>
                <a href="?page=${paging.totalPage}">마지막</a>
            </c:if>
        </c:if>
    </div>
</div>

<script>
function deleteBoard(boardId) {
    if (!confirm('게시판을 삭제하시겠습니까?\n게시판의 모든 게시물도 함께 삭제됩니다.')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/board/delete',
        type: 'POST',
        data: { boardId: boardId },
        success: function(result) {
            if (result.success) {
                alert('삭제되었습니다.');
                location.reload();
            }
        },
        error: function() {
            alert('삭제 중 오류가 발생했습니다.');
        }
    });
}
</script>

<jsp:include page="../layout/footer.jsp"/>
