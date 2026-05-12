-- =====================================================
-- 06_popup_code_stats.sql : 팝업/공통코드/통계/파일 테이블
-- =====================================================
USE helpdesk;
GO

-- 팝업 정보
IF OBJECT_ID('TB_POPUP_INFO', 'U') IS NULL
CREATE TABLE TB_POPUP_INFO (
    popup_seq           INT             NOT NULL IDENTITY(1,1),
    popup_title         VARCHAR(200)    NULL,               -- 팝업제목
    popup_type          CHAR(1)         NULL,               -- 팝업유형
    display_type        CHAR(1)         NULL,               -- 표시유형
    image_path          VARCHAR(400)    NULL,               -- 이미지경로
    image_nm            VARCHAR(400)    NULL,               -- 이미지명
    popup_width         INT             NULL,               -- 팝업너비
    popup_height        INT             NULL,               -- 팝업높이
    pos_left            INT             NULL,               -- 좌측위치
    pos_top             INT             NULL,               -- 상단위치
    link_url            VARCHAR(256)    NULL,               -- 링크URL
    new_window_yn       CHAR(1)         NULL DEFAULT 'N',   -- 새창여부
    popup_template      VARCHAR(20)     NULL,               -- 팝업템플릿
    close_btn_yn        CHAR(1)         NULL DEFAULT 'Y',   -- 닫기버튼여부
    file_id             VARCHAR(20)     NULL,               -- 첨부파일ID
    image_id            VARCHAR(20)     NULL,               -- 이미지ID
    popup_content       VARCHAR(4000)   NULL,               -- 팝업내용
    all_yn              CHAR(1)         NULL DEFAULT 'N',   -- 전체표시여부
    hide_yn             CHAR(1)         NULL DEFAULT 'N',   -- 숨김여부
    CONSTRAINT PK_TB_POPUP_INFO PRIMARY KEY (popup_seq)
);
GO

-- 팝업 시스템 매핑
IF OBJECT_ID('TB_POPUP_SYS_MAP', 'U') IS NULL
CREATE TABLE TB_POPUP_SYS_MAP (
    popup_sys_seq       INT             NOT NULL IDENTITY(1,1),
    popup_seq           INT             NOT NULL,           -- 팝업순번
    sys_id              VARCHAR(20)     NULL,               -- 시스템ID
    sys_nm              VARCHAR(100)    NULL,               -- 시스템명
    begin_dt            DATETIME        NULL,               -- 시작일
    end_dt              DATETIME        NULL,               -- 종료일
    begin_time          VARCHAR(64)     NULL,               -- 시작시간
    end_time            VARCHAR(64)     NULL,               -- 종료시간
    use_yn              CHAR(1)         NULL DEFAULT 'Y',   -- 사용여부
    sort_order          INT             NULL,               -- 정렬순서
    CONSTRAINT PK_TB_POPUP_SYS_MAP PRIMARY KEY (popup_sys_seq)
);
GO

-- 팝업 변경 이력
IF OBJECT_ID('TB_POPUP_HIST', 'U') IS NULL
CREATE TABLE TB_POPUP_HIST (
    hist_seq            INT             NOT NULL IDENTITY(1,1),
    hist_group_seq      INT             NOT NULL,
    popup_seq           INT             NOT NULL,
    hist_user_id        VARCHAR(256)    NULL,
    hist_user_nm        VARCHAR(256)    NULL,
    hist_user_ip        VARCHAR(256)    NULL,
    hist_dt             DATETIME        NOT NULL DEFAULT GETDATE(),
    hist_type           CHAR(1)         NULL,
    CONSTRAINT PK_TB_POPUP_HIST PRIMARY KEY (hist_seq)
);
GO

-- 팝업 호출 로그
IF OBJECT_ID('TB_POPUP_CALL_LOG', 'U') IS NULL
CREATE TABLE TB_POPUP_CALL_LOG (
    sys_id              VARCHAR(128)    NOT NULL,
    reg_id              VARCHAR(256)    NULL,
    reg_nm              VARCHAR(256)    NULL,
    reg_ip              VARCHAR(256)    NULL,
    reg_dt              DATETIME        NOT NULL DEFAULT GETDATE()
);
GO

-- 공통코드 그룹
IF OBJECT_ID('TB_CODE_GROUP_INFO', 'U') IS NULL
CREATE TABLE TB_CODE_GROUP_INFO (
    code_group          VARCHAR(128)    NOT NULL,           -- 코드그룹
    code_group_nm       VARCHAR(256)    NULL,               -- 코드그룹명
    code_group_desc     VARCHAR(1000)   NULL,               -- 코드그룹설명
    use_yn              CHAR(1)         NULL DEFAULT 'Y',   -- 사용여부
    CONSTRAINT PK_TB_CODE_GROUP_INFO PRIMARY KEY (code_group)
);
GO

-- 공통코드 상세
IF OBJECT_ID('TB_CODE_DETAIL_INFO', 'U') IS NULL
CREATE TABLE TB_CODE_DETAIL_INFO (
    code_group          VARCHAR(128)    NULL,               -- 코드그룹
    code_value          VARCHAR(128)    NULL,               -- 코드값
    code_nm             VARCHAR(256)    NULL,               -- 코드명
    code_desc           VARCHAR(1000)   NULL,               -- 코드설명
    use_yn              CHAR(1)         NULL DEFAULT 'Y',   -- 사용여부
    sort_order          INT             NULL                 -- 정렬순서
);
GO

