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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.springmvc.domain.Category;
import com.springmvc.domain.Club;
import com.springmvc.domain.Member;
import com.springmvc.service.CategoryService;
import com.springmvc.service.ClubMemberService;
import com.springmvc.service.ClubService;
import com.springmvc.service.MemberCategoryService;
import com.springmvc.service.MemberService;
import com.springmvc.service.PostService;
import com.springmvc.service.ScheduleService;

@Controller
@RequestMapping("/member")
public class MemberController {
	
	@Autowired
	private MemberService memberService;
	
	@Autowired
	private ClubService clubService;
	
	@Autowired
	private ClubMemberService clubMemberService;
	
	@Autowired
	private CategoryService categoryService;
	
	@Autowired
	private MemberCategoryService memberCategoryService;
	
	@Autowired
	private ScheduleService scheduleService;
	
	@Autowired
	private PostService postService;
	
	
	//회원가입
	@GetMapping("/join")
	public String joinForm() {
		System.out.println("회원가입 폼 표시");
		return "memberJoin";
	}
	
	@PostMapping("/join")
	public String join(@ModelAttribute Member member,
					   @RequestParam("favCategory1") int favCategory1,
					   @RequestParam("favCategory2") int favCategory2,
					   @RequestParam("favCategory3") int favCategory3,
					   HttpServletRequest request) {
		
		System.out.println("전체주소 = " + member.getmAddress());
		System.out.println("시/도 = " + member.getmSiDo());
		System.out.println("구/군 = " + member.getmGuGun());
		System.out.println("동 = " + member.getmDong());
		
		// 시도명 정규화
		member.setmSiDo(normalizeSidoName(member.getmSiDo()));
		
		// 구군 공백 제거
		if (member.getmGuGun() != null) {
		    member.setmGuGun(member.getmGuGun().replaceAll("\\s+", ""));
		}
		
		//아이디 유효성 검사
		if (!member.getmId().matches("^(?=.*[a-z])(?=.*[0-9])[a-z0-9]{5,15}$")) {
		    request.setAttribute(
		        "error",
		        "아이디는 영문 소문자와 숫자를 반드시 포함한 5~15자여야 합니다."
		    );
		    return "memberJoin";
		}
		
		//전화번호 유효성 검사 숫자만 허용
		if(!member.getmPhone().matches("^010[0-9]{8}$")) {
			request.setAttribute("error", "전화번호는 010으로 시작하는 11자리 숫자여야 합니다.");
			return "memberJoin";
		}
		
		Member phoneUser = memberService.findByPhone(member.getmPhone());
		if (phoneUser != null) {
		    request.setAttribute("error", "이미 사용 중인 전화번호입니다.");
		    return "memberJoin";
		}
		
		
		//가입 날짜 설정
		member.setmJoinDate(LocalDateTime.now());
		
		//기본 권한 설정
		member.setmRole("USER");
		
		//전달받은 프로필 이미지 저장 처리
		MultipartFile file = member.getmProfileImage();
		
		if (file != null && !file.isEmpty()) {
			
			//원본 파일명
			String original = file.getOriginalFilename();
			System.out.println("원본 이미지 이름: " + original);
	
			//확장자 분리
			String[] parts = original.split("\\.");
			String ext = parts[parts.length -1];
			
			//랜덤 파일명 생성
			String saveName = UUID.randomUUID().toString() + "." + ext;
			System.out.println("저장될 랜덤 이름: " + saveName);
			
			//member DTO에 저장 ("DB에 들어갈 파일명")
			member.setmProfileImageName(saveName);
			
			//저장 경로 구하기
			String path = request.getServletContext().getRealPath("/resources/images/profile");
			System.out.println(path);
			
			//실제 저장될 파일 객체
			File saveFile = new File(path, saveName);
			
			try {
				//파일 저장
				file.transferTo(saveFile);
			} catch (Exception e) {
				throw new RuntimeException("프로필 이미지 업로드 실패!", e);
			}
		
	}
		//회원 저장
		memberService.addMember(member);
		
		System.out.println("MemberService.addMember() 호출 완료");
		
		memberCategoryService.add(member.getmId(), favCategory1);
		memberCategoryService.add(member.getmId(), favCategory2);
		memberCategoryService.add(member.getmId(), favCategory3);
		
		System.out.println("관심 카테고리 저장 완료");

		return "welcome";
	}
	
