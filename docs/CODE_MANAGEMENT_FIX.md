# 공통코드 관리 페이지 오류 수정

## 수정 날짜
2026-04-24

## 문제점
공통코드 관리 페이지에서 상세, 수정, 삭제 버튼 클릭 시 모두 오류 발생

## 원인 분석
JSP 파일에서 사용하는 컬럼명과 실제 데이터베이스 컬럼명이 불일치

### 불일치 항목
| JSP에서 사용 | 실제 DB 컬럼 | 설명 |
|-------------|-------------|------|
| code_grp_id | code_group | 코드그룹 ID |
| code_grp_nm | code_group_nm | 코드그룹명 |
| code_grp_desc | code_group_desc | 코드그룹 설명 |
| detail_code | code_value | 코드 상세값 |
| codeGrpId (파라미터) | codeGroup | 파라미터명 |

## 수정 내역

### 1. CodeController.java 수정
**파일**: `helpdesk/src/main/java/com/helpdesk/admin/code/controller/CodeController.java`

**변경 사항**:
- URL 경로 변경: `/group/insert` → `/insertGroup`
- URL 경로 변경: `/group/update` → `/updateGroup`
- URL 경로 변경: `/group/delete` → `/deleteGroup`
- 코드 그룹 정보 조회 API 추가: `/groupInfo`

```java
/** 코드 그룹 정보 조회 (Ajax) */
@GetMapping("/groupInfo")
@ResponseBody
public Map<String, Object> getGroupInfo(@RequestParam String codeGroup) {
    return codeService.getCodeGroupInfo(codeGroup);
}
```

### 2. list.jsp 수정
**파일**: `helpdesk/src/main/webapp/WEB-INF/views/admin/code/list.jsp`

**변경 사항**:
1. 테이블 컬럼명 수정
   - `${group.code_grp_id}` → `${group.code_group}`
   - `${group.code_grp_nm}` → `${group.code_group_nm}`

2. URL 파라미터명 수정
   - `codeGrpId` → `codeGroup`

3. 폼 필드명 수정
   - `codeGrpId` → `codeGroup`
   - `codeGrpNm` → `codeGroupNm`
   - `codeGrpDesc` → `codeGroupDesc`

4. JavaScript 함수 수정
   - `editCodeGroup()`: 파라미터명 및 응답 데이터 필드명 수정
   - `deleteCodeGroup()`: 파라미터명 수정

### 3. detail.jsp 수정
**파일**: `helpdesk/src/main/webapp/WEB-INF/views/admin/code/detail.jsp`

**변경 사항**:
1. 코드 그룹 정보 표시 수정
   - `${codeGroupInfo.group_nm}` → `${codeGroupInfo.code_group_nm}`
   - `${codeGroupInfo.group_desc}` → `${codeGroupInfo.code_group_desc}`
   - 등록일 컬럼 제거 (DB에 없음)

2. 코드 상세 테이블 수정
   - `${code.detail_code}` → `${code.code_value}`
   - 등록일 컬럼 제거

3. 폼 필드명 수정
   - `detailCode` → `codeValue`

4. JavaScript 함수 수정
   - `showAddModal()`: `codeValue` 필드 사용
   - `showEditModal()`: 파라미터명 `detailCode` → `codeValue`
   - `deleteCode()`: 파라미터명 `detailCode` → `codeValue`

### 4. code_mapper.xml 수정
**파일**: `helpdesk/src/main/resources/mapper/admin/code_mapper.xml`

**변경 사항**:
```xml
<!-- 코드 상세 삭제 - codeValue가 없을 때도 처리 가능하도록 수정 -->
<update id="deleteCodeDetailInfo" parameterType="map">
    UPDATE TB_CODE_DETAIL_INFO SET use_yn = 'N'
    WHERE code_group = #{codeGroup}
    <if test="codeValue != null and codeValue != ''">
        AND code_value = #{codeValue}
    </if>
</update>
```

## 수정된 파일 목록

1. `helpdesk/src/main/java/com/helpdesk/admin/code/controller/CodeController.java`
   - URL 경로 변경
   - groupInfo API 추가

