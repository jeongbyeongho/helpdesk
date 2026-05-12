package com.helpdesk.admin.main.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AdminMainMapper {

    /**
     * 전체 사용자 수 조회
     */
    @Select("SELECT COUNT(*) FROM TB_USER_INFO")
    int selectTotalUserCount();

    /**
     * 전체 게시물 수 조회
     */
    @Select("SELECT COUNT(*) FROM TB_POST_INFO WHERE post_use_yn = 'Y'")
    int selectTotalPostCount();

    /**
     * 상태별 게시물 수 조회
     * W:대기, R:접수, C:완료, H:보류
     */
    @Select("SELECT COUNT(*) FROM TB_POST_INFO WHERE post_use_yn = 'Y' AND post_status = #{status}")
    int selectPostCountByStatus(@Param("status") String status);

    /**
     * 오늘 등록된 게시물 수 조회
     */
    @Select("SELECT COUNT(*) FROM TB_POST_INFO WHERE post_use_yn = 'Y' AND CAST(reg_dt AS DATE) = CAST(GETDATE() AS DATE)")
    int selectTodayPostCount();
}
