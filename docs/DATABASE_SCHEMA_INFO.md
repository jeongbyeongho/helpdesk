# 데이터베이스 스키마 정보

## 주요 테이블 구조

### TB_USER_INFO (사용자 정보)
```sql
CREATE TABLE TB_USER_INFO (
    user_seq        INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NOT NULL,           -- 사용자ID
    user_nm         VARCHAR(256)    NULL,               -- 사용자명
    user_pwd        VARCHAR(256)    NULL,               -- 비밀번호 (BCrypt)
    mobile_no       VARCHAR(256)    NULL,               -- 휴대폰번호
    tel_no          VARCHAR(256)    NULL,               -- 전화번호
    email           VARCHAR(256)    NULL,               -- 이메일
    dept_nm         VARCHAR(256)    NULL,               -- 부서명
    ci_key          VARCHAR(256)    NULL,               -- CI키
    certi_key       VARCHAR(256)    NULL,               -- 인증키
    reg_dt          DATETIME        NULL,               -- 등록일시
    reg_ip          VARCHAR(256)    NULL,               -- 등록IP
    CONSTRAINT PK_TB_USER_INFO PRIMARY KEY (user_seq),
    CONSTRAINT UQ_TB_USER_INFO_ID UNIQUE (user_id)
);
```

**주의**: `use_yn` 컬럼이 없습니다!

### TB_POST_INFO (게시물 정보)
```sql
CREATE TABLE TB_POST_INFO (
    board_id            INT             NOT NULL,
    post_seq            INT             NOT NULL IDENTITY(1,1),
    post_title          VARCHAR(2000)   NULL,
    post_content        VARCHAR(MAX)    NULL,
    reg_id              VARCHAR(256)    NULL,
    reg_nm              VARCHAR(256)    NULL,
    reg_ip              VARCHAR(256)    NULL,
    reg_dt              DATETIME        NOT NULL DEFAULT GETDATE(),
    read_cnt            INT             NOT NULL DEFAULT 0,
    post_status         CHAR(1)         NULL,           -- 게시물상태
    post_use_yn         CHAR(1)         NULL DEFAULT 'Y',
    secret_yn           CHAR(1)         NULL DEFAULT 'N',
    notice_yn           CHAR(1)         NULL DEFAULT 'N',
    notice_begin_dt     DATETIME        NULL,
    notice_end_dt       DATETIME        NULL,
    ...
);
```

### 게시물 상태 코드 (post_status)
- **W**: 대기 (Waiting)
- **R**: 접수 (Received)
- **C**: 완료 (Completed)
- **H**: 보류 (Hold)

### TB_USER_TYPE_INFO (사용자 유형/권한)
```sql
CREATE TABLE TB_USER_TYPE_INFO (
    user_type_seq   INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NULL,
    user_type       CHAR(1)         NULL,               -- 사용자유형
    org_code        VARCHAR(128)    NULL,
    org_nm          VARCHAR(128)    NULL,
    dept_code       VARCHAR(32)     NULL,
    approval_yn     CHAR(1)         NULL DEFAULT 'N',   -- 승인여부
    approval_user_id VARCHAR(256)   NULL,
    approval_user_nm VARCHAR(256)   NULL,
    approval_dt     DATETIME        NULL,
    ...
);
```

### TB_BOARD_INFO (게시판 정보)
```sql
CREATE TABLE TB_BOARD_INFO (
    board_id            INT             NOT NULL IDENTITY(1,1),
    board_title         VARCHAR(256)    NULL,
    board_type          VARCHAR(10)     NULL,           -- 게시판타입
    status_use_yn       CHAR(1)         NULL DEFAULT 'Y',
    reply_yn            CHAR(1)         NULL DEFAULT 'Y',
    secret_use_yn       CHAR(1)         NULL DEFAULT 'N',
    file_use_yn         CHAR(1)         NULL DEFAULT 'Y',
    file_max_cnt        INT             NULL DEFAULT 5,
    file_max_size       BIGINT          NULL DEFAULT 10485760,
    allow_ext           VARCHAR(500)    NULL,
    use_yn              CHAR(1)         NULL DEFAULT 'Y',
    ...
);
```

### 게시판 타입 (board_type)
- **BOARD**: 일반게시판
- **NOTICE**: 공지사항
- **FAQ**: FAQ
- **QNA**: Q&A

## 권한 코드 (role_code)

현재 시스템에서 사용하는 권한 코드:
- **1**: 시스템 관리자 (모든 권한)
- **2**: 관리자 (관리자 페이지 접근 가능)
- **3**: 일반 사용자 (사용자 페이지만 접근)

