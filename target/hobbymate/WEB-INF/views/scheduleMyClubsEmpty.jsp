<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 없음</title>
</head>
<body>

	<h2>😢 현재 가입된 모임이 없습니다</h2>
	
	<p>새로운 모임에 가입해보세요!</p>
	<a href="<c:url value='/club/viewallclubs'/>">모임 가입하러 가기</a>

</body>
</html>