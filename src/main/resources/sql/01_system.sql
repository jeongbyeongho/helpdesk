-- =====================================================
-- 01_system.sql : 시스템/기관/부서 관련 테이블
-- =====================================================
USE helpdesk;
GO

-- 기관 정보
IF OBJECT_ID('TB_ORG_INFO', 'U') IS NULL
CREATE TABLE TB_ORG_INFO (
    org_code        VARCHAR(64)     NOT NULL,           -- 기관코드
    org_nm          VARCHAR(128)    NULL,               -- 기관명
    org_type        CHAR(1)         NULL,               -- 기관유형
    org_grade       VARCHAR(32)     NULL,               -- 기관등급
    org_level       INT             NULL,               -- 기관레벨
    upper_org_code  VARCHAR(64)     NULL,               -- 상위기관코드
    upper_org_nm    VARCHAR(128)    NULL,               -- 상위기관명
    base_org_code   VARCHAR(64)     NULL,               -- 기준기관코드
    base_org_nm     VARCHAR(128)    NULL,               -- 기준기관명
    area            VARCHAR(128)    NULL,               -- 지역
    CONSTRAINT PK_TB_ORG_INFO PRIMARY KEY (org_code)
);
GO

-- 시스템 정보
IF OBJECT_ID('TB_SYS_INFO', 'U') IS NULL
CREATE TABLE TB_SYS_INFO (
    sys_id          VARCHAR(20)     NOT NULL,           -- 시스템ID
    sys_nm          NVARCHAR(100)   NULL,               -- 시스템명
    sys_type        VARCHAR(10)     NULL,               -- 시스템유형
    sys_status      VARCHAR(10)     NULL,               -- 시스템상태 (O:운영, S:중지, D:삭제)
    sys_purpose     VARCHAR(10)     NULL,               -- 시스템용도
    org_code        VARCHAR(256)    NULL,               -- 기관코드
    template_id     VARCHAR(10)     NULL,               -- 템플릿ID
    template_type   VARCHAR(32)     NULL,               -- 템플릿유형
    intro_yn        CHAR(1)         NULL,               -- 인트로사용여부
    establish_dt    DATETIME        NULL,               -- 구축일자
    charger         VARCHAR(20)     NULL,               -- 담당자
    tel_no          VARCHAR(20)     NULL,               -- 전화번호
    reg_id          VARCHAR(256)    NULL,               -- 등록자ID
    reg_nm          VARCHAR(256)    NULL,               -- 등록자명
    reg_ip          VARCHAR(256)    NULL,               -- 등록IP
    reg_dt          DATETIME        NULL,               -- 등록일시
    CONSTRAINT PK_TB_SYS_INFO PRIMARY KEY (sys_id)
);
GO

-- 시스템 도메인
IF OBJECT_ID('TB_SYS_DOMAIN_INFO', 'U') IS NULL
CREATE TABLE TB_SYS_DOMAIN_INFO (
    domain_seq      INT             NOT NULL IDENTITY(1,1),
    sys_id          VARCHAR(20)     NULL,               -- 시스템ID
    sys_domain      VARCHAR(500)    NULL,               -- 도메인
    use_yn          CHAR(1)         NULL,               -- 사용여부
    CONSTRAINT PK_TB_SYS_DOMAIN_INFO PRIMARY KEY (domain_seq)
);
GO

-- 부서 정보
IF OBJECT_ID('TB_DEPT_INFO', 'U') IS NULL
CREATE TABLE TB_DEPT_INFO (
    dept_seq        INT             NOT NULL IDENTITY(1,1),
    org_code        NVARCHAR(256)   NULL,               -- 기관코드
    dept_code       NVARCHAR(10)    NULL,               -- 부서코드
    dept_nm         NVARCHAR(256)   NULL,               -- 부서명
    reg_id          NVARCHAR(256)   NULL,               -- 등록자ID
    reg_nm          NVARCHAR(256)   NULL,               -- 등록자명
    reg_ip          NVARCHAR(256)   NULL,               -- 등록IP
    reg_dt          DATETIME        NULL,               -- 등록일시
    CONSTRAINT PK_TB_DEPT_INFO PRIMARY KEY (dept_seq)
);
GO

-- 부서 업무
IF OBJECT_ID('TB_DEPT_JOB_INFO', 'U') IS NULL
CREATE TABLE TB_DEPT_JOB_INFO (
    dept_job_seq    INT             NOT NULL IDENTITY(1,1),
    dept_code       NVARCHAR(10)    NULL,               -- 부서코드
    job_nm          NVARCHAR(256)   NULL,               -- 업무명
    sort_order      INT             NULL,               -- 정렬순서
    reg_id          NVARCHAR(256)   NULL,               -- 등록자ID
    reg_nm          NVARCHAR(256)   NULL,               -- 등록자명
    reg_ip          NVARCHAR(256)   NULL,               -- 등록IP
    reg_dt          DATETIME        NULL,               -- 등록일시
    CONSTRAINT PK_TB_DEPT_JOB_INFO PRIMARY KEY (dept_job_seq)
);
GO

-- 사이트 정보
IF OBJECT_ID('TB_SITE_INFO', 'U') IS NULL
CREATE TABLE TB_SITE_INFO (
    site_info_seq   INT             NOT NULL IDENTITY(1,1),
    sys_id          VARCHAR(20)     NULL,               -- 시스템ID
    site_addr       VARCHAR(1024)   NULL,               -- 사이트주소
    site_tel_no     VARCHAR(512)    NULL,               -- 전화번호
    site_fax_no     VARCHAR(512)    NULL,               -- 팩스번호
    site_email      VARCHAR(512)    NULL,               -- 이메일
    reg_id          VARCHAR(256)    NULL,               -- 등록자ID
    reg_nm          VARCHAR(256)    NULL,               -- 등록자명
    reg_ip          VARCHAR(256)    NULL,               -- 등록IP
    reg_dt          DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_SITE_INFO PRIMARY KEY (site_info_seq)
);
GO

PRINT '01_system.sql 완료';
GO
