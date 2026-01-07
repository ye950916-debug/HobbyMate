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
	<p>지역: 
		<c:if test="${not empty club.cSiDo and not empty club.cGuGun}">
			${club.cSiDo} ${club.cGuGun} 
			<c:if test="${not empty club.cDong}">
				${club.cDong}
			</c:if>
		</c:if>
		<c:if test="${empty club.cSiDo or empty club.cGuGun}">
			(지역 정보 없음)
		</c:if>
	</p>
	<p>최대 인원: ${club.cMaxMembers}</p>
	<p>생성일: ${club.cCreateDate}</p>
	<p>분류 : </p>
	<c:forEach var="entry" items="${categoryHierarchy }">
		<c:set var="sub" value="${entry.value[0]}" />
		<c:set var="mid" value="${entry.value[1]}" />
		<c:set var="top" value="${entry.value[2]}" />

		${top.ctName} > ${mid.ctName} > ${sub.ctName}
		<br/>
	</c:forEach>

	<!-- 그룹장 -->
	<c:if test="${not empty sessionScope.loginMember and sessionScope.loginMember.mId eq realLeaderId}">	
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
		
		<form action="${pageContext.request.contextPath}/clubmember/manage" method="get" style="display:inline;">
		    <input type="hidden" name="clubId" value="${club.cId}" />
		    <button type="submit">회원관리</button>
		</form>
		
		<form action="${pageContext.request.contextPath}/clubmember/changeleader" method="get" style="display:inline;">
		    <input type="hidden" name="clubId" value="${club.cId}" />
		    <button type="submit">리더변경</button>
		</form>

	</c:if>
	
	<!-- 관리자 -->
	<c:if test="${not empty sessionScope.loginMember and sessionScope.loginMember.mRole eq 'ADMIN'}">	
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
		
		<!-- 회원 관리 form -->
		<form action="${pageContext.request.contextPath}/clubmember/manage" method="get" style="display:inline;">
		    <input type="hidden" name="clubId" value="${club.cId}" />
		    <button type="submit">회원관리</button>
		</form>
		
		<!-- 리더 변경 form -->
		<form action="${pageContext.request.contextPath}/clubmember/admin/changeleader" method="get" style="display:inline;">
		    <input type="hidden" name="clubId" value="${club.cId}" />
		    <button type="submit">리더변경</button>
		</form>
	</c:if>
	<c:if test="${not empty param.msg}">
	    <script>
	        let msg = "${param.msg}";
	
	        if (msg === "adminLeaderChanged") {
	            alert("관리자가 모임 리더를 변경했습니다.");
	        }
	        else if (msg === "noAdmin") {
	            alert("관리자만 이 기능을 사용할 수 있습니다.");
	        }
	    </script>
	</c:if>
	
	
	<!-- 일반회원 -->
	<c:if test="${empty sessionScope.loginMember or sessionScope.loginMember.mId ne club.cLeaderId and sessionScope.loginMember.mRole ne 'ADMIN'}">
    	<a href="<c:url value='/clubmember/join?cmCId=${club.cId }'/>" onclick="return confirm('이 모임에 가입 신청하시겠습니까?')">모임 가입하기</a>
	</c:if>
	<c:if test="${param.msg == 'applyAlready'}">
	    <script>alert("이미 가입신청 하셨습니다.");</script>
	</c:if>
	<c:if test="${param.msg == 'applySuccess'}">
	    <script>
	        alert("가입 신청이 완료되었습니다.");
	    </script>
	</c:if>
	<br>
	<a href="<c:url value='/'/>">🏠 홈으로 돌아가기</a>
	
	<c:if test="${param.msg == 'leaderChangeFail'}">
	    <script>
	        alert("리더 변경이 실패하였습니다.");
	    </script>
	</c:if>
	<c:if test="${param.msg == 'leaderChanged'}">
	    <script>
	        alert("리더 변경이 완료되었습니다.");
	    </script>
	</c:if>
	
	<a href="<c:url value='/club/home?clubId=${club.cId}' />">모임 홈으로 가기</a>
	
</body>
</html>