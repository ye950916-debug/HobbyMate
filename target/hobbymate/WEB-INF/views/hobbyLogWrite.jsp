<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>하비로그 작성</title>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css?v=17'/>">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>
	
	<div class="container mt-5 mb-5" style="max-width: 720px;">

		<!-- 헤더 -->
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h3 class="fw-bold mb-0">📝 하비로그 작성</h3>

			<a href="javascript:history.back()"
				class="btn btn-sm btn-outline-secondary"> ← 돌아가기 </a>
		</div>

		<!-- 연결된 일정 정보 -->
		<div class="mb-4 p-3 border rounded bg-light">
			<div class="fw-bold mb-2">📅 연결된 일정</div>

			<div class="small">
				<div class="mb-1">
					<span class="text-muted">제목</span> <span class="ms-2">${schedule.eventTitle}</span>
				</div>
				<div class="mb-1">
					<span class="text-muted">시작</span> <span class="ms-2">${schedule.startTime}</span>
				</div>
				<div>
					<span class="text-muted">종료</span> <span class="ms-2">${schedule.endTime}</span>
				</div>
			</div>
		</div>

		<!-- 작성 폼 -->
		<form id="hobbyLogForm" action="<c:url value='/hobbylog/write'/>"
			method="post" enctype="multipart/form-data">

			<!-- hidden -->
			<input type="hidden" name="postType" value="HOBBYLOG"> <input
				type="hidden" name="postEventNo" value="${eventNo}"> <input
				type="hidden" name="postCId" value="${schedule.cId}">

			<!-- 제목 -->
			<div class="mb-4">
				<label class="form-label fw-bold">제목</label> <input type="text"
					name="postTitle" class="form-control" placeholder="하비로그 제목을 입력하세요"
					required>
			</div>

			<!-- 내용 -->
			<div class="mb-4">
				<label class="form-label fw-bold">내용</label>
				<textarea name="postContent" class="form-control" rows="8"
					placeholder="오늘의 활동은 어땠나요?" required></textarea>
			</div>

			<div class="mb-4">
				<label class="form-label fw-bold">이미지</label>

				<!-- 실제 파일 input (숨김) -->
				<input type="file" id="imageInput" accept="image/*"
					style="display: none">

				<button type="button" class="btn btn-outline-primary rounded-pill"
					onclick="document.getElementById('imageInput').click()">+
					이미지 추가</button>

				<div class="form-text mt-2">여러 번 눌러서 이미지를 계속 추가할 수 있어요.</div>

				<!-- 미리보기 -->
				<div class="preview-list" id="previewList"></div>
			</div>

			<!-- 버튼 -->
			<div class="d-flex justify-content-end gap-2">
				<a href="javascript:history.back()"
					class="btn btn-outline-secondary rounded-pill px-4"> 취소 </a>

				<button type="submit" class="btn btn-primary rounded-pill px-4">
					등록</button>
			</div>

		</form>

	</div>

	<script>
	let selectedFiles = [];
	
	const imageInput = document.getElementById("imageInput");
	const previewList = document.getElementById("previewList");
	const form = document.getElementById("hobbyLogForm");
	
	imageInput.addEventListener("change", function () {
	    const files = Array.from(this.files);
	
	    files.forEach(file => {
	        selectedFiles.push(file);
	
	        const reader = new FileReader();
	        reader.onload = e => {
	            const div = document.createElement("div");
	            div.className = "preview-item";
	
	            const img = document.createElement("img");
	            img.src = e.target.result;
	
	            const btn = document.createElement("button");
	            btn.innerText = "×";
	            btn.onclick = () => {
	                const index = selectedFiles.indexOf(file);
	                if (index > -1) selectedFiles.splice(index, 1);
	                div.remove();
	            };
	
	            div.appendChild(img);
	            div.appendChild(btn);
	            previewList.appendChild(div);
	        };
	        reader.readAsDataURL(file);
	    });
	
	    this.value = ""; // 다시 선택 가능하게
	});
	
	// submit 시 FormData에 이미지 주입
		form.addEventListener("submit", function (e) {
	    e.preventDefault();
	
	    const submitBtn = form.querySelector("button[type='submit']");
	    submitBtn.disabled = true;
	    submitBtn.innerText = "등록 중...";
	
	    const formData = new FormData(form);
	    selectedFiles.forEach(file => {
	        formData.append("imageFiles", file);
	    });
	
	    fetch(form.action, {
	        method: "POST",
	        body: formData
	    })
	    .then(res => {
	        if (res.redirected) {
	            location.href = res.url;
	        } else {
	            submitBtn.disabled = false;
	            submitBtn.innerText = "등록";
	        }
	    })
	    .catch(err => {
	        alert("등록 중 오류가 발생했습니다.");
	        submitBtn.disabled = false;
	        submitBtn.innerText = "등록";
	    });
	});
	</script>

</body>
</html>
