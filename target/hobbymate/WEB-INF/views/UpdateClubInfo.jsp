<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 정보 수정</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">

<!-- 화면 기본 디자인 (CreateClub.jsp와 동일) -->


<script>
    let selectedCategoryIds = [];

    $(document).ready(function () {

        // 선택되어있는 카테고리 ID를 selectedCategoryIds 배열에 넣기
        <c:forEach var="entry" items="${categoryHierarchy}">
            selectedCategoryIds.push("${entry.key}");
        </c:forEach>

        $("#categoryIds").val(selectedCategoryIds.join(","));
        
        $("#midCategory").empty().append('<option value="">--중분류 선택--</option>');
        $("#subCategory").empty().append('<option value="">--소분류 선택--</option>');

        //1. 대분류로딩
        loadTopCategories();

        //2. 중분류로딩
        $("#topCategory").change(function () {
        	
            let parentId = $(this).val();
            $("#midCategory").empty().append('<option value="">--중분류 선택--</option>');
            $("#subCategory").empty().append('<option value="">--소분류 선택--</option>');

        	updateCategoryPreview();
        	
            if (parentId === "") return;

            $.ajax({
                url: "${pageContext.request.contextPath}/category/mid",
                type: "GET",
                data: { parentId: parentId },
                success: function (list) {
                    for (let i = 0; i < list.length; i++) {
                        $("#midCategory").append('<option value="' + list[i].ctId + '">' + list[i].ctName + '</option>');
                    }
                }
            });
        });

       //3. 소분류 로딩
        $("#midCategory").change(function () {
            let parentId = $(this).val();
            
            $("#subCategory").empty().append('<option value="">--소분류 선택--</option>');
            
        	updateCategoryPreview();
        	

            if (parentId === "") return;

            $.ajax({
                url: "${pageContext.request.contextPath}/category/sub",
                type: "GET",
                data: { parentId: parentId },
                success: function (list) {
                    for (let i = 0; i < list.length; i++) {
                        $("#subCategory").append('<option value="' + list[i].ctId + '">' + list[i].ctName + '</option>');
                    }
                }
            });
        });
       
        $("#subCategory").change(function () {
            updateCategoryPreview();
        });

        //카테고리 추가
        $("#addCategoryBtn").click(function () {
            let ctId = $("#subCategory").val();
            let ctName = $("#subCategory option:selected").text();
            let topName = $("#topCategory option:selected").text();
            let midName = $("#midCategory option:selected").text();

            if (ctId === "" || ctId == null) {
                alert("소분류를 선택하세요");
                return;
            }

            if (selectedCategoryIds.includes(ctId)) {
                alert("이미 선택한 카테고리입니다.");
                return;
            }

            selectedCategoryIds.push(ctId);

            $("#selectedCategoryList").append(
                "<li data-id='" + ctId + "'>" +
                topName + " > " + midName + " > " + ctName +
                " <button type='button' class='removeCt' data-id='" + ctId + "'>x</button></li>"
            );

            $("#categoryIds").val(selectedCategoryIds.join(","));
			
            $("#categoryPreview").text("");
            $("#midCategory").empty().append('<option value="">--중분류 선택--</option>');
            $("#subCategory").empty().append('<option value="">--소분류 선택--</option>');
            $("#topCategory").val("");
        });

        // X 버튼 누르면 카테고리를 삭제
        $(document).on("click", ".removeCt", function () {
            let id = $(this).data("id");

            selectedCategoryIds = selectedCategoryIds.filter(function (item) {
                return item != id;
            });

            $(this).parent().remove();
            $("#categoryIds").val(selectedCategoryIds.join(","));
        });
    });
    
  //선택한 카테고리 미리보기
    function updateCategoryPreview() {
    	let topName = $("#topCategory option:selected").text();
    	let midName = $("#midCategory option:selected").text();
    	let subName = $("#subCategory option:selected").text();
    	
    	if (topName.includes("선택") || midName.includes("선택") || subName.includes("선택")) {
            $("#categoryPreview").text("");
            return;
        }
    	
    	$("#categoryPreview").text(topName + " > " +midName + " > " + subName);
    }

    //ajax로 대분류 불러오기
    function loadTopCategories() {
        $.ajax({
            url: "${pageContext.request.contextPath}/category/top",
            type: "GET",
            success: function (list) {
                $("#topCategory").empty().append('<option value="">--대분류 선택--</option>');
                for (let i = 0; i < list.length; i++) {
                    $("#topCategory").append('<option value="' + list[i].ctId + '">' + list[i].ctName + '</option>');
                }
            }
        });
    }
    
