<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 상세 정보</title>
</head>
<body>
	<p>모임 이름: ${club.cName}</p>
	<p>설명: ${club.cDescription}</p>
	<p>지역: ${club.cLocation}</p>
	<p>최대 인원: ${club.cMaxMembers}</p>
	<p>가입일: ${clubmember.cmJoinDate}</p>

	<c:if test="${empty sessionScope.loginMember or sessionScope.loginMember.mId ne club.cLeaderId and sessionScope.loginMember.mRole ne 'ADMIN'}">
		<form action="<c:url value='/clubmember/leaveClub'/>" method="post" onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
		    <input type="hidden" name="clubId" value="${club.cId}">
		    <button type="submit">모임 탈퇴하기</button>
		</form>
	</c:if>
	<c:if test="${param.msg == 'notLeader'}">
	    <script>
	        alert("해당 모임의 그룹장이 아닙니다. 리더 변경 권한이 없습니다.");
	    </script>
	</c:if>
	<a href="${pageContext.request.contextPath}/clubmember/readsome?loginId=${sessionScope.loginMember.mId}">가입한 모임 목록으로 돌아가기</a>
</body>
</html>