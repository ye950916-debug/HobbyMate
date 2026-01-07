package com.springmvc.repository;

import java.util.List;
import java.util.Map;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubDetail;

public interface ClubRepository {
	void insertClub(Club club);
	public Club findClubByLeaderId(String clubLeaderId);
	public List<Club> findClubsByIds(List<Integer> leaderId);
	public Club findClubByClubId(int clubId);
	public void updateClub(Club club);
	public void deleteClub(int clubId);
	public List<ClubDetail> getAllClubDetails();
	public boolean existsClubName(String clubName);
	int getLastInsertId();
	public List<Integer> findLeaderClubIdsByMemberId(String mId);
	public String findClubNameById(String cId);
	void updateClubMemberCount(int clubId, int count);
	List<ClubDetail> getClubsByCategoriesAndLocation(List<Integer> categoryIds, String sido, String gugun);
	List<ClubDetail> getClubsByLocation(String memberSido, String memberGugun);
	List<Club> findClubsByClubIds(List<Integer> clubIds);
	List<ClubDetail> getClubsBySearch(String searchType, String searchKeyword);
	List<ClubDetail> selectFilteredClubs(Map<String, Object> filters);
}
