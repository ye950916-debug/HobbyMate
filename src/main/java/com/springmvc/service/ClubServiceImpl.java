package com.springmvc.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubCategory;
import com.springmvc.domain.ClubDetail;
import com.springmvc.domain.Member;
import com.springmvc.repository.ClubCategoryRepository;
import com.springmvc.repository.ClubMemberRepository;
import com.springmvc.repository.ClubRepository;
import com.springmvc.repository.MemberCategoryRepository;
import com.springmvc.repository.MemberRepository;
import com.springmvc.repository.PostRepository;
import com.springmvc.repository.ScheduleRepository;

@Service
public class ClubServiceImpl implements ClubService {
	
	@Autowired
	private ClubRepository clubRepository;
	
	@Autowired
	private ClubCategoryRepository clubCategoryRepository;
	
	@Autowired
	private ClubMemberRepository clubMemberRepository;
	
	@Autowired
	private MemberCategoryRepository memberCategoryRepository;
	
	@Autowired
	private MemberRepository memberRepository;
	
	@Autowired
	private ScheduleRepository scheduleRepository;
	
	@Autowired
	private PostRepository postRepository;
	
	@Override
	public boolean existsClubName(String clubName) {
		return clubRepository.existsClubName(clubName);
	}
	
	@Override
	public List<Club> findClubsByLeaderId(String leaderId) {
		List<Integer> clubIds = clubMemberRepository.findClubIdsByIdRole(leaderId, "LEADER");
		List<Club> clubs = clubRepository.findClubsByIds(clubIds);
		
		return clubs;
	}
	
	@Override
	public List<Club> findClubsByMemberId(String memberId) {
		List<Integer> clubIds = clubMemberRepository.findClubIdsByIdRole(memberId, "MEMBER");
		List<Club> clubs = clubRepository.findClubsByIds(clubIds);
		
		return clubs;
	}
	
	@Override
	public Club findClubByClubId(int clubId) {
		return clubRepository.findClubByClubId(clubId);
	}
	
	@Override
	@Transactional
	public void updateClub(Club club, List<Integer> categoryIds) {
		clubRepository.updateClub(club);
		
		clubCategoryRepository.deleteByClubId(club.getcId());
		
		for(int i=0; i<categoryIds.size(); i++) {
			int ctId = categoryIds.get(i);
			clubCategoryRepository.insertClubCategory(club.getcId(), ctId);
		}
	}
	
	@Override
	@Transactional
	public void deleteClub(int clubId) {
		
		List<Integer> eventNos = scheduleRepository.findEventNosByClubId(clubId);
		
		postRepository.deletePostByClubId(clubId);
		for(int i=0; i<eventNos.size(); i++) {
			int eventNo = eventNos.get(i);
			scheduleRepository.deleteMemberScheduleByEventNo(eventNo);
		}
		scheduleRepository.deleteSchedulesByClubId(clubId);
		clubMemberRepository.deleteMembersByClubId(clubId);
		clubCategoryRepository.deleteClubCategory(clubId);
		clubRepository.deleteClub(clubId);
	}
	
	@Override
	public List<ClubDetail> getAllClubDetails() {
		return clubRepository.getAllClubDetails();
	}
	
	@Override
	public Club findClubByLeaderId(String clubLeaderId) {
		return clubRepository.findClubByLeaderId(clubLeaderId);
	}
	
	@Override
	@Transactional
	public void createClub(Club club, String categoryIds) {
		//club만들기
		clubRepository.insertClub(club);
		
		// clubId 가져오기
		int newClubId = clubRepository.getLastInsertId();
		
		//categoryIds 처리
		List<Integer> ctIdList = Arrays.stream(categoryIds.split(","))
				.map(Integer::parseInt)
				.collect(Collectors.toList());
		
		//club category insert
		for(Integer ctId : ctIdList) {
			ClubCategory cc = new ClubCategory();
			cc.setcId(newClubId);
			cc.setCtId(ctId);
			clubCategoryRepository.insertClubCategory(cc);
		}
		
		//clubmember에 모임장 정보 저장
		clubMemberRepository.insertLeaderAsMember(newClubId, club.getcFounderId());
		//club 테이블 c_member_count +1
		clubRepository.updateClubMemberCount(newClubId, 1);
	}
	
	

