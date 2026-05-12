package com.helpdesk.admin.stats.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface StatsMapper {

    // 사용자 접속 로그
    List<Map<String, Object>> selectUserAccessLogList(Map<String, Object> param);
    int selectUserAccessLogListCount(Map<String, Object> param);
    int insertUserAccessLog(Map<String, Object> param);

    // 관리자 접속 로그
    List<Map<String, Object>> selectAdminAccessLogList(Map<String, Object> param);
    int selectAdminAccessLogListCount(Map<String, Object> param);
    int insertAdminAccessLog(Map<String, Object> param);

    // 메뉴 통계
    List<Map<String, Object>> selectMenuStatsList(Map<String, Object> param);
    int insertMenuStats(Map<String, Object> param);

    // 방문 통계
    List<Map<String, Object>> selectVisitStatsList(Map<String, Object> param);
    int insertVisitStats(Map<String, Object> param);

    // 게시물 상태별 통계
    Map<String, Object> selectPostStatusStats(Map<String, Object> param);

    // 일별 통계
    List<Map<String, Object>> selectDailyStats(Map<String, Object> param);

    // 접속 통계
    Map<String, Object> selectAccessStatsSummary(Map<String, Object> param);
    List<Map<String, Object>> selectDailyAccessStats(Map<String, Object> param);
    List<Map<String, Object>> selectPageAccessStats(Map<String, Object> param);
    List<Map<String, Object>> selectBrowserStats(Map<String, Object> param);
    List<Map<String, Object>> selectOsStats(Map<String, Object> param);
}
