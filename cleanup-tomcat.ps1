# Tomcat 및 프로젝트 정리 스크립트
# 사용법: PowerShell에서 .\cleanup-tomcat.ps1 실행

Write-Host "==================================" -ForegroundColor Cyan
Write-Host "Tomcat & Project Cleanup Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""

# 1. Maven Clean
Write-Host "[1/4] Maven Clean 실행 중..." -ForegroundColor Yellow
if (Test-Path "pom.xml") {
    mvn clean
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Maven Clean 완료" -ForegroundColor Green
    } else {
        Write-Host "✗ Maven Clean 실패" -ForegroundColor Red
    }
} else {
    Write-Host "✗ pom.xml을 찾을 수 없습니다. helpdesk 디렉토리에서 실행하세요." -ForegroundColor Red
    exit 1
}

Write-Host ""

# 2. Target 디렉토리 삭제
Write-Host "[2/4] Target 디렉토리 삭제 중..." -ForegroundColor Yellow
if (Test-Path "target") {
    Remove-Item -Path "target" -Recurse -Force
    Write-Host "✓ Target 디렉토리 삭제 완료" -ForegroundColor Green
} else {
    Write-Host "○ Target 디렉토리가 없습니다." -ForegroundColor Gray
}

Write-Host ""

# 3. Tomcat Work 디렉토리 삭제 (Eclipse workspace)
Write-Host "[3/4] Tomcat Work 디렉토리 삭제 중..." -ForegroundColor Yellow
$workspacePath = "..\..\.metadata\.plugins\org.eclipse.wst.server.core"
if (Test-Path $workspacePath) {
    $tomcatDirs = Get-ChildItem -Path $workspacePath -Directory -Filter "tmp*"
    foreach ($dir in $tomcatDirs) {
        $workPath = Join-Path $dir.FullName "work"
        if (Test-Path $workPath) {
            Remove-Item -Path $workPath -Recurse -Force
            Write-Host "✓ $workPath 삭제 완료" -ForegroundColor Green
        }
    }
    Write-Host "✓ Tomcat Work 디렉토리 정리 완료" -ForegroundColor Green
} else {
    Write-Host "○ Eclipse workspace를 찾을 수 없습니다." -ForegroundColor Gray
}

Write-Host ""

# 4. Maven Package
Write-Host "[4/4] Maven Package 실행 중..." -ForegroundColor Yellow
mvn package -DskipTests
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Maven Package 완료" -ForegroundColor Green
} else {
    Write-Host "✗ Maven Package 실패" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "==================================" -ForegroundColor Cyan
Write-Host "정리 완료!" -ForegroundColor Green
Write-Host "==================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "다음 단계:" -ForegroundColor Yellow
Write-Host "1. Eclipse/STS에서 Tomcat 서버를 재시작하세요" -ForegroundColor White
Write-Host "2. http://localhost:8080/main 접속하여 확인하세요" -ForegroundColor White
Write-Host ""
