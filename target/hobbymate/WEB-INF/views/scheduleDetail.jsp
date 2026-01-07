<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 상세 정보</title>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css?v=3'/>">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>

	<div class="container my-5">
		<div class="card shadow-sm p-4 rounded-4"
			style="max-width: 900px; margin: 0 auto;">

			<!-- 제목 -->
			<h3 class="fw-bold mb-4 ms-1">[${clubName}] 일정 상세</h3>

			<!-- 제목 -->
			<div class="mb-4">
				<label class="fw-semibold">제목</label> <input type="text"
					class="form-control" value="${schedule.eventTitle}" readonly>
			</div>

			<!-- 내용 -->
			<div class="mb-4">
				<label class="fw-semibold">내용</label>
				<textarea class="form-control" rows="4" readonly>${schedule.eventContent}</textarea>
			</div>

			<!-- 날짜 & 시간 -->
			<div class="row mb-4">
				<div class="col-md-6">
					<label class="fw-semibold">시작 시간</label> <input type="text"
						class="form-control" value="${schedule.startTime}" readonly>
				</div>
				<div class="col-md-6">
					<label class="fw-semibold">종료 시간</label> <input type="text"
						class="form-control" value="${schedule.endTime}" readonly>
				</div>
			</div>

			<!-- 참여 인원 -->
			<div class="row mb-4">
				<div class="col-md-6">
					<label class="fw-semibold">참여 가능 인원</label> <input type="text"
						class="form-control" value="${schedule.peopleLimit}명" readonly>
				</div>

				<div class="col-md-6">
					<label class="fw-semibold">현재 참여 인원</label> <input type="text"
						class="form-control" value="${currentCount}명" readonly>
				</div>
			</div>

			<hr class="my-4" style="opacity: 0.15;">

			<!-- 장소 정보 -->
			<h5 class="fw-bold mt-4 mb-3">장소 정보</h5>

			<div class="mb-3">
				<label class="fw-semibold">주소</label> <input type="text"
					class="form-control" value="${schedule.eventAddress}" readonly>
			</div>

			<div class="mb-3">
				<label class="fw-semibold">상세 위치</label> <input type="text"
					class="form-control" value="${schedule.eventDetailAddress}"
					readonly>
			</div>

			<!-- 지도 -->
			<div class="mb-4">
				<label class="fw-semibold d-block mb-2">장소 지도</label>
				<div id="map"
					style="width: 100%; height: 300px; border-radius: 10px;"></div>
			</div>

			<hr class="my-4" style="opacity: 0.15;">

			<!-- 참여자 목록 -->
			<h5 class="fw-bold mb-3">참여자</h5>

			<c:if test="${empty participants}">
				<p class="text-muted">아직 참여한 사람이 없습니다.</p>
			</c:if>

			<c:if test="${not empty participants}">
				<div class="d-flex flex-wrap gap-2">
					<c:forEach var="p" items="${participants}">
						<div class="d-flex align-items-center px-3 py-2"
							style="background: #f5f5f5; border-radius: 20px;">
							<img
								src="<c:url value='/resources/images/profile/${empty p.mProfileImageName ? "user-default.png" : p.mProfileImageName}'/>"
								onerror="this.onerror=null; this.src='<c:url value="/resources/images/profile/user-default.png"/>';"
								class="rounded-circle me-2"
								style="width: 28px; height: 28px; object-fit: cover;"> <span
								class="fw-semibold" style="font-size: 0.9rem;">
								${p.mName} </span>
						</div>
					</c:forEach>
				</div>
			</c:if>

			<!-- 버튼 영역 -->
			<div class="mt-5 d-flex justify-content-start">

				<a href="<c:url value='/club/home?clubId=${schedule.cId}'/>"
					class="btn btn-outline-secondary rounded-pill px-4 me-3"> 목록으로
				</a>

				<c:if test="${canJoin}">
					<form
						action="<c:url value='/schedule/memberSchedule/page/${schedule.eventNo}'/>"
						method="post" class="d-inline">
						<button type="submit"
							class="btn btn-success rounded-pill px-4 me-2">내 일정에
							추가하기</button>
					</form>
				</c:if>

				<c:if test="${canCancel}">
					<a
						href="<c:url value='/schedule/deleteMemberSchedule/page/${schedule.eventNo}'/>"
						class="btn btn-warning rounded-pill px-4 me-2"
						onclick="return confirm('내 일정에서 삭제하시겠습니까?');"> 내 일정에서 삭제하기 </a>
				</c:if>

				<!-- 🔥 수정 / 삭제 버튼 (정답 로직) -->
				<div>
					<c:if test="${canEdit}">
						<a href="<c:url value='/schedule/update/${schedule.eventNo}'/>"
							class="btn btn-primary rounded-pill px-4 me-2"> 수정하기 </a>
					</c:if>

					<c:if test="${canDelete}">
                        <form action="<c:url value='/schedule/delete/${schedule.eventNo}'/>"
                              method="post" class="d-inline">

                            <input type="hidden" name="clubId" value="${schedule.cId}" />

                            <button type="submit"
                                    class="btn btn-danger rounded-pill px-4"
                                    onclick="return confirm('정말 삭제하시겠습니까?');">
                                삭제하기
                            </button>
                        </form>
                    </c:if>
				</div>

			</div>

		</div>
	</div>

	<!-- 지도 Script -->
	<script
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4a29243207a31b3336be36fba8fdd313"></script>

	<script>
let mapContainer = document.getElementById('map');
let position = new kakao.maps.LatLng(${schedule.latitude}, ${schedule.longitude});

let map = new kakao.maps.Map(mapContainer, {
    center: position,
    level: 3
});

let marker = new kakao.maps.Marker({
    position: position
});
marker.setMap(map);
</script>

</body>
</html>
