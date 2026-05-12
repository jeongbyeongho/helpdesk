<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<div class="content-box">
    <div style="margin-bottom: 20px; text-align: right;">
        <a href="${pageContext.request.contextPath}/admin/role/form" class="btn btn-success">권한 등록</a>
    </div>

    <table class="table">
        <thead>
            <tr>
                <th style="width: 100px;">권한코드</th>
                <th>권한명</th>
                <th>설명</th>
                <th style="width: 100px;">사용자수</th>
                <th style="width: 100px;">사용여부</th>
                <th style="width: 150px;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${roleList}" var="role">
                <tr>
                    <td>${role.role_code}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/role/view?roleCode=${role.role_code}">
                            ${role.role_nm}
                        </a>
                    </td>
                    <td>${role.role_desc}</td>
                    <td>${role.user_cnt}</td>
                    <td>
                        <c:choose>
                            <c:when test="${role.use_yn == 'Y'}">
                                <span class="badge badge-success">사용</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">미사용</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/role/view?roleCode=${role.role_code}" class="btn btn-sm btn-primary">상세</a>
                        <a href="${pageContext.request.contextPath}/admin/role/form?roleCode=${role.role_code}" class="btn btn-sm btn-info">수정</a>
                        <button onclick="deleteRole(${role.role_code})" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty roleList}">
                <tr>
                    <td colspan="6" class="empty-message">등록된 권한이 없습니다.</td>
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
function deleteRole(roleCode) {
    if (!confirm('권한을 삭제하시겠습니까?')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/role/delete',
        type: 'POST',
        data: { roleCode: roleCode },
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