	//회원 가입시 아이디 중복 체크(AJAX)
	@GetMapping("/checkId")
	@ResponseBody
	public String checkId(@RequestParam("mId") String mId) {
		
		if (!mId.matches("^(?=.*[a-z])(?=.*[0-9])[a-z0-9]{5,15}$")) {
	        return "INVALID";
	    }
		
		Member member = memberService.getMemberById(mId);
		
		if(member == null) {
			return "OK";
		}
		else {
			return "DUPLICATE";
		}
		
	}
	
	
	// 시도 약칭 → 정식 행정구역명 변환 테이블
	private static final Map<String, String> SIDO_NORMALIZE;

	static {
	    Map<String, String> map = new HashMap<>();
	    map.put("서울", "서울특별시");
	    map.put("서울시", "서울특별시");
	    map.put("인천", "인천광역시");
	    map.put("부산", "부산광역시");
	    map.put("대구", "대구광역시");
	    map.put("대전", "대전광역시");
	    map.put("광주", "광주광역시");
	    map.put("울산", "울산광역시");
	    map.put("세종", "세종특별자치시");

	    map.put("경기", "경기도");
	    map.put("강원", "강원도");
	    map.put("충북", "충청북도");
	    map.put("충남", "충청남도");
	    map.put("전북", "전라북도");
	    map.put("전남", "전라남도");
	    map.put("경북", "경상북도");
	    map.put("경남", "경상남도");

	    map.put("제주", "제주특별자치도");

	    SIDO_NORMALIZE = Collections.unmodifiableMap(map);
	}


	// 변환 함수
	private String normalizeSidoName(String sido) {
	    return SIDO_NORMALIZE.getOrDefault(sido, sido);
	}
	
	
	//회원 전체 조회
	@GetMapping("/list")
	public String getAllMembers(HttpSession session, Model model) {
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		
		if (loginMember == null) {
			return "redirect:/login";
		}
		
		if(!"ADMIN".equals(loginMember.getmRole())){
			model.addAttribute("error", "관리자만 접근 가능합니다.");
			return "error";
		}
		
		List<Member> memberList = memberService.getAllMembers();
		model.addAttribute("memberList", memberList);
		return "memberList";
	}
	
	//회원 조건 조회 (Read some)
	@GetMapping("/search")
	public String searchMembers(@RequestParam("keyword") String keyword, Model model) {
		System.out.println("검색 요청 들어옴, keyword: " + keyword);
		List<Member> members = memberService.searchMembers(keyword);
		model.addAttribute("memberList", members);
		return "memberList";
	}
	
	//회원 상세 조회 (Read one)
	@GetMapping("/{mId}")
	public String getMemberById(@PathVariable("mId") String mId, HttpSession session, Model model) {
		System.out.println("회원 상세 조회 요청됨. mId" + mId);
		
		//로그인 체크 여부
		Member loginMember = (Member) session.getAttribute("loginMember");
		if(loginMember == null) {
			return "redirect:/login";
		}
		
		//본인 or 관리자만 접근 허용
		if(!"ADMIN".equals(loginMember.getmRole()) &&
		   !loginMember.getmId().equals(mId)) {
			
			model.addAttribute("error", "본인 정보만 조회할 수 있습니다.");
			return "error";
		}
		
		//멤버 ID 조회
		Member member = memberService.getMemberById(mId);
		model.addAttribute("member", member);
		
		System.out.println("조회된 회원 정보: " + member);
		
		//관심분야 조회
		List<Integer> favList = memberCategoryService.getCategoriesByMember(mId);
		List<Category> favCategories = categoryService.findCategoriesByIds(favList);
		List<String> favFullNames = new ArrayList<>();
		
		for (Category sub : favCategories) {
			Category mid = categoryService.getCategoryById(sub.getCtParentId());
			Category top = categoryService.getCategoryById(mid.getCtParentId());
			String path = top.getCtName() + " > " + mid.getCtName() + " > " + sub.getCtName();
			favFullNames.add(path);
		}
		
		model.addAttribute("favCategories", favCategories);
		model.addAttribute("favFullNames", favFullNames);
		
		return "memberDetail";
	}
		
	//회원 수정
	@GetMapping("/update/{mId}")
	public String updateForm(@PathVariable String mId, Model model) {
		
		Member member = memberService.getMemberById(mId);
		model.addAttribute("member", member);
		
		//MEMBERCATEGORY에서 회원이 가진 소분류 ct_id 3개 가져오기
		List<Integer> favList = memberCategoryService.getCategoriesByMember(mId);
		model.addAttribute("favList", favList);
		
		//소분류 카테고리 객체 가져오기
	    List<Category> favCategories = categoryService.findCategoriesByIds(favList);
	    
	    //JSP가 알아야 할 대·중·소 ID 목록
	    List<Integer> favLv1 = new ArrayList<>();
	    List<Integer> favLv2 = new ArrayList<>();
	    List<Integer> favLv3 = new ArrayList<>();
	    
	    // 소 → 중(parentId) → 대(parentId)로 parent 타고 올라가기
	    for (Category c : favCategories) {
	    	int lv3 = c.getCtId();
	    	int lv2 = c.getCtParentId();
	    	
	    	// 중분류 Category 객체 조회 → 여기서 대분류 ID 알 수 있음
	    	Category mid = categoryService.getCategoryById(lv2); //중분류의 부모 = 대분류 ID
	    	int lv1 = mid.getCtParentId();
	    	
	    	favLv1.add(lv1);
	    	favLv2.add(lv2);
	    	favLv3.add(lv3);
	    }
	    
	    model.addAttribute("favLv1", favLv1);
	    model.addAttribute("favLv2", favLv2);
	    model.addAttribute("favLv3", favLv3);
		
		System.out.println("수정폼 표시: " + mId);
		return "memberUpdate";
	}
	
