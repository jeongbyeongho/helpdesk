package com.helpdesk.admin.system.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface SystemMapper {

    List<Map<String, Object>> selectSystemList(Map<String, Object> param);
    int selectSystemListCount(Map<String, Object> param);
    Map<String, Object> selectSystemInfo(Map<String, Object> param);

    int insertSystemInfo(Map<String, Object> param);
    int updateSystemInfo(Map<String, Object> param);
    int updateSystemTemplate(Map<String, Object> param);
    int deleteSystemInfo(Map<String, Object> param);

    int checkSystemIdDup(Map<String, Object> param);

    // 시스템 도메인
    List<Map<String, Object>> selectSystemDomainList(Map<String, Object> param);
    Map<String, Object> selectSystemDomainInfo(Map<String, Object> param);
    int insertSystemDomainInfo(Map<String, Object> param);
    int updateSystemDomainInfo(Map<String, Object> param);
    int deleteSystemDomainInfo(Map<String, Object> param);

    // 부서
    List<Map<String, Object>> selectDeptList(Map<String, Object> param);
    Map<String, Object> selectDeptInfo(Map<String, Object> param);
    int insertDeptInfo(Map<String, Object> param);
    int updateDeptInfo(Map<String, Object> param);
    int deleteDeptInfo(Map<String, Object> param);

    // 부서 업무
    List<Map<String, Object>> selectDeptJobList(Map<String, Object> param);
    int insertDeptJobInfo(Map<String, Object> param);
    int updateDeptJobInfo(Map<String, Object> param);
    int deleteDeptJobInfo(Map<String, Object> param);
}
