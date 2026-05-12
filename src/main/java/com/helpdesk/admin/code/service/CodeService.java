package com.helpdesk.admin.code.service;

import com.helpdesk.admin.code.mapper.CodeMapper;
import com.helpdesk.common.util.PagingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class CodeService {

    @Autowired
    private CodeMapper codeMapper;

    public Map<String, Object> getCodeGroupListPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = codeMapper.selectCodeGroupList(param);
        int totalCount = codeMapper.selectCodeGroupListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("codeGroupList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    public Map<String, Object> getCodeGroupInfo(String codeGroup) {
        Map<String, Object> param = new HashMap<>();
        param.put("codeGroup", codeGroup);
        return codeMapper.selectCodeGroupInfo(param);
    }

    public List<Map<String, Object>> getCodeDetailList(String codeGroup) {
        Map<String, Object> param = new HashMap<>();
        param.put("codeGroup", codeGroup);
        return codeMapper.selectCodeDetailList(param);
    }

    @Transactional
    public void insertCodeGroup(Map<String, Object> param) {
        codeMapper.insertCodeGroupInfo(param);
    }

    @Transactional
    public void updateCodeGroup(Map<String, Object> param) {
        codeMapper.updateCodeGroupInfo(param);
    }

    @Transactional
    public void deleteCodeGroup(String codeGroup) {
        Map<String, Object> param = new HashMap<>();
        param.put("codeGroup", codeGroup);
        codeMapper.deleteCodeDetailInfo(param);
        codeMapper.deleteCodeGroupInfo(param);
    }

    @Transactional
    public void insertCodeDetail(Map<String, Object> param) {
        codeMapper.insertCodeDetailInfo(param);
    }

    @Transactional
    public void updateCodeDetail(Map<String, Object> param) {
        codeMapper.updateCodeDetailInfo(param);
    }

    @Transactional
    public void deleteCodeDetail(Map<String, Object> param) {
        codeMapper.deleteCodeDetailInfo(param);
    }

    @Transactional
    public void updateCodeDetailOrder(List<Map<String, Object>> orderList) {
        for (Map<String, Object> item : orderList) {
            codeMapper.updateCodeDetailOrder(item);
        }
    }
}
