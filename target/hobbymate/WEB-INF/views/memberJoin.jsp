<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<title>회원가입</title>

<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">

<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">

<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>

<div class="container my-5">
    <div class="card shadow-sm p-4 rounded-4" style="max-width:900px;margin:0 auto;">

        <h3 class="fw-bold mb-4 ms-1">회원가입</h3>

        <form action="<c:url value='/member/join'/>" method="post" enctype="multipart/form-data">
            <div class="row g-4">

                <div class="col-md-4 text-center border-end pe-4">

                    <img src="<c:url value='/resources/images/profile/user-default.png'/>"
                         class="rounded-circle mt-5 mb-4"
                         style="width:130px;height:130px;object-fit:cover; border:1px solid #ddd;">
                    
                    <div class="mt-3">
                        <label class="fw-semibold small d-block mb-1">프로필 이미지</label>
                        <input type="file" name="mProfileImage" class="form-control form-control-sm">
                    </div>

                </div>

                <div class="col-md-8 ps-5" style="line-height:1.55;">

                    <h6 class="fw-bold fs-2 mb-3">기본 정보</h6>

                    <div class="mb-3">
                        <label class="fw-semibold">아이디</label>
                        <input type="text" id="mId" name="mId" oninput="checkId()" required class="form-control">
                        <span id="idMsg" class="small"></span>
                    </div>
                    
                    <div class="mb-3">
                        <label class="fw-semibold">비밀번호</label>
                        <input type="password" name="mPw" required class="form-control">
                    </div>

                    <div class="mb-3">
                        <label class="fw-semibold">이름</label>
                        <input type="text" name="mName" required class="form-control">
                    </div>

                    <div class="mb-3">
                        <label class="fw-semibold">나이</label>
                        <input type="number" name="mAge" required class="form-control">
                    </div>

                    <div class="mb-3">
                        <label class="fw-semibold me-3">성별</label>
                        <label class="me-3">
                            <input type="radio" name="mGender" value="남성" required> 남성
                        </label>
                        <label>
                            <input type="radio" name="mGender" value="여성"> 여성
                        </label>
                    </div>

                    <div class="mb-3">
                        <label class="fw-semibold">전화번호</label>
                        <input type="text" id="mPhone" name="mPhone" maxlength="11" required class="form-control"
                              placeholder="숫자만 입력(010 포함 11자리)" 
                              oninput="this.value = this.value.replace(/[^0-9]/g, ''); checkPhone();">
                        <span id="phoneMsg" class="small"></span>
                    </div>

                    <hr class="my-4" style="opacity:0.15;">
 
                    <h5 class="fw-bold mt-4 mb-3">주소 입력</h5>

                    <label class="form-label fw-semibold">우편번호</label>
					<div class="mb-3 d-flex">
						<input type="text" id="postcode" class="form-control me-2" placeholder="우편번호" style="max-width:150px;" readonly>
						<button type="button" id="btnAddr" class="btn btn-outline-primary rounded-pill px-3">
							주소 검색
						</button>
					</div>

					<div class="mb-3">
						<label class="form-label fw-semibold">기본 주소</label>
						<input type="text" id="roadAddress" class="form-control" placeholder="기본주소" readonly>
					</div>

					<div class="mb-2">
						<label class="form-label fw-semibold">상세 주소</label>
						<input type="text" id="detailAddress" class="form-control" placeholder="상세주소를 입력하세요">
					</div>
					
					<input type="hidden" id="mAddress" name="mAddress">
					
					<input type="hidden" id="mSiDo" name="mSiDo">
					<input type="hidden" id="mGuGun" name="mGuGun">
					<input type="hidden" id="mDong" name="mDong">
					
					
                    <hr class="my-4" style="opacity:0.15;">
                   
                    <h6 class="fw-bold fs-2 mb-3">관심 분야 (3개)</h6>

                    <div class="mb-4">
                        <label class="fw-semibold d-block mb-2">관심분야 1</label>
                        <select id="ct1_lv1" class="form-select mb-2" onchange="loadSubCategory('ct1_lv1')">
                            <option value="">대분류 선택</option>
                        </select>
                        <select id="ct1_lv2" class="form-select mb-2" onchange="loadSubCategory('ct1_lv2')">
                            <option value="">중분류 선택</option>
                        </select>
                        <select id="ct1_lv3" name="favCategory1" required class="form-select">
                            <option value="">소분류 선택</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="fw-semibold d-block mb-2">관심분야 2</label>
                        <select id="ct2_lv1" class="form-select mb-2" onchange="loadSubCategory('ct2_lv1')">
                            <option value="">대분류 선택</option>
                        </select>
                        <select id="ct2_lv2" class="form-select mb-2" onchange="loadSubCategory('ct2_lv2')">
                            <option value="">중분류 선택</option>
                        </select>
                        <select id="ct2_lv3" name="favCategory2" required class="form-select">
                            <option value="">소분류 선택</option>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label class="fw-semibold d-block mb-2">관심분야 3</label>
                        <select id="ct3_lv1" class="form-select mb-2" onchange="loadSubCategory('ct3_lv1')">
                            <option value="">대분류 선택</option>
                        </select>
                        <select id="ct3_lv2" class="form-select mb-2" onchange="loadSubCategory('ct3_lv2')">
                            <option value="">중분류 선택</option>
                        </select>
                        <select id="ct3_lv3" name="favCategory3" required class="form-select">
                            <option value="">소분류 선택</option>
                        </select>
                    </div>
                    
                    <div id="categoryError" class="mt-2 small" style="color:red;"></div>
                    
                    <div class="mt-4">
                        <input type="submit" value="회원가입" class="btn btn-primary rounded-pill px-4 py-2">
                    </div>

                </div>
            </div>
        </form>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
	let timeoutId = null;
	let isIdValid = false; 
	let isIdChecked = false;
	
	function checkId() {
		clearTimeout(timeoutId);
		timeoutId = setTimeout(() => {
			doCheckId();
			}, 300);
	}
	
	function doCheckId() {
		const mId = $("#mId").val();
		const idMsg = $("#idMsg");
		
		isIdChecked = false;
        isIdValid = false;
		
        const idPattern = /^(?=.*[a-z])(?=.*[0-9])[a-z0-9]{5,15}$/;
		
		if (!idPattern.test(mId)) {
			idMsg.css("color", "red").text("아이디는 영문 소문자 + 숫자 5~15자여야 합니다.");
			
			isIdChecked = true;
            isIdValid = false;
			
			return;
		}
		
		$.ajax({
			url: "<c:url value='/member/checkId'/>",
			type: "GET",
			data: { mId: mId },
			success: function(result) {
			    if (result === "OK") {
			        idMsg.css("color", "green").text("✔ 사용 가능한 아이디입니다.");
			        isIdValid = true;
			    } else if (result === "INVALID") {
			        idMsg.css("color", "red")
			             .text("아이디는 영문 소문자와 숫자를 반드시 포함한 5~15자여야 합니다.");
			        isIdValid = false;
			    } else {
			        idMsg.css("color", "red").text("❌ 이미 존재하는 아이디입니다.");
			        isIdValid = false;
			    }
			    isIdChecked = true;
			}
		});
	}
