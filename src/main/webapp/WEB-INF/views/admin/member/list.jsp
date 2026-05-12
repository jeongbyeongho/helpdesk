<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<div class="content-box">
    <!-- 검색 영역 -->
    <div class="search-area">
        <form method="get" action="${pageContext.request.contextPath}/admin/member/list">
            <select name="approvalYn">
                <option value="">승인상태 전체</option>
                <option value="Y" ${param.approvalYn == 'Y' ? 'selected' : ''}>승인</option>
                <option value="N" ${param.approvalYn == 'N' ? 'selected' : ''}>미승인</option>
            </select>
            <select name="userType">
                <option value="">회원유형 전체</option>
                <option value="ADMIN" ${param.userType == 'ADMIN' ? 'selected' : ''}>관리자</option>
                <option value="USER" ${param.userType == 'USER' ? 'selected' : ''}>일반사용자</option>
            </select>
            <input type="text" name="keyword" value="${param.keyword}" placeholder="이름, ID 검색">
            <button type="submit" class="btn btn-primary">검색</button>
            <a href="${pageContext.request.contextPath}/admin/member/form" class="btn btn-success">회원 등록</a>
        </form>
    </div>

    <!-- 목록 영역 -->
    <table class="table">
        <thead>
            <tr>
                <th>사용자ID</th>
                <th>이름</th>
                <th>이메일</th>
                <th>부서</th>
                <th>권한</th>
                <th>승인상태</th>
                <th>등록일</th>
                <th>관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${memberList}" var="member">
                <tr>
                    <td>${member.user_id}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/member/view?userId=${member.user_id}">
                            ${member.user_nm}
                        </a>
                    </td>
                    <td>${member.email}</td>
                    <td>${member.dept_nm}</td>
                    <td>
                        <c:choose>
                            <c:when test="${member.role_code == 1}">
                                <span class="badge badge-danger">시스템관리자</span>
                            </c:when>
                            <c:when test="${member.role_code == 2}">
                                <span class="badge badge-warning">관리자</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-info">일반사용자</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${member.approval_yn == 'Y'}">
                                <span class="badge badge-success">승인</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">미승인</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td><fmt:formatDate value="${member.reg_dt}" pattern="yyyy-MM-dd"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/member/form/${member.user_id}" class="btn btn-sm btn-info">수정</a>
                        <c:if test="${member.approval_yn != 'Y'}">
                            <button onclick="approveMember('${member.user_id}')" class="btn btn-sm btn-success">승인</button>
                        </c:if>
                        <button onclick="deleteMember('${member.user_id}')" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty memberList}">
                <tr>
                    <td colspan="8" class="empty-message">등록된 회원이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <!-- 페이징 영역 -->
    <div class="paging-area">
        <c:if test="${paging.totalPage > 0}">
            <c:if test="${paging.currentPage > 1}">
                <a href="?page=1&approvalYn=${param.approvalYn}&userType=${param.userType}&keyword=${param.keyword}">처음</a>
                <a href="?page=${paging.currentPage - 1}&approvalYn=${param.approvalYn}&userType=${param.userType}&keyword=${param.keyword}">이전</a>
            </c:if>
            
            <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
                <c:choose>
                    <c:when test="${i == paging.currentPage}">
                        <strong>${i}</strong>
                    </c:when>
                    <c:otherwise>
                        <a href="?page=${i}&approvalYn=${param.approvalYn}&userType=${param.userType}&keyword=${param.keyword}">${i}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            
            <c:if test="${paging.currentPage < paging.totalPage}">
                <a href="?page=${paging.currentPage + 1}&approvalYn=${param.approvalYn}&userType=${param.userType}&keyword=${param.keyword}">다음</a>
                <a href="?page=${paging.totalPage}&approvalYn=${param.approvalYn}&userType=${param.userType}&keyword=${param.keyword}">마지막</a>
            </c:if>
        </c:if>
    </div>
</div>

<script>
function approveMember(userId) {
    if (!confirm('회원을 승인하시겠습니까?')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/member/approve',
        type: 'POST',
        data: { userId: userId },
        success: function(result) {
            if (result.success) {
                alert('승인되었습니다.');
                location.reload();
            }
        },
        error: function() {
            alert('승인 중 오류가 발생했습니다.');
        }
    });
}

function deleteMember(userId) {
    if (!confirm('회원을 삭제하시겠습니까?')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/member/delete',
        type: 'POST',
        data: { userId: userId },
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
