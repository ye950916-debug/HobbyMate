<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<title>회원 정보 수정</title>

<!-- Bootstrap -->
<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">

<!-- Theme CSS -->
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">

<meta name="viewport" content="width=device-width, initial-scale=1">

</head>
<body>

<div class="container my-5">

    <div class="card shadow-sm p-4 rounded-4" style="max-width:900px;margin:0 auto;">

        <h3 class="fw-bold mb-4 ms-1">회원 정보 수정</h3>

        <form action="<c:url value='/member/update'/>" method="post" enctype="multipart/form-data">

            <div class="row g-4">

                <!-- LEFT : 프로필 -->
                <div class="col-md-4 text-center border-end pe-4">

                    <!-- 프로필 이미지 -->
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

                    <!-- 이름 + ID -->
                    <h5 class="fw-bold mb-1">${member.mName}님</h5>
                    <span class="small text-muted d-block mt-1">ID : ${member.mId}</span>

                    <!-- 새 프로필 업로드 -->
                    <div class="mt-3">
                        <label class="fw-semibold small d-block mb-1">새 프로필 이미지</label>
                        <input type="file" name="mProfileImage" class="form-control form-control-sm">
                    </div>

                    <!-- 기존 이미지 삭제 -->
                    <c:if test="${not empty member.mProfileImageName}">
                        <div class="mt-2">
                            <label class="small">
                                <input type="checkbox" name="deleteImage" value="yes"> 기존 이미지 삭제
                            </label>
                        </div>
                    </c:if>

                </div>

                <!-- RIGHT -->
                <div class="col-md-8 ps-5" style="line-height:1.55;">

                    <!-- 기본 정보 -->
                    <h6 class="fw-bold fs-2 mb-3">기본 정보</h6>

                    <div class="mb-3">
                        <label class="fw-semibold">아이디</label>
                        <input type="text" class="form-control" name="mId" value="${member.mId}" readonly>
                    </div>

                    <div class="mb-3">
                        <label class="fw-semibold">비밀번호</label>
                        <input type="password" class="form-control" name="mPw" value="${member.mPw}">
                    </div>

                    <div class="mb-3">
                        <label class="fw-semibold">이름</label>
                        <input type="text" class="form-control" name="mName" value="${member.mName}">
                    </div>

                    <div class="mb-3">
                        <label class="fw-semibold">나이</label>
                        <input type="number" class="form-control" name="mAge" value="${member.mAge}">
                    </div>

                    <div class="mb-3">
					    <label class="fw-semibold me-2">성별</label>
					
					    <!-- 보여지는 라디오 버튼: 선택은 불가능 (disabled) -->
					    <label class="me-3">
					        <input type="radio" value="남성"
					            <c:if test="${member.mGender=='남성'}">checked</c:if> disabled> 남성
					    </label>
					
					    <label>
					        <input type="radio" value="여성"
					            <c:if test="${member.mGender=='여성'}">checked</c:if> disabled> 여성
					    </label>
					
					    <!-- 진짜 서버로 전달될 값 (수정 불가) -->
					    <input type="hidden" name="mGender" value="${member.mGender}">
					</div>

                    <div class="mb-3">
                        <label class="fw-semibold">전화번호</label>
                        <input type="text" class="form-control" id="mPhone" maxlength="11"
                               name="mPhone" value="${member.mPhone}"
                               oninput="this.value=this.value.replace(/[^0-9]/g,''); checkPhoneUpdate();">
                        <span id="phoneMsg" class="small"></span>
                    </div>

                    <hr class="my-4" style="opacity:0.15;">
			

                   <!-- 주소 수정 -->
					<h5 class="fw-bold mt-4 mb-3">주소 수정</h5>
					
					<!-- 기존 주소에서 우편번호만 추출 -->
					<c:set var="firstPart" value="${fn:split(member.mAddress, ' ')[0]}" />
					<c:set var="postcodeVal" value="${fn:replace(fn:replace(firstPart, '(', ''), ')', '')}" />
					
					<%-- (기존) 기존 주소에서 우편번호 제거한 기본주소(도로명)를 추출 --%>
					<c:set var="addressWithoutPostcode" value="${fn:trim(fn:substringAfter(member.mAddress, ')'))}" />
					
					<label class="form-label fw-semibold">우편번호</label>
					<div class="mb-3 d-flex">
					    <input type="text" id="postcode"
					           class="form-control me-2"
					           placeholder="우편번호"
					           style="max-width:150px;"
					           value="${postcodeVal}"
					           readonly>
					    <button type="button" id="btnAddr"
					            class="btn btn-outline-primary rounded-pill px-3">
					        주소 검색
					    </button>
					</div>
					
					<div class="mb-3">
					    <label class="form-label fw-semibold">기본 주소</label>
					    <input type="text" id="roadAddress"
					           class="form-control"
					           placeholder="도로명 주소"
					           value="" <%-- ⭐️ 기존 주소 값 제거 (JS에서 로드할 예정) --%>
					           readonly>
					</div>
					
					<div class="mb-2">
					    <label class="form-label fw-semibold">상세 주소</label>
					    <input type="text" id="detailAddress"
					           class="form-control"
					           placeholder="상세 주소를 입력하세요"
					           value=""> <%-- ⭐️ 기존 주소 값 제거 (JS에서 로드할 예정) --%>
					</div>
					
					                                
					<input type="hidden" id="mAddress" name="mAddress" value="${member.mAddress}">
					<input type="hidden" id="mSiDo" name="mSiDo" value="${member.mSiDo}">
					<input type="hidden" id="mGuGun" name="mGuGun" value="${member.mGuGun}">
					<input type="hidden" id="mDong" name="mDong" value="${member.mDong}">
					
					<%-- ⭐️ 추가: 기존의 전체 주소를 그대로 보관하는 hidden 필드 추가 --%>
					<input type="hidden" id="originalFullAddress" value="${member.mAddress}">

                    <hr class="my-4" style="opacity:0.15;">

                    <!-- 관심 분야 -->
                    <h6 class="fw-bold fs-2 mb-3">관심 분야 (3개)</h6>

                    <!-- 관심분야 1 -->
                    <div class="mb-4">
                        <label class="fw-semibold d-block mb-2">관심분야 1</label>
                        <select id="ct1_lv1" class="form-select mb-2" onchange="loadSubCategory('ct1_lv1')"></select>
                        <select id="ct1_lv2" class="form-select mb-2" onchange="loadSubCategory('ct1_lv2')"></select>
                        <select id="ct1_lv3" name="favCategory1" class="form-select"></select>
                    </div>

                    <!-- 관심분야 2 -->
                    <div class="mb-4">
                        <label class="fw-semibold d-block mb-2">관심분야 2</label>
                        <select id="ct2_lv1" class="form-select mb-2" onchange="loadSubCategory('ct2_lv1')"></select>
                        <select id="ct2_lv2" class="form-select mb-2" onchange="loadSubCategory('ct2_lv2')"></select>
                        <select id="ct2_lv3" name="favCategory2" class="form-select"></select>
                    </div>

                    <!-- 관심분야 3 -->
                    <div class="mb-4">
                        <label class="fw-semibold d-block mb-2">관심분야 3</label>
                        <select id="ct3_lv1" class="form-select mb-2" onchange="loadSubCategory('ct3_lv1')"></select>
                        <select id="ct3_lv2" class="form-select mb-2" onchange="loadSubCategory('ct3_lv2')"></select>
                        <select id="ct3_lv3" name="favCategory3" class="form-select"></select>
                    </div>

                    <!-- hidden: 기존 선택값 -->
                    <input type="hidden" id="p1_lv1" value="${favLv1[0]}">
                    <input type="hidden" id="p1_lv2" value="${favLv2[0]}">
                    <input type="hidden" id="p1_lv3" value="${favLv3[0]}">

                    <input type="hidden" id="p2_lv1" value="${favLv1[1]}">
                    <input type="hidden" id="p2_lv2" value="${favLv2[1]}">
                    <input type="hidden" id="p2_lv3" value="${favLv3[1]}">

                    <input type="hidden" id="p3_lv1" value="${favLv1[2]}">
                    <input type="hidden" id="p3_lv2" value="${favLv2[2]}">
                    <input type="hidden" id="p3_lv3" value="${favLv3[2]}">

                    <div class="mt-4">
                        <button type="submit" class="btn btn-primary rounded-pill px-4 py-2">
                            수정 완료
                        </button>
                        
                         <a href="<c:url value='/member/${member.mId}'/>" 
					       class="btn btn-outline-secondary rounded-pill px-4 py-2">
					        돌아가기
					   	 </a>
                    </div>

                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>

	function loadSubCategory(parentSelectId){
		const parentId = document.getElementById(parentSelectId).value;
		
		let url = "";
		
		if (parentSelectId.endsWith("lv1")){
			url = "${ctx}/category/mid";
		}
		
		if (parentSelectId.endsWith("lv2")){
			url = "${ctx}/category/sub";
		}
		
		let childSelectId = "";
		
		if(parentSelectId === "ct1_lv1") childSelectId = "ct1_lv2";
		if(parentSelectId === "ct2_lv1") childSelectId = "ct2_lv2";
		if(parentSelectId === "ct3_lv1") childSelectId = "ct3_lv2";
		
		if(parentSelectId === "ct1_lv2") childSelectId = "ct1_lv3";
		if(parentSelectId === "ct2_lv2") childSelectId = "ct2_lv3";
		if(parentSelectId === "ct3_lv2") childSelectId = "ct3_lv3";
		
		const child = document.getElementById(childSelectId);
		
		child.innerHTML = "<option value>선택하세요</option>";
		
		if(!parentId) return;
		
		$.ajax({
			url: url,
			type: "GET",
			data: { parentId: parentId },
			dataType: "json",
			success: function(list){
				list.forEach(ct => {
					child.innerHTML += "<option value=" + ct.ctId + ">"+ct.ctName+"</option>";
				});
			},
	        error: function() {
	            console.log("카테고리 불러오기 오류!");
	        }
	    });
	}



	function loadLevel1Categories(callback){
		$.ajax({
	        url: "${ctx}/category/top",
	        type: "GET",
	        dataType: "json",
	        success: function(list) {
	        	console.log(list)
	            const select1 = document.getElementById("ct1_lv1");
	            const select2 = document.getElementById("ct2_lv1");
	            const select3 = document.getElementById("ct3_lv1");
	           
	            let opts = "<option value=''>대분류 선택</option>";
	            list.forEach(ct => {
	                opts += "<option value='" + ct.ctId + "'>" + ct.ctName + "</option>";
	            });
	            
	                select1.innerHTML = opts;
	                select2.innerHTML = opts;
	                select3.innerHTML = opts;
	            
	            if (callback) callback();
	        }
		});
	}
            
	function setSelectValues(level1, level2, level3, p1, p2, p3){
		$("#" + level1).val(p1).trigger("change");
		
		setTimeout(() => {
		    $("#" + level2).val(p2).trigger("change");
		}, 200);
			
		setTimeout(() => {
			$("#" + level3).val(p3);
		}, 400);
	}
	
	$(document).ready(function(){
	    loadLevel1Categories(function(){
	        setSelectValues("ct1_lv1", "ct1_lv2", "ct1_lv3",
	            $("#p1_lv1").val(), $("#p1_lv2").val(), $("#p1_lv3").val());

	        setSelectValues("ct2_lv1", "ct2_lv2", "ct2_lv3",
	            $("#p2_lv1").val(), $("#p2_lv2").val(), $("#p2_lv3").val());

	        setSelectValues("ct3_lv1", "ct3_lv2", "ct3_lv3",
	            $("#p3_lv1").val(), $("#p3_lv2").val(), $("#p3_lv3").val());
	    });
	    
		    loadInitialAddress(); 
		    
			// 2) 주소 검색 버튼 (기존 유지)
			$("#btnAddr").on("click", function(){ execDaumPostcode(); }); 
			// 3) 상세주소 입력하면 전체주소 즉시 반영 (기존 유지)
			$("#detailAddress").on("input", function(){ updateFullAddress(); }); 
			// 4) 수정 버튼 눌렀을 때 마지막으로 mAddress 최신화 (기존 유지)
			$("form").on("submit", function(){ updateFullAddress(); }); 
	});

	
	