</script>

<script>
let isPhoneValid = false;

function checkPhone() {
    let phone = document.getElementById("mPhone").value;
    let msg = document.getElementById("phoneMsg");
    
    isPhoneValid = false;

    // 숫자만 입력하도록 이미 oninput에서 처리됨
    if (phone.length < 10) {
        msg.style.color = "red";
        msg.innerHTML = "전화번호를 정확히 입력해주세요.";
        return;
    }

    $.ajax({
        url: "<c:url value='/member/checkPhone'/>",
        type: "GET",
        data: { phone: phone },
        success: function(result) {
            if (result === "OK") {
                msg.style.color = "green";
                msg.innerHTML = "✔ 사용 가능한 번호입니다.";
                isPhoneValid = true;
            } else {
                msg.style.color = "red";
                msg.innerHTML = "❌ 이미 등록된 번호입니다.";
                isPhoneValid = false;
            }
        },
        error: function() {
            // ⭐ 추가: 오류 발생 시 유효하지 않다고 설정
            isPhoneValid = false;
            console.log("전화번호 Ajax 요청 실패");
        }
    });
}
</script>

<script>
	window.onload = function(){
		loadLevel1Categories();
	
	}
	
	function loadLevel1Categories(){
		$.ajax({
	        url: "${ctx}/category/top",
	        type: "GET",
	        dataType: "json",
	        success: function(list) {
	        	console.log(list)
	            const select1 = document.getElementById("ct1_lv1");
	            const select2 = document.getElementById("ct2_lv1");
	            const select3 = document.getElementById("ct3_lv1");
	           
	            let opts = "<option value=''>대분류 선택</option>"; // value="" 추가
	            list.forEach(ct => {
	                opts += "<option value=" + ct.ctId + ">"+ct.ctName+"</option>";
	            });
	            
	            // 이미 option "대분류 선택"이 있으므로 += 대신 = 사용
	            select1.innerHTML = opts; 
	            select2.innerHTML = opts;
	            select3.innerHTML = opts;
	            
	        },
	        error: function(xhr) {
	            console.log("level1 로딩 오류", xhr.status);
	        }
	    });
	}
	
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
		
		// "선택하세요" 텍스트와 value="" 추가
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
</script>

