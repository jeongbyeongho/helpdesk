<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<div class="content-box">
    <div style="margin-bottom: 20px; text-align: right;">
        <a href="${pageContext.request.contextPath}/admin/popup/form" class="btn btn-success">팝업 등록</a>
    </div>

    <table class="table">
        <thead>
            <tr>
                <th style="width: 80px;">번호</th>
                <th>팝업제목</th>
                <th style="width: 150px;">게시기간</th>
                <th style="width: 100px;">크기(W×H)</th>
                <th style="width: 100px;">위치(X,Y)</th>
                <th style="width: 100px;">사용여부</th>
                <th style="width: 150px;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${popupList}" var="popup">
                <tr>
                    <td>${popup.popup_seq}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/popup/view?popupSeq=${popup.popup_seq}">
                            ${popup.popup_title}
                        </a>
                    </td>
                    <td>
                        <fmt:formatDate value="${popup.begin_dt}" pattern="yyyy-MM-dd"/> ~
                        <fmt:formatDate value="${popup.end_dt}" pattern="yyyy-MM-dd"/>
                    </td>
                    <td>${popup.popup_width} × ${popup.popup_height}</td>
                    <td>${popup.popup_left}, ${popup.popup_top}</td>
                    <td>
                        <c:choose>
                            <c:when test="${popup.use_yn == 'Y'}">
                                <span class="badge badge-success">사용</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">미사용</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/popup/view?popupSeq=${popup.popup_seq}" class="btn btn-sm btn-primary">상세</a>
                        <a href="${pageContext.request.contextPath}/admin/popup/form?popupSeq=${popup.popup_seq}" class="btn btn-sm btn-info">수정</a>
                        <button onclick="deletePopup(${popup.popup_seq})" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty popupList}">
                <tr>
                    <td colspan="7" class="empty-message">등록된 팝업이 없습니다.</td>
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
function deletePopup(popupSeq) {
    if (!confirm('팝업을 삭제하시겠습니까?')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/popup/delete',
        type: 'POST',
        data: { popupSeq: popupSeq },
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
