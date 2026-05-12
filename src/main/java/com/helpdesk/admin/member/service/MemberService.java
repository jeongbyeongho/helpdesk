package com.helpdesk.admin.member.service;

import com.helpdesk.admin.member.mapper.MemberMapper;
import com.helpdesk.common.util.PagingUtil;
import com.helpdesk.common.util.PasswordUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MemberService {

    @Autowired
    private MemberMapper memberMapper;

    public Map<String, Object> getMemberListPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = memberMapper.selectMemberList(param);
        int totalCount = memberMapper.selectMemberListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("memberList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    public Map<String, Object> getMemberInfo(String userId, String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("sysId", sysId);
        return memberMapper.selectMemberInfo(param);
    }

    @Transactional
    public void insertMember(Map<String, Object> param) {
        // 비밀번호 암호화
        String rawPwd = (String) param.get("userPwd");
        if (rawPwd != null && !rawPwd.isEmpty()) {
            param.put("userPwd", PasswordUtil.encrypt(rawPwd));
        }
        
        // 사용자 기본 정보 등록
        memberMapper.insertMemberInfo(param);
        
        // 사용자 유형 정보 등록을 위한 기본값 설정
        if (param.get("userType") == null || param.get("userType").toString().isEmpty()) {
            param.put("userType", "I"); // 기본값: 내부사용자
        }
        if (param.get("orgCode") == null || param.get("orgCode").toString().isEmpty()) {
            param.put("orgCode", "DEFAULT");
        }
        if (param.get("orgNm") == null || param.get("orgNm").toString().isEmpty()) {
            param.put("orgNm", "기본조직");
        }
        if (param.get("orgType") == null || param.get("orgType").toString().isEmpty()) {
            param.put("orgType", "C");
        }
        if (param.get("approvalYn") == null || param.get("approvalYn").toString().isEmpty()) {
            param.put("approvalYn", "Y"); // 기본값: 승인
        }
        
        memberMapper.insertMemberTypeInfo(param);
    }

    @Transactional
    public void updateMember(Map<String, Object> param) {
        String rawPwd = (String) param.get("userPwd");
        if (rawPwd != null && !rawPwd.isEmpty()) {
            param.put("userPwd", PasswordUtil.encrypt(rawPwd));
        } else {
            param.put("userPwd", null);
        }
        memberMapper.updateMemberInfo(param);
    }

    @Transactional
    public void approveMember(String userId, String sysId, String approvalUserId, String approvalUserNm) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("sysId", sysId);
        param.put("approvalYn", "Y");
        param.put("approvalUserId", approvalUserId);
        param.put("approvalUserNm", approvalUserNm);
        memberMapper.updateMemberApproval(param);
    }

    @Transactional
    public void resetPassword(String userId, String newRawPwd) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("userPwd", PasswordUtil.encrypt(newRawPwd));
        memberMapper.updateMemberPwd(param);
    }

    @Transactional
    public void deleteMember(String userId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        memberMapper.deleteMemberTypeInfo(param);
        memberMapper.deleteMemberInfo(param);
    }

    public List<Map<String, Object>> getMemberListByType(Map<String, Object> param) {
        return memberMapper.selectMemberListByType(param);
    }

    public List<Map<String, Object>> getDeptList(String orgCode) {
        Map<String, Object> param = new HashMap<>();
        param.put("orgCode", orgCode);
        return memberMapper.selectDeptList(param);
    }
}