-- 사용자 접속 로그
IF OBJECT_ID('TB_USER_ACCESS_LOG', 'U') IS NULL
CREATE TABLE TB_USER_ACCESS_LOG (
    access_seq          INT             NOT NULL IDENTITY(1,1),
    user_id             VARCHAR(256)    NULL,               -- 사용자ID
    user_nm             VARCHAR(256)    NULL,               -- 사용자명
    connect_type        VARCHAR(128)    NULL,               -- 접속유형
    org_code            VARCHAR(128)    NULL,               -- 기관코드
    org_nm              VARCHAR(128)    NULL,               -- 기관명
    public_ip           VARCHAR(256)    NULL,               -- 공인IP
    private_ip          VARCHAR(256)    NULL,               -- 사설IP
    mac_addr            VARCHAR(256)    NULL,               -- MAC주소
    connect_dt          DATETIME        NULL,               -- 접속일시
    connect_action      VARCHAR(128)    NULL,               -- 접속행위
    connect_url         VARCHAR(400)    NULL,               -- 접속URL
    browser             VARCHAR(16)     NULL,               -- 브라우저
    terminal            VARCHAR(16)     NULL,               -- 단말기
    browser_ver         VARCHAR(16)     NULL,               -- 브라우저버전
    os                  VARCHAR(16)     NULL,               -- OS
    os_ver              VARCHAR(16)     NULL,               -- OS버전
    session_id          VARCHAR(128)    NULL,               -- 세션ID
    CONSTRAINT PK_TB_USER_ACCESS_LOG PRIMARY KEY (access_seq)
);
GO

-- 관리자 접속 로그
IF OBJECT_ID('TB_ADMIN_ACCESS_LOG', 'U') IS NULL
CREATE TABLE TB_ADMIN_ACCESS_LOG (
    access_seq          INT             NOT NULL IDENTITY(1,1),
    user_id             VARCHAR(256)    NULL,
    user_nm             VARCHAR(256)    NULL,
    org_code            VARCHAR(128)    NULL,
    org_nm              VARCHAR(128)    NULL,
    public_ip           VARCHAR(256)    NULL,
    private_ip          VARCHAR(256)    NULL,
    mac_addr            VARCHAR(256)    NULL,
    connect_dt          DATETIME        NULL,
    connect_yn          CHAR(1)         NULL,               -- 접속성공여부
    browser             VARCHAR(16)     NULL,
    terminal            VARCHAR(16)     NULL,
    browser_ver         VARCHAR(16)     NULL,
    os                  VARCHAR(16)     NULL,
    os_ver              VARCHAR(16)     NULL,
    session_id          VARCHAR(128)    NULL,
    CONSTRAINT PK_TB_ADMIN_ACCESS_LOG PRIMARY KEY (access_seq)
);
GO

-- 메뉴 통계
IF OBJECT_ID('TB_MENU_STATS_LOG', 'U') IS NULL
CREATE TABLE TB_MENU_STATS_LOG (
    stats_seq           INT             NOT NULL IDENTITY(1,1),
    menu_dt             DATETIME        NULL,               -- 통계일자
    menu_id             INT             NOT NULL,           -- 메뉴ID
    sys_id              VARCHAR(20)     NULL,               -- 시스템ID
    CONSTRAINT PK_TB_MENU_STATS_LOG PRIMARY KEY (stats_seq)
);
GO

-- 방문 통계
IF OBJECT_ID('TB_VISIT_STATS_LOG', 'U') IS NULL
CREATE TABLE TB_VISIT_STATS_LOG (
    visit_seq           INT             NOT NULL IDENTITY(1,1),
    visit_dt            DATETIME        NULL,               -- 방문일자
    sys_id              VARCHAR(20)     NULL,               -- 시스템ID
    visit_ip            VARCHAR(64)     NULL,               -- 방문IP
    browser             VARCHAR(16)     NULL,
    os                  VARCHAR(16)     NULL,
    browser_ver         VARCHAR(16)     NULL,
    os_ver              VARCHAR(16)     NULL,
    terminal            VARCHAR(16)     NULL,
    connect_url         VARCHAR(400)    NULL,               -- 접속URL
    refer_url           VARCHAR(400)    NULL,               -- 유입URL
    session_id          VARCHAR(128)    NULL,
    CONSTRAINT PK_TB_VISIT_STATS_LOG PRIMARY KEY (visit_seq)
);
GO

-- 첨부파일 그룹
IF OBJECT_ID('TB_FILE_GROUP_INFO', 'U') IS NULL
CREATE TABLE TB_FILE_GROUP_INFO (
    file_id             VARCHAR(20)     NOT NULL,           -- 파일그룹ID
    reg_dt              DATETIME        NULL DEFAULT GETDATE(),
    use_yn              VARCHAR(1)      NULL DEFAULT 'Y',
    CONSTRAINT PK_TB_FILE_GROUP_INFO PRIMARY KEY (file_id)
);
GO

-- 첨부파일 상세
IF OBJECT_ID('TB_FILE_DETAIL_INFO', 'U') IS NULL
CREATE TABLE TB_FILE_DETAIL_INFO (
    file_id             VARCHAR(20)     NULL,               -- 파일그룹ID
    file_seq            INT             NOT NULL IDENTITY(1,1),
    file_store_path     VARCHAR(1000)   NULL,               -- 저장경로
    stored_file_nm      VARCHAR(500)    NULL,               -- 저장파일명
    origin_file_nm      VARCHAR(500)    NULL,               -- 원본파일명
    file_ext            VARCHAR(20)     NULL,               -- 파일확장자
    file_size           INT             NULL,               -- 파일크기
    file_desc           VARCHAR(4000)   NULL,               -- 파일설명
    use_yn              VARCHAR(1)      NULL DEFAULT 'Y',
    reg_dt              DATETIME        NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_FILE_DETAIL_INFO PRIMARY KEY (file_seq)
);
GO

PRINT '06_popup_code_stats.sql 완료';
GO
