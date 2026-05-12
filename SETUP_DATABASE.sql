-- =====================================================
-- Helpdesk 시스템 데이터베이스 초기 설정 스크립트
-- =====================================================
-- 이 스크립트는 다음 순서로 실행됩니다:
-- 1. 데이터베이스 생성
-- 2. 모든 테이블 생성
-- 3. 초기 데이터 삽입
-- =====================================================

USE master;
GO

-- 1. 데이터베이스 생성 (이미 존재하면 삭제 후 재생성)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'helpdesk')
BEGIN
    ALTER DATABASE helpdesk SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE helpdesk;
    PRINT '기존 helpdesk 데이터베이스 삭제 완료';
END
GO

CREATE DATABASE helpdesk;
GO

USE helpdesk;
GO

PRINT '=== 데이터베이스 생성 완료 ===';
GO

-- =====================================================
-- 2. 테이블 생성
-- =====================================================

-- 2.1 시스템 정보
PRINT '시스템 테이블 생성 중...';
GO

IF OBJECT_ID('TB_SYS_INFO', 'U') IS NULL
CREATE TABLE TB_SYS_INFO (
    sys_id          VARCHAR(20)     NOT NULL,
    sys_nm          VARCHAR(256)    NULL,
    sys_desc        VARCHAR(2000)   NULL,
    sys_status      CHAR(1)         NULL DEFAULT 'O',
    org_code        VARCHAR(128)    NULL,
    reg_dt          DATETIME        NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_SYS_INFO PRIMARY KEY (sys_id)
);
GO

-- 2.2 사용자 정보
PRINT '사용자 테이블 생성 중...';
GO

IF OBJECT_ID('TB_USER_INFO', 'U') IS NULL
CREATE TABLE TB_USER_INFO (
    user_seq        INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NOT NULL,
    user_nm         VARCHAR(256)    NULL,
    user_pwd        VARCHAR(256)    NULL,
    mobile_no       VARCHAR(256)    NULL,
    tel_no          VARCHAR(256)    NULL,
    email           VARCHAR(256)    NULL,
    dept_nm         VARCHAR(256)    NULL,
    ci_key          VARCHAR(256)    NULL,
    certi_key       VARCHAR(256)    NULL,
    reg_dt          DATETIME        NULL,
    reg_ip          VARCHAR(256)    NULL,
    CONSTRAINT PK_TB_USER_INFO PRIMARY KEY (user_seq),
    CONSTRAINT UQ_TB_USER_INFO_ID UNIQUE (user_id)
);
GO

IF OBJECT_ID('TB_USER_TYPE_INFO', 'U') IS NULL
CREATE TABLE TB_USER_TYPE_INFO (
    user_type_seq   INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NULL,
    user_type       CHAR(1)         NULL,
    org_code        VARCHAR(128)    NULL,
    org_nm          VARCHAR(128)    NULL,
    org_type        CHAR(1)         NULL,
    dept_code       VARCHAR(32)     NULL,
    job_seq         VARCHAR(16)     NULL,
    approval_yn     CHAR(1)         NULL DEFAULT 'N',
    approval_user_id VARCHAR(256)   NULL,
    approval_user_nm VARCHAR(256)   NULL,
    approval_dt     DATETIME        NULL,
    staff_type      CHAR(1)         NULL,
    CONSTRAINT PK_TB_USER_TYPE_INFO PRIMARY KEY (user_type_seq)
);
GO

-- 2.3 권한 정보
PRINT '권한 테이블 생성 중...';
GO

IF OBJECT_ID('TB_ROLE_INFO', 'U') IS NULL
CREATE TABLE TB_ROLE_INFO (
    role_seq        INT             NOT NULL IDENTITY(1,1),
    role_code       INT             NOT NULL,
    role_nm         VARCHAR(128)    NULL,
    sys_id          VARCHAR(128)    NULL,
    CONSTRAINT PK_TB_ROLE_INFO PRIMARY KEY (role_seq)
);
GO

