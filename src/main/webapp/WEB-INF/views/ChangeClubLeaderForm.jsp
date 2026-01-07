<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리더 변경</title>

<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>

<body class="bg-light pt-5 pb-5">
    
    <div class="container" style="max-width: 700px;"> 
        
        <div class="card shadow p-4 p-md-5 border rounded-3 bg-white">
            
            <h2 class="fw-bold mb-5 pb-3 border-bottom text-dark">
                <i class="fas fa-exchange-alt me-2 text-secondary"></i> 모임 리더 변경
            </h2>
            
            <p class="mb-4 text-muted">모임의 회원 중 새로운 리더를 선택하세요. 현재 리더는 선택할 수 없습니다.</p>
            
            <c:if test="${not empty param.error}">
                <div class="alert alert-danger" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i> ${param.error}
                </div>
            </c:if>
            <c:if test="${not empty param.success}">
                <div class="alert alert-success" role="alert">
                    <i class="fas fa-check-circle me-2"></i> ${param.success}
                </div>
            </c:if>
            
            <div class="table-responsive">
                <table class="table table-hover table-striped table-bordered text-center align-middle">
                    <thead class="table-secondary">
                        <tr>
                            <th>회원 아이디</th>
                            <th style="width: 20%;">상태</th>
                            <th style="width: 15%;">선택</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="member" items="${clubmembers }">
                            <tr>
                                <td class="align-middle fw-semibold">${member.cmMId }</td>
                                <td class="align-middle">
                                    <c:choose>
                                        <c:when test="${member.cmMId == leaderId}">
                                            <span class="badge text-bg-danger fw-bold"><i class="fas fa-crown me-1"></i> 현재 리더</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge text-bg-light border text-muted">일반 회원</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${member.cmMId != leaderId}">
                                        <form action="${pageContext.request.contextPath }/clubmember/changeleader" method="post"
                                              onsubmit="return confirm('${member.cmMId} 님을 새로운 리더로 지정하시겠습니까?');">
                                            <input type="hidden" name="clubId" value="${clubId }" />
                                            <input type="hidden" name="newLeaderId" value="${member.cmMId }" />
                                            <button type="submit" class="btn btn-sm btn-outline-secondary w-100 fw-semibold">
                                                <i class="fas fa-hand-point-right me-1"></i> 선택
                                            </button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
            
            <div class="text-center mt-4">
                <a href="${pageContext.request.contextPath}/club/home?clubId=${clubId}" 
                   class="btn btn-secondary rounded-pill px-4 fw-semibold"> 
                   <i class="fas fa-arrow-left me-1"></i> 모임 페이지로 돌아가기 
                </a>
            </div>
            
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>