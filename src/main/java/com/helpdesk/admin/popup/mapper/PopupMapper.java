package com.helpdesk.admin.popup.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface PopupMapper {

    List<Map<String, Object>> selectPopupList(Map<String, Object> param);
    int selectPopupListCount(Map<String, Object> param);
    Map<String, Object> selectPopupInfo(Map<String, Object> param);
    List<Map<String, Object>> selectPopupSysMapList(Map<String, Object> param);

    int insertPopupInfo(Map<String, Object> param);
    int insertPopupSysMap(Map<String, Object> param);
    int updatePopupInfo(Map<String, Object> param);
    int updatePopupSysMap(Map<String, Object> param);
    int deletePopupInfo(Map<String, Object> param);
    int deletePopupSysMap(Map<String, Object> param);

    // 화면 노출용 팝업 조회
    List<Map<String, Object>> selectActivePopupList(Map<String, Object> param);
}
