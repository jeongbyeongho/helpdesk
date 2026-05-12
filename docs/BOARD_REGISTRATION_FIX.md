# 게시판 등록 기능 수정 완료

## 문제 상황
게시판 등록 시 SQL 오류 발생:
```
테이블 'helpdesk.dbo.TB_BOARD_INFO', 열 'new_post_notice_hr'에 NULL 값을 삽입할 수 없습니다.
```

## 원인 분석
1. **폼에서 누락된 필드**: form.jsp에 일부 필수 필드가 포함되지 않음
2. **빈 문자열 처리 미흡**: `@RequestParam Map<String, Object>`로 받을 때 빈 문자열("")이 전달되면 null 체크만으로는 감지 불가
3. **DB 제약조건**: `new_post_notice_hr INT NOT NULL DEFAULT 24` - NULL 허용 안 함

## 해결 방법

### 1. BoardService.java 수정
- `isEmpty()` 헬퍼 메서드 추가: null과 빈 문자열 모두 체크
- `insertBoard()` 메서드의 모든 기본값 설정 로직을 `isEmpty()` 사용하도록 변경

```java
private boolean isEmpty(Object value) {
    return value == null || (value instanceof String && ((String) value).trim().isEmpty());
}

@Transactional
public void insertBoard(Map<String, Object> param) {
    // 기본값 설정 - null 또는 빈 문자열 체크
    if (isEmpty(param.get("newPostNoticeHr"))) param.put("newPostNoticeHr", 24);
    if (isEmpty(param.get("fileLimitSize"))) param.put("fileLimitSize", 10);
    if (isEmpty(param.get("fileMaxCnt"))) param.put("fileMaxCnt", 5);
    // ... 기타 필드들
}
```

### 2. 설정된 기본값 목록
| 필드명 | 기본값 | 설명 |
|--------|--------|------|
| boardPurpose | "일반" | 게시판 용도 |
| replyType | "N" | 답변 유형 |
| menuId | 0 | 메뉴 ID |
| pagePostCnt | 10 | 페이지당 게시물 수 |
| secretUseYn | "N" | 비밀글 사용 여부 |
| fileMaxCnt | 5 | 파일 최대 개수 |
| editorUseYn | "Y" | 에디터 사용 여부 |
| statusUseYn | "Y" | 상태 사용 여부 |
| **newPostNoticeHr** | **24** | **신규 게시물 알림 시간** |
| listFileDownloadYn | "Y" | 목록 파일 다운로드 여부 |
| **fileLimitSize** | **10** | **파일 제한 크기 (MB)** |
| approvalUseYn | "N" | 승인 사용 여부 |
| satisfactionUseYn | "N" | 만족도 사용 여부 |
| smsUseYn | "N" | SMS 사용 여부 |
| emailUseYn | "N" | 이메일 사용 여부 |
| ownerListUseYn | "N" | 담당자 목록 사용 여부 |
| postContentRequiredYn | "Y" | 게시물 내용 필수 여부 |
| noticeYn | "N" | 공지 사용 여부 |
| replyYn | "Y" | 댓글 사용 여부 |
| copyYn | "N" | 복사 사용 여부 |
| prefaceUseYn | "N" | 머리말 사용 여부 |
| prefaceContent | "" | 머리말 내용 |
| anonymousUseYn | "N" | 익명 사용 여부 |
| folderUseYn | "N" | 폴더 사용 여부 |
| allowedExt | "jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx,hwp,txt,zip" | 허용 확장자 |
| regPeriodUseYn | "N" | 등록 기간 사용 여부 |

## 테스트 방법
1. 관리자로 로그인 (admin/admin1234)
2. 게시판관리 > 게시판 등록
3. 필수 항목만 입력:
   - 시스템: 선택
   - 게시판명: 입력
   - 게시판유형: 선택
4. 저장 버튼 클릭
5. 정상 등록 확인

## 수정 파일
- `helpdesk/src/main/java/com/helpdesk/admin/board/service/BoardService.java`

## 관련 파일 (이미 구현 완료)
- `helpdesk/src/main/java/com/helpdesk/admin/board/controller/BoardController.java` - 시스템 목록 전달
- `helpdesk/src/main/webapp/WEB-INF/views/admin/board/form.jsp` - 완전한 UI 구현
- `helpdesk/src/main/resources/mapper/admin/board_mapper.xml` - INSERT 쿼리
- `helpdesk/src/main/java/com/helpdesk/admin/board/mapper/BoardMapper.java` - selectSystemList() 메서드

## 주의사항
- 폼에서 전송되지 않는 필드는 모두 서비스 레이어에서 기본값 설정
- Spring의 `@RequestParam Map`은 빈 문자열도 포함하므로 null 체크만으로는 부족
- DB 제약조건(NOT NULL)이 있는 컬럼은 반드시 기본값 설정 필요