## 세션 정보

로그인 후 세션에 저장되는 정보:
```java
sessionScope.LOGIN_USER = {
    user_id: "사용자ID",
    user_nm: "사용자명",
    userNm: "사용자명",  // 대체 키
    roleCode: 권한코드,
    role_code: 권한코드   // 대체 키
}
```

## 주요 Y/N 플래그

### 공통
- **Y**: Yes (사용/활성)
- **N**: No (미사용/비활성)

### 사용 위치
- `post_use_yn`: 게시물 사용여부
- `use_yn`: 일반적인 사용여부
- `approval_yn`: 승인여부
- `secret_yn`: 비밀글여부
- `notice_yn`: 공지여부
- `reply_yn`: 답변 사용여부
- `file_use_yn`: 파일 사용여부

## 파일 업로드 설정

### 기본 설정
- **업로드 경로**: `D:/helpdesk/upload`
- **최대 파일 개수**: 5개
- **최대 파일 크기**: 10MB (10485760 bytes)
- **허용 확장자**: jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,zip

## 날짜/시간 필드

### 공통 패턴
- `reg_dt`: 등록일시 (DATETIME, DEFAULT GETDATE())
- `reg_id`: 등록자ID
- `reg_nm`: 등록자명
- `reg_ip`: 등록IP

## 주의사항

### 1. use_yn 컬럼
- TB_USER_INFO에는 `use_yn` 컬럼이 **없습니다**
- 사용자 삭제는 물리적 삭제 또는 별도 플래그 사용

### 2. 상태 코드
- 게시물 상태는 1자리 문자 (W, R, C, H)
- 4자리 문자열 (WAIT, PROC, COMP) 사용 금지

### 3. Identity 컬럼
- 대부분의 PK는 IDENTITY(1,1) 사용
- INSERT 시 PK 값 지정 불가
- useGeneratedKeys="true" 설정 필요

### 4. VARCHAR vs NVARCHAR
- VARCHAR: 영문/숫자 위주
- NVARCHAR: 한글 포함 (일부 테이블에서 사용)

## 쿼리 작성 시 주의사항

### 1. 날짜 비교
```sql
-- 오늘 날짜 비교
CAST(reg_dt AS DATE) = CAST(GETDATE() AS DATE)

-- 기간 비교
reg_dt BETWEEN @startDate AND @endDate
```

### 2. 문자열 연결
```sql
-- SQL Server 방식
'%' + #{keyword} + '%'

-- 또는
CONCAT('%', #{keyword}, '%')
```

### 3. NULL 처리
```sql
-- COALESCE 사용
COALESCE(column_name, 'default_value')

-- ISNULL 사용
ISNULL(column_name, 'default_value')
```

### 4. 페이징
```sql
-- ROW_NUMBER() 사용
SELECT * FROM (
    SELECT *, ROW_NUMBER() OVER(ORDER BY reg_dt DESC) AS rn
    FROM TB_POST_INFO
) AS numbered
WHERE rn > #{minSn} AND rn <= #{maxSn}
```

## 초기 데이터

### 관리자 계정
```sql
INSERT INTO TB_USER_INFO (user_id, user_nm, user_pwd, email, dept_nm, reg_dt)
VALUES ('admin', '관리자', '$2a$10$...', 'admin@example.com', 'IT부서', GETDATE());
```

### 일반 사용자 계정
```sql
INSERT INTO TB_USER_INFO (user_id, user_nm, user_pwd, email, dept_nm, reg_dt)
VALUES ('user01', '사용자01', '$2a$10$...', 'user01@example.com', '영업부', GETDATE());
```

### 게시판
```sql
INSERT INTO TB_BOARD_INFO (board_title, board_type, status_use_yn, reply_yn, file_use_yn, ...)
VALUES ('IT 문의게시판', 'BOARD', 'Y', 'Y', 'Y', ...);
```

## 참고 파일

- `src/main/resources/sql/01_system.sql` - 시스템/기관/부서
- `src/main/resources/sql/02_user.sql` - 사용자/회원
- `src/main/resources/sql/03_menu.sql` - 메뉴/권한
- `src/main/resources/sql/04_board.sql` - 게시판
- `src/main/resources/sql/05_post.sql` - 게시물/답변/파일
- `src/main/resources/sql/06_code.sql` - 코드
- `src/main/resources/sql/07_popup.sql` - 팝업
- `src/main/resources/sql/00_init_data.sql` - 초기 데이터
