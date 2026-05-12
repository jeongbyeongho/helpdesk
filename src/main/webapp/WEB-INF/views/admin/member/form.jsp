<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .form-container {
            max-width: 800px;
            margin: 20px auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .form-header {
            border-bottom: 2px solid #4CAF50;
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        .form-header h2 {
            color: #333;
            margin: 0;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #555;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group textarea {
            height: 80px;
            resize: vertical;
        }
        .form-row {
            display: flex;
            gap: 20px;
        }
        .form-row .form-group {
            flex: 1;
        }
        .btn-group {
            text-align: center;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .btn {
            padding: 12px 30px;
            margin: 0 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            display: inline-block;
        }
        .btn-primary {
            background: #4CAF50;
            color: white;
        }
        .btn-primary:hover {
            background: #45a049;
        }
        .btn-secondary {
            background: #999;
            color: white;
        }
        .btn-secondary:hover {
            background: #777;
        }
        .btn-check {
            background: #2196F3;
            color: white;
            padding: 8px 16px;
            font-size: 12px;
            margin-left: 10px;
        }
        .btn-check:hover {
            background: #1976D2;
        }
        .required {
            color: red;
        }
        .help-text {
            font-size: 12px;
            color: #666;
            margin-top: 5px;
        }
        .input-group {
            display: flex;
            align-items: center;
        }
        .input-group input {
            flex: 1;
            margin-right: 10px;
        }
        .validation-msg {
            font-size: 12px;
            margin-top: 5px;
        }
        .validation-success {
            color: #4CAF50;
        }
        .validation-error {
            color: #f44336;
        }
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
        }
        .strength-weak { color: #f44336; }
        .strength-medium { color: #ff9800; }
        .strength-strong { color: #4CAF50; }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="form-header">
            <h2>${pageTitle}</h2>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/admin/member/${empty memberInfo ? 'insert' : 'update'}">
            <c:if test="${not empty memberInfo}">
                <input type="hidden" name="originalUserId" value="${memberInfo.user_id}">
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label for="userId">사용자ID <span class="required">*</span></label>
                    <div class="input-group">
                        <input type="text" id="userId" name="userId" value="${memberInfo.user_id}" 
                               ${not empty memberInfo ? 'readonly' : ''} required 
                               placeholder="영문, 숫자 조합 (4-20자)">
                        <c:if test="${empty memberInfo}">
                            <button type="button" class="btn btn-check" onclick="checkUserId()">중복확인</button>
                        </c:if>
                    </div>
                    <div id="userIdValidation" class="validation-msg"></div>
                    <div class="help-text">영문, 숫자 조합으로 4-20자 이내로 입력하세요.</div>
                </div>
                <div class="form-group">
                    <label for="userNm">사용자명 <span class="required">*</span></label>
                    <input type="text" id="userNm" name="userNm" value="${memberInfo.user_nm}" required 
                           placeholder="홍길동">
                </div>
            </div>

            <c:if test="${empty memberInfo}">
                <div class="form-row">
                    <div class="form-group">
                        <label for="userPwd">비밀번호 <span class="required">*</span></label>
                        <input type="password" id="userPwd" name="userPwd" required 
                               placeholder="8자 이상, 영문/숫자/특수문자 조합">
                        <div id="passwordStrength" class="password-strength"></div>
                        <div class="help-text">8자 이상, 영문/숫자/특수문자를 조합하여 입력하세요.</div>
                    </div>
                    <div class="form-group">
                        <label for="userPwdConfirm">비밀번호 확인 <span class="required">*</span></label>
                        <input type="password" id="userPwdConfirm" name="userPwdConfirm" required 
                               placeholder="비밀번호를 다시 입력하세요">
                        <div id="passwordMatch" class="validation-msg"></div>
                    </div>
                </div>
            </c:if>

            <div class="form-row">
                <div class="form-group">
                    <label for="email">이메일 <span class="required">*</span></label>
                    <input type="email" id="email" name="email" value="${memberInfo.email}" required 
                           placeholder="user@example.com">
                </div>
                <div class="form-group">
                    <label for="telNo">전화번호</label>
                    <input type="tel" id="telNo" name="telNo" value="${memberInfo.tel_no}" 
                           placeholder="02-1234-5678">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="mobileNo">휴대폰번호</label>
                    <input type="tel" id="mobileNo" name="mobileNo" value="${memberInfo.mobile_no}" 
                           placeholder="010-1234-5678">
                </div>
                <div class="form-group">
                    <!-- Empty for layout balance -->
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="deptNm">부서명</label>
                    <select id="deptNm" name="deptNm">
                        <option value="">부서 선택</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="jobCode">직급</label>
                    <select id="jobCode" name="jobCode">
                        <option value="">직급 선택</option>
                    </select>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="userType">사용자타입</label>
                    <select id="userType" name="userType">
                        <option value="">사용자타입 선택</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="approvalYn">승인여부</label>
                    <select id="approvalYn" name="approvalYn">
                        <option value="Y" ${memberInfo.approval_yn eq 'Y' || empty memberInfo.approval_yn ? 'selected' : ''}>승인</option>
                        <option value="N" ${memberInfo.approval_yn eq 'N' ? 'selected' : ''}>미승인</option>
                        <option value="R" ${memberInfo.approval_yn eq 'R' ? 'selected' : ''}>반려</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="userDesc">사용자설명</label>
                <textarea id="userDesc" name="userDesc" placeholder="사용자에 대한 설명을 입력하세요">${memberInfo.user_desc}</textarea>
            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-primary" id="submitBtn">
                    ${empty memberInfo ? '등록' : '수정'}
                </button>
                <a href="${pageContext.request.contextPath}/admin/member/list" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>

    <script>
        let userIdChecked = ${not empty memberInfo ? 'true' : 'false'};

        // 페이지 로드 시 공통코드 로드
        document.addEventListener('DOMContentLoaded', function() {
            loadCommonCodes();
        });

        // 공통코드 로드
        function loadCommonCodes() {
            // 부서 코드 로드
            fetch('${pageContext.request.contextPath}/admin/code/api/codes?codeGroup=DEPT')
                .then(response => response.json())
                .then(codes => {
                    const deptSelect = document.getElementById('deptNm');
                    const currentDept = '${memberInfo.dept_nm}';
                    
                    codes.forEach(code => {
                        const option = document.createElement('option');
                        option.value = code.code_nm;
                        option.textContent = code.code_nm;
                        if (currentDept === code.code_nm) {
                            option.selected = true;
                        }
                        deptSelect.appendChild(option);
                    });
                })
                .catch(error => console.error('부서 코드 로드 실패:', error));

            // 직급 코드 로드
            fetch('${pageContext.request.contextPath}/admin/code/api/codes?codeGroup=JOB')
                .then(response => response.json())
                .then(codes => {
                    const jobSelect = document.getElementById('jobCode');
                    const currentJob = '${memberInfo.dept_code}';
                    
                    codes.forEach(code => {
                        const option = document.createElement('option');
                        option.value = code.code_value;
                        option.textContent = code.code_nm;
                        if (currentJob === code.code_value) {
                            option.selected = true;
                        }
                        jobSelect.appendChild(option);
                    });
                })
                .catch(error => console.error('직급 코드 로드 실패:', error));

            // 사용자타입 코드 로드
            fetch('${pageContext.request.contextPath}/admin/code/api/codes?codeGroup=USER_TYPE')
                .then(response => response.json())
                .then(codes => {
                    const userTypeSelect = document.getElementById('userType');
                    const currentUserType = '${memberInfo.user_type}';
                    
                    codes.forEach(code => {
                        const option = document.createElement('option');
                        option.value = code.code_value;
                        option.textContent = code.code_nm;
                        if (currentUserType === code.code_value || (!currentUserType && code.code_value === 'I')) {
                            option.selected = true;
                        }
                        userTypeSelect.appendChild(option);
                    });
                })
                .catch(error => console.error('사용자타입 코드 로드 실패:', error));
        }

        function checkUserId() {
            const userId = document.getElementById('userId').value.trim();
            const validationDiv = document.getElementById('userIdValidation');
            
            if (!userId) {
                validationDiv.innerHTML = '<span class="validation-error">사용자ID를 입력하세요.</span>';
                return;
            }

            // 영문, 숫자만 허용, 4-20자
            const pattern = /^[a-zA-Z0-9]{4,20}$/;
            if (!pattern.test(userId)) {
                validationDiv.innerHTML = '<span class="validation-error">영문, 숫자 조합으로 4-20자 이내로 입력하세요.</span>';
                userIdChecked = false;
                return;
            }

            fetch('${pageContext.request.contextPath}/admin/member/checkId?userId=' + encodeURIComponent(userId))
                .then(response => response.json())
                .then(isDuplicate => {
                    if (isDuplicate === 1) {
                        validationDiv.innerHTML = '<span class="validation-error">이미 사용 중인 사용자ID입니다.</span>';
                        userIdChecked = false;
                    } else {
                        validationDiv.innerHTML = '<span class="validation-success">사용 가능한 사용자ID입니다.</span>';
                        userIdChecked = true;
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    validationDiv.innerHTML = '<span class="validation-error">중복 확인 중 오류가 발생했습니다.</span>';
                    userIdChecked = false;
                });
        }

        // 사용자ID 변경시 중복확인 초기화
        document.getElementById('userId').addEventListener('input', function() {
            if (${empty memberInfo ? 'true' : 'false'}) {
                userIdChecked = false;
                document.getElementById('userIdValidation').innerHTML = '';
            }
        });

        <c:if test="${empty memberInfo}">
        // 비밀번호 강도 체크
        document.getElementById('userPwd').addEventListener('input', function() {
            const password = this.value;
            const strengthDiv = document.getElementById('passwordStrength');
            
            if (!password) {
                strengthDiv.innerHTML = '';
                return;
            }

            let strength = 0;
            let strengthText = '';
            let strengthClass = '';

            // 길이 체크
            if (password.length >= 8) strength++;
            // 영문 체크
            if (/[a-zA-Z]/.test(password)) strength++;
            // 숫자 체크
            if (/[0-9]/.test(password)) strength++;
            // 특수문자 체크
            if (/[^a-zA-Z0-9]/.test(password)) strength++;

            if (strength < 2) {
                strengthText = '약함';
                strengthClass = 'strength-weak';
            } else if (strength < 3) {
                strengthText = '보통';
                strengthClass = 'strength-medium';
            } else {
                strengthText = '강함';
                strengthClass = 'strength-strong';
            }

            strengthDiv.innerHTML = `<span class="\${strengthClass}">비밀번호 강도: \${strengthText}</span>`;
        });

        // 비밀번호 확인
        document.getElementById('userPwdConfirm').addEventListener('input', function() {
            const password = document.getElementById('userPwd').value;
            const confirmPassword = this.value;
            const matchDiv = document.getElementById('passwordMatch');

            if (!confirmPassword) {
                matchDiv.innerHTML = '';
                return;
            }

            if (password === confirmPassword) {
                matchDiv.innerHTML = '<span class="validation-success">비밀번호가 일치합니다.</span>';
            } else {
                matchDiv.innerHTML = '<span class="validation-error">비밀번호가 일치하지 않습니다.</span>';
            }
        });
        </c:if>

        // 휴대폰번호 자동 하이픈 추가
        document.getElementById('mobileNo').addEventListener('input', function() {
            let value = this.value.replace(/[^0-9]/g, '');
            if (value.length >= 3 && value.length <= 7) {
                value = value.replace(/(\d{3})(\d+)/, '$1-$2');
            } else if (value.length > 7) {
                value = value.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
            }
            this.value = value;
        });

        // 전화번호 자동 하이픈 추가
        document.getElementById('telNo').addEventListener('input', function() {
            let value = this.value.replace(/[^0-9]/g, '');
            if (value.startsWith('02')) {
                if (value.length >= 2 && value.length <= 6) {
                    value = value.replace(/(\d{2})(\d+)/, '$1-$2');
                } else if (value.length > 6) {
                    value = value.replace(/(\d{2})(\d{4})(\d+)/, '$1-$2-$3');
                }
            } else {
                if (value.length >= 3 && value.length <= 7) {
                    value = value.replace(/(\d{3})(\d+)/, '$1-$2');
                } else if (value.length > 7) {
                    value = value.replace(/(\d{3})(\d{4})(\d+)/, '$1-$2-$3');
                }
            }
            this.value = value;
        });

        // 폼 제출 전 검증
        document.querySelector('form').addEventListener('submit', function(e) {
            <c:if test="${empty memberInfo}">
            if (!userIdChecked) {
                e.preventDefault();
                alert('사용자ID 중복확인을 해주세요.');
                return false;
            }

            const password = document.getElementById('userPwd').value;
            const confirmPassword = document.getElementById('userPwdConfirm').value;

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('비밀번호가 일치하지 않습니다.');
                return false;
            }

            if (password.length < 8) {
                e.preventDefault();
                alert('비밀번호는 8자 이상이어야 합니다.');
                return false;
            }
            </c:if>
        });
    </script>
</body>
</html>