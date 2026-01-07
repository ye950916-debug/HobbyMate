package com.springmvc.controller;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.springmvc.domain.Member;
import com.springmvc.domain.Post;
import com.springmvc.domain.PostImage;
import com.springmvc.domain.Schedule;
import com.springmvc.service.ClubService;
import com.springmvc.service.PostImageService;
import com.springmvc.service.PostService;
import com.springmvc.service.ScheduleService;

@Controller
@RequestMapping("/hobbylog")
public class HobbyLogController {
	
	@Autowired
	private PostService postService;
	
	@Autowired
	private ScheduleService scheduleService;
	
	@Autowired
	private PostImageService postImageService;
	
	@Autowired
	private ClubService clubService;
	
	@GetMapping("/list")
	public String hobbyLogList(
	        @RequestParam(value = "year", required = false) Integer year,
	        @RequestParam(value = "month", required = false) Integer month,
	        HttpSession session,
	        Model model) {

	    // 로그인 체크
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/login";
	    }

	    String memberId = loginMember.getmId();

	    // 연 / 월 처리
	    LocalDate today = LocalDate.now();
	    int currentYear = (year != null) ? year : today.getYear();
	    int currentMonth = (month != null) ? month : today.getMonthValue();

	    model.addAttribute("year", currentYear);
	    model.addAttribute("month", currentMonth);

	    // ===============================
	    // 📅 달력 계산
	    // ===============================
	    LocalDate firstDay = LocalDate.of(currentYear, currentMonth, 1);
	    int javaDay = firstDay.getDayOfWeek().getValue();
	    int startDayIndex = (javaDay == 7) ? 0 : javaDay;
	    int lastDay = firstDay.lengthOfMonth();

	    int filled = startDayIndex + lastDay;
	    int totalCells = (filled <= 28) ? 28 : (filled <= 35 ? 35 : 42);

	    model.addAttribute("startDayIndex", startDayIndex);
	    model.addAttribute("lastDay", lastDay);
	    model.addAttribute("totalCells", totalCells);

	    // ===============================
	    // ⭐ 월간 핵심 로직
	    // ===============================

	    // 월 기준 범위 (활동 기준)
	    LocalDate monthStart = LocalDate.of(currentYear, currentMonth, 1);
	    LocalDate monthEnd = monthStart.plusMonths(1).minusDays(1);

	    LocalDateTime rangeStart = monthStart.atStartOfDay();
	    LocalDateTime rangeEnd = monthEnd.plusDays(1).atStartOfDay();

	    // ✅ 월간 전용 메서드 사용 (여기가 핵심 수정)
	    List<Post> hobbyLogList =
	            postService.getMonthlyHobbyLogs(
	                    memberId,
	                    rangeStart,
	                    rangeEnd
	            );
	    
	    System.out.println("===== [DEBUG] monthly hobbyLogList size =====");
	    System.out.println(hobbyLogList.size());

	    Map<Integer, List<Post>> dailyLogs = new HashMap<>();

	    for (int d = 1; d <= lastDay; d++) {
	        dailyLogs.put(d, new ArrayList<>());
	    }
	    

	    System.out.println("===== [DEBUG] hobbyLogList detail BEFORE distribute =====");
	    // 일정 기간 기준으로 날짜 분배
	    for (int i = 0; i < hobbyLogList.size(); i++) {
	        Post log = hobbyLogList.get(i);
	        
	        System.out.println(
	                "idx=" + i
	                + ", postId=" + log.getPostId()
	                + ", eventNo=" + log.getPostEventNo()
	                + ", start=" + log.getScheduleStartTime()
	                + ", end=" + log.getScheduleEndTime()
	            );

	        if (log.getScheduleStartTime() == null || log.getScheduleEndTime() == null) {
	            continue;
	        }

	        LocalDate startDate = log.getScheduleStartTime().toLocalDate();
	        LocalDate endDate = log.getScheduleEndTime().toLocalDate();

	        LocalDate loopStart =
	                startDate.isBefore(monthStart) ? monthStart : startDate;

	        LocalDate loopEnd =
	                endDate.isAfter(monthEnd) ? monthEnd : endDate;
	        
	        System.out.println(
	        	    "   -> startDate=" + startDate
	        	    + ", endDate=" + endDate
	        	    + ", loopStart=" + loopStart
	        	    + ", loopEnd=" + loopEnd
	        	);

	        LocalDate cursor = loopStart;
	        while (!cursor.isAfter(loopEnd)) {
	        	int dayOfMonth = cursor.getDayOfMonth();
	        	int dayKey = dayOfMonth;

	        	dailyLogs.get(dayKey).add(log);
	            
	        	cursor = cursor.plusDays(1);
	        }
	    }
	    
