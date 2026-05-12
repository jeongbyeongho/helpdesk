-- =====================================================
-- 05_post.sql : 게시물/답변/파일 관련 테이블
-- =====================================================
USE helpdesk;
GO

-- 게시물 정보
IF OBJECT_ID('TB_POST_INFO', 'U') IS NULL
CREATE TABLE TB_POST_INFO (
    board_id            INT             NOT NULL,           -- 게시판ID
    post_seq            INT             NOT NULL IDENTITY(1,1), -- 게시물순번
    upper_post_seq      INT             NULL,               -- 상위게시물순번
    post_title          VARCHAR(2000)   NULL,               -- 게시물제목
    post_content        VARCHAR(MAX)    NULL,               -- 게시물내용
    reg_id              VARCHAR(256)    NULL,               -- 등록자ID
    reg_nm              VARCHAR(256)    NULL,               -- 등록자명
    reg_ip              VARCHAR(256)    NULL,               -- 등록IP
    reg_dt              DATETIME        NOT NULL DEFAULT GETDATE(),
    read_cnt            INT             NOT NULL DEFAULT 0, -- 조회수
    oppose_cnt          INT             NOT NULL DEFAULT 0, -- 반대수
    approve_cnt         INT             NOT NULL DEFAULT 0, -- 찬성수
    post_status         CHAR(1)         NULL,               -- 게시물상태 (W:대기, R:접수, C:완료, H:보류)
    post_use_yn         CHAR(1)         NULL DEFAULT 'Y',   -- 사용여부
    secret_yn           CHAR(1)         NULL DEFAULT 'N',   -- 비밀글여부
    sms_yn              CHAR(1)         NULL DEFAULT 'N',   -- SMS발송여부
    email_yn            CHAR(1)         NULL DEFAULT 'N',   -- 이메일발송여부
    notice_yn           CHAR(1)         NULL DEFAULT 'N',   -- 공지여부
    notice_begin_dt     DATETIME        NULL,               -- 공지시작일
    notice_end_dt       DATETIME        NULL,               -- 공지종료일
    folder_yn           CHAR(1)         NULL DEFAULT 'N',   -- 폴더여부
    before_post_id      INT             NULL,               -- 이전게시물ID
    approval_yn         CHAR(1)         NULL DEFAULT 'N',   -- 승인여부
    approval_begin_dt   DATETIME        NULL,               -- 승인시작일
    approval_end_dt     DATETIME        NULL,               -- 승인종료일
    approval_user_id    VARCHAR(256)    NULL,               -- 승인자ID
    approval_user_nm    VARCHAR(256)    NULL,               -- 승인자명
    approval_dt         DATETIME        NULL,               -- 승인일시
    status_dt           DATETIME        NULL,               -- 상태변경일시
    -- 추가 컬럼 (게시판별 확장 항목)
    extra_col1          VARCHAR(2000)   NULL,
    extra_col2          VARCHAR(2000)   NULL,
    extra_col3          VARCHAR(2000)   NULL,
    extra_col4          VARCHAR(MAX)    NULL,
    extra_col5          VARCHAR(MAX)    NULL,
    extra_col6          VARCHAR(2000)   NULL,
    extra_col7          VARCHAR(2000)   NULL,
    extra_col8          VARCHAR(2000)   NULL,
    extra_col9          VARCHAR(2000)   NULL,
    extra_col10         VARCHAR(2000)   NULL,
    extra_col11         VARCHAR(2000)   NULL,
    extra_col12         VARCHAR(2000)   NULL,
    extra_col13         VARCHAR(2000)   NULL,
    extra_col14         VARCHAR(2000)   NULL,
    extra_col15         VARCHAR(2000)   NULL,
    extra_col16         VARCHAR(2000)   NULL,
    extra_col17         VARCHAR(2000)   NULL,
    extra_col18         VARCHAR(2000)   NULL,
    extra_col19         VARCHAR(2000)   NULL,
    extra_col20         VARCHAR(2000)   NULL,
    CONSTRAINT PK_TB_POST_INFO PRIMARY KEY (post_seq)
);
GO

-- 게시물 답변
IF OBJECT_ID('TB_POST_REPLY_INFO', 'U') IS NULL
CREATE TABLE TB_POST_REPLY_INFO (
    board_id            INT             NOT NULL,
    post_seq            INT             NOT NULL,
    reply_seq           INT             NOT NULL IDENTITY(1,1),
    upper_reply_seq     INT             NULL,               -- 상위답변순번
    reply_title         VARCHAR(2000)   NULL,               -- 답변제목
    reply_content       VARCHAR(MAX)    NULL,               -- 답변내용
    reply_nm            VARCHAR(2000)   NULL,               -- 답변자명
    work_dt             VARCHAR(256)    NULL,               -- 처리일자
    reg_id              VARCHAR(256)    NULL,               -- 등록자ID
    reg_nm              VARCHAR(256)    NULL,               -- 등록자명
    reg_ip              VARCHAR(256)    NULL,               -- 등록IP
    reg_dt              DATETIME        NOT NULL DEFAULT GETDATE(),
    oppose_cnt          INT             NOT NULL DEFAULT 0,
    approve_cnt         INT             NOT NULL DEFAULT 0,
    reply_status        CHAR(1)         NULL,               -- 답변상태
    reply_use_yn        CHAR(1)         NULL DEFAULT 'Y',
    secret_yn           CHAR(1)         NULL DEFAULT 'N',
    CONSTRAINT PK_TB_POST_REPLY_INFO PRIMARY KEY (reply_seq)
);
GO

