<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hobby Log</title>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css?v=1'/>">

<meta name="viewport" content="width=device-width, initial-scale=1">

</head>
<body>


	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>



	<!-- ================= LAYOUT ================= -->
	<div id="app-container" class="d-flex">

		<!-- ===== SIDEBAR ===== -->
		<div id="sidebar" class="bg-dark text-white p-3" style="width: 240px;">
			<ul class="nav flex-column">
				<li class="nav-item mb-2"><a
					href="<c:url value='/hobbylog/list'/>"
					class="nav-link bg-primary text-white p-2 rounded fw-bold"> 월간
						하비로그 </a></li>
				<li class="nav-item mb-2"><a
					href="<c:url value='/hobbylog/weekly'/>"
					class="nav-link text-white p-2 rounded"> 주간 하비로그 </a></li>
			</ul>
		</div>

		<!-- ===== MAIN ===== -->
		<div id="main-content" class="flex-grow-1 p-4">


			<!-- ===== CALENDAR CARD ===== -->
			<div class="calendar-card shadow-sm">

				<!-- ===== HEADER ===== -->
				<div
					class="d-flex justify-content-center align-items-center calendar-header-compact mb-3">
					<h4 class="m-0 me-3 fw-bold">${year}년${month}월</h4>


					<button class="btn btn-sm btn-outline-secondary me-1"
						onclick="location.href='${pageContext.request.contextPath}/hobbylog/list?year=${prevYear}&month=${prevMonth}${searchParam}'">&lt;</button>


					<button class="btn btn-sm btn-outline-secondary"
						onclick="location.href='${pageContext.request.contextPath}/hobbylog/list?year=${nextYear}&month=${nextMonth}${searchParam}'">&gt;</button>


					<button class="btn btn-sm btn-primary ms-3 rounded-pill"
						onclick="location.href='${pageContext.request.contextPath}/hobbylog/list?${searchParam}'">Today</button>


				</div>


				<!-- 요일 -->
				<div class="row text-center fw-bold py-2 mx-0">
					<div class="col">SUN</div>
					<div class="col">MON</div>
					<div class="col">TUE</div>
					<div class="col">WED</div>
					<div class="col">THU</div>
					<div class="col">FRI</div>
					<div class="col">SAT</div>
				</div>
				<div>

					<!-- 날짜 -->
					<div class="my-3">
						<div class="hm-calendar">

							<c:forEach begin="1" end="${totalCells}" var="i">
								<c:set var="dayNumber" value="${i - startDayIndex}" />

								<div class="hm-calendar-day">

									<c:choose>
										<c:when test="${dayNumber >= 1 && dayNumber <= lastDay}">

											<div class="hm-day-number">${dayNumber}</div>

											<div class="hm-day-events">
												<c:set var="dayKeyString">
													<c:out value="${dayNumber}" />
												</c:set>

												<c:forEach var="log" items="${dailyLogs.get(i)}">
													<a
														href="${pageContext.request.contextPath}/hobbylog/detail/${log.postId}"
														class="event-label"> 📝 ${log.postTitle} </a>
												</c:forEach>
											</div>

										</c:when>

										<c:otherwise>
										</c:otherwise>
									</c:choose>

								</div>
							</c:forEach>

						</div>
					</div>
				</div>
			</div>

		</div>
	</div>

</body>
</html>
