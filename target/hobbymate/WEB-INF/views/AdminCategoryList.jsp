<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카테고리 목록</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/bootstrap.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/theme.css">

<script>
	function confirmDelete(ctId, level){
		let msg="";
		
		if(level==1){
			msg="대분류 삭제 : 해당 대분류에 속한 중분류 + 소분류 전체 삭제됩니다. \n정말 삭제하시겠습니까?";
		}
		else if(level==2){
			msg="중분류 삭제 : 해당 중분류에 속한 소분류 전체 삭제됩니다. \n정말 삭제하시겠습니까?";
		}
		else{
			msg="정말 이 카테고리를 삭제하시겠습니까? 작업을 취소할 수 없습니다.";
		}
		
		if(confirm(msg)){
			document.getElementById("deleteForm_" + ctId).submit();
		}
	}
</script>
</head>
<body>
	<div class="container mt-5">

	    <!-- 상단 메뉴 -->
	    <div class="d-flex justify-content-between align-items-center mb-3">
	        <h4 class="fw-bold">카테고리 관리</h4>
	        <a href="<c:url value='/category/admin/add'/>" class="btn btn-primary">
	            + 카테고리 추가
	        </a>
	    </div>
	
	    <!-- 카테고리 테이블 -->
	    <div class="card shadow-sm">
	        <div class="card-body p-0">
	
	            <table class="table table-bordered table-hover align-middle mb-0 text-center">
	                <thead class="table-light">
	                    <tr>
	                        <th style="width: 25%">대분류</th>
	                        <th style="width: 25%">중분류</th>
	                        <th style="width: 25%">소분류</th>
	                        <th style="width: 25%">관리</th>
	                    </tr>
	                </thead>
	                <tbody>
	
	                <c:forEach var="top" items="${topList}">
	                    <!-- 대분류 -->
	                    <tr class="table-primary">
	                        <td class="fw-bold">${top.ctName}</td>
	                        <td colspan="2"></td>
	                        <td>
	                            <div class="d-flex justify-content-center gap-2">
	                                <form action="<c:url value='/category/admin/edit'/>">
	                                    <input type="hidden" name="ctId" value="${top.ctId}" />
	                                    <button type="submit" class="btn btn-sm btn-outline-secondary">수정</button>
	                                </form>
	                                <form action="<c:url value='/category/admin/delete'/>"
	                                      id="deleteForm_${top.ctId}" method="post">
	                                    <input type="hidden" name="ctId" value="${top.ctId}" />
	                                    <button type="button"
	                                            class="btn btn-sm btn-outline-danger"
	                                            onclick="confirmDelete(${top.ctId}, ${top.ctLevel})">
	                                        삭제
	                                    </button>
	                                </form>
	                            </div>
	                        </td>
	                    </tr>
	
	                    <!-- 중분류 -->
	                    <c:forEach var="mid" items="${midList}">
	                        <c:if test="${mid.ctParentId == top.ctId}">
	                            <tr>
	                                <td></td>
	                                <td class="fw-semibold">${mid.ctName}</td>
	                                <td></td>
	                                <td>
	                                    <div class="d-flex justify-content-center gap-2">
	                                        <form action="<c:url value='/category/admin/edit'/>">
	                                            <input type="hidden" name="ctId" value="${mid.ctId}" />
	                                            <button type="submit" class="btn btn-sm btn-outline-secondary">수정</button>
	                                        </form>
	                                        <form action="<c:url value='/category/admin/delete'/>"
	                                              id="deleteForm_${mid.ctId}" method="post">
	                                            <input type="hidden" name="ctId" value="${mid.ctId}" />
	                                            <button type="button"
	                                                    class="btn btn-sm btn-outline-danger"
	                                                    onclick="confirmDelete(${mid.ctId}, ${mid.ctLevel})">
	                                                삭제
	                                            </button>
	                                        </form>
	                                    </div>
	                                </td>
	                            </tr>
	
	                            <!-- 소분류 -->
	                            <c:forEach var="sub" items="${subList}">
	                                <c:if test="${sub.ctParentId == mid.ctId}">
	                                    <tr>
	                                        <td></td>
	                                        <td></td>
	                                        <td>${sub.ctName}</td>
	                                        <td>
	                                            <div class="d-flex justify-content-center gap-2">
	                                                <form action="<c:url value='/category/admin/edit'/>">
	                                                    <input type="hidden" name="ctId" value="${sub.ctId}" />
	                                                    <button type="submit" class="btn btn-sm btn-outline-secondary">
	                                                        수정
	                                                    </button>
	                                                </form>
	                                                <form action="<c:url value='/category/admin/delete'/>"
	                                                      id="deleteForm_${sub.ctId}" method="post">
	                                                    <input type="hidden" name="ctId" value="${sub.ctId}" />
	                                                    <button type="button"
	                                                            class="btn btn-sm btn-outline-danger"
	                                                            onclick="confirmDelete(${sub.ctId}, ${sub.ctLevel})">
	                                                        삭제
	                                                    </button>
	                                                </form>
	                                            </div>
	                                        </td>
	                                    </tr>
	                                </c:if>
	                            </c:forEach>
	                        </c:if>
	                    </c:forEach>
	
	                </c:forEach>
	
	                </tbody>
	            </table>
	        </div>
	    </div>
	
	    <!-- 하단 -->
	    <div class="mt-4 mb-5 text-center">
	        <a href="<c:url value='/'/>" class="btn btn-outline-secondary btn-sm">
	            홈으로
	        </a>
	    </div>
	
	</div>

</body>
</html>