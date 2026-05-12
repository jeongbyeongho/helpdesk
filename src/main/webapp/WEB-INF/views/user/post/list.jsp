<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background: #f5f5f5;
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
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info span {
            color: #555;
        }
        .btn-logout {
            padding: 8px 15px;
            background: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
        }
        .btn-logout:hover {
            background: #d32f2f;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .page-header {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .page-header h2 {
            color: #333;
            margin: 0;
        }
        .breadcrumb {
            color: #666;
            font-size: 14px;
        }
        .breadcrumb a {
            color: #4CAF50;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        .search-card {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .search-form {
            display: flex;
            gap: 10px;
            align-items: center;
            flex-wrap: wrap;
        }
        .search-form select, .search-form input {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }
        .search-form input[type="text"] {
            flex: 1;
            min-width: 200px;
        }
        .btn {
            padding: 8px 16px;
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
        .list-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .list-header {
            padding: 20px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .list-header h3 {
            margin: 0;
            color: #333;
        }
        .list-stats {
            color: #666;
            font-size: 14px;
        }
        .data-table {
            width: 100%;
            border-collapse: collapse;
        }
        .data-table th, .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }
        .data-table th {
            background: #f8f9fa;
            font-weight: bold;
            color: #555;
        }
        .data-table tbody tr:hover {
            background: #f8f9fa;
        }
        .post-title {
            color: #333;
            text-decoration: none;
            font-weight: 500;
        }
        .post-title:hover {
            color: #4CAF50;
            text-decoration: underline;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: bold;
        }
        .status-temp {
            background: #ffebee;
            color: #c62828;
        }
        .status-wait {
            background: #f3e5f5;
            color: #7b1fa2;
        }
        .status-received {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .status-processing {
            background: #fff3e0;
            color: #ef6c00;
        }
        .status-completed {
            background: #e3f2fd;
            color: #1565c0;
        }
        .file-icon {
            color: #4CAF50;
            font-size: 16px;
        }
        .new-badge {
            background: #f44336;
            color: white;
            padding: 2px 6px;
            border-radius: 3px;
            font-size: 10px;
            margin-left: 5px;
        }
        .pagination {
            text-align: center;
            padding: 20px;
        }
        .pagination a, .pagination span {
            display: inline-block;
            padding: 8px 12px;
            margin: 0 2px;
            text-decoration: none;
            border: 1px solid #ddd;
            color: #333;
            border-radius: 4px;
        }
        .pagination .current {
            background: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        .pagination a:hover {
            background: #f5f5f5;
        }
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .no-data i {
            font-size: 48px;
            margin-bottom: 15px;
            display: block;
        }
        .checkbox-group {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .checkbox-item input[type="checkbox"] {
            width: auto;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1>IT 서비스데스크</h1>
            <div class="user-info">
                <span><strong>${sessionScope.LOGIN_USER.user_nm != null ? sessionScope.LOGIN_USER.user_nm : sessionScope.LOGIN_USER.userNm}</strong>님</span>
                <a href="${pageContext.request.contextPath}/auth/logout" class="btn-logout">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="page-header">
            <div>
                <h2>${pageTitle}</h2>
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/main">홈</a> &gt; ${pageTitle}
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/user/post/form?boardId=${boardId}" class="btn btn-primary">
                문의 등록
            </a>
        </div>

        <!-- 검색 영역 -->
        <div class="search-card">
            <form method="get" action="${pageContext.request.contextPath}/user/post/list" class="search-form">
                <input type="hidden" name="boardId" value="${boardId}">
                
                <select name="postStatus">
                    <option value="">전체 상태</option>
                    <option value="T" ${param.postStatus eq 'T' ? 'selected' : ''}>임시저장</option>
                    <option value="W" ${param.postStatus eq 'W' ? 'selected' : ''}>대기</option>
                    <option value="R" ${param.postStatus eq 'R' ? 'selected' : ''}>접수</option>
                    <option value="P" ${param.postStatus eq 'P' ? 'selected' : ''}>처리중</option>
                    <option value="C" ${param.postStatus eq 'C' ? 'selected' : ''}>완료</option>
                </select>

                <select name="searchType">
                    <option value="">전체</option>
                    <option value="title" ${param.searchType eq 'title' ? 'selected' : ''}>제목</option>
                    <option value="content" ${param.searchType eq 'content' ? 'selected' : ''}>내용</option>
                    <option value="writer" ${param.searchType eq 'writer' ? 'selected' : ''}>작성자</option>
                </select>

                <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력하세요">

                <c:if test="${isAdmin}">
                    <div class="checkbox-group">
                        <div class="checkbox-item">
                            <input type="checkbox" id="searchOnlyMine" name="searchOnlyMine" value="Y" 
                                   ${param.searchOnlyMine eq 'Y' ? 'checked' : ''}>
                            <label for="searchOnlyMine">내 문의만</label>
                        </div>
                    </div>
                </c:if>

                <button type="submit" class="btn btn-primary">검색</button>
                <button type="button" class="btn btn-secondary" onclick="resetSearch()">초기화</button>
            </form>
        </div>

        <!-- 목록 영역 -->
        <div class="list-card">
            <div class="list-header">
                <h3>문의 목록</h3>
                <div class="list-stats">
                    총 <fmt:formatNumber value="${paging.totalCount}" pattern="#,##0"/>건 
                    (${paging.currentPage}/${paging.totalPage} 페이지)
                </div>
            </div>

            <c:choose>
                <c:when test="${empty postList}">
                    <div class="no-data">
                        <i>📝</i>
                        <div>등록된 문의가 없습니다.</div>
                        <div style="margin-top: 10px;">
                            <a href="${pageContext.request.contextPath}/user/post/form?boardId=${boardId}" class="btn btn-primary">
                                첫 문의 등록하기
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 60px;">번호</th>
                                <th style="width: 80px;">상태</th>
                                <th>제목</th>
                                <th style="width: 100px;">작성자</th>
                                <th style="width: 100px;">등록일</th>
                                <th style="width: 60px;">조회</th>
                                <th style="width: 40px;">파일</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${postList}" var="post" varStatus="status">
                                <tr>
                                    <td>${paging.totalCount - (paging.currentPage - 1) * paging.pageSize - status.index}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${post.post_status eq 'T'}">
                                                <span class="status-badge status-temp">임시저장</span>
                                            </c:when>
                                            <c:when test="${post.post_status eq 'W'}">
                                                <span class="status-badge status-wait">대기</span>
                                            </c:when>
                                            <c:when test="${post.post_status eq 'R'}">
                                                <span class="status-badge status-received">접수</span>
                                            </c:when>
                                            <c:when test="${post.post_status eq 'P'}">
                                                <span class="status-badge status-processing">처리중</span>
                                            </c:when>
                                            <c:when test="${post.post_status eq 'C'}">
                                                <span class="status-badge status-completed">완료</span>
                                            </c:when>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/user/post/view?boardId=${boardId}&postSeq=${post.post_seq}" 
                                           class="post-title">
                                            ${post.post_title}
                                            <c:if test="${post.reply_cnt > 0}">
                                                <span style="color: #4CAF50; font-size: 12px;">[${post.reply_cnt}]</span>
                                            </c:if>
                                        </a>
                                    </td>
                                    <td>${post.reg_nm}</td>
                                    <td>
                                        <fmt:formatDate value="${post.reg_dt}" pattern="MM-dd HH:mm"/>
                                    </td>
                                    <td><fmt:formatNumber value="${post.read_cnt}" pattern="#,##0"/></td>
                                    <td>
                                        <c:if test="${post.file_cnt > 0}">
                                            <span class="file-icon">📎</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- 페이징 -->
                    <div class="pagination">
                        <c:if test="${paging.currentPage > 1}">
                            <a href="?boardId=${boardId}&page=1&postStatus=${param.postStatus}&searchType=${param.searchType}&keyword=${param.keyword}&searchOnlyMine=${param.searchOnlyMine}">&laquo; 처음</a>
                            <a href="?boardId=${boardId}&page=${paging.currentPage - 1}&postStatus=${param.postStatus}&searchType=${param.searchType}&keyword=${param.keyword}&searchOnlyMine=${param.searchOnlyMine}">&lsaquo; 이전</a>
                        </c:if>
                        
                        <c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
                            <c:choose>
                                <c:when test="${i == paging.currentPage}">
                                    <span class="current">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="?boardId=${boardId}&page=${i}&postStatus=${param.postStatus}&searchType=${param.searchType}&keyword=${param.keyword}&searchOnlyMine=${param.searchOnlyMine}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <c:if test="${paging.currentPage < paging.totalPage}">
                            <a href="?boardId=${boardId}&page=${paging.currentPage + 1}&postStatus=${param.postStatus}&searchType=${param.searchType}&keyword=${param.keyword}&searchOnlyMine=${param.searchOnlyMine}">다음 &rsaquo;</a>
                            <a href="?boardId=${boardId}&page=${paging.totalPage}&postStatus=${param.postStatus}&searchType=${param.searchType}&keyword=${param.keyword}&searchOnlyMine=${param.searchOnlyMine}">마지막 &raquo;</a>
                        </c:if>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        function resetSearch() {
            location.href = '${pageContext.request.contextPath}/user/post/list?boardId=${boardId}';
        }
    </script>
</body>
</html>