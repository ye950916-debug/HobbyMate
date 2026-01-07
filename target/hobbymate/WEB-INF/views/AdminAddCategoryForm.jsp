<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 추가</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">


<script>
	$(document).ready(function(){
		
		//페이지 로딩시 parent 선택 박스 숨기기
		$("#parentTopDiv").hide();
		$("#parentMidDiv").hide();
		
		//level 변경시
		$("#levelSelect").change(function() {
			let level = $(this).val();
			
			if(level == "1") {
				$("#parentTopDiv").hide();
				$("#parentMidDiv").hide();
				$("#parentId").val("");
			}
			else if(level == "2") {
				$("#parentTopDiv").show();
				$("#parentMidDiv").hide();
				loadTopCategories();
			}
			else if(level == "3") {
				$("#parentTopDiv").show();
				$("#parentMidDiv").show();
				loadTopCategories();
			}
		});
		
		// 대분류 선택 -> 중분류 로딩
		$("#topCategory").change(function(){
			let parentId = $(this).val();
			$("#midCategory").empty().append('<option value="">--중분류 선택--</option>');
			
			if(parentId == "") return;
			
			$.ajax({
				url: "${pageContext.request.contextPath}/category/mid",
				type: "GET",
				data: {parentId: parentId},
				success: function(list) {
					for(let i=0; i<list.length; i++) {
						$("#midCategory").append('<option value="'+list[i].ctId+'">'+list[i].ctName +'</option>');
					}
				}
			});
		});
		
		$("form").submit(function() {
			let level = $("#levelSelect").val();
			
			if(level == "1") {
				$("#parentId").val("");
			}
			else if(level == "2") {
				let topId = $("#topCategory").val();
				if(topId == "") {
					alert("대분류를 선택하세요.");
					return false;
				}
				$("#parentId").val(topId);
			}
			else if(level == "3") {
				let midId = $("#midCategory").val();
				if(midId == "") {
					alert("중분류를 선택하세요.");
					return false;
				}
				$("#parentId").val(midId);
			}
			return true;
		});
		
	});
	
	
	//대분류 가져오기
	function loadTopCategories() {
		$.ajax({
			url: "${pageContext.request.contextPath}/category/top",
			type: "GET",
			success: function(list) {
				$("#topCategory").empty().append('<option value="">--대분류선택--</option>');
				for(let i=0; i<list.length; i++){
					$("#topCategory").append('<option value="'+ list[i].ctId+'">'+ list[i].ctName+'</option>');
				}
			}
		});
	}
</script>
</head>
<body>
	<div class="container mt-5">
	    <div class="row justify-content-center">
	        <div class="col-md-6">
	            
	            <div class="card shadow-sm">
	                <div class="card-header bg-primary text-white">
	                    <h4 class="mb-0">카테고리 추가 (관리자)</h4>
	                </div>
	
	                <div class="card-body">
	                    <form action="${pageContext.request.contextPath}/category/admin/add" method="post">
	                        
	                        <!-- 카테고리 레벨 선택 -->
	                        <div class="mb-3">
	                            <label class="form-label fw-bold">카테고리 단계</label>
	                            <select id="levelSelect" name="level" class="form-select" required>
	                                <option value="">-- 선택 --</option>
	                                <option value="1">대분류 추가</option>
	                                <option value="2">중분류 추가</option>
	                                <option value="3">소분류 추가</option>
	                            </select>
	                        </div>
	
	                        <!-- 대분류 선택 -->
	                        <div id="parentTopDiv" class="mb-3">
	                            <label class="form-label fw-bold">대분류 선택</label>
	                            <select id="topCategory" class="form-select">
	                                <option value="">-- 대분류 선택 --</option>
	                            </select>
	                        </div>
	
	                        <!-- 중분류 선택 -->
	                        <div id="parentMidDiv" class="mb-3">
	                            <label class="form-label fw-bold">중분류 선택</label>
	                            <select id="midCategory" class="form-select">
	                                <option value="">-- 중분류 선택 --</option>
	                            </select>
	                        </div>
	
	                        <!-- 카테고리 이름 -->
	                        <div class="mb-3">
	                            <label class="form-label fw-bold">추가할 카테고리 이름</label>
	                            <input type="text" name="ctName" class="form-control" placeholder="카테고리 이름 입력" required />
	                        </div>
	
	                        <!-- hidden parentId -->
	                        <input type="hidden" id="parentId" name="parentId" />
	
	                        <!-- 버튼 -->
	                        <div class="d-grid">
	                            <button type="submit" class="btn btn-primary">
	                                카테고리 추가하기
	                            </button>
	                        </div>
	                    </form>
	                </div>
	
	                <div class="card-footer text-center">
	                    <a href="${pageContext.request.contextPath}/category/admin/list" class="btn btn-outline-secondary btn-sm">
	                        카테고리 목록으로 돌아가기
	                    </a>
	                </div>
	            </div>
	
	        </div>
	    </div>
	</div>

</body>
</html>