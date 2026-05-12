-- =====================================================
-- 03_role_menu.sql : 권한/메뉴/접근제어 관련 테이블
-- =====================================================
USE helpdesk;
GO

-- 권한 정보
IF OBJECT_ID('TB_ROLE_INFO', 'U') IS NULL
CREATE TABLE TB_ROLE_INFO (
    role_seq        INT             NOT NULL IDENTITY(1,1),
    role_code       INT             NOT NULL,           -- 권한코드
    role_nm         VARCHAR(128)    NULL,               -- 권한명
    sys_id          VARCHAR(128)    NULL,               -- 시스템ID
    CONSTRAINT PK_TB_ROLE_INFO PRIMARY KEY (role_seq)
);
GO

-- 사용자 권한 매핑
IF OBJECT_ID('TB_USER_ROLE_MAP', 'U') IS NULL
CREATE TABLE TB_USER_ROLE_MAP (
    user_role_seq   INT             NOT NULL IDENTITY(1,1),
    user_id         VARCHAR(256)    NULL,               -- 사용자ID
    role_code       INT             NULL,               -- 권한코드
    sys_id          VARCHAR(128)    NULL,               -- 시스템ID
    CONSTRAINT PK_TB_USER_ROLE_MAP PRIMARY KEY (user_role_seq)
);
GO

-- 권한 변경 이력
IF OBJECT_ID('TB_ROLE_HIST', 'U') IS NULL
CREATE TABLE TB_ROLE_HIST (
    hist_seq        INT             NOT NULL IDENTITY(1,1),
    hist_group_seq  INT             NULL,               -- 이력그룹순번
    user_id         VARCHAR(256)    NULL,               -- 사용자ID
    role_code       INT             NULL,               -- 권한코드
    sys_id          VARCHAR(20)     NULL,               -- 시스템ID
    hist_user_id    VARCHAR(256)    NULL,               -- 처리자ID
    hist_user_nm    VARCHAR(256)    NULL,               -- 처리자명
    hist_user_ip    VARCHAR(256)    NULL,               -- 처리IP
    hist_dt         DATETIME        NULL,               -- 처리일시
    hist_type       CHAR(1)         NULL,               -- 이력유형
    CONSTRAINT PK_TB_ROLE_HIST PRIMARY KEY (hist_seq)
);
GO

-- 그룹 정보
IF OBJECT_ID('TB_GROUP_INFO', 'U') IS NULL
CREATE TABLE TB_GROUP_INFO (
    group_seq       INT             NOT NULL IDENTITY(1,1),
    sys_id          VARCHAR(20)     NULL,               -- 시스템ID
    group_template  VARCHAR(32)     NULL,               -- 그룹템플릿
    group_title     VARCHAR(128)    NULL,               -- 그룹제목
    group_subtitle  VARCHAR(256)    NULL,               -- 그룹부제목
    group_content   VARCHAR(1000)   NULL,               -- 그룹내용
    group_sign      VARCHAR(256)    NULL,               -- 서명
    group_position  VARCHAR(256)    NULL,               -- 직위
    file_id         VARCHAR(20)     NULL,               -- 파일ID
    reg_id          VARCHAR(256)    NULL,               -- 등록자ID
    reg_nm          VARCHAR(256)    NULL,               -- 등록자명
    reg_ip          VARCHAR(256)    NULL,               -- 등록IP
    reg_dt          DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_GROUP_INFO PRIMARY KEY (group_seq)
);
GO

-- 그룹 권한 매핑
IF OBJECT_ID('TB_GROUP_ROLE_MAP', 'U') IS NULL
CREATE TABLE TB_GROUP_ROLE_MAP (
    group_role_seq  INT             NOT NULL IDENTITY(1,1),
    group_code      INT             NOT NULL,           -- 그룹코드
    role_code       INT             NULL,               -- 권한코드
    sys_id          VARCHAR(128)    NULL,               -- 시스템ID
    CONSTRAINT PK_TB_GROUP_ROLE_MAP PRIMARY KEY (group_role_seq)
);
GO

