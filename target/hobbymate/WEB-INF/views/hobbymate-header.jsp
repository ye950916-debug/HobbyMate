<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>HobbyMate Header</title>
    </head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top py-3 shadow-sm">
        <div class="container">
        
        <a class="navbar-brand fw-bold fs-3" href="<c:url value='/'/>">
            HobbyMate
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse"
            data-bs-target="#navbarHM" aria-controls="navbarHM" aria-expanded = "false">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarHM">
        
            <ul class="navbar-nav me-auto ms-lg-4">
            
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle fw-bold" href="#" id="moimDropdown"
                        role="button" data-bs-toggle="dropdown" aria-expanded="false">
                        모임
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="moimDropdown">

                        <li>						
                            <a class="dropdown-item" href="<c:url value='/club/viewallclubs'/>">
                                전체 모임 보기
                            </a>
                        </li>
                        
                        <c:choose>
                            <c:when test="${empty sessionScope.loginMember}">
                                <li><a class="dropdown-item" href="<c:url value='/login'/>">모임 만들기</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/login'/>">모임 추천받기</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/login'/>">내가 만든 모임</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/login'/>">내가 회원인 모임</a></li>
                            </c:when>
                            
                            <c:otherwise>
                                <li><a class="dropdown-item" href="<c:url value='/club/create'/>">모임 만들기</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/club/recommended?loginId=${sessionScope.loginMember.mId}'/>">모임 추천</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/club/myclub'/>">내 모임</a></li>
                            </c:otherwise>
                        </c:choose>
                        
                    </ul>
                </li>
                
                <li class="nav-item dropdown ms-lg-3">
                    <a class="nav-link dropdown-toggle fw-bold" href="#" id="scheduleDropdown"
                        role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            일정	
                    </a>
                    <ul class="dropdown-menu" aria-labelledby="scheduleDropdown">
                        <c:choose>
                            <c:when test="${empty sessionScope.loginMember}">
                                <li><a class="dropdown-item" href="<c:url value='/login'/>">내가 가입한 모든 모임 일정</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/login'/>">나의 일정 관리</a></li>
                            </c:when>
                            
                            <c:otherwise>
                                <li><a class="dropdown-item" href="<c:url value='/schedule/myclubs'/>">내가 가입한 모든 모임 일정</a></li>
                                <li><a class="dropdown-item" href="<c:url value='/schedule/memberSchedule'/>">나의 일정 관리</a></li>
                            </c:otherwise>
                        </c:choose>
                        
                    </ul>
                </li>
                
                <li class="nav-item dropdown ms-lg-3">
                        <a class="nav-link dropdown-toggle fw-bold" href="#" id="hobbyLogDropdown"
                           role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            하비로그
                        </a>
                    
                        <ul class="dropdown-menu" aria-labelledby="hobbyLogDropdown">
                            <c:choose>
                                <c:when test="${empty sessionScope.loginMember}">
                                    <li>
                                        <a class="dropdown-item" href="<c:url value='/login'/>">
                                            나의 하비로그
                                        </a>
                                    </li>
                                </c:when>
                    
                                <c:otherwise>
                                    <li>
                                        <a class="dropdown-item" href="<c:url value='/hobbylog/list'/>">
                                            나의 하비로그
                                        </a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </ul>
                    </li>
                                    
                
            </ul>
            
            <ul class="navbar-nav ms-auto">
            
                <c:if test="${empty sessionScope.loginMember}">
                    <li class="nav-item">
                        <a class="nav-link fw-bold" href="<c:url value='/login'/>">로그인</a>
                    </li>
                    <li class="nav-item ms-2">
                        <a class="btn btn-outline-secondary rounded-pill px-3" href="<c:url value='/member/join'/>">
                            회원가입
                        </a> 
                    </li>
                </c:if>
                
                <c:if test="${not empty sessionScope.loginMember}">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#"
                           id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                
                            <c:choose>
                                <c:when test="${not empty sessionScope.loginMember.mProfileImageName}">
                                    <img src="<c:url value='/resources/images/profile/${sessionScope.loginMember.mProfileImageName}'/>"
                                         alt="profile" class="rounded-circle me-2"
                                         style="width:32px; height:32px; object-fit:cover; border: 1px solid #ddd; border-radius: 50%;">
                                </c:when>
                        
                                <c:otherwise>
                                    <img src="<c:url value='/resources/images/profile/user-default.png'/>"
                                         alt="default profile" class="rounded-circle me-2"
                                         style="width:32px; height:32px; object-fit:cover; border: 1px solid #ddd; border-radius: 50%;">
                                </c:otherwise>
                            </c:choose>
                
                            ${sessionScope.loginMember.mName}님
                        </a>
                
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                            <li>
                                <a class="dropdown-item"
                                   href="<c:url value='/member/${sessionScope.loginMember.mId}'/>">
                                    내 정보 보기
                                </a>
                            </li>
                        </ul>
                    </li>
                    
                    <li class="nav-item ms-2">
                        <a class="btn btn-outline-secondary rounded-pill" href="<c:url value='/logout'/>">로그아웃</a>
                    </li>
                    
                    <c:if test="${sessionScope.loginMember.mRole eq 'ADMIN'}">
                        <li class="nav-item ms-3">
                            <a class="btn btn-danger rounded-pill px-3" href="<c:url value='/member/list'/>">
                                관리자
                            </a>
                        </li>
                    </c:if>
                
                </c:if>
            
            </ul>
        
        </div>
        
        </div>
    
    </nav>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>