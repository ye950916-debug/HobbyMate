<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 수정</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">


<script>
	$(document).ready(function(){
		let level = ${category.ctLevel};
		
		if(level == 1){
			$("#topDiv").hide();
			$("#midDiv").hide();
		}
		else if(level == 2){
			$("#topDiv").show();
			$("#midDiv").hide();
		}
		elseif(level == 3){
			$("#topDiv").show();
			$("#midDiv").show();
		}
		
		$("#topCategory").change(function(){
			let topId = $(this).val();
			
			$("#midCategory").empty();
			$("#midCategory").append("<option value=''>--중분류 선택--</option>");
			
			if(topId == "") {
				return;
			}
			
			$.ajax({
				url: "${pageContext.request.contextPath}/category/mid",
				type: "GET",
				date: {parentId: topId},
				success: function(list){
					for(let i=0; i<list.length; i++){
						$("#midCategory").append("<option value='" + list[i].ctId + "'>" + list[i].ctName + "</option>");
					}
				}
			});
		});
	});
</script>
</head>
<body>
	<div class="container mt-5 mb-5">
	    <div class="row justify-content-center">
	        <div class="col-md-6">
	
	            <div class="card shadow-sm">
	                <div class="card-header bg-primary text-white">
	                    <h4 class="mb-0">카테고리 수정</h4>
	                </div>
	
	                <div class="card-body">
	                    <form action="${pageContext.request.contextPath }/category/admin/update" method="post">
	                        <input type="hidden" name="ctId" value="${category.ctId }" />
	
	                        <!-- 대분류 선택 -->
	                        <div id="topDiv" class="mb-3">
	                            <label class="form-label fw-bold">대분류 선택</label>
	                            <select id="topCategory" name="topId" class="form-select">
	                                <option value="">-- 대분류 선택 --</option>
	                                <c:forEach var="t" items="${topList}">
	                                    <option value="${t.ctId}"
	                                        <c:if test="${t.ctId eq parentTopId}">selected</c:if>>
	                                        ${t.ctName}
	                                    </option>
	                                </c:forEach>
	                            </select>
	                        </div>
	
	                        <!-- 중분류 선택 -->
	                        <div id="midDiv" class="mb-3">
	                            <label class="form-label fw-bold">중분류 선택</label>
	                            <select id="midCategory" name="midId" class="form-select">
	                                <option value="">-- 중분류 선택 --</option>
	                                <c:if test="${not empty midList}">
	                                    <c:forEach var="m" items="${midList}">
	                                        <option value="${m.ctId}"
	                                            <c:if test="${m.ctId eq category.ctParentId}">selected</c:if>>
	                                            ${m.ctName}
	                                        </option>
	                                    </c:forEach>
	                                </c:if>
	                            </select>
	                        </div>
	
	                        <!-- 카테고리 이름 -->
	                        <div class="mb-4">
	                            <label class="form-label fw-bold">카테고리 이름</label>
	                            <input type="text"
	                                   name="ctName"
	                                   class="form-control"
	                                   value="${category.ctName}"
	                                   required />
	                        </div>
	
	                        <!-- 버튼 -->
	                        <div class="d-flex justify-content-between">
	                            <a href="<c:url value='/admin/category/list'/>"
	                               class="btn btn-outline-secondary">
	                                취소
	                            </a>
	                            <button type="submit" class="btn btn-primary">
	                                수정하기
	                            </button>
	                        </div>
	                    </form>
	                </div>
	            </div>
	
	        </div>
	    </div>
	</div>

</body>
</html>