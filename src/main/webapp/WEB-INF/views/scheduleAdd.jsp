<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isELIgnored="false"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일정 등록</title>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css?v=1'/>">

<meta name="viewport" content="width=device-width, initial-scale=1">

<c:set var="ctx" value="${pageContext.request.contextPath}" />
</head>

<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>

	<div class="container my-5">
		<div class="card shadow-sm p-4 rounded-4"
			style="max-width: 900px; margin: 0 auto;">

			<h3 class="fw-bold mb-4 ms-1">[${club.cName}] 새 일정 등록</h3>

			<form action="<c:url value='/schedule/add/page/${cId}'/>"
				method="post" onsubmit="return validateTime();">

				<!-- 제목 -->
				<div class="mb-4">
					<label class="fw-semibold">제목</label> <input type="text"
						name="eventTitle" class="form-control" required
						placeholder="일정 제목을 입력하세요">
				</div>

				<!-- 내용 -->
				<div class="mb-4">
					<label class="fw-semibold">내용</label>
					<textarea name="eventContent" rows="4" class="form-control"
						required placeholder="일정 내용을 입력하세요"></textarea>
				</div>

				<!-- 시작 / 종료 -->
				<div class="row mb-4">
					<div class="col-md-6">
						<label class="fw-semibold">시작 시간</label> <input
							type="datetime-local" name="startTime" class="form-control"
							required>
					</div>
					<div class="col-md-6">
						<label class="fw-semibold">종료 시간</label> <input
							type="datetime-local" name="endTime" class="form-control"
							required>
					</div>
				</div>

				<!-- 참여 가능 인원 -->
				<div class="mb-4">
					<label class="fw-semibold">참여 가능 인원</label> <input type="number"
						name="peopleLimit" min="1" class="form-control" required
						placeholder="참여 인원 제한">
				</div>

				<hr class="my-4" style="opacity: 0.15;">

				<!-- 주소 섹션 -->
				<h5 class="fw-bold mt-4 mb-3">장소 정보</h5>

				<div class="mb-3 d-flex">
					<input type="text" id="eventAddress" name="eventAddress"
						class="form-control me-2" placeholder="주소를 입력 후 검색 버튼을 누르세요">
					<button type="button" id="btnSearch"
						class="btn btn-primary rounded btn-addr-search">주소 검색</button>
				</div>

				<div class="mb-3">
					<label class="fw-semibold">상세 위치</label> <input type="text"
						id="eventDetail" name="eventDetail" class="form-control"
						placeholder="상세 위치 입력 (건물 내부 위치 등)">
				</div>

				<!-- 지도 -->
				<div class="mb-4">
					<label class="fw-semibold d-block mb-2">지도 위치 확인 (마커 이동 가능)</label>
					<div id="map"
						style="width: 100%; height: 300px; border-radius: 10px;"></div>
				</div>

				<input type="hidden" id="latitude" name="latitude"> <input
					type="hidden" id="longitude" name="longitude">

				<!-- 제출 버튼 -->
				<div class="mt-4 text-end">
					<button type="submit"
						class="btn btn-primary px-4 py-2 rounded-pill">일정 등록</button>
				</div>

			</form>
		</div>
	</div>


	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4a29243207a31b3336be36fba8fdd313&libraries=services"></script>

	<script>
		// -------------------------------
		// 지도 초기화
		// -------------------------------
		let mapContainer = document.getElementById('map');
		let mapOption = {
			center : new kakao.maps.LatLng(37.5665, 126.9780), // 서울시청
			level : 3
		};
		let map = new kakao.maps.Map(mapContainer, mapOption);
		let geocoder = new kakao.maps.services.Geocoder();

		// 마커 생성
		let marker = new kakao.maps.Marker({
			position : map.getCenter(),
			draggable : true
		});
		marker.setMap(map);

		document.getElementById("latitude").value = map.getCenter().getLat();
		document.getElementById("longitude").value = map.getCenter().getLng();

		// 마커 이동 시 좌표 저장
		kakao.maps.event.addListener(marker, 'dragend', function() {
			let latlng = marker.getPosition();
			document.getElementById("latitude").value = latlng.getLat();
			document.getElementById("longitude").value = latlng.getLng();
		});

		// -------------------------------
		// 주소 검색
		// -------------------------------
		$("#btnSearch")
				.on(
						"click",
						function() {
							let keyword = $("#eventAddress").val();

							if (!keyword || keyword.trim() === "") {
								alert("주소를 입력하세요.");
								return;
							}

							geocoder
									.addressSearch(
											keyword,
											function(result, status) {
												if (status === kakao.maps.services.Status.OK) {
													let coords = new kakao.maps.LatLng(
															result[0].y,
															result[0].x);

													map.setCenter(coords);
													marker.setPosition(coords);

													document
															.getElementById("latitude").value = result[0].y;
													document
															.getElementById("longitude").value = result[0].x;
												} else {
													alert("주소 검색 결과가 없습니다.");
												}
											});
						});

		// -------------------------------
		// 시간 검증
		// -------------------------------
		function validateTime() {
			const start = new Date(document
					.querySelector("input[name='startTime']").value);
			const end = new Date(document
					.querySelector("input[name='endTime']").value);
			const now = new Date();

			if (start < now) {
				alert("이미 지난 시간에는 일정을 생성할 수 없습니다.");
				return false;
			}
			if (start >= end) {
				alert("종료 시간은 시작 시간보다 늦어야 합니다.");
				return false;
			}
			return true;
		}
	</script>

</body>
</html>
