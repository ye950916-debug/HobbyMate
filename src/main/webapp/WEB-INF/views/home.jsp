<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>

<head>

	<title>${title}</title>
	<!-- Bootstrap CSS -->
	<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
	
	<!-- Theme CSS -->
	<link rel="stylesheet" href="<c:url value='/resources/css/theme.css?v=3'/>">

</head>

<body>
	
	
	<!-- Bootstrap Navbar -->
	<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top py-3">
		<div class="container">
		
		<!-- 로고 -->
		<a class="navbar-brand fw-bold fs-3" href="<c:url value='/'/>">
			HobbyMate
		</a>
		
		<!-- 모바일 토글 버튼 -->
		<button class="navbar-toggler" type="button" data-bs-toggle="collapse"
			data-bs-target="#navbarHM" aria-controls="navbarHM" aria-expanded = "false">
			<span class="navbar-toggler-icon"></span>
		</button>
		
		<div class="collapse navbar-collapse" id="navbarHM">
		
			<!-- 왼쪽 메뉴 -->
			<ul class="navbar-nav me-auto ms-lg-4">
			
				<!-- 모임 Dropdown -->
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
				
				<!-- 일정 Dropdown -->
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
				
				<!-- 하비로그 Dropdown -->
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
			
			<!-- 오른쪽 메뉴 -->
			<ul class="navbar-nav ms-auto">
			
				<c:if test="${empty sessionScope.loginMember}">
					<li class="nav-item">
						<a class="nav-link fw-bold" href="<c:url value='/login'/>">로그인</a>
					</li>
					<li class="nav-item ms-2">
						<a class="btn btn-outline-primary rounded-pill px-3" href="<c:url value='/member/join'/>">
                            회원가입
                        </a> 
					</li>
				</c:if>
				
				<c:if test="${not empty sessionScope.loginMember}">
				    <!-- 사용자 드롭다운 -->
				    <li class="nav-item dropdown">
				        <a class="nav-link dropdown-toggle d-flex align-items-center" href="#"
				           id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
				
				            <!-- 프로필 아이콘 -->
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


	<section class="home-hero py-5">
    <div class="container">
        <div class="row align-items-center">

            <!-- 왼쪽 : 텍스트 & 버튼 -->
            <div class="col-lg-5 order-2 order-lg-1 mt-4 mt-lg-0">

                <c:choose>
                    <c:when test="${empty sessionScope.loginMember}">
                        <p class="hm-hero-eyebrow mb-2">나에게 맞는 취미 루틴 찾기</p>
                        <h1 class="hm-hero-title mb-3">
                            이번 주, <br/>
                            취미로 채워볼 시간을<br/>
                            골라볼까요?
                        </h1>
                        <p class="hm-hero-sub mb-4">
                            단순히 모임을 나열하는 것이 아니라,<br/>
                            당신의 주간 일정에 딱 맞는 취미 시간을 추천해 드려요.
                        </p>

                        <div class="d-flex flex-wrap gap-2">
                            <a class="btn btn-primary btn-lg rounded-pill px-4"
                               href="<c:url value='/member/join'/>">
                                시작하기
                            </a>
                            <a class="btn btn-outline-primary btn-lg rounded-pill px-4"
                               href="<c:url value='/club/viewallclubs'/>">
                                모임 둘러보기
                            </a>
                        </div>
                    </c:when>

                    <c:otherwise>
                        <p class="hm-hero-eyebrow mb-2">
                            ${sessionScope.loginMember.mName}님의 취미 루틴 보드
                        </p>
                        <h1 class="hm-hero-title mb-3">
                            이번 주, <br/>
                            나만의 취미 시간표를<br/>
                            완성해볼까요?
                        </h1>
                        <p class="hm-hero-sub mb-4">
                            내가 가입한 모임과 추천 모임을 바탕으로<br/>
                            이번 주 취미 일정이 한눈에 보이도록 도와드립니다.
                        </p>

                        <div class="d-flex flex-wrap gap-2">
                            <a class="btn btn-primary btn-lg rounded-pill px-4"
                               href="<c:url value='/schedule/memberSchedule'/>">
                                나의 취미 일정 보기
                            </a>
                            <a class="btn btn-outline-primary btn-lg rounded-pill px-4"
                               href="<c:url value='/club/recommended?loginId=${sessionScope.loginMember.mId}'/>">
                                추천 모임 보기
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>

            <!-- 오른쪽 : 미니 위클리 캘린더 데모 -->
            <div class="col-lg-7 order-1 order-lg-2">
                <div class="hm-weekly-card shadow-sm">

                    <div class="hm-weekly-header d-flex justify-content-between align-items-center">
                        <div>
                            <span class="hm-weekly-label">이번 주 취미 캘린더 미리보기</span>
                            <small class="d-block text-muted mt-1">
                                아침·저녁 한 칸씩, 내 루틴을 채워보세요.
                            </small>
                        </div>
                        <span class="hm-weekly-range">12.16 ~ 12.22</span>
                    </div>

                    <div class="hm-weekly-body">

                        <!-- 요일 1 -->
                        <div class="hm-weekly-row">
                            <div class="hm-weekly-day">월</div>
                            <div class="hm-weekly-slots">
                                <div class="hm-slot">
                                    <span class="hm-slot-time">오후 7:30</span>
                                    <span class="hm-slot-title">런닝 크루</span>
                                </div>
                            </div>
                        </div>

                        <!-- 요일 2 -->
                        <div class="hm-weekly-row">
                            <div class="hm-weekly-day">수</div>
                            <div class="hm-weekly-slots">
                                <div class="hm-slot">
                                    <span class="hm-slot-time">오전 10:00</span>
                                    <span class="hm-slot-title">북클럽</span>
                                </div>
                            </div>
                        </div>

                        <!-- 요일 3 -->
                        <div class="hm-weekly-row">
                            <div class="hm-weekly-day">금</div>
                            <div class="hm-weekly-slots">
                                <div class="hm-slot">
                                    <span class="hm-slot-time">오후 6:00</span>
                                    <span class="hm-slot-title">사진 산책</span>
                                </div>
                            </div>
                        </div>

                        <!-- 요일 4 (비어 있는 날 예시) -->
                        <div class="hm-weekly-row hm-weekly-empty">
                            <div class="hm-weekly-day">토</div>
                            <div class="hm-weekly-slots">
                                <span class="hm-empty-text">아직 채워지지 않은 취미 시간이에요 ✨</span>
                            </div>
                        </div>

                    </div>

                    <div class="hm-weekly-footer">
                        <span class="hm-weekly-tip">
                            이 빈 칸에 딱 맞는 모임을 추천해 드릴게요.
                        </span>
                        <a href="<c:url value='/club/viewallclubs'/>"
                           class="btn btn-sm btn-outline-primary rounded-pill px-3">
                            모임 보러가기
                        </a>
                    </div>

                </div>
            </div>

        </div>
    </div>
    
    <!-- 추천 모임 띄우기 -->
	    <div class="container py-7">
			<div class="d-flex justify-content-between align-items-center mb-4">
			
			    <h3 class="fw-bold mb-0">
			        이런 모임도 있어요!
			    </h3>
			
			    <c:choose>
			        <c:when test="${empty sessionScope.loginMember}">
			            <a href="<c:url value='/login'/>"
			               class="text-decoration-none text-primary fw-semibold">
			                맞춤추천 더보기 &gt;
			            </a>
			        </c:when>
			
			        <c:otherwise>
			            <a href="<c:url value='/club/recommended?loginId=${sessionScope.loginMember.mId}'/>"
			               class="text-decoration-none text-primary fw-semibold">
			                맞춤추천 더보기 &gt;
			            </a>
			        </c:otherwise>
			    </c:choose>
			
			</div>

			
			<div class="row">
			    <c:forEach var="club" items="${recommendedClubs}">
			        <div class="col-md-4 mb-4">
					    <div class="card border-0 rounded-4 overflow-hidden shadow position-relative" style="min-height: 180px;"> 
					        <div class="bg-400 text-white px-4 py-2 fw-semibold small">
					            ${club.largeName } &gt; ${club.midName } &gt; ${club.subName }
					        </div>
					        
					        <div class="card-body p-4 d-flex">
					            
					            <div class="flex-grow-1 d-flex align-items-start"> 
					            
					                <div class="flex-shrink-0 me-4">
					                    <c:choose>
					                        <c:when test="${empty club.cMainImageName }">
					                            <img src="<c:url value='/resources/images/ClubMain/club-default.jpg'/>" 
					                            alt="기본 이미지" 
					                            style="width:100px; height:100px; object-fit:cover; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
					                        </c:when>
					                        <c:otherwise>
					                            <img src="<c:url value='/resources/images/ClubMain/${club.cMainImageName }'/>"
					                            alt="${club.cName} 대표 이미지"
					                            style="width:100px; height:100px; object-fit:cover; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
					                        </c:otherwise>
					                    </c:choose>
					                </div>
					                
					                <div class="flex-grow-1 min-w-0 me-2"> <p class="text-muted small mb-1 text-truncate">
					                        ${club.cSiDo} ${club.cGuGun}
					                    </p>
					                    
					                    <h5 class="card-title fw-bold mb-2 text-truncate">
					                        ${club.cName}
					                    </h5>
					                    
					                    <p class="card-text text-muted mb-0 small" style="max-width: 100%;">
					                        <c:set var="description" value="${club.cDescription}" />
					                        <c:if test="${fn:length(description) > 20}">
					                            ${fn:substring(description, 0, 20)}...
					                        </c:if>
					                        <c:if test="${fn:length(description) <= 20}">
					                            ${description}
					                        </c:if>
					                    </p>
					                </div>
					                
					            </div>
					            
					            </div>
					        
					        <div style="position: absolute; right: 15px; top: 50%; transform: translateY(10px);"> 
					            <a href="<c:url value='/club/home?clubId=${club.cId}'/>"
					               class="btn btn-sm btn-outline-primary btn-lg rounded-pill px-4 shadow-sm">
					                모임 홈
					            </a>
					        </div>
					        
					    </div>
					</div>
			    </c:forEach>
			</div>
	    </div>
	</section>
 

       
	        
	        

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script src="<c:url value='/resources/js/theme.js'/>"></script>

<script src="<c:url value='/resources/js/bootstrap-navbar.js'/>"></script>
</body>
</html>