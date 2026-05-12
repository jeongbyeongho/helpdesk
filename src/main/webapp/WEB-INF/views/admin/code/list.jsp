<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<div class="content-box">
    <div style="margin-bottom: 20px; text-align: right;">
        <button onclick="openCodeGroupForm()" class="btn btn-success">코드그룹 등록</button>
    </div>

    <table class="table">
        <thead>
            <tr>
                <th style="width: 150px;">코드그룹ID</th>
                <th>코드그룹명</th>
                <th style="width: 100px;">코드수</th>
                <th style="width: 100px;">사용여부</th>
                <th style="width: 150px;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${codeGroupList}" var="group">
                <tr>
                    <td>${group.code_group}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/code/detail?codeGroup=${group.code_group}">
                            ${group.code_group_nm}
                        </a>
                    </td>
                    <td>${group.code_cnt}</td>
                    <td>
                        <c:choose>
                            <c:when test="${group.use_yn == 'Y'}">
                                <span class="badge badge-success">사용</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-secondary">미사용</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/code/detail?codeGroup=${group.code_group}" class="btn btn-sm btn-primary">상세</a>
                        <button onclick="editCodeGroup('${group.code_group}')" class="btn btn-sm btn-info">수정</button>
                        <button onclick="deleteCodeGroup('${group.code_group}')" class="btn btn-sm btn-danger">삭제</button>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty codeGroupList}">
                <tr>
                    <td colspan="5" class="empty-message">등록된 코드그룹이 없습니다.</td>
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

<!-- 코드그룹 등록/수정 모달 -->
<div id="codeGroupModal" style="display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); z-index:9999;">
    <div style="position:absolute; top:50%; left:50%; transform:translate(-50%,-50%); background:white; padding:30px; border-radius:10px; width:500px;">
        <h3 style="margin-bottom:20px;">코드그룹 등록/수정</h3>
        <form id="codeGroupForm">
            <div class="form-group">
                <label>코드그룹ID *</label>
                <input type="text" name="codeGroup" id="codeGroup" required>
            </div>
            <div class="form-group">
                <label>코드그룹명 *</label>
                <input type="text" name="codeGroupNm" id="codeGroupNm" required>
            </div>
            <div class="form-group">
                <label>설명</label>
                <textarea name="codeGroupDesc" id="codeGroupDesc"></textarea>
            </div>
            <div class="form-group">
                <label>사용여부</label>
                <select name="useYn" id="useYn">
                    <option value="Y">사용</option>
                    <option value="N">미사용</option>
                </select>
            </div>
            <div class="form-actions">
                <button type="submit" class="btn btn-primary">저장</button>
                <button type="button" onclick="closeCodeGroupModal()" class="btn btn-secondary">취소</button>
            </div>
        </form>
    </div>
</div>

<script>
function openCodeGroupForm() {
    document.getElementById('codeGroupForm').reset();
    document.getElementById('codeGroup').readOnly = false;
    document.getElementById('codeGroupModal').style.display = 'block';
}

function editCodeGroup(codeGroup) {
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/code/groupInfo',
        type: 'GET',
        data: { codeGroup: codeGroup },
        success: function(data) {
            document.getElementById('codeGroup').value = data.code_group;
            document.getElementById('codeGroup').readOnly = true;
            document.getElementById('codeGroupNm').value = data.code_group_nm;
            document.getElementById('codeGroupDesc').value = data.code_group_desc || '';
            document.getElementById('useYn').value = data.use_yn;
            document.getElementById('codeGroupModal').style.display = 'block';
        }
    });
}

function closeCodeGroupModal() {
    document.getElementById('codeGroupModal').style.display = 'none';
}

document.getElementById('codeGroupForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    const formData = new FormData(this);
    const data = Object.fromEntries(formData);
    const isEdit = document.getElementById('codeGroup').readOnly;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/code/' + (isEdit ? 'updateGroup' : 'insertGroup'),
        type: 'POST',
        data: data,
        success: function(result) {
            if (result.success) {
                alert('저장되었습니다.');
                location.reload();
            }
        },
        error: function() {
            alert('저장 중 오류가 발생했습니다.');
        }
    });
});

function deleteCodeGroup(codeGroup) {
    if (!confirm('코드그룹을 삭제하시겠습니까?\n하위 코드도 함께 삭제됩니다.')) return;
    
    $.ajax({
        url: '${pageContext.request.contextPath}/admin/code/deleteGroup',
        type: 'POST',
        data: { codeGroup: codeGroup },
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
