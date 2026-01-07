<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 리더 변경</title>
</head>
<body>

<h2>관리자 : 리더 변경</h2>

<h4>현재 그룹장 ID</h4>
<p>${currentLeaderId}</p>

<p>선택한 멤버를 새로운 리더로 지정합니다.</p>

<table border="1">
    <tr>
        <th>회원 ID</th>
        <th>현재 권한</th>
        <th>선택</th>
    </tr>

    <c:forEach var="cm" items="${clubmembers}">
    	<!-- 현재 그룹장을 제외한 승인멤버 목록 -->
        <c:if test="${cm.cmMId ne currentLeaderId}">
            <tr>
                <td>${cm.cmMId}</td>
                <td>${cm.cmRole}</td>
                <td>
                    <form action="${pageContext.request.contextPath}/clubmember/admin/changeleader" method="post">
                        <input type="hidden" name="clubId" value="${clubId}">
                        <input type="hidden" name="newLeaderId" value="${cm.cmMId}">
                        <button type="submit">리더 지정</button>
                    </form>
                </td>
            </tr>
        </c:if>
    </c:forEach>

</table>



</body>
</html>
