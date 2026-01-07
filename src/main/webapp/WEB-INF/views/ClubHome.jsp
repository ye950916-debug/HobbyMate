<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${club.cName} - 모임 홈</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>"> 
    <link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">

    <c:if test="${param.msg == 'applyAlready'}">
	    <script>alert("이미 가입신청 하셨습니다.");</script>
	</c:if>
	<c:if test="${param.msg == 'applySuccess'}">
	    <script>alert("가입 신청이 완료되었습니다. 리더의 승인을 기다려주세요.");</script>
	</c:if>
	<c:if test="${param.msg == 'leaveSuccess'}">
	    <script>alert("모임 탈퇴가 완료되었습니다.");</script>
	</c:if>
	<c:if test="${param.msg == 'leaderChanged'}">
	    <script>alert("리더 변경이 완료되었습니다.");</script>
	</c:if>
	<c:if test="${param.msg == 'leaderChangeFail'}">
	    <script>alert("리더 변경이 실패하였습니다.");</script>
	</c:if>
    <script>
        function confirmDelete() {
            return confirm('정말 [${club.cName}] 모임을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.');
        }
    </script>

</head>

<body class="pt-4 pb-4" style="background-color: #f4f7f6; color: #333; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;">
	
	<%@ include file="/WEB-INF/views/hobbymate-header.jsp" %>
	
	<div class="container p-0 shadow mt-7" style="max-width: 900px; background-color: white; border-radius: 10px;">
	
        <c:choose>
            <c:when test="${not empty club.cMainImageName}">
                <div style="height: 250px; overflow: hidden; position: relative;">
                    <img src="<c:url value='/resources/images/ClubMain/${club.cMainImageName}'/>"
                         alt="${club.cName} 대표 이미지"
                         class="img-fluid w-100" 
                         style="object-fit: cover; height: 100%; border-top-left-radius: 10px; border-top-right-radius: 10px;">
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-flex justify-content-center align-items-center" style="height: 250px; background-color: #ccc; border-top-left-radius: 10px; border-top-right-radius: 10px;">
                </div>
            </c:otherwise>
        </c:choose>

        <div class="px-4 pt-3 pb-4"> <header class="main-header text-center" style="padding: 30px 0 20px 0; border-bottom: 2px solid #e0e7ff; margin-bottom: 20px;">
                <h1 class="main-title-text" style="font-size: 2.5em; font-weight: 800; color: #1a237e; margin-bottom: 5px;"><i class="fas fa-handshake"></i> ${club.cName}</h1>
                <p class="main-subtitle-text" style="color: #7986cb; font-size: 1.1em; font-weight: 500;">모임 리더: ${leaderId}</p>
            </header>
        
            <div class="section-box" style="padding: 20px 0;">
                <h2 class="section-title" style="font-size: 1.5em; font-weight: 700; color: #303f9f; padding-bottom: 5px; margin-bottom: 15px; margin-top: 0; display: flex; align-items: center;">
                    <i class="fas fa-info-circle me-2" style="margin-right: 10px;"></i> 모임 정보
                </h2>
                
                <ul class="club-info-list-inline list-unstyled d-flex flex-wrap p-0 m-0">
                    <li class="col-6 mb-2" style="font-size: 1em; color: #555; display: flex; align-items: center; box-sizing: border-box;">
                        <i class="fas fa-align-left me-2" style="color: #5c6bc0; font-size: 1.1em; width: 20px; text-align: center;"></i> 
                        소개: <strong style="color: #333; font-weight: 600; margin-left: 5px;">${club.cDescription}</strong>
                    </li>
                     <li class="col-6 mb-2" style="font-size: 1em; color: #555; display: flex; align-items: center; box-sizing: border-box;">
                        <i class="fas fa-users me-2" style="color: #5c6bc0; font-size: 1.1em; width: 20px; text-align: center;"></i> 
                        현재 인원: <strong style="color: #333; font-weight: 600; margin-left: 5px;">${club.cMemberCount}</strong> / ${club.cMaxMembers}명
                    </li>
                    <li class="col-6 mb-2" style="font-size: 1em; color: #555; display: flex; align-items: center; box-sizing: border-box;">
                        <i class="fas fa-map-marker-alt me-2" style="color: #5c6bc0; font-size: 1.1em; width: 20px; text-align: center;"></i> 
                        지역: <strong style="color: #333; font-weight: 600; margin-left: 5px;">${club.cSiDo} ${club.cGuGun} ${club.cDong}</strong>
                    </li>
                    <li class="col-6 mb-2" style="font-size: 1em; color: #555; display: flex; align-items: center; box-sizing: border-box;">
                        <i class="fas fa-street-view me-2" style="color: #5c6bc0; font-size: 1.1em; width: 20px; text-align: center;"></i> 
                        주 모임 장소: <strong style="color: #333; font-weight: 600; margin-left: 5px;">${club.cMainPlace}</strong>
                    </li>
                </ul>
	        
                <div class="action-buttons d-flex flex-wrap gap-2 mt-4">
                   	<c:if test="${not empty sessionScope.loginMember and isMember eq 'NONE'}">
                      <a href="<c:url value='/clubmember/join?cmCId=${club.cId }'/>" class="btn-primary d-inline-flex align-items-center"
                         style="padding: 10px 18px; border-radius: 6px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; background-color: #5c6bc0; color: white;">
                              <i class="fas fa-user-plus me-1"></i> 모임 가입 신청하기
                      </a>
                    </c:if>
                      
                      <c:if test="${not empty sessionScope.loginMember and isMember eq 'A' and sessionScope.loginMember.mId ne leaderId}">
                      	<a href="<c:url value='/clubmember/leaveClub?clubId=${club.cId }'/>" class="btn-primary d-inline-flex align-items-center"
                         style="padding: 10px 18px; border-radius: 6px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; background-color: #5c6bc0; color: white;">
                              <i class="fas fa-user-minus me-1"></i> 모임 탈퇴 신청하기
                         </a>
                      </c:if>
                      
                      <c:if test="${not empty sessionScope.loginMember and isMember eq 'W' and sessionScope.loginMember.mId ne leaderId}">
	                      <button disabled 
	                         class="d-inline-flex align-items-center"
	                         style="padding: 10px 18px; border-radius: 6px; font-weight: 600; text-decoration: none; border: none; 
	                                background-color: #5c6bc0; color: white; /* 기본 배경/글자색 */
	                                opacity: 0.7; /* 비활성화 상태임을 표시하기 위해 투명도 추가 */
	                                cursor: not-allowed; /* 마우스 커서 변경 */">
	                              <i class="fas fa-user me-1"></i> 가입 승인 대기중
	                      </button>
                      </c:if>
                      
                      <c:if test="${not empty sessionScope.loginMember and isMember eq 'R' and sessionScope.loginMember.mId ne leaderId}">
                    	  <a href="<c:url value='/clubmember/join?cmCId=${club.cId }'/>" class="btn-primary d-inline-flex align-items-center"
                       		  style="padding: 10px 18px; border-radius: 6px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; background-color: #5c6bc0; color: white;">
                              <i class="fas fa-user-plus me-1"></i> 모임 가입 신청하기
                          </a>
                      </c:if>
	
	                <c:if test="${sessionScope.loginMember.mId eq leaderId || sessionScope.loginMember.mRole eq 'ADMIN'}">
                        <div class="admin-buttons d-flex flex-wrap gap-2 pt-3 mt-3 w-100" style="border-top: 1px dashed #eee;">
                            
                            <form action="${pageContext.request.contextPath}/club/update" method="get" style="display:inline;">
	                            <input type="hidden" name="clubId" value="${club.cId}">
	                            <button type="submit" class="btn-secondary d-inline-flex align-items-center"
                                    style="padding: 10px 18px; border-radius: 6px; font-weight: 600; border: none; background-color: #e8eaf6; color: #3f51b5; cursor: pointer;">
	                                <i class="fas fa-edit me-1"></i> 모임 정보 수정
	                            </button>
	                        </form>
	
	                        <form action="${pageContext.request.contextPath}/clubmember/manage" method="get" style="display:inline;">
	                            <input type="hidden" name="clubId" value="${club.cId}">
	                            <button type="submit" class="btn-secondary d-inline-flex align-items-center"
                                    style="padding: 10px 18px; border-radius: 6px; font-weight: 600; border: none; background-color: #e8eaf6; color: #3f51b5; cursor: pointer;">
	                                <i class="fas fa-user-cog me-1"></i> 회원 관리
	                            </button>
	                        </form>
	
	                        <form action="${pageContext.request.contextPath}/clubmember/changeleader" method="get" style="display:inline;">
	                            <input type="hidden" name="clubId" value="${club.cId}">
	                            <button type="submit" class="btn-secondary d-inline-flex align-items-center"
                                    style="padding: 10px 18px; border-radius: 6px; font-weight: 600; border: none; background-color: #e8eaf6; color: #3f51b5; cursor: pointer;">
	                                <i class="fas fa-exchange-alt me-1"></i> 리더 변경
	                            </button>
	                        </form>
	                        
	                        <form action="${pageContext.request.contextPath}/club/delete" method="post" 
	                              style="display:inline;" onsubmit="return confirmDelete();">
	                            <input type="hidden" name="clubId" value="${club.cId}">
                                <button type="submit" class="btn-primary d-inline-flex align-items-center" 
                                    style="padding: 10px 18px; border-radius: 6px; font-weight: 600; border: none; background-color:#d32f2f; color: white; cursor: pointer;">
	                                <i class="fas fa-trash-alt me-1"></i> 모임 삭제
	                            </button>
	                        </form>
	                    </div>
	                </c:if>
	            </div>
	        </div>
	    
	        <hr class="divider" style="border: 0; height: 1px; background-color: #ddd; margin: 20px 0;">
	    
            <div class="section-box" style="padding: 20px 0;">
                <h2 class="section-title" style="font-size: 1.5em; font-weight: 700; color: #303f9f; padding-bottom: 5px; margin-bottom: 15px; margin-top: 0; display: flex; align-items: center;">
                    <i class="fas fa-calendar-alt me-2" style="margin-right: 10px;"></i> 모임 일정
                </h2>
	        
	            <c:if test="${empty schedules}">
                    <p class="no-data" style="color: #777; padding: 15px; background-color: #fcfcfc; border-radius: 6px; border: 1px dashed #ddd;">등록된 일정이 없습니다.</p>
	            </c:if>
	        
	            <c:if test="${not empty schedules}">
                    <table class="data-table table" style="width: 100%; border-collapse: collapse; font-size: 0.95em; text-align: left; margin-bottom: 10px;">
	                    <thead>
                            <tr style="background-color: #f8f8f8; color: #303f9f; font-weight: 600;">
	                            <th style="padding: 12px 15px;">제목</th>
	                            <th style="width: 35%; padding: 12px 15px;">시간</th>
	                            <th style="width: 15%; padding: 12px 15px;">참가 인원</th>
	                            <th style="width: 15%; padding: 12px 15px;">상세보기</th>
	                        </tr>
	                    </thead>
	                    <tbody>
                            <c:forEach var="s" items="${schedules}" varStatus="st">
                                <tr style="border-bottom: 1px solid #eee;">
	                                <td style="padding: 12px 15px;">${s.eventTitle}</td>
	                                <td style="padding: 12px 15px;">${s.startTime.monthValue}/${s.startTime.dayOfMonth} <spring:eval expression="s.startTime.hour" />:<spring:eval expression="s.startTime.minute" /> ~ 
								        <spring:eval expression="s.endTime.hour" />:<spring:eval expression="s.endTime.minute" />
								    </td>
	                                <td style="padding: 12px 15px;">${currentCounts[st.index]}</td>
	                                <td style="padding: 12px 15px;">
                                        <c:if test="${isMember eq 'A' or sessionScope.loginMember.mRole eq 'ADMIN' }">
	                                        <a href="${pageContext.request.contextPath}/schedule/detail/${s.eventNo}" style="color: #5c6bc0; text-decoration: none;">
		                                        자세히 보기 <i class="fas fa-chevron-right" style="font-size: 0.8em;"></i>
		                                    </a>
	                                    </c:if>
	                                    <c:if test="${isMember ne 'A' and sessionScope.loginMember.mRole ne 'ADMIN' }">
	                                        <span class="text-danger fw-semibold">
										        회원공개
										    </span>
	                                    </c:if>
	                                </td>
	                            </tr>
	                        </c:forEach>
	                    </tbody>
	                </table>
	            </c:if>
	        
	            <c:if test="${sessionScope.loginMember.mId eq leaderId}">
	                <div class="mt-3" style="margin-top: 15px;">
                        <a href="${pageContext.request.contextPath}/schedule/add/${club.cId}" class="btn-primary d-inline-flex align-items-center"
                           style="padding: 10px 18px; border-radius: 6px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; background-color: #5c6bc0; color: white;">
	                        <i class="fas fa-plus-circle me-1"></i> 일정 추가하기
	                    </a>
	                </div>
	            </c:if>
	        </div>
	    
            <hr class="divider" style="border: 0; height: 1px; background-color: #ddd; margin: 20px 0;">
	    
            <div class="section-box" style="padding: 20px 0;">
                <h2 class="section-title" style="font-size: 1.5em; font-weight: 700; color: #303f9f; padding-bottom: 5px; margin-bottom: 15px; margin-top: 0; display: flex; align-items: center;">
                    <i class="fas fa-comments me-2" style="margin-right: 10px;"></i> 게시글 목록
                </h2>
	        
	            <c:forEach var="m" items="${members }">
	                <c:if test="${sessionScope.loginMember.mId eq m.cmMId}">
                        <a href="${pageContext.request.contextPath}/post/write/${club.cId}" class="btn-primary d-inline-flex align-items-center" 
                           style="padding: 10px 18px; border-radius: 6px; font-weight: 600; text-decoration: none; cursor: pointer; border: none; background-color: #5c6bc0; color: white; margin-bottom: 15px;">
	                        <i class="fas fa-pencil-alt me-1"></i> 글 작성하기
	                    </a>
	                    <br>
	                </c:if>
	            </c:forEach>
	        
	            <c:if test="${empty posts}">
                    <p class="no-data" style="color: #777; padding: 15px; background-color: #fcfcfc; border-radius: 6px; border: 1px dashed #ddd;">등록된 게시글이 없습니다.</p>
	            </c:if>
	        
	            <c:if test="${not empty posts}">
                    <table class="data-table table" style="width: 100%; border-collapse: collapse; font-size: 0.95em; text-align: left; margin-bottom: 10px;">
	                    <thead>
                            <tr style="background-color: #f8f8f8; color: #303f9f; font-weight: 600;">
	                            <th style="width: 10%; padding: 12px 15px;">번호</th>
	                            <th style="width: 50%; padding: 12px 15px;">제목</th>
	                            <th style="width: 15%; padding: 12px 15px;">작성자</th>
	                            <th style="width: 15%; padding: 12px 15px;">작성일</th>
	                            <th style="width: 10%; padding: 12px 15px;">조회수</th>
	                        </tr>
	                    </thead>
	                    <tbody>
	                        <c:forEach var="post" items="${posts}" varStatus="st">
                                <tr style="border-bottom: 1px solid #eee;">
	                                <td style="padding: 12px 15px;">${post.postId}</td>
	                                <td style="padding: 12px 15px;">
                                        <a href="${pageContext.request.contextPath}/post/detail/${post.postId}" style="color: #5c6bc0; text-decoration: none;">
	                                        ${post.postTitle}
	                                    </a>
	                                </td>
	                                <td style="padding: 12px 15px;">${post.postMId}</td> 
	                                <td style="padding: 12px 15px;">
                                        <spring:eval expression="T(java.time.format.DateTimeFormatter).ofPattern('yy.MM.dd').format(post.postCreatedDate)" />
                                    </td>
	                                <td style="padding: 12px 15px;">${post.postViewCount}</td>
	                            </tr>
	                        </c:forEach>
	                    </tbody>
	                </table>
	            </c:if>
	        </div>
	
            <hr class="divider" style="border: 0; height: 1px; background-color: #ddd; margin: 20px 0;">
	
            <div class="section-box" style="padding: 20px 0;">
                <h2 class="section-title" style="font-size: 1.5em; font-weight: 700; color: #303f9f; padding-bottom: 5px; margin-bottom: 15px; margin-top: 0; display: flex; align-items: center;">
                    <i class="fas fa-users me-2" style="margin-right: 10px;"></i> 현재 모임 멤버
                </h2>
	        
	            <c:if test="${empty members}">
                    <p class="no-data" style="color: #777; padding: 15px; background-color: #fcfcfc; border-radius: 6px; border: 1px dashed #ddd;">아직 승인된 회원이 없습니다.</p>
	            </c:if>
	        
	            <c:if test="${not empty members}">
                    <ul class="member-list list-unstyled d-flex flex-wrap gap-2 p-0">
	                    <c:forEach var="m" items="${members}">
                            <li style="background-color: #e8eaf6; color: #3f51b5; padding: 6px 12px; border-radius: 20px; font-size: 0.9em; font-weight: 500;">
	                            ${m.cmMId}
                                <c:if test="${m.cmMId eq leaderId}">
	                                <span class="leader-tag" style="font-weight: 700; color: #d32f2f; margin-left: 5px;">(리더)</span>
	                            </c:if>
	                        </li>
	                    </c:forEach>
	                </ul>
	            </c:if>
	        </div>
	    
            <div class="text-center" style="padding: 20px 0;">
	            <a href="<c:url value='/'/>" class="back-to-home text-decoration-none" style="color: #333;">
	                <i class="fas fa-home me-1"></i> 홈으로 돌아가기
	            </a>
	        </div>
        </div>
	
	</div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>