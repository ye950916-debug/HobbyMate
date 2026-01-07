<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:if test="${not empty param.error}">
	<script>
        alert("${param.error}");
    </script>
</c:if>

<c:set var="currentSearchKeyword"
	value="${not empty param.searchKeyword ? param.searchKeyword : ''}" />

<c:set var="prevYear" value="${month == 1 ? year - 1 : year}" />
<c:set var="prevMonth" value="${month == 1 ? 12 : month - 1}" />

<c:set var="nextYear" value="${month == 12 ? year + 1 : year}" />
<c:set var="nextMonth" value="${month == 12 ? 1 : month + 1}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 스케줄 관리</title>

<script type="text/javascript"
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=4a29243207a31b3336be36fba8fdd313&libraries=services"></script>

<script>
    const ctx = "${pageContext.request.contextPath}";
</script>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">

<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css'/>">

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

<meta name="viewport" content="width=device-width, initial-scale=1">

</head>
<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>



	<div id="app-container" class="d-flex">

		<div id="sidebar" class="bg-dark text-white p-3">

			<ul class="nav flex-column">
				<li class="nav-item mb-2"><a
					href="<c:url value='/schedule/myclubs'/>"
					class="nav-link text-white p-2 rounded"> <i
						class="fas fa-calendar-alt me-2"></i> 전체 모임 일정
				</a></li>
				<li class="nav-item mb-2"><a
					href="<c:url value='/schedule/memberSchedule'/>"
					class="nav-link bg-primary text-white p-2 rounded fw-bold"> <i
						class="fas fa-list-check me-2"></i> 내 스케줄 확인
				</a></li>

				<c:if test="${not empty leaderClubIds}">
					<li class="nav-item mb-2"><a href="javascript:void(0)"
						class="nav-link text-white p-2 rounded"
						onclick="openAddEventModal()"> <i
							class="fas fa-plus-circle me-2"></i> 새 일정 추가
					</a></li>
				</c:if>

			</ul>

			<div class="mt-4 pt-3 border-top border-secondary">
				<h6 class="text-secondary">내가 가입한 모임</h6>

				<c:choose>
					<c:when test="${not empty memberClubs}">
						<ul class="nav flex-column small">
							<c:forEach var="cl" items="${memberClubs}">
								<li class="nav-item text-truncate"><a
									href="<c:url value='/club/home?clubId=${cl.id}'/>"
									class="nav-link text-light p-1"> ${cl.name} </a></li>
							</c:forEach>
						</ul>
					</c:when>
					<c:otherwise>
						<div class="small text-secondary mt-2">아직 가입한 모임이 없어요 🙂</div>
					</c:otherwise>
				</c:choose>
			</div>



			<c:if test="${not empty leaderClubIds}">
				<div class="mt-5 pt-3 border-top border-secondary">
					<h6 class="text-secondary">내가 리더인 모임</h6>
					<ul class="nav flex-column small">
						<c:forEach var="cl" items="${leaderClubs}">
							<li class="nav-item text-truncate"><a
								href="<c:url value='/club/home?clubId=${cl.id}'/>"
								class="nav-link text-info p-1"> ${cl.name} </a></li>
						</c:forEach>
					</ul>
				</div>
			</c:if>

		</div>

  		<div style="width:100%">
			<div id="main-content" class="flex-grow-1 p-4">
	
				<div class="d-flex align-items-center gap-3 mb-4">
	
					<h3 class="mb-0 text-secondary">${sessionScope.loginMember.mName}님의
						참석 일정</h3>
	
					<form class="d-flex"
						action="${pageContext.request.contextPath}/schedule/memberSchedule"
						method="get" style="width: 250px;">
	
						<input class="form-control rounded-pill px-3" type="search"
							name="searchKeyword" placeholder="일정, 모임 검색"
							value="${searchKeyword}">
					</form>
	
				</div>
				
				<c:if test="${hasNoClubs}">
					<div class="alert alert-info small mb-4">
						📭 현재 가입한 모임이 없습니다.<br> 모임에 가입하면 이곳에서 모든 일정을 한눈에 확인할 수 있어요.
					</div>
				</c:if>
				
				<div class="row">
	
					<div class="col-lg-9">
	
						<div class="calendar-card shadow-sm">
	
							<%-- 1. 현재 검색 키워드 변수 정의 --%>
							<%-- URL에 추가할 'searchKeyword=키워드값' 문자열을 만듭니다. --%>
							<c:set var="searchParam" value="" />
							<c:if test="${not empty searchKeyword}">
								<c:set var="searchParam" value="&searchKeyword=${searchKeyword}" />
							</c:if>
	
							<div
								class="d-flex justify-content-center align-items-center calendar-header-compact mb-3">
								<h4 class="m-0 me-3 fw-bold">${year}년${month}월</h4>
	
								<%-- ⬅️ 이전 달 버튼 수정 --%>
								<button class="btn btn-sm btn-outline-secondary me-1"
									onclick="location.href='${pageContext.request.contextPath}/schedule/memberSchedule?year=${prevYear}&month=${prevMonth}${searchParam}'">&lt;</button>
	
								<%-- ➡️ 다음 달 버튼 수정 --%>
								<button class="btn btn-sm btn-outline-secondary"
									onclick="location.href='${pageContext.request.contextPath}/schedule/memberSchedule?year=${nextYear}&month=${nextMonth}${searchParam}'">&gt;</button>
	
								<%-- 📅 Today 버튼 수정 --%>
								<button class="btn btn-sm btn-primary ms-3 rounded-pill"
									onclick="location.href='${pageContext.request.contextPath}/schedule/memberSchedule?${searchParam}'">Today</button>
	
								<%-- Today 버튼은 year/month 파라미터가 없어야 합니다. 
				             searchParam이 빈 문자열이면 '/schedule/myclubs?'가 되지만, 대부분의 브라우저에서 문제없이 작동합니다. --%>
							</div>
	
	
							<div class="row text-center fw-bold py-2 mx-0">
								<div class="col">SUN</div>
								<div class="col">MON</div>
								<div class="col">TUE</div>
								<div class="col">WED</div>
								<div class="col">THU</div>
								<div class="col">FRI</div>
								<div class="col">SAT</div>
							</div>
	
							<div class="my-3">
								<div class="hm-calendar">
	
									<c:forEach begin="1" end="${totalCells}" var="i">
										<c:set var="dayNumber" value="${i - startDayIndex}" />
	
										<div class="hm-calendar-day">
	
											<c:choose>
	
												<c:when test="${dayNumber >= 1 && dayNumber <= lastDay}">
													<div class="hm-day-number fw-bold">${dayNumber}</div>
	
													<fmt:formatNumber value="${month}" pattern="00" var="mm" />
													<fmt:formatNumber value="${dayNumber}" pattern="00" var="dd" />
													<c:set var="dayStr" value="${year}-${mm}-${dd}" />
	
													<div class="hm-day-events mt-1">
	
														<c:forEach var="ev" items="${calendarSchedules}">
															<c:if test="${ev.start <= dayStr && ev.end >= dayStr}">
																<div class="event-label" data-eventno="${ev.eventNo}"
																	style="background:${ev.color}; color:white; padding:2px 4px; border-radius:4px; font-size:12px; margin-bottom:2px;">
																	${ev.clubName} - ${ev.title}</div>
															</c:if>
	
														</c:forEach>
													</div>
												</c:when>
	
												<c:otherwise>
													<div class="hm-day-number fw-bold"></div>
												</c:otherwise>
											</c:choose>
	
	
										</div>
									</c:forEach>
	
								</div>
	
	
							</div>
						</div>
					</div>
	
					<div class="col-lg-3">
	
						<div class="card shadow-sm mb-4">
							<div class="card-header bg-primary text-white">
								<h5 class="mb-0 small">
									<i class="fas fa-calendar-check me-2"></i> 오늘의 일정 (<%=new java.text.SimpleDateFormat("MM.dd").format(new java.util.Date())%>)
								</h5>
							</div>
							<div class="card-body p-0">
	
								<c:choose>
									<%-- 1. Controller에서 'todaySchedules'가 넘어왔고, 내용이 있을 경우 --%>
									<c:when test="${not empty todaySchedules}">
										<ul class="list-group list-group-flush">
											<c:forEach var="schedule" items="${todaySchedules}">
												<li
													class="list-group-item d-flex flex-column align-items-start list-group-item-action"
													data-eventno="${schedule.eventNo}"
													onclick="document.querySelector('.event-label[data-eventno=\'${schedule.eventNo}\']').click();">
	
													<div class="d-flex align-items-center gap-2">
														<span class="badge bg-secondary">${schedule.clubName}</span>
														<p class="mb-0 text-truncate fw-bold">${schedule.title}</p>
													</div>
												</li>
											</c:forEach>
										</ul>
									</c:when>
	
									<%-- 2. 오늘 일정이 없을 경우: 안내 메시지 표시 --%>
									<c:otherwise>
										<div class="p-3 text-center text-muted small">오늘 예정된 일정이
											없습니다. 🎉</div>
									</c:otherwise>
								</c:choose>
	
							</div>
						</div>
	
	
					</div>
				</div>
			</div>
		</div>
		
		<div class="modal fade" id="addEventModal" tabindex="-1"
			aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">

					<div class="modal-header">
						<h5 class="modal-title">새 일정 추가</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>

					<div class="modal-body form-like-body">

						<div class="form-group">
							<label class="form-label">모임 선택</label> <select id="addClubId"
								name="clubId" class="form-select">
							</select>
						</div>

						<div class="form-group">
							<label class="form-label">제목</label> <input type="text"
								id="addTitle" class="form-control">
						</div>

						<div class="form-group">
							<label class="form-label">내용</label>
							<textarea id="addContent" class="form-control" rows="3"></textarea>
						</div>

						<div class="form-group">
							<label class="form-label">시작 시간</label> <input
								type="datetime-local" id="addStart" class="form-control">
						</div>

						<div class="form-group">
							<label class="form-label">종료 시간</label> <input
								type="datetime-local" id="addEnd" class="form-control">
						</div>

						<div class="form-group">
							<label class="form-label">주소</label>
							<div
								style="display: flex; align-items: center; margin-bottom: 10px;">
								<input type="text" id="addEventAddress" name="eventAddress"
									class="form-control me-2" placeholder="주소를 입력 후 검색 버튼을 누르세요"
									value="">
								<button type="button" class="btn btn-primary"
									onclick="searchAddress()">주소 검색</button>
							</div>
						</div>

						<div class="form-group">
							<label class=form-label>상세 위치</label> <input type="text"
								id="addEventDetailAddress" name="eventDetailAddress"
								class="form-control">
						</div>

						<div class="form-group">
							<label class="form-label">지도 위치 확인 (마커 이동 가능)</label>
							<div id="mapContainer"
								style="width: 100%; height: 200px; border: 1px solid #ddd; border-radius: 5px; background: #f8f8f8;">
							</div>
							<input type="hidden" id="addMapLat" name="latitude" value="0">
							<input type="hidden" type="hidden" id="addMapLng"
								name="longitude" value="0">
						</div>

						<div class="form-group">
							<label class="form-label">참여 가능 인원</label> <input type="number"
								id="addPeopleLimit" class="form-control" min="1">
						</div>

						<div id="addEventButtons"></div>

					</div>

					<div class="modal-footer">
						<button class="btn btn-primary" onclick="submitAddEvent()">등록</button>
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">닫기</button>
					</div>


				</div>
			</div>
		</div>

		<div class="modal fade" id="editEventModal" tabindex="-1"
			aria-labelledby="editEventModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="editEventModalLabel">일정 수정</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
					<div class="modal-body">

						<input type="hidden" id="editEventNo" value="">

						<div class="mb-3">
							<label for="editClubName" class="form-label">모임</label> <input
								type="text" id="editClubName" class="form-control" readonly>
							<input type="hidden" id="editClubId" name="cId" value="">
						</div>

						<div class="mb-3">
							<label for="editTitle" class="form-label">제목</label> <input
								type="text" id="editTitle" name="eventTitle"
								class="form-control">
						</div>

						<div class="mb-3">
							<label for="editContent" class="form-label">내용</label>
							<textarea id="editContent" name="eventContent"
								class="form-control"></textarea>
						</div>

						<div class="mb-3">
							<label for="editStart" class="form-label">시작 시간</label> <input
								type="datetime-local" id="editStart" name="startTime"
								class="form-control">
						</div>

						<div class="mb-3">
							<label for="editEnd" class="form-label">종료 시간</label> <input
								type="datetime-local" id="editEnd" name="endTime"
								class="form-control">
						</div>

						<div class="mb-3">
							<label class="form-label">주소</label>
							<div style="display: flex; gap: 8px; margin-bottom: 8px;">
								<input type="text" id="editEventAddress" name="eventAddress"
									class="form-control">
								<button type="button" class="btn btn-primary"
									onclick="searchAddressEdit()">주소 검색</button>
							</div>
						</div>

						<div class="mb-3">
							<label class="form-label">상세 위치</label> <input type="text"
								id="editEventDetailAddress" name="eventDetailAddress"
								class="form-control">
						</div>


						<div class="mb-3">
							<label class="form-label">지도 위치 확인 (마커 이동 가능)</label>
							<div id="editMapContainer"
								style="width: 100%; height: 200px; border: 1px solid #ddd; border-radius: 5px; background: #f5f5f5;">
							</div>
							<input type="hidden" id="editMapLat"> <input
								type="hidden" id="editMapLng">
						</div>

						<div class="mb-3">
							<label for="editPeopleLimit" class="form-label">참여 가능 인원</label>
							<input type="number" id="editPeopleLimit" name="peopleLimit"
								class="form-control" min="1">
						</div>

					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">닫기</button>
						<button type="button" class="btn btn-primary"
							onclick="submitUpdateEvent()">수정 완료</button>
					</div>
				</div>
			</div>
		</div>

		<div class="modal fade" id="eventModal" tabindex="-1"
			aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered">
				<div class="modal-content">

					<div class="modal-header">
						<h5 class="modal-title">일정 상세</h5>
						<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
					</div>

					<div class="modal-body form-like-body">

						<div class="form-group mb-3">
							<label class="form-label">모임</label>

							<div id="modalClubNameLink" class="form-value fw-bold"
								style="cursor: pointer; text-align: left;"
								onclick="goToClubHome(this)">

								<span id="modalClubName"></span>
							</div>
						</div>

						<div class="form-group" id="modalStatusGroup"
							style="display: none;">
							<label class="form-label">상태</label>
							<div class="form-value text-danger fw-bold" id="modalEventStatus"></div>
						</div>

						<div class="form-group">
							<label class="form-label">제목</label>
							<div class="form-value" id="modalEventTitle"></div>
						</div>

						<div class="form-group">
							<label class="form-label">내용</label>
							<div class="form-value" id="modalEventContent"
								style="white-space: pre-wrap;"></div>
						</div>

						<div class="form-group">
							<label class="form-label">기간</label>

							<div class="date-range-wrapper">
								<div class="date-card">
									<div class="date-label">시작</div>
									<div class="date-day" id="startDay"></div>
									<div class="date-time" id="startTime"></div>
								</div>

								<div class="date-card">
									<div class="date-label">종료</div>
									<div class="date-day" id="endDay"></div>
									<div class="date-time" id="endTime"></div>
								</div>
							</div>
						</div>

						<div class="form-group">
							<label class="form-label">주소</label>
							<div class="form-value" id="modalEventAddress"></div>
						</div>

						<div class="form-group">
							<label class="form-label">상세 위치</label>
							<div class="form-value" id="modalEventDetailAddress"></div>
						</div>

						<div class="form-group">
							<label class="form-label">지도</label>
							<div id="detailMapContainer"
								style="width: 100%; height: 200px; border: 1px solid #ddd; border-radius: 5px; background: #f5f5f5;">
							</div>
						</div>

						<div class="form-group">
							<label class="form-label">참여 인원</label>
							<div class="form-value" id="modalParticipantCount"></div>
						</div>

						<div class="form-group">
							<label class="form-label">참여자</label>
							<ul id="modalParticipants"></ul>
						</div>

						<div id="modalButtons"></div>

						<input type="hidden" id="detailScheduleId" value="">

					</div>

					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">닫기</button>
					</div>

				</div>
			</div>
		</div>

		<script>
		let map = null;
		let marker = null;
		let geocoder = null;
		
		// 주소 검색을 위한 geocoder 먼저 생성
		window.onload = function() {
		    geocoder = new kakao.maps.services.Geocoder();
		};
		
		// 모달 열릴 때 실행
		function initializeMap() {
		
		    const mapContainer = document.getElementById('mapContainer');
		
		    // 지도 최초 생성
		    if (map === null) {
		
		        const mapOption = {
		            center: new kakao.maps.LatLng(37.566826, 126.9786567),
		            level: 3
		        };
		
		        map = new kakao.maps.Map(mapContainer, mapOption);
		
		        // 마커 생성
		        marker = new kakao.maps.Marker({
		            position: map.getCenter()
		        });
		        marker.setMap(map);
		
		        // 처음 좌표 저장
		        updateHiddenInputs(map.getCenter());
		
		    }
		
		    // 모달이 열리면 리사이즈 필요
		    setTimeout(() => {
		        map.relayout();
		        map.setCenter(marker.getPosition());
		    }, 200);
		}
		
		function updateHiddenInputs(latlng) {
		    document.getElementById("addMapLat").value = latlng.getLat();
		    document.getElementById("addMapLng").value = latlng.getLng();
		}
