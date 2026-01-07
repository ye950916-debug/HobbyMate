<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 탈퇴 불가</title>
</head>
<body>

<h2>회원 탈퇴 불가</h2>
<p>
	현재 회원님은 아래 모임의 리더입니다.
	리더 권한을 위임하거나, 모임을 정리한 후 탈퇴할 수 있습니다.
</p>

<ul>
	<c:forEach var="club" items="${leaderClubs}">
		<li>
			${club.cName}
			<a href="${pageContext.request.contextPath}/club/delegate/${club.cId}">
				리더 위임하러 가기
			</a>
		</li>
	</c:forEach>
</ul>

<a href="<c:url value='/member/${sessionScope.loginMember.mId}'/>">
    내 정보 수정 돌아가기
</a>

</body>
</html>