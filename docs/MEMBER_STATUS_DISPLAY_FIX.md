# 회원 관리 상태 표시 오류 수정

## 문제 상황
1. **회원 목록**: 승인된 사용자도 "미승인"으로 표시
2. **회원 상세**: 사용 중인 계정도 "미사용"으로 표시

## 원인 분석

### 1. approval_yn NULL 문제
- TB_USER_TYPE_INFO 테이블에 데이터가 없는 경우 approval_yn이 NULL
- admin 계정은 TB_USER_TYPE_INFO에 레코드가 없어서 NULL 반환
- JSP에서 `${memberInfo.approval_yn eq 'Y'}`는 NULL을 'Y'로 인식하지 않음

### 2. use_yn 컬럼 부재
- TB_USER_INFO 테이블에 use_yn 컬럼이 존재하지 않음
- view.jsp에서 존재하지 않는 컬럼 참조

### 3. role_code 누락
- 권한 정보는 TB_USER_ROLE_MAP 테이블에 있음
- 기존 쿼리에서 JOIN하지 않아서 role_code가 조회되지 않음

## 해결 방법

### 1. member_mapper.xml 수정

#### approval_yn NULL 처리
```sql
-- 수정 전
UT.approval_yn

-- 수정 후
ISNULL(UT.approval_yn, 'Y') AS approval_yn
```
- TB_USER_TYPE_INFO에 데이터가 없으면 기본값 'Y'(승인) 반환
- admin 같은 시스템 계정은 자동 승인으로 처리

#### role_code JOIN 추가
```sql
-- 추가
LEFT JOIN TB_USER_ROLE_MAP RM ON U.user_id = RM.user_id
...
RM.role_code
```

**적용 쿼리**:
- `selectMemberListSql`: 회원 목록 조회
- `selectMemberInfo`: 회원 상세 조회

### 2. view.jsp 수정

#### use_yn 컬럼 제거
```jsp
<!-- 수정 전 -->
<th>승인여부</th>
<td>...</td>
<th>사용여부</th>
<td>${memberInfo.use_yn eq 'Y' ? '사용' : '미사용'}</td>

<!-- 수정 후 -->
<th>승인여부</th>
<td colspan="3">
    <c:otherwise>
        <span class="status-badge status-approved">승인</span>
    </c:otherwise>
</td>
```
- use_yn 컬럼 참조 제거
- approval_yn이 NULL인 경우 "승인"으로 표시

## 데이터베이스 구조

### 관련 테이블
```sql
-- 사용자 기본 정보
TB_USER_INFO
├─ user_id (PK)
├─ user_nm
├─ email
└─ ... (use_yn 컬럼 없음)

-- 사용자 유형 정보 (시스템별 소속)
TB_USER_TYPE_INFO
├─ user_id (FK)
├─ approval_yn (DEFAULT 'N')
├─ org_code
└─ ...

-- 사용자 권한 매핑
TB_USER_ROLE_MAP
├─ user_id (FK)
├─ role_code (1:시스템관리자, 2:관리자, 3:일반사용자)
└─ sys_id
```

### admin 계정 특징
```sql
-- TB_USER_INFO: 존재 ✅
SELECT * FROM TB_USER_INFO WHERE user_id = 'admin';

-- TB_USER_TYPE_INFO: 없음 ❌
SELECT * FROM TB_USER_TYPE_INFO WHERE user_id = 'admin';
-- 결과: 0건 → approval_yn = NULL

-- TB_USER_ROLE_MAP: 존재 ✅
SELECT * FROM TB_USER_ROLE_MAP WHERE user_id = 'admin';
-- role_code = 1 (시스템관리자)
```

## 수정 결과

### 1. 회원 목록 (/admin/member/list)
**수정 전**:
- admin: 미승인 (approval_yn = NULL)
- user01: 미승인 (approval_yn = 'N' 또는 NULL)

**수정 후**:
- admin: 승인 (ISNULL(NULL, 'Y') = 'Y')
- user01: 승인 또는 미승인 (실제 데이터에 따라)

### 2. 회원 상세 (/admin/member/view?userId=admin)
**수정 전**:
- 승인여부: 미승인
- 사용여부: 미사용 (컬럼 없음)

**수정 후**:
- 승인여부: 승인
- 사용여부: (항목 제거)

## 테스트 시나리오

### 1. admin 계정 확인
```sql
-- 데이터 확인
SELECT 
    U.user_id,
    U.user_nm,
    UT.approval_yn AS original_approval_yn,
    ISNULL(UT.approval_yn, 'Y') AS fixed_approval_yn,
    RM.role_code
FROM TB_USER_INFO U
LEFT JOIN TB_USER_TYPE_INFO UT ON U.user_id = UT.user_id
LEFT JOIN TB_USER_ROLE_MAP RM ON U.user_id = RM.user_id
WHERE U.user_id = 'admin';

-- 예상 결과:
-- user_id: admin
-- user_nm: 시스템관리자
-- original_approval_yn: NULL
-- fixed_approval_yn: Y
-- role_code: 1
```

### 2. 회원 목록 페이지 테스트
1. 관리자 로그인 (admin/admin1234)
2. 회원관리 > 회원 목록
3. admin 계정 확인
   - **승인상태**: "승인" 배지 (녹색)
   - **권한**: "시스템관리자" 배지 (빨간색)

### 3. 회원 상세 페이지 테스트
1. admin 계정 클릭
2. 회원 상세 페이지 확인
   - **승인여부**: "승인" 배지 (녹색)
   - **사용여부**: 항목 없음 (정상)

### 4. user01 계정 확인
```sql
-- TB_USER_TYPE_INFO에 데이터가 있는 경우
INSERT INTO TB_USER_TYPE_INFO (user_id, approval_yn, org_code)
VALUES ('user01', 'Y', 'ORG001');

-- 목록에서 "승인"으로 표시되는지 확인
```

## 추가 개선 사항

### 1. TB_USER_TYPE_INFO 데이터 생성
admin 계정에도 TB_USER_TYPE_INFO 레코드 생성:
```sql
INSERT INTO TB_USER_TYPE_INFO (
    user_id, user_type, org_code, org_nm, approval_yn
) VALUES (
    'admin', '1', 'SYS', '시스템', 'Y'
);
```

### 2. 사용여부 관리 필요 시
TB_USER_INFO에 use_yn 컬럼 추가:
```sql
ALTER TABLE TB_USER_INFO 
ADD use_yn CHAR(1) NULL DEFAULT 'Y';

UPDATE TB_USER_INFO SET use_yn = 'Y';
```

### 3. 권한 표시 개선
role_code를 role_nm으로 변환하여 표시:
```sql
LEFT JOIN TB_ROLE_INFO R ON RM.role_code = R.role_code
...
R.role_nm
```

## 수정 파일
1. `helpdesk/src/main/resources/mapper/admin/member_mapper.xml`
   - selectMemberListSql: ISNULL(UT.approval_yn, 'Y'), role_code JOIN 추가
   - selectMemberInfo: ISNULL(UT.approval_yn, 'Y'), role_code JOIN 추가

2. `helpdesk/src/main/webapp/WEB-INF/views/admin/member/view.jsp`
   - use_yn 컬럼 참조 제거
   - approval_yn NULL 처리 추가

## 주의사항
- ISNULL 기본값 'Y'는 시스템 계정(admin 등)을 자동 승인 처리
- 일반 사용자는 TB_USER_TYPE_INFO에 레코드가 있어야 정상 동작
- 회원 가입 시 TB_USER_TYPE_INFO에 approval_yn='N'으로 INSERT 필요