</script>

		<script>
	function searchAddress() {
	    const addr = document.getElementById('addEventAddress').value.trim();
	    if (!addr) {
	        alert("주소를 입력해주세요.");
	        return;
	    }
	
	    geocoder.addressSearch(addr, function(result, status) {
	
	        if (status === kakao.maps.services.Status.OK) {
	
	            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	
	            // 지도 중심 이동
	            map.setCenter(coords);
	
	            // 마커 이동
	            marker.setPosition(coords);
	
	            // 좌표 hidden 값 업데이트
	            updateHiddenInputs(coords);
	
	            // 검색된 정식 주소로 input 업데이트
	            document.getElementById('addEventAddress').value = result[0].address_name;
	
	        } else {
	            alert("검색된 주소가 없습니다.");
	        }
	    });
	}
</script>

		<script>
	let editMap = null;
	let editMarker = null;
	
	function initializeEditMap(lat, lng) {
		
		 lat = Number(lat);
		 lng = Number(lng);

		 // 값이 0이거나 null이면 기본좌표로
	    if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
	        lat = 37.566826;
	        lng = 126.9786567;
	    }
	
	    const container = document.getElementById('editMapContainer');
	    if (!container) return;
	
	    const center = new kakao.maps.LatLng(lat, lng);
	    
	    if (editMap === null) {
	        editMap = new kakao.maps.Map(container, {
	            center: center,
	            level: 3
	        });
	
	        editMarker = new kakao.maps.Marker({
	            position: center
	        });
	        editMarker.setMap(editMap);
	
	    } else {
	        editMap.setCenter(center);
	        editMarker.setPosition(center);
	    }
	
	    document.getElementById("editMapLat").value = center.getLat();
	    document.getElementById("editMapLng").value = center.getLng();
	
	    kakao.maps.event.addListener(editMap, 'click', function(mouseEvent) {
	        let pos = mouseEvent.latLng;
	        editMarker.setPosition(pos);
	        document.getElementById("editMapLat").value = pos.getLat();
	        document.getElementById("editMapLng").value = pos.getLng();
	    });
	
	    setTimeout(() => {
	        editMap.relayout();
	        editMap.setCenter(center);
	    }, 200);
	}
