package com.springmvc.repository;

import java.util.List;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubMember;

public interface ClubMemberRepository {
	public void insertClubMember(ClubMember clubMember);
	List<Club> findClubInfobyMId(String loginId);
	void applyJoin(int clubId, String memberId);
	void insertLeaderAsMember(int clubId, String memberId);
	ClubMember getClubMember(String memberId, int clubId);
	List<ClubMember> getMembersByStatus(int clubId, String status);
	List<Integer> getClubIdsByMembersStatus(String memberId, String status);
	void updateStatus(String memberId, int clubId, String status);
	String deleteMember(String memberId, int clubId);
	List<Integer> findClubIdsByMemberId(String mId);
	// cm_role = role 파라미터인 club id들을 조회
	List<Integer> findClubIdsByIdRole(String loginId, String role);	
	void deleteByMember(String mId);
	List<Club> findLeaderClubsByMemberId(String mId);
	boolean loginMemberEqClubLeader(int clubId, String memberId);
	List<ClubMember> getApprovedMemberExceptLeader(int clubId, String leaderId);
	boolean isApprovedMember(int clubId, String newLeaderId);
	int updateRole(int clubId, String memberId, String role);
	int updateRoleAdmin(int clubId, String memberId, String role);
	List<ClubMember> findApprovedMembers(int clubId);
	ClubMember findLeaderByClubId(int clubId);
	List<ClubMember> isLoginMemberJoinThisClub(int clubId, String loginId);
	void deleteMembersByClubId(int clubId);
	String getMemberStatus(int clubId, String memberId);
}
