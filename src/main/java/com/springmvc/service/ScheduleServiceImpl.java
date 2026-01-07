package com.springmvc.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.springmvc.domain.Member;
import com.springmvc.domain.Schedule;
import com.springmvc.repository.ScheduleRepository;

@Service
public class ScheduleServiceImpl implements ScheduleService{

	@Autowired
	private ScheduleRepository scheduleRepository;

	@Override
	public List<Schedule> getSchedulesByClubIds(List<Integer> clubIds){
		return scheduleRepository.getSchedulesByClubIds(clubIds);
	}

	//일정 조회
	@Override
	public List<Schedule> getSchedulesByClubId(String cId) {
		
		return scheduleRepository.getSchedulesByClubId(cId);
	}

	//일정 추가
	@Override
	public void addSchedule(Schedule schedule) {
		scheduleRepository.addSchedule(schedule);
		
	    int eventNo = scheduleRepository.findLastEventNoByClubAndMember(
	            schedule.getcId(),
	            schedule.getRegisterId()
	    );
	    
	    this.memberSchedule(
	            schedule.getRegisterId(),
	            eventNo
	    );
	}

	//일정 수정 = 수정할 일정 고유번호 조회
	@Override
	public Schedule getScheduleByNum(int eventNo) {
		return scheduleRepository.getScheduleByNum(eventNo);
	}

	//일정 수정 = 업데이트 DB반영
	@Override
	public void updateSchedule(Schedule schedule) {
		scheduleRepository.updateSchedule(schedule);
	}

	//일정 삭제
	@Override
	public void deleteSchedule(int eventNo) {
		 // 1. 나의 일정에서 먼저 제거
	    scheduleRepository.deleteMemberSchedule(eventNo);

	    // 2. 원래 일정 삭제
	    scheduleRepository.deleteSchedule(eventNo);
		
	}

	@Override
	public int getCurrentParticipantCount(int eventNo) {
		return scheduleRepository.getCurrentParticipantCount(eventNo);
	}

	@Override
	public int getPeopleLimit(int eventNo) {
		return scheduleRepository.getPeopleLimit(eventNo);
	}

	@Override
	public List<Schedule> memberScheduleList(String mId) {
		return scheduleRepository.memberScheduleList(mId);
	}

	@Override
	public void memberSchedule(String mId, int eventNo) {
		
		//중복 방지
		if (scheduleRepository.existsMemberSchedule(mId, eventNo)) {
	        throw new IllegalStateException("이미 내 일정에 추가된 일정입니다.");
	    }
		
		//현재 참여 인원
		int currentCount = scheduleRepository.getCurrentParticipantCount(eventNo);
		
		//제한 인원
		int limit = scheduleRepository.getPeopleLimit(eventNo);

		
		//초과하면 저장 안됨
		if (currentCount >= limit) {
			throw new IllegalStateException("정원이 초과된 일정입니다.");
		}
		
		//정상 추가
		scheduleRepository.memberSchedule(mId, eventNo);
		
	}
	
	@Override
	public List<Integer> getMemberEventNos(String mId) {
	    return scheduleRepository.getMemberEventNos(mId);
	}
	
	@Override
	public void deleteOnlyMemberSchedule(String mId, int eventNo) {
	    scheduleRepository.deleteOnlyMemberSchedule(mId, eventNo);
	}

	@Override
	public List<Member> getParticipants(int eventNo) {
		return scheduleRepository.getParticipants(eventNo);
	}
	
	@Override
	public void deleteMemberScheduleByMember(String mId) {
	    scheduleRepository.deleteMemberScheduleByMember(mId);
	}

	@Override
	public void nullifyRegisterId(String mId) {
		scheduleRepository.nullifyRegisterId(mId);
		
	}

	@Override
	public List<Schedule> getAllSchedules() {
		return scheduleRepository.getAllSchedules();
	}

	@Override
	public void deleteMemberScheduleByEventNo(int eventNo) {
		scheduleRepository.deleteMemberScheduleByEventNo(eventNo);
	}

	@Override
	public void updateScheduleStatus(int eventNo, String status) {
		scheduleRepository.updateScheduleStatus(eventNo, status);
	}
	
	@Override
	public List<Schedule> getSchedulesByClubId(int clubId) {
		return scheduleRepository.getSchedulesByClubId(clubId);
	}

	@Override
	public List<Schedule> getSchedulesByClubIdsAndSearch(List<Integer> clubIds, String searchKeyword) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("clubIds", clubIds);
		paramMap.put("searchKeyword", searchKeyword);
	    
		return scheduleRepository.selectSchedulesByClubIdsAndSearch(paramMap);
	}

	@Override
	public List<Schedule> getAllSchedulesAndSearch(String searchKeyword) {
		Map<String, Object> paramMap = new HashMap<>();
		paramMap.put("searchKeyword", searchKeyword);
		
		return scheduleRepository.selectAllSchedulesAndSearch(paramMap);
	}
	
	@Override
	public Schedule getScheduleForHobbyLog(int eventNo) {
		return scheduleRepository.getScheduleForHobbyLog(eventNo);
	}

}
