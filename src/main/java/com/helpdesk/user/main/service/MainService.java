package com.helpdesk.user.main.service;

import com.helpdesk.user.main.mapper.MainMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MainService {

    @Autowired
    private MainMapper mainMapper;

    /**
     * 나의 요청 현황 조회
     */
    public Map<String, Object> getMyStats(String userId) {
        return mainMapper.selectMyStats(userId);
    }

    /**
     * 전체 현황 조회
     */
    public Map<String, Object> getTotalStats() {
        return mainMapper.selectTotalStats();
    }

    /**
     * 공지사항 목록 조회 (최근 5건)
     */
    public List<Map<String, Object>> getNoticeList() {
        return mainMapper.selectNoticeList();
    }

    /**
     * 사용 중인 게시판 목록 조회
     */
    public List<Map<String, Object>> getBoardList() {
        return mainMapper.selectBoardList();
    }
}
