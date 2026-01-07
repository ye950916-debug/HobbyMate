<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 가입</title>
</head>
<body>
	<c:if test="${not empty errorMessage}">
	    <script type="text/javascript">
	        alert("${errorMessage}");
	        window.location.href = "<c:url value='/club/viewallclubs' />"; // ViewAllClubs.jsp로 이동
	    </script>
	</c:if>

	<h2>모임 가입</h2>
	
	<p>모임 이름 : ${club.cName}</p>
	<p>지역 : ${club.cLocation }</p>
	
	
	<form action="<c:url value='/clubmember/join' />" method="post">
		<input type="hidden" name="cmCId" value="${JoinClub.cmCId}" />
		<input type="text" name="cmMId" value="${JoinClub.cmMId}" readonly />
		<input type="text" name="cmRole" value="MEMBER" readonly />
		<input type="submit" value="가입신청" />
	</form>
</body>
</html>