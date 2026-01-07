<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인 | HobbyMate</title>
<!-- Bootstrap CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">

    <!-- Theme CSS -->
    <link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">
</head>
<body>

	<!-- 로고 영역 -->
	<div class="container text-center py-5">
		<a href="<c:url value='/'/>" class="text-decoration-none fw-bold fs-1 text-primary">
			HobbyMate
		</a>
	</div>
	
	<!-- 로그인 폼 영역 -->
	<div class="container d-flex justify-content-center">
		<div class="col-12 col-md-4">
		
			<form action="<c:url value='/login'/>"method="post" class="p-4 bg-white shadow-sm rounded">
				<h4 class="text-center mb-4 fw-semibold">로그인</h4>
				
				<div class="mb-3">
					<label class="form-label">아이디</label>
					<input type="text" name="mId" class="form-control" required>
				</div>
				
				<div class="mb-3">
					<label class="form-label">비밀번호</label>
					<input type="password" name="mPw" class="form-control" required>
				</div>
				
				<button type="submit" class="btn btn-primary w-100 rounded-pill mt-3">
					로그인
				</button>
				
				<div class="text-center mt-3">
					<a href="<c:url value='/member/join'/>" class="text-decoration-none">
						회원가입
					</a>
				</div>
			</form>
		</div>
	</div>
	
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script src="<c:url value='/resources/js/theme.js'/>"></script>

<script src="<c:url value='/resources/js/bootstrap-navbar.js'/>"></script>
</body>
</html>