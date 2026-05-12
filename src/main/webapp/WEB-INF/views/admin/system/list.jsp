<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<div class="content-box">
    <!-- 검색 영역 -->
    <div class="search-area">
        <form method="get" action="${pageContext.request.contextPath}/admin/system/list">
            <input type="text" name="keyword" value="${param.keyword}" placeholder="시스템명 검색">
            <button type="submit" class="btn btn-primary">검색</button>
            <a href="${pageContext.request.contextPath}/admin/system/form" class="btn btn-success">시스템 등록</a>
        </form>
    </div>

    <!-- 목록 영역 -->
    <table class="table">
        <thead>
            <tr>
                <th>시스템ID</th>
                <th>시스템명</th>
                <th>시스템URL</th>
                <th>사용자수</th>
                <th>게시판수</th>
                <th>등록일</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${systemList}" var="system">
                <tr>
                    <td>${system.sys_id}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/system/view?sysId=${system.sys_id}">
                            ${system.sys_nm}
                        </a>
                    </td>
                    <td>${system.sys_url}</td>
                    <td>${system.user_cnt}</td>
                    <td>${system.board_cnt}</td>
                    <td><fmt:formatDate value="${system.reg_dt}" pattern="yyyy-MM-dd"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/system/form?sysId=${system.sys_id}" class="btn btn-sm btn-info">수정</a>
                        <button onclick="deleteSystem('${system.sys_id}')" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty systemList}">
                <tr>
                    <td colspan="7" class="empty-message">등록된 시스템이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <!-- 페이징 영역 -->
    <div class="paging-area">
        <c:if test="${paging.totalPage > 0}">
            <c:if test="${paging.currentPage > 1}">
                <a href="?page=1&keyword=${param.keyword}">처음</a>
                <a href="?page=${paging.currentPage - 1}&keyword=${param.keyword}">이전</a>
            </c:if>
            
            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
                <c:choose>
                    <c:when test="${i == paging.currentPage}">
                        <strong>${i}</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}&keyword=${param.keyword}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:if test="${paging.currentPage < paging.totalPage}">
                <a href="?page=${paging.currentPage + 1}&keyword=${param.keyword}">다음</a>
                <a href="?page=${paging.totalPage}&keyword=${param.keyword}">마지막</a>
            </c:if>
        </c:if>
    </div>
</div>

<script>
function deleteSystem(sysId) {
    if (!confirm('시스템을 삭제하시겠습니까?')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/system/delete',
        type: 'POST',
        data: { sysId: sysId },
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
