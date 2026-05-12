# Helpdesk 시스템

IT 서비스 헬프데스크 시스템 - Spring Boot 기반 웹 애플리케이션

## 📋 목차
- [시스템 개요](#-시스템-개요)
- [빠른 시작](#-빠른-시작)
- [기능 목록](#-기능-목록)
- [기술 스택](#-기술-스택)
- [프로젝트 구조](#-프로젝트-구조)
- [문서](#-문서)

---

## 🎯 시스템 개요

### 주요 기능
- **게시판 관리**: 다양한 유형의 게시판 생성 및 관리
- **문의 관리**: IT 문의사항 등록, 처리, 추적
- **회원 관리**: 사용자 및 권한 관리
- **통계**: 접속 통계, 게시물 통계
- **공통코드 관리**: 시스템 코드 관리

### 사용자 유형
- **시스템관리자** (role_code: 1): 전체 시스템 관리
- **관리자** (role_code: 2): 게시판 및 문의 관리
- **일반사용자** (role_code: 3): 문의 등록 및 조회

---

## 🚀 빠른 시작

### 1. 사전 요구사항
- **JDK**: 11 이상
- **Maven**: 3.6 이상
- **SQL Server**: 2019 이상 (Express Edition 가능)

### 2. 데이터베이스 설정

SQL Server Management Studio 또는 sqlcmd로 실행:
```bash
sqlcmd -S "localhost\SQLEXPRESS" -U sa -P [sa비밀번호] -i SETUP_DATABASE.sql
```

**생성되는 항목**:
- 데이터베이스: `helpdesk`
- 관리자 계정: `admin` / `admin1234`
- 테스트 계정: `user01` / `user1234`
- 기본 게시판: IT 문의게시판

### 3. 애플리케이션 설정

`src/main/resources/application.yml` 확인:
```yaml
spring:
  datasource:
    url: jdbc:sqlserver://localhost\\SQLEXPRESS;databaseName=helpdesk;encrypt=false
    username: appUser
    password: xlqm4968632@
```

### 4. 프로젝트 실행

```bash
# Maven으로 실행
mvn clean spring-boot:run

# 또는 JAR 빌드 후 실행
mvn clean package
java -jar target/helpdesk-1.0.0.jar
```

### 5. 접속

브라우저에서 **http://localhost:8080** 접속

**로그인**:
- 관리자: `admin` / `admin1234`
- 일반사용자: `user01` / `user1234`

---

## ✨ 기능 목록

### 사용자 기능
- ✅ 로그인/로그아웃
- ✅ 비밀번호 변경
- ✅ 문의 등록/조회/수정
- ✅ 나의 문의 현황 확인 (연도별)
- ✅ 공지사항 조회
- ✅ 파일 첨부/다운로드

### 관리자 기능
- ✅ 게시판 관리 (생성/수정/삭제)
- ✅ 문의 처리 (접수/처리중/완료)
- ✅ 회원 관리 (승인/권한 부여)
- ✅ 공통코드 관리
- ✅ 접속 통계 조회
- ✅ 권한 관리

---

## 🛠 기술 스택

### Backend
- **Framework**: Spring Boot 2.7.x
- **ORM**: MyBatis 2.3.x
- **Database**: SQL Server 2019
- **Build Tool**: Maven 3.8.x
- **Java**: 11

### Frontend
- **Template Engine**: JSP
- **CSS**: Custom CSS
- **JavaScript**: jQuery 3.6.x

---

## 📁 프로젝트 구조

```
helpdesk/
├── src/
│   ├── main/
│   │   ├── java/com/helpdesk/
│   │   │   ├── admin/              # 관리자 기능
│   │   │   │   ├── board/          # 게시판 관리
│   │   │   │   ├── member/         # 회원 관리
│   │   │   │   ├── code/           # 공통코드 관리
│   │   │   │   ├── stats/          # 통계
│   │   │   │   └── role/           # 권한 관리
│   │   │   ├── user/               # 사용자 기능
│   │   │   │   ├── main/           # 메인 페이지
│   │   │   │   └── post/           # 게시물 관리
│   │   │   ├── common/             # 공통 기능
│   │   │   │   ├── config/         # 설정
│   │   │   │   ├── interceptor/    # 인터셉터
│   │   │   │   └── util/           # 유틸리티
│   │   │   └── auth/               # 인증
│   │   ├── resources/
│   │   │   ├── mapper/             # MyBatis 매퍼
│   │   │   ├── sql/                # SQL 스크립트
│   │   │   ├── static/             # 정적 리소스
│   │   │   └── application.yml     # 설정 파일
│   │   └── webapp/WEB-INF/views/   # JSP 파일
│   └── test/                       # 테스트 코드
├── docs/                           # 상세 문서
├── SETUP_DATABASE.sql              # DB 초기화 스크립트
├── README.md                       # 이 파일
├── RUN_GUIDE.md                    # 실행 가이드
├── FIXES_AND_IMPROVEMENTS.md       # 수정 사항
└── pom.xml                         # Maven 설정
```

---

## 📚 문서

### 필수 문서
- **README.md** (이 파일): 프로젝트 개요 및 빠른 시작
- **RUN_GUIDE.md**: 상세 실행 가이드
- **SETUP_DATABASE.sql**: 데이터베이스 초기화 스크립트
- **FIXES_AND_IMPROVEMENTS.md**: 수정 및 개선 사항

### 상세 문서 (docs/ 폴더)
- 게시판 관련: `BOARD_*.md`
- 회원 관리: `MEMBER_*.md`
- 공통코드: `CODE_*.md`
- 사용자 기능: `USER_*.md`
- 기타: `DATABASE_SCHEMA_INFO.md`, `TOMCAT_CLEANUP.md`

---

## 🔑 주요 계정 정보

### 데이터베이스
- **DB명**: helpdesk
- **인스턴스**: localhost\SQLEXPRESS
- **계정**: appUser / xlqm4968632@

### 애플리케이션
- **관리자**: admin / admin1234 (role_code: 1)
- **일반사용자**: user01 / user1234 (role_code: 3)

---

## 📊 게시물 상태 코드
- **W**: 대기 (Waiting)
- **R**: 접수 (Received)
- **P**: 처리중 (Processing)
- **C**: 완료 (Completed)
- **H**: 보류 (Hold)

---

## 🔧 문제 해결

### 데이터베이스 연결 오류
1. SQL Server 서비스 실행 확인
2. `application.yml`의 연결 정보 확인
3. `SETUP_DATABASE.sql` 재실행

### 로그인 실패
1. 데이터베이스에 사용자 데이터 확인
2. 비밀번호 해시 확인 (SHA-256)
3. 세션 설정 확인

### Tomcat 포트 충돌
```bash
# cleanup-tomcat.ps1 실행
.\cleanup-tomcat.ps1
```

---

## 📝 라이선스

이 프로젝트는 내부 사용을 위한 프로젝트입니다.
