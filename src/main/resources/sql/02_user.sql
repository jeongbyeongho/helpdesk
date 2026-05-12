-- =====================================================
-- 02_user.sql : 사용자/회원 관련 테이블
-- =====================================================
USE helpdesk;
GO

-- 사용자 기본 정보
IF OBJECT_ID('TB_USER_INFO', 'U') IS NULL
CREATE TABLE TB_USER_INFO (
    user_seq        INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NOT NULL,           -- 사용자ID
    user_nm         VARCHAR(256)    NULL,               -- 사용자명
    user_pwd        VARCHAR(256)    NULL,               -- 비밀번호 (SHA-256)
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
GO

-- 사용자 유형 (시스템별 소속/권한 정보)
IF OBJECT_ID('TB_USER_TYPE_INFO', 'U') IS NULL
CREATE TABLE TB_USER_TYPE_INFO (
    user_type_seq   INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NULL,               -- 사용자ID
    user_type       CHAR(1)         NULL,               -- 사용자유형
    org_code        VARCHAR(128)    NULL,               -- 기관코드
    org_nm          VARCHAR(128)    NULL,               -- 기관명
    org_type        CHAR(1)         NULL,               -- 기관유형
    dept_code       VARCHAR(32)     NULL,               -- 부서코드
    job_seq         VARCHAR(16)     NULL,               -- 업무순번
    approval_yn     CHAR(1)         NULL DEFAULT 'N',   -- 승인여부
    approval_user_id VARCHAR(256)   NULL,               -- 승인자ID
    approval_user_nm VARCHAR(256)   NULL,               -- 승인자명
    approval_dt     DATETIME        NULL,               -- 승인일시
    staff_type      CHAR(1)         NULL,               -- 직원유형
    CONSTRAINT PK_TB_USER_TYPE_INFO PRIMARY KEY (user_type_seq)
);
GO

-- 비밀번호 변경 이력
IF OBJECT_ID('TB_USER_PWD_HIST', 'U') IS NULL
CREATE TABLE TB_USER_PWD_HIST (
    pwd_hist_seq    INT             NOT NULL IDENTITY(1,1),
    hist_type       VARCHAR(16)     NULL,               -- 이력유형
    user_id         VARCHAR(256)    NULL,               -- 사용자ID
    prev_pwd        VARCHAR(256)    NULL,               -- 이전비밀번호
    reg_id          VARCHAR(256)    NULL,               -- 등록자ID
    reg_nm          VARCHAR(256)    NULL,               -- 등록자명
    reg_ip          VARCHAR(256)    NULL,               -- 등록IP
    reg_dt          DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_USER_PWD_HIST PRIMARY KEY (pwd_hist_seq)
);
GO

-- 사용자 변경 이력
IF OBJECT_ID('TB_USER_HIST', 'U') IS NULL
CREATE TABLE TB_USER_HIST (
    hist_seq        INT             NOT NULL IDENTITY(1,1),
    hist_group_seq  INT             NOT NULL,           -- 이력그룹순번
    user_id         VARCHAR(256)    NULL,               -- 사용자ID
    user_nm         VARCHAR(256)    NULL,               -- 사용자명
    user_type       CHAR(1)         NULL,               -- 사용자유형
    mobile_no       VARCHAR(256)    NULL,               -- 휴대폰번호
    org_code        VARCHAR(128)    NULL,               -- 기관코드
    dept_nm         VARCHAR(256)    NULL,               -- 부서명
    hist_user_id    VARCHAR(256)    NULL,               -- 처리자ID
    hist_user_nm    VARCHAR(256)    NULL,               -- 처리자명
    hist_user_ip    VARCHAR(256)    NULL,               -- 처리IP
    hist_dt         DATETIME        NOT NULL DEFAULT GETDATE(),
    hist_type       CHAR(1)         NULL,               -- 이력유형 (I:등록, U:수정, D:삭제)
    CONSTRAINT PK_TB_USER_HIST PRIMARY KEY (hist_seq)
);
GO

-- 회원 승인 설정
IF OBJECT_ID('TB_USER_APPROVAL_CFG', 'U') IS NULL
CREATE TABLE TB_USER_APPROVAL_CFG (
    sys_id          VARCHAR(256)    NULL,               -- 시스템ID
    user_type       CHAR(1)         NULL,               -- 사용자유형
    auto_approval_yn CHAR(1)        NULL DEFAULT 'N'    -- 자동승인여부
);
GO

PRINT '02_user.sql 완료';
GO