-- 메뉴 정보
IF OBJECT_ID('TB_MENU_INFO', 'U') IS NULL
CREATE TABLE TB_MENU_INFO (
    menu_id         INT             NOT NULL IDENTITY(1,1),
    sys_id          VARCHAR(20)     NULL,               -- 시스템ID
    sys_nm          VARCHAR(100)    NULL,               -- 시스템명
    upper_menu_id   INT             NULL,               -- 상위메뉴ID
    upper_menu_nm   VARCHAR(100)    NULL,               -- 상위메뉴명
    menu_nm         VARCHAR(100)    NULL,               -- 메뉴명
    menu_level      CHAR(1)         NULL,               -- 메뉴레벨
    menu_type       VARCHAR(20)     NULL,               -- 메뉴유형
    content_id      INT             NULL,               -- 콘텐츠ID
    menu_link       VARCHAR(400)    NULL,               -- 메뉴링크
    menu_url        VARCHAR(400)    NULL,               -- 메뉴URL
    connect_menu_id INT             NULL,               -- 연결메뉴ID
    use_yn          CHAR(1)         NULL DEFAULT 'Y',   -- 사용여부
    connect_yn      CHAR(1)         NULL,               -- 연결여부
    connect_role    VARCHAR(1000)   NULL,               -- 연결권한
    sort_order      INT             NULL,               -- 정렬순서
    new_window_yn   CHAR(1)         NULL DEFAULT 'N',   -- 새창여부
    content_yn      CHAR(1)         NULL,               -- 콘텐츠여부
    right_click_yn  CHAR(1)         NULL,               -- 우클릭여부
    sub_right_click_yn CHAR(1)      NULL,               -- 하위우클릭여부
    folder_yn       CHAR(1)         NULL,               -- 폴더여부
    tab_yn          CHAR(1)         NULL,               -- 탭여부
    expand_yn       CHAR(1)         NULL,               -- 확장여부
    CONSTRAINT PK_TB_MENU_INFO PRIMARY KEY (menu_id)
);
GO

-- 메뉴 권한 매핑
IF OBJECT_ID('TB_MENU_ROLE_MAP', 'U') IS NULL
CREATE TABLE TB_MENU_ROLE_MAP (
    menu_id         INT             NOT NULL,           -- 메뉴ID
    role_no         INT             NOT NULL,           -- 권한번호
    role_type       CHAR(1)         NULL,               -- 권한유형 (A:허용, D:거부)
    menu_type       VARCHAR(20)     NULL,               -- 메뉴유형
    content_id      INT             NULL,               -- 콘텐츠ID
    CONSTRAINT PK_TB_MENU_ROLE_MAP PRIMARY KEY (menu_id, role_no)
);
GO

-- 메뉴 변경 이력
IF OBJECT_ID('TB_MENU_HIST', 'U') IS NULL
CREATE TABLE TB_MENU_HIST (
    hist_seq        INT             NOT NULL IDENTITY(1,1),
    hist_group_seq  INT             NOT NULL,
    menu_id         INT             NULL,
    sys_id          VARCHAR(20)     NULL,
    menu_nm         VARCHAR(100)    NULL,
    menu_level      CHAR(1)         NULL,
    menu_type       VARCHAR(20)     NULL,
    menu_url        VARCHAR(400)    NULL,
    use_yn          CHAR(1)         NULL,
    sort_order      INT             NULL,
    hist_user_id    VARCHAR(256)    NULL,
    hist_user_nm    VARCHAR(256)    NULL,
    hist_user_ip    VARCHAR(256)    NULL,
    hist_dt         DATETIME        NOT NULL DEFAULT GETDATE(),
    hist_type       CHAR(1)         NULL,               -- I:등록, U:수정, D:삭제, R:복구
    CONSTRAINT PK_TB_MENU_HIST PRIMARY KEY (hist_seq)
);
GO

-- 접근제어 정보
IF OBJECT_ID('TB_ACCESS_CTL_INFO', 'U') IS NULL
CREATE TABLE TB_ACCESS_CTL_INFO (
    access_no       INT             NOT NULL IDENTITY(1,1),
    access_target   VARCHAR(256)    NULL,               -- 접근대상
    access_target_pos VARCHAR(256)  NULL,               -- 접근대상위치
    allow_ip        VARCHAR(256)    NULL,               -- 허용IP
    block_ip        VARCHAR(256)    NULL,               -- 차단IP
    mac_addr        VARCHAR(256)    NULL,               -- MAC주소
    ip_scope        VARCHAR(256)    NULL,               -- IP범위
    user_id         VARCHAR(256)    NULL,               -- 사용자ID
    approval_yn     CHAR(1)         NULL,               -- 승인여부
    approval_id     VARCHAR(256)    NULL,               -- 승인자ID
    approval_ip     VARCHAR(256)    NULL,               -- 승인IP
    approval_dt     DATETIME        NULL,               -- 승인일시
    band_ip_use_yn  CHAR(1)         NULL,               -- 대역IP사용여부
    reg_id          VARCHAR(256)    NULL,               -- 등록자ID
    reg_ip          VARCHAR(256)    NULL,               -- 등록IP
    reg_dt          DATETIME        NOT NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_ACCESS_CTL_INFO PRIMARY KEY (access_no)
);
GO

PRINT '03_role_menu.sql 완료';
GO
