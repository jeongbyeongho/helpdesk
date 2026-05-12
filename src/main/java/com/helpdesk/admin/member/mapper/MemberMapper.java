package com.helpdesk.admin.member.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface MemberMapper {

    List<Map<String, Object>> selectMemberList(Map<String, Object> param);
    int selectMemberListCount(Map<String, Object> param);
    Map<String, Object> selectMemberInfo(Map<String, Object> param);
    int insertMemberInfo(Map<String, Object> param);
    int insertMemberTypeInfo(Map<String, Object> param);
    int updateMemberInfo(Map<String, Object> param);
    int updateMemberApproval(Map<String, Object> param);
    int updateMemberPwd(Map<String, Object> param);
    int deleteMemberInfo(Map<String, Object> param);
    int deleteMemberTypeInfo(Map<String, Object> param);

    List<Map<String, Object>> selectMemberListByType(Map<String, Object> param);
    List<Map<String, Object>> selectDeptList(Map<String, Object> param);
}
