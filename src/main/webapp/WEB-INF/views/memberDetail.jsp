<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 상세 정보</title>

 <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">

 <!-- Theme CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">

    <meta name="viewport" content="width=device-width, initial-scale=1">

</head>
<body>
	<div class="container my-5">

    <!-- 메인 카드 -->
    <div class="card shadow-sm p-4 rounded-4" style="max-width: 900px; margin: 0 auto;">

        <h3 class="fw-bold mb-4 ms-1">회원 정보</h3>

        <div class="row g-4">

            <!-- LEFT : 프로필 -->
            <div class="col-md-4 text-center border-end pe-4">

                <c:choose>
                    <c:when test="${empty member.mProfileImageName}">
                        <img src="<c:url value='/resources/images/profile/user-default.png'/>"
                             class="rounded-circle mt-5 mb-4"
                             style="width:130px;height:130px;object-fit:cover; border:1px solid #ddd;">
                    </c:when>

                    <c:otherwise>
                        <img src="<c:url value='/resources/images/profile/${member.mProfileImageName}'/>"
                             class="rounded-circle mt-5 mb-4"
                             style="width:130px;height:130px;object-fit:cover; border:1px solid #ddd;">
                    </c:otherwise>
                </c:choose>

                <h5 class="fw-bold mb-0">${member.mName}님</h5>
                <span class="small" style="color:#6c757d"> ID : ${member.mId}</span>

            </div>

            <!-- RIGHT : 상세 정보 -->
            <div class="col-md-8 ps-6" style="line-height:1.55;">

                <h6 class="fw-bold fs-1 mb-3">프로필 정보</h6>

                <div class="mb-2"><span class="fw-semibold text-dark">나이 :</span> ${member.mAge}</div>
                <div class="mb-2"><span class="fw-semibold text-dark">성별 :</span> ${member.mGender}</div>
                <div class="mb-2"><span class="fw-semibold text-dark">전화번호 :</span> ${member.mPhone}</div>
                <div class="mb-2"><span class="fw-semibold text-dark">주소 :</span> ${member.mAddress}</div>
				
				
				<hr class="my-3" style="opacity: 0.15;">
				
				
                <h6 class="fw-bold fs-1 mt-3 mb-3">관심 분야</h6>

                <c:forEach var="p" items="${favFullNames}">
                    <div class="mb-1">${p}</div>
                </c:forEach>

            </div>
        </div>
    </div>

    <!-- 버튼 영역 -->
    <div class="text-end mt-4" style="max-width:900px; margin:0 auto;">

        <c:if test="${(sessionScope.loginMember.mRole eq 'ADMIN'
                       or sessionScope.loginMember.mId eq member.mId)
                       and member.mStatus ne 'DELETED'}">

            <a href="<c:url value='/member/update/${member.mId}'/>"
               class="btn btn-primary rounded-pill px-4 py-2 me-2">
                수정하기
            </a>

            <form action="<c:url value='/member/delete'/>"
                  method="post" class="d-inline"
                  onsubmit="return confirm('정말 탈퇴하시겠습니까?');">
                <input type="hidden" name="mId" value="${member.mId}">
                <button type="submit" class="btn btn-danger rounded-pill px-4 py-2">
                    회원 탈퇴
                </button>
            </form>
        </c:if>

        <c:if test="${sessionScope.loginMember.mRole eq 'ADMIN'}">
            <a href="<c:url value='/member/list'/>"
               class="btn btn-outline-dark rounded-pill px-4 py-2 ms-2">
                회원 목록
            </a>
        </c:if>

        <a href="<c:url value='/'/>"
           class="btn btn-light rounded-pill px-4 py-2 ms-2">
            홈으로
        </a>
    </div>
</div>

	
</body>
</html>
