# 메인 페이지 통계 연도 필터 적용

## 변경 사항
메인 페이지의 통계를 **해당 연도(현재 연도)만** 표시하도록 수정

## 수정 내용

### 1. SQL 쿼리 수정
**파일**: `helpdesk/src/main/resources/mapper/user/main_mapper.xml`

#### 수정 전
```sql
SELECT
    SUM(CASE WHEN post_status = 'W' THEN 1 ELSE 0 END) AS waiting,
    ...
FROM TB_POST_INFO
WHERE reg_id = #{userId}
  AND post_use_yn = 'Y'
```

#### 수정 후
```sql
SELECT
    SUM(CASE WHEN post_status = 'W' THEN 1 ELSE 0 END) AS waiting,
    ...
FROM TB_POST_INFO
WHERE reg_id = #{userId}
  AND post_use_yn = 'Y'
  AND YEAR(reg_dt) = YEAR(GETDATE())  -- 현재 연도만
```

**적용 쿼리**:
- `selectMyStats`: 나의 요청 현황
- `selectTotalStats`: 전체 현황

### 2. UI 표시 수정
**파일**: `helpdesk/src/main/webapp/WEB-INF/views/user/main.jsp`

#### 수정 전
```jsp
<h2>나의 요청 현황</h2>
<h2>전체 현황</h2>
```

#### 수정 후
```jsp
<jsp:useBean id="now" class="java.util.Date" />

<h2>나의 요청 현황 (<fmt:formatDate value="${now}" pattern="yyyy"/>년)</h2>
<h2>전체 현황 (<fmt:formatDate value="${now}" pattern="yyyy"/>년)</h2>
```

## 동작 방식

### SQL 함수 설명
```sql
YEAR(reg_dt) = YEAR(GETDATE())
```
- `YEAR(reg_dt)`: 게시물 등록일의 연도 추출
- `YEAR(GETDATE())`: 현재 날짜의 연도 추출 (2026)
- 두 값이 같은 레코드만 조회

### 예시
현재 날짜가 2026-04-24인 경우:
- ✅ 2026-01-15 등록 게시물 → 포함
- ✅ 2026-12-31 등록 게시물 → 포함
- ❌ 2025-12-31 등록 게시물 → 제외
- ❌ 2027-01-01 등록 게시물 → 제외

## 테스트 시나리오

### 1. 현재 연도 게시물 확인
```sql
-- 2026년 게시물 확인
SELECT 
    reg_id,
    post_title,
    post_status,
    reg_dt
FROM TB_POST_INFO
WHERE YEAR(reg_dt) = 2026
  AND post_use_yn = 'Y'
ORDER BY reg_dt DESC;
```

### 2. 통계 확인
```sql
-- 나의 요청 현황 (2026년)
SELECT
    SUM(CASE WHEN post_status = 'W' THEN 1 ELSE 0 END) AS waiting,
    SUM(CASE WHEN post_status = 'R' THEN 1 ELSE 0 END) AS received,
    SUM(CASE WHEN post_status = 'P' THEN 1 ELSE 0 END) AS processing,
    SUM(CASE WHEN post_status = 'C' THEN 1 ELSE 0 END) AS completed
FROM TB_POST_INFO
WHERE reg_id = 'user01'
  AND post_use_yn = 'Y'
  AND YEAR(reg_dt) = 2026;
```

### 3. 메인 페이지 확인
1. 사용자로 로그인 (user01/user1234)
2. 메인 페이지 접속
3. **나의 요청 현황 (2026년)** 제목 확인
4. **전체 현황 (2026년)** 제목 확인
5. 통계 건수가 2026년 데이터만 집계되었는지 확인

### 4. 연도 변경 테스트
```sql
-- 테스트용 2025년 데이터 삽입
INSERT INTO TB_POST_INFO (board_id, post_title, post_status, reg_id, reg_dt, post_use_yn)
VALUES (1, '2025년 테스트', 'W', 'user01', '2025-12-31', 'Y');

-- 메인 페이지 새로고침 → 2025년 데이터는 통계에 포함되지 않음
```

## 장점

### 1. 성능 개선
- 인덱스 활용: `reg_dt` 컬럼에 인덱스가 있으면 연도 필터링 시 성능 향상
- 데이터 양 감소: 전체 데이터가 아닌 해당 연도만 조회

### 2. 사용자 경험 개선
- 명확한 정보: "2026년" 표시로 어떤 기간의 통계인지 명확
- 관련성 높은 데이터: 과거 데이터 제외로 현재 상황에 집중

### 3. 유지보수
- 자동 연도 변경: 2027년이 되면 자동으로 2027년 데이터 조회
- 코드 수정 불필요: `YEAR(GETDATE())`로 자동 처리

## 추가 개선 가능 사항

### 1. 연도 선택 기능
사용자가 원하는 연도를 선택할 수 있도록 드롭다운 추가:
```jsp
<select id="yearFilter" onchange="loadStats(this.value)">
    <option value="2026" selected>2026년</option>
    <option value="2025">2025년</option>
    <option value="2024">2024년</option>
</select>
```

### 2. 월별 통계
연도뿐만 아니라 월별 통계도 제공:
```sql
WHERE YEAR(reg_dt) = YEAR(GETDATE())
  AND MONTH(reg_dt) = MONTH(GETDATE())
```

### 3. 기간 선택
시작일~종료일 범위로 통계 조회:
```sql
WHERE reg_dt BETWEEN @startDate AND @endDate
```

### 4. 전년 대비 증감
전년도와 비교하여 증감률 표시:
```sql
-- 전년도 통계
WHERE YEAR(reg_dt) = YEAR(GETDATE()) - 1

-- 증감률 계산
(올해 건수 - 작년 건수) / 작년 건수 * 100
```

## 성능 최적화

### 인덱스 추가 권장
```sql
-- reg_dt 컬럼에 인덱스 생성
CREATE INDEX IX_POST_INFO_REG_DT 
ON TB_POST_INFO(reg_dt);

-- 복합 인덱스 (더 효율적)
CREATE INDEX IX_POST_INFO_YEAR_STATUS 
ON TB_POST_INFO(reg_dt, post_status, post_use_yn);
```

### 쿼리 실행 계획 확인
```sql
-- 실행 계획 확인
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT ...
FROM TB_POST_INFO
WHERE YEAR(reg_dt) = YEAR(GETDATE())
  AND post_use_yn = 'Y';
```

## 수정 파일
1. `helpdesk/src/main/resources/mapper/user/main_mapper.xml` - SQL 쿼리 수정
2. `helpdesk/src/main/webapp/WEB-INF/views/user/main.jsp` - UI 표시 수정

## 주의사항
- `YEAR()` 함수 사용 시 인덱스 스캔이 아닌 풀 스캔이 발생할 수 있음
- 대용량 데이터의 경우 성능 테스트 필요
- 연도가 바뀌는 시점(12월 31일 → 1월 1일)에 통계가 리셋됨