<script>
	function validateCategories() {
		const c1 = document.getElementById("ct1_lv3").value;
		const c2 = document.getElementById("ct2_lv3").value;
		const c3 = document.getElementById("ct3_lv3").value;
		
		const errorBox = document.getElementById("categoryError");
		
		errorBox.innerHTML = "";
		
		if (!c1 || !c2 || !c3)return true;
	
		if (c1 === c2 || c1 === c3 || c2 === c3){
			errorBox.innerHTML = "❌ 관심분야는 서로 다른 카테고리로 선택해야 합니다.";
			alert("관심분야를 최소 3개 선택하세요.")
			return false;
		}
		
		return true;
	}
	
	//중복시 회원가입 막기
	document.querySelector("form").addEventListener("submit", function(e){
		//폼 제출 전 최종 주소 업데이트
	    updateFullAddress();
		
	    let isValid = true;
	    
	 // 1. 아이디 유효성 검사 (검사 완료 필수)
        if (!isIdChecked || !isIdValid) {
            alert("회원가입 전에 아이디 유효성 및 중복 검사를 완료하고 확인해주세요.");
            e.preventDefault();
            isValid = false;
        }
        
        // 2. 전화번호 유효성 검사
        if (isValid && !isPhoneValid) { 
            alert("전화번호 유효성 및 중복 검사를 완료하고 확인해주세요.");
            e.preventDefault();
            isValid = false;
        }
		
		if (!validateCategories()){
			e.preventDefault();
			isValid = false;
		}
	});
	
	document.querySelectorAll("#ct1_lv3, #ct2_lv3, #ct3_lv3")
		.forEach(select => {
			select.addEventListener("change", validateCategories);
		});
</script>


<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
	$(document).ready(function(){
		
		// 주소 검색 버튼 클릭 이벤트 추가
        $("#btnAddr").on("click", function(){
            execDaumPostcode();
        });
	
	    // 상세주소 입력 시 통합주소 업데이트
	    $("#detailAddress").on("input", function(){
	        updateFullAddress();
	    });
	
	    // 폼 제출 시 통합주소 최종 업데이트 (submit 이벤트 핸들러에 이미 포함됨)
	
	});
	
	// ----------------------------------------------------------
	// 주소 팝업 호출 (setTimeout 적용)
	// ----------------------------------------------------------
	function execDaumPostcode() {
	    new daum.Postcode({
	        oncomplete: function(data) {
	
	            // 기본 주소 입력
	            $("#postcode").val(data.zonecode);
	            $("#roadAddress").val(data.roadAddress);
	            $("#detailAddress").val(""); // 상세주소 초기화
	
	            // 행정구역 분리 (DOM 쓰기 작업)
	            parseRegion(data);
	
	            // ★★★ DOM 쓰기 완료 후 다음 사이클에 실행되도록 분리 ★★★
	            setTimeout(function() {
	                updateFullAddress(); // 통합주소 업데이트
	                console.log("주소검색 완료 후 최종 mAddress:", $("#mAddress").val());
	            }, 0);
	        }
	    }).open();
	}
	
	// ----------------------------------------------------------
	// 통합주소 생성 (순수 JS + 문자열 연결)
	// ----------------------------------------------------------
	function updateFullAddress() {
	    // 1. 순수 JS로 DOM 값 읽기 (jQuery val() 사용 금지)
	    const postcode = document.getElementById("postcode").value;
	    const road = document.getElementById("roadAddress").value;
	    const detail = document.getElementById("detailAddress").value; 
	    
	    // 디버그 로그 (순수 JS 값이 정상인지 다시 확인)
	    console.log("순수 JS 읽기 (재확인): postcode=", postcode, "road=", road);

	    if (!postcode || !road) {
	        $("#mAddress").val("");
	        console.log("updateFullAddress() 실행 → 주소 미선택");
	        return;
	    }
	    
	    // 2. 템플릿 리터럴 대신 문자열 연결 사용
	    let fullAddress = "(" + postcode + ") " + road;

	    if (detail && detail.trim() !== "") {
	        fullAddress += " " + detail.trim();
	    }
	    
	    $("#mAddress").val(fullAddress);
	    console.log("updateFullAddress() 실행 →", fullAddress); // 디버그 로그 추가
	}
	
	// ----------------------------------------------------------
	// 주소로부터 시/도, 구/군, 동 자동 추출
	// ----------------------------------------------------------
	function parseRegion(data) {
	
	    // "서울특별시 강남구 테헤란로 123"
	    //const address = data.roadAddress;
	    //const parts = address.split(" ");
	
	    $("#mSiDo").val(data.sido);     // 서울특별시
	    $("#mGuGun").val(data.sigungu);    // 강남구
	
	    // 동/읍/면은 bname이 더 정확함
	    $("#mDong").val(data.bname);    // 역삼동
	}

</script>

</body>
</html>