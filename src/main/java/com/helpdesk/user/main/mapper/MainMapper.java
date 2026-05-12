package com.helpdesk.user.main.mapper;

import org.apache.ibatis.annotations.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface MainMapper {

    /**
     * 나의 요청 현황 조회
     */
    Map<String, Object> selectMyStats(String userId);

    /**
     * 전체 현황 조회
     */
    Map<String, Object> selectTotalStats();

    /**
     * 공지사항 목록 조회 (최근 5건)
     */
    List<Map<String, Object>> selectNoticeList();

    /**
     * 사용 중인 게시판 목록 조회
     */
    List<Map<String, Object>> selectBoardList();
}