</script>

		<script>
	function searchAddressEdit() {
	
	    const addr = document.getElementById('editEventAddress').value.trim();
	    if (!addr) {
	        alert("주소를 입력해주세요.");
	        return;
	    }
	
	    geocoder.addressSearch(addr, function(result, status) {
	
	        if (status === kakao.maps.services.Status.OK) {
	
	            const coords = new kakao.maps.LatLng(result[0].y, result[0].x);
	
	            editMap.setCenter(coords);
	            editMarker.setPosition(coords);
	
	            document.getElementById("editMapLat").value = result[0].y;
	            document.getElementById("editMapLng").value = result[0].x;
	
	            document.getElementById("editEventAddress").value = result[0].address_name;
	
	        } else {
	            alert("검색된 주소가 없습니다.");
	        }
	    });
	}
</script>

		<script>
	let detailMap = null;
	let detailMarker = null;
	
	function initializeDetailMap(lat, lng) {
		
		lat = Number(lat);
		lng = Number(lng);
		
		 if (!lat || !lng || isNaN(lat) || isNaN(lng)) {
		        lat = 37.566826;
		        lng = 126.9786567;
		    }

	    const container = document.getElementById('detailMapContainer');
	    if (!container) return;

	    // 좌표가 없으면 기본 서울 const center = new kakao.maps.LatLng(lat || 37.566826, lng || 126.9786567);

	    const center = new kakao.maps.LatLng(lat, lng)
	    
	    if (detailMap === null) {

	        detailMap = new kakao.maps.Map(container, {
	            center: center,
	            level: 3
	        });

	        detailMarker = new kakao.maps.Marker({
	            position: center
	        });
	        detailMarker.setMap(detailMap);

	    } else {
	        detailMap.setCenter(center);
	        detailMarker.setPosition(center);
	    }

	    // 모달 렌더링 보정
	    setTimeout(() => {
	        detailMap.relayout();
	        detailMap.setCenter(center);
	    }, 200);
	}
