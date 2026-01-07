<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>전체 모임 보기</title>

<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>"> 
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>


<script>
	function fetchRegionData(param, $targetSelect, level) {
	    var url = "";
	    
	    // level에 따라 엔드포인트 URL 설정
	    if (level === "sido") {
	        url = "${pageContext.request.contextPath}/region/sido";
	    }
	    else if (level === "gugun") {
	        url = "${pageContext.request.contextPath}/region/gugun?sidocode=" + param;
	    }
	    // 'dong' 레벨은 ViewAllClubs에서는 사용하지 않지만, 코드는 유지합니다.
	    else if (level === "dong") {
	        url = "${pageContext.request.contextPath}/region/dong?guguncode=" + param;
	    }
	
	    $.ajax({
	        url: url,
	        type: "GET",
	        dataType: "json",
	
	        success: function(regionData) {
	            // 초기화 옵션 텍스트 정의
	            let defaultText = (level === "sido") ? '시/도 전체' : '구/군 전체';
	            $targetSelect.empty().append('<option value="">' + defaultText + '</option>');
	
	            if (!regionData || regionData.length === 0) {
	                console.log(level + " 데이터 없음");
	                return;
	            }
	
	            for (var i = 0; i < regionData.length; i++) {
	                var item = regionData[i];
	                var code = item["법정동코드"]; 
	                var name = "";
	
	                if (level === "sido") {
	                    name = item["시도명"];
	                }
	                else if (level === "gugun") {
	                    name = item["시군구명"];
	                }
	                else if (level === "dong") {
	                    name = item["읍면동명"];
	                }
	
	                if (code && name) {
	                    $targetSelect.append('<option value="' + code + '">' + name + '</option>');
	                }
	            }
	            
	            // 구/군 드롭다운은 데이터 로드 완료 후 활성화
	            if (level === "gugun") {
	                $targetSelect.prop('disabled', false);
	            }
	        },
	
	        error: function(xhr, status, error) {
	            console.error("지역 API 호출 실패:", error);
	            $targetSelect.empty().append('<option value="">-- 로딩 실패 --</option>');
	            $targetSelect.prop('disabled', true);
	        }
	    });
	}
	
	
	// 필터 초기화 함수
	function resetAllFilters() {
	    
	    // 1. 카테고리 필터 초기화
	    $("#largeCategorySelect").val(""); 
	    // 중/소분류는 초기 상태로 되돌리고 비활성화 (동적으로 다시 로드될 준비)
	    $("#midCategorySelect").val("").html('<option value="">중분류 전체</option>').prop('disabled', true);
	    $("#subCategorySelect").val("").html('<option value="">소분류 전체</option>').prop('disabled', true);
	    
	    // 2. 지역 필터 초기화
	    $("#sidoSelect").val(""); // 시/도 전체 선택
	    // 구/군 초기화 및 비활성화
	    $("#gugunSelect").val("").html('<option value="">구/군 전체</option>').prop('disabled', true);
	    
	    // 3. 검색어 필터 초기화 (search-area 영역에 있음)
	    // 현재 HTML의 검색 폼 요소에 접근
	    $('select[name="searchType"]').val("name"); // 검색 타입 기본값으로 설정
	    $('input[name="searchKeyword"]').val(""); // 검색 키워드 지우기

	    // 4. 모든 필터링 조건이 초기화되었으므로, 서버에 전체 목록 요청
	    fetchFilteredClubs(); 
	}


	//----------------------------------------------------------
	//  모임 목록을 필터링하여 AJAX로 가져오는 함수
	//----------------------------------------------------------
	function fetchFilteredClubs() {
	    // 1. 필터 조건 수집
	    const filters = {
	        // 지역 코드 수집 (Value는 법정동 코드)
	        sidoCode: $('#sidoSelect').val(),
	        gugunCode: $('#gugunSelect').val(),
	        
	        // 카테고리 코드 수집 (DB에 저장된 코드 사용 가정)
	        largeCode: $('#largeCategorySelect').val(),
	        midCode: $('#midCategorySelect').val(),
	        subCode: $('#subCategorySelect').val(),
	        
	        // 키워드 검색 값 수집
	        searchType: $('select[name="searchType"]').val(),
	        searchKeyword: $('input[name="searchKeyword"]').val()
	    };
	    
	    // 로딩 인디케이터 표시
	    $('.club-list').html('<div class="text-center p-5"><i class="fas fa-spinner fa-spin fa-2x text-primary"></i><p class="mt-2">모임 목록을 불러오는 중...</p></div>');
	
	    // 2. AJAX 호출 (클럽 조회 엔드포인트)
	    // **TODO: 이 URL을 실제 클럽 필터링을 처리하는 Controller 메서드로 변경해야 합니다.**
	    $.ajax({
	        url: '<c:url value="/club/api/filterClubs" />', 
	        type: 'GET',
	        data: filters,
	        dataType: 'json', // 서버가 모임 객체 목록을 JSON 배열로 반환한다고 가정
	        success: function(clubs) {
	            updateClubList(clubs); // 3. 화면 업데이트 함수 호출
	        },
	        error: function(xhr, status, error) {
	            console.error("모임 목록 필터링 실패:", error);
	            $('.club-list').html('<div class="alert alert-danger text-center" role="alert"><i class="fas fa-exclamation-triangle me-2"></i>모임 목록을 불러오는 데 실패했습니다.</div>');
	        }
	    });
	}


	//----------------------------------------------------------
	//  JSON 데이터를 받아 화면의 club-list를 갱신하는 함수
	//----------------------------------------------------------
	function updateClubList(clubs) {

    console.log("서버에서 받은 클럽 목록:", clubs);

    let htmlContent = '';

    if (!clubs || clubs.length === 0) {
        htmlContent =
        	'<div class="alert alert-warning text-center p-3" role="alert">' +
	            '<i class="fas fa-info-circle me-2"></i>선택하신 조건에 맞는 모임이 없습니다.' +
	        '</div>';
    } else {

        clubs.forEach(function(club) {
            const max = club.cMaxMembers || 0;
            const current = club.cMemberCount || 0;
            const progress = (max > 0) ? (current / max) * 100 : 0;
            // 모임 홈 링크
            const clubUrl = '/hobbymate/club/home?clubId=' + club.cId;
            const description = club.cDescription || '';

         	// 1. 이미지 처리 로직
            const imageHtml = club.cMainImageName ? 
                '<img src="${pageContext.request.contextPath}/resources/images/ClubMain/' + club.cMainImageName + '" ' +
                'alt="' + (club.cName || '') + ' 대표 이미지" class="rounded-3 shadow-sm" style="width:130px;height:130px;object-fit:cover;">' 
                : 
                '<div class="d-flex justify-content-center align-items-center bg-light border rounded-3" style="width:130px;height:130px;">' +
                    '<i class="fas fa-users text-muted" style="font-size: 3.5rem;"></i>' +
                '</div>';

            // 2. 카테고리 태그 처리
            const categoryHtml = (club.subName) ?
                '<span class="badge text-bg-light text-dark border border-secondary-subtle fw-normal text-truncate" style="max-width: 100%;">' +
                    (club.largeName || '') + ' &gt; ' +
                    (club.midName || '') + ' &gt; ' +
                    (club.subName || '') +
                '</span>'
                : '';


            // 3. 최종 카드 HTML (JSP body와 클래스 일치)
            htmlContent +=
                '<div class="card p-4 shadow-sm border-0">' +
                    '<div class="d-flex align-items-start w-100">' +
                        
                        // 이미지/아이콘 영역
                        '<div class="flex-shrink-0 me-4">' +
                            imageHtml +
                        '</div>' +
                        
                        // 모임 메인 정보 영역
                        '<div class="flex-grow-1 min-w-0 me-4">' +
                            // ⭐ 모임 제목 크기: fs-4 -> fs-5로 조정했던 클래스 적용 ⭐
                            '<h2 class="fs-5 fw-bold text-dark mb-1 text-truncate" title="' + (club.cName || '') + '">' +
                                (club.cName || '') +
                            '</h2>' +
                            
                            // 카테고리 태그
                            '<div class="mb-2">' +
                                categoryHtml +
                            '</div>' +
                            
                            // 모임 설명
                            '<p class="text-muted small mb-2 text-truncate" title="' + description + '" style="max-height: 4.5em; overflow: hidden; line-height: 1.5em;">' +
                                description +
                            '</p>' +
                            
                            // 상세 정보
                            '<div class="d-flex flex-column gap-1 mt-3 small text-muted">' +
                                '<div><i class="fas fa-user-circle me-1 text-muted"></i> 리더: <strong>' + (club.leaderId || '') + '</strong></div>' +
                                '<div><i class="fas fa-map-marker-alt me-1 text-muted"></i> 지역: ' + (club.cSiDo || '') + ' ' + (club.cGuGun || '') + '</div>' +
                                '<div><i class="fas fa-street-view me-1 text-muted"></i> 주 활동 장소: ' + (club.cMainPlace || '미정') + '</div>' +
                            '</div>' +
                        '</div>' +

                        // 멤버 수 및 버튼 (줄바꿈 방지 스타일 유지)
                        '<div class="flex-shrink-0 ms-4 text-end d-flex flex-column justify-content-center align-items-end" style="min-width: 150px;">' +
                            '<div class="mb-3" style="width: 120px;">' +
                                // ⭐ 멤버 수 크기: fs-3 -> fs-6로 조정했던 클래스 적용 ⭐
                                '<span class="d-block fw-bold fs-3 text-dark">' +
                                    current + '/' + max + '명' +
                                '</span>' +
                                
                                '<div class="progress mt-1" style="height: 8px;">' +
                                    '<div class="progress-bar bg-primary" role="progressbar" style="width:' + progress + '%"></div>' +
                                '</div>' +
                            '</div>' +
                            
                            '<a href="' + clubUrl + '" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-sm">모임 홈</a>' +
                        '</div>' +
                    '</div>' +
                '</div>';
        });
    }

    $('.club-list').html(htmlContent);
}



	//----------------------------------------------------------
	//  이벤트 리스너 및 초기화 (ViewAllClubs.jsp ID에 맞춤)
	//----------------------------------------------------------
	$(document).ready(function() {
	    
	    // 1. 최초 시도 로딩
	    fetchRegionData('0', $("#sidoSelect"), 'sido');
	
	    // 2. 시도 선택 시 구군 로딩 (ID: #sidoSelect, #gugunSelect 사용)
	    $("#sidoSelect").change(function() {
	        var sidoCode = $(this).val();
	
	        // 구/군 초기화 및 비활성화
	        $("#gugunSelect").html('<option value="">구/군 전체</option>').prop('disabled', true);
	        // 카테고리 소분류 초기화 (지역 단계 변경 시 하위 필터는 모두 초기화 권장)
	        $("#subCategorySelect").val('').prop('disabled', true);
	
	        if (sidoCode) {
	            fetchRegionData(sidoCode, $("#gugunSelect"), 'gugun');
	        }
	    });
	
	    // 3. 구군 선택 시 (하위 필터링이 있다면 여기에 로직 추가)
	    $("#gugunSelect").change(function() {
	        // 지역 3단계 (읍/면/동)는 현재 ViewAllClubs.jsp에서 구현하지 않으므로 추가 작업은 없습니다.
	        // 다만, 최종 검색에는 이 값을 활용합니다.
	    });
	    
	    // 4. 카테고리 대분류 선택 시 중분류 로드 (TODO: 여기에 구현 필요)
	    $('#largeCategorySelect').on('change', function() {
	        const largeCode = $(this).val();
	        $('#midCategorySelect').val('').prop('disabled', true);
	        $('#subCategorySelect').val('').prop('disabled', true);
	
	        if (largeCode) {
	            // loadMidCategory(largeCode); // TODO: 이 함수를 구현하여 호출해야 함
	            // 임시로 활성화만 처리
	            $('#midCategorySelect').prop('disabled', false); 
	        }
	    });
	    
	    // 5. 필터 적용 버튼 클릭 시 최종 목록 조회
	    $('#applyFilterBtn').on('click', function() {
	        fetchFilteredClubs();
	    });
		    
		// 6. 필터 초기화 버튼 클릭 이벤트 연결
	    $("#resetFiltersBtn").on('click', function() {
	        resetAllFilters();
	    });
	    
	    // 7. 키워드 검색 폼 제출 시 (기존 폼 제출 대신 AJAX 호출)
	    // 기존 폼 제출을 막고 AJAX로 처리하려면 이 코드를 추가합니다.
	    $('.search-area form').on('submit', function(e) {
	        e.preventDefault(); // 기본 폼 제출 방지
	        fetchFilteredClubs();
	    });
	    
	    // TODO: 페이지 로드 시 모임 목록을 한 번 불러올지 결정 (현재는 JSP가 서버에서 받은 ${allClubs}를 먼저 뿌려주고 있음)
	    // 만약 처음부터 AJAX로 목록을 로드하려면 여기에 fetchFilteredClubs()를 호출합니다.
	});
