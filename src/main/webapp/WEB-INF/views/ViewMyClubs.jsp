<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 나중에 본인 이 그룹장인 그룹 리스트로 뜨게 하고 상세 누르면 해당 그룹 세부정보 뷰 뿌리도록 수정 -->
	<c:if test="${not empty myClubs}">
	    <table class="table">
	        <thead>
	            <tr>
	                <th>모임 이름</th>
	                <th>지역</th>
	                <th>주 모임 장소</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="club" items="${myClubs}">
	                <tr>
	                    <td>${club.cName}</td>
	                    <td>
							<c:if test="${not empty club.cSiDo and not empty club.cGuGun}">
								${club.cSiDo} ${club.cGuGun} 
								<c:if test="${not empty club.cDong}">
									${club.cDong}
								</c:if>
							</c:if>
							<c:if test="${empty club.cSiDo or empty club.cGuGun}">
								(지역 정보 없음)
							</c:if>
						</td>
	                    <td>${club.cMainPlace}</td>
	                    <td><a href="<c:url value='/club/home?clubId=${club.cId }' />">모임 페이지</a></td>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
	</c:if>
	<a href="<c:url value='/'/>">🏠 홈으로 돌아가기</a>
	<br>
	
</body>
</html>