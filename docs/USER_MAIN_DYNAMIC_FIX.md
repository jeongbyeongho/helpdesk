# 사용자 메인 페이지 동적 데이터 구현

## 문제 상황
1. **하드코딩된 통계**: 나의 요청현황/전체현황이 고정된 숫자로 표시
2. **고정된 게시판 바로가기**: 게시판 생성 시 자동으로 바로가기 버튼이 추가되지 않음

## 해결 방법

### 1. MainService 생성
실제 DB 조회를 위한 서비스 레이어 추가

**파일**: `helpdesk/src/main/java/com/helpdesk/user/main/service/MainService.java`

```java
@Service
public class MainService {
    @Autowired
    private MainMapper mainMapper;

    // 나의 요청 현황 조회
    public Map<String, Object> getMyStats(String userId);
    
    // 전체 현황 조회
    public Map<String, Object> getTotalStats();
    
    // 공지사항 목록 조회 (최근 5건)
    public List<Map<String, Object>> getNoticeList();
    
    // 사용 중인 게시판 목록 조회
    public List<Map<String, Object>> getBoardList();
}
```

### 2. MainMapper 생성
MyBatis 매퍼 인터페이스 추가

**파일**: `helpdesk/src/main/java/com/helpdesk/user/main/mapper/MainMapper.java`

```java
@Mapper
public interface MainMapper {
    Map<String, Object> selectMyStats(String userId);
    Map<String, Object> selectTotalStats();
    List<Map<String, Object>> selectNoticeList();
    List<Map<String, Object>> selectBoardList();
}
```

### 3. main_mapper.xml 생성
실제 SQL 쿼리 구현

**파일**: `helpdesk/src/main/resources/mapper/user/main_mapper.xml`

#### 나의 요청 현황 쿼리
```sql
SELECT
    SUM(CASE WHEN post_status = 'W' THEN 1 ELSE 0 END) AS waiting,
    SUM(CASE WHEN post_status = 'R' THEN 1 ELSE 0 END) AS received,
    SUM(CASE WHEN post_status = 'P' THEN 1 ELSE 0 END) AS processing,
    SUM(CASE WHEN post_status = 'C' THEN 1 ELSE 0 END) AS completed
FROM TB_POST_INFO
WHERE reg_id = #{userId}
  AND post_use_yn = 'Y'
```

#### 전체 현황 쿼리
```sql
SELECT
    SUM(CASE WHEN post_status = 'W' THEN 1 ELSE 0 END) AS waiting,
    SUM(CASE WHEN post_status = 'R' THEN 1 ELSE 0 END) AS received,
    SUM(CASE WHEN post_status = 'P' THEN 1 ELSE 0 END) AS processing,
    SUM(CASE WHEN post_status = 'C' THEN 1 ELSE 0 END) AS completed
FROM TB_POST_INFO
WHERE post_use_yn = 'Y'
```

#### 공지사항 목록 쿼리
```sql
SELECT TOP 5
    P.post_seq,
    P.post_title,
    P.reg_dt,
    CASE 
        WHEN DATEDIFF(DAY, P.reg_dt, GETDATE()) <= 7 THEN 'Y'
        ELSE 'N'
    END AS is_new
FROM TB_POST_INFO P
JOIN TB_BOARD_INFO B ON P.board_id = B.board_id
WHERE B.board_type = 'NORMAL'
  AND B.board_title LIKE '%공지%'
  AND P.post_use_yn = 'Y'
  AND P.notice_yn = 'Y'
ORDER BY P.reg_dt DESC
```

#### 게시판 목록 쿼리
```sql
SELECT
    board_id,
    board_title,
    board_type,
    board_desc
FROM TB_BOARD_INFO
WHERE board_use_yn = 'Y'
  AND board_type IN ('NORMAL', 'QNA', 'FAQ')
ORDER BY board_id
```

### 4. MainController 수정
하드코딩된 값을 실제 DB 조회로 변경

**수정 전**:
```java
// 나의 요청 현황 (임시 데이터)
Map<String, Object> myStats = new HashMap<>();
myStats.put("waiting", 3);
myStats.put("received", 5);
myStats.put("processing", 2);
myStats.put("completed", 15);
```

**수정 후**:
```java
// 나의 요청 현황 (실제 DB 조회)
Map<String, Object> myStats = mainService.getMyStats(userId);

// 전체 현황 (실제 DB 조회)
Map<String, Object> totalStats = mainService.getTotalStats();

// 공지사항 목록 조회
List<Map<String, Object>> noticeList = mainService.getNoticeList();

// 게시판 목록 조회
List<Map<String, Object>> boardList = mainService.getBoardList();
```

### 5. main.jsp 수정
게시판 바로가기를 동적으로 생성

**수정 전**:
```jsp
<a href="${pageContext.request.contextPath}/user/post/list?boardId=1" class="menu-item">
    <i>📝</i>
    <span>IT 문의</span>
</a>
<a href="${pageContext.request.contextPath}/user/faq" class="menu-item">
    <i>❓</i>
    <span>FAQ</span>
</a>
```