	@Override
	public List<Integer> findLeaderClubIdsByMemberId(String mId) {
		return clubRepository.findLeaderClubIdsByMemberId(mId);
	}

	@Override
	public String findClubNameById(String cId) {
		return clubRepository.findClubNameById(cId);
	}
	
	@Override
	public List<Club> findClubsByClubIds(List<Integer> clubIds) {
		return clubRepository.findClubsByClubIds(clubIds);
	}
	
	@Override
	@Transactional
	public List<ClubDetail> getRecommendedClubs(String memberId) {
		// 회원의 관심 카테고리 ID 목록 조회
		List<Integer> memberCategoryIds = memberCategoryRepository.getMemberCategoryIds(memberId);
		
		// 관심사 없으면 빈 목록 반환
		if (memberCategoryIds.isEmpty()) {
            // 관심사가 없으면 빈 목록 반환
			return Collections.emptyList();
        }
		
		Member member = memberRepository.getMemberById(memberId);
		
		// 지역 정보 누락 체크
        if (member == null || member.getmSiDo() == null || member.getmGuGun() == null) {
            System.err.println("ERROR: 회원 ID(" + memberId + ")의 지역 정보가 누락되어 추천 클럽을 찾을 수 없습니다.");
            return Collections.emptyList();
        }
        
        String memberSido = member.getmSiDo();
        String memberGugun = member.getmGuGun();
		
        List<ClubDetail> recommendedClubs = clubRepository.getClubsByCategoriesAndLocation(memberCategoryIds, memberSido, memberGugun);
        
		
		return recommendedClubs;
	}
	
	@Override
	public List<ClubDetail> getClubsByLocation(String memberSido, String memberGugun) {
		return clubRepository.getClubsByLocation(memberSido, memberGugun);
	}
	
	@Override
	public List<ClubDetail> getClubsBySearch(String searchType, String searchKeyword) {
		return clubRepository.getClubsBySearch(searchType, searchKeyword);
	}

	@Override
	public List<ClubDetail> getFilteredClubs(String sidoCode, String gugunCode, String searchType, String searchKeyword,
			String largeCode, String midCode, String subCode) {
		// DAO로 전달할 필터 조건 Map 생성
        Map<String, Object> filters = new HashMap<>();
        
        // 지역 필터
        if (sidoCode != null && !sidoCode.isEmpty()) {
            filters.put("sidoCode", sidoCode);
        }
        if (gugunCode != null && !gugunCode.isEmpty()) {
            filters.put("gugunCode", gugunCode);
        }

        // 검색어 필터
        if (searchKeyword != null && !searchKeyword.isEmpty()) {
            filters.put("searchType", searchType);
            filters.put("searchKeyword", searchKeyword);
        }

        // 카테고리 필터 (현재는 JS에서 호출이 없어도 Map에 담아두면 DAO에서 동적 처리 가능)
        if (largeCode != null && !largeCode.isEmpty()) {
            filters.put("largeCode", largeCode);
        }
        if (midCode != null && !midCode.isEmpty()) {
            filters.put("midCode", midCode);
        }
        if (subCode != null && !subCode.isEmpty()) {
            filters.put("subCode", subCode);
        }

        // DAO를 호출하여 동적 쿼리를 실행합니다.
        return clubRepository.selectFilteredClubs(filters);
	}
	
	@Override
	public List<ClubDetail> getRandomClubs(int limit) {
		// 1. 전체 모임 목록 조회
	    List<ClubDetail> allClubs = clubRepository.getAllClubDetails();

	    // 2. 결과를 담을 리스트
	    List<ClubDetail> result = new ArrayList<>();

	    // 3. 랜덤 섞기
	    Collections.shuffle(allClubs);

	    // 4. limit 개수만큼 담기
	    for (int i = 0; i < allClubs.size(); i++) {
	        result.add(allClubs.get(i));

	        if (result.size() == limit) {
	            break;
	        }
	    }

	    return result;
	}
}
