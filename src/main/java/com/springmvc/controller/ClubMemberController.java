package com.springmvc.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubMember;
import com.springmvc.domain.Member;
import com.springmvc.service.ClubMemberService;
import com.springmvc.service.ClubService;

@Controller
@RequestMapping("/clubmember")
public class ClubMemberController {
	
	@Autowired
	private ClubMemberService cmService;
	
	@Autowired
	private ClubService clubService;
	
	//create
	//모임 가입
	@GetMapping("/join")
	public String joinClub(@RequestParam("cmCId") int clubId, HttpSession session) {
		Member member = (Member) session.getAttribute("loginMember");
		if(member == null) {
			return "redirect:/login";
		}
		
		// 이미 가입했거나 신청한 기록이 있는지 확인
	    ClubMember exist = cmService.getClubMember(member.getmId(), clubId);

	    if (exist != null) {
	        return "redirect:/club/home?clubId=" + clubId + "&msg=applyAlready";
	    }
		
	    cmService.applyJoin(clubId, member.getmId());
	    
	    return "redirect:/club/home?clubId=" + clubId + "&msg=applySuccess";
	}
	

	// read
	@GetMapping("/readone")
	public String readMembersClub(@RequestParam("clubId") int clubId, HttpSession session, Model model) {
		Member member = (Member) session.getAttribute("loginMember");
		if (member == null) return "redirect:/login";
		
		//모임 정보 가져오기
		Club club = clubService.findClubByClubId(clubId);
		
		//승인된 멤버인지 획인
		ClubMember cm = cmService.getClubMember(member.getmId(), clubId);
		if(cm == null || !"A".equals(cm.getCmStatus())) {
			return "redirect:/clubmember/readsome?loginId=" + member.getmId();
		}
		
		model.addAttribute("club", club);
		model.addAttribute("clubmember", cm);
		
		return "ViewMyClub";
	}
	
	//특정 그룹에 가입한 회원 조회
	@GetMapping("/manage")
	public String manageMembers(@RequestParam("clubId") int clubId, Model model) {
		System.out.println("manageMembers 시작. clubId = "+clubId);
		List<ClubMember> waitingList = cmService.getMembersByStatus(clubId, "W");
		List<ClubMember> approvedList = cmService.getMembersByStatus(clubId, "A");
		String leaderId = cmService.findLeaderIdByClubId(clubId);
		
		for(int i=0; i<waitingList.size(); i++) {
			ClubMember cm = waitingList.get(i);
			System.out.println(cm.getCmCId());
			System.out.println(cm.getCmMId());
			System.out.println(cm.getCmStatus());
		}
		
		model.addAttribute("waitingList", waitingList);
		model.addAttribute("approvedList", approvedList);
		model.addAttribute("clubId", clubId);
		model.addAttribute("leaderId", leaderId);

		
		return "ClubMemberManage";
	}
	
	//그룹에 가입되어있는 회원 모두 조회(관리자사용)
	
	
	
	//update
	//회원가입 승인(그룹장)
	@PostMapping("/approve")
	public String approve(@RequestParam("memberId") String memberId, @RequestParam("clubId") int clubId) {
		
		cmService.updateStatus(memberId, clubId, "A");
		
		return "redirect:/clubmember/manage?clubId="+clubId;
	}
	
	//회원가입 거절(그룹장)
	@PostMapping("/reject")
	public String reject(@RequestParam("memberId") String memberId, @RequestParam("clubId") int clubId) {
		cmService.updateStatus(memberId, clubId, "R");
		return "redirect:/clubmember/manage?clubId="+clubId;
	}
	
	//그룹장 변경
	@GetMapping("/changeleader")
	public String showChangeLeaderForm(@RequestParam("clubId") int clubId, HttpSession session, Model model) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if(loginMember == null) {
			return "redirect:/login";
		}
		
		String loginMemberId = loginMember.getmId();
		
		//현재 요청 발생 회원이 이 그룹의 모임장이 맞는지 검토
		boolean isLeader = cmService.loginMemberEqClubLeader(clubId, loginMemberId);
		
		if(!isLeader) {
			return "redirect:/club/readone?cId=" + clubId + "&msg=notLeader";
		}
		
		List<ClubMember> approvedMembers = cmService.getApprovedMemberExceptLeader(clubId, loginMemberId);
		
		model.addAttribute("clubId", clubId);
		model.addAttribute("clubmembers", approvedMembers);
		
		return "ChangeClubLeaderForm";
	}
	
	@PostMapping("/changeleader")
	public String changeLeader(@RequestParam("clubId") int clubId, @RequestParam("newLeaderId") String newLeaderId, HttpSession session) {
		Member loginMember = (Member) session.getAttribute("loginMember");
		if(loginMember == null) {
			return "redirect:/login";
		}
		
		String currentLeaderId = loginMember.getmId();
		
		boolean success = cmService.changeLeaderRole(clubId, currentLeaderId, newLeaderId);
		
		if(!success) {
			return "redirect:/club/readone?clubId=" + clubId + "&msg=leaderChangeFail";
		}
		
		return "redirect:/club/home?clubId=" + clubId + "&msg=leaderChanged";
	}
	
	//그룹장 강제 변경 (관리자)
	@GetMapping("/admin/changeleader")
	public String showAdminChangeLeaderForm(@RequestParam("clubId") int clubId,
	                                        HttpSession session, Model model) {

	    Member loginMember = (Member) session.getAttribute("loginMember");

	    if (loginMember == null) return "redirect:/login";

	    // 관리자 권한 확인
	    if (!"ADMIN".equals(loginMember.getmRole())) {
	        return "redirect:/?msg=noAdmin";
	    }
	    //현재 그룹의 리더 Id 조회
	    String currentLeaderId = cmService.findLeaderIdByClubId(clubId);
	    
	    //cm_status 승인인 그룹회원 전체 조회
	    List<ClubMember> approvedMembers = cmService.findApprovedMembers(clubId);

	    model.addAttribute("clubId", clubId);
	    model.addAttribute("currentLeaderId", currentLeaderId); 
	    model.addAttribute("clubmembers", approvedMembers);

	    return "AdminChangeLeaderForm";
	}
	
	@PostMapping("/admin/changeleader")
	public String adminChangeLeader(@RequestParam("clubId") int clubId,
	                                @RequestParam("newLeaderId") String newLeaderId,
	                                HttpSession session) {

	    Member loginMember = (Member) session.getAttribute("loginMember");
	    if (loginMember == null) return "redirect:/login";

	    // 관리자 체크
	    if (!"ADMIN".equals(loginMember.getmRole())) {
	        return "redirect:/?msg=noAdmin";
	    }

	    boolean success = cmService.adminChangeLeader(clubId, newLeaderId);

	    return "redirect:/club/readone?clubId=" + clubId + "&msg=adminLeaderChanged";
	}
	
	
	
	
	//delete
	//강제탈퇴
	@PostMapping("/remove")
	public String remove(@RequestParam("memberId") String memberId, @RequestParam("clubId") int clubId) {
		cmService.deleteMember(memberId, clubId);
		return "redirect:/clubmember/manage?clubId="+clubId;
	}
	
	//회원 자진 탈퇴
	@GetMapping("/leaveClub")
	public String leaveClub(@RequestParam("clubId")int clubId, HttpSession session) {
		Member member = (Member) session.getAttribute("loginMember");
		if (member == null) return "redirect:/login";
		
		cmService.deleteMember(member.getmId(), clubId);
		
		return "redirect:/club/home?clubId=" + clubId + "&msg=leaveSuccess";
	}
	
}
