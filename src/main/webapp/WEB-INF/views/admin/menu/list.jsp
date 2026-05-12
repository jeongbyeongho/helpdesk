<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<div class="content-box">
    <div style="margin-bottom: 20px; text-align: right;">
        <a href="${pageContext.request.contextPath}/admin/menu/form" class="btn btn-success">메뉴 등록</a>
    </div>

    <table class="table">
        <thead>
            <tr>
                <th style="width: 50px;">순서</th>
                <th>메뉴명</th>
                <th>메뉴타입</th>
                <th>URL</th>
                <th style="width: 100px;">사용여부</th>
                <th style="width: 150px;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${menuList}" var="menu">
                <tr>
                    <td>${menu.sort_order}</td>
                    <td style="padding-left: ${(menu.menu_level - 1) * 20}px;">
                        <c:if test="${menu.menu_level > 1}">└ </c:if>
                        ${menu.menu_nm}
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${menu.menu_type == 'FOLDER'}">폴더</c:when>
                            <c:when test="${menu.menu_type == 'BOARD'}">게시판</c:when>
                            <c:when test="${menu.menu_type == 'LINK'}">링크</c:when>
                            <c:when test="${menu.menu_type == 'PROGRAM'}">프로그램</c:when>
                            <c:otherwise>${menu.menu_type}</c:otherwise>
                        </c:choose>
                    </td>
                    <td>${menu.menu_url}</td>
                    <td>
                        <c:choose>
                            <c:when test="${menu.use_yn == 'Y'}">
                                <span class="badge badge-success">사용</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">미사용</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/menu/form?menuId=${menu.menu_id}" class="btn btn-sm btn-info">수정</a>
                        <button onclick="deleteMenu(${menu.menu_id})" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty menuList}">
                <tr>
                    <td colspan="6" class="empty-message">등록된 메뉴가 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<script>
function deleteMenu(menuId) {
    if (!confirm('메뉴를 삭제하시겠습니까?\n하위 메뉴도 함께 삭제됩니다.')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/menu/delete',
        type: 'POST',
        data: { menuId: menuId },
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
