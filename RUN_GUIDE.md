# IT 서비스데스크 실행 가이드

## 🚀 실행 방법

### 1. Eclipse/STS에서 실행

1. **프로젝트 Import**
   - File → Import → Existing Maven Projects
   - Root Directory: `F:\source_ithelp\helpdesk`
   - Finish

2. **Maven Update**
   - 프로젝트 우클릭 → Maven → Update Project
   - Force Update of Snapshots/Releases 체크
   - OK

3. **실행**
   - `HelpdeskApplication.java` 파일 열기
   - 우클릭 → Run As → Spring Boot App
   - 또는 `main` 메서드 우클릭 → Run As → Java Application

### 2. IntelliJ IDEA에서 실행

1. **프로젝트 Open**
   - File → Open → `F:\source_ithelp\helpdesk` 선택

2. **Maven Reload**
   - 우측 Maven 탭 → Reload All Maven Projects

3. **실행**
   - `HelpdeskApplication.java` 파일 열기
   - `main` 메서드 옆 실행 버튼 클릭
   - 또는 Shift + F10

### 3. VS Code에서 실행

1. **프로젝트 Open**
   - File → Open Folder → `F:\source_ithelp\helpdesk`

2. **Extension 설치** (필요시)
   - Extension Pack for Java
   - Spring Boot Extension Pack

3. **실행**
   - `HelpdeskApplication.java` 파일 열기
   - F5 또는 Run → Start Debugging

### 4. 명령줄에서 실행 (Maven 설치 필요)

```bash
# 프로젝트 디렉토리로 이동
cd F:\source_ithelp\helpdesk

# 컴파일 및 실행
mvn spring-boot:run

# 또는 JAR 빌드 후 실행
mvn clean package
java -jar target/helpdesk-1.0.0.war
```

## 🌐 접속 정보

### 애플리케이션 URL
```
http://localhost:8080
```

### 로그인 페이지
```
http://localhost:8080/auth/login
```

### 계정 정보

#### 관리자 계정
- **ID**: `admin`
- **PW**: `admin1234`
- **권한**: 시스템관리자 (모든 기능 접근 가능)

#### 테스트 사용자 계정
- **ID**: `user01`
- **PW**: `user1234`
- **권한**: 일반사용자

## 📋 주요 기능 URL

### 사용자 기능
- 메인: `http://localhost:8080/main`
- 문의게시판: `http://localhost:8080/user/post/list?boardId=1`
- FAQ: `http://localhost:8080/user/post/list?boardId=2`
- 내 문의: `http://localhost:8080/user/post/list?boardId=1&searchOnlyMine=Y`

### 관리자 기능
- 게시판관리: `http://localhost:8080/admin/board/list`
- 회원관리: `http://localhost:8080/admin/member/list`
- 메뉴관리: `http://localhost:8080/admin/menu/list`
- 시스템관리: `http://localhost:8080/admin/system/list`
- 권한관리: `http://localhost:8080/admin/role/list`
- 코드관리: `http://localhost:8080/admin/code/list`
- 팝업관리: `http://localhost:8080/admin/popup/list`
- 통계: `http://localhost:8080/admin/stats/access`

## 🔧 데이터베이스 정보

- **서버**: `localhost\SQLEXPRESS`
- **데이터베이스**: `helpdesk`
- **계정**: `appUser` / `xlqm4968632@`
- **포트**: 기본 포트 (1433)

## 📝 초기 데이터

초기 데이터는 이미 입력되어 있습니다:
- ✅ 시스템 정보 (helpdesk)
- ✅ 권한 정보 (시스템관리자, 관리자, 일반사용자)
- ✅ 관리자 계정 (admin)
- ✅ 테스트 사용자 (user01)
- ✅ 게시판 2개 (문의게시판, FAQ)

## ⚠️ 문제 해결

### 1. 포트 충돌 (8080 포트 사용 중)
`application.yml` 파일에서 포트 변경:
```yaml
server:
  port: 8081  # 다른 포트로 변경
```

### 2. 데이터베이스 연결 실패
- SQL Server가 실행 중인지 확인
- `application.yml`의 DB 정보 확인
- SQL Server 인증 모드 확인 (혼합 모드)

### 3. JSP 페이지가 표시되지 않음
- `pom.xml`에 tomcat-embed-jasper 의존성 확인
- `application.yml`의 view prefix/suffix 확인

### 4. 파일 업로드 오류
- `application.yml`의 upload-path 디렉토리 생성 확인
- 디렉토리 쓰기 권한 확인