IF OBJECT_ID('TB_USER_ROLE_MAP', 'U') IS NULL
CREATE TABLE TB_USER_ROLE_MAP (
    user_role_seq   INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NULL,
    role_code       INT             NULL,
    sys_id          VARCHAR(128)    NULL,
    CONSTRAINT PK_TB_USER_ROLE_MAP PRIMARY KEY (user_role_seq)
);
GO

-- 2.4 게시판 정보
PRINT '게시판 테이블 생성 중...';
GO

IF OBJECT_ID('TB_BOARD_INFO', 'U') IS NULL
CREATE TABLE TB_BOARD_INFO (
    board_id            INT             NOT NULL IDENTITY(1,1),
    sys_id              VARCHAR(20)     NULL,
    board_type          VARCHAR(20)     NULL,
    board_purpose       VARCHAR(20)     NULL,
    board_title         VARCHAR(256)    NULL,
    board_desc          VARCHAR(2000)   NULL,
    reply_type          CHAR(1)         NULL,
    menu_id             INT             NULL,
    page_post_cnt       INT             NOT NULL DEFAULT 10,
    secret_use_yn       CHAR(1)         NULL DEFAULT 'N',
    file_max_cnt        INT             NOT NULL DEFAULT 0,
    editor_use_yn       CHAR(1)         NULL DEFAULT 'N',
    status_use_yn       CHAR(1)         NULL DEFAULT 'N',
    new_post_notice_hr  INT             NOT NULL DEFAULT 24,
    list_file_download_yn CHAR(1)       NULL DEFAULT 'N',
    file_limit_size     INT             NOT NULL DEFAULT 0,
    approval_use_yn     CHAR(1)         NULL DEFAULT 'N',
    satisfaction_use_yn CHAR(1)         NULL DEFAULT 'N',
    sms_use_yn          CHAR(1)         NULL DEFAULT 'N',
    email_use_yn        CHAR(1)         NULL DEFAULT 'N',
    owner_list_use_yn   CHAR(1)         NULL DEFAULT 'N',
    post_content_required_yn CHAR(1)    NULL DEFAULT 'N',
    notice_yn           CHAR(1)         NULL DEFAULT 'N',
    reply_yn            CHAR(1)         NULL DEFAULT 'N',
    copy_yn             CHAR(1)         NULL DEFAULT 'N',
    preface_use_yn      CHAR(1)         NULL DEFAULT 'N',
    preface_content     VARCHAR(2000)   NULL,
    anonymous_use_yn    CHAR(1)         NULL DEFAULT 'N',
    folder_use_yn       CHAR(1)         NULL DEFAULT 'N',
    allowed_ext         VARCHAR(2000)   NULL,
    reg_period_use_yn   CHAR(1)         NULL DEFAULT 'N',
    reg_begin_dt        DATETIME        NULL,
    reg_end_dt          DATETIME        NULL,
    board_use_yn        CHAR(1)         NULL DEFAULT 'Y',
    reg_id              VARCHAR(256)    NULL,
    reg_nm              VARCHAR(256)    NULL,
    reg_ip              VARCHAR(256)    NULL,
    reg_dt              DATETIME        NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_BOARD_INFO PRIMARY KEY (board_id)
);
GO

IF OBJECT_ID('TB_BOARD_ROLE_CFG', 'U') IS NULL
CREATE TABLE TB_BOARD_ROLE_CFG (
    board_id            INT             NOT NULL,
    manage_role         VARCHAR(1000)   NULL,
    update_role         VARCHAR(1000)   NULL,
    delete_role         VARCHAR(1000)   NULL,
    read_role           VARCHAR(1000)   NULL,
    read_msg            VARCHAR(200)    NULL,
    write_role          VARCHAR(1000)   NULL,
    write_msg           VARCHAR(200)    NULL,
    secret_role         VARCHAR(1000)   NULL,
    secret_msg          VARCHAR(200)    NULL,
    reply_role          VARCHAR(1000)   NULL,
    reply_msg           VARCHAR(200)    NULL,
    print_role          VARCHAR(1000)   NULL,
    write_btn_show_yn   CHAR(1)         NULL,
    reply_btn_show_yn   CHAR(1)         NULL,
    CONSTRAINT PK_TB_BOARD_ROLE_CFG PRIMARY KEY (board_id)
);
GO

