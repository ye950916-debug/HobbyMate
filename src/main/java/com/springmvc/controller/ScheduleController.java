package com.springmvc.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubMember;
import com.springmvc.domain.Member;
import com.springmvc.domain.Schedule;
import com.springmvc.service.ClubMemberService;
import com.springmvc.service.ClubService;
import com.springmvc.service.PostService;
import com.springmvc.service.ScheduleService;

@Controller
@RequestMapping("/schedule")
public class ScheduleController {
	
	@Autowired
	private ScheduleService scheduleService;
	
	@Autowired
	private ClubService clubService;
	
	@Autowired
	private ClubMemberService cmService;
	
	@Autowired
	private PostService postService;
	
	//내가 속한 클럽 전체 일정 조회
	@GetMapping("/myclubs")
	public String listMyClubsSchedules(
			@RequestParam(value = "year", required = false) Integer year,
			@RequestParam(value = "month", required = false) Integer month,
			@RequestParam(value = "searchKeyword", required = false) String searchKeyword,
			HttpSession session, Model model) {
		
		LocalDate today = LocalDate.now();
		
		int currentYear = (year != null) ? year : today.getYear();
		int currentMonth = (month != null) ? month : today.getMonthValue();
		
		model.addAttribute("year", currentYear);
		model.addAttribute("month", currentMonth);
		
		LocalDate firstDay = LocalDate.of(currentYear, currentMonth, 1);
		int javaDay = firstDay.getDayOfWeek().getValue(); // 1~7
		int startDayIndex = (javaDay == 7) ? 0 : javaDay;
		int lastDay = firstDay.lengthOfMonth();
		
		int filled = startDayIndex + lastDay;

		int totalCells;
		if (filled <= 28) {
		    totalCells = 28;
		} else if (filled <= 35) {
		    totalCells = 35;
		} else {
		    totalCells = 42;
		}

		model.addAttribute("startDayIndex", startDayIndex);
		model.addAttribute("lastDay", lastDay);
		model.addAttribute("totalCells", totalCells);
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) 
			return "redirect:/login";
		
		String mId = loginMember.getmId();
		
		List<Schedule> allSchedules;
		
		boolean hasNoClubs = false;
		
		if ("ADMIN".equals(loginMember.getmRole())) {
			// 관리자 : 전체 일정 + 검색 키워드 전달
			allSchedules = scheduleService.getAllSchedulesAndSearch(searchKeyword);
			} else {	
				
				List<Integer> myClubIds = cmService.findClubIdsByMemberId(mId);
			
				if (myClubIds.isEmpty()) {
				hasNoClubs = true;
				allSchedules = new ArrayList<>();
			} else {
				// 일반 사용자 : 내 모임 일정 + 검색 키워드 전달
				allSchedules = scheduleService.getSchedulesByClubIdsAndSearch(myClubIds, searchKeyword);
			}		
		}
		
		List<Integer> currentCounts = new java.util.ArrayList<>();
		
		for (int i = 0; i < allSchedules.size(); i++) {
			Schedule s = allSchedules.get(i);
			
			int count = scheduleService.getCurrentParticipantCount(s.getEventNo());
			currentCounts.add(count);
		}
		
		List<String> clubNames = new java.util.ArrayList<>();
		
		for (int i = 0; i < allSchedules.size(); i++) {
			Schedule s = allSchedules.get(i);
			
			String clubName = clubService.findClubNameById(s.getcId());
			clubNames.add(clubName);
		}
		
		List<List<Member>> participantNamesList = new ArrayList<>();

		for (int i = 0; i < allSchedules.size(); i++) {
			Schedule s = allSchedules.get(i);
			
			List<Member> names = scheduleService.getParticipants(s.getEventNo());
			participantNamesList.add(names);
		}
		
