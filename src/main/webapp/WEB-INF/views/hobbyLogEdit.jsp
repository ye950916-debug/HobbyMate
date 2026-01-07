<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>하비로그 수정</title>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css?v=14'/>">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>

	<div class="container mt-5" style="max-width: 720px;">

		<!-- 헤더 -->
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h3 class="fw-bold mb-0">✏️ 하비로그 수정</h3>

			<a href="<c:url value='/hobbylog/detail/${hobbyLog.postId}'/>"
				class="btn btn-sm btn-outline-secondary"> ← 돌아가기 </a>
		</div>

		<form id="hobbyLogEditForm" action="<c:url value='/hobbylog/edit'/>"
			method="post" enctype="multipart/form-data">

			<input type="hidden" name="postId" value="${hobbyLog.postId}" />

			<!-- 제목 -->
			<div class="mb-4">
				<label class="form-label fw-bold">제목</label> <input type="text"
					name="postTitle" class="form-control" value="${hobbyLog.postTitle}"
					required>
			</div>

			<!-- 본문 -->
			<div class="mb-4">
				<label class="form-label fw-bold">내용</label>
				<textarea name="postContent" class="form-control" rows="7" required>${hobbyLog.postContent}</textarea>
			</div>

			<!-- 기존 이미지 -->
			<c:if test="${not empty images}">
				<div class="mb-4">
					<label class="form-label fw-bold">이미지</label>

					<div class="preview-list">
						<c:forEach var="img" items="${images}">
							<div class="preview-item existing-image"
								data-image-id="${img.piId}">

								<img
									src="${pageContext.request.contextPath}/resources/images/hobbylog/${img.piName}" />

								<button type="button" onclick="removeExistingImage(this)">
									×</button>

							</div>
						</c:forEach>
					</div>

					<div class="form-text mt-2">❌ 버튼을 누르면 이미지가 삭제됩니다.</div>
				</div>
			</c:if>


			<!-- 새 이미지 업로드 -->
			<div class="mb-4">
				<label class="form-label fw-bold">이미지 추가</label> <input type="file"
					id="imageInput" name="imageFiles" accept="image/*" multiple
					style="display: none">

				<button type="button" class="btn btn-outline-primary rounded-pill"
					onclick="document.getElementById('imageInput').click()">+
					이미지 추가</button>

				<div class="form-text mt-2">여러 번 눌러 이미지를 계속 추가할 수 있어요.</div>

				<div class="preview-list" id="previewList"></div>
			</div>


			<!-- 연결된 일정 (읽기 전용) -->
			<c:if test="${not empty schedule}">
				<div class="mb-4 p-3 border rounded bg-light">
					<div class="fw-bold mb-2">📅 연결된 일정</div>

					<div class="small">
						<div class="mb-1">
							<span class="text-muted">모임</span> <span class="ms-2">${clubName}</span>
						</div>
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
			</c:if>

			<!-- 버튼 -->
			<div class="d-flex justify-content-end gap-2 mt-5">
				<a href="<c:url value='/hobbylog/detail/${hobbyLog.postId}'/>"
					class="btn btn-outline-secondary rounded-pill"> 취소 </a>

				<button type="submit" class="btn btn-primary rounded-pill">
					수정 완료</button>
			</div>

		</form>

	</div>

	<script>
let selectedFiles = [];

const imageInput = document.getElementById("imageInput");
const previewList = document.getElementById("previewList");
const form = document.getElementById("hobbyLogEditForm");

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
      btn.type = "button";
      btn.innerText = "×";
      btn.onclick = () => {
        const idx = selectedFiles.indexOf(file);
        if (idx > -1) selectedFiles.splice(idx, 1);
        div.remove();
      };

      div.appendChild(img);
      div.appendChild(btn);
      previewList.appendChild(div);
    };
    reader.readAsDataURL(file);
  });

  this.value = "";
});

// 🔥 핵심
form.addEventListener("submit", function () {
  const dataTransfer = new DataTransfer();

  selectedFiles.forEach(file => {
    dataTransfer.items.add(file);
  });

  imageInput.files = dataTransfer.files;
});
</script>


	<script>
function removeExistingImage(btn) {
  const imageDiv = btn.closest(".existing-image");
  const imageId = imageDiv.dataset.imageId;

  // 🔥 hidden input 생성 (서버로 보낼 삭제 ID)
  const input = document.createElement("input");
  input.type = "hidden";
  input.name = "deleteImageIds";
  input.value = imageId;

  document.getElementById("hobbyLogEditForm").appendChild(input);

  // 화면에서 제거
  imageDiv.remove();
}
</script>


</body>
</html>
