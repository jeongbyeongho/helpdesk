<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<jsp:include page="../layout/header.jsp"/>

<style>
    .stats-container {
        padding: 20px;
    }
    .stats-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
    }
    .date-filter {
        display: flex;
        gap: 10px;
        align-items: center;
    }
    .date-filter input {
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
    }
    .stats-summary {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 30px;
    }
    .stat-card {
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        text-align: center;
    }
    .stat-card h3 {
        margin: 0 0 10px 0;
        color: #666;
        font-size: 14px;
        font-weight: normal;
    }
    .stat-card .value {
        font-size: 32px;
        font-weight: bold;
        color: #4CAF50;
    }
    .stat-card .unit {
        font-size: 14px;
        color: #999;
        margin-left: 5px;
    }
    .stats-section {
        background: white;
        padding: 25px;
        border-radius: 8px;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        margin-bottom: 20px;
    }
    .stats-section h2 {
        margin: 0 0 20px 0;
        padding-bottom: 10px;
        border-bottom: 2px solid #4CAF50;
        color: #333;
        font-size: 18px;
    }
    .stats-table {
        width: 100%;
        border-collapse: collapse;
    }
    .stats-table th,
    .stats-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #eee;
    }
    .stats-table th {
        background: #f8f9fa;
        font-weight: bold;
        color: #555;
    }
    .stats-table tbody tr:hover {
        background: #f8f9fa;
    }
    .progress-bar {
        width: 100%;
        height: 20px;
        background: #f0f0f0;
        border-radius: 10px;
        overflow: hidden;
        position: relative;
    }
    .progress-fill {
        height: 100%;
        background: linear-gradient(90deg, #4CAF50, #45a049);
        transition: width 0.3s ease;
    }
    .progress-text {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-size: 12px;
        font-weight: bold;
        color: #333;
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
    .no-data {
        text-align: center;
        padding: 40px;
        color: #999;
    }
</style>

<div class="stats-container">
    <div class="stats-header">
        <h1>${pageTitle}</h1>
        <form class="date-filter" method="get">
            <label>기간:</label>
            <input type="date" name="startDate" value="${startDate}" required>
            <span>~</span>
            <input type="date" name="endDate" value="${endDate}" required>
            <button type="submit" class="btn btn-primary">조회</button>
        </form>
    </div>

    <!-- 요약 통계 -->
    <div class="stats-summary">
        <div class="stat-card">
            <h3>총 방문자</h3>
            <div class="value">
                <fmt:formatNumber value="${accessSummary.totalVisitors != null ? accessSummary.totalVisitors : 0}" pattern="#,##0"/>
                <span class="unit">명</span>
            </div>
        </div>
        <div class="stat-card">
            <h3>총 페이지뷰</h3>
            <div class="value">
                <fmt:formatNumber value="${accessSummary.totalPageViews != null ? accessSummary.totalPageViews : 0}" pattern="#,##0"/>
                <span class="unit">회</span>
            </div>
        </div>
        <div class="stat-card">
            <h3>신규 방문자</h3>
            <div class="value">
                <fmt:formatNumber value="${accessSummary.newVisitors != null ? accessSummary.newVisitors : 0}" pattern="#,##0"/>
                <span class="unit">명</span>
            </div>
        </div>
        <div class="stat-card">
            <h3>평균 체류시간</h3>
            <div class="value">
                <fmt:formatNumber value="${accessSummary.avgDuration != null ? accessSummary.avgDuration : 0}" pattern="#,##0"/>
                <span class="unit">초</span>
            </div>
        </div>
    </div>

    <!-- 일별 접속 통계 -->
    <div class="stats-section">
        <h2>일별 접속 통계</h2>
        <c:choose>
            <c:when test="${empty dailyAccessStats}">
                <div class="no-data">조회된 데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <table class="stats-table">
                    <thead>
                        <tr>
                            <th>날짜</th>
                            <th>방문자 수</th>
                            <th>페이지뷰</th>
                            <th>신규 방문자</th>
                            <th>재방문자</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${dailyAccessStats}" var="stat">
                            <tr>
                                <td><fmt:formatDate value="${stat.access_date}" pattern="yyyy-MM-dd"/></td>
                                <td><fmt:formatNumber value="${stat.visitor_cnt}" pattern="#,##0"/></td>
                                <td><fmt:formatNumber value="${stat.page_view_cnt}" pattern="#,##0"/></td>
                                <td><fmt:formatNumber value="${stat.new_visitor_cnt}" pattern="#,##0"/></td>
                                <td><fmt:formatNumber value="${stat.return_visitor_cnt}" pattern="#,##0"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 페이지별 접속 통계 -->
    <div class="stats-section">
        <h2>페이지별 접속 통계 (Top 10)</h2>
        <c:choose>
            <c:when test="${empty pageAccessStats}">
                <div class="no-data">조회된 데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <table class="stats-table">
                    <thead>
                        <tr>
                            <th style="width: 50%;">페이지 URL</th>
                            <th>방문 횟수</th>
                            <th>순 방문자</th>
                            <th style="width: 200px;">비율</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:set var="maxVisit" value="${pageAccessStats[0].visit_cnt}"/>
                        <c:forEach items="${pageAccessStats}" var="stat" begin="0" end="9">
                            <tr>
                                <td>${stat.page_url}</td>
                                <td><fmt:formatNumber value="${stat.visit_cnt}" pattern="#,##0"/></td>
                                <td><fmt:formatNumber value="${stat.unique_visitor_cnt}" pattern="#,##0"/></td>
                                <td>
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: ${stat.visit_cnt * 100 / maxVisit}%"></div>
                                        <div class="progress-text">
                                            <fmt:formatNumber value="${stat.visit_cnt * 100 / maxVisit}" pattern="#0.0"/>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- 브라우저별 통계 -->
    <div class="stats-section">
        <h2>브라우저별 통계</h2>
        <c:choose>
            <c:when test="${empty browserStats}">
                <div class="no-data">조회된 데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <table class="stats-table">
                    <thead>
                        <tr>
                            <th>브라우저</th>
                            <th>버전</th>
                            <th>사용 횟수</th>
                            <th style="width: 200px;">비율</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${browserStats}" var="stat">
                            <tr>
                                <td>${stat.browser}</td>
                                <td>${stat.browser_ver}</td>
                                <td><fmt:formatNumber value="${stat.cnt}" pattern="#,##0"/></td>
                                <td>
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: ${stat.percentage}%"></div>
                                        <div class="progress-text">
                                            <fmt:formatNumber value="${stat.percentage}" pattern="#0.0"/>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- OS별 통계 -->
    <div class="stats-section">
        <h2>운영체제별 통계</h2>
        <c:choose>
            <c:when test="${empty osStats}">
                <div class="no-data">조회된 데이터가 없습니다.</div>
            </c:when>
            <c:otherwise>
                <table class="stats-table">
                    <thead>
                        <tr>
                            <th>운영체제</th>
                            <th>버전</th>
                            <th>사용 횟수</th>
                            <th style="width: 200px;">비율</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${osStats}" var="stat">
                            <tr>
                                <td>${stat.os}</td>
                                <td>${stat.os_ver}</td>
                                <td><fmt:formatNumber value="${stat.cnt}" pattern="#,##0"/></td>
                                <td>
                                    <div class="progress-bar">
                                        <div class="progress-fill" style="width: ${stat.percentage}%"></div>
                                        <div class="progress-text">
                                            <fmt:formatNumber value="${stat.percentage}" pattern="#0.0"/>%
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="../layout/footer.jsp"/>
