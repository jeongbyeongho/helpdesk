-- =====================================================
-- 00_init_data.sql : 초기 데이터 입력
-- =====================================================
USE helpdesk;
GO

-- 1. 시스템 정보
IF NOT EXISTS (SELECT 1 FROM TB_SYS_INFO WHERE sys_id = 'helpdesk')
BEGIN
    INSERT INTO TB_SYS_INFO (sys_id, sys_nm, sys_type, sys_status, reg_dt)
    VALUES ('helpdesk', 'IT 서비스데스크', 'HELPDESK', 'O', GETDATE());
    PRINT '시스템 정보 등록 완료';
END
GO

-- 2. 권한 정보
IF NOT EXISTS (SELECT 1 FROM TB_ROLE_INFO WHERE role_code = 1)
BEGIN
    INSERT INTO TB_ROLE_INFO (role_code, role_nm, sys_id) VALUES (1, '시스템관리자', 'helpdesk');
    INSERT INTO TB_ROLE_INFO (role_code, role_nm, sys_id) VALUES (2, '관리자', 'helpdesk');
    INSERT INTO TB_ROLE_INFO (role_code, role_nm, sys_id) VALUES (3, '일반사용자', 'helpdesk');
    PRINT '권한 정보 등록 완료';
END
GO

-- 3. 관리자 계정 (ID: admin, PW: admin1234)
-- 비밀번호는 SHA-256 해시값
IF NOT EXISTS (SELECT 1 FROM TB_USER_INFO WHERE user_id = 'admin')
BEGIN
    INSERT INTO TB_USER_INFO (user_id, user_nm, user_pwd, email, mobile_no, reg_dt, reg_ip)
    VALUES ('admin', '시스템관리자', 
            'ac9689e2272427085e35b9d3e3e8bed88cb3434828b43b86fc0596cad4c6e270', -- admin1234
            'admin@helpdesk.com', '010-0000-0000', GETDATE(), '127.0.0.1');
    PRINT '관리자 계정 등록 완료';
END
ELSE
BEGIN
    -- 이미 존재하면 비밀번호만 업데이트
    UPDATE TB_USER_INFO 
    SET user_pwd = 'ac9689e2272427085e35b9d3e3e8bed88cb3434828b43b86fc0596cad4c6e270'
    WHERE user_id = 'admin';
    PRINT '관리자 비밀번호 업데이트 완료';
END
GO

-- 4. 관리자 권한 부여
IF NOT EXISTS (SELECT 1 FROM TB_USER_ROLE_MAP WHERE user_id = 'admin')
BEGIN
    INSERT INTO TB_USER_ROLE_MAP (user_id, role_code, sys_id)
    VALUES ('admin', 1, 'helpdesk');
    PRINT '관리자 권한 부여 완료';
END
GO

-- 5. 테스트 사용자 계정 (ID: user01, PW: user1234)
IF NOT EXISTS (SELECT 1 FROM TB_USER_INFO WHERE user_id = 'user01')
BEGIN
    INSERT INTO TB_USER_INFO (user_id, user_nm, user_pwd, email, mobile_no, reg_dt, reg_ip)
    VALUES ('user01', '테스트사용자', 
            '831c237928e6212bedaa4451a514ace3174562f6761f6a157a2fe5082b36e2fb', -- user1234
            'user01@helpdesk.com', '010-1111-1111', GETDATE(), '127.0.0.1');
    PRINT '테스트 사용자 등록 완료';
END
ELSE
BEGIN
    -- 이미 존재하면 비밀번호만 업데이트
    UPDATE TB_USER_INFO 
    SET user_pwd = '831c237928e6212bedaa4451a514ace3174562f6761f6a157a2fe5082b36e2fb'
    WHERE user_id = 'user01';
    PRINT '테스트 사용자 비밀번호 업데이트 완료';
END
GO

-- 6. 테스트 사용자 권한 부여
IF NOT EXISTS (SELECT 1 FROM TB_USER_ROLE_MAP WHERE user_id = 'user01')
BEGIN
    INSERT INTO TB_USER_ROLE_MAP (user_id, role_code, sys_id)
    VALUES ('user01', 3, 'helpdesk');
    PRINT '테스트 사용자 권한 부여 완료';
END
GO

-- 7. 게시판 생성 (문의게시판)
IF NOT EXISTS (SELECT 1 FROM TB_BOARD_INFO WHERE board_id = 1)
BEGIN
    SET IDENTITY_INSERT TB_BOARD_INFO ON;
    
    INSERT INTO TB_BOARD_INFO (
        board_id, sys_id, board_type, board_title, board_desc,
        reply_type, page_post_cnt, secret_use_yn, file_max_cnt,
        editor_use_yn, status_use_yn, reply_yn, board_use_yn,
        allowed_ext, reg_id, reg_nm, reg_ip, reg_dt
    ) VALUES (
        1, 'helpdesk', 'QNA', 'IT 문의게시판', 'IT 관련 문의사항을 등록하는 게시판입니다.',
        'N', 10, 'Y', 5,
        'Y', 'Y', 'Y', 'Y',
        'jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,zip', 'admin', '시스템관리자', '127.0.0.1', GETDATE()
    );
    
    SET IDENTITY_INSERT TB_BOARD_INFO OFF;
    PRINT '문의게시판 등록 완료';
END
GO

