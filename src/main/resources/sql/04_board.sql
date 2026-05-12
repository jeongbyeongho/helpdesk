-- =====================================================
-- 04_board.sql : 게시판 관련 테이블
-- =====================================================
USE helpdesk;
GO

-- 게시판 정보
IF OBJECT_ID('TB_BOARD_INFO', 'U') IS NULL
CREATE TABLE TB_BOARD_INFO (
    board_id            INT             NOT NULL IDENTITY(1,1),
    sys_id              VARCHAR(20)     NULL,               -- 시스템ID
    board_type          VARCHAR(20)     NULL,               -- 게시판유형
    board_purpose       VARCHAR(20)     NULL,               -- 게시판용도
    board_title         VARCHAR(256)    NULL,               -- 게시판제목
    board_desc          VARCHAR(2000)   NULL,               -- 게시판설명
    reply_type          CHAR(1)         NULL,               -- 답변유형
    menu_path           VARCHAR(2000)   NULL,               -- 메뉴경로
    menu_id             INT             NULL,               -- 메뉴ID
    page_post_cnt       INT             NOT NULL DEFAULT 10,-- 페이지당게시물수
    col_nm_no           VARCHAR(200)    NULL,               -- 번호컬럼명
    col_nm_content      VARCHAR(200)    NULL,               -- 내용컬럼명
    col_nm_reg_nm       VARCHAR(200)    NULL,               -- 등록자컬럼명
    col_nm_reg_dt       VARCHAR(200)    NULL,               -- 등록일컬럼명
    secret_use_yn       CHAR(1)         NULL DEFAULT 'N',   -- 비밀글사용여부
    file_max_cnt        INT             NOT NULL DEFAULT 0, -- 파일최대개수
    editor_use_yn       CHAR(1)         NULL DEFAULT 'N',   -- 에디터사용여부
    status_use_yn       CHAR(1)         NULL DEFAULT 'N',   -- 상태사용여부
    new_post_notice_hr  INT             NOT NULL DEFAULT 24,-- 신규게시물알림시간
    list_file_download_yn CHAR(1)       NULL DEFAULT 'N',   -- 목록파일다운여부
    file_limit_size     INT             NOT NULL DEFAULT 0, -- 파일제한크기
    approval_use_yn     CHAR(1)         NULL DEFAULT 'N',   -- 승인사용여부
    satisfaction_use_yn CHAR(1)         NULL DEFAULT 'N',   -- 만족도사용여부
    sms_use_yn          CHAR(1)         NULL DEFAULT 'N',   -- SMS사용여부
    email_use_yn        CHAR(1)         NULL DEFAULT 'N',   -- 이메일사용여부
    owner_list_use_yn   CHAR(1)         NULL DEFAULT 'N',   -- 담당자목록사용여부
    post_content_required_yn CHAR(1)    NULL DEFAULT 'N',   -- 게시물내용필수여부
    notice_yn           CHAR(1)         NULL DEFAULT 'N',   -- 공지사용여부
    reply_yn            CHAR(1)         NULL DEFAULT 'N',   -- 댓글사용여부
    copy_yn             CHAR(1)         NULL DEFAULT 'N',   -- 복사사용여부
    preface_use_yn      CHAR(1)         NULL DEFAULT 'N',   -- 머리말사용여부
    preface_content     VARCHAR(2000)   NULL,               -- 머리말내용
    anonymous_use_yn    CHAR(1)         NULL DEFAULT 'N',   -- 익명사용여부
    folder_use_yn       CHAR(1)         NULL DEFAULT 'N',   -- 폴더사용여부
    allowed_ext         VARCHAR(2000)   NULL,               -- 허용확장자
    reg_period_use_yn   CHAR(1)         NULL DEFAULT 'N',   -- 등록기간사용여부
    reg_begin_dt        DATETIME        NULL,               -- 등록시작일
    reg_end_dt          DATETIME        NULL,               -- 등록종료일
    board_use_yn        CHAR(1)         NULL DEFAULT 'Y',   -- 게시판사용여부
    reg_id              VARCHAR(256)    NULL,               -- 등록자ID
    reg_nm              VARCHAR(256)    NULL,               -- 등록자명
    reg_ip              VARCHAR(256)    NULL,               -- 등록IP
    reg_dt              DATETIME        NULL DEFAULT GETDATE(),
    CONSTRAINT PK_TB_BOARD_INFO PRIMARY KEY (board_id)
);
GO