		//내가 리더인 모임 c_id + name
		List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);

		List<Map<String, Object>> leaderClubs = new ArrayList<>();
		for (int i = 0; i < leaderClubIds.size(); i++) {
		    Integer cid = leaderClubIds.get(i);
		    Map<String, Object> map = new HashMap<>();
		    map.put("id", cid);
		    map.put("name", clubService.findClubNameById(String.valueOf(cid)));
		    leaderClubs.add(map);
		}

		model.addAttribute("leaderClubs", leaderClubs);
		
		List<Integer> memberClubIds = cmService.findClubIdsByMemberId(mId);

		// id + name 형태로 변환
		List<Map<String, Object>> memberClubs = new ArrayList<>();
		for (int i = 0; i < memberClubIds.size(); i++) {
		    Integer cid = memberClubIds.get(i);
		    Map<String, Object> map = new HashMap<>();
		    map.put("id", cid);
		    map.put("name", clubService.findClubNameById(String.valueOf(cid)));
		    memberClubs.add(map);
		}

		// JSP로 전달
		model.addAttribute("memberClubs", memberClubs);

		
		//일정 추가 중복방지
		List<Integer> existingEventNos = scheduleService.getMemberEventNos(mId);
		
		// -----------------------------
		// 달력용 일정 데이터 만들기
		// -----------------------------

		// 1) 자동 색상 배열
		String[] colors = {
		    "#2B7BFF", // 파랑
		    "#3EB489", // 초록
		    "#F1C40F", // 노랑
		    "#E67E22", // 주황
		    "#9B59B6"  // 보라
		};

		// 2) 새로운 리스트 생성 (JSP로 넘길 달력 일정 리스트)
		List<Map<String, Object>> calendarSchedules = new ArrayList<>();

		// 3) schedules 반복문 돌기
		for (int i = 0; i < allSchedules.size(); i++) {
			
			Schedule s = allSchedules.get(i);

		    // 날짜만(LocalDate) 추출
		    LocalDate startDate = s.getStartTime().toLocalDate();
		    LocalDate endDate = s.getEndTime().toLocalDate();

		    // 모임 이름
		    String clubName = clubService.findClubNameById(s.getcId());

		    // 자동 색상 선택 (clubId 기반)
		    int clubId = Integer.parseInt(s.getcId());
		    String color = colors[clubId % colors.length];

		    // 일정 정보 Map으로 묶기
		    Map<String, Object> map = new HashMap<>();
		    map.put("eventNo", s.getEventNo());
		    map.put("title", s.getEventTitle());
		    map.put("clubName", clubName);
		    map.put("start", startDate);
		    map.put("end", endDate);
		    map.put("color", color);

		    // 리스트에 추가
		    calendarSchedules.add(map);
		}

		// JSP에서 사용할 수 있게 넘기기
		model.addAttribute("calendarSchedules", calendarSchedules);
		
		LocalDate todayDate = LocalDate.now();
		
		List<Map<String, Object>> todaySchedules = calendarSchedules.stream().filter(ev -> {
			LocalDate start = (LocalDate) ev.get("start");
			LocalDate end = (LocalDate) ev.get("end");
			return (start.isEqual(todayDate) || start.isBefore(todayDate)) && (end.isEqual(todayDate) || end.isAfter(todayDate));
		}).collect(Collectors.toList());
		
		model.addAttribute("todaySchedules", todaySchedules);
		
		model.addAttribute("now", LocalDateTime.now());
		model.addAttribute("schedules", allSchedules);
		model.addAttribute("leaderClubIds", leaderClubIds);
		model.addAttribute("loginMember", loginMember);
		model.addAttribute("existingEventNos", existingEventNos);
		model.addAttribute("currentCounts", currentCounts);
		model.addAttribute("clubNames", clubNames);
		model.addAttribute("participantNamesList", participantNamesList);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("hasNoClubs", hasNoClubs);
		
		return "scheduleMyClubs";
		
	}
	
	//모달용 일정상세 보기
	@GetMapping("/detail")
	@ResponseBody
	public Map<String, Object> getScheduleDetail(@RequestParam int eventNo, HttpSession session) {
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		String mId = loginMember.getmId();
		String role = loginMember.getmRole();

	    Schedule s = scheduleService.getScheduleByNum(eventNo);
	    
	    ClubMember cm = cmService.getClubMember(mId,  Integer.parseInt(s.getcId()));
	    boolean isAdmin = "ADMIN".equals(role);
	    
	    if (cm == null && !isAdmin) {
	    	throw new RuntimeException("클럽 회원만 일정 상세를 볼 수 있습니다.");
	    }
	    
	    List<Member> members = scheduleService.getParticipants(eventNo);
	    
	    LocalDateTime now = LocalDateTime.now();
	    
	    boolean isLeader = cmService.loginMemberEqClubLeader(Integer.parseInt(s.getcId()), mId);
	    
	    boolean isJoined = scheduleService.getMemberEventNos(mId).contains(eventNo);
	    
	    int current = scheduleService.getCurrentParticipantCount(eventNo);
	    
	    boolean isFull = current >= s.getPeopleLimit();
	    boolean isStopped = "STOPPED".equals(s.getsStatus());
	    boolean isEnded = s.getEndTime().isBefore(now);
	    boolean isStarted = s.getStartTime().isBefore(now);
	    
	    boolean hasHobbyLog = postService.existsHobbyLog(eventNo, mId);
	    boolean canWriteHobbyLog = isJoined && isEnded && !hasHobbyLog;
	    
	    boolean canJoin = !isJoined && !isFull && !isStopped && !isStarted;
	    
	    boolean canCancel = isJoined && !isStarted;
	    
	    boolean canEdit = isLeader && !isStarted;
	    
	    boolean canDelete = isLeader && !isStarted;
	    
	    boolean canAdminStop = isAdmin && !isStopped;
	    boolean canAdminDelete = isAdmin;
	    
	    //JSON 구성

	    Map<String, Object> result = new HashMap<>();
	    result.put("clubName", clubService.findClubNameById(s.getcId()));
	    result.put("title", s.getEventTitle());
	    
	    result.put("eventAddress", s.getEventAddress()); // 기본 주소 (지도 API 입력값)
        result.put("eventDetailAddress", s.getEventDetailAddress()); // 상세 장소명 (사용자 노출)
        result.put("latitude", s.getLatitude());
        result.put("longitude", s.getLongitude());
        
	    LocalDateTime start = s.getStartTime();
	    LocalDateTime end = s.getEndTime();
	    
	    result.put("startDay", start.toLocalDate().toString());
	    result.put("endDay", end.toLocalDate().toString());
	    
	    result.put("startTime",toAmPmFormat(start));
	    result.put("endTime", toAmPmFormat(end));
	    
	    // 💡 JSP 수정 모달에서 필요한 필드 추가
        result.put("cId", s.getcId());
        result.put("eventContent", s.getEventContent());
        result.put("peopleLimit", s.getPeopleLimit());
        result.put("currentParticipants", current);
        
        
        // 💡 datetime-local 포맷에 필요한 ISO String (예: "2025-12-08T15:00:00.0")
        result.put("startTime_ISO", start.toString()); 
        result.put("endTime_ISO", end.toString());
	    
	    result.put("isJoined", isJoined);
	    result.put("canJoin", canJoin);
	    result.put("canCancel", canCancel);
	    result.put("canEdit", canEdit);
	    result.put("canDelete", canDelete);
	    result.put("isLeader", isLeader);
	    result.put("isAdmin", isAdmin);
	    result.put("canWriteHobbyLog", canWriteHobbyLog);
	    result.put("hasHobbyLog", hasHobbyLog);
	    
	    if (hasHobbyLog) {
	        Long hobbyLogId = postService.findHobbyLogId(eventNo, mId);
	        result.put("hobbyLogId", hobbyLogId);
	    }
	    
	    result.put("canAdminStop", canAdminStop);
	    result.put("canAdminDelete", canAdminDelete);
	    
	    String statusLabel = isStopped ? "중단됨" : isEnded ? "종료됨" : isStarted ? "진행중" : isFull ? "마감" : "모집중";
	    result.put("status", statusLabel);

	    List<Map<String, Object>> participantList = new ArrayList<>();
	    for (Member m : members) {
	        Map<String, Object> map = new HashMap<>();
	        map.put("mName", m.getmName());
	        map.put("mProfileImageName", m.getmProfileImageName());
	        participantList.add(map);
	    }

	    result.put("participants", participantList);

	    return result;
	}
	
	private String toAmPmFormat(LocalDateTime dt) {
	    int hour = dt.getHour();
	    int minute = dt.getMinute();

	    String ampm = (hour >= 12) ? "pm" : "am";
	    int hour12 = hour % 12;
	    if (hour12 == 0) hour12 = 12;

	    return String.format("%s %02d:%02d", ampm, hour12, minute);
	}
	
	//페이지용 일정상세 보기
	@GetMapping("/detail/{eventNo}")
	public String scheduleDetailPage(
	        @PathVariable int eventNo,
	        HttpSession session,
	        Model model) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) return "redirect:/login";

	    Schedule s = scheduleService.getScheduleByNum(eventNo);
	    if (s == null) {
	        model.addAttribute("error", "해당 일정이 존재하지 않습니다.");
	        return "error";
	    }
	    
	    String mId = loginMember.getmId();
	    
	    ClubMember cm = cmService.getClubMember(mId, Integer.parseInt(s.getcId()));

	    boolean isAdmin = "ADMIN".equals(loginMember.getmRole());

	    if (cm == null && !isAdmin) {
	    	model.addAttribute("error", "클럽 회원만 일정 상세를 볼 수 있습니다.");
	    	return "error";
	    }

	    String role = loginMember.getmRole();

	    boolean isLeader = cmService.loginMemberEqClubLeader(Integer.parseInt(s.getcId()), mId);
	    
	    boolean isJoined =
	            scheduleService.getMemberEventNos(mId).contains(eventNo);

	    int current = scheduleService.getCurrentParticipantCount(eventNo);

	    boolean isFull = current >= s.getPeopleLimit();
	    boolean isStopped = "STOPPED".equals(s.getsStatus());
	    boolean isEnded = s.getEndTime().isBefore(LocalDateTime.now());
	    boolean isStarted = s.getStartTime().isBefore(LocalDateTime.now());

	    boolean canJoin = !isJoined && !isFull && !isStopped && !isStarted;
	    boolean canCancel = isJoined && !isStarted;
	    boolean canEdit   = (isLeader || isAdmin) && !isStarted;
	    boolean canDelete = (isLeader || isAdmin) && !isStarted;
	    

	    model.addAttribute("schedule", s);
	    model.addAttribute("clubName",
	            clubService.findClubNameById(s.getcId()));
	    model.addAttribute("currentCount",
	            scheduleService.getCurrentParticipantCount(eventNo));
	    model.addAttribute("participants",
	            scheduleService.getParticipants(eventNo));

	    // 🔥 권한 전달
	    model.addAttribute("canEdit", canEdit);
	    model.addAttribute("canDelete", canDelete);
	    model.addAttribute("isLeader", isLeader);
	    model.addAttribute("isAdmin", isAdmin);
	    model.addAttribute("canJoin", canJoin);
	    model.addAttribute("canCancel", canCancel);

	    return "scheduleDetail";
	}


	
	
	//클럽 일정 추가
	@GetMapping("/add/{cId}")
	public String addScheduleForm(@PathVariable("cId") String cId, HttpSession session, Model model) {
		
		//로그인 체크
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return "redirect:/login";
		}
		
		String mId = loginMember.getmId();
		
		List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);
		
		if (!leaderClubIds.contains(Integer.parseInt(cId))) {
			model.addAttribute("error", "클럽 리더만 일정 추가가 가능합니다.");
			return "error";
		}
		
		Club club = clubService.findClubByClubId(Integer.parseInt(cId));
		model.addAttribute("club", club);
		
		model.addAttribute("cId", cId);
		
		return "scheduleAdd";
	}
	
	//모달용
	@PostMapping("/add/{cId}")
	@ResponseBody
	public Map<String, Object> addSchedule(
			@PathVariable("cId") String cId, 
			@ModelAttribute Schedule schedule,
			HttpSession session, Model model) {
		
		
		Map<String, Object> response = new HashMap<>();
		
		//로그인 체크
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			response.put("success", false);
			response.put("message", "로그인이 필요합니다.");
			response.put("redirectUrl", "/login");
			return response;
		}
		
		String mId = loginMember.getmId();
		
		List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);
		
		if (!leaderClubIds.contains(Integer.parseInt(cId))) {
			response.put("success", false);
			response.put("message", "클럽 리더만 일정 추가가 가능합니다.");
			return response;
		}
		
		
		if(schedule.getStartTime().isAfter(schedule.getEndTime()) ||
		   schedule.getStartTime().isEqual(schedule.getEndTime())) {
			response.put("success", false);
			response.put("message", "종료 시간은 시작 시간보다 늦어야 합니다.");
			return response;
		}
		
		if (schedule.getStartTime().isBefore(LocalDateTime.now())) {
			response.put("success", false);
			response.put("message", "이미 지난 시간에는 일정을 생성할 수 없습니다.");
			return response;
		}
		
		int clubId = Integer.parseInt(cId);
	    Club club = clubService.findClubByClubId(clubId);
	    int maxClubMembers = club.getcMaxMembers();
	    
	    if (schedule.getPeopleLimit() > maxClubMembers) {
	        response.put("success", false);
	        response.put("message", 
	            "일정의 참여 가능 인원(" + schedule.getPeopleLimit() + 
	            ")은 모임의 최대 가입 인원(" + maxClubMembers + ")을 초과할 수 없습니다.");
	        return response;
	    }
	    
	    // 6. DB 등록 (성공)
	    schedule.setcId(cId);
	    schedule.setRegisterId(mId);
	    schedule.setCreateEventDate(LocalDateTime.now());
	    scheduleService.addSchedule(schedule);
	    
	    response.put("success", true);
	    response.put("redirectUrl", "/schedule/myclubs"); // 성공 시 이동할 경로
	    
	    return response;
	}
	
	//페이지용
	@PostMapping("/add/page/{cId}")
	public String addSchedulePage(
	        @PathVariable("cId") String cId,
	        @ModelAttribute Schedule schedule,
	        HttpSession session,
	        RedirectAttributes redirectAttributes) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/login";
	    }

	    String mId = loginMember.getmId();
	    List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);

	    if (!leaderClubIds.contains(Integer.parseInt(cId))) {
	        redirectAttributes.addFlashAttribute("error", "클럽 리더만 일정 추가가 가능합니다.");
	        return "redirect:/error";
	    }

	    // 시간 검증(기존과 동일)
	    if (schedule.getStartTime().isAfter(schedule.getEndTime())
	            || schedule.getStartTime().isEqual(schedule.getEndTime())) {
	        redirectAttributes.addFlashAttribute("error", "종료 시간이 시작 시간보다 빨라야 합니다.");
	        return "redirect:/schedule/add/" + cId;
	    }

	    if (schedule.getStartTime().isBefore(LocalDateTime.now())) {
	        redirectAttributes.addFlashAttribute("error", "이미 지난 시간에는 일정을 생성할 수 없습니다.");
	        return "redirect:/schedule/add/" + cId;
	    }

	    schedule.setcId(cId);
	    schedule.setRegisterId(mId);
	    schedule.setCreateEventDate(LocalDateTime.now());

	    scheduleService.addSchedule(schedule);

	    return "redirect:/club/home?clubId=" + cId;
	}

	
	//일정 수정
		@GetMapping("/update/{eventNo}")
		public String updateScheduleForm(@PathVariable("eventNo") int eventNo, HttpSession session, Model model) {
			
			//로그인 체크
			Member loginMember = (Member) session.getAttribute("loginMember");
			if (loginMember == null) {
				return "redirect:/login";
			}
		
			//수정할 일정 조회
			Schedule schedule = scheduleService.getScheduleByNum(eventNo);
			
			String mId = loginMember.getmId();
			
			List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);
			
			if (!leaderClubIds.contains(Integer.parseInt(schedule.getcId()))) {
				model.addAttribute("error", "클럽 리더만 일정 수정할 수 있습니다.");
				return "error";
			}
			
			if(schedule.getStartTime().isAfter(schedule.getEndTime()) ||
			   schedule.getStartTime().isEqual(schedule.getEndTime())) {
			   model.addAttribute("error", "종료 시간은 시작 시간보다 늦어야 합니다.");
			   return "error";
			}
			
			if(schedule.getStartTime().isBefore(LocalDateTime.now())) {
				model.addAttribute("error", "이미 시작된 일정은 수정할 수 없습니다.");
				return "error";
			}
			
			int clubId = Integer.parseInt(schedule.getcId());
			Club club = clubService.findClubByClubId(clubId);
			model.addAttribute("club", club);
			
		    model.addAttribute("schedule", schedule);
			return "scheduleUpdate";
		}
		
		//모달용 일정 수정
		@PostMapping("/update/{eventNo}")
		@ResponseBody
		public Map<String, Object> updateSchedule(
				@PathVariable("eventNo") int eventNo, 
				@ModelAttribute Schedule schedule, 
				HttpSession session, Model model) {
			
			Map<String, Object> response = new HashMap<>(); 
		    
		    //로그인 체크
		    Member loginMember = (Member) session.getAttribute("loginMember");
		    if (loginMember == null) {
		        response.put("success", false);
		        response.put("message", "로그인이 필요합니다.");
		        response.put("redirectUrl", "/login");
		        return response;
		    }
		    
		    Schedule original = scheduleService.getScheduleByNum(eventNo);

		    String mId = loginMember.getmId();
		    
		    List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);
		    
		    // 리더 권한 체크
		    if (!leaderClubIds.contains(Integer.parseInt(original.getcId()))) {
		        response.put("success", false);
		        response.put("message", "클럽 리더만 일정 수정할 수 있습니다.");
		        return response;
		    }
		    
		    // 이미 시작된 일정 검사
		    if(original.getStartTime().isBefore(LocalDateTime.now())) {
		        response.put("success", false);
		        response.put("message", "이미 시작된 일정은 수정할 수 없습니다.");
		        return response;
		    }
		    
		    int currentParticipants = scheduleService.getCurrentParticipantCount(eventNo);
		    int newLimit = schedule.getPeopleLimit();
		    int clubId = Integer.parseInt(original.getcId());
		    Club club = clubService.findClubByClubId(clubId); // Club 정보 조회
		    int maxClubMembers = club.getcMaxMembers(); // 모임 최대 인원수

		    
		    // 🚨 1차 검사: 현재 참여 인원보다 적게 설정 불가능
		    if (newLimit < currentParticipants) {
		        response.put("success", false);
		        response.put("message",
		                "현재 참여 인원(" + currentParticipants + "명)보다 적게 설정할 수 없습니다.");
		        return response;
		    }
		    
		    // 🚨 2차 검사: 모임 최대 인원 초과 검사 (요청하신 로직)
		    if (newLimit > maxClubMembers) {
		        response.put("success", false);
		        response.put("message", 
		            "일정의 참여 가능 인원(" + newLimit + 
		            ")은 모임의 최대 가입 인원(" + maxClubMembers + ")을 초과할 수 없습니다.");
		        return response;
		    }
		    
		    // 시간 순서 유효성 검사
		    if(schedule.getStartTime().isAfter(schedule.getEndTime()) ||
		       schedule.getStartTime().isEqual(schedule.getEndTime())) {
		        response.put("success", false);
		        response.put("message", "종료 시간은 시작 시간보다 늦어야 합니다.");
		        return response;
		    }
		    

		    schedule.setEventNo(eventNo);
		    schedule.setcId(original.getcId());
		    scheduleService.updateSchedule(schedule);
		    
		    response.put("success", true);
		    response.put("redirectUrl", "/schedule/myclubs"); 
		    
		    return response;
		}
		
		//페이지용 일정 수정
		@PostMapping("/update/page/{eventNo}")
		public String updateSchedulePage(
		        @PathVariable int eventNo,
		        @ModelAttribute Schedule schedule,
		        HttpSession session,
		        RedirectAttributes redirectAttributes) {

		    Member loginMember = (Member) session.getAttribute("loginMember");
		    if (loginMember == null) return "redirect:/login";

		    Schedule original = scheduleService.getScheduleByNum(eventNo);
		    String mId = loginMember.getmId();

		    // 리더 권한 체크
		    List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);
		    if (!leaderClubIds.contains(Integer.parseInt(original.getcId()))) {
		        redirectAttributes.addFlashAttribute("error", "클럽 리더만 일정 수정할 수 있습니다.");
		        return "redirect:/error";
		    }

		    // 이미 시작된 일정 수정 불가
		    if (original.getStartTime().isBefore(LocalDateTime.now())) {
		        redirectAttributes.addFlashAttribute("error", "이미 시작된 일정은 수정할 수 없습니다.");
		        return "redirect:/schedule/update/" + eventNo;
		    }

		    int currentParticipants = scheduleService.getCurrentParticipantCount(eventNo);
		    int newLimit = schedule.getPeopleLimit();

		    // 🔥 1차: 현재 참여 인원보다 적게 설정 불가
		    if (newLimit < currentParticipants) {
		        redirectAttributes.addFlashAttribute("error",
		            "현재 참여 인원(" + currentParticipants + "명)보다 작게 설정할 수 없습니다.");
		        return "redirect:/schedule/update/" + eventNo;
		    }

		    // 🔥 2차: 모임 최대 가입 인원 초과 불가  ← 이게 누락되어 있었음!!
		    int clubId = Integer.parseInt(original.getcId());
		    Club club = clubService.findClubByClubId(clubId);
		    int maxClubMembers = club.getcMaxMembers();

		    if (newLimit > maxClubMembers) {
		        redirectAttributes.addFlashAttribute("error",
		            "참여 가능 인원(" + newLimit +
		            ")은 모임 최대 가입 인원(" + maxClubMembers + ")을 초과할 수 없습니다.");
		        return "redirect:/schedule/update/" + eventNo;
		    }

		    // 시간 검증
		    if(schedule.getStartTime().isAfter(schedule.getEndTime()) ||
		       schedule.getStartTime().isEqual(schedule.getEndTime())) {
		        redirectAttributes.addFlashAttribute("error", "종료 시간은 시작 시간보다 늦어야 합니다.");
		        return "redirect:/schedule/update/" + eventNo;
		    }

		    // DB 저장
		    schedule.setEventNo(eventNo);
		    schedule.setcId(original.getcId());
		    scheduleService.updateSchedule(schedule);

		    return "redirect:/schedule/detail/" + eventNo;
		}


		//일정 삭제
        @PostMapping("/delete/{eventNo}")
        public String deleteSchedule(@PathVariable int eventNo, @RequestParam String clubId, HttpSession session, Model model) {

            //로그인 체크 
            Member loginMember = (Member) session.getAttribute("loginMember");
            if (loginMember == null) {
                return "redirect:/login";
            }

            //삭제 대상 일정 조회
            Schedule schedule = scheduleService.getScheduleByNum(eventNo);

            String mId = loginMember.getmId();

            List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);

            if (!leaderClubIds.contains(Integer.parseInt(schedule.getcId()))) {
                model.addAttribute("error", "클럽 리더만 일정 삭제할 수 있습니다.");
                return "error";
            }

            if(schedule.getStartTime().isBefore(LocalDateTime.now())) {
                model.addAttribute("error", "이미 시작된 일정은 삭제할 수 없습니다.");
                return "error";
            }

            scheduleService.deleteSchedule(eventNo);
            return "redirect:/club/home?clubId=" + clubId;
        }
		
		//내 일정 조회
		@GetMapping("/memberSchedule")
		public String memberScheduleList(
				@RequestParam(value = "year", required = false) Integer year,
				@RequestParam(value = "month", required = false) Integer month,
				@RequestParam(value = "searchKeyword", required = false) String searchKeyword,
				HttpSession session, Model model) {
			
			LocalDate today = LocalDate.now();
			
			int currentYear = (year != null) ? year : today.getYear();
			int currentMonth = (month != null) ? month : today.getMonthValue();
			
			model.addAttribute("year", currentYear);
			model.addAttribute("month", currentMonth);
			
			LocalDate firstDay = LocalDate.of(currentYear, currentMonth, 1);
			int javaDay = firstDay.getDayOfWeek().getValue(); // 1~7
			int startDayIndex = (javaDay == 7) ? 0 : javaDay;
			int lastDay = firstDay.lengthOfMonth();
			
			int filled = startDayIndex + lastDay;

			int totalCells;
			if (filled <= 28) {
			    totalCells = 28;
			} else if (filled <= 35) {
			    totalCells = 35;
			} else {
			    totalCells = 42;
			}

			model.addAttribute("startDayIndex", startDayIndex);
			model.addAttribute("lastDay", lastDay);
			model.addAttribute("totalCells", totalCells);
			
			//로그인 체크 
			Member loginMember = (Member) session.getAttribute("loginMember");
			if (loginMember == null) {
				return "redirect:/login";
			}
			
			String mId = loginMember.getmId();

			// 2. 내가 리더인 클럽 ID 목록 가져오기
			List<Integer> leaderClubIds = cmService.findClubIdsByLeaderIdRole(mId);

			// 3. id + name 형태로 리스트 변환
			List<Map<String, Object>> leaderClubs = new ArrayList<>();
			for (int i = 0; i < leaderClubIds.size(); i++) {
			    Integer cid = leaderClubIds.get(i);
			    Map<String, Object> map = new HashMap<>();
			    map.put("id", cid);
			    map.put("name", clubService.findClubNameById(String.valueOf(cid)));
			    leaderClubs.add(map);
			}

			// 4. JSP로 전달
			model.addAttribute("leaderClubIds", leaderClubIds);
			model.addAttribute("leaderClubs", leaderClubs);
			
			List<Integer> memberClubIds = cmService.findClubIdsByMemberId(mId);

			// id + name 형태로 변환
			List<Map<String, Object>> memberClubs = new ArrayList<>();
			for (int i = 0; i < memberClubIds.size(); i++) {
			    Integer cid = memberClubIds.get(i);
			    Map<String, Object> map = new HashMap<>();
			    map.put("id", cid);
			    map.put("name", clubService.findClubNameById(String.valueOf(cid)));
			    memberClubs.add(map);
			}

			// JSP로 전달
			model.addAttribute("memberClubs", memberClubs);

			
			List<Schedule> schedules = scheduleService.memberScheduleList(mId);
			
			List<Integer> currentCounts = new java.util.ArrayList<>();
			for(int i = 0; i < schedules.size(); i++) {
				Schedule s = schedules.get(i);
				int count = scheduleService.getCurrentParticipantCount(s.getEventNo());
				currentCounts.add(count);
			}
			
			List<String> clubNames = new java.util.ArrayList<>();
			
			for (int i = 0; i < schedules.size(); i++) {
				Schedule s = schedules.get(i);
				String clubName = clubService.findClubNameById(s.getcId());
				clubNames.add(clubName);
			}
			
			List<List<Member>> participantNamesList = new ArrayList<>();

			for (int i = 0; i < schedules.size(); i++) {
				Schedule s = schedules.get(i);
			    List<Member> names = scheduleService.getParticipants(s.getEventNo());
			    participantNamesList.add(names);
			}
			
			List<Integer> existingEventNos = scheduleService.getMemberEventNos(mId);
			
			String[] colors = {
			        "#2B7BFF", // 파랑
			        "#3EB489", // 초록
			        "#F1C40F", // 노랑
			        "#E67E22", // 주황
			        "#9B59B6"  // 보라
			    };
			
			List<Map<String, Object>> calendarSchedules = new ArrayList<>();

		    for (int i = 0; i < schedules.size(); i++) {
		    	
		    	Schedule s = schedules.get(i);
		        
		        String clubName = clubService.findClubNameById(s.getcId()); 

		        int clubId = Integer.parseInt(s.getcId());
		        String color = colors[clubId % colors.length];

		        Map<String, Object> map = new HashMap<>();
		        map.put("eventNo", s.getEventNo());
		        map.put("title", s.getEventTitle());
		        map.put("clubName", clubName);
		        map.put("start", s.getStartTime().toLocalDate()); 
		        map.put("end", s.getEndTime().toLocalDate());   
		        map.put("color", color);
		        map.put("allDay", false); 

		        calendarSchedules.add(map);
		    }
		    
		    model.addAttribute("calendarSchedules", calendarSchedules);
			
		    LocalDate todayDate = LocalDate.now();
			
			List<Map<String, Object>> todaySchedules = calendarSchedules.stream().filter(ev -> {
				LocalDate start = (LocalDate) ev.get("start");
				LocalDate end = (LocalDate) ev.get("end");
				return (start.isEqual(todayDate) || start.isBefore(todayDate)) && (end.isEqual(todayDate) || end.isAfter(todayDate));
			}).collect(Collectors.toList());
			
			model.addAttribute("todaySchedules", todaySchedules);
			
			model.addAttribute("memberSchedule", schedules);
			model.addAttribute("currentCounts", currentCounts);
			model.addAttribute("existingEventNos", existingEventNos);
			model.addAttribute("clubNames", clubNames);
			model.addAttribute("now", LocalDateTime.now());
			model.addAttribute("participantNamesList", participantNamesList);
			
			return "/scheduleMember";
		}
		
		//모달전용 내 일정 추가 후 
        @PostMapping("/memberSchedule/{eventNo}")
        public String memberSchedule(@PathVariable int eventNo, HttpSession session) {

            Member loginMember = (Member) session.getAttribute("loginMember");
            if (loginMember == null) {
                return "redirect:/login";
            }

            String mId = loginMember.getmId();

            try {
                scheduleService.memberSchedule(mId, eventNo);

             } catch (IllegalStateException e) {
                    String encoded = "";
                    try {
                        encoded = URLEncoder.encode(e.getMessage(), "UTF-8");
                    } catch (UnsupportedEncodingException ex) {
                        // fallback
                        encoded = "encodingError";
                    }

                return "redirect:/schedule/myclubs?error=" + encoded;
            }

            return "redirect:/schedule/memberSchedule";
        }

		
		//페이지 전용 내 일정 추가 후 
		@PostMapping("/memberSchedule/page/{eventNo}")
		public String memberScheduleFromPage(
		        @PathVariable int eventNo,
		        HttpSession session) {

		    Member loginMember = (Member) session.getAttribute("loginMember");
		    if (loginMember == null) {
		        return "redirect:/login";
		    }

		    String mId = loginMember.getmId();

		    scheduleService.memberSchedule(mId, eventNo);

		    // 🔥 상세 페이지로 다시
		    return "redirect:/schedule/detail/" + eventNo;
		}
		
		//모달 전용 페이지 삭제 후
		@GetMapping("/deleteMemberSchedule/{eventNo}")
		public String deleteMemberSchedule(@PathVariable int eventNo, HttpSession session, RedirectAttributes redirectAttributes) {
			Member loginMember = (Member) session.getAttribute("loginMember");
			if (loginMember == null) {
				return "redirect:/login";
			}
			
			String mId = loginMember.getmId();
			Schedule schedule = scheduleService.getScheduleByNum(eventNo);
			
			if(schedule.getStartTime().isBefore(LocalDateTime.now())) {
				redirectAttributes.addFlashAttribute("error", "이미 시작된 일정은 취소할 수 없습니다.");
				return "redirect:/schedule/memberSchedule";
			}
			
			//멤버스케줄에서만 삭제
			scheduleService.deleteOnlyMemberSchedule(mId, eventNo);
			
			return "redirect:/schedule/memberSchedule";
		}
		
		//페이지 전용 삭제 후
		@GetMapping("/deleteMemberSchedule/page/{eventNo}")
		public String deleteMemberScheduleFromPage(
		        @PathVariable int eventNo,
		        HttpSession session,
		        RedirectAttributes redirectAttributes) {

		    Member loginMember = (Member) session.getAttribute("loginMember");
		    if (loginMember == null) {
		        return "redirect:/login";
		    }

		    String mId = loginMember.getmId();
		    Schedule schedule = scheduleService.getScheduleByNum(eventNo);

		    if (schedule.getStartTime().isBefore(LocalDateTime.now())) {
		        redirectAttributes.addFlashAttribute(
		            "error", "이미 시작된 일정은 취소할 수 없습니다."
		        );
		        return "redirect:/schedule/detail/" + eventNo;
		    }

		    scheduleService.deleteOnlyMemberSchedule(mId, eventNo);

		    // 🔥 상세 페이지로 다시
		    return "redirect:/schedule/detail/" + eventNo;
		}
		
		@GetMapping("/memberSchedule/{eventNo}")
		public String blockWrongAccess() {

		    return "redirect:/schedule/myclubs";
		}
		
		@PostMapping("/admin/stop")
		public String stopSchedule(@RequestParam("eventNo") int eventNo, HttpSession session, Model model) {
			Member loginMember = (Member) session.getAttribute("loginMember");
			
			if (loginMember == null || !"ADMIN".equals(loginMember.getmRole())) {
				model.addAttribute("error", "관리자만 가능합니다.");
				return "error";
			}
			
			scheduleService.updateScheduleStatus(eventNo, "STOPPED");
			return "redirect:/schedule/myclubs";
		}
				
		@PostMapping("/admin/delete")
		public String admindeleteSchedule(@RequestParam("eventNo") int eventNo, HttpSession session, Model model) {
			
			Member loginMember = (Member) session.getAttribute("loginMember");
			
			if (loginMember == null || !"ADMIN".equals(loginMember.getmRole())) {
				model.addAttribute("error", "관리자만 가능합니다.");
				return "error";
			}
			
			scheduleService.deleteMemberScheduleByEventNo(eventNo);
			scheduleService.deleteSchedule(eventNo);
			return "redirect:/schedule/myclubs";
		}
}