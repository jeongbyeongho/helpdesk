package com.helpdesk.admin.stats.service;

import com.helpdesk.admin.stats.mapper.StatsMapper;
import com.helpdesk.common.util.PagingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class StatsService {

    @Autowired
    private StatsMapper statsMapper;

    /** 사용자 접속 로그 목록 */
    public Map<String, Object> getUserAccessLogPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = statsMapper.selectUserAccessLogList(param);
        int totalCount = statsMapper.selectUserAccessLogListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("logList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    /** 관리자 접속 로그 목록 */
    public Map<String, Object> getAdminAccessLogPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = statsMapper.selectAdminAccessLogList(param);
        int totalCount = statsMapper.selectAdminAccessLogListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("logList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    /** 게시물 상태별 통계 */
    public Map<String, Object> getPostStatusStats(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return statsMapper.selectPostStatusStats(param);
    }

    /** 일별 통계 */
    public List<Map<String, Object>> getDailyStats(Map<String, Object> param) {
        return statsMapper.selectDailyStats(param);
    }

    /** 방문 통계 */
    public List<Map<String, Object>> getVisitStats(Map<String, Object> param) {
        return statsMapper.selectVisitStatsList(param);
    }

    /** 메뉴 통계 */
    public List<Map<String, Object>> getMenuStats(Map<String, Object> param) {
        return statsMapper.selectMenuStatsList(param);
    }

    /** 접속 통계 요약 */
    public Map<String, Object> getAccessStatsSummary(Map<String, Object> param) {
        return statsMapper.selectAccessStatsSummary(param);
    }

    /** 일별 접속 통계 */
    public List<Map<String, Object>> getDailyAccessStats(Map<String, Object> param) {
        return statsMapper.selectDailyAccessStats(param);
    }

    /** 페이지별 접속 통계 */
    public List<Map<String, Object>> getPageAccessStats(Map<String, Object> param) {
        return statsMapper.selectPageAccessStats(param);
    }

    /** 브라우저별 통계 */
    public List<Map<String, Object>> getBrowserStats(Map<String, Object> param) {
        return statsMapper.selectBrowserStats(param);
    }

    /** OS별 통계 */
    public List<Map<String, Object>> getOsStats(Map<String, Object> param) {
        return statsMapper.selectOsStats(param);
    }

    /** 접속 로그 기록 */
    @Transactional
    public void logUserAccess(Map<String, Object> param) {
        statsMapper.insertUserAccessLog(param);
    }

    @Transactional
    public void logAdminAccess(Map<String, Object> param) {
        statsMapper.insertAdminAccessLog(param);
    }

    @Transactional
    public void logMenuStats(Map<String, Object> param) {
        statsMapper.insertMenuStats(param);
    }

    @Transactional
    public void logVisitStats(Map<String, Object> param) {
        statsMapper.insertVisitStats(param);
    }
}