	@PostMapping("/update")
	public String updateMember(@ModelAttribute Member member, 
							   @RequestParam("favCategory1") int fav1,
							   @RequestParam("favCategory2") int fav2,
							   @RequestParam("favCategory3") int fav3,
							   @RequestParam(value="deleteImage", required=false) String deleteImage, HttpServletRequest request) {
		
		System.out.println(">>> 전달된 주소 mAddress = " + member.getmAddress());
		System.out.println(">>> si_do = " + member.getmSiDo());
		System.out.println(">>> gu_gun = " + member.getmGuGun());
		System.out.println(">>> dong = " + member.getmDong());
		
		// 시도명 정규화
		member.setmSiDo(normalizeSidoName(member.getmSiDo()));
		
		// 구군 공백 제거
		if (member.getmGuGun() != null) {
		    member.setmGuGun(member.getmGuGun().replaceAll("\\s+", ""));
		}
		
		if(!member.getmPhone().matches("^010[0-9]{8}$")) {
			request.setAttribute("error", "전화번호는 010으로 시작하는 11자리 숫자여야 합니다.");
			return "memberUpdate";
		}
		
		Member phoneUser = memberService.findByPhone(member.getmPhone());
		if(phoneUser != null && !phoneUser.getmId().equals(member.getmId())) {
			request.setAttribute("error", "이미 사용 중인 전화번호입니다.");
			return "memberUpdate";
		}

		
		//기존 회원 정보 조회 (기존 프로필 파일명, 가입일 유지용)
		Member oldMember = memberService.getMemberById(member.getmId());
		
		//가입일 수정 변경 막기
		member.setmJoinDate(oldMember.getmJoinDate());
		
		//role 변경 막기
		member.setmRole(oldMember.getmRole());
		
		//프로필 이미지 저장 경로
		String path = request.getServletContext().getRealPath("/resources/images/profile");
		
		//기존 프로필 이미지 파일명
		String oldFileName = oldMember.getmProfileImageName();
		
		//업로드된 파일
		MultipartFile file = member.getmProfileImage();
		
		//최종 프로필 이미지 파일명 (기본은 기존 파일명 유지)
		String finalName = oldFileName;
		
		
		//프로필 이미지 삭제 버튼 클릭
		if("yes".equals(deleteImage)) {
			finalName = null;
			file = null;
		}
		
		//새 프로필 이미지 등록
		if (file != null && !file.isEmpty()) {
			
			//원본 파일명
			String original = file.getOriginalFilename();
			//확장자 분리
			String[] parts = original.split("\\.");
			String ext = parts[parts.length -1];
			//랜덤 파일명 생성
			finalName = UUID.randomUUID().toString() + "." + ext;
			}
		
		//기존 파일 삭제
		if (oldFileName != null && !oldFileName.equals(finalName)) {
			File oldFile = new File(path, oldFileName);
			if (oldFile.exists()) oldFile.delete();
		}
		
		//새 파일 저장
		if (file != null && !file.isEmpty()) {
			File saveFile = new File(path, finalName);
			try {
				file.transferTo(saveFile);
			} catch (Exception e) {
				throw new RuntimeException("프로필 이미지 업로드 실패!", e);
			}
		}
		
		//member DTO에 저장 ("DB에 들어갈 파일명")
		member.setmProfileImageName(finalName);
		
		memberService.updateMember (member);
		System.out.println("회원정보 수정 완료: " + member);
		
		//기존 관심분야 삭제
		memberCategoryService.deleteAll(member.getmId());
		
		memberCategoryService.add(member.getmId(), fav1);
		memberCategoryService.add(member.getmId(), fav2);
		memberCategoryService.add(member.getmId(), fav3);
		
		System.out.println("관심분야 수정 완료!");
		
		return "redirect:/member/" + member.getmId();
	}
	