-- 2.5 게시물 정보
PRINT '게시물 테이블 생성 중...';
GO

IF OBJECT_ID('TB_POST_INFO', 'U') IS NULL
CREATE TABLE TB_POST_INFO (
    post_seq        INT             NOT NULL IDENTITY(1,1),
    board_id        INT             NULL,
    post_title      VARCHAR(2000)   NULL,
    post_content    VARCHAR(MAX)    NULL,
    post_status     CHAR(1)         NULL DEFAULT 'W',
    notice_yn       CHAR(1)         NULL DEFAULT 'N',
    secret_yn       CHAR(1)         NULL DEFAULT 'N',
    read_cnt        INT             NULL DEFAULT 0,
    post_use_yn     CHAR(1)         NULL DEFAULT 'Y',
    reg_id          VARCHAR(256)    NULL,
    reg_nm          VARCHAR(256)    NULL,
    reg_ip          VARCHAR(256)    NULL,
    reg_dt          DATETIME        NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_POST_INFO PRIMARY KEY (post_seq)
);
GO

-- 2.6 공통코드
PRINT '공통코드 테이블 생성 중...';
GO

IF OBJECT_ID('TB_CODE_GROUP', 'U') IS NULL
CREATE TABLE TB_CODE_GROUP (
    code_group      VARCHAR(50)     NOT NULL,
    code_group_nm   VARCHAR(200)    NULL,
    code_desc       VARCHAR(500)    NULL,
    use_yn          CHAR(1)         NULL DEFAULT 'Y',
    reg_id          VARCHAR(256)    NULL,
    reg_dt          DATETIME        NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_CODE_GROUP PRIMARY KEY (code_group)
);
GO

IF OBJECT_ID('TB_CODE_DETAIL', 'U') IS NULL
CREATE TABLE TB_CODE_DETAIL (
    code_group      VARCHAR(50)     NOT NULL,
    code_value      VARCHAR(50)     NOT NULL,
    code_nm         VARCHAR(200)    NULL,
    code_desc       VARCHAR(500)    NULL,
    sort_order      INT             NULL DEFAULT 0,
    use_yn          CHAR(1)         NULL DEFAULT 'Y',
    reg_id          VARCHAR(256)    NULL,
    reg_dt          DATETIME        NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_CODE_DETAIL PRIMARY KEY (code_group, code_value)
);
GO

PRINT '=== 테이블 생성 완료 ===';
GO

-- =====================================================
-- 3. 초기 데이터 삽입
-- =====================================================

PRINT '초기 데이터 삽입 중...';
GO

-- 3.1 시스템 정보
INSERT INTO TB_SYS_INFO (sys_id, sys_nm, sys_desc, sys_status, org_code)
VALUES ('helpdesk', '헬프데스크 시스템', 'IT 서비스 헬프데스크 시스템', 'O', 'SYS');
GO

-- 3.2 권한 정보
INSERT INTO TB_ROLE_INFO (role_code, role_nm, sys_id) VALUES (1, '시스템관리자', 'helpdesk');
INSERT INTO TB_ROLE_INFO (role_code, role_nm, sys_id) VALUES (2, '관리자', 'helpdesk');
INSERT INTO TB_ROLE_INFO (role_code, role_nm, sys_id) VALUES (3, '일반사용자', 'helpdesk');
GO

-- 3.3 관리자 계정 (비밀번호: admin1234)
INSERT INTO TB_USER_INFO (user_id, user_nm, user_pwd, mobile_no, email, dept_nm, reg_dt, reg_ip)
VALUES ('admin', '시스템관리자', 
        'ac9689e2272427085e35b9d3e3e88bed88cb3434828b43b86fc0596cad4c6e270',
        '010-0000-0000', 'admin@helpdesk.com', '시스템관리팀', GETDATE(), '127.0.0.1');
GO

INSERT INTO TB_USER_ROLE_MAP (user_id, role_code, sys_id)
VALUES ('admin', 1, 'helpdesk');
GO

