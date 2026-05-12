# Tomcat JSP 컴파일 오류 해결 가이드

## 문제 증상
```
java.lang.ClassNotFoundException: org.apache.jsp.WEB_002dINF.views.user.main_jsp
```

이 오류는 Tomcat이 JSP 파일을 컴파일하지 못했거나, 이전 컴파일된 클래스가 캐시되어 있을 때 발생합니다.

## 해결 방법

### 방법 1: Eclipse/STS에서 해결 (권장)

1. **서버 중지**
   - Servers 탭에서 Tomcat 서버 우클릭 → Stop

2. **프로젝트 Clean**
   - Project → Clean... → Clean all projects → OK

3. **Tomcat 작업 디렉토리 삭제**
   - Servers 탭에서 Tomcat 서버 우클릭 → Clean...
   - 또는 Servers 탭에서 Tomcat 서버 우클릭 → Clean Tomcat Work Directory...

4. **프로젝트 다시 빌드**
   - Project → Build Project (또는 Build Automatically가 켜져 있으면 자동)

5. **서버 재시작**
   - Servers 탭에서 Tomcat 서버 우클릭 → Start

### 방법 2: 수동으로 해결

1. **서버 중지**

2. **Tomcat work 디렉토리 삭제**
   ```bash
   # Eclipse workspace의 Tomcat work 디렉토리
   rm -rf .metadata/.plugins/org.eclipse.wst.server.core/tmp*/work/
   ```

3. **프로젝트 target 디렉토리 삭제**
   ```bash
   cd helpdesk
   rm -rf target/
   ```

4. **Maven Clean & Build**
   ```bash
   mvn clean package
   ```

5. **서버 재시작**

### 방법 3: IntelliJ IDEA에서 해결

1. **서버 중지**

2. **Invalidate Caches**
   - File → Invalidate Caches / Restart... → Invalidate and Restart

3. **Maven Clean**
   - Maven 탭 → Lifecycle → clean 더블클릭
   - Maven 탭 → Lifecycle → package 더블클릭

4. **Rebuild Project**
   - Build → Rebuild Project

5. **서버 재시작**

## 예방 방법

1. **JSP 파일 수정 후 항상 서버 재시작**
   - JSP 파일의 구조적 변경(태그 추가/삭제)은 재시작 필요
   - 단순 텍스트 변경은 재시작 불필요 (Hot Deploy 지원)

2. **프로젝트 Clean 주기적으로 실행**
   - 이상한 오류가 발생하면 먼저 Clean 시도

3. **Tomcat 설정 확인**
   - Server.xml에서 `reloadable="true"` 설정 확인
   - Context.xml에서 `antiResourceLocking="true"` 설정 확인

## 현재 프로젝트 상태

- ✅ user/main.jsp 파일 존재 확인
- ✅ admin/main.jsp 파일 존재 확인
- ✅ JSP 문법 오류 없음
- ⚠️ Tomcat JSP 컴파일 필요

## 다음 단계

1. 위의 방법 1 또는 방법 2를 실행하세요
2. 서버 재시작 후 http://localhost:8080/main 접속
3. 관리자 계정(admin/admin1234)으로 로그인
4. 관리자 메뉴 클릭하여 http://localhost:8080/admin 접속 확인
