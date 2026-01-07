<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 목록</title>

<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css?v=3'/>">
<meta name="viewport" content="width=device-width, initial-scale=1">

<style>
    .member-card { max-width: 1400px; margin: 0 auto; }
    table th { background: #f8f9fa; }
    table td, table th { vertical-align: middle; }
</style>
</head>

<body>

<div class="container my-5">
    <div class="card shadow-sm p-4 rounded-4 member-card">

        <!-- 제목 -->
        <h3 class="fw-bold mb-4">회원 목록</h3>

        <!-- 검색 영역 -->
        <form action="<c:url value='/member/search'/>" method="get" class="d-flex mb-4">
            <input type="text" name="keyword" class="form-control me-2" placeholder="회원 조건 검색">
            <button class="btn btn-primary px-4" style="white-space: nowrap;">검색</button>
        </form>

        <!-- 회원 테이블 -->
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>이름</th>
                        <th>나이</th>
                        <th>성별</th>
                        <th>전화번호</th>
                        <th>주소</th>
                        <th>가입일</th>
                        <th>상태</th>
                        <th>관리</th>
                        <th>수정</th>
                    </tr>
                </thead>

                <tbody>
                <c:forEach var="member" items="${memberList}">
                    <tr>

                        <td>
                            <a href="<c:url value='/member/${member.mId}'/>" class="text-decoration-none fw-semibold">
                                ${member.mId}
                            </a>
                        </td>

                        <td>${member.mName}</td>
                        <td>${member.mAge}</td>
                        <td>${member.mGender}</td>
                        <td>${member.mPhone}</td>
                        <td>${member.mAddress}</td>
                        <td>${member.mJoinDate}</td>

                        <!-- 상태 컬러 태그 -->
                        <td>
                            <span class="badge 
                                <c:choose>
                                    <c:when test='${member.mStatus eq "ACTIVE"}'>bg-success</c:when>
                                    <c:when test='${member.mStatus eq "SUSPENDED"}'>bg-warning text-dark</c:when>
                                    <c:when test='${member.mStatus eq "DELETED"}'>bg-secondary</c:when>
                                </c:choose>
                            ">
                                ${member.mStatus}
                            </span>
                        </td>

                        <!-- 관리자 기능 -->
                        <td style="width:160px;">
                            <c:if test="${sessionScope.loginMember.mRole eq 'ADMIN'}">

                                <!-- ACTIVE → 활동중지 -->
                                <c:if test="${member.mStatus eq 'ACTIVE'}">
                                    <form action="<c:url value='/member/admin/suspend' />" method="post" class="d-inline">
                                        <input type="hidden" name="mId" value="${member.mId}">
                                        <button class="btn btn-warning btn-sm text-dark">중지</button>
                                    </form>
                                </c:if>

                                <!-- SUSPENDED → 활동재개 -->
                                <c:if test="${member.mStatus eq 'SUSPENDED'}">
                                    <form action="<c:url value='/member/admin/activate' />" method="post" class="d-inline">
                                        <input type="hidden" name="mId" value="${member.mId}">
                                        <button class="btn btn-success btn-sm">재개</button>
                                    </form>
                                </c:if>

                                <!-- 강제탈퇴 -->
                                <c:if test="${member.mStatus ne 'DELETED'}">
                                    <form action="<c:url value='/member/admin/delete'/>" method="post"
                                          class="d-inline"
                                          onsubmit="return confirm('정말 강제 탈퇴시키겠습니까?');">
                                        <input type="hidden" name="mId" value="${member.mId}">
                                        <button class="btn btn-danger btn-sm">탈퇴</button>
                                    </form>
                                </c:if>

                            </c:if>
                        </td>

                        <!-- 수정 버튼 -->
                        <td>
                            <a href="<c:url value='/member/update/${member.mId}'/>"
                               class="btn btn-outline-primary btn-sm">
                                수정하기
                            </a>
                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="mt-4 text-end">
            <a href="<c:url value='/'/>" class="btn btn-secondary rounded-pill px-4">홈으로</a>
        </div>

    </div>
</div>

</body>
</html>