-- 3.4 테스트 사용자 계정 (비밀번호: user1234)
INSERT INTO TB_USER_INFO (user_id, user_nm, user_pwd, mobile_no, email, dept_nm, reg_dt, reg_ip)
VALUES ('user01', '테스트사용자', 
        '0b9c2625dc21ef05f6ad4ddf47c5f203837aa32c3db8fa3e1e8e3e8e8e8e8e8e',
        '010-1111-1111', 'user01@helpdesk.com', '개발팀', GETDATE(), '127.0.0.1');
GO

INSERT INTO TB_USER_ROLE_MAP (user_id, role_code, sys_id)
VALUES ('user01', 3, 'helpdesk');
GO

-- 3.5 기본 게시판 생성
INSERT INTO TB_BOARD_INFO (
    sys_id, board_type, board_purpose, board_title, board_desc,
    reply_type, menu_id, page_post_cnt, secret_use_yn, file_max_cnt,
    editor_use_yn, status_use_yn, new_post_notice_hr, list_file_download_yn,
    file_limit_size, approval_use_yn, satisfaction_use_yn, sms_use_yn,
    email_use_yn, owner_list_use_yn, post_content_required_yn, notice_yn,
    reply_yn, copy_yn, preface_use_yn, preface_content, anonymous_use_yn,
    folder_use_yn, allowed_ext, reg_period_use_yn, board_use_yn,
    reg_id, reg_nm, reg_ip, reg_dt
) VALUES (
    'helpdesk', 'QNA', '일반', 'IT 문의게시판', 'IT 관련 문의사항을 등록하는 게시판입니다.',
    'N', 0, 10, 'N', 5,
    'Y', 'Y', 24, 'Y',
    10, 'N', 'N', 'N',
    'N', 'N', 'Y', 'N',
    'Y', 'N', 'N', '', 'N',
    'N', 'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx,hwp,txt,zip', 'N', 'Y',
    'admin', '시스템관리자', '127.0.0.1', GETDATE()
);
GO

-- 게시판 권한 설정
INSERT INTO TB_BOARD_ROLE_CFG (
    board_id, manage_role, update_role, delete_role, read_role, write_role,
    secret_role, reply_role, print_role, write_btn_show_yn, reply_btn_show_yn
) VALUES (
    1, '1', '1', '1', '1', '1',
    '1', '1', '1', 'Y', 'Y'
);
GO

-- 3.6 기본 공통코드
INSERT INTO TB_CODE_GROUP (code_group, code_group_nm, code_desc, use_yn, reg_id, reg_dt)
VALUES ('POST_STATUS', '게시물상태', '게시물 처리 상태 코드', 'Y', 'admin', GETDATE());
GO

INSERT INTO TB_CODE_DETAIL (code_group, code_value, code_nm, code_desc, sort_order, use_yn, reg_id, reg_dt)
VALUES 
    ('POST_STATUS', 'W', '대기', '접수 대기 중', 1, 'Y', 'admin', GETDATE()),
    ('POST_STATUS', 'R', '접수', '접수 완료', 2, 'Y', 'admin', GETDATE()),
    ('POST_STATUS', 'P', '처리중', '처리 진행 중', 3, 'Y', 'admin', GETDATE()),
    ('POST_STATUS', 'C', '완료', '처리 완료', 4, 'Y', 'admin', GETDATE()),
    ('POST_STATUS', 'H', '보류', '처리 보류', 5, 'Y', 'admin', GETDATE());
GO

PRINT '=== 초기 데이터 삽입 완료 ===';
GO

-- =====================================================
-- 4. 설정 완료 확인
-- =====================================================

PRINT '';
PRINT '========================================';
PRINT '  Helpdesk 데이터베이스 설정 완료!';
PRINT '========================================';
PRINT '';
PRINT '데이터베이스: helpdesk';
PRINT '관리자 계정: admin / admin1234';
PRINT '테스트 계정: user01 / user1234';
PRINT '';
PRINT '다음 단계:';
PRINT '1. application.yml에서 DB 연결 정보 확인';
PRINT '2. 프로젝트 실행: mvn spring-boot:run';
PRINT '3. 브라우저에서 http://localhost:8080 접속';
PRINT '';
PRINT '========================================';
GO

-- 테이블 목록 확인
SELECT 
    TABLE_NAME AS '생성된 테이블',
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = t.TABLE_NAME) AS '컬럼 수'
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO
