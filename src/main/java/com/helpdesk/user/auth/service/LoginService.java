package com.helpdesk.user.auth.service;

import com.helpdesk.common.util.PasswordUtil;
import com.helpdesk.user.auth.mapper.LoginMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class LoginService {

    @Autowired
    private LoginMapper loginMapper;

    /**
     * 로그인 처리
     * @return 사용자 정보 Map (실패 시 null)
     */
    public Map<String, Object> login(String userId, String rawPwd, String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("userPwd", PasswordUtil.encrypt(rawPwd));
        param.put("sysId", sysId);

        Map<String, Object> userInfo = loginMapper.selectUserForLogin(param);
        if (userInfo == null) return null;

        // 권한 목록 조회
        List<Map<String, Object>> roleList = loginMapper.selectUserRoleList(param);
        userInfo.put("roleList", roleList);

        // 최고 권한코드 (숫자가 낮을수록 높은 권한)
        int minRoleCode = 99;
        if (roleList != null && !roleList.isEmpty()) {
            minRoleCode = roleList.stream()
                    .mapToInt(r -> {
                        Object roleCode = r.get("role_code");
                        if (roleCode == null) roleCode = r.get("roleCode");
                        return Integer.parseInt(String.valueOf(roleCode));
                    })
                    .min().orElse(99);
        }
        userInfo.put("roleCode", String.valueOf(minRoleCode));

        return userInfo;
    }

    /**
     * 비밀번호 변경 주기 초과 여부
     */
    public boolean isPwdChangeRequired(String userId, int changeCycle) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("changeCycle", changeCycle);
        Map<String, Object> result = loginMapper.selectPwdChangeInfo(param);
        int cnt = Integer.parseInt(String.valueOf(result.getOrDefault("changeCnt", "0")));
        return cnt == 0;
    }

    /**
     * 비밀번호 변경
     */
    public int changePassword(String userId, String newRawPwd) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("newPwd", PasswordUtil.encrypt(newRawPwd));
        return loginMapper.updateUserPwd(param);
    }

    /**
     * 승인 대기 수
     */
    public int getPendingApprovalCount(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        Map<String, Object> result = loginMapper.selectPendingApprovalCount(param);
        return Integer.parseInt(String.valueOf(result.getOrDefault("pendingCnt", "0")));
    }
}