	@GetMapping("/checkPhone")
	@ResponseBody
	public String checkPhone(@RequestParam("phone") String phone,
			                 @RequestParam(value = "currentId", required = false) String currentId) {
		Member found = memberService.findByPhone(phone);
		
		if (found == null) return "OK";
		
		if (currentId != null && found.getmId().equals(currentId)) {
			return "OK";
		}
		
		return "DUPLICATE";
	}
	
	//회원 탈퇴
		@PostMapping("/delete")
		public String deleteMember(@RequestParam("mId") String mId, HttpSession session, Model model) {
			Member loginMember = (Member) session.getAttribute("loginMember");
			
			if(loginMember == null) {
				return "redirect:/login";
			}
			
			//본인 or ADMIN만 삭제 가능
			if(!"ADMIN".equals(loginMember.getmRole()) &&
			   ! loginMember.getmId().equals(mId)) {
				model.addAttribute("error", "본인만 탈퇴할 수 있습니다.");
				return "error";
			}
			
			List<Club> leaderClubs = clubMemberService.findLeaderClubsByMemberId(mId);
			
			if(leaderClubs != null && !leaderClubs.isEmpty()) {
				
				model.addAttribute("leaderClubs", leaderClubs);
				
				return "/deleteBlocked";
			}
			
			// 본인이 작성한 일정의 작성자 NULL 처리
			scheduleService.nullifyRegisterId(mId);
			
			//일정 참여 삭제
			scheduleService.deleteMemberScheduleByMember(mId);
			
			//하비로그 삭제
			postService.deleteHobbyLogsByMember(mId);
			
			//클럽 소속 삭제
			clubMemberService.deleteByMember(mId);
			
			//관심분야(MEMBERCATEGORY) 삭제
			memberCategoryService.deleteAll(mId);
			System.out.println("관심 카테고리 삭제 완료: " + mId);
			
			//DB에서 회원 삭제
			memberService.deleteMember(mId);
			System.out.println("회원 삭제 완료: " + mId);
			
			//본인 or 관리자가 탈퇴하면 세션 종료
			if(!"ADMIN".equals(loginMember.getmRole())) {
				session.invalidate();
			}
			
			return "redirect:/";
		}
		
		@PostMapping("/admin/suspend")
		public String suspendMember(@RequestParam("mId") String mId, HttpSession session, Model model) {
			Member loginMember = (Member) session.getAttribute("loginMember");
			
			if (loginMember == null || !"ADMIN".equals(loginMember.getmRole())) {
				model.addAttribute("error", "관리자만 접근 가능합니다.");
				return "error";
			}
			memberService.updateStatus(mId, "SUSPENDED");
			System.out.println("관리자에 의해 SUSPENDED 처리됨 : " + mId);
			
			return "redirect:/member/list";
		}
		
		@PostMapping("/admin/activate")
		public String activateMember(@RequestParam("mId") String mId, HttpSession session, Model model) {
			Member loginMember = (Member) session.getAttribute("loginMember");
			
			if (loginMember == null || !"ADMIN".equals(loginMember.getmRole())) {
				model.addAttribute("error", "관리자만 접근 가능합니다.");
				return "error";
			}
			memberService.updateStatus(mId, "ACTIVE");
			System.out.println("관리자에 의해 ACTIVE 처리됨 : " + mId);
			
			return "redirect:/member/list";
		}
		
		@PostMapping("/admin/delete")
		public String forceDeleteMember(@RequestParam("mId") String mId, HttpSession session, Model model) {
			Member loginMember = (Member) session.getAttribute("loginMember");
			
			if (loginMember == null || !"ADMIN".equals(loginMember.getmRole())) {
				model.addAttribute("error", "관리자만 접근 가능합니다.");
				return "error";
			}
			
			List<Club> leaderClubs = clubMemberService.findLeaderClubsByMemberId(mId);
			
			if(leaderClubs != null && !leaderClubs.isEmpty()) {
				model.addAttribute("leaderClubs", leaderClubs);
				model.addAttribute("error", "해당 회원은 클럽 리더입니다. 위임 또는 클럽 삭제 후 탈퇴 가능합니다.");
				return "deleteBlocked";
			}
			
			scheduleService.nullifyRegisterId(mId);
			
			scheduleService.deleteMemberScheduleByMember(mId);
			
			postService.deleteHobbyLogsByMember(mId);
			
			clubMemberService.deleteByMember(mId);
			
			memberCategoryService.deleteAll(mId);
			
			memberService.updateStatus(mId, "DELETED");
			
			//memberService.deleteMember(mId);

			System.out.println("관리자에 의해 강제 탈퇴됨 : " + mId);
			
			return "redirect:/member/list";
		}
		

	}
