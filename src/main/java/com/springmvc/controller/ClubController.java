package com.springmvc.controller;

import java.io.File;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.springmvc.domain.Category;
import com.springmvc.domain.Club;
import com.springmvc.domain.ClubDetail;
import com.springmvc.domain.ClubMember;
import com.springmvc.domain.Member;
import com.springmvc.domain.Post;
import com.springmvc.domain.Schedule;
import com.springmvc.service.CategoryService;
import com.springmvc.service.ClubCategoryService;
import com.springmvc.service.ClubMemberService;
import com.springmvc.service.ClubService;
import com.springmvc.service.MemberService;
import com.springmvc.service.PostService;
import com.springmvc.service.RegionService;
import com.springmvc.service.ScheduleService;

@Controller
@RequestMapping("/club")
public class ClubController {
	
	@Autowired
	private ClubService clubService;
	
	@Autowired
	private ClubCategoryService clubCategoryService;
	
	@Autowired
	private CategoryService categoryService;
	
	@Autowired
	private ClubMemberService cmService;
	
	@Autowired
	private ScheduleService scheduleService;
	
	@Autowired
	private PostService postService;
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private RegionService regionService;
	
	
	// 새로 생성한 인스턴스에 javaTimeModule 등록되어있지 않기 때문에 이미 모듈 등록하여 생성해 둔 objectMapper을 주입받아서 사용
	@Autowired
	private ObjectMapper objectMapper;
	
	//create
	//--------------------------------
	//모임 만들기
	//--------------------------------
	@GetMapping("/create")
	public String requestCreateClubForm(@ModelAttribute("NewClub") Club club, Model model) {
		List<Map<String, Object>> sidoList = regionService.getSidoList();
		model.addAttribute("sidoList", sidoList);
		
		return "CreateClub";
	}
	
	@PostMapping("/create")
	public String createClub (@ModelAttribute("NewClub") Club club, 
							BindingResult result, 
							HttpSession session, 
							@RequestParam("categoryIds") String categoryIds,
							HttpServletRequest request) {
		
		System.out.println("시도명 = " + club.getcSiDo());
	    System.out.println("시도코드 = " + club.getcSiDoCode());
		
		if(result.hasErrors()) {
			return "CreateClub";
		}
		
		if(categoryIds == null || categoryIds.isEmpty()) {
			return "CreateClub";
		}
		
		
		//생성일 등록
		club.setcCreateDate(LocalDateTime.now());
		
		//세션에서 사용자 정보 가져오기
		Member member = (Member) session.getAttribute("loginMember");
		if(member == null) {
			return "redirect:/login";
		}
		//현재 로그인 한 회원을 모임장으로 설정
		club.setcFounderId(member.getmId());
		
		//전달받은 모임 이미지 저장 처리
		MultipartFile file = club.getcMainImage();
		
		if (file != null && !file.isEmpty()) {
			
			//원본 파일명
			String original = file.getOriginalFilename();
			System.out.println("클럽 이미지 원본 이름: " +  original);
			
			//확장자 분리
			String[] parts = original.split("\\.");
			String ext = parts[parts.length -1];
			
			//랜덤 파일명 생성
			String saveName = UUID.randomUUID().toString() + "." + ext;
			System.out.println("저장할 클럽 이미지 랜덤 이름: " + saveName);
			
			//club DTO에 저장 (DB에 저장될 파일명)
			club.setcMainImageName(saveName);
			
			//저장 경로 구하기
			String path = request.getServletContext().getRealPath("/resources/images/ClubMain");
			System.out.println(path);
			
			//실제 저장될 파일 객체
			File saveFile = new File(path, saveName);
			
			try {
				//파일 저장
				file.transferTo(saveFile);
			} catch (Exception e) {
				throw new RuntimeException("클럽 메임 이미지 업로드 실패!", e);
			}
			
		}
		
		//DB에 저장
		
		clubService.createClub(club, categoryIds);
		
		//뷰이동
		return "redirect:/";
	}
	
	
	
	//read
	
	@GetMapping("/recommended")
	public String getRecommendedClubs(@RequestParam("loginId") String memberId) {
		return "RecommendedClubsTabs";
	}
	