</script>

<script>
/* -------------------------------------
   공통 지역 데이터 로딩 함수
-------------------------------------- */
function fetchRegionData(level, param, $select, callback) {

    let url = "";

    if (level === "sido") {
        url = "${pageContext.request.contextPath}/region/sido";
    }
    if (level === "gugun") {
        url = "${pageContext.request.contextPath}/region/gugun?sidocode=" + param;
    }
    if (level === "dong") {
        url = "${pageContext.request.contextPath}/region/dong?guguncode=" + param;
    }

    $.ajax({
        url: url,
        type: "GET",
        dataType: "json",

        success: function(list) {

            $select.empty();
            $select.append('<option value="">-- 선택 --</option>');

            list.forEach(function(item) {

                let code = item["법정동코드"];
                let name = "";

                // level에 따라 정확한 이름을 넣어준다
                if (level === "sido") {
                    name = item["시도명"];
                }
                else if (level === "gugun") {
                    name = item["시군구명"];
                }
                else if (level === "dong") {
                    name = item["읍면동명"];
                }

                $select.append('<option value="' + code + '">' + name + '</option>');
            });

            if (callback) callback();
        }
    });
}


// 기존 지역 자동 설정
function initRegion() {
	
    let sido = "${club.cSiDoCode}";
    let gugun = "${club.cGuGunCode}";
    let dong = "${club.cDongCode}";

    fetchRegionData("sido", null, $("#sidoCategory"), function () {
        $("#sidoCategory").val(sido);

        fetchRegionData("gugun", sido, $("#gugunCategory"), function () {
            $("#gugunCategory").val(gugun);

            fetchRegionData("dong", gugun, $("#dongCategory"), function () {
                $("#dongCategory").val(dong);
            });
        });
    });
}

$(document).ready(function () {

    // 자동 선택은 살짝 늦게 실행
    setTimeout(initRegion, 100);

    // 시/도 변경 시
    $("#sidoCategory").change(function () {
        let code = $(this).val(); // 선택한 시/도 코드
        let name = $("#sidoCategory option:selected").text(); // "경상남도" 같은 이름

        // hidden에 시/도 이름 저장
        $("#cSiDo").val(name);

        // 하위 셀렉트 초기화
        $("#gugunCategory").html('<option value="">-- 구/군 선택 --</option>');
        $("#dongCategory").html('<option value="">-- 동 선택 --</option>');

        if (!code) return; // 아무 것도 선택 안 했으면 종료

        // 선택된 시/도의 구/군 목록 불러오기
        fetchRegionData("gugun", code, $("#gugunCategory"));
    });

    // 구/군 변경 시
    $("#gugunCategory").change(function () {
        let code = $(this).val();
        let name = $("#gugunCategory option:selected").text();

        $("#cGuGun").val(name);

        $("#dongCategory").html('<option value="">-- 동 선택 --</option>');

        if (!code) return;

        fetchRegionData("dong", code, $("#dongCategory"));
    });

    // 동 변경 시
    $("#dongCategory").change(function () {
        let name = $("#dongCategory option:selected").text();
        $("#cDong").val(name);
    });
});

</script>


</head>
<body>

<%@ include file="/WEB-INF/views/hobbymate-header.jsp" %>