**수정 후**:
```jsp
<!-- 동적 게시판 목록 -->
<c:forEach items="${boardList}" var="board">
    <a href="${pageContext.request.contextPath}/user/post/list?boardId=${board.board_id}" 
       class="menu-item">
        <i>
            <c:choose>
                <c:when test="${board.board_type == 'QNA'}">❓</c:when>
                <c:when test="${board.board_type == 'FAQ'}">💡</c:when>
                <c:when test="${board.board_type == 'GAL'}">🖼️</c:when>
                <c:otherwise>📝</c:otherwise>
            </c:choose>
        </i>
        <span>${board.board_title}</span>
    </a>
</c:forEach>
```

## 개선 사항

### 1. 실시간 통계
- ✅ **나의 요청 현황**: 로그인한 사용자의 실제 게시물 상태별 건수
- ✅ **전체 현황**: 시스템 전체의 게시물 상태별 건수
- ✅ **자동 업데이트**: 게시물 등록/수정 시 자동 반영

### 2. 동적 게시판 바로가기
- ✅ **자동 생성**: 게시판 등록 시 자동으로 바로가기 버튼 추가
- ✅ **아이콘 자동 선택**: 게시판 유형에 따라 적절한 아이콘 표시
  - QNA: ❓
  - FAQ: 💡
  - GAL: 🖼️
  - NORMAL: 📝
- ✅ **게시판 삭제 시 자동 제거**: board_use_yn='N'이면 표시 안 됨

### 3. 공지사항 표시
- ✅ **최근 5건 표시**: 공지사항 게시판의 최근 글 5건
- ✅ **NEW 뱃지**: 7일 이내 등록된 글에 NEW 표시
- ✅ **클릭 시 상세 페이지 이동**

## 데이터베이스 확인

### 통계 확인
```sql
-- 사용자별 통계
SELECT
    reg_id,
    SUM(CASE WHEN post_status = 'W' THEN 1 ELSE 0 END) AS waiting,
    SUM(CASE WHEN post_status = 'R' THEN 1 ELSE 0 END) AS received,
    SUM(CASE WHEN post_status = 'P' THEN 1 ELSE 0 END) AS processing,
    SUM(CASE WHEN post_status = 'C' THEN 1 ELSE 0 END) AS completed
FROM TB_POST_INFO
WHERE post_use_yn = 'Y'
GROUP BY reg_id;

-- 전체 통계
SELECT
    SUM(CASE WHEN post_status = 'W' THEN 1 ELSE 0 END) AS waiting,
    SUM(CASE WHEN post_status = 'R' THEN 1 ELSE 0 END) AS received,
    SUM(CASE WHEN post_status = 'P' THEN 1 ELSE 0 END) AS processing,
    SUM(CASE WHEN post_status = 'C' THEN 1 ELSE 0 END) AS completed
FROM TB_POST_INFO
WHERE post_use_yn = 'Y';
```

### 게시판 목록 확인
```sql
SELECT board_id, board_title, board_type, board_use_yn
FROM TB_BOARD_INFO
WHERE board_use_yn = 'Y'
ORDER BY board_id;
```

## 테스트 시나리오

### 1. 통계 확인
1. 사용자로 로그인 (user01/user1234)
2. 메인 페이지 접속
3. **나의 요청 현황** 확인
   - 대기중/접수/처리중/완료 건수가 실제 데이터와 일치하는지 확인
4. **전체 현황** 확인
   - 시스템 전체 통계가 표시되는지 확인

### 2. 게시판 바로가기 동적 생성
1. 관리자로 로그인 (admin/admin1234)
2. 게시판관리 > 게시판 등록
3. 새 게시판 등록 (예: "시스템 문의")
4. 로그아웃 후 일반 사용자로 로그인
5. 메인 페이지에서 **새로 등록한 게시판 바로가기 버튼 확인**

### 3. 게시판 삭제 시 바로가기 제거
1. 관리자로 게시판 삭제 (board_use_yn='N')
2. 일반 사용자 메인 페이지 새로고침
3. **삭제된 게시판 바로가기가 사라졌는지 확인**

### 4. 게시물 등록 후 통계 업데이트
1. 사용자로 게시물 등록
2. 메인 페이지로 돌아가기
3. **나의 요청 현황의 대기중 건수가 증가했는지 확인**

## 수정 파일 목록
1. `helpdesk/src/main/java/com/helpdesk/user/main/controller/MainController.java` - 수정
2. `helpdesk/src/main/java/com/helpdesk/user/main/service/MainService.java` - 신규
3. `helpdesk/src/main/java/com/helpdesk/user/main/mapper/MainMapper.java` - 신규
4. `helpdesk/src/main/resources/mapper/user/main_mapper.xml` - 신규
5. `helpdesk/src/main/webapp/WEB-INF/views/user/main.jsp` - 수정

## 주의사항
- 게시판 유형이 NORMAL, QNA, FAQ인 것만 바로가기에 표시됨
- 공지사항은 board_title에 '공지'가 포함된 게시판에서 조회
- 통계는 post_use_yn='Y'인 게시물만 집계
- NEW 뱃지는 7일 이내 등록된 글에만 표시

## 다음 단계
- 게시판별 아이콘 커스터마이징 기능 추가 가능
- 게시판 순서 변경 기능 추가 가능
- 즐겨찾기 게시판 기능 추가 가능
