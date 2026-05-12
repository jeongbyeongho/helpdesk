<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 변경 - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <style>
        .change-pwd-container {
            max-width: 500px;
            margin: 100px auto;
            padding: 40px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .change-pwd-container h2 {
            text-align: center;
            margin-bottom: 10px;
            color: #333;
        }
        .change-pwd-container .notice {
            background: #fff3cd;
            border: 1px solid #ffc107;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
            color: #856404;
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
        .form-group input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: #45a049;
        }
        .error-msg {
            color: #d32f2f;
            background: #ffebee;
            padding: 10px;
            border-radius: 4px;
            margin-bottom: 15px;
            text-align: center;
        }
        .btn-skip {
            width: 100%;
            padding: 12px;
            background: #999;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            cursor: pointer;
            margin-top: 10px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }
        .btn-skip:hover {
            background: #777;
        }
    </style>
</head>
<body>
    <div class="change-pwd-container">
        <h2>비밀번호 변경</h2>
        
        <div class="notice">
            <strong>비밀번호 변경이 필요합니다.</strong><br>
            보안을 위해 주기적으로 비밀번호를 변경해주세요.
        </div>

        <c:if test="${not empty errorMsg}">
            <div class="error-msg">${errorMsg}</div>
        </c:if>

        <form method="post" action="${pageContext.request.contextPath}/auth/change-password" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="newPwd">새 비밀번호</label>
                <input type="password" id="newPwd" name="newPwd" required 
                       placeholder="8자 이상 입력하세요" minlength="8">
            </div>

            <div class="form-group">
                <label for="confirmPwd">새 비밀번호 확인</label>
                <input type="password" id="confirmPwd" name="confirmPwd" required 
                       placeholder="비밀번호를 다시 입력하세요" minlength="8">
            </div>

            <button type="submit" class="btn-submit">비밀번호 변경</button>
            <a href="${pageContext.request.contextPath}/main" class="btn-skip">나중에 변경</a>
        </form>
    </div>

    <script>
        function validateForm() {
            var newPwd = document.getElementById('newPwd').value;
            var confirmPwd = document.getElementById('confirmPwd').value;

            if (newPwd.length < 8) {
                alert('비밀번호는 8자 이상이어야 합니다.');
                return false;
            }

            if (newPwd !== confirmPwd) {
                alert('새 비밀번호가 일치하지 않습니다.');
                return false;
            }

            return true;
        }
    </script>
</body>
</html>