-- 게시판 권한 설정
IF OBJECT_ID('TB_BOARD_ROLE_CFG', 'U') IS NULL
CREATE TABLE TB_BOARD_ROLE_CFG (
    board_id            INT             NOT NULL,
    manage_role         VARCHAR(1000)   NULL,               -- 관리권한
    update_role         VARCHAR(1000)   NULL,               -- 수정권한
    delete_role         VARCHAR(1000)   NULL,               -- 삭제권한
    read_role           VARCHAR(1000)   NULL,               -- 읽기권한
    read_msg            VARCHAR(200)    NULL,               -- 읽기제한메시지
    write_role          VARCHAR(1000)   NULL,               -- 쓰기권한
    write_msg           VARCHAR(200)    NULL,               -- 쓰기제한메시지
    secret_role         VARCHAR(1000)   NULL,               -- 비밀글권한
    secret_msg          VARCHAR(200)    NULL,               -- 비밀글제한메시지
    reply_role          VARCHAR(1000)   NULL,               -- 답변권한
    reply_msg           VARCHAR(200)    NULL,               -- 답변제한메시지
    print_role          VARCHAR(1000)   NULL,               -- 인쇄권한
    write_btn_show_yn   CHAR(1)         NULL,               -- 쓰기버튼표시여부
    reply_btn_show_yn   CHAR(1)         NULL,               -- 답변버튼표시여부
    CONSTRAINT PK_TB_BOARD_ROLE_CFG PRIMARY KEY (board_id)
);
GO

-- 게시판 추가 항목
IF OBJECT_ID('TB_BOARD_FIELD_INFO', 'U') IS NULL
CREATE TABLE TB_BOARD_FIELD_INFO (
    field_seq           INT             NOT NULL IDENTITY(1,1),
    board_id            INT             NOT NULL,           -- 게시판ID
    field_nm            VARCHAR(200)    NULL,               -- 항목명
    field_type          VARCHAR(20)     NULL,               -- 항목유형 (DEFAULT:기본, 기타:확장)
    field_value         VARCHAR(1000)   NULL,               -- 항목값
    field_order         INT             NOT NULL DEFAULT 0, -- 항목순서
    list_use_yn         CHAR(1)         NULL,               -- 목록표시여부
    list_width          INT             NOT NULL DEFAULT 0, -- 목록너비
    required_yn         CHAR(1)         NULL,               -- 필수여부
    view_use_yn         CHAR(1)         NULL,               -- 상세표시여부
    category_use_yn     CHAR(1)         NULL,               -- 카테고리사용여부
    col_nm              VARCHAR(100)    NULL,               -- 컬럼명
    CONSTRAINT PK_TB_BOARD_FIELD_INFO PRIMARY KEY (field_seq)
);
GO

-- 게시판 변경 이력
IF OBJECT_ID('TB_BOARD_HIST', 'U') IS NULL
CREATE TABLE TB_BOARD_HIST (
    hist_seq            INT             NOT NULL IDENTITY(1,1),
    hist_group_seq      INT             NOT NULL,
    board_id            INT             NOT NULL,
    sys_id              VARCHAR(20)     NULL,
    board_type          VARCHAR(20)     NULL,
    board_title         VARCHAR(256)    NULL,
    board_use_yn        CHAR(1)         NULL,
    hist_user_id        VARCHAR(256)    NULL,
    hist_user_nm        VARCHAR(256)    NULL,
    hist_user_ip        VARCHAR(256)    NULL,
    hist_dt             DATETIME        NOT NULL DEFAULT GETDATE(),
    hist_type           CHAR(1)         NULL,               -- I:등록, U:수정, D:삭제
    CONSTRAINT PK_TB_BOARD_HIST PRIMARY KEY (hist_seq)
);
GO

-- 메인 게시판 설정
IF OBJECT_ID('TB_MAIN_BOARD_CFG', 'U') IS NULL
CREATE TABLE TB_MAIN_BOARD_CFG (
    sys_id              VARCHAR(20)     NULL,               -- 시스템ID
    board_id            VARCHAR(100)    NULL,               -- 게시판ID
    board_title         VARCHAR(256)    NULL,               -- 게시판제목
    board_type          VARCHAR(20)     NULL,               -- 게시판유형
    print_post_cnt      INT             NOT NULL DEFAULT 5, -- 출력게시물수
    menu_id             INT             NULL,               -- 메뉴ID
    sort_order          INT             NOT NULL DEFAULT 0, -- 정렬순서
    extra_data1         VARCHAR(256)    NULL                -- 추가데이터1
);
GO

PRINT '04_board.sql 완료';
GO