	    for(int i = 0; i < dailyLogs.get(10).size(); i++) {
	    	System.out.println("dailyLogs"+i+": " + dailyLogs.get(10).get(i));
	    	
	    }

	    model.addAttribute("dailyLogs", dailyLogs);

	    // 이전 / 다음 달
	    int prevYear = (currentMonth == 1) ? currentYear - 1 : currentYear;
	    int prevMonth = (currentMonth == 1) ? 12 : currentMonth - 1;
	    int nextYear = (currentMonth == 12) ? currentYear + 1 : currentYear;
	    int nextMonth = (currentMonth == 12) ? 1 : currentMonth + 1;

	    model.addAttribute("prevYear", prevYear);
	    model.addAttribute("prevMonth", prevMonth);
	    model.addAttribute("nextYear", nextYear);
	    model.addAttribute("nextMonth", nextMonth);

	    return "hobbyLogList";
	}
	
	
	@GetMapping("/write")
	public String writeHobbyLog(
	        @RequestParam("eventNo") int eventNo,
	        HttpSession session,
	        Model model
	) {
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/login";
	    }

	    String mId = loginMember.getmId();

	    // 1️⃣ 일정 존재 확인
	    Schedule schedule = scheduleService.getScheduleByNum(eventNo);
	    if (schedule == null) {
	        model.addAttribute("error", "존재하지 않는 일정입니다.");
	        return "error";
	    }

	    // 2️⃣ 참여 여부 확인
	    boolean isJoined = scheduleService
	            .getMemberEventNos(mId)
	            .contains(eventNo);

	    if (!isJoined) {
	        model.addAttribute("error", "참여한 일정만 하비로그를 작성할 수 있습니다.");
	        return "error";
	    }

	    // 3️⃣ 일정 종료 여부 확인
	    if (!schedule.getEndTime().isBefore(LocalDateTime.now())) {
	        model.addAttribute("error", "일정 종료 후에만 하비로그를 작성할 수 있습니다.");
	        return "error";
	    }

	    // 4️⃣ 이미 하비로그 존재 여부
	    boolean hasHobbyLog = postService.existsHobbyLog(eventNo, mId);
	    if (hasHobbyLog) {
	        model.addAttribute("error", "이미 해당 일정에 대한 하비로그를 작성했습니다.");
	        return "error";
	    }

	    // 5️⃣ JSP에 전달할 데이터
	    model.addAttribute("eventNo", eventNo);
	    model.addAttribute("schedule", schedule);

	    return "hobbyLogWrite";
	}
	
	@PostMapping("/write")
	public String writeHobbyLogSubmit(
	        @ModelAttribute Post post,
	        @RequestParam(required = false)
	        List<MultipartFile> imageFiles,
	        HttpSession session,
	        RedirectAttributes redirectAttributes
	) {
	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/login";
	    }

	    String mId = loginMember.getmId();
	    Integer eventNo = post.getPostEventNo();

	    // 1️⃣ eventNo 필수 체크
	    if (eventNo == null) {
	        redirectAttributes.addFlashAttribute("error", "잘못된 접근입니다.");
	        return "redirect:/hobbylog/list";
	    }

	    // 2️⃣ 일정 존재 확인
	    Schedule schedule = scheduleService.getScheduleByNum(eventNo);
	    if (schedule == null) {
	        redirectAttributes.addFlashAttribute("error", "존재하지 않는 일정입니다.");
	        return "redirect:/hobbylog/list";
	    }

	    // 3️⃣ 일정 참여 여부
	    boolean isJoined = scheduleService
	            .getMemberEventNos(mId)
	            .contains(eventNo);

	    if (!isJoined) {
	        redirectAttributes.addFlashAttribute("error", "참여한 일정만 기록할 수 있습니다.");
	        return "redirect:/schedule/myclubs";
	    }

	    // 4️⃣ 일정 종료 여부
	    if (!schedule.getEndTime().isBefore(LocalDateTime.now())) {
	        redirectAttributes.addFlashAttribute("error", "일정 종료 후에만 하비로그를 작성할 수 있습니다.");
	        return "redirect:/schedule/myclubs";
	    }

	    // 5️⃣ 중복 하비로그 방지
	    boolean hasHobbyLog = postService.existsHobbyLog(eventNo, mId);
	    if (hasHobbyLog) {
	        redirectAttributes.addFlashAttribute("error", "이미 하비로그를 작성한 일정입니다.");
	        return "redirect:/hobbylog/list";
	    }

	    // 6️⃣ Post 객체 필수값 세팅
	    post.setPostMId(mId);
	    post.setPostCId(Integer.parseInt(schedule.getcId()));
	    post.setPostType("HOBBYLOG");

	    // 7️⃣ 저장
	    postService.savePost(post, loginMember.getmId());
	    
	    if (imageFiles != null && !imageFiles.isEmpty()) {
	        postImageService.insert(post.getPostId(), imageFiles);
	    }

	    // 8️⃣ 완료 후 이동
	    redirectAttributes.addFlashAttribute("message", "하비로그가 등록되었습니다.");
	    return "redirect:/hobbylog/list";
	}
	
	@GetMapping("/detail/{postId}")
    public String hobbyLogDetail(
            @PathVariable long postId,
            HttpSession session,
            Model model) {

        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/login";
        }

        Post post = postService.getHobbyLogById(postId);

        // 존재하지 않거나 하비로그가 아님
        if (post == null || !"HOBBYLOG".equals(post.getPostType())) {
            model.addAttribute("error", "존재하지 않는 하비로그입니다.");
            return "error";
        }

        // 본인 글만 열람 가능 (정책에 따라 조정 가능)
        if (!loginMember.getmId().equals(post.getPostMId())) {
            model.addAttribute("error", "접근 권한이 없습니다.");
            return "error";
        }
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        String createdAt = post.getPostCreatedDate().format(formatter);
        
        List<PostImage> images = postImageService.findByPostId(postId);
        
        Schedule schedule = null;
        String clubName = null;
        String startTimeStr = null;
        String endTimeStr = null;
        // 현재 존재하지 않는 일정에 기록된 hobbylog 여부 체크
        boolean archived = false;
        
        if (post.getPostEventNo() != 0) {
        	schedule = scheduleService.getScheduleForHobbyLog(post.getPostEventNo());
        	
        	if(schedule.getsStatus().equals("ARCHIVED")) {
        		archived = true;
        		model.addAttribute("archived", archived);
        	} else {
        		model.addAttribute("archived", archived);
        	}
        	
        	if (schedule != null) {
        		clubName = clubService.findClubNameById(schedule.getcId());
        		DateTimeFormatter timeFmt =
                        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

                startTimeStr =
                        schedule.getStartTime().format(timeFmt);
                endTimeStr =
                        schedule.getEndTime().format(timeFmt);
                
                int eventNo = schedule.getEventNo();
                
                model.addAttribute("eventNo", eventNo);
        	}
        }
        
        model.addAttribute("hobbyLog", post);
        model.addAttribute("createdAt", createdAt);
        model.addAttribute("images", images);
        model.addAttribute("schedule", schedule);
        model.addAttribute("clubName", clubName);
        model.addAttribute("startTimeStr", startTimeStr);
        model.addAttribute("endTimeStr", endTimeStr);
        

        return "hobbyLogDetail";
    }
	
	@GetMapping("/edit/{postId}")
	public String editHobbyLogForm(
	        @PathVariable long postId,
	        HttpSession session,
	        Model model) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/login";
	    }

	    Post post = postService.getHobbyLogById(postId);

	    if (post == null || !"HOBBYLOG".equals(post.getPostType())) {
	        model.addAttribute("error", "존재하지 않는 하비로그입니다.");
	        return "error";
	    }

	    // 본인 글만 수정 가능
	    if (!loginMember.getmId().equals(post.getPostMId())) {
	        model.addAttribute("error", "수정 권한이 없습니다.");
	        return "error";
	    }
	    
	    List<PostImage> images = postImageService.findByPostId(postId);
	    
	    Schedule schedule = null;
	    if (post.getPostEventNo() != 0) {
	    	schedule = scheduleService.getScheduleForHobbyLog(post.getPostEventNo());
	    }

	    model.addAttribute("hobbyLog", post);
	    model.addAttribute("images", images);
	    model.addAttribute("schedule", schedule);
	    return "hobbyLogEdit";
	}
	
	@PostMapping("/edit")
	public String editHobbyLog(
	        @RequestParam long postId,
	        @RequestParam String postTitle,
	        @RequestParam String postContent,
	        @RequestParam(required = false) List<Long> deleteImageIds,
	        @RequestParam(required = false) List<MultipartFile> imageFiles,
	        HttpSession session) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/login";
	    }

	    Post post = postService.getHobbyLogById(postId);

	    if (post == null || !"HOBBYLOG".equals(post.getPostType())) {
	        return "redirect:/hobbylog/list";
	    }

	    post.setPostTitle(postTitle);
	    post.setPostContent(postContent);
	    post.setPostMId(loginMember.getmId());

	    postService.updatePost(post);
	    
	    if (deleteImageIds != null && !deleteImageIds.isEmpty()) {
	    	for (int i = 0; i < deleteImageIds.size(); i++) {
	    		postImageService.deleteImage(deleteImageIds.get(i), postId);
	    	}
	    }
	    
	   if(imageFiles != null && !imageFiles.isEmpty()) {
		   postImageService.insert(postId, imageFiles);
		  }

	    return "redirect:/hobbylog/detail/" + postId;
	}
	
	@PostMapping("/delete")
	public String deleteHobbyLog(
	        @RequestParam long postId,
	        HttpSession session) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) {
	        return "redirect:/login";
	    }

	    Post post = postService.getHobbyLogById(postId);

	    if (post == null || !"HOBBYLOG".equals(post.getPostType())) {
	        return "redirect:/hobbylog/list";
	    }

	    postService.deletePost(postId, loginMember.getmId());

	    return "redirect:/hobbylog/list";
	}
	
	
	@GetMapping("/weekly")
	public String hobbyLogWeekly(
	        @RequestParam(required = false) String week,
	        HttpSession session,
	        Model model) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) return "redirect:/login";

	    // 1) 기준 주 계산
	    LocalDate weekStart = (week != null)
	            ? LocalDate.parse(week)
	            : LocalDate.now().with(DayOfWeek.MONDAY);

	    LocalDate weekEnd = weekStart.plusDays(6);

	    model.addAttribute("prevWeek", weekStart.minusWeeks(1).toString());
	    model.addAttribute("nextWeek", weekStart.plusWeeks(1).toString());

	    DateTimeFormatter rangeFmt = DateTimeFormatter.ofPattern("MM/dd");
	    model.addAttribute("weekRangeLabel",
	            weekStart.format(rangeFmt) + " - " + weekEnd.format(rangeFmt));

	    // 2) 조회 범위 (겹치는 일정 포함)
	    LocalDateTime rangeStart = weekStart.atStartOfDay();
	    LocalDateTime rangeEnd = weekEnd.plusDays(1).atStartOfDay();

	    List<Post> weeklyLogs = postService.getHobbyLogsByMemberAndDateRange(
	            loginMember.getmId(),
	            rangeStart,
	            rangeEnd
	    );

	    // 3) 요일 헤더 데이터 (weekDays) 만들기
	    List<Map<String, String>> weekDays = new ArrayList<>();
	    String[] labels = {"MON","TUE","WED","THU","FRI","SAT","SUN"};
	    DateTimeFormatter dayFmt = DateTimeFormatter.ofPattern("MM/dd");

	    for (int i = 0; i < 7; i++) {
	        LocalDate day = weekStart.plusDays(i);
	        Map<String, String> m = new HashMap<>();
	        m.put("label", labels[i]);
	        m.put("date", day.format(dayFmt));
	        weekDays.add(m);
	    }
	    model.addAttribute("weekDays", weekDays);

	    // 4) startDayIndex / spanDays 계산
	    for (int i = 0; i < weeklyLogs.size(); i++) {
	        Post log = weeklyLogs.get(i);

	        if (log.getScheduleStartTime() == null || log.getScheduleEndTime() == null) continue;

	        LocalDate startDate = log.getScheduleStartTime().toLocalDate();
	        LocalDate endDate = log.getScheduleEndTime().toLocalDate();

	        int startIndex = (int) ChronoUnit.DAYS.between(weekStart, startDate);
	        if (startIndex < 0) startIndex = 0;
	        if (startIndex > 6) startIndex = 6;

	        int span = (int) ChronoUnit.DAYS.between(startDate, endDate) + 1;

	        if (startIndex + span > 7) {
	            span = 7 - startIndex;
	        }
	        if (span < 1) span = 1;

	        log.setStartDayIndex(startIndex);
	        log.setSpanDays(span);
	    }

	    // 5) 겹치지 않게 row 분리 (eventRows)
	    List<List<Post>> eventRows = new ArrayList<>();

	    for (int i = 0; i < weeklyLogs.size(); i++) {
	        Post log = weeklyLogs.get(i);
	        boolean placed = false;

	        for (int r = 0; r < eventRows.size(); r++) {
	            List<Post> row = eventRows.get(r);
	            boolean conflict = false;

	            for (int j = 0; j < row.size(); j++) {
	                Post exist = row.get(j);

	                int aStart = exist.getStartDayIndex();
	                int aEnd = aStart + exist.getSpanDays() - 1;

	                int bStart = log.getStartDayIndex();
	                int bEnd = bStart + log.getSpanDays() - 1;

	                if (!(aEnd < bStart || bEnd < aStart)) {
	                    conflict = true;
	                    break;
	                }
	            }

	            if (!conflict) {
	                row.add(log);
	                placed = true;
	                break;
	            }
	        }

	        if (!placed) {
	            List<Post> newRow = new ArrayList<>();
	            newRow.add(log);
	            eventRows.add(newRow);
	        }
	    }

	    // ✅ JSP가 쓸 데이터들
	    model.addAttribute("eventRows", eventRows);

	    return "hobbyLogWeekly";
	}

}