</script>



		<script>
	    const leaderClubs = [
	        <c:forEach var="cl" items="${leaderClubs}" varStatus="st">
	            { id: "${cl.id}", name: "${cl.name}" }<c:if test="${!st.last}">,</c:if>
	        </c:forEach>
	    ];
	</script>

		<script>
	    // 모임 이름 클릭 시 실행되는 함수
	    function goToClubHome(element) {
	        // 1. data-club-id 속성에서 클럽 ID를 가져옵니다.
	        const clubId = element.getAttribute('data-club-id');
	        
	        if (clubId) {
	            // 2. 클럽 홈 URL 패턴에 맞춰 이동합니다.
	            // URL 패턴이 '/club/home?clubId=1' 형태라고 가정합니다.
	            const clubHomeUrl = ctx + '/club/home?clubId=' + clubId;
	            
	            // 3. 페이지 이동
	            window.location.href = clubHomeUrl;
	        }
	    }
	</script>

		<script>
		let currentDetailData = null;
	</script>

		<script>
		function validateTime() {
		    const startValue = document.getElementById("addStart").value;
		    const endValue = document.getElementById("addEnd").value;
	
		    if (!startValue || !endValue) {
		        alert("시작시간과 종료시간을 모두 입력해주세요.");
		        return false;
		    }
	
		    const start = new Date(startValue);
		    const end = new Date(endValue);
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

		<script>
		function submitAddEvent() {
			
	
		    if (!validateTime()) {
		        return;
		    }
	
		    const cId = document.getElementById("addClubId").value;
		    
		    if(!cId || isNaN(parseInt(cId))){
		    	alert("일정을 추가할 모임을 선택해주세요. (모임 ID 오류)");
		    	return;
		    } 
		    
		    // 1. 서버로 전송할 FormData 객체 생성
		    const formData = new FormData();
		    
		    formData.append("eventTitle", document.getElementById("addTitle").value);
		    formData.append("eventContent", document.getElementById("addContent").value);
		    formData.append("startTime", document.getElementById("addStart").value);
		    formData.append("endTime", document.getElementById("addEnd").value);
		    formData.append("peopleLimit", document.getElementById("addPeopleLimit").value);
		    formData.append("eventAddress", document.getElementById("addEventAddress").value);
		    formData.append("eventDetailAddress", document.getElementById("addEventDetailAddress").value);
		    formData.append("latitude", document.getElementById("addMapLat").value);
		    formData.append("longitude", document.getElementById("addMapLng").value);
		    
		    // 2. Fetch API를 사용하여 비동기 POST 요청
		    fetch(ctx + "/schedule/add/" + cId, {
		        method: 'POST',
		        body: formData
		    })
		    .then(res => res.json())
		    .then(data => {
		        if (data.success) {
		            alert("일정이 성공적으로 등록되었습니다.");
		            
		            // 모달 닫기
		            const addModalEl = document.getElementById('addEventModal');
		            const addModal = bootstrap.Modal.getInstance(addModalEl);
		            if (addModal) {
		                addModal.hide();
		            }
		            
		            location.href = ctx + data.redirectUrl; 
		        } else {
		            // 실패 시 처리
		            alert("일정 등록 오류: " + data.message); 
		            
		            if(data.redirectUrl) {
		                location.href = ctx + data.redirectUrl;
		            }
		        }
		    })
		    .catch(error => {
		        alert("요청 처리 중 오류가 발생했습니다. 서버 상태를 확인해주세요.");
		        console.error('Fetch error:', error);
		    });
		}
	</script>

		<script>
		function openEditModalFromDetail() {
			
			sessionStorage.setItem("returnPage", window.location.pathname.replace(ctx, ""));
		    
			const data = window.currentDetailData; 
		    const eventNo = document.getElementById('detailScheduleId').value;
		    
		    // 데이터 유효성 검사 (AJAX 실패 시를 대비)
		    if (!data || !eventNo) {
		        alert("일정 상세 정보가 로드되지 않았습니다. 다시 시도해주세요.");
		        return;
		    }

		    // 상세 모달을 닫기
		    const detailModalEl = document.getElementById('eventModal'); 
		    const detailModal = bootstrap.Modal.getInstance(detailModalEl);
		    if (detailModal) {
		        detailModal.hide();
		    }
		            
		    // 3. 모달에 데이터 채우기 (Prefill)
		    document.getElementById('editEventNo').value = eventNo; 
		    document.getElementById('editClubName').value = data.clubName;
		    
		    document.getElementById('editClubId').value = data.cId; 
		    document.getElementById('editContent').value = data.eventContent;
		    document.getElementById('editPeopleLimit').value = data.peopleLimit;
		    document.getElementById('editEventAddress').value = data.eventAddress;		    
		    document.getElementById('editEventDetailAddress').value = data.eventDetailAddress;		    
		    document.getElementById('editTitle').value = data.title; 
		    
		    // 시간 포맷 처리
		    document.getElementById('editStart').value = data.startTime_ISO ? data.startTime_ISO.substring(0, 16) : '';
		    document.getElementById('editEnd').value = data.endTime_ISO ? data.endTime_ISO.substring(0, 16) : '';

		    
		    // 4. '일정 수정' 모달 열기
		    const editModal = new bootstrap.Modal(document.getElementById('editEventModal'));
		    editModal.show();
		    
		    initializeEditMap(data.latitude, data.longitude);
		}
	</script>

		<script>
		function submitUpdateEvent() {
		    
			// 기존 시간 유효성 검사 함수는 그대로 사용
		    function validateEditTime() {
		        const startValue = document.getElementById("editStart").value;
		        const endValue = document.getElementById("editEnd").value;
		        
		        if (!startValue || !endValue) {
		            alert("시작시간과 종료시간을 모두 입력해주세요.");
		            return false;
		        }

		        const start = new Date(startValue);
		        const end = new Date(endValue);
		        
		        if (start >= end) {
		            alert("종료 시간은 시작 시간보다 늦어야 합니다.");
		            return false;
		        }
		        
		        return true;
		    }

		    if (!validateEditTime()) {
		        return;
		    }
		    
		    const eventNo = document.getElementById("editEventNo").value;
		    
		    if(!eventNo){
		    	alert("수정할 일정 ID가 누락되었습니다.");
		    	return;
		    }

		    // 1. FormData 객체 생성
		    const formData = new FormData();

		    formData.append("eventTitle", document.getElementById("editTitle").value);
		    formData.append("eventContent", document.getElementById("editContent").value);
		    formData.append("startTime", document.getElementById("editStart").value);
		    formData.append("endTime", document.getElementById("editEnd").value);
		    formData.append("peopleLimit", document.getElementById("editPeopleLimit").value); 
		    formData.append("eventAddress", document.getElementById("editEventAddress").value);
		    formData.append("eventDetailAddress", document.getElementById("editEventDetailAddress").value);
		    formData.append("cId", document.getElementById("editClubId").value); 
		    formData.append("latitude", document.getElementById("editMapLat").value);
		    formData.append("longitude", document.getElementById("editMapLng").value);
		    
		    // 2. Fetch API를 사용하여 비동기 POST 요청
		    fetch(ctx + "/schedule/update/" + eventNo, {
		        method: 'POST',
		        body: formData
		    })
		    .then(res => res.json())
		    .then(data => {
		        if (data.success) {
		            alert("일정이 성공적으로 수정되었습니다.");
		            
		            // 모달 닫기
		            const editModalEl = document.getElementById('editEventModal');
		            const editModal = bootstrap.Modal.getInstance(editModalEl);
		            if (editModal) {
		                editModal.hide();
		            }
		            
		            const back = sessionStorage.getItem("returnPage") || "/schedule/myclubs";
		            location.href = ctx + back;
		            
		        } else {
		            // 🚨 실패 시 처리
		            alert("일정 수정 오류: " + data.message); 
		            
		            if(data.redirectUrl) {
		                location.href = ctx + data.redirectUrl;
		            }
		        }
		    })
		    .catch(error => {
		        alert("요청 처리 중 오류가 발생했습니다. 서버 상태를 확인해주세요.");
		        console.error('Fetch error:', error);
		    });
		}
	</script>


		<script>
		function openAddEventModal() {
	
		    const select = document.getElementById("addClubId");
		    select.innerHTML = "";
	
		    leaderClubs.forEach(club => {
		        let opt = document.createElement("option");
		        opt.value = club.id;
		        opt.textContent = club.name;
		        select.appendChild(opt);
		    });
	
		    if (leaderClubs.length > 0) {
		        select.value = leaderClubs[0].id;
		    }
	
		    const modalEl = document.getElementById('addEventModal');
		    const addModal = new bootstrap.Modal(modalEl);
		    
		    modalEl.addEventListener('shown.bs.modal', initializeMap, { once: true });
	
		    addModal.show();
		}
	</script>

		<script>
		document.addEventListener("click", function(e) {
		    let target = e.target.closest(".event-label");
		    
		    if(!target) return;
	
		    let eventNo = target.dataset.eventno;
		
		    fetch(ctx + '/schedule/detail?eventNo=' + eventNo)
		        .then(res => res.json())
		        .then(data => {
		        	
		        	window.currentDetailData = data;
		        	
		        	document.getElementById("detailScheduleId").value = eventNo;
		            
		            document.getElementById("modalClubName").innerText = data.clubName;
		            
		           	const clubNameLink = document.getElementById("modalClubNameLink");
		            
		           	clubNameLink.setAttribute('data-club-id', data.cId);
		           	
		            const statusGroup = document.getElementById("modalStatusGroup");
		            const statusDiv = document.getElementById("modalEventStatus");

		            // 상태 그룹 설정
		            statusGroup.style.display = "block";
		            statusDiv.className = "form-value fw-bold"; 

		            const status = data.status; 

		            if (status === "중단됨") {
		                statusDiv.innerText = "🚨 " + status;
		                statusDiv.classList.add('text-danger'); 
		            } else if (status === "종료됨") {
		                statusDiv.innerText = "✅ " + status;
		                statusDiv.classList.add('text-secondary'); 
		            } else if (status === "진행중") {
		                statusDiv.innerText = "🔥 " + status;
		                statusDiv.classList.add('text-primary'); 
		            } else if (status === "마감") {
		                statusDiv.innerText = "⛔ " + status;
		                statusDiv.classList.add('text-warning'); 
		            } else if (status === "모집중") {
		                statusDiv.innerText = "📢 " + status;
		                statusDiv.classList.add('text-success'); 
		            } else {
		                statusDiv.innerText = "";
		                statusGroup.style.display = "none";
		            }
		            
		            document.getElementById("modalEventTitle").innerText = data.title;
		            document.getElementById("modalEventContent").innerText = data.eventContent;
		            document.getElementById("startDay").innerText = data.startDay;
		            document.getElementById("startTime").innerText = data.startTime;
		            document.getElementById("endDay").innerText = data.endDay;
		            document.getElementById("endTime").innerText = data.endTime;
		            
		            document.getElementById('modalEventAddress').innerText = data.eventAddress;
		            document.getElementById("modalEventDetailAddress").innerText = data.eventDetailAddress;
		            document.getElementById('modalParticipantCount').innerText = data.currentParticipants + " / " + data.peopleLimit + "명";
		
		            let ul = document.getElementById("modalParticipants");
		            ul.innerHTML = "";
		            data.participants.forEach(p => {
		            	let li = document.createElement("li");

		            	let img = document.createElement("img");
		            	img.src = p.mProfileImageName 
		            	    ? ctx + '/resources/images/profile/' + p.mProfileImageName
		            	    : ctx + '/resources/images/profile/user-default.png';
		            	img.style.width = "24px";
		            	img.style.height = "24px";
		            	img.style.borderRadius = "50%";
		            	img.style.marginRight = "6px";

		            	let name = document.createElement("span");
		            	name.innerText = p.mName;

		            	li.appendChild(img);
		            	li.appendChild(name);
		            	ul.appendChild(li);
		            });
		            
		           const btnBox = document.getElementById("modalButtons");
		           btnBox.innerHTML = "";
		           
		           btnBox.style.display = 'flex';
		           btnBox.style.flexWrap = 'wrap';
		           
		           function addButton(label, onClick, color = "primary"){
		        	   let btn = document.createElement("button");
		        	   btn.className = "btn btn-" + color + " me-2 mb-2 rounded-pill";
		        	   btn.innerText = label;
		        	   btn.onclick = onClick;
		        	   btnBox.appendChild(btn);
		           }
		           
		           if (data.canJoin) {
		        	    // 내 일정에 추가하기 (POST)
		        	    addButton("내 일정에 추가하기", function() {
		        	        let form = document.createElement("form");
		        	        form.method = "post";
		        	        form.action = ctx + "/schedule/memberSchedule/" + eventNo;
		        	        document.body.appendChild(form);
		        	        form.submit();
		        	    }, "success");
		        	}

		        	if (data.canCancel) {
		        	    // 내 일정에서 삭제 (GET)
		        	    addButton("내 일정에서 삭제", function() {
		        	        location.href = ctx + "/schedule/deleteMemberSchedule/" + eventNo;
		        	    }, "warning");
		        	}

		        	if (data.canEdit) {
		        	    addButton("일정 수정", function() {
		        	    	document.getElementById('detailScheduleId').value = eventNo;
		        	        openEditModalFromDetail();
		        	    }, "secondary");
		        	}

		        	if (data.canDelete) {
		        	    // 일정 삭제 (GET)
		        	    addButton("일정 삭제", function() {
		        	        if (confirm("정말 삭제할까요?")) {
		        	            location.href = ctx + "/schedule/delete/" + eventNo;
		        	        }
		        	    }, "danger");
		        	}

		        	if (data.canAdminStop) {
		        	    // 일정 중단 (POST)
		        	    addButton("일정 중단", function() {
		        	        if (confirm("중단할까요?")) {
		        	            let form = document.createElement("form");
		        	            form.method = "post";
		        	            form.action = ctx + "/schedule/admin/stop";
		        	            
		        	            let input = document.createElement("input");
		        	            input.type = "hidden";
		        	            input.name = "eventNo";
		        	            input.value = eventNo;
		        	            
		        	            form.appendChild(input);
		        	            
		        	            document.body.appendChild(form);
		        	            form.submit();
		        	        }
		        	    }, "warning");
		        	}

		        	if (data.canAdminDelete) {
		        	    // 일정 삭제 (관리자) POST
		        	    addButton("일정 삭제(ADMIN)", function() {
		        	        if (confirm("정말 삭제할까요? 복구 불가합니다.")) {
		        	        	
		        	            let form = document.createElement("form");
		        	            form.method = "post";
		        	            form.action = ctx + "/schedule/admin/delete";
		        	            
		        	            let input = document.createElement("input");
		        	            input.type = "hidden";
		        	            input.name = "eventNo";
		        	            input.value = eventNo;
		        	            
		        	            form.appendChild(input);
		        	            
		        	            document.body.appendChild(form);
		        	            form.submit();
		        	        }
		        	    }, "danger");
		        	}
		
		            // 모달 열기
		            let modal = new bootstrap.Modal(document.getElementById('eventModal'));
		            modal.show();
		            
		            initializeDetailMap(data.latitude, data.longitude);
		        })
		        .catch(error => { 
		            alert("일정 상세 정보 로드 중 오류 발생: " + error.message);
		            console.error(error);
		        });
		});
	</script>



		<script
			src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>