package com.helpdesk.admin.board.service;

import com.helpdesk.admin.board.mapper.BoardMapper;
import com.helpdesk.common.util.PagingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class BoardService {

    @Autowired
    private BoardMapper boardMapper;

    /**
     * 값이 비어있는지 확인 (null 또는 빈 문자열)
     */
    private boolean isEmpty(Object value) {
        return value == null || (value instanceof String && ((String) value).trim().isEmpty());
    }

    public Map<String, Object> getBoardListPage(Map<String, Object> param, int page, int pageSize) {
        Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
        param.putAll(pagingParam);

        List<Map<String, Object>> list = boardMapper.selectBoardList(param);
        int totalCount = boardMapper.selectBoardListCount(param);

        Map<String, Object> result = new HashMap<>();
        result.put("boardList", list);
        result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
        return result;
    }

    public Map<String, Object> getBoardInfo(int boardId) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        return boardMapper.selectBoardInfo(param);
    }

    public Map<String, Object> getBoardRoleCfg(int boardId) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        return boardMapper.selectBoardRoleCfg(param);
    }

    public List<Map<String, Object>> getBoardFieldList(int boardId) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        return boardMapper.selectBoardFieldList(param);
    }

    @Transactional
    public void insertBoard(Map<String, Object> param) {
        // 기본값 설정 - null 또는 빈 문자열 체크
        if (isEmpty(param.get("boardPurpose"))) param.put("boardPurpose", "일반");
        if (isEmpty(param.get("replyType"))) param.put("replyType", "N");
        if (isEmpty(param.get("menuId"))) param.put("menuId", 0);
        if (isEmpty(param.get("pagePostCnt"))) param.put("pagePostCnt", 10);
        if (isEmpty(param.get("secretUseYn"))) param.put("secretUseYn", "N");
        if (isEmpty(param.get("fileMaxCnt"))) param.put("fileMaxCnt", 5);
        if (isEmpty(param.get("editorUseYn"))) param.put("editorUseYn", "Y");
        if (isEmpty(param.get("statusUseYn"))) param.put("statusUseYn", "Y");
        if (isEmpty(param.get("newPostNoticeHr"))) param.put("newPostNoticeHr", 24);
        if (isEmpty(param.get("listFileDownloadYn"))) param.put("listFileDownloadYn", "Y");
        if (isEmpty(param.get("fileLimitSize"))) param.put("fileLimitSize", 10);
        if (isEmpty(param.get("approvalUseYn"))) param.put("approvalUseYn", "N");
        if (isEmpty(param.get("satisfactionUseYn"))) param.put("satisfactionUseYn", "N");
        if (isEmpty(param.get("smsUseYn"))) param.put("smsUseYn", "N");
        if (isEmpty(param.get("emailUseYn"))) param.put("emailUseYn", "N");
        if (isEmpty(param.get("ownerListUseYn"))) param.put("ownerListUseYn", "N");
        if (isEmpty(param.get("postContentRequiredYn"))) param.put("postContentRequiredYn", "Y");
        if (isEmpty(param.get("noticeYn"))) param.put("noticeYn", "N");
        if (isEmpty(param.get("replyYn"))) param.put("replyYn", "Y");
        if (isEmpty(param.get("copyYn"))) param.put("copyYn", "N");
        if (isEmpty(param.get("prefaceUseYn"))) param.put("prefaceUseYn", "N");
        if (isEmpty(param.get("prefaceContent"))) param.put("prefaceContent", "");
        if (isEmpty(param.get("anonymousUseYn"))) param.put("anonymousUseYn", "N");
        if (isEmpty(param.get("folderUseYn"))) param.put("folderUseYn", "N");
        if (isEmpty(param.get("allowedExt"))) param.put("allowedExt", "jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx,hwp,txt,zip");
        if (isEmpty(param.get("regPeriodUseYn"))) param.put("regPeriodUseYn", "N");
        
        boardMapper.insertBoardInfo(param);
        
        // 권한 설정 기본값 등록
        Map<String, Object> roleParam = new HashMap<>(param);
        roleParam.put("boardId", param.get("boardId"));
        roleParam.put("readRole", "1");
        roleParam.put("writeRole", "1");
        roleParam.put("replyRole", "1");
        roleParam.put("deleteRole", "1");
        roleParam.put("manageRole", "1");
        roleParam.put("updateRole", "1");
        roleParam.put("secretRole", "1");
        roleParam.put("printRole", "1");
        roleParam.put("writeBtnShowYn", "Y");
        roleParam.put("replyBtnShowYn", "Y");
        boardMapper.insertBoardRoleCfg(roleParam);
    }

    @Transactional
    public void updateBoard(Map<String, Object> param) {
        boardMapper.updateBoardInfo(param);
    }

    @Transactional
    public void deleteBoard(int boardId) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        boardMapper.deleteBoardInfo(param);
    }

    @Transactional
    public void insertBoardField(Map<String, Object> param) {
        boardMapper.insertBoardFieldInfo(param);
    }

    @Transactional
    public void updateBoardField(Map<String, Object> param) {
        boardMapper.updateBoardFieldInfo(param);
    }

    @Transactional
    public void deleteBoardField(int fieldSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("fieldSeq", fieldSeq);
        boardMapper.deleteBoardFieldInfo(param);
    }

    public List<Map<String, Object>> getSystemList() {
        return boardMapper.selectSystemList();
    }
}