	//------------------------------------------
	// 회원 주소와 지역 일치하는 모임 추천받기
	//------------------------------------------	
	@GetMapping("/recommended/location")
	public String getClubsByLocation(@RequestParam("loginId") String memberId, Model model) {
		
		Member member = memberService.getMemberById(memberId);
		
		String memberSido = member.getmSiDo();
		String memberGugun = member.getmGuGun();
		
		List<ClubDetail> recommendedClubs = clubService.getClubsByLocation(memberSido, memberGugun);
		
		model.addAttribute("recommendedClubs", recommendedClubs);
		model.addAttribute("memberId", memberId);
		model.addAttribute("memberSido", memberSido);
		model.addAttribute("memberGugun", memberGugun);
		
		return "RecommendedClubsByLocation";
	}
		
		
	//------------------------------------------
	// 회원 지역 + 회원 관심 카테고리와 일치하는 카테고리의 모임 추천받기
	//------------------------------------------
	@GetMapping("/recommended/category")
	public String getClubsByCategory(@RequestParam("loginId") String memberId, Model model) {
		
		//로그인 한 사용자 ID 사용해서 추천 모임 목록 조회
		List<ClubDetail> recommendedClubs = clubService.getRecommendedClubs(memberId);
		
		model.addAttribute("recommendedClubs", recommendedClubs);
        model.addAttribute("memberId", memberId); 
		
		return "RecommendedClubs";
	}
	
	
	//---------------------------------
	// 모임 정보 상세보기
	//---------------------------------
	@GetMapping("/readone")
	public String myClubInfo(@RequestParam("clubId") int clubId, Model model) {
		Club club = clubService.findClubByClubId(clubId);
		
		List<Integer> ctIdList = clubCategoryService.findCategoryiesByIds(clubId);
		
		Map<Integer, List<Category>> categoryHierarchy = new HashMap<>();
		
		for (int i=0; i<ctIdList.size(); i++) {
			int subCtId = ctIdList.get(i);
			List<Category> hierarchy = categoryService.findCategoryWithParent(subCtId);
			categoryHierarchy.put(subCtId, hierarchy);
		}
		
		String realLeaderId = cmService.findLeaderIdByClubId(clubId);
	    model.addAttribute("realLeaderId", realLeaderId);
		
		model.addAttribute("club", club);
		model.addAttribute("categoryHierarchy", categoryHierarchy);
		
		return "ViewClubInfo";
	}
	
	//read all
	//-------------------------------------
	//모든 모임 보기
	//-------------------------------------
	@GetMapping("/viewallclubs")
	public String viewAllClubs(Model model){
		
		List<ClubDetail> allClubs;

		allClubs = clubService.getAllClubDetails();
		Collections.shuffle(allClubs);

		
		model.addAttribute("allClubs", allClubs);
		return "ViewAllClubs";
	}
	
	@GetMapping("/api/filterClubs")
	@ResponseBody
	public List<ClubDetail> filterClubs(
			@RequestParam(required = false) String sidoCode,
			@RequestParam(required = false) String gugunCode,
			
			@RequestParam(required = false) String searchType,
			@RequestParam(required = false) String searchKeyword,
			
			@RequestParam(required = false) String largeCode,
			@RequestParam(required = false) String midCode,
			@RequestParam(required = false) String subCode
			){
		
		List<ClubDetail> filteredClubs = clubService.getFilteredClubs(sidoCode, gugunCode, searchType, searchKeyword, largeCode, midCode, subCode);
		
		for(int i=0; i<1; i++) {
			ClubDetail cd = filteredClubs.get(i);
			System.out.println("필터링된 모임의 이름"+cd.getcName());
		}
		return filteredClubs;
		
	}
	
	
	//-------------------------------------
	//모임 페이지로 이동
	@GetMapping("/home")
	public String clubHome(@RequestParam("clubId") int clubId,
	                       HttpSession session,
	                       Model model) {

	    Member login = (Member) session.getAttribute("loginMember");
	    if (login == null) return "redirect:/login";

	    // 클럽 정보
	    Club club = clubService.findClubByClubId(clubId);

	    // 리더 ID
	    String leaderId = cmService.findLeaderIdByClubId(clubId);

	    // 승인된 회원 목록
	    List<ClubMember> members = cmService.findApprovedMembers(clubId);
	    
	    // 회원이 해당 클럽의 멤버인지 여부
        // joinThisClub이 true = 회원이 맞음(승인, 대기, 거부 모두 포함)
        String joinThisClub = cmService.getMemberStatus(clubId, login.getmId());
	    
	    
	    // 일정 목록
	    List<Schedule> schedules = scheduleService.getSchedulesByClubId(clubId);

	    // 일정마다 현재 참여 인원 count() 조회
	    List<Integer> currentCounts = new ArrayList<>();
	    for (int i = 0; i < schedules.size(); i++) {
	        int count = scheduleService.getCurrentParticipantCount(schedules.get(i).getEventNo());
	        currentCounts.add(count);
	    }
	    
	    // 게시글 목록
	    List<Post> posts = postService.getPostsByClubId(clubId);

	    model.addAttribute("posts", posts);
	    
	    model.addAttribute("schedules", schedules);
	    model.addAttribute("currentCounts", currentCounts);


	    model.addAttribute("club", club);
	    model.addAttribute("leaderId", leaderId);
	    model.addAttribute("members", members);
	    
	    model.addAttribute("isMember", joinThisClub);
	    
	    

	    return "ClubHome";
	}


