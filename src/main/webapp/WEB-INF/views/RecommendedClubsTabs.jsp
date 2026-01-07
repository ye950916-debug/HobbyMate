<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>추천 모임</title>

	<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
	
	<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">


<style>
/* 왼쪽 사이드 탭 영역 */
.recommend-sidebar {
    background-color: var(--bs-dark) !important; /* bg-dark와 동일 */
    min-height: 100vh;
    height: 100%;
}

/* 탭 아이템 기본 상태 */
.recommend-tab {
    padding: 10px 15px; /* p-2에 가까움 */
    cursor: pointer;
    color: var(--bs-white) !important; /* 기본 상태는 흰색 */
    font-weight: 500;
    position: relative;
    transition: all 0.2s ease;
    font-size: 0.95rem;
    margin-bottom: 8px; /* mb-2에 가까움 */
    border-radius: 0.25rem; /* rounded */
}

/* Hover 시 */
.recommend-tab:hover {
    background-color: rgba(255, 255, 255, 0.1); /* 탭을 살짝 밝게 */
    color: #ffffff;
}

/* 활성 탭 (Active): bg-primary, text-white, fw-bold 스타일 */
.recommend-tab.active {
    background-color: var(--bs-primary) !important; /* Primary 컬러 배경 */
    color: #ffffff !important; 
    font-weight: 700;
    box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075); /* 살짝 그림자 추가 */
}

/* 활성 탭 왼쪽 포인트 바 (제거 - 참고 코드에 없으므로) */
/* .recommend-tab.active::before { display: none; } */

/* 상단 타이틀 영역 구분선 */
.recommend-sidebar .border-bottom {
    border-bottom: 1px solid rgba(255, 255, 255, 0.2) !important;
}

.recommended-content{
	padding-top: 40px;
	padding-bottom: 40px;
}

.header-wrapper {
    width: 100%;
    background-color: #fff;
}
</style>


	<script>
		$(document).ready(function () {
		
		    // 처음엔 지역 기반 추천
		    loadLocation();
		
		    $("#tab-location").click(function () {
		        setActive($(this));
		        loadLocation();
		    });
		
		    $("#tab-category").click(function () {
		        setActive($(this));
		        loadCategory();
		    });
		
		    function setActive(target) {
		        $(".recommend-tab").removeClass("active");
		        target.addClass("active");
		    }
		
		    function loadLocation() {
		        $("#recommendContent").load(
		            "/hobbymate/club/recommended/location?loginId=${sessionScope.loginMember.mId}"
		        );
		    }
		
		    function loadCategory() {
		        $("#recommendContent").load(
		            "/hobbymate/club/recommended/category?loginId=${sessionScope.loginMember.mId}"
		        );
		    }
		});
	</script>

</head>

<body>

<div class="header-wrapper">
    <%@ include file="/WEB-INF/views/hobbymate-header.jsp" %>
</div>


<div class="container-fluid p-0">
    <div class="row g-0 min-vh-100">

        <div class="col-12 col-md-2 p-0 recommend-sidebar">
            <div class="d-flex flex-column h-100 p-3">

                <div class="text-white fw-bold px-1 py-3 border-bottom mb-3">
                    추천 모임
                </div>

                <div id="tab-location" class="recommend-tab active">
                    <i class="fas fa-map-marker-alt me-2"></i> 지역 기반 추천
                </div>

                <div id="tab-category" class="recommend-tab">
                    <i class="fas fa-tags me-2"></i> 관심 카테고리 추천
                </div>
                
                <div class="mt-auto pt-3 border-top border-secondary">
                    <a href="<c:url value='/'/>" class="recommend-tab text-center text-secondary">
                        <i class="fas fa-home me-2"></i> 홈으로 돌아가기
                    </a>
                </div>

            </div>
        </div>

        <div class="col-12 col-md-10 px-4">
            <div id="recommendContent" class="recommended-content">
                </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>