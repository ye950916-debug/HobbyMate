<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원님을 위한 추천 모임</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <style>
        /* ---------------------------------------------------- */
        /* 1. 전체 페이지 기본 스타일 */
        /* ---------------------------------------------------- */
		body {
	        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
	        background-color: #f4f7f6; 
	        color: #333;
	        min-height: 100vh;
	        /* 추가: AJAX로 로드되므로 혹시 모를 body 마진/패딩을 제거 */
	        margin: 0 !important;
	        padding: 0 !important;
	    }
	    .container {
	        max-width: 1000px;
	        margin: 0 auto;
	        padding: 0 20px;
	        /* 추가: 컨테이너 자체의 상하 마진을 제거 */
	        margin-top: 0 !important;
	        margin-bottom: 0 !important;
	    }

        /* ---------------------------------------------------- */
        /* 2. 헤더 및 강조 영역 스타일 */
        /* ---------------------------------------------------- */
        header {
            text-align: center;
            margin-bottom: 40px;
        }
        .main-title {
            font-size: 1.8em;
            font-weight: 700;
            color: #303f9f;
            margin-bottom: 5px;
        }
        .sub-description {
            font-size: 1em;
            color: #666;
            margin-bottom: 15px;
        }

        /* 지역 강조 스타일 */
        .highlight-region {
            display: inline-block;
            background-color: #e8eaf6;
            color: #3f51b5; 
            font-weight: 600;
            padding: 4px 10px;
            border-radius: 6px;
            margin-left: 5px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        
        /* ---------------------------------------------------- */
        /* 3. 리스트형 카드 스타일 (전체 모임 뷰와 동일) */
        /* ---------------------------------------------------- */
        .club-list {
            display: flex;
            flex-direction: column;
            gap: 15px; /* 항목 사이 간격 */
        }

        /* 개별 모임 리스트 항목 (가로형 카드) 스타일 */
        .club-item {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            padding: 20px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: box-shadow 0.2s;
        }
        .club-item:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }

        /* 모임 기본 정보 영역 (왼쪽) */
        .club-main-info {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            min-width: 0;
            margin-right: 20px;
        }

        /* 모임 이름 */
        .club-name {
            font-size: 1.4em;
            font-weight: 700;
            color: #303f9f;
            margin-bottom: 5px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* 카테고리 태그 컨테이너 */
        .category-tags {
            margin-bottom: 8px;
        }
        /* 카테고리 태그 */
        .category-tag {
            display: inline-block;
            background-color: #f1f3f7; 
            color: #5c6bc0; 
            padding: 4px 10px;
            border-radius: 15px;
            font-size: 0.85em;
            font-weight: 500;
            white-space: nowrap;
        }
        
        /* 모임 설명 */
        .club-description {
            font-size: 0.9em;
            color: #666;
            margin-top: 10px;
            line-height: 1.4;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 1;
            -webkit-box-orient: vertical;
        }

        /* 추가된 정보 (리더, 지역, 장소) 가로 정렬 */
        .club-details {
            display: flex;
            gap: 15px;
            font-size: 0.9em;
            color: #555;
            margin-top: 10px;
        }
        .club-details i {
            margin-right: 3px;
            color: #7986cb;
        }
        .detail-item {
            white-space: nowrap;
        }
        
        /* 멤버 수 및 액션 버튼 영역 (오른쪽) */
        .club-right-section {
            display: flex;
            align-items: center;
            gap: 20px;
            padding-left: 20px;
            flex-shrink: 0;
        }
        
        /* 멤버 수 컨테이너 */
        .member-status-container {
            width: 120px; 
            text-align: right;
        }

        /* 멤버 수 텍스트 */
        .member-count-text {
            font-size: 0.9em;
            font-weight: 600;
            color: #555;
            white-space: nowrap;
            display: block;
            margin-bottom: 5px;
        }
        .member-count-text span {
            color: #303f9f;
        }

        /* 멤버 수 진행 바 (Progress Bar) */
        .progress-bar {
            height: 6px;
            background-color: #e0e0e0;
            border-radius: 3px;
            overflow: hidden;
            width: 100%;
        }
        .progress-bar-fill {
            height: 100%;
            background-color: #5c6bc0;
            transition: width 0.4s;
        }
        
        /* 상세 보기 버튼 */
        .btn-detail {
            padding: 10px 20px;
            background-color: #5c6bc0;
            color: white;
            font-weight: 600;
            border-radius: 6px;
            text-decoration: none;
            transition: background-color 0.2s;
        }
        .btn-detail:hover {
            background-color: #3f51b5;
        }

        /* 모임 없음 메시지 스타일 */
        .no-club-message {
            text-align: center;
            padding: 40px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06);
        }
        .no-club-message h3 {
            font-size: 1.2em;
            font-weight: 600;
            color: #303f9f;
            margin-top: 10px;
            margin-bottom: 5px;
        }
        .btn-explore {
            display: inline-block;
            padding: 10px 20px;
            background-color: #5c6bc0;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <div class="container">
        <header>
            <h1 class="main-title">
                <c:out value="${memberId}" />님을 위한 모임 추천
            </h1>
            <p class="sub-description">
                선택하신 관심 카테고리를 기반으로 추천된 모임 목록입니다.
            </p>
        </header>

        <c:choose>
            <%-- 1. 추천 모임이 있는 경우 --%>
            <c:when test="${not empty recommendedClubs}">
                <div class="club-list">
                    <c:forEach var="club" items="${recommendedClubs}" varStatus="status">
                        <c:set var="currentMembers" value="${club.cMemberCount}" />
                        <c:set var="maxMembers" value="${club.cMaxMembers}" />
                        <c:set var="progress" value="${(currentMembers / maxMembers) * 100}" /> 
                        
                        <div class="club-item">
                            
                            <div class="club-main-info">
                                <h2 class="club-name" title="${club.cName}">
                                    <c:out value="${club.cName}" /> 
                                </h2>
                                
                                <div class="category-tags">
			                        <c:if test="${not empty club.subName}">
			                            <span class="category-tag">${club.largeName} &gt;  ${club.midName} &gt; ${club.subName}</span>
			                        </c:if>
			                    </div>
                                
                                <p class="club-description" title="${club.cDescription}">
                                    <c:out value="${club.cDescription}" />
                                </p>
                                
                                <div class="club-details">
			                        <div class="detail-item">
			                            <i class="fas fa-user-circle"></i> 리더: <strong>${club.leaderId}</strong>
			                        </div>
			                        <div class="detail-item">
			                            <i class="fas fa-map-marker-alt"></i> 지역: ${club.cSiDo} ${club.cGuGun}
			                        </div>
			                        <div class="detail-item">
			                            <i class="fas fa-street-view"></i> 주 활동 장소: ${club.cMainPlace}
			                        </div>
			                    </div>
                            </div>
                            
                            <div class="club-right-section">
                                
                                <div class="member-status-container">
                                    <span class="member-count-text">
                                        <c:out value="${currentMembers}" />/<c:out value="${maxMembers}" />명
                                    </span>
                                    <div class="progress-bar">
                                        <div class="progress-bar-fill" style="width: ${progress}%"></div>
                                    </div>
                                </div>

                                <a href="<c:url value="/club/home?clubId=${club.cId}" />" 
                                   class="btn-detail">
                                    상세 보기
                                </a>
                            </div>
                            
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            
            <%-- 2. 추천 모임이 없는 경우 --%>
            <c:otherwise>
                <div class="no-club-message">
                    <i class="fas fa-box-open fa-3x mb-3" style="color: #ccc;"></i>
                    <h3>추천 모임 없음</h3>
                    <p class="mt-1 text-sm text-gray-500">
                        현재 회원님의 관심 카테고리와 일치하며 모집 중인 모임이 없습니다.
                    </p>
                    <div class="mt-4">
                        <a href="<c:url value="/club/viewallclubs" />" 
                           class="btn-explore">
                            전체 모임 탐색하기
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>