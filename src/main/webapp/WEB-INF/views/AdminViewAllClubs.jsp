<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 모임 목록</title>
</head>
<body>
	
	<h2>전체 모임 목록</h2>

	<form action="<c:url value='/club/allclubs' />" method="get">
		<label>카테고리: </label>
		<select name="category">
	        <option value="">전체</option>
	        <option value="운동" ${selectedCategory == '운동' ? 'selected' : ''}>운동</option>
	        <option value="공부" ${selectedCategory == '공부' ? 'selected' : ''}>공부</option>
	        <option value="공예" ${selectedCategory == '공예' ? 'selected' : ''}>공예</option>
	        <option value="여행" ${selectedCategory == '여행' ? 'selected' : ''}>여행</option>
	        <option value="봉사" ${selectedCategory == '봉사' ? 'selected' : ''}>봉사</option>
	        <option value="독서" ${selectedCategory == '독서' ? 'selected' : ''}>독서</option>
	    </select>
	    <label>지역: </label>
   		<input type="text" name="location" value="${selectedLocation}" placeholder="예: 서울, 부산 등"/>
	    
    	<button type="submit">검색</button>
	</form>
	<br>
	<table border="1">
	    <tr>
	        <th>모임 이름</th>
	        <th>모임장 ID</th>
	        <th>생성일</th>
	        <th>분류</th>
	        <th>지역</th>
	    </tr>
	
	    <c:forEach var="club" items="${clubs}">
	        <tr>
	            <td>${club.cName}</td>
	            <td>${club.cLeaderId}</td>
	            <td>${club.cCreateDate}</td>
	            <td>${club.cCategory}</td>
	            <td>${club.cLocation}</td>
	            <td><a href="<c:url value='/club/readone?clubId=${club.cId }' />">상세정보보기</a></td>
	        </tr>
	    </c:forEach>
	</table>
</body>
</html>