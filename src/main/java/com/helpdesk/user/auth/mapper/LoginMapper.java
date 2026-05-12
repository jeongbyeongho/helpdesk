package com.helpdesk.user.auth.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.Map;

@Mapper
public interface LoginMapper {

    /** 로그인 - 사용자 정보 조회 */
    Map<String, Object> selectUserForLogin(Map<String, Object> param);

    /** 사용자 기본 정보 조회 (ID만으로) */
    Map<String, Object> selectUserBaseInfo(Map<String, Object> param);

    /** 비밀번호 변경 주기 확인 */
    Map<String, Object> selectPwdChangeInfo(Map<String, Object> param);

    /** 사용자 보유 권한 목록 */
    java.util.List<Map<String, Object>> selectUserRoleList(Map<String, Object> param);

    /** 승인 대기 회원 수 */
    Map<String, Object> selectPendingApprovalCount(Map<String, Object> param);

    /** 비밀번호 변경 */
    int updateUserPwd(Map<String, Object> param);
}
