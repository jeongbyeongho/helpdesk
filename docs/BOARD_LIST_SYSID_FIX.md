# 게시판 목록 조회 오류 수정

## 문제 상황
게시판 등록 후 목록에 표시되지 않음
- 로그: `sys_id = ?` 파라미터가 **null**로 전달됨
- 결과: 조회 결과 0건

## 원인 분석
1. **TB_USER_INFO 테이블에 sys_id 컬럼 없음**
   - `SessionUtil.getLoginSysId(request)`가 null 반환
   - 사용자 테이블에는 sys_id 정보가 없음

2. **board_mapper.xml에서 sys_id 필수 조건**
   - `WHERE B.board_use_yn = 'Y' AND B.sys_id = #{sysId}`
   - sys_id가 null이면 조회 불가

## 해결 방법

### 1. board_mapper.xml 수정
sys_id 조건을 선택적으로 변경:

```xml
<!-- 수정 전 -->
WHERE B.board_use_yn = 'Y'
  AND B.sys_id = #{sysId}

<!-- 수정 후 -->
WHERE B.board_use_yn = 'Y'
<if test="sysId != null and sysId != ''">
  AND B.sys_id = #{sysId}
</if>
```

**적용 위치**:
- `selectBoardListSql` (목록 조회)
- `selectBoardListCount` (카운트 조회)

### 2. BoardController.java 수정
시스템 필터 파라미터 추가 및 시스템 목록 전달:

```java
@GetMapping("/list")
public String list(@RequestParam(defaultValue = "1") int page,
                   @RequestParam(defaultValue = "10") int pageSize,
                   @RequestParam(required = false) String sysId,  // 추가
                   @RequestParam(required = false) String boardType,
                   @RequestParam(required = false) String keyword,
                   HttpServletRequest request, Model model) {

    Map<String, Object> param = new HashMap<>();
    
    // sysId 파라미터가 없으면 세션에서 가져오기 (없으면 null로 전체 조회)
    if (sysId == null || sysId.isEmpty()) {
        sysId = SessionUtil.getLoginSysId(request);
    }
    param.put("sysId", sysId);
    param.put("boardType", boardType);
    param.put("keyword", keyword);

    Map<String, Object> result = boardService.getBoardListPage(param, page, pageSize);
    model.addAllAttributes(result);
    model.addAttribute("sysList", boardService.getSystemList());  // 추가
    model.addAttribute("selectedSysId", sysId);  // 추가
    model.addAttribute("pageTitle", "게시판관리");
    return "admin/board/list";
}
```

### 3. list.jsp 수정
검색 필터 UI 추가:

```jsp
<!-- 검색 필터 -->
<div style="margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius: 4px;">
    <form method="get" action="${pageContext.request.contextPath}/admin/board/list">
        <label>시스템:</label>
        <select name="sysId" class="form-control">
            <option value="">전체</option>
            <c:forEach items="${sysList}" var="sys">
                <option value="${sys.sysId}" ${selectedSysId == sys.sysId ? 'selected' : ''}>
                    ${sys.sysNm}
                </option>
            </c:forEach>
        </select>
        
        <label>게시판유형:</label>
        <select name="boardType" class="form-control">
            <option value="">전체</option>
            <option value="NORMAL">일반게시판</option>
            <option value="FAQ">FAQ</option>
            <option value="GAL">갤러리</option>
            <option value="QNA">Q&A</option>
        </select>
        
        <label>검색:</label>
        <input type="text" name="keyword" value="${param.keyword}" 
               class="form-control" placeholder="게시판명 검색">
        
        <button type="submit" class="btn btn-primary">조회</button>
    </form>
</div>
```

테이블에 시스템명 컬럼 추가:
```jsp
<th>시스템</th>
...
<td>${board.sys_nm}</td>
```

게시물 상태별 통계 컬럼 추가:
```jsp
<th>대기</th>
<th>접수</th>
<th>완료</th>
...
<td>${board.ntt_wait}</td>
<td>${board.ntt_rcept}</td>
<td>${board.ntt_compt}</td>
```

## 수정 결과

### 기능 개선
1. **전체 게시판 조회 가능**: sys_id가 없어도 모든 게시판 조회
2. **시스템별 필터링**: 드롭다운으로 시스템 선택 가능
3. **게시판유형 필터링**: 일반/FAQ/갤러리/Q&A 선택 가능
4. **검색 기능**: 게시판명으로 검색
5. **시스템명 표시**: 목록에 시스템명 컬럼 추가
6. **게시물 통계**: 대기/접수/완료 건수 표시

### 데이터베이스 확인
```sql
-- 등록된 게시판 확인
SELECT board_id, sys_id, board_title, board_type, board_use_yn, reg_dt 
FROM TB_BOARD_INFO 
ORDER BY board_id DESC;

-- 결과:
-- board_id=4, sys_id='helpdesk', board_title='공지사항', board_type='NORMAL'
-- board_id=1, sys_id='helpdesk', board_title='IT 문의게시판', board_type='QNA'
```

## 테스트 방법

### 1. 전체 게시판 조회
1. 게시판관리 메뉴 접근
2. 시스템 필터: "전체" 선택
3. 조회 버튼 클릭
4. **예상 결과**: 모든 시스템의 게시판 표시

### 2. 시스템별 필터링
1. 시스템 필터: "헬프데스크 시스템" 선택
2. 조회 버튼 클릭
3. **예상 결과**: helpdesk 시스템의 게시판만 표시

### 3. 게시판유형 필터링
1. 게시판유형: "Q&A" 선택
2. 조회 버튼 클릭
3. **예상 결과**: Q&A 유형 게시판만 표시

### 4. 검색 기능
1. 검색: "공지" 입력
2. 조회 버튼 클릭
3. **예상 결과**: "공지사항" 게시판 표시

### 5. 복합 필터
1. 시스템: "헬프데스크 시스템"
2. 게시판유형: "일반게시판"
3. 검색: "공지"
4. 조회 버튼 클릭
5. **예상 결과**: 조건에 맞는 게시판만 표시

## 수정 파일
1. `helpdesk/src/main/resources/mapper/admin/board_mapper.xml`
   - selectBoardListSql: sys_id 조건 선택적으로 변경
   - selectBoardListCount: sys_id 조건 선택적으로 변경

2. `helpdesk/src/main/java/com/helpdesk/admin/board/controller/BoardController.java`
   - list() 메서드: sysId 파라미터 추가, 시스템 목록 전달

3. `helpdesk/src/main/webapp/WEB-INF/views/admin/board/list.jsp`
   - 검색 필터 UI 추가
   - 시스템명 컬럼 추가
   - 게시물 상태별 통계 컬럼 추가

## 주의사항
- sys_id가 null이면 전체 시스템의 게시판 조회
- 관리자는 모든 시스템의 게시판을 볼 수 있음
- 일반 사용자의 경우 추후 권한 제어 필요 시 추가 구현 가능
