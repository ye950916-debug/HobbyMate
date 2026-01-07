package com.springmvc.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.springmvc.domain.ClubDetail;
import com.springmvc.domain.Member;
import com.springmvc.service.ClubService;

@Controller

public class WelcomeController {
	
	@Autowired
	private ClubService clubService;
	
	//홈 화면
	@RequestMapping("/")
	public String home(Model model, HttpSession session) {
		
	
		String title="취미로 만나는 세상, HobbyMate!";
		String intro="관심사 기반 취미 모임을 추천받고, 함께 활동을 즐겨보세요 😻";
		
		model.addAttribute("title", title);
		model.addAttribute("intro", intro);
		
		Member loginMember = (Member) session.getAttribute("loginMember");
		
	    List<ClubDetail> randomClubs = clubService.getRandomClubs(3);
	    model.addAttribute("recommendedClubs", randomClubs);
		
	        
		return "home";
	}
	
	
	
}
