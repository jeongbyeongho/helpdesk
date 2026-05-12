package com.helpdesk.common.util;

import java.util.HashMap;
import java.util.Map;

public class PagingUtil {

    private static final int DEFAULT_PAGE_SIZE = 10;
    private static final int DEFAULT_PAGE_BLOCK = 10;

    /**
     * 페이징 파라미터 생성
     * @param page     현재 페이지 (1부터 시작)
     * @param pageSize 페이지당 건수
     * @return offset, limit 포함한 Map
     */
    public static Map<String, Object> buildPagingParam(int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;

        int offset = (page - 1) * pageSize;

        Map<String, Object> param = new HashMap<>();
        param.put("page", page);
        param.put("pageSize", pageSize);
        param.put("offset", offset);
        param.put("limit", pageSize);
        // MSSQL ROW_NUMBER 방식
        param.put("minSn", offset);
        param.put("maxSn", offset + pageSize);
        return param;
    }

    /**
     * 페이징 정보 계산
     * @param totalCount 전체 건수
     * @param page       현재 페이지
     * @param pageSize   페이지당 건수
     * @return 페이징 정보 Map
     */
    public static Map<String, Object> buildPagingInfo(int totalCount, int page, int pageSize) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;

        int totalPage = (int) Math.ceil((double) totalCount / pageSize);
        if (totalPage < 1) totalPage = 1;
        if (page > totalPage) page = totalPage;

        int blockStart = ((page - 1) / DEFAULT_PAGE_BLOCK) * DEFAULT_PAGE_BLOCK + 1;
        int blockEnd = Math.min(blockStart + DEFAULT_PAGE_BLOCK - 1, totalPage);

        Map<String, Object> paging = new HashMap<>();
        paging.put("totalCount", totalCount);
        paging.put("page", page);
        paging.put("pageSize", pageSize);
        paging.put("totalPage", totalPage);
        paging.put("blockStart", blockStart);
        paging.put("blockEnd", blockEnd);
        paging.put("hasPrev", blockStart > 1);
        paging.put("hasNext", blockEnd < totalPage);
        paging.put("prevPage", blockStart - 1);
        paging.put("nextPage", blockEnd + 1);
        return paging;
    }
}