-- 게시물 파일
IF OBJECT_ID('TB_POST_FILE_INFO', 'U') IS NULL
CREATE TABLE TB_POST_FILE_INFO (
    board_id            INT             NOT NULL,
    post_seq            INT             NOT NULL,
    file_seq            INT             NOT NULL IDENTITY(1,1),
    file_nm             VARCHAR(512)    NULL,               -- 파일명 (원본)
    file_path           VARCHAR(512)    NULL,               -- 파일경로
    file_size           INT             NOT NULL DEFAULT 0, -- 파일크기
    download_cnt        INT             NOT NULL DEFAULT 0, -- 다운로드수
    download_url        VARCHAR(256)    NULL,               -- 다운로드URL
    file_ext            VARCHAR(10)     NULL,               -- 파일확장자
    thumb_path          VARCHAR(512)    NULL,               -- 썸네일경로
    file_type           VARCHAR(10)     NULL,               -- 파일유형
    CONSTRAINT PK_TB_POST_FILE_INFO PRIMARY KEY (file_seq)
);
GO

-- 게시물 변경 이력
IF OBJECT_ID('TB_POST_HIST', 'U') IS NULL
CREATE TABLE TB_POST_HIST (
    hist_seq            INT             NOT NULL IDENTITY(1,1),
    hist_group_seq      INT             NOT NULL,
    board_id            INT             NOT NULL,
    post_seq            INT             NOT NULL,
    post_title          VARCHAR(2000)   NULL,
    post_content        VARCHAR(MAX)    NULL,
    post_status         CHAR(1)         NULL,
    reg_id              VARCHAR(256)    NULL,
    reg_nm              VARCHAR(256)    NULL,
    hist_user_id        VARCHAR(256)    NULL,
    hist_user_nm        VARCHAR(256)    NULL,
    hist_user_ip        VARCHAR(256)    NULL,
    hist_dt             DATETIME        NOT NULL DEFAULT GETDATE(),
    hist_type           CHAR(1)         NULL,
    CONSTRAINT PK_TB_POST_HIST PRIMARY KEY (hist_seq)
);
GO

-- 답변 변경 이력
IF OBJECT_ID('TB_POST_REPLY_HIST', 'U') IS NULL
CREATE TABLE TB_POST_REPLY_HIST (
    hist_seq            INT             NOT NULL IDENTITY(1,1),
    hist_group_seq      INT             NOT NULL,
    board_id            INT             NOT NULL,
    post_seq            INT             NOT NULL,
    reply_seq           INT             NOT NULL,
    reply_content       VARCHAR(MAX)    NULL,
    reply_status        CHAR(1)         NULL,
    hist_user_id        VARCHAR(256)    NULL,
    hist_user_nm        VARCHAR(256)    NULL,
    hist_user_ip        VARCHAR(256)    NULL,
    hist_dt             DATETIME        NOT NULL DEFAULT GETDATE(),
    hist_type           CHAR(1)         NULL,
    CONSTRAINT PK_TB_POST_REPLY_HIST PRIMARY KEY (hist_seq)
);
GO

-- 파일 변경 이력
IF OBJECT_ID('TB_POST_FILE_HIST', 'U') IS NULL
CREATE TABLE TB_POST_FILE_HIST (
    hist_seq            INT             NOT NULL IDENTITY(1,1),
    hist_group_seq      INT             NOT NULL,
    board_id            INT             NOT NULL,
    post_seq            INT             NOT NULL,
    file_seq            INT             NOT NULL,
    file_nm             VARCHAR(512)    NULL,
    file_path           VARCHAR(512)    NULL,
    file_size           INT             NOT NULL DEFAULT 0,
    hist_user_id        VARCHAR(256)    NULL,
    hist_user_nm        VARCHAR(256)    NULL,
    hist_user_ip        VARCHAR(256)    NULL,
    hist_dt             DATETIME        NOT NULL DEFAULT GETDATE(),
    hist_type           CHAR(1)         NULL,
    CONSTRAINT PK_TB_POST_FILE_HIST PRIMARY KEY (hist_seq)
);
GO

PRINT '05_post.sql 완료';
GO
