package com.helpdesk.admin.menu.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface MenuMapper {

    List<Map<String, Object>> selectMenuList(Map<String, Object> param);
    List<Map<String, Object>> selectMenuLevelList(Map<String, Object> param);
    Map<String, Object> selectMenuInfo(Map<String, Object> param);
    List<Map<String, Object>> selectUpperMenuList(Map<String, Object> param);
    List<Map<String, Object>> selectConnectMenuList(Map<String, Object> param);
    int selectNextSortOrder(Map<String, Object> param);

    int insertMenuInfo(Map<String, Object> param);
    int updateMenuInfo(Map<String, Object> param);
    int updateMenuSortOrder(Map<String, Object> param);
    int deleteMenuInfo(Map<String, Object> param);
    int deleteMenuByUpperId(Map<String, Object> param);
    List<String> selectChildMenuIdList(Map<String, Object> param);

    // 메뉴 권한
    List<Map<String, Object>> selectMenuRoleList(Map<String, Object> param);
    int insertMenuRole(Map<String, Object> param);
    int deleteMenuRole(Map<String, Object> param);

    // 게시판 연결 목록
    List<Map<String, Object>> selectBoardListForMenu(Map<String, Object> param);
    List<Map<String, Object>> selectBoardPathList(Map<String, Object> param);
}
