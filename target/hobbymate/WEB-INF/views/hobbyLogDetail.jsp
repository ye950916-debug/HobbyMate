<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hobby Log Detail</title>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css?v=17'/>">

<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>


	<div class="container mt-5 mb-5 log-page" style="max-width: 820px;">

		<!-- =========================
         상단 헤더
    ========================== -->
		<div class="d-flex justify-content-between align-items-center mb-4">
			<h3 class="fw-bold mb-0">📝 Hobby Log</h3>

			<button class="btn btn-sm btn-outline-secondary"
				onclick="history.back()">← 돌아가기</button>
		</div>

		<!-- =========================
         제목 + 작성일 (문서 헤더)
    ========================== -->
		<div class="d-flex justify-content-between align-items-end mb-4">
			<div class="d-flex align-items-center gap-2">
				<span class="log-label">제목</span>

				<!-- 제목 값 (문서 헤더 느낌) -->
				<div class="log-title-box">${hobbyLog.postTitle}</div>
			</div>

			<div class="log-date">🕒 ${createdAt}</div>
		</div>

		<!-- =========================
         본문 (문서 본문)
    ========================== -->
		<div class="log-content-box mb-5">${hobbyLog.postContent}</div>

		<!-- =========================
	     첨부 이미지
	========================== -->
		<c:if test="${not empty images}">
			<div class="log-image-section mb-5">
				<div class="log-image-title">첨부 이미지</div>

				<div class="d-flex flex-wrap gap-3">
					<c:forEach var="img" items="${images}">
						<img
							src="${pageContext.request.contextPath}/resources/images/hobbylog/${img.piName}"
							data-src="${pageContext.request.contextPath}/resources/images/hobbylog/${img.piName}"
							class="log-image previewable" />
					</c:forEach>
				</div>
			</div>
		</c:if>

		<!-- =========================
         연결된 일정 (속성/메타 정보)
    ========================== -->
		<c:if test="${not empty schedule}">
			<div class="schedule-meta mb-5">
				<div class="schedule-meta-title d-flex align-items-center">
					<span>연결 정보</span>

					<c:if test="${archived}">
						<span
							class="badge bg-danger-subtle text-danger-emphasis rounded-pill ms-3 px-3 py-2">
							현재 상세보기 불가능한 일정입니다 </span>
					</c:if>

					<c:if test="${not archived}">
						<a
							href="${pageContext.request.contextPath}/schedule/detail/${eventNo}"
							class="badge bg-primary-subtle text-primary-emphasis rounded-pill ms-3 px-3 py-2 text-decoration-none">
							자세히 보기 <i class="fas fa-chevron-right ms-1"
							style="font-size: 0.8em;"></i>
						</a>
					</c:if>
				</div>

				<div class="meta-row">
					<span class="label">모임</span> <span>${clubName}</span>
				</div>

				<div class="meta-row">
					<span class="label">제목</span> <span>${schedule.eventTitle}</span>
				</div>

				<div class="meta-row">
					<span class="label">시작</span> <span>${startTimeStr}</span>
				</div>

				<div class="meta-row">
					<span class="label">종료</span> <span>${endTimeStr}</span>
				</div>


			</div>
		</c:if>

		<!-- =========================
         문서 하단 액션
    ========================== -->
		<div class="d-flex justify-content-end gap-2 action-footer">
			<a
				href="${pageContext.request.contextPath}/hobbylog/edit/${hobbyLog.postId}"
				class="btn btn-outline-primary rounded-pill px-4"> 수정 </a>

			<form action="${pageContext.request.contextPath}/hobbylog/delete"
				method="post" onsubmit="return confirm('이 하비로그를 삭제할까요?');">

				<input type="hidden" name="postId" value="${hobbyLog.postId}" />

				<button type="submit"
					class="btn btn-outline-danger rounded-pill px-4">삭제</button>
			</form>
		</div>

	</div>

	<!-- =========================
	     이미지 원본 보기 모달
	========================== -->
	<div class="modal fade" id="imagePreviewModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered modal-xl">
			<div class="modal-content bg-transparent border-0">
				<div class="modal-body p-0 text-center">
					<img id="previewModalImage" src="" class="img-fluid rounded shadow"
						alt="원본 이미지">
				</div>
			</div>
		</div>
	</div>

	<script>
		document.addEventListener("click", function(e) {
			const img = e.target.closest(".previewable");
			if (!img)
				return;

			const modalImg = document.getElementById("previewModalImage");
			modalImg.src = img.dataset.src;

			const modal = new bootstrap.Modal(document
					.getElementById("imagePreviewModal"));
			modal.show();
		});
	</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>


</body>
</html>
