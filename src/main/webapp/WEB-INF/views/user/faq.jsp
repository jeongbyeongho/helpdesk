<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자주 묻는 질문 - IT 서비스데스크</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/common.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Malgun Gothic', sans-serif;
            background: #f5f5f5;
            line-height: 1.6;
        }
        .header {
            background: white;
            border-bottom: 2px solid #4CAF50;
            padding: 15px 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }
        .header h1 {
            color: #4CAF50;
            font-size: 24px;
        }
        .header h1 a {
            color: inherit;
            text-decoration: none;
        }
        .user-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .user-info span {
            color: #555;
        }
        .user-info a {
            padding: 8px 15px;
            background: #f44336;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
        }
        .user-info a:hover {
            background: #d32f2f;
        }
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        .breadcrumb {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .breadcrumb a {
            color: #4CAF50;
            text-decoration: none;
        }
        .breadcrumb a:hover {
            text-decoration: underline;
        }
        .breadcrumb span {
            color: #666;
            margin: 0 8px;
        }
        .page-title {
            font-size: 28px;
            color: #333;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 3px solid #4CAF50;
        }
        .search-section {
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .search-box {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        .search-box input {
            flex: 1;
            padding: 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 16px;
        }
        .search-box input:focus {
            outline: none;
            border-color: #4CAF50;
        }
        .search-box button {
            padding: 15px 30px;
            background: #4CAF50;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 600;
        }
        .search-box button:hover {
            background: #45a049;
        }
        .category-tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .category-tab {
            padding: 12px 24px;
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 25px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 500;
        }
        .category-tab.active {
            background: #4CAF50;
            color: white;
            border-color: #4CAF50;
        }
        .category-tab:hover {
            border-color: #4CAF50;
        }
        .faq-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .faq-item {
            border-bottom: 1px solid #e9ecef;
        }
        .faq-item:last-child {
            border-bottom: none;
        }
        .faq-question {
            padding: 25px 30px;
            cursor: pointer;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.3s;
        }
        .faq-question:hover {
            background: #f8f9fa;
        }
        .faq-question.active {
            background: #e8f5e8;
            color: #2e7d32;
        }
        .question-text {
            font-size: 16px;
            font-weight: 600;
            flex: 1;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .question-icon {
            font-size: 20px;
            color: #4CAF50;
        }
        .toggle-icon {
            font-size: 20px;
            transition: transform 0.3s;
        }
        .toggle-icon.active {
            transform: rotate(180deg);
        }
        .faq-answer {
            padding: 0 30px;
            max-height: 0;
            overflow: hidden;
            transition: all 0.3s;
        }
        .faq-answer.active {
            padding: 0 30px 25px 30px;
            max-height: 500px;
        }
        .answer-content {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 8px;
            line-height: 1.7;
            color: #555;
        }
        .answer-content h4 {
            color: #333;
            margin-bottom: 15px;
        }
        .answer-content ul {
            margin-left: 20px;
            margin-top: 10px;
        }
        .answer-content li {
            margin-bottom: 8px;
        }
        .popular-badge {
            background: #ff4444;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }
        .new-badge {
            background: #4CAF50;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
        }
        .contact-section {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            padding: 40px 30px;
            border-radius: 12px;
            text-align: center;
            margin-top: 30px;
        }
        .contact-section h3 {
            font-size: 24px;
            margin-bottom: 15px;
        }
        .contact-section p {
            margin-bottom: 25px;
            opacity: 0.9;
        }
        .contact-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        .contact-btn {
            padding: 12px 24px;
            background: rgba(255,255,255,0.2);
            color: white;
            border: 2px solid rgba(255,255,255,0.3);
            border-radius: 8px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
        }
        .contact-btn:hover {
            background: rgba(255,255,255,0.3);
            border-color: rgba(255,255,255,0.5);
        }
        @media (max-width: 768px) {
            .container {
                padding: 0 15px;
            }
            .search-box {
                flex-direction: column;
            }
            .search-box input,
            .search-box button {
                width: 100%;
            }
            .category-tabs {
                justify-content: center;
            }
            .contact-buttons {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-content">
            <h1><a href="${pageContext.request.contextPath}/main">IT 서비스데스크</a></h1>
            <div class="user-info">
                <span>${sessionScope.LOGIN_USER.user_nm != null ? sessionScope.LOGIN_USER.user_nm : sessionScope.LOGIN_USER.userNm}님</span>
                <a href="${pageContext.request.contextPath}/auth/logout">로그아웃</a>
            </div>
        </div>
    </div>

    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/main">홈</a>
            <span>></span>
            <span>자주 묻는 질문</span>
        </div>

        <h2 class="page-title">❓ 자주 묻는 질문</h2>

        <!-- 검색 섹션 -->
        <div class="search-section">
            <div class="search-box">
                <input type="text" id="searchInput" placeholder="궁금한 내용을 검색해보세요...">
                <button onclick="searchFAQ()">🔍 검색</button>
            </div>
        </div>

        <!-- 카테고리 탭 -->
        <div class="category-tabs">
            <div class="category-tab active" data-category="all">전체</div>
            <div class="category-tab" data-category="account">계정/로그인</div>
            <div class="category-tab" data-category="system">시스템 오류</div>
            <div class="category-tab" data-category="network">네트워크</div>
            <div class="category-tab" data-category="software">소프트웨어</div>
            <div class="category-tab" data-category="hardware">하드웨어</div>
            <div class="category-tab" data-category="etc">기타</div>
        </div>

        <!-- FAQ 목록 -->
        <div class="faq-container">
            <!-- 계정/로그인 관련 -->
            <div class="faq-item" data-category="account">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">🔑</span>
                        <span>비밀번호를 잊어버렸어요. 어떻게 재설정하나요?</span>
                        <span class="popular-badge">인기</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>비밀번호 재설정 방법</h4>
                        <p>다음 단계를 따라 비밀번호를 재설정할 수 있습니다:</p>
                        <ul>
                            <li>로그인 페이지에서 "비밀번호 찾기" 클릭</li>
                            <li>사용자 ID와 등록된 이메일 입력</li>
                            <li>이메일로 전송된 임시 비밀번호 확인</li>
                            <li>로그인 후 새로운 비밀번호로 변경</li>
                        </ul>
                        <p><strong>참고:</strong> 보안을 위해 임시 비밀번호는 24시간 후 만료됩니다.</p>
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="account">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">👤</span>
                        <span>계정 정보를 수정하고 싶어요.</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>계정 정보 수정 방법</h4>
                        <p>로그인 후 다음 경로로 이동하여 정보를 수정할 수 있습니다:</p>
                        <ul>
                            <li>메인 페이지 → "내 정보" 메뉴 클릭</li>
                            <li>수정 가능한 항목: 이름, 부서, 연락처, 이메일</li>
                            <li>비밀번호는 별도 메뉴에서 변경 가능</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 시스템 오류 관련 -->
            <div class="faq-item" data-category="system">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">⚠️</span>
                        <span>페이지가 로딩되지 않거나 오류가 발생해요.</span>
                        <span class="popular-badge">인기</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>페이지 로딩 오류 해결 방법</h4>
                        <p>다음 방법들을 순서대로 시도해보세요:</p>
                        <ul>
                            <li>브라우저 새로고침 (Ctrl + F5)</li>
                            <li>브라우저 캐시 및 쿠키 삭제</li>
                            <li>다른 브라우저에서 접속 시도</li>
                            <li>인터넷 연결 상태 확인</li>
                            <li>방화벽 또는 보안 프로그램 확인</li>
                        </ul>
                        <p>문제가 지속되면 IT 지원팀에 문의해주세요.</p>
                    </div>
                </div>
            </div>

            <div class="faq-item" data-category="system">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">🔄</span>
                        <span>시스템이 느려요. 어떻게 해야 하나요?</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>시스템 속도 개선 방법</h4>
                        <ul>
                            <li>불필요한 프로그램 종료</li>
                            <li>브라우저 탭 개수 줄이기</li>
                            <li>임시 파일 정리</li>
                            <li>컴퓨터 재시작</li>
                            <li>네트워크 상태 확인</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 네트워크 관련 -->
            <div class="faq-item" data-category="network">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">🌐</span>
                        <span>인터넷이 연결되지 않아요.</span>
                        <span class="new-badge">NEW</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>네트워크 연결 문제 해결</h4>
                        <ul>
                            <li>네트워크 케이블 연결 상태 확인</li>
                            <li>Wi-Fi 연결 상태 확인</li>
                            <li>네트워크 어댑터 재시작</li>
                            <li>IP 주소 갱신 (ipconfig /renew)</li>
                            <li>DNS 캐시 초기화 (ipconfig /flushdns)</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 소프트웨어 관련 -->
            <div class="faq-item" data-category="software">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">💻</span>
                        <span>프로그램 설치가 필요해요.</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>소프트웨어 설치 요청</h4>
                        <p>업무용 소프트웨어 설치는 다음 절차를 따라주세요:</p>
                        <ul>
                            <li>IT 서비스데스크에 설치 요청 등록</li>
                            <li>소프트웨어명, 버전, 사용 목적 명시</li>
                            <li>라이선스 정보 확인</li>
                            <li>보안 검토 후 설치 진행</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 하드웨어 관련 -->
            <div class="faq-item" data-category="hardware">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">🖥️</span>
                        <span>모니터가 켜지지 않아요.</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>모니터 문제 해결</h4>
                        <ul>
                            <li>전원 케이블 연결 확인</li>
                            <li>모니터 전원 버튼 확인</li>
                            <li>비디오 케이블 연결 상태 확인</li>
                            <li>다른 모니터로 테스트</li>
                            <li>그래픽 카드 드라이버 확인</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- 기타 -->
            <div class="faq-item" data-category="etc">
                <div class="faq-question">
                    <div class="question-text">
                        <span class="question-icon">📞</span>
                        <span>긴급한 문제가 발생했어요. 어떻게 연락하나요?</span>
                        <span class="popular-badge">인기</span>
                    </div>
                    <span class="toggle-icon">▼</span>
                </div>
                <div class="faq-answer">
                    <div class="answer-content">
                        <h4>긴급 상황 연락처</h4>
                        <ul>
                            <li><strong>IT 헬프데스크:</strong> 내선 1234</li>
                            <li><strong>긴급 상황:</strong> 내선 9999</li>
                            <li><strong>이메일:</strong> helpdesk@company.com</li>
                            <li><strong>운영 시간:</strong> 평일 09:00 ~ 18:00</li>
                        </ul>
                        <p>업무 시간 외에는 온라인으로 문의를 등록해주시면 다음 업무일에 처리됩니다.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- 문의하기 섹션 -->
        <div class="contact-section">
            <h3>💬 원하는 답변을 찾지 못하셨나요?</h3>
            <p>IT 지원팀이 직접 도움을 드리겠습니다.</p>
            <div class="contact-buttons">
                <a href="${pageContext.request.contextPath}/user/post/form?boardId=1" class="contact-btn">
                    📝 문의 등록하기
                </a>
                <a href="tel:1234" class="contact-btn">
                    📞 전화 문의 (내선 1234)
                </a>
                <a href="mailto:helpdesk@company.com" class="contact-btn">
                    📧 이메일 문의
                </a>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // FAQ 아코디언 기능
            $('.faq-question').click(function() {
                var $item = $(this).closest('.faq-item');
                var $answer = $item.find('.faq-answer');
                var $icon = $(this).find('.toggle-icon');

                if ($answer.hasClass('active')) {
                    $answer.removeClass('active');
                    $(this).removeClass('active');
                    $icon.removeClass('active');
                } else {
                    // 다른 열린 항목들 닫기
                    $('.faq-answer.active').removeClass('active');
                    $('.faq-question.active').removeClass('active');
                    $('.toggle-icon.active').removeClass('active');

                    // 현재 항목 열기
                    $answer.addClass('active');
                    $(this).addClass('active');
                    $icon.addClass('active');
                }
            });

            // 카테고리 탭 기능
            $('.category-tab').click(function() {
                var category = $(this).data('category');
                
                // 탭 활성화
                $('.category-tab').removeClass('active');
                $(this).addClass('active');

                // FAQ 항목 필터링
                if (category === 'all') {
                    $('.faq-item').show();
                } else {
                    $('.faq-item').hide();
                    $('.faq-item[data-category="' + category + '"]').show();
                }

                // 열린 답변들 닫기
                $('.faq-answer.active').removeClass('active');
                $('.faq-question.active').removeClass('active');
                $('.toggle-icon.active').removeClass('active');
            });

            // 검색 기능
            $('#searchInput').on('keyup', function(e) {
                if (e.keyCode === 13) {
                    searchFAQ();
                }
            });
        });

        function searchFAQ() {
            var searchTerm = $('#searchInput').val().toLowerCase();
            
            if (!searchTerm) {
                $('.faq-item').show();
                return;
            }

            $('.faq-item').each(function() {
                var questionText = $(this).find('.question-text span:not(.popular-badge):not(.new-badge)').text().toLowerCase();
                var answerText = $(this).find('.answer-content').text().toLowerCase();
                
                if (questionText.includes(searchTerm) || answerText.includes(searchTerm)) {
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });

            // 검색 결과가 없을 때
            if ($('.faq-item:visible').length === 0) {
                if ($('.no-results').length === 0) {
                    $('.faq-container').append(
                        '<div class="no-results" style="padding: 40px; text-align: center; color: #666;">' +
                        '<p>검색 결과가 없습니다.</p>' +
                        '<p>다른 키워드로 검색해보시거나 직접 문의해주세요.</p>' +
                        '</div>'
                    );
                }
            } else {
                $('.no-results').remove();
            }

            // 전체 탭으로 변경
            $('.category-tab').removeClass('active');
            $('.category-tab[data-category="all"]').addClass('active');
        }
    </script>
</body>
</html>