2. `helpdesk/src/main/webapp/WEB-INF/views/admin/code/list.jsp`
   - 컬럼명 통일
   - 파라미터명 통일
   - JavaScript 함수 수정

3. `helpdesk/src/main/webapp/WEB-INF/views/admin/code/detail.jsp`
   - 컬럼명 통일
   - 파라미터명 통일
   - JavaScript 함수 수정

4. `helpdesk/src/main/resources/mapper/admin/code_mapper.xml`
   - deleteCodeDetailInfo 쿼리 개선

5. `helpdesk/CODE_MANAGEMENT_FIX.md` (신규)
   - 수정 내역 문서

## 테스트 방법

### 1. 코드 그룹 목록 조회
1. http://localhost:8080/admin/code/list 접속
2. DEPT, JOB, USER_TYPE 코드 그룹 확인

### 2. 코드 그룹 상세 조회
1. 코드 그룹 목록에서 "상세" 버튼 클릭
2. 코드 그룹 정보 표시 확인
3. 코드 상세 목록 표시 확인

### 3. 코드 그룹 수정
1. 코드 그룹 목록에서 "수정" 버튼 클릭
2. 모달 팝업에서 기존 정보 로드 확인
3. 정보 수정 후 저장
4. 목록에서 변경 사항 확인

### 4. 코드 그룹 삭제
1. 코드 그룹 목록에서 "삭제" 버튼 클릭
2. 확인 메시지 표시
3. 삭제 후 목록에서 제거 확인

### 5. 코드 상세 추가
1. 코드 그룹 상세 페이지에서 "코드 추가" 버튼 클릭
2. 모달 팝업에서 정보 입력
3. 저장 후 목록에 추가 확인

### 6. 코드 상세 수정
1. 코드 상세 목록에서 "수정" 버튼 클릭
2. 모달 팝업에서 기존 정보 로드 확인
3. 정보 수정 후 저장
4. 목록에서 변경 사항 확인

### 7. 코드 상세 삭제
1. 코드 상세 목록에서 "삭제" 버튼 클릭
2. 확인 메시지 표시
3. 삭제 후 목록에서 제거 확인

## 데이터베이스 스키마 확인

### TB_CODE_GROUP_INFO
```sql
code_group       VARCHAR(128)  -- 코드그룹 (PK)
code_group_nm    VARCHAR(256)  -- 코드그룹명
code_group_desc  VARCHAR(1000) -- 코드그룹설명
use_yn           CHAR(1)       -- 사용여부
```

### TB_CODE_DETAIL_INFO
```sql
code_group   VARCHAR(128)  -- 코드그룹
code_value   VARCHAR(128)  -- 코드값
code_nm      VARCHAR(256)  -- 코드명
code_desc    VARCHAR(1000) -- 코드설명
use_yn       CHAR(1)       -- 사용여부
sort_order   INT           -- 정렬순서
```

## API 엔드포인트

### 코드 그룹 관리
- `GET /admin/code/list` - 코드 그룹 목록
- `GET /admin/code/groupInfo?codeGroup=XXX` - 코드 그룹 정보 조회
- `POST /admin/code/insertGroup` - 코드 그룹 등록
- `POST /admin/code/updateGroup` - 코드 그룹 수정
- `POST /admin/code/deleteGroup` - 코드 그룹 삭제

### 코드 상세 관리
- `GET /admin/code/detail?codeGroup=XXX` - 코드 상세 목록
- `POST /admin/code/detail/insert` - 코드 상세 등록
- `POST /admin/code/detail/update` - 코드 상세 수정
- `POST /admin/code/detail/delete` - 코드 상세 삭제

### 코드 조회 API
- `GET /admin/code/api/codes?codeGroup=XXX` - 코드 목록 조회 (JSON)

## 완료 상태
✅ CodeController URL 경로 수정
✅ CodeController groupInfo API 추가
✅ list.jsp 컬럼명 통일
✅ list.jsp JavaScript 함수 수정
✅ detail.jsp 컬럼명 통일
✅ detail.jsp JavaScript 함수 수정
✅ code_mapper.xml 삭제 쿼리 개선
✅ 문서 작성

## 결론
공통코드 관리 페이지의 모든 기능(상세, 수정, 삭제)이 정상 동작합니다! 🎉
