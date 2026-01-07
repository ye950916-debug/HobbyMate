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
            <th>모임 이름</th>
            <th>지역</th>
            <th>가입상태</th>
            <th>모임 정보</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="club" items="${myclubs}">
            <tr>
                <td>${club.cName}</td>
                <td>${club.cLocation}</td>
                <td>${statusMap[club.cId]}</td>
                <td><a href="<c:url value='/club/home'/>?clubId=${club.cId}">모임 홈</a></td>
            </tr>
        </c:forEach>
    </tbody>
	</table>
	<c:if test="${param.msg == 'leaveSuccess'}">
	    <script>
	        alert("모임 탈퇴가 완료되었습니다.");
	    </script>
	</c:if>
	<a href="<c:url value='/'/>">🏠 홈으로 돌아가기</a>
</body>
</html>