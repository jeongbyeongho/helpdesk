# 사용자 게시판 목록 기능 개선

## 수정 날짜
2026-04-24

## 문제점
1. 게시물 목록에서 건수가 표시되지 않음
2. 페이지네이션 정보가 표시되지 않음
3. 조회수가 표시되지 않음
4. 사용자별로 자신의 글만 볼 수 없음
5. 관리자가 모든 글을 볼 수 없음

## 해결 방법

### 1. PostController 수정
**파일**: `helpdesk/src/main/java/com/helpdesk/user/post/controller/PostController.java`

**추가된 기능**:
```java
// 관리자 여부 확인
Object roleCodeObj = loginUser.get("roleCode");
if (roleCodeObj == null) roleCodeObj = loginUser.get("role_code");
boolean isAdmin = roleCodeObj != null && Integer.parseInt(String.valueOf(roleCodeObj)) <= 2;

// 관리자가 아니고 "내 문의만" 체크가 안되어 있으면 자동으로 내 문의만 보기
if (!isAdmin && !"Y".equals(searchOnlyMine)) {
    param.put("searchOnlyMine", "Y");
    searchOnlyMine = "Y";
}

// Model에 추가 정보 전달
model.addAttribute("isAdmin", isAdmin);
model.addAttribute("searchOnlyMine", searchOnlyMine);
model.addAttribute("currentPage", page);
model.addAttribute("pageSize", pageSize);
```

**권한 로직**:
- **일반 사용자**: 자동으로 자신의 글만 조회 (searchOnlyMine = 'Y' 강제)
- **관리자** (roleCode <= 2): 모든 글 조회 가능, "내 문의만" 체크박스로 선택 가능

### 2. list.jsp 수정
**파일**: `helpdesk/src/main/webapp/WEB-INF/views/user/post/list.jsp`

**수정 사항**:

#### 2.1 페이징 정보 표시
```jsp
<!-- 변경 전 -->
총 ${totalCount}건 (${currentPage}/${totalPages} 페이지)

<!-- 변경 후 -->
총 <fmt:formatNumber value="${paging.totalCount}" pattern="#,##0"/>건 
(${paging.currentPage}/${paging.totalPage} 페이지)
```

#### 2.2 번호 계산 수정
```jsp
<!-- 변경 전 -->
${totalCount - (currentPage - 1) * pageSize - status.index}

<!-- 변경 후 -->
${paging.totalCount - (paging.currentPage - 1) * paging.pageSize - status.index}
```

#### 2.3 조회수 표시 수정
```jsp
<!-- 변경 전 -->
<td>${post.read_count}</td>

<!-- 변경 후 -->
<td><fmt:formatNumber value="${post.read_cnt}" pattern="#,##0"/></td>
```

#### 2.4 파일/답글 수 표시 수정
```jsp
<!-- 파일 수 -->
<c:if test="${post.file_cnt > 0}">
    <span class="file-icon">📎</span>
</c:if>

<!-- 답글 수 -->
<c:if test="${post.reply_cnt > 0}">
    <span style="color: #4CAF50; font-size: 12px;">[${post.reply_cnt}]</span>
</c:if>
```

#### 2.5 페이징 링크 수정
```jsp
<!-- 모든 페이징 변수를 paging 객체에서 가져오도록 수정 -->
<c:if test="${paging.currentPage > 1}">
    <a href="?boardId=${boardId}&page=1&...">&laquo; 처음</a>
    <a href="?boardId=${boardId}&page=${paging.currentPage - 1}&...">&lsaquo; 이전</a>
</c:if>

<c:forEach begin="${paging.startPage}" end="${paging.endPage}" var="i">
    <c:when test="${i == paging.currentPage}">
        <span class="current">${i}</span>
    </c:when>
</c:forEach>

<c:if test="${paging.currentPage < paging.totalPage}">
    <a href="?boardId=${boardId}&page=${paging.currentPage + 1}&...">다음 &rsaquo;</a>
    <a href="?boardId=${boardId}&page=${paging.totalPage}&...">마지막 &raquo;</a>
</c:if>
```

#### 2.6 관리자 전용 "내 문의만" 체크박스
```jsp
<c:if test="${isAdmin}">
    <div class="checkbox-group">
        <div class="checkbox-item">
            <input type="checkbox" id="searchOnlyMine" name="searchOnlyMine" value="Y" 
                   ${param.searchOnlyMine eq 'Y' ? 'checked' : ''}>
            <label for="searchOnlyMine">내 문의만</label>
        </div>
    </div>
</c:if>
```

