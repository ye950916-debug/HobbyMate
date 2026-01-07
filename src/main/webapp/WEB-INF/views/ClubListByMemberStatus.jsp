<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1" cellpadding="8" cellspacing="0">
    <thead>
        <tr>
            <th>모임명</th>
            <th>주 활동 지역</th>
            <th>가입상태</th>
            <th>모임 페이지</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="club" items="${clubs}">
            <tr>
                <td>${club.cName}</td>
                <td>${club.cSiDo} ${club.cGuGun} ${club.cDong }</td>
                <td>${status }</td>
                <td><a href="<c:url value='/club/home'/>?clubId=${club.cId}">이동</a></td>
            </tr>
        </c:forEach>
    </tbody>
	</table>
	<a href="<c:url value='/'/>">🏠 홈으로 돌아가기</a>
</body>
</html>