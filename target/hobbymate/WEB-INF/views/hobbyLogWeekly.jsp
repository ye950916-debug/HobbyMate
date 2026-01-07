<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Hobby Log · Weekly</title>

<link rel="stylesheet"
	href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet"
	href="<c:url value='/resources/css/theme.css?v=15'/>">

<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp"%>


	<div id="app-container" class="d-flex">

		<div id="sidebar" class="bg-dark text-white p-3"
			style="width: 240px; min-height: 100vh;">
			<ul class="nav flex-column">
				<li class="nav-item mb-2"><a
					href="<c:url value='/hobbylog/list'/>"
					class="nav-link text-white p-2 rounded">월간 하비로그</a></li>
				<li class="nav-item mb-2"><a
					href="<c:url value='/hobbylog/weekly'/>"
					class="nav-link bg-primary text-white p-2 rounded fw-bold">주간
						하비로그</a></li>
			</ul>
		</div>

		<div id="main-content" class="flex-grow-1 p-4">

			<div
				class="d-flex justify-content-center align-items-center calendar-header-compact mb-3">
				<div class="text-center me-3">
					<h3 class="fw-bold mb-1">${weekRangeLabel}</h3>
				</div>

				<button class="btn btn-sm btn-outline-secondary me-1"
					onclick="location.href='${pageContext.request.contextPath}/hobbylog/weekly?week=${prevWeek}'">&lt;</button>


				<button class="btn btn-sm btn-outline-secondary"
					onclick="location.href='${pageContext.request.contextPath}/hobbylog/weekly?week=${nextWeek}'">&gt;</button>

				<button class="btn btn-sm btn-primary ms-3 rounded-pill"
					onclick="location.href='${pageContext.request.contextPath}/hobbylog/weekly?${searchParam}'">Today</button>
			</div>



			<!-- 요일 헤더 -->
			<div class="weekly-head">
				<c:forEach var="day" items="${weekDays}">
					<div class="weekly-head-cell">
						${day.label}<br> <span class="text-muted small">${day.date}</span>
					</div>
				</c:forEach>
			</div>

			<!-- 본문: row 단위로 쌓아서 절대 안 겹치게 -->
			<div class="weekly-body">
				<c:if test="${empty eventRows}">
					<div class="text-center text-muted mt-5">이번 주 기록이 없습니다.</div>
				</c:if>

				<c:forEach var="row" items="${eventRows}">
					<div class="weekly-row">

						<c:forEach var="log" items="${row}">
							<a
								href="${pageContext.request.contextPath}/hobbylog/detail/${log.postId}"
								class="weekly-card text-decoration-none"
								style="grid-column: ${log.startDayIndex + 1} / span ${log.spanDays};">

								<div class="card shadow-sm border-0 rounded-4 h-100">
									<div class="card-body p-3">

										<div class="text-muted small mb-1">
											${log.scheduleStartTime.monthValue}/${log.scheduleStartTime.dayOfMonth}
											${log.scheduleStartTime.hour}:${log.scheduleStartTime.minute < 10 ? '0' : ''}${log.scheduleStartTime.minute}
											&nbsp;~&nbsp;

											<c:if
												test="${log.scheduleStartTime.toLocalDate() eq log.scheduleEndTime.toLocalDate()}">
                      ${log.scheduleEndTime.hour}:${log.scheduleEndTime.minute < 10 ? '0' : ''}${log.scheduleEndTime.minute}
                    </c:if>

											<c:if
												test="${log.scheduleStartTime.toLocalDate() ne log.scheduleEndTime.toLocalDate()}">
                      ${log.scheduleEndTime.monthValue}/${log.scheduleEndTime.dayOfMonth}
                      ${log.scheduleEndTime.hour}:${log.scheduleEndTime.minute < 10 ? '0' : ''}${log.scheduleEndTime.minute}
                    </c:if>
										</div>

										<div class="text-muted small">📅 ${log.scheduleTitle}</div>

										<div class="fw-bold mt-1">📝 ${log.postTitle}</div>

										<div class="text-muted small mt-1">
											<c:choose>
												<c:when test="${fn:length(log.postContent) > 30}">
                        ${fn:substring(log.postContent, 0, 30)}…
                      </c:when>
												<c:otherwise>
                        ${log.postContent}
                      </c:otherwise>
											</c:choose>
										</div>

									</div>
								</div>

							</a>
						</c:forEach>

					</div>
				</c:forEach>
			</div>

		</div>
	</div>

</body>
</html>
