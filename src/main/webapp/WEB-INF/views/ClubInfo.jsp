<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<p>모임 이름: ${club.cName}</p>
	<p>설명: ${club.cDescription}</p>
	<p>분류: ${club.cCategory}</p>
	<p>지역: ${club.cLocation}</p>
	<p>최대 인원: ${club.cMaxMembers}</p>
	<p>생성일: ${club.cCreateDate}</p>
	<c:if test="${not empty sessionScope.loginMember and sessionScope.loginMember.mId eq club.cLeaderId}">
		<!-- 수정 버튼 form -->
		<form action="<c:url value='/club/update' />" method="get" style="display:inline;">
		    <input type="hidden" name="clubId" value="${club.cId}" />
		    <button type="submit">수정하기</button>
		</form>
	
		<!-- 삭제 버튼 form -->
		<form action="${pageContext.request.contextPath}/club/delete" method="post" style="display:inline;" 
		      onsubmit="return confirm('정말 삭제하시겠습니까?');">
		    <input type="hidden" name="clubId" value="${club.cId}" />
		    <button type="submit">삭제하기</button>
		</form>
	</c:if>
	<c:if test="${empty sessionScope.loginMember or sessionScope.loginMember.mId ne leaderId}">
    	<a href="<c:url value='/clubmember/join?cmCId=${club.cId }'/>">모임 가입하기</a>
	</c:if>
</body>
</html>