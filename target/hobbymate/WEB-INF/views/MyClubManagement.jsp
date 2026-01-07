<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 모임 관리</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="<c:url value='/resources/css/bootstrap.min.css'/>">
<link rel="stylesheet" href="<c:url value='/resources/css/theme.css'/>">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
	<style>
        /* 기본 스타일 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f7f6;
            color: #333;
            padding: 40px 0;
            margin: 0;
        }
        
        /* 메인 컨테이너 (2단 레이아웃 설정) */
        .myclub-wrapper {
            max-width: 1200px;
            margin: 0 auto;
            display: flex; /* Flexbox 활성화 */
            gap: 20px;
            background-color: white;
            padding: 20px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
            border-radius: 10px;
        }
        
        /* 왼쪽 사이드바 (Nav) */
        .sidebar {
            flex: 0 0 250px; /* 고정 너비 250px */
            padding: 10px;
            border-right: 1px solid #eee;
        }
        .sidebar button {
            display: block;
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 10px;
            border: none;
            background-color: transparent;
            text-align: left;
            font-size: 1.1em;
            font-weight: 600;
            color: #555;
            cursor: pointer;
            border-radius: 6px;
            transition: background-color 0.2s, color 0.2s;
        }
        .sidebar button:hover {
            background-color: #e0e7ff;
            color: #3f51b5;
        }
        .sidebar button.active {
            background-color: #5c6bc0; /* 현재 선택된 버튼 강조 */
            color: white;
        }

        /* 오른쪽 콘텐츠 영역 */
        .content {
            flex: 1; /* 남은 공간 모두 차지 */
            padding: 10px;
        }
        .content h2 {
            font-size: 1.8em;
            color: #1a237e;
            border-bottom: 2px solid #e0e7ff;
            padding-bottom: 10px;
            margin-top: 0;
            margin-bottom: 20px;
        }

        /* 모임 카드 스타일 */
        .club-card {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
            padding: 15px;
            margin-bottom: 15px;
            border-left: 5px solid #ccc; /* 기본 보더 */
            transition: border-left 0.3s, box-shadow 0.3s;
            position: relative;
            min-height: auto;
            overflow: hidden;
        }
        
        .club-card-content {
        	flex-grow: 1;
        }
        
        .club-action-btn {
        	float: right;
        	margin-top: 5px;
        	margin-left: 15px;
        	
        	align-self: initial;
        	top: auto;
        	right:auto;
        	
        	padding: 8px 15px;
        	background-color: #5c6bc0;
        	color: white;
        	text-decoration: none;
        	border-radius: 5px;
        	font-size: 0.9em;
        }
        
        .btn-primary {
        	text-decoration: none;
        }
        
        .club-card:hover {
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }

        /* 상태별 카드 스타일 */
        .club-card[data-status="active"] { border-left-color: #4CAF50; } /* 활동 중 */
        .club-card[data-status="waiting"] { border-left-color: #FF9800; background-color: #fff9e6; } /* 대기 중 */
        .club-card[data-status="rejected"] { border-left-color: #F44336; opacity: 0.7; } /* 반려됨 */

        /* 카드 내용 */
        .club-card h3 {
            margin-top: 0;
            margin-bottom: 5px;
            color: #3f51b5;
        }
        .club-card p {
            margin: 5px 0;
            font-size: 0.95em;
            color: #555;
        }
        .club-card i {
            margin-right: 5px;
            color: #7986cb;
        }
        .status-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            padding: 5px 10px;
            border-radius: 4px;
            font-size: 0.85em;
            font-weight: 700;
            color: white;
        }
        .status-badge.active { background-color: #4CAF50; }
        .status-badge.waiting { background-color: #FF9800; }
        .status-badge.rejected { background-color: #F44336; }
        
        .no-data {
            text-align: center;
            padding: 30px;
            border: 1px dashed #ccc;
            border-radius: 6px;
            color: #777;
        }
    </style>
</head>
<body>

	<%@ include file="/WEB-INF/views/hobbymate-header.jsp" %>
	
	<div class="myclub-wrapper mt-7">
	    <div class="sidebar">
	        <button id="btn-active" data-status="active" class="active"><i class="fas fa-check-circle"></i>활동 중인 모임</button>
	        <button id="btn-waiting" data-status="waiting"><i class="fas fa-clock"></i>가입 대기 모임</button>
	        <button id="btn-rejected" data-status="rejected"><i class="fas fa-times-circle"></i>가입 반려 모임</button>
	    </div>
	
	    <div class="content">
	        <h2><span id="list-title">활동 중인 모임</span> 목록</h2>
	        <div id="club-list-area">
	            <p class="no-data">모임을 불러오는 중입니다...</p>
	        </div>
	    </div>
	</div>

</body>

<script>
	const API_BASE_URL = '${pageContext.request.contextPath}/club/myclub';
	
	// 상태 값을 한글 이름으로 변환하는 함수
	function getStatusText(status) {
		switch(status){
		case 'active': return '활동 중';
		case 'waiting': return '승인 대기';
		case 'rejected': return '가입 반려';
		default: return '알 수 없음';
		}
	}
	
	// json 데이터를 기반으로 하나의 모임 카드 html을 생성하는 함수
	function createClubCard(club, status){
		const statusText = getStatusText(status);
		
		let cardHtml = 
			'<div class="club-card" data-status="' + status + '">' +
				'<span class="status-badge ' + status + '">' + statusText + '</span>' +
				'<div class="club-card-content">' +
					'<h3>' + club.cName + '</h3>' +
					'<p><i class="fas fa-info-circle"></i> 소개: ' + club.cDescription.substring(0, 50) + '</p>' +
				//	'<p><i class="fas fa-user"></i> 리더: ' + club.cLeaderId + '</p>' + // cLeaderId는 Controller에서 전달되는 필드명에 따라 변경될 수 있음
					'<p><i class="fas fa-users"></i> 현재 인원: ' + club.cMemberCount + ' / ' + club.cMaxMembers + '</p>' +
					'<p><i class="fas fa-map-marker-alt"></i> 지역: ' + club.cSiDo + ' ' + club.cGuGun + '</p>' + // 지도 아이콘으로 변경
				'</div>' +
				'<a href="${pageContext.request.contextPath}/club/home/?clubId=' + club.cId + '" class="club-action-btn btn-primary">모임 홈 <i class="fas fa-chevron-right"></i></a>' +
			'</div>';
			
		return cardHtml;
	}
	
	
	
		
	// json배열을 받아서 화면에 렌더링하는 함수
	function renderClubs(clubs, status) {
		const $listArea = $('#club-list-area');
		$listArea.empty(); //기존의 내용 비우기
		
		// 데이터가 없는 경우 먼저 체크
		if(!clubs || clubs.length ==0){
			$listArea.html('<p class="no-data">' + getStatusText(status) + '상태의 모임이 없습니다.</p>');
			return;
		}
		
		// **상태가 active일때만 리더/일반 회원으로 분리**
		if (status == 'active') {
			
			// 배열 변수 만들기
			var leaderClubs = [];
			var memberClubs = [];
			
			// 반복문으로 리더여부 판단 및 분류
			for (var i=0; i<clubs.length; i++) {
				var club = clubs[i];
				
				if(club.isLeader == true){
					leaderClubs.push(club);
				} else{
					memberClubs.push(club);
				}
			}
			
			var finalHtml ='';
			
			finalHtml += '<h3> 내가 리더인 모임 </h3>';
			if(leaderClubs.length > 0){
				// 리더 모임 카드 생성
				for(var i=0; i<leaderClubs.length; i++){
					finalHtml += createClubCard(leaderClubs[i], status);
				}
			} else {
				finalHtml += '<p class="no-data">리더로 활동 중인 모임이 없습니다.</p>';
			}
			
			//일반 회원인 모임
			finalHtml += '<hr>';	//구분선 추가
			finalHtml += '<h3> 일반 회원인 모임 </h3>';
			if(memberClubs.length > 0){
				for(var i=0; i<memberClubs.length; i++){
					finalHtml += createClubCard(memberClubs[i], status);
				}
			} else {
				finalHtml += '<p class="no-data">일반 회원으로 활동 중인 모임이 없습니다.</p>';
			}
			
			$listArea.html(finalHtml);
		} else{
			// 'waiting' or 'rejected'
			var totalHtml = '';
			for (var i = 0; i < clubs.length; i++) {
	            totalHtml += createClubCard(clubs[i], status);
	        }
	        $listArea.html(totalHtml);
		}
	}
	
	// ajax를 통해 모임 목록 불러오는 함수
	function loadClubs(status){
		console.log("모임 목록 로딩" + status);
		
		$('#club-list-area').html('<p class:"no-data">모임 목록을 불러오는 중...</p>');
		
		let url = API_BASE_URL + '/' + status;
		
		$.ajax({
			url: url,
			type: 'GET',
			dataType: 'json',

			
			success: function(response){
				renderClubs(response, status);
				
				// 제목 업데이트
				$('#list-title').text(getStatusText(status));
				
				// 버튼 상태 업데이트
				$('.sidebar button').removeClass('active');
				$('#btn-' + status).addClass('active');
			},
			error: function(error){
				console.error("Error loading clubs: ", error);
				$('#club-list-area').html('<p class="error-msg">모임 정보를 불러오는 데 실패했습니다.</p>');
			}
		});
	}
	
	
	// 페이지 초기화 및 이벤트 리스너 등록
	$(document).ready(function () {
		
		// 페이지 접속 시 자동으로 'A' 모임 로드
		loadClubs('active');
		
		// Nav 버튼 클릭 시 ajax 요청
		$('.sidebar button').on('click', function() {
			const status = $(this).data('status');
			loadClubs(status);
		});
	});
</script>
</html>