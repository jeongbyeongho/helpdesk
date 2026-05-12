-- =====================================================
-- 07_init_common_codes.sql : 공통코드 초기 데이터
-- =====================================================
USE helpdesk;
GO

-- 기존 데이터 삭제
DELETE FROM TB_CODE_DETAIL_INFO WHERE code_group IN ('DEPT', 'JOB', 'USER_TYPE');
DELETE FROM TB_CODE_GROUP_INFO WHERE code_group IN ('DEPT', 'JOB', 'USER_TYPE');
GO

-- 코드 그룹 등록
INSERT INTO TB_CODE_GROUP_INFO (code_group, code_group_nm, code_group_desc, use_yn) VALUES
('DEPT', '부서', '부서 코드', 'Y'),
('JOB', '직급', '직급 코드', 'Y'),
('USER_TYPE', '사용자타입', '사용자 유형 코드', 'Y');
GO

-- 부서 코드
INSERT INTO TB_CODE_DETAIL_INFO (code_group, code_value, code_nm, code_desc, use_yn, sort_order) VALUES
('DEPT', 'IT', 'IT팀', 'IT 부서', 'Y', 1),
('DEPT', 'SALES', '영업팀', '영업 부서', 'Y', 2),
('DEPT', 'ADMIN', '관리팀', '관리 부서', 'Y', 3),
('DEPT', 'DEV', '개발팀', '개발 부서', 'Y', 4),
('DEPT', 'PLAN', '기획팀', '기획 부서', 'Y', 5);
GO

-- 직급 코드
INSERT INTO TB_CODE_DETAIL_INFO (code_group, code_value, code_nm, code_desc, use_yn, sort_order) VALUES
('JOB', 'CEO', '대표이사', '대표이사', 'Y', 1),
('JOB', 'EXEC', '임원', '임원', 'Y', 2),
('JOB', 'DEPT_HEAD', '부서장', '부서장', 'Y', 3),
('JOB', 'TEAM_LEAD', '팀장', '팀장', 'Y', 4),
('JOB', 'MANAGER', '과장', '과장', 'Y', 5),
('JOB', 'STAFF', '대리', '대리', 'Y', 6),
('JOB', 'ASSOCIATE', '사원', '사원', 'Y', 7);
GO

-- 사용자타입 코드
INSERT INTO TB_CODE_DETAIL_INFO (code_group, code_value, code_nm, code_desc, use_yn, sort_order) VALUES
('USER_TYPE', 'I', '내부사용자', '내부 직원', 'Y', 1),
('USER_TYPE', 'E', '외부사용자', '외부 사용자', 'Y', 2),
('USER_TYPE', 'P', '협력업체', '협력업체 직원', 'Y', 3),
('USER_TYPE', 'C', '고객', '고객사 사용자', 'Y', 4);
GO

PRINT '07_init_common_codes.sql 완료 - 공통코드 초기 데이터 생성';
GO