</script>

<script>
function fetchCategoryData(parentId, $targetSelect, level) {
    let url = "";
    
    if (level === "large") {
        url = "${pageContext.request.contextPath}/category/top";
    } else if (level === "mid") {
        url = "${pageContext.request.contextPath}/category/mid?parentId=" + parentId;
    } else if (level === "sub") {
        url = "${pageContext.request.contextPath}/category/sub?parentId=" + parentId;
    }
    
    $.ajax({
        url: url,
        type: "GET",
        dataType: "json",
        success: function(categoryData) {
            let defaultText = "";
            if (level === "large") { defaultText = '대분류 전체'; }
            else if (level === "mid") { defaultText = '중분류 전체'; }
            else if (level === "sub") { defaultText = '소분류 전체'; }
            
            // 드롭다운 초기화
            $targetSelect.empty().append('<option value="">' + defaultText + '</option>');

            if (!categoryData || categoryData.length === 0) {
                $targetSelect.prop('disabled', true);
                return;
            }
            
            for (var i = 0; i < categoryData.length; i++) {
                var item = categoryData[i];
                
                // 필터링에 사용할 CODE를 VALUE에, 다음 로딩에 사용할 ID를 data-id에 저장
                var id = item["ctId"];     
                var code = item["ctCode"]; 
                var name = item["ctName"];
                
                if (id && code && name) {
                    // ⭐ 중요: 필터링을 위해 ctCode를 value로 사용
                    $targetSelect.append('<option value="' + code + '" data-id="' + id + '">' + name + '</option>');
                }
            }
            
            $targetSelect.prop('disabled', false);
        },
        error: function(xhr, status, error) {
            console.error(level + " 카테고리 로딩 실패:", error);
            $targetSelect.empty().append('<option value="">-- 로딩 실패 --</option>');
            $targetSelect.prop('disabled', true);
        }
    });
}


// ------------------------------------------------------------------
// 2. 이벤트 리스너 및 초기화 (JQuery document.ready 내부에 삽입)
// ------------------------------------------------------------------
$(document).ready(function() {
    // 1. 최초 대분류 로딩 
    fetchCategoryData(null, $("#largeCategorySelect"), 'large');

    // 2. 대분류 선택 시 중분류 로드
    $('#largeCategorySelect').on('change', function() {
        // 선택된 <option>에서 ctId를 가져옴 (data-id 사용)
        const largeId = $(this).find('option:selected').data('id'); 
        
        // 중/소분류 초기화
        $('#midCategorySelect').html('<option value="">중분류 전체</option>').prop('disabled', true);
        $('#subCategorySelect').html('<option value="">소분류 전체</option>').prop('disabled', true);

        if (largeId) {
            fetchCategoryData(largeId, $("#midCategorySelect"), 'mid');
        }
        
    });

    // 3. 중분류 선택 시 소분류 로드
    $('#midCategorySelect').on('change', function() {
        // 선택된 <option>에서 ctId를 가져옴 (data-id 사용)
        const midId = $(this).find('option:selected').data('id');
        
        // 소분류 초기화
        $('#subCategorySelect').html('<option value="">소분류 전체</option>').prop('disabled', true);
        
        if (midId) {
            fetchCategoryData(midId, $("#subCategorySelect"), 'sub');
        }
        
    });
    
    // 4. 소분류 변경 시 필터링 실행
    $('#subCategorySelect').on('change', function() {

    });


});
</script>

</head>
<body>

<%@ include file="/WEB-INF/views/hobbymate-header.jsp" %>
	
<div class="d-flex flex-nowrap min-vh-100">

    <div class="flex-shrink-0 bg-dark text-white p-4 shadow-lg sticky-top" style="width: 280px; top: 70px; height: calc(100vh - 70px); overflow-y: auto;">
        
        <h2 class="fs-4 fw-bold mb-4 pb-2 border-bottom border-secondary text-white">
            <i class="fas fa-filter me-2 text-primary"></i> 모임 필터링
        </h2>

        <div class="filter-item-group mb-4">
            <label for="sidoSelect" class="form-label fw-semibold text-light"><i class="fas fa-map-marker-alt me-1 text-muted"></i> 지역 선택</label>
            <select class="form-select form-select-sm mb-2" id="sidoSelect" name="cSiDoCode">
                <option value="">시/도 전체</option>
            </select>
            <select class="form-select form-select-sm" id="gugunSelect" name="cGuGunCode" disabled>
                <option value="">구/군 전체</option>
            </select>
        </div>

        <div class="filter-item-group mb-4">
            <label for="largeCategorySelect" class="form-label fw-semibold text-light"><i class="fas fa-layer-group me-1 text-muted"></i> 카테고리 선택</label>
            <select class="form-select form-select-sm mb-2" id="largeCategorySelect">
                <option value="">대분류 전체</option>
            </select>
            <select class="form-select form-select-sm mb-2" id="midCategorySelect" disabled>
                <option value="">중분류 전체</option>
            </select>
            <select class="form-select form-select-sm" id="subCategorySelect" disabled>
                <option value="">소분류 전체</option>
            </select>
        </div>
        
        <button type="button" id="applyFilterBtn" class="btn btn-primary w-100 mt-3 fw-semibold shadow-sm">
             <i class="fas fa-check me-1"></i> 필터 적용하기
        </button>
		<button type="button" id="resetFiltersBtn" class="btn btn-outline-secondary w-100 mt-2 fw-semibold">
			<i class="fas fa-redo me-1"></i> 필터 초기화
	    </button>
    </div>
    
    <div class="flex-grow-1 p-4 bg-light" style="min-width: 0;">

        <div class="container pt-4" style="max-width: 1200px;">
            
            <h1 class="fs-3 fw-bold mb-4 text-dark"><i class="fas fa-list me-2"></i> 전체 모임 보기</h1>
            
            <div class="search-area mb-4 p-3 bg-white border rounded shadow-sm">
                <form action="<c:url value='/club/viewallclubs' />" method="get" class="d-flex gap-2 align-items-center">
                    <select name="searchType" class="form-select form-select-sm" style="max-width: 120px;">
                        <option value="name">모임 제목</option>
                        <option value="content">소개 내용</option>
                    </select>
                    <input type="text" name="searchKeyword" placeholder="검색어를 입력하세요." 
                           class="form-control form-control-sm flex-grow-1">
                    <button type="submit" class="btn btn-secondary btn-sm fw-semibold" style="padding: 0.25rem 0.5rem; white-space: nowrap;">
                        <i class="fas fa-search"></i> 검색
                    </button>
                </form>
            </div>
            
            <div class="club-list d-grid gap-3">
                <c:forEach var="club" items="${allClubs}">
				    <c:set var="currentMembers" value="${club.cMemberCount}" />
				    <c:set var="maxMembers" value="${club.cMaxMembers}" />
				    <c:set var="progress" value="${maxMembers > 0 ? (currentMembers / maxMembers) * 100 : 0}" /> 
				    
				    <div class="card p-4 shadow-sm border-0">
				        <div class="d-flex align-items-start w-100">
				            
				            <div class="flex-shrink-0 me-4"> 
				                <c:choose>
				                    <c:when test="${empty club.cMainImageName }">
				                        <div class="d-flex justify-content-center align-items-center bg-light border rounded-3" style="width:130px;height:130px;">
                                            <i class="fas fa-users text-muted" style="font-size: 3.5rem;"></i>
                                        </div>
				                    </c:when>
				                    <c:otherwise>
				                        <img src="<c:url value='/resources/images/ClubMain/${club.cMainImageName }'/>"
				                        alt="${club.cName} 대표 이미지" class="rounded-3 shadow-sm" style="width:130px;height:130px;object-fit:cover;">
				                    </c:otherwise>
				                </c:choose>
				            </div>
				            
				            <div class="flex-grow-1 min-w-0 me-4"> 
				                <h2 class="fs-4 fw-bold text-dark mb-1 text-truncate" title="${club.cName}">${club.cName}</h2>
				                
				                <div class="mb-2">
				                    <c:if test="${not empty club.subName}">
				                        <span class="badge text-bg-light text-dark border border-secondary-subtle fw-normal">
                                            ${club.largeName} &gt; ${club.midName} &gt; ${club.subName}
                                        </span>
				                    </c:if>
				                </div>
				                
				                <p class="text-muted small mb-2 text-truncate" title="${club.cDescription}" style="max-height: 4.5em; overflow: hidden; line-height: 1.5em;">
				                   <c:out value="${club.cDescription}" />
				               </p>
				                
				                <div class="d-flex flex-column gap-1 mt-3 small text-muted">
				                    <div><i class="fas fa-user-circle me-1 text-muted"></i> 리더: <strong>${club.leaderId}</strong></div>
				                    <div><i class="fas fa-map-marker-alt me-1 text-muted"></i> 지역: ${club.cSiDo} ${club.cGuGun}</div>
				                    <div><i class="fas fa-street-view me-1 text-muted"></i> 주 활동 장소: <c:out value="${club.cMainPlace}" default="미정"/></div>
				                </div>
				            </div>
				
				            <div class="flex-shrink-0 ms-4 text-end d-flex flex-column justify-content-center align-items-end" style="min-width: 150px;">
				                
				                <div class="mb-3" style="width: 120px;">
				                    <span class="d-block fw-bold fs-3 text-dark">
				                        <c:out value="${currentMembers}" />/<c:out value="${maxMembers}" />명
				                    </span>
				                    
				                    <div class="progress mt-1" style="height: 8px;">
				                         <div class="progress-bar bg-primary" role="progressbar" 
				                              style="width: ${progress}%" 
				                              aria-valuenow="${currentMembers}" aria-valuemin="0" aria-valuemax="${maxMembers}">
				                        </div>
				                    </div>
				                </div>
				                
				                <a href="<c:url value='/club/home?clubId=${club.cId}' />" class="btn btn-primary rounded-pill px-4 fw-semibold shadow-sm">모임 홈</a>
				            </div>
				        </div>
				    </div>
				</c:forEach>
            </div>

        </div>
    </div>
</div>
</body>

</html>