	//===================================
	// ajax로 내모임관리 뷰 데이터 뿌리기
	//===================================
	
	// 내모임관리 클릭 시 JSP 뷰만 반환하는 메서드 (데이터x)
	@GetMapping("/myclub")
	public String myClubManagementView() {
		return "MyClubManagement";
	}
		
	@GetMapping("/myclub/active")
	@ResponseBody
	public List<Map<String, Object>> showActiveClubs(HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if (loginMember == null) {
			return Collections.emptyList();
		}
		
		String loginMId = loginMember.getmId();
		
		// 1. 로그인 회원이 속한 클럽 id들 조회("A"=active)
		List<Integer> clubIds = cmService.getClubIdsByMembersStatus(loginMember.getmId(), "A");
		
		// 2. clubIds 리스트로 club 데이터 조회
		List<Club> clubs = clubService.findClubsByClubIds(clubIds);
		
		// 3. Map 사용해서 isLeader 정보를 추가하고 새로운 리스트 생성
		List<Map<String, Object>> resultList = new ArrayList<>();
		// ObjectMapper mapper = new ObjectMapper(); <- 새 인스턴스 JavaTimeModule 등록되지 않아서 LocalDateTime 타입 만나면 에러
		
		
		for(int i=0; i<clubs.size(); i++) {
			Club club = clubs.get(i);
			// 2-1. ClubMemberService에서 현재 클럽 리더 Id 조회
			String currentLeaderId = cmService.findLeaderIdByClubId(club.getcId());
			
			// 2-2. Club 객체의 모든 필드를 Map으로 변환
			Map<String, Object> clubMap = objectMapper.convertValue(club, new TypeReference<Map<String, Object>>(){});
			
			// 2-3. 리더 여부 판단
			// 현재 리더 Id가 not null 이면서 로그인한 회원 Id와 일치 = true
			boolean isLeader = (currentLeaderId != null) && loginMId.equals(currentLeaderId);
			
			// 2-4. isLeader 데이터를 Map에 추가
			clubMap.put("isLeader", isLeader);
			
			resultList.add(clubMap);
			
		}
		
		// isLeader 데이터 추가된 map 리스트를 json으로 반환한다
		return resultList;

	}
	
	@GetMapping("/myclub/waiting")
	@ResponseBody
	public List<Club> showWaitingClubs(HttpSession session){
		Member loginMember = (Member) session.getAttribute("loginMember");
		if(loginMember == null) {
			return Collections.emptyList();
		}
		// 1. 로그인 회원이 속한 클럽 id들 조회("A"=active)
		List<Integer> clubIds = cmService.getClubIdsByMembersStatus(loginMember.getmId(), "W");
		
		// 2. clubIds 리스트로 club 데이터 조회
		List<Club> clubs = clubService.findClubsByClubIds(clubIds);
		
		return clubs;
	}
	
	@GetMapping("/myclub/rejected")
	@ResponseBody
	public List<Club> showRejectedClubs(HttpSession session){
		Member loginMember = (Member) session.getAttribute("loginMember");
		if(loginMember == null) {
			return Collections.emptyList();
		}
		// 1. 로그인 회원이 속한 클럽 id들 조회("A"=active)
		List<Integer> clubIds = cmService.getClubIdsByMembersStatus(loginMember.getmId(), "R");
		
		// 2. clubIds 리스트로 club 데이터 조회
		List<Club> clubs = clubService.findClubsByClubIds(clubIds);
		
		return clubs;
	}
	
	
	
	
	
