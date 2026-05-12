package com.helpdesk.admin.board.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface BoardMapper {

    List<Map<String, Object>> selectBoardList(Map<String, Object> param);
    int selectBoardListCount(Map<String, Object> param);
    Map<String, Object> selectBoardInfo(Map<String, Object> param);
    Map<String, Object> selectBoardRoleCfg(Map<String, Object> param);
    List<Map<String, Object>> selectBoardFieldList(Map<String, Object> param);

    int insertBoardInfo(Map<String, Object> param);
    int insertBoardRoleCfg(Map<String, Object> param);
    int insertBoardFieldInfo(Map<String, Object> param);

    int updateBoardInfo(Map<String, Object> param);
    int updateBoardRoleCfg(Map<String, Object> param);
    int updateBoardFieldInfo(Map<String, Object> param);

    int deleteBoardInfo(Map<String, Object> param);
    int deleteBoardFieldInfo(Map<String, Object> param);
    int deleteBoardFieldBasicList(Map<String, Object> param);
    
    List<Map<String, Object>> selectSystemList();
}
