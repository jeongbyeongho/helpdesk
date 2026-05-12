package com.helpdesk.user.post.mapper;

import org.apache.ibatis.annotations.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface PostMapper {

    List<Map<String, Object>> selectPostList(Map<String, Object> param);
    int selectPostListCount(Map<String, Object> param);
    Map<String, Object> selectPostInfo(Map<String, Object> param);

    int insertPostInfo(Map<String, Object> param);
    int updatePostInfo(Map<String, Object> param);
    int updatePostStatus(Map<String, Object> param);
    int updateReadCount(Map<String, Object> param);
    int deletePostInfo(Map<String, Object> param);

    // 답변
    List<Map<String, Object>> selectReplyList(Map<String, Object> param);
    Map<String, Object> selectReplyInfo(Map<String, Object> param);
    int insertReplyInfo(Map<String, Object> param);
    int updateReplyInfo(Map<String, Object> param);
    int deleteReplyInfo(Map<String, Object> param);

    // 파일
    List<Map<String, Object>> selectFileList(Map<String, Object> param);
    Map<String, Object> selectFileInfo(Map<String, Object> param);
    int insertFileInfo(Map<String, Object> param);
    int deleteFileInfo(Map<String, Object> param);
    int updateDownloadCount(Map<String, Object> param);
}
