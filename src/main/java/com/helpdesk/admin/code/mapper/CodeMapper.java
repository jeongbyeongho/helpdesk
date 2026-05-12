package com.helpdesk.admin.code.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface CodeMapper {

    // 코드 그룹
    List<Map<String, Object>> selectCodeGroupList(Map<String, Object> param);
    int selectCodeGroupListCount(Map<String, Object> param);
    Map<String, Object> selectCodeGroupInfo(Map<String, Object> param);
    int insertCodeGroupInfo(Map<String, Object> param);
    int updateCodeGroupInfo(Map<String, Object> param);
    int deleteCodeGroupInfo(Map<String, Object> param);

    // 코드 상세
    List<Map<String, Object>> selectCodeDetailList(Map<String, Object> param);
    Map<String, Object> selectCodeDetailInfo(Map<String, Object> param);
    int insertCodeDetailInfo(Map<String, Object> param);
    int updateCodeDetailInfo(Map<String, Object> param);
    int deleteCodeDetailInfo(Map<String, Object> param);
    int updateCodeDetailOrder(Map<String, Object> param);
}
