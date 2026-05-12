package com.helpdesk.admin.role.service;

import com.helpdesk.admin.role.mapper.RoleMapper;
import com.helpdesk.common.util.PagingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class RoleService {

    @Autowired
    private RoleMapper roleMapper;

    public Map<String, Object> getRoleListPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = roleMapper.selectRoleList(param);
        int totalCount = roleMapper.selectRoleListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("roleList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    public Map<String, Object> getRoleInfo(int roleSeq, String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("roleSeq", roleSeq);
        param.put("sysId", sysId);
        return roleMapper.selectRoleInfo(param);
    }

    public boolean checkRoleNameDup(String roleNm, String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("roleNm", roleNm);
        param.put("sysId", sysId);
        return roleMapper.checkRoleNameDup(param) > 0;
    }

    @Transactional
    public void insertRole(Map<String, Object> param) {
        roleMapper.insertRoleInfo(param);
    }

    @Transactional
    public void updateRole(Map<String, Object> param) {
        roleMapper.updateRoleInfo(param);
    }

    @Transactional
    public void deleteRole(int roleSeq, int roleCode) {
        Map<String, Object> param = new HashMap<>();
        param.put("roleSeq", roleSeq);
        param.put("roleCode", roleCode);
        roleMapper.deleteUserRoleMapByRoleCode(param);
        roleMapper.deleteGroupRoleMapByRoleCode(param);
        roleMapper.deleteRoleInfo(param);
    }

    // 사용자 권한 부여/회수
    public Map<String, Object> getUserListByRolePage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = roleMapper.selectUserListByRole(param);
        int totalCount = roleMapper.selectUserListByRoleCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("userList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    public List<Map<String, Object>> getGrantableRoleList(Map<String, Object> param) {
        return roleMapper.selectGrantableRoleList(param);
    }

    @Transactional
    public void grantRole(Map<String, Object> param) {
        roleMapper.insertUserRoleMap(param);
    }

    @Transactional
    public void revokeRole(int userRoleSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("userRoleSeq", userRoleSeq);
        roleMapper.deleteUserRoleMap(param);
    }

    public List<Map<String, Object>> getRoleListForSystem(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return roleMapper.selectRoleListForSystem(param);
    }
}