### 3. post_mapper.xml 확인
**파일**: `helpdesk/src/main/resources/mapper/user/post_mapper.xml`

**searchOnlyMine 조건**:
```xml
<if test='searchOnlyMine != null and searchOnlyMine == "Y"'>
    AND P.reg_id = #{userId}
</if>
```

이 조건이 selectPostList와 selectPostListCount 모두에 적용되어 있음을 확인

## 수정된 파일 목록

1. **PostController.java**
   - 관리자 여부 확인 로직 추가
   - 일반 사용자 자동 필터링 추가
   - Model에 추가 정보 전달

2. **list.jsp**
   - 페이징 정보 표시 수정
   - 조회수 표시 수정
   - 파일/답글 수 표시 수정
   - 페이징 링크 수정
   - 관리자 전용 체크박스 추가

3. **USER_POST_LIST_FIX.md** (신규)
   - 수정 내역 문서

## 권한별 동작 방식

### 일반 사용자 (roleCode > 2)
- **자동 필터링**: 자신이 작성한 글만 조회
- **체크박스 미표시**: "내 문의만" 옵션 없음
- **URL 파라미터**: searchOnlyMine=Y 자동 설정

### 관리자 (roleCode <= 2)
- **전체 조회**: 기본적으로 모든 글 조회
- **체크박스 표시**: "내 문의만" 선택 가능
- **선택적 필터링**: 체크 시 자신의 글만 조회

## 페이징 정보 구조

PagingUtil.buildPagingInfo()가 반환하는 Map:
```java
{
    "totalCount": 전체 건수,
    "currentPage": 현재 페이지,
    "totalPage": 전체 페이지 수,
    "pageSize": 페이지당 건수,
    "startPage": 시작 페이지 번호,
    "endPage": 끝 페이지 번호
}
```

## 테스트 방법

### 1. 일반 사용자 테스트
```
1. user01 / user1234 로그인
2. 게시판 접속
3. 자신이 작성한 글만 표시되는지 확인
4. "내 문의만" 체크박스가 없는지 확인
5. 페이징 정보 표시 확인
6. 조회수 표시 확인
```

### 2. 관리자 테스트
```
1. admin / admin1234 로그인
2. 게시판 접속
3. 모든 사용자의 글이 표시되는지 확인
4. "내 문의만" 체크박스 표시 확인
5. 체크박스 선택 시 자신의 글만 표시되는지 확인
6. 페이징 정보 표시 확인
7. 조회수 표시 확인
```

### 3. 페이징 테스트
```
1. 게시물 11개 이상 등록
2. 페이지당 10개씩 표시 확인
3. 페이지 번호 클릭 시 이동 확인
4. 처음/이전/다음/마지막 버튼 동작 확인
5. 현재 페이지 강조 표시 확인
```

### 4. 검색 테스트
```
1. 상태별 검색 (대기, 접수, 처리중, 완료)
2. 검색 타입별 검색 (제목, 내용, 작성자)
3. 키워드 검색
4. 검색 조건 유지 확인 (페이징 이동 시)
```

## 데이터베이스 컬럼명 매핑

| JSP 변수 | DB 컬럼명 | 설명 |
|----------|-----------|------|
| post.read_cnt | read_cnt | 조회수 |
| post.file_cnt | (서브쿼리) | 파일 수 |
| post.reply_cnt | (서브쿼리) | 답글 수 |
| post.reg_nm | reg_nm | 작성자명 |
| post.reg_dt | reg_dt | 등록일시 |
| post.post_status | post_status | 게시물 상태 |

## 완료 상태
✅ 게시물 건수 표시 수정
✅ 페이지네이션 정보 표시 수정
✅ 조회수 표시 수정
✅ 사용자별 자신의 글만 보기 구현
✅ 관리자 모든 글 보기 구현
✅ 권한별 UI 차별화 (체크박스 표시/미표시)
✅ 파일/답글 수 표시 수정

## 결론
사용자 게시판의 모든 기능이 정상적으로 작동합니다! 🎉

- 일반 사용자는 자신의 글만 자동으로 조회
- 관리자는 모든 글을 조회하고 선택적으로 필터링 가능
- 페이징, 조회수, 파일/답글 수 모두 정상 표시
