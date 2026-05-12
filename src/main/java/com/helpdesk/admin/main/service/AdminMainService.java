package com.helpdesk.admin.main.service;

import com.helpdesk.admin.main.mapper.AdminMainMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class AdminMainService {

    @Autowired
    private AdminMainMapper adminMainMapper;

    /**
     * 관리자 대시보드 통계 조회
     */
    public Map<String, Object> getDashboardStats() {
        Map<String, Object> stats = new HashMap<>();
        
        // 전체 사용자 수
        stats.put("totalUsers", adminMainMapper.selectTotalUserCount());
        
        // 전체 문의 수
        stats.put("totalPosts", adminMainMapper.selectTotalPostCount());
        
        // 대기중 문의 (W:대기)
        stats.put("waitingPosts", adminMainMapper.selectPostCountByStatus("W"));
        
        // 처리중 문의 (R:접수)
        stats.put("processingPosts", adminMainMapper.selectPostCountByStatus("R"));
        
        // 완료 문의 (C:완료)
        stats.put("completedPosts", adminMainMapper.selectPostCountByStatus("C"));
        
        // 오늘 문의
        stats.put("todayPosts", adminMainMapper.selectTodayPostCount());
        
        return stats;
    }
}