</script>

<!-- 주소api -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
	
	/* ----------------------------------------------------------
	1) 기존 주소를 기본 주소와 상세 주소로 분리하여 로드 (최종 수정)
	---------------------------------------------------------- */
	function loadInitialAddress(){
	    const fullAddress = $("#originalFullAddress").val(); 
	
	    if (!fullAddress) return;
	
	    // 1. 우편번호와 괄호 제거
	    const addressWithoutPostcode = fullAddress.replace(/^\([^)]+\)\s*/, '').trim(); 
	    
	    // 2. 분리 로직: 도로명 주소의 끝을 찾습니다.
	    // 도로명 주소는 '로' 또는 '길'로 끝나고, 그 뒤에 건물 번호(숫자, 숫자-숫자)가 붙습니다.
	    
	    // 이 정규식은 다음 두 가지 패턴을 모두 찾습니다.
	    // 1) '[도로명]길 [숫자] (-[숫자]까지)'   <- '번길 11-21' 형태 포함
	    // 2) '[도로명]로 [숫자] (-[숫자]까지)'
	    const roadEndPattern = /(로|길)\s*\d+(\s*-\s*\d+)?/g; 
	    let roadEndIndex = -1;
	    
	    // 주소 문자열에서 모든 일치 패턴을 찾고, 가장 마지막에 일치하는 패턴의 끝을 찾습니다.
	    let match;
	    while ((match = roadEndPattern.exec(addressWithoutPostcode)) !== null) {
	        // 일치하는 패턴의 끝 인덱스를 저장합니다.
	        roadEndIndex = match.index + match[0].length;
	    }
	
	    let roadAddressPart = addressWithoutPostcode;
	    let detailAddressPart = "";
	    
	    // 3. 분리 실행
	    if (roadEndIndex !== -1) {
	        // 도로명 주소 부분 (마지막 건물 번호 끝까지)
	        roadAddressPart = addressWithoutPostcode.substring(0, roadEndIndex).trim();
	        
	        // 상세 주소 부분 (도로명 주소 끝 이후의 모든 것)
	        detailAddressPart = addressWithoutPostcode.substring(roadEndIndex).trim();
	    }
	    
	    $("#roadAddress").val(roadAddressPart);
	    $("#detailAddress").val(detailAddressPart);
	    
	    console.log("초기 주소 로드 완료 - 기본:", roadAddressPart, " 상세:", detailAddressPart);
	}
		
	
	  /* ----------------------------------------------------------
	  2) 주소 검색 팝업 (setTimeout 적용)
	  ---------------------------------------------------------- */
	   function execDaumPostcode() {

	       new daum.Postcode({
	           oncomplete: function(data){

	               $("#postcode").val(data.zonecode);
	               $("#roadAddress").val(data.roadAddress);
	               $("#detailAddress").val("");

	               parseRegion(data);  

	               // ★★★ DOM 쓰기 완료 후 다음 사이클에 실행되도록 분리 ★★★
	               setTimeout(function() {
	                   updateFullAddress();  // 통합 주소 자동 저장
	                   console.log("주소 검색 완료 후 최종 mAddress:", $("#mAddress").val());
	               }, 0);
	           }
	       }).open();
	   }
	
	
	
	/* ----------------------------------------------------------
	   3) 시·도 / 구·군 / 동 자동 추출
	---------------------------------------------------------- */
	function parseRegion(data){
		
	    //const parts = data.roadAddress.split(" "); // ["서울특별시","강남구",...]
	
	    $("#mSiDo").val(data.sido);
	    $("#mGuGun").val(data.sigungu);
	    $("#mDong").val(data.bname);
	}
	
	
	
	/* ----------------------------------------------------------
	4) 최종 주소 "(우편번호) 기본주소 상세주소" 자동 구성 (수정)
	---------------------------------------------------------- */
	function updateFullAddress(){

	    // ★★★ 순수 JS로 DOM 값 읽기 (jQuery val() 사용 금지) ★★★
	    const postcode = document.getElementById("postcode").value || "";
	    const road = document.getElementById("roadAddress").value || "";
	    const detail = document.getElementById("detailAddress").value || "";
	    
	    // 1. 우편번호와 도로명이 없으면 mAddress를 비웁니다.
	    if (!postcode || !road) {
	        $("#mAddress").val("");
	        console.log("updateFullAddress() 실행 → 주소 미선택/초기화");
	        return;
	    }
	    
	    // 2. 기본 주소 포맷 구성 (문자열 연결 사용)
	    let fullAddress = "(" + postcode + ") " + road;

	    // 3. 상세 주소가 있으면 추가합니다.
	    if (detail.trim() !== "") {
	        fullAddress += " " + detail.trim();
	    }
	    
	    $("#mAddress").val(fullAddress);
	    console.log("updateFullAddress() 실행 →", fullAddress);
	}
</script>
<script>
	function checkPhoneUpdate(){
		const phone = document.getElementById("mPhone").value;
		const msg = document.getElementById("phoneMsg");
		const currentId = "${member.mId}";
		
		if (phone.length < 10){
			msg.style.color = "red";
			msg.innerHTML = "전화번호를 정확히 입력해주세요.";
			return;
		}
		
		$.ajax({
			url: "<c:url value='/member/checkPhone'/>",
			type: "GET",
			data: {
					phone: phone,
					currentId: currentId
			},
			success: function(result){
				if (result === "OK"){
					msg.style.color = "green";
					msg.innerHTML = "✔ 사용 가능한 번호입니다.";
				} else {
					msg.style.color = "red";
					msg.innerHTML = "❌ 이미 등록된 번호입니다.";
				}
			 }
		});
	}

</script>


</body>
</html>