package com.springmvc.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springmvc.domain.Member;
import com.springmvc.service.MemberService;

@Controller
public class LoginController {
	
	@Autowired
	private MemberService memberService;
	
	//로그인 폼
	@GetMapping("/login")
	public String loginForm() {
		System.out.println("로그인 폼 표시");
		return "login";
	}
	
	//로그인 처리
	@PostMapping("/login")
	public String login(@RequestParam("mId") String mId, @RequestParam("mPw") String mPw, HttpSession session, Model model) {
		System.out.println("로그인 시도: " + mId);
		
		Member member = memberService.getMemberById(mId);
		
		if (member == null) {
			model.addAttribute("error", "존재하지 않는 회원입니다.");
			return "login";
		}
		
		if ("SUSPENDED".equals(member.getmStatus())) {
			model.addAttribute("error", "해당 계정은 현재 활동이 중지되었습니다.");
			return "login";
		}
		
		if ("DELETED".equals(member.getmStatus())) {
			model.addAttribute("error", "이미 탈퇴 처리된 계정입니다.");
			return "login";
		}
		
		if (!member.getmPw().equals(mPw)) {
			model.addAttribute("error", "비밀번호가 일치하지 않습니다.");
			return "login";
		}
		
		session.setAttribute("loginMember", member);
		System.out.println("로그인 성공: " + member);
		
		return "redirect:/";
	}
	
	//로그아웃
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		System.out.println("로그아웃 완료");
		
		return "redirect:/";
	}

}
