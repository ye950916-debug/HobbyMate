package com.springmvc.service;

import java.util.List;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubDetail;

public interface ClubService {
	void createClub(Club club, String categoryIds);
	
	Club findClubByLeaderId(String clubLeaderId);
	// id의 모임 내 역할이 leader인 club객체들 찾기
	List<Club> findClubsByLeaderId(String leaderId);
	// id의 모임 내 역할이 member인 club객체들 찾기
	List<Club> findClubsByMemberId(String memberId);
	Club findClubByClubId(int clubId);
	void updateClub(Club club, List<Integer> categoryIds);
	void deleteClub(int clubId);
	List<ClubDetail> getAllClubDetails();
	boolean existsClubName(String clubName);
	List<Integer> findLeaderClubIdsByMemberId(String mId);
	String findClubNameById(String cId);
	List<Club> findClubsByClubIds(List<Integer> clubIds);
	List<ClubDetail> getRecommendedClubs(String memberId);
	List<ClubDetail> getClubsByLocation(String memberSido, String memberGugun);
	//검색 조건에 맞는 클럽 조회
	List<ClubDetail> getClubsBySearch(String searchType, String searchKeyword);
	List<ClubDetail> getFilteredClubs(
			String sidoCode, 
            String gugunCode, 
            String searchType, 
            String searchKeyword,
            String largeCode, 
            String midCode, 
            String subCode
    );
	List<ClubDetail> getRandomClubs(int limit);
}
