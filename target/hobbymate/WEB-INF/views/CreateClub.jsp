<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 만들기</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">

<script>

	let selectedCategoryIds = [];
	
	$(document).ready(function() {
		
		$("#midCategory").empty().append('<option value="">--중분류 선택--</option>');
        $("#subCategory").empty().append('<option value="">--소분류 선택--</option>');
		
		// 1. 대분류로딩
		loadTopCategories();
	
		// 2. 중분류로딩
		$("#topCategory").change(function() {
			let parentId = $(this).val();
			$("#midCategory").empty().append('<option value="">--중분류선택--</option>');
			$("#subCategory").empty().append('<option value="">--소분류선택--</option>');
			
			if(parentId === "") return;
			
			$.ajax({
				url: "${pageContext.request.contextPath}/category/mid",
				type: "GET",
				data: {parentId: parentId},
				success: function(list) {
					list.forEach(function(ct) {
						$("#midCategory").append('<option value="'+ct.ctId+'">'+ct.ctName+'</option>');
					});
				}
			});
		});
		
		// 3. 소분류로딩
		$("#midCategory").change(function() {
			let parentId = $(this).val();
			$("#subCategory").empty().append('<option value="">--소분류 선택--</option>');
			
			if(parentId === "") return;
			
			$.ajax({
		        url: "${pageContext.request.contextPath}/category/sub",
		        type: "GET",
		        data: { parentId: parentId },
		        success: function(list) {
		            list.forEach(function(ct) {
		                $("#subCategory").append('<option value="'+ct.ctId+'">'+ct.ctName+'</option>');
		            });
		        }
		    });
		});
	
		// 4. 카테고리추가 -> 선택이 누적
		$("#addCategoryBtn").click(function() {
		    let ctId = $("#subCategory").val();
		    let ctName = $("#subCategory option:selected").text();
		
		    if(ctId === "" || ctId == null || ctName === "--소분류 선택--") {
		        alert("소분류를 선택하세요");
		        return;
		    }
            
            // 최대 3개까지만 선택 가능하도록 제한
            if(selectedCategoryIds.length >= 3) {
                alert("카테고리는 최대 3개까지만 선택 가능합니다.");
                return;
            }
		
		    if(selectedCategoryIds.includes(ctId)) {
		        alert("이미 선택한 카테고리입니다.");
		        return;
		    }
		
		    selectedCategoryIds.push(ctId);
		
		    $("#selectedCategoryList").append(
		    		"<li data-id='"+ctId+"'>"+ ctName +
		    		"<button type='button' class='removeCt' data-id='"+ctId+"'><i class='fas fa-times'></i></button></li>"
		    	);
		
		    // hidden input 업데이트
		    $("#categoryIds").val(selectedCategoryIds.join(","));
		    
		    // 선택 초기화 (선택 사항)
		    $("#midCategory").empty().append('<option value="">--중분류선택--</option>');
		    $("#subCategory").empty().append('<option value="">--소분류선택--</option>');
		    $("#topCategory").val("");
		});
        
		
		
	});
	
	// 삭제 이벤트
	$(document).on("click", ".removeCt", function(){
		let id = $(this).data("id");
		selectedCategoryIds = selectedCategoryIds.filter(ct => ct != id);
		$(this).parent().remove();
		$("#categoryIds").val(selectedCategoryIds.join(","));
	});
	
	
	

	
	function loadTopCategories() {
		$.ajax({
			url: "${pageContext.request.contextPath}/category/top",
			type: "GET",
			success: function(list) {
				$("#topCategory").empty().append('<option value="">--대분류선택--</option>');
				list.forEach(function(ct){
					$("#topCategory").append('<option value="'+ct.ctId+'">'+ct.ctName+'</option>');
				});
			}
		});
	}
</script>

<script>
	//----------------------------------------------------------
	//  지역 데이터 로딩 함수
	//----------------------------------------------------------
	function fetchRegionData(param, $targetSelect, level) {
	
	    var url = "";
	    
	    if (level === "sido") {
	        url = "${pageContext.request.contextPath}/region/sido";
	    }
	    else if (level === "gugun") {
	        url = "${pageContext.request.contextPath}/region/gugun?sidocode=" + param;
	    }
	    else if (level === "dong") {
	        url = "${pageContext.request.contextPath}/region/dong?guguncode=" + param;
	    }
	
	    $.ajax({
	        url: url,
	        type: "GET",
	        dataType: "json",
	
	        success: function(regionData) {
	
	        	 $targetSelect.empty().append('<option value="">--선택--</option>');

	             if (!regionData || regionData.length === 0) {
	                 console.log("지역 데이터 없음");
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
	        },
	
	        error: function(xhr, status, error) {
	            console.log("지역 API 호출 실패:", error);
	            $targetSelect.empty().append('<option value="">--로딩 실패--</option>');
	        }
	    });
	}
	
	
	//----------------------------------------------------------
	//  지역 관련 document.ready
	//----------------------------------------------------------
	$(document).ready(function() {
		
		$("#gugunCategory").html('<option value="">-- 구/군 선택 --</option>');
        $("#dongCategory").html('<option value="">-- 동/읍/면 선택 --</option>');
	
	    // 최초 시도 로딩
	    fetchRegionData('0', $("#sidoCategory"), 'sido');
	
	    // 시도 선택 시 구군 로딩
	    $("#sidoCategory").change(function() {
	        var sidoCode = $(this).val();
	
	        $("#gugunCategory").html('<option value="">-- 구/군 선택 --</option>');
	        $("#dongCategory").html('<option value="">-- 동/읍/면 선택 --</option>');
	
	        if (sidoCode) {
	            fetchRegionData(sidoCode, $("#gugunCategory"), 'gugun');
	        }
	    });
	
	    // 구군 선택 시 동 로딩
	    $("#gugunCategory").change(function() {
	        var gugunCode = $(this).val();
	
	        $("#dongCategory").html('<option value="">-- 동/읍/면 선택 --</option>');
	
	        if (gugunCode) {
	            fetchRegionData(gugunCode, $("#dongCategory"), 'dong');
	        }
	    });
	    
		 // 시도 변경 → hidden 저장
	    $("#sidoCategory").change(function() {
	        let name = $("#sidoCategory option:selected").text();
	        $("#sidoText").val(name);
	    });

	    // 구군 변경 → hidden 저장
	    $("#gugunCategory").change(function() {
	        let name = $("#gugunCategory option:selected").text();
	        $("#gugunText").val(name);
	    });

	    // 동 변경 → hidden 저장
	    $("#dongCategory").change(function() {
	        let name = $("#dongCategory option:selected").text();
	        $("#dongText").val(name);
	    });

	});
</script>

</head>
<body>
	<%@ include file="/WEB-INF/views/hobbymate-header.jsp" %>

<div class="container my-5" style="max-width: 800px;">

    <h1 class="text-center fw-bold text-primary mb-4">
        모임 생성하기
    </h1>

    <form:form id="createClubForm"
               modelAttribute="NewClub"
               action="${pageContext.request.contextPath}/club/create"
               method="post"
               enctype="multipart/form-data"
               class="bg-white rounded-4 shadow-sm p-4">

        <!-- 모임 이름 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-users me-1"></i> 모임 이름 <span class="text-danger">*</span>
            </label>
            <form:input path="cName"
                        id="cName"
                        class="form-control"
                        required="required"
                        maxlength="15"
                        placeholder="15자 이내로 입력하세요"/>
        </div>

        <!-- 모임 설명 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-info-circle me-1"></i> 모임 설명
            </label>
            <form:textarea path="cDescription"
                           class="form-control"
                           rows="3"
                           placeholder="모임의 성격과 활동 내용을 간단히 설명해주세요."/>
        </div>

        <!-- 대표 이미지 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-image me-1"></i> 모임 대표 사진
            </label>
            <input type="file"
                   class="form-control"
                   id="cMainImage"
                   name="cMainImage">
            <div class="form-text">
                모임의 대표 이미지를 등록해 주세요.
            </div>
        </div>

        <!-- 최대 인원 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-user-plus me-1"></i> 모임 최대 인원 <span class="text-danger">*</span>
            </label>
            <form:input path="cMaxMembers"
                        type="number"
                        class="form-control"
                        min="2"
                        max="50"/>
        </div>

        <!-- 카테고리 -->
        <div class="mb-4">
            <label class="form-label fw-semibold">
                <i class="fas fa-tags me-1"></i> 모임 분류 (최대 3개) <span class="text-danger">*</span>
            </label>

            <div class="input-group mb-2">
                <select id="topCategory" class="form-select"></select>
                <select id="midCategory" class="form-select mx-1"></select>
                <select id="subCategory" class="form-select"></select>

                <button type="button"
                        id="addCategoryBtn"
                        class="btn btn-outline-primary ms-2">
                    <i class="fas fa-plus"></i> 추가
                </button>
            </div>

            <input type="hidden" id="categoryIds" name="categoryIds" />

            <ul id="selectedCategoryList"
                class="list-unstyled d-flex flex-wrap gap-2 mt-2">
            </ul>
        </div>

        <!-- 지역 -->
        <div class="mb-4">
            <label class="form-label fw-semibold">
                <i class="fas fa-map-marker-alt me-1"></i> 모임 지역 선택 <span class="text-danger">*</span>
            </label>

            <div class="input-group">
                <select id="sidoCategory" name="cSiDoCode" class="form-select"></select>
                <select id="gugunCategory" name="cGuGunCode" class="form-select mx-1"></select>
                <select id="dongCategory" name="cDongCode" class="form-select"></select>
            </div>

            <input type="hidden" id="sidoText" name="cSiDo" />
            <input type="hidden" id="gugunText" name="cGuGun" />
            <input type="hidden" id="dongText" name="cDong" />
        </div>

        <!-- 주 모임 장소 -->
        <div class="mb-4">
            <label class="form-label fw-semibold">
                <i class="fas fa-location-arrow me-1"></i> 주 모임 장소 (선택)
            </label>
            <form:input path="cMainPlace"
                        class="form-control"
                        placeholder="예: 강남역 11번 출구 스터디룸"/>
        </div>

        <!-- 제출 -->
        <div class="text-end">
            <button type="submit" class="btn btn-primary px-5">
                모임 생성하기
            </button>
        </div>

    </form:form>
</div>
	<script>
           $(document).ready(function () {
   
               $("#createClubForm").submit(function (e) {
   
                   // 카테고리 하나도 안 추가한 경우
                   if (selectedCategoryIds.length === 0) {
                       alert("카테고리를 추가하려면 [추가] 버튼을 눌러주세요.");
                       e.preventDefault(); // submit 중단
                       return false;
                   }
   
               });
   
           });
        </script>
</body>
</html>