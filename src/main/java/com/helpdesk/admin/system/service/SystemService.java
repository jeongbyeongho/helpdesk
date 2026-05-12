package com.helpdesk.admin.system.service;

import com.helpdesk.admin.system.mapper.SystemMapper;
import com.helpdesk.common.util.PagingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SystemService {

    @Autowired
    private SystemMapper systemMapper;

    public Map<String, Object> getSystemListPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = systemMapper.selectSystemList(param);
        int totalCount = systemMapper.selectSystemListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("systemList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    public Map<String, Object> getSystemInfo(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return systemMapper.selectSystemInfo(param);
    }

    public boolean checkSystemIdDup(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return systemMapper.checkSystemIdDup(param) > 0;
    }

    @Transactional
    public void insertSystem(Map<String, Object> param) {
        systemMapper.insertSystemInfo(param);
    }

    @Transactional
    public void updateSystem(Map<String, Object> param) {
        systemMapper.updateSystemInfo(param);
    }

    @Transactional
    public void deleteSystem(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        systemMapper.deleteSystemInfo(param);
    }

    // 도메인
    public List<Map<String, Object>> getDomainList(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return systemMapper.selectSystemDomainList(param);
    }

    @Transactional
    public void insertDomain(Map<String, Object> param) {
        systemMapper.insertSystemDomainInfo(param);
    }

    @Transactional
    public void updateDomain(Map<String, Object> param) {
        systemMapper.updateSystemDomainInfo(param);
    }

    @Transactional
    public void deleteDomain(int domainSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("domainSeq", domainSeq);
        systemMapper.deleteSystemDomainInfo(param);
    }

    // 부서
    public List<Map<String, Object>> getDeptList(String orgCode) {
        Map<String, Object> param = new HashMap<>();
        param.put("orgCode", orgCode);
        return systemMapper.selectDeptList(param);
    }

    @Transactional
    public void insertDept(Map<String, Object> param) {
        systemMapper.insertDeptInfo(param);
    }

    @Transactional
    public void updateDept(Map<String, Object> param) {
        systemMapper.updateDeptInfo(param);
    }

    @Transactional
    public void deleteDept(int deptSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("deptSeq", deptSeq);
        systemMapper.deleteDeptInfo(param);
    }

    // 부서 업무
    public List<Map<String, Object>> getDeptJobList(String deptCode) {
        Map<String, Object> param = new HashMap<>();
        param.put("deptCode", deptCode);
        return systemMapper.selectDeptJobList(param);
    }

    @Transactional
    public void insertDeptJob(Map<String, Object> param) {
        systemMapper.insertDeptJobInfo(param);
    }

    @Transactional
    public void updateDeptJob(Map<String, Object> param) {
        systemMapper.updateDeptJobInfo(param);
    }

    @Transactional
    public void deleteDeptJob(int deptJobSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("deptJobSeq", deptJobSeq);
        systemMapper.deleteDeptJobInfo(param);
    }
}
