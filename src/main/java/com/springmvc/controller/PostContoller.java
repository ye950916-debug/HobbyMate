package com.springmvc.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.springmvc.domain.Member;
import com.springmvc.domain.Post;
import com.springmvc.service.PostService;

@Controller
@RequestMapping("/post")
public class PostContoller {
	
	@Autowired
	private PostService postService;
	
	
	// create
	// CreateHome.jsp - '글 작성하기'
	@GetMapping("/write/{cId}")
    public String showWriteForm(@PathVariable("cId") int cId, HttpSession session, Model model) {
		
		// 로그인 여부 확인
		Member member = (Member) session.getAttribute("loginMember");
		if(member == null) {
			return "redirect:/login";
		}
        
        // 어떤 모임에 글을 작성하는지 알기 위해 clubId를 모델에 담아 폼으로 전달
        model.addAttribute("clubId", cId);
        
        return "PostWriteForm"; 
    }
	
	@PostMapping("/write")
    public String saveWriteForm(Post post, HttpSession session) {
        
        // 1. 로그인 여부 확인
        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/login"; 
        }

        // 2. DTO에 작성자 ID 설정 (폼에서 누락될 경우를 대비해 Controller에서 재확인)
        post.setPostMId(loginMember.getmId());
        
        // 3. 게시글 타입 명확히 지정
        post.setPostType("NORMAL");
        
        // 4. Service 호출: DB에 Post 객체 저장
        postService.savePost(post, loginMember.getmId()); 
        
        // 5. 저장 후 해당 모임의 홈(게시판 목록)으로 리다이렉트
        return "redirect:/club/home?clubId=" + post.getPostCId();
    }
	
	
	//-------------------------------------------------------
	// 게시글 상세조회
	@GetMapping("/detail/{pId}")
	public String getPostDetail(@PathVariable("pId") long postId, HttpSession session, Model model) {
		
		// 1. 로그인 여부 확인
        Member loginMember = (Member) session.getAttribute("loginMember");
        if (loginMember == null) {
            return "redirect:/login"; 
        }
        
        String memberId = loginMember.getmId();
        
        Post post = postService.getPostDetail(postId, memberId);
        
        if (post == null) {
            // 게시글을 찾을 수 없거나 또는 모임 회원이 아니어서 접근 권한이 없는 경우
            model.addAttribute("error", "게시글을 찾을 수 없거나 접근 권한이 없습니다.");
            return "error"; 
        }
        
        // 3. 뷰에 전달
        model.addAttribute("post", post);
        
        // 4. 수정/삭제 버튼 노출을 위한 작성자 여부 플래그
        model.addAttribute("isAuthor", memberId.equals(post.getPostMId()));
        
		
		return "PostDetail";
	}
	
	//-----------------------------------------------------
	// PostDetail.jsp - 수정버튼 클릭 -> 게시글 수정 폼 이동
	@GetMapping("/update/{pId}")
    public String showUpdateForm(@PathVariable("pId") long postId, Model model, HttpSession session) {
        
        Member loginMember = (Member) session.getAttribute("loginMember");
        if(loginMember == null) {
            return "redirect:/login";
        }
        
        // 게시글 상세 정보 조회 (조회수 증가 X)
        Post originalPost = postService.getPostById(postId); 
        
        // 게시글 존재 여부 및 작성자 일치 여부 확인
        if (originalPost == null || !originalPost.getPostMId().equals(loginMember.getmId())) {
            model.addAttribute("message", "수정 권한이 없거나 게시글을 찾을 수 없습니다.");
            return "error/accessDenied"; // 적절한 에러 페이지로 리다이렉트
        }
        
        model.addAttribute("post", originalPost);
        
        return "PostUpdateForm";
    }
	
	// 게시글 수정
	@PostMapping("/update")
    public String processUpdateForm(Post post, HttpSession session, Model model) {
        
        Member loginMember = (Member) session.getAttribute("loginMember");
        if(loginMember == null) {
            return "redirect:/login"; // 로그인 체크
        }

        // 1. 작성자 ID와 현재 로그인 ID 일치 여부 확인
        if (!post.getPostMId().equals(loginMember.getmId())) {
            model.addAttribute("message", "수정 권한이 없습니다.");
            return "error/accessDenied";
        }
        
        // 2. DB 업데이트
        postService.updatePost(post);
        
        // 3. 수정 완료 후 해당 게시글 상세 페이지로 리다이렉트
        return "redirect:/post/detail/" + post.getPostId();
    }
	
	
	//---------------------------------------------------------
	// 게시글 삭제
	@PostMapping("/delete")
    public String processDelete(@RequestParam("postId") long postId, HttpSession session, Model model) {
        
        Member loginMember = (Member) session.getAttribute("loginMember");
        if(loginMember == null) {
            return "redirect:/login"; 
        }
        
        String memberId = loginMember.getmId();
        
        // 1. 게시글이 존재하는지 확인
        Post postToDelete = postService.getPostById(postId);
        
        if (postToDelete == null) {
            model.addAttribute("message", "이미 삭제되었거나 존재하지 않는 게시글입니다.");
            return "error/accessDenied";
        }
        
        // 2. 로그인 사용자와 게시글 작성자가 일치하는지 확인
        if (!postToDelete.getPostMId().equals(memberId)) {
            model.addAttribute("message", "삭제 권한이 없습니다.");
            return "error/accessDenied";
        }
        
        // 삭제 성공 후 리다이렉트할 모임 ID 저장
        int clubId = postToDelete.getPostCId();
        
        // 3. 삭제 처리
        postService.deletePost(postId, memberId);
        
        // 4. 삭제 완료 후 모임 홈(게시글 목록)으로 리다이렉트
        return "redirect:/club/home?clubId=" + clubId;
    }
	
}
