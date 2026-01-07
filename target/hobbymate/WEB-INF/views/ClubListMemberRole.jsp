<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	
	<c:if test="${not empty myClubs}">
	    <table class="table">
	        <thead>
	            <tr>
	                <th>모임 이름</th>
	                <th>모임 소개</th>
	                <th>최대 멤버 수</th>
	                <th>모임 생성 일시</th>
	                <th>지역</th>
	                <th>주 모임 장소</th>
	            </tr>
	        </thead>
	        <tbody>
	            <c:forEach var="club" items="${myClubs}">
	                <tr>
	                    <td>${club.cName}</td>
	                    <td>${club.cDescription}</td>
	                    <td>${club.cMaxMembers}</td>
	                    <td>${club.cCreateDate}</td>
	                    <td>${club.cLocation}</td>
	                    <td>${club.cMainPlace}</td>
	                    <td><a href="<c:url value='/club/home?clubId=${club.cId }' />">모임 홈</a></td>
	                </tr>
	            </c:forEach>
	        </tbody>
	    </table>
	</c:if>
	<a href="<c:url value='/'/>">🏠 홈으로 돌아가기</a>
	<br>
	
</body>
</html>