-- 8. 게시판 권한 설정
IF NOT EXISTS (SELECT 1 FROM TB_BOARD_ROLE_CFG WHERE board_id = 1)
BEGIN
    INSERT INTO TB_BOARD_ROLE_CFG (
        board_id, manage_role, update_role, delete_role,
        read_role, write_role, secret_role, reply_role, print_role,
        write_btn_show_yn, reply_btn_show_yn
    ) VALUES (
        1, '1,2', '1,2', '1,2',
        '1,2,3', '1,2,3', '1,2,3', '1,2', '1,2,3',
        'Y', 'Y'
    );
    PRINT '게시판 권한 설정 완료';
END
GO

-- 9. FAQ 게시판 생성
IF NOT EXISTS (SELECT 1 FROM TB_BOARD_INFO WHERE board_id = 2)
BEGIN
    SET IDENTITY_INSERT TB_BOARD_INFO ON;
    
    INSERT INTO TB_BOARD_INFO (
        board_id, sys_id, board_type, board_title, board_desc,
        reply_type, page_post_cnt, secret_use_yn, file_max_cnt,
        editor_use_yn, status_use_yn, reply_yn, board_use_yn,
        allowed_ext, reg_id, reg_nm, reg_ip, reg_dt
    ) VALUES (
        2, 'helpdesk', 'FAQ', 'FAQ', '자주 묻는 질문 게시판입니다.',
        'N', 10, 'N', 3,
        'Y', 'N', 'N', 'Y',
        'jpg,jpeg,png,gif,pdf', 'admin', '시스템관리자', '127.0.0.1', GETDATE()
    );
    
    SET IDENTITY_INSERT TB_BOARD_INFO OFF;
    PRINT 'FAQ 게시판 등록 완료';
END
GO

-- 10. FAQ 게시판 권한 설정
IF NOT EXISTS (SELECT 1 FROM TB_BOARD_ROLE_CFG WHERE board_id = 2)
BEGIN
    INSERT INTO TB_BOARD_ROLE_CFG (
        board_id, manage_role, update_role, delete_role,
        read_role, write_role, secret_role, reply_role, print_role,
        write_btn_show_yn, reply_btn_show_yn
    ) VALUES (
        2, '1,2', '1,2', '1,2',
        '1,2,3', '1,2', '1,2', '1,2', '1,2,3',
        'Y', 'N'
    );
    PRINT 'FAQ 게시판 권한 설정 완료';
END
GO

PRINT '===========================================';
PRINT '초기 데이터 입력 완료!';
PRINT '===========================================';
PRINT '관리자 계정: admin / admin1234';
PRINT '테스트 계정: user01 / user1234';
PRINT '===========================================';
GO
-- 11. 테스트 게시물 데이터 추가
IF NOT EXISTS (SELECT 1 FROM TB_POST_INFO WHERE board_id = 1)
BEGIN
    INSERT INTO TB_POST_INFO (
        board_id, post_title, post_content, reg_id, reg_nm, reg_ip, reg_dt,
        post_status, post_use_yn, secret_yn, notice_yn, read_cnt
    ) VALUES 
    (1, '컴퓨터가 부팅되지 않습니다', '어제부터 컴퓨터를 켜도 검은 화면만 나오고 부팅이 되지 않습니다. 전원은 들어오는 것 같은데 모니터에 아무것도 표시되지 않습니다.', 'user01', '테스트사용자', '192.168.1.100', GETDATE(), 'W', 'Y', 'N', 'N', 0),
    (1, '프린터 연결 문제', '새로 설치한 프린터가 네트워크에 연결되지 않습니다. 드라이버는 설치했는데 인쇄가 되지 않습니다.', 'user01', '테스트사용자', '192.168.1.100', GETDATE(), 'R', 'Y', 'N', 'N', 5),
    (1, '이메일 계정 설정 요청', '새로운 직원 이메일 계정 설정을 요청드립니다. 부서: 개발팀, 이름: 김개발', 'user01', '테스트사용자', '192.168.1.100', GETDATE(), 'P', 'Y', 'N', 'N', 2),
    (1, 'VPN 접속 불가', '재택근무를 위해 VPN 접속을 시도하는데 연결이 되지 않습니다. 인증서 문제인 것 같습니다.', 'user01', '테스트사용자', '192.168.1.100', GETDATE(), 'C', 'Y', 'N', 'N', 8),
    (2, '자주 묻는 질문 - 비밀번호 변경 방법', '비밀번호 변경은 로그인 후 우상단 메뉴에서 "내 정보" 클릭 후 비밀번호 변경 탭에서 진행하시면 됩니다.', 'admin', '시스템관리자', '192.168.1.1', GETDATE(), 'C', 'Y', 'N', 'Y', 25);
    
    PRINT '테스트 게시물 등록 완료';
END
GO

-- 12. 테스트 답변 데이터 추가
IF NOT EXISTS (SELECT 1 FROM TB_POST_REPLY_INFO WHERE board_id = 1)
BEGIN
    INSERT INTO TB_POST_REPLY_INFO (
        board_id, post_seq, reply_title, reply_content, reply_nm, 
        reg_id, reg_nm, reg_ip, reg_dt, reply_status, reply_use_yn, secret_yn
    ) VALUES 
    (1, 2, '답변', '프린터 드라이버를 재설치하고 네트워크 설정을 확인해보세요. 필요시 IT팀에서 직접 방문하여 설정해드리겠습니다.', 'IT관리자', 'admin', '시스템관리자', '192.168.1.1', GETDATE(), 'N', 'Y', 'N'),
    (1, 4, '답변', 'VPN 인증서가 만료되었습니다. 새로운 인증서를 이메일로 발송해드렸으니 설치 후 다시 시도해보세요.', 'IT관리자', 'admin', '시스템관리자', '192.168.1.1', GETDATE(), 'N', 'Y', 'N');
    
    PRINT '테스트 답변 등록 완료';
END
GO