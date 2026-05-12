package com.helpdesk.admin.role.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface RoleMapper {

    List<Map<String, Object>> selectRoleList(Map<String, Object> param);
    int selectRoleListCount(Map<String, Object> param);
    Map<String, Object> selectRoleInfo(Map<String, Object> param);
    int checkRoleNameDup(Map<String, Object> param);

    int insertRoleInfo(Map<String, Object> param);
    int updateRoleInfo(Map<String, Object> param);
    int deleteRoleInfo(Map<String, Object> param);

    // 사용자 권한 부여/회수
    List<Map<String, Object>> selectUserRoleList(Map<String, Object> param);
    int selectUserRoleListCount(Map<String, Object> param);
    List<Map<String, Object>> selectGrantableRoleList(Map<String, Object> param);
    List<Map<String, Object>> selectGrantableUserList(Map<String, Object> param);

    int insertUserRoleMap(Map<String, Object> param);
    int deleteUserRoleMap(Map<String, Object> param);
    int deleteUserRoleMapByRoleCode(Map<String, Object> param);
    int deleteGroupRoleMapByRoleCode(Map<String, Object> param);

    // 권한별 사용자 목록 (페이징)
    List<Map<String, Object>> selectUserListByRole(Map<String, Object> param);
    int selectUserListByRoleCount(Map<String, Object> param);

    // 역할 목록 (시스템용)
    List<Map<String, Object>> selectRoleListForSystem(Map<String, Object> param);
    List<Map<String, Object>> selectRoleListForMenu(Map<String, Object> param);
}
