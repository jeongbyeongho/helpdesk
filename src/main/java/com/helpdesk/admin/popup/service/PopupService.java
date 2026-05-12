package com.helpdesk.admin.popup.service;

import com.helpdesk.admin.popup.mapper.PopupMapper;
import com.helpdesk.common.util.PagingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class PopupService {

    @Autowired
    private PopupMapper popupMapper;

    public Map<String, Object> getPopupListPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = popupMapper.selectPopupList(param);
        int totalCount = popupMapper.selectPopupListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("popupList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    public Map<String, Object> getPopupInfo(int popupSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("popupSeq", popupSeq);
        Map<String, Object> info = popupMapper.selectPopupInfo(param);
        info.put("sysMapList", popupMapper.selectPopupSysMapList(param));
        return info;
    }

    @Transactional
    public void insertPopup(Map<String, Object> param, List<Map<String, Object>> sysMapList) {
        popupMapper.insertPopupInfo(param);
        if (sysMapList != null) {
            for (Map<String, Object> sysMap : sysMapList) {
                sysMap.put("popupSeq", param.get("popupSeq"));
                popupMapper.insertPopupSysMap(sysMap);
            }
        }
    }

    @Transactional
    public void updatePopup(Map<String, Object> param, List<Map<String, Object>> sysMapList) {
        popupMapper.updatePopupInfo(param);
        Map<String, Object> delParam = new HashMap<>();
        delParam.put("popupSeq", param.get("popupSeq"));
        popupMapper.deletePopupSysMap(delParam);
        if (sysMapList != null) {
            for (Map<String, Object> sysMap : sysMapList) {
                sysMap.put("popupSeq", param.get("popupSeq"));
                popupMapper.insertPopupSysMap(sysMap);
            }
        }
    }

    @Transactional
    public void deletePopup(int popupSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("popupSeq", popupSeq);
        popupMapper.deletePopupSysMap(param);
        popupMapper.deletePopupInfo(param);
    }

    public List<Map<String, Object>> getActivePopupList(String sysId) {
        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        return popupMapper.selectActivePopupList(param);
    }
}