	//update
	//---------------------------------------
	//모임 정보 수정하기
	//---------------------------------------
	@GetMapping("/update")
	public String updateClubInfoForm(@RequestParam("clubId") int clubId, Model model) {
		Club club = clubService.findClubByClubId(clubId);
		List<Integer> ctIdList = clubCategoryService.findCategoryiesByIds(clubId);
		
		Map<Integer, List<Category>> categoryHierarchy = new HashMap<>();
		
		for (int i=0; i<ctIdList.size(); i++) {
			int subCtId = ctIdList.get(i);
			List<Category> hierarchy = categoryService.findCategoryWithParent(subCtId);
			categoryHierarchy.put(subCtId, hierarchy);
		}
		
		model.addAttribute("club", club);
		model.addAttribute("categoryHierarchy", categoryHierarchy);
		return "UpdateClubInfo";
	}
	
    @PostMapping("/update")
    public String updateClubInfo(@ModelAttribute Club club, 
                                @RequestParam("categoryIds") String categoryIds,
                                @RequestParam(value = "cMainImage", required = false) MultipartFile file,
		                        @RequestParam("existingImage") String existingImage,
		                        HttpServletRequest request) {
            // 1. 카테고리 처리
            List<Integer> ctIdList = new ArrayList<Integer>();
            
            if(categoryIds != null && categoryIds.length() > 0) {
                    String[] temp = categoryIds.split(",");
                    for(int i=0; i<temp.length; i++) {
                            ctIdList.add(Integer.parseInt(temp[i]));
                    }
            }
            
            // 2. 이미지 처리
        if (file != null && !file.isEmpty()) {

            String original = file.getOriginalFilename();
            String ext = original.substring(original.lastIndexOf(".") + 1);

            String saveName = UUID.randomUUID().toString() + "." + ext;
            club.setcMainImageName(saveName);

            String path = request.getServletContext()
                                 .getRealPath("/resources/images/ClubMain");

            File saveFile = new File(path, saveName);

            try {
                file.transferTo(saveFile);
            } catch (Exception e) {
                throw new RuntimeException("클럽 메인 이미지 수정 실패", e);
            }

        } else {
            // 이미지 변경 안 했을 때 → 기존 이미지 유지
            club.setcMainImageName(existingImage);
        }
            
        clubService.updateClub(club, ctIdList);
            
        return "redirect:/club/home?clubId="+club.getcId();
    }
	
	
	
	
	//delete
	//-------------------------------------
	//모임 삭제하기
	//-------------------------------------
	@PostMapping("/delete")
	public String deleteClub(@RequestParam("clubId") int clubId, HttpSession session, Model model) {
		Member member = (Member)session.getAttribute("loginMember");
		if(member == null) {
			return "redirect:/login";
		}
		
		String loginId = member.getmId();
		Club club = clubService.findClubByClubId(clubId);
		
		if(club == null) {
			model.addAttribute("errorMessage", "존재하지 않는 모임입니다.");
			return "AccessFail";
		}
		
		String leaderId = cmService.findLeaderIdByClubId(clubId);
		if(!leaderId.equals(loginId)) {
			model.addAttribute("errorMessage", "본인이 리더인 모임만 삭제할 수 있습니다.");
			return "AccessFail";
		}
		
		clubService.deleteClub(clubId);
		
		return "redirect:/club/myclub";
	}
	
	
	
	//==================================================
	//관리자 기능
	//==================================================
	//read all
//	@GetMapping("/allclubs")
//	public String viewAllClubs(@RequestParam(value="category", required=false) String category, @RequestParam(value="location", required=false) String location, Model model, HttpSession session) {
//		String memberRole = (String)session.getAttribute("mRole");
//		
//		if("ADMIN".equals(memberRole)) {
//			List<Club> clubs;
//			if((category == null || category.isEmpty())&&(location == null || location.isEmpty())) {
//				clubs = clubService.viewAllClubs();
//			} else {
//				clubs = clubService.findClubsByCategoryAndLocation(category, location);
//			}
//			model.addAttribute("clubs", clubs);
//			model.addAttribute("selectedCategory", category);
//			model.addAttribute("selectedLocation", location);
//			return "AdminViewAllClubs";
//		}
//		else{
//			model.addAttribute("errorMessage", "관리자만 접근할 수 있는 페이지입니다. 권한이 없습니다.");
//			return "AccessFail";
//		}
//	}
	
}
