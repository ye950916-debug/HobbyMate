package com.springmvc.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.springmvc.domain.Club;
import com.springmvc.domain.ClubMember;
import com.springmvc.repository.ClubMemberRepository;
import com.springmvc.repository.ClubRepository;

@Service
public class ClubMemberServiceImpl implements ClubMemberService {
	
	@Autowired
	private ClubMemberRepository cmRepository;
	
	@Autowired
	private ClubRepository clubRepository;
	
	@Override
	public void insertClubMember(ClubMember clubMember) {
		cmRepository.insertClubMember(clubMember);
	}
	
	@Override
	public List<Club> findClubInfobyMId(String loginId) {
		return cmRepository.findClubInfobyMId(loginId);
	}
	
	// 모임 개설 시 당사자를 멤버로 삽입
	@Override
	@Transactional
	public void insertLeaderAsMember(int clubId, String MemberId) {
		cmRepository.insertLeaderAsMember(clubId, MemberId);
		// club테이블 c_member_count 증가
		clubRepository.updateClubMemberCount(clubId, 1);
	}
	
	@Override
	public void applyJoin(int clubId, String memberId) {
		cmRepository.applyJoin(clubId, memberId);	
	}
	
	@Override
	public ClubMember getClubMember(String memberId, int clubId) {
		return cmRepository.getClubMember(memberId, clubId);
	}
	
	@Override
	public List<ClubMember> getMembersByStatus(int clubId, String status) {
		return cmRepository.getMembersByStatus(clubId, status);
	}
	
	@Override
	public List<Integer> getClubIdsByMembersStatus(String memberId, String status) {
		return cmRepository.getClubIdsByMembersStatus(memberId, status);
	}
	
	@Override
	@Transactional
	public void updateStatus(String memberId, int clubId, String status) {
		// 변경 전 회원의 status 조회
		ClubMember currentCm = cmRepository.getClubMember(memberId, clubId);
		String oldStatus;
		if(currentCm != null) {
			oldStatus = currentCm.getCmStatus();
		} else {
			oldStatus = null;
		}
		
		// DB 상태 변경 쿼리 실행
		cmRepository.updateStatus(memberId, clubId, status);
		
		// 회원 승인시 Club의 member count +1
		if("A".equals(status) && "W".equals(oldStatus)) {
			clubRepository.updateClubMemberCount(clubId, 1);
		}
		// 승인상태인 회원을 승인거절로 변경하는 경우 -1
		else if("R".equals(status) && "A".equals(oldStatus)) {
			clubRepository.updateClubMemberCount(clubId, -1);
		}
		
	}
	
	@Override
	@Transactional
	public String deleteMember(String memberId, int clubId) {
		
		// CLUBMEMBER table에서 해당 회원을 삭제 및 삭제 전의 회원상태 반환
		String statusBeforeDelete = cmRepository.deleteMember(memberId, clubId);
		
		// 삭제된 회원의 기존 상태가 'A'인 경우 member count 감소
		if("A".equals(statusBeforeDelete)) {
			clubRepository.updateClubMemberCount(clubId, -1);
		}
		
		return statusBeforeDelete;
	}
	
	@Override
	public boolean loginMemberEqClubLeader(int clubId, String memberId) {
		return cmRepository.loginMemberEqClubLeader(clubId, memberId);
	}
	
	@Override
	public List<ClubMember> getApprovedMemberExceptLeader(int clubId, String leaderId) {
		return cmRepository.getApprovedMemberExceptLeader(clubId, leaderId);
	}
	
	//그룹장이 권한 양도
		@Override
		@Transactional
		public boolean changeLeaderRole(int clubId, String currentLeaderId, String newLeaderId) {
			
			// 요청회원 = 현재리더 일치 검토
			boolean isLeader = loginMemberEqClubLeader(clubId, currentLeaderId);
			
			if(!isLeader) {
				return false;
			}
			
			//새 리더 후보 승인회원여부
			boolean isApproved = isApprovedMember(clubId, newLeaderId);
			if(!isApproved) {
				return false;
			}
			
			int row1 = cmRepository.updateRole(clubId, currentLeaderId, "MEMBER");
			
			int row2 = cmRepository.updateRole(clubId, newLeaderId, "LEADER");
			
			return (row1 > 0 && row2 >0);
		}
		
		//admin이 그룹장 변경
		@Override
		@Transactional
		public boolean adminChangeLeader(int clubId, String newLeaderId) {
			
			// 기존 리더 찾기
			ClubMember oldLeader = cmRepository.findLeaderByClubId(clubId);
			
			if (oldLeader != null) {
				// 기존 리더 MEMBER로 변경
				cmRepository.updateRole(clubId, oldLeader.getCmMId(), "MEMBER");
			}
			
			// 새 리더 LEADER로 변경
			int updated = cmRepository.updateRoleAdmin(clubId, newLeaderId, "LEADER");
			
			return updated > 0;
		}
		
		public boolean isApprovedMember(int clubId, String newLeaderId) {
			return cmRepository.isApprovedMember(clubId, newLeaderId);
		}
	
	@Override
	public List<Integer> findClubIdsByMemberId(String mId) {
	    return cmRepository.findClubIdsByMemberId(mId);
	}
	
	@Override
	public List<Integer> findClubIdsByLeaderIdRole(String loginId) {
		return cmRepository.findClubIdsByIdRole(loginId, "LEADER");
	}
	
	@Override
	public List<Integer> findClubIdsByMemberIdRole(String loginId) {
		return cmRepository.findClubIdsByIdRole(loginId, "MEMBER");
	}
	
	@Override
    public void deleteByMember(String mId) {
        cmRepository.deleteByMember(mId);
    }

	@Override
	public List<Club> findLeaderClubsByMemberId(String mId) {
		return cmRepository.findLeaderClubsByMemberId(mId);
	}
	
	@Override
	public List<ClubMember> findApprovedMembers(int clubId) {
		return cmRepository.findApprovedMembers(clubId);
	}
	
	
	@Override
	public String findLeaderIdByClubId(int clubId) {
		
		ClubMember leader = cmRepository.findLeaderByClubId(clubId);
		
		if (leader == null) {
	        return null;
	    } else {
	        return leader.getCmMId();
	    }
	}
	
    @Override
    public String getMemberStatus(int clubId, String memberId) {
            return cmRepository.getMemberStatus(clubId, memberId);
    }
	
}