<div class="container my-5" style="max-width: 800px;">

    <h1 class="text-center fw-bold text-primary mb-4">
        모임 정보 수정
    </h1>

    <form action="${pageContext.request.contextPath}/club/update"
          method="post"
          enctype="multipart/form-data"
          class="bg-white rounded-4 shadow-sm p-4">

        <input type="hidden" name="cId" value="${club.cId}" />
        <input type="hidden" id="categoryIds" name="categoryIds" />
        <input type="hidden" name="existingImage" value="${club.cMainImageName}">
        <input type="hidden" name="cMemberCount" value="${club.cMemberCount}">

        <!-- 모임 이름 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-users me-1"></i> 모임 이름 <span class="text-danger">*</span>
            </label>
            <input type="text"
                   name="cName"
                   value="${club.cName}"
                   class="form-control"
                   required />
        </div>

        <!-- 모임 설명 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-info-circle me-1"></i> 모임 설명
            </label>
            <textarea name="cDescription"
                      class="form-control"
                      rows="3">${club.cDescription}</textarea>
        </div>

        <!-- 대표 이미지 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-image me-1"></i> 모임 대표 이미지
            </label>

            <c:if test="${not empty club.cMainImage}">
                <div class="mb-2">
                    <img src="<c:url value='/resources/upload/club/${club.cMainImage}'/>"
                         class="img-fluid rounded"
                         style="max-width: 300px;">
                </div>
            </c:if>

            <input type="file"
                   class="form-control"
                   name="cMainImage"
                   accept="image/*">

            <div class="form-text">
                새 이미지를 선택하지 않으면 기존 이미지가 유지됩니다.
            </div>
        </div>

        <!-- 지역 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-map-marker-alt me-1"></i> 모임 지역 <span class="text-danger">*</span>
            </label>

            <div class="input-group">
                <select id="sidoCategory" name="cSiDoCode" class="form-select"></select>
                <select id="gugunCategory" name="cGuGunCode" class="form-select mx-1"></select>
                <select id="dongCategory" name="cDongCode" class="form-select"></select>
            </div>

            <input type="hidden" id="cSiDo" name="cSiDo" value="${club.cSiDo}">
            <input type="hidden" id="cGuGun" name="cGuGun" value="${club.cGuGun}">
            <input type="hidden" id="cDong" name="cDong" value="${club.cDong}">

            <input type="text"
                   class="form-control mt-2"
                   readonly
                   value="${club.cSiDo} ${club.cGuGun} ${club.cDong}">
        </div>

        <!-- 최대 인원 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-user-plus me-1"></i> 모임 최대 인원
            </label>
            <input type="number"
                   name="cMaxMembers"
                   value="${club.cMaxMembers}"
                   min="2" max="50"
                   class="form-control">
        </div>

        <!-- 현재 카테고리 -->
        <div class="mb-3">
            <label class="form-label fw-semibold">
                <i class="fas fa-tags me-1"></i> 현재 카테고리
            </label>

            <ul class="list-unstyled d-flex flex-wrap gap-2">
                <c:forEach var="entry" items="${categoryHierarchy}">
                    <li class="badge bg-secondary-subtle text-secondary rounded-pill px-3 py-2">
                        ${entry.value[2].ctName} &gt;
                        ${entry.value[1].ctName} &gt;
                        ${entry.value[0].ctName}
                        <button type="button"
                                class="btn-close ms-2 removeCt"
                                data-id="${entry.key}">
                        </button>
                    </li>
                </c:forEach>
            </ul>
        </div>

        <!-- 새 카테고리 -->
        <div class="mb-4">
            <label class="form-label fw-semibold">
                <i class="fas fa-plus-circle me-1"></i> 새 카테고리 추가
            </label>

            <div class="input-group mb-2">
                <select id="topCategory" class="form-select"></select>
                <select id="midCategory" class="form-select mx-1"></select>
                <select id="subCategory" class="form-select"></select>
            </div>

            <div id="categoryPreview" class="text-muted small mb-2"></div>

            <button type="button" id="addCategoryBtn"
                    class="btn btn-outline-primary rounded-pill px-4">
                <i class="fas fa-plus"></i> 카테고리 추가
            </button>
        </div>

        <div class="text-end">
            <button type="submit" class="btn btn-primary px-5">
                모임 정보 저장
            </button>
        </div>

    </form>
</div>

</body>
</html>