<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 회원 관리</title>

<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>

<body class="bg-light pt-5 pb-5">
    
    <div class="container" style="max-width: 900px;"> 
        
        <div class="card shadow p-4 p-md-5 border rounded-3">
	
            <h2 class="fw-bold mb-5 pb-3 border-bottom text-dark">
                <i class="fas fa-users-cog me-2"></i> 모임 회원 관리
            </h2>
            
            <h4 class="fw-semibold mb-3">가입 대기 중인 회원 (${waitingList.size()})</h4>
            
            <c:if test="${empty waitingList }">
                <div class="alert alert-light text-center border py-3" role="alert">
                    <i class="fas fa-info-circle me-2"></i> 가입 대기 중인 회원이 없습니다.
                </div>
            </c:if>
            
            <c:if test="${not empty waitingList }">
                <div class="table-responsive">
                    <table class="table table-hover table-striped table-bordered text-center align-middle">
                        <thead class="table-secondary">
                            <tr>
                                <th>회원 ID</th>
                                <th>가입 신청일</th>
                                <th colspan="2" style="width: 30%;">처리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cm" items="${waitingList }">
                                <tr>
                                    <td class="align-middle fw-semibold">${cm.cmMId }</td>
                                    <td class="align-middle text-muted">${cm.cmJoinDate }</td>
                                    <td>
                                        <form action="${pageContext.request.contextPath }/clubmember/approve" method="post">
                                            <input type="hidden" name="memberId" value="${cm.cmMId}" />
                                            <input type="hidden" name="clubId" value="${clubId}" />
                                            <button type="submit" class="btn btn-sm btn-success w-100 fw-semibold">
                                                <i class="fas fa-check me-1"></i> 승인
                                            </button>
                                        </form>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath }/clubmember/reject" method="post">
                                            <input type="hidden" name="memberId" value="${cm.cmMId}" />
                                            <input type="hidden" name="clubId" value="${clubId}" />
                                            <button type="submit" class="btn btn-sm btn-outline-secondary w-100 fw-semibold"> 
                                                <i class="fas fa-times me-1"></i> 거절
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            
            <hr class="my-5"> 

            <h4 class="fw-semibold mb-3">승인된 회원 (${approvedList.size()})</h4>
            
            <c:if test="${empty approvedList }">
                <div class="alert alert-light text-center border py-3 text-secondary" role="alert">
                    <i class="fas fa-info-circle me-2"></i> 승인된 회원이 없습니다.
                </div>
            </c:if>
            <c:if test="${not empty approvedList }">
                <div class="table-responsive">
                    <table class="table table-hover table-striped table-bordered text-center align-middle">
                        <thead class="table-secondary">
                            <tr>
                                <th>회원 ID</th>
                                <th>가입 날짜</th>
                                <th style="width: 20%;">강제 탈퇴</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cm" items="${approvedList }">
                                <tr>
                                    <td class="align-middle fw-semibold">${cm.cmMId }</td>
                                    <td class="align-middle text-muted">${cm.cmJoinDate }</td>
                                    <td>
	                                    <c:if test="${cm.cmMId ne leaderId }">
	                                        <form action="${pageContext.request.contextPath }/clubmember/remove" method="post" onsubmit="return confirm('정말 해당 회원(${cm.cmMId})을 강제 탈퇴 시키겠습니까?');">
	                                            <input type="hidden" name="memberId" value="${cm.cmMId}" />
	                                            <input type="hidden" name="clubId" value="${clubId}" />
	                                            <button type="submit" class="btn btn-sm btn-danger w-100 fw-semibold">
	                                                <i class="fas fa-user-slash me-1"></i> 탈퇴
	                                            </button>
	                                        </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
            
            <br>
            
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/club/home?clubId=${clubId}" 
                   class="btn btn-secondary rounded-pill px-4 fw-semibold"> 
                   <i class="fas fa-arrow-left me-1"></i> 모임 페이지로 돌아가기 
                </a>
            </div>
        
        </div> </div> <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>