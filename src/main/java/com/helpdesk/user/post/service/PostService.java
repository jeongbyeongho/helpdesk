package com.helpdesk.user.post.service;

import com.helpdesk.user.post.mapper.PostMapper;
import com.helpdesk.admin.board.mapper.BoardMapper;
import com.helpdesk.common.util.PagingUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
public class PostService {

    @Autowired
    private PostMapper postMapper;

    @Autowired
    private BoardMapper boardMapper;

    @Value("${file.upload-path}")
    private String uploadPath;

    @Value("${file.allowed-ext}")
    private String allowedExt;

    public Map<String, Object> getPostListPage(Map<String, Object> param, int page, int pageSize) {
        try {
            System.out.println("=== PostService.getPostListPage 시작 ===");
            System.out.println("boardId: " + param.get("boardId"));
            System.out.println("userId: " + param.get("userId"));
            
            Map<String, Object> pagingParam = PagingUtil.buildPagingParam(page, pageSize);
            param.putAll(pagingParam);
            
            System.out.println("페이징 파라미터: " + pagingParam);

            List<Map<String, Object>> list = postMapper.selectPostList(param);
            System.out.println("게시물 목록 조회 완료: " + (list != null ? list.size() : 0) + "건");
            
            int totalCount = postMapper.selectPostListCount(param);
            System.out.println("전체 건수: " + totalCount);

            // 게시판 정보
            Map<String, Object> boardInfo = null;
            String boardTitle = "게시판";
            
            if (param.get("boardId") != null) {
                System.out.println("게시판 정보 조회 시작");
                boardInfo = getBoardInfo((int) param.get("boardId"));
                System.out.println("게시판 정보: " + boardInfo);
                if (boardInfo != null && boardInfo.get("board_title") != null) {
                    boardTitle = (String) boardInfo.get("board_title");
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("postList", list != null ? list : new ArrayList<>());
            result.put("paging", PagingUtil.buildPagingInfo(totalCount, page, pageSize));
            result.put("boardInfo", boardInfo);
            result.put("boardTitle", boardTitle);
            
            System.out.println("=== PostService.getPostListPage 완료 ===");
            return result;
        } catch (Exception e) {
            System.err.println("=== PostService.getPostListPage 오류 ===");
            e.printStackTrace();
            Map<String, Object> result = new HashMap<>();
            result.put("postList", new ArrayList<>());
            result.put("paging", PagingUtil.buildPagingInfo(0, page, pageSize));
            result.put("boardInfo", new HashMap<>());
            result.put("boardTitle", "게시판");
            return result;
        }
    }

    public Map<String, Object> getPostInfo(int boardId, int postSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        param.put("postSeq", postSeq);
        return postMapper.selectPostInfo(param);
    }

    public Map<String, Object> getBoardInfo(int boardId) {
        try {
            System.out.println("=== getBoardInfo 시작 ===");
            System.out.println("boardId: " + boardId);
            
            Map<String, Object> param = new HashMap<>();
            param.put("boardId", boardId);
            
            Map<String, Object> boardInfo = boardMapper.selectBoardInfo(param);
            System.out.println("게시판 정보: " + boardInfo);
            
            if (boardInfo != null) {
                System.out.println("allowed_ext: " + boardInfo.get("allowed_ext"));
                System.out.println("file_max_cnt: " + boardInfo.get("file_max_cnt"));
            }
            
            System.out.println("=== getBoardInfo 완료 ===");
            return boardInfo;
        } catch (Exception e) {
            System.err.println("=== getBoardInfo 오류 ===");
            e.printStackTrace();
            return null;
        }
    }

    public List<Map<String, Object>> getFileList(int boardId, int postSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        param.put("postSeq", postSeq);
        return postMapper.selectFileList(param);
    }

    public Map<String, Object> getFileInfo(int fileSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("fileSeq", fileSeq);
        return postMapper.selectFileInfo(param);
    }

    public List<Map<String, Object>> getReplyList(int boardId, int postSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        param.put("postSeq", postSeq);
        return postMapper.selectReplyList(param);
    }

    @Transactional
    public int insertPost(Map<String, Object> param, List<MultipartFile> files) {
        try {
            System.out.println("=== PostService.insertPost 시작 ===");
            System.out.println("입력 파라미터: " + param);
            
            // 필수 파라미터 검증
            if (param.get("boardId") == null) {
                throw new RuntimeException("boardId가 누락되었습니다.");
            }
            if (param.get("postTitle") == null || param.get("postTitle").toString().trim().isEmpty()) {
                throw new RuntimeException("postTitle이 누락되었습니다.");
            }
            if (param.get("postContent") == null || param.get("postContent").toString().trim().isEmpty()) {
                throw new RuntimeException("postContent가 누락되었습니다.");
            }
            if (param.get("regId") == null || param.get("regId").toString().trim().isEmpty()) {
                throw new RuntimeException("regId가 누락되었습니다.");
            }
            
            // 기본값 설정
            if (param.get("postStatus") == null) {
                param.put("postStatus", "W"); // 대기
            }
            if (param.get("secretYn") == null) {
                param.put("secretYn", "N");
            }
            if (param.get("noticeYn") == null) {
                param.put("noticeYn", "N");
            }
            
            System.out.println("기본값 설정 완료");
            System.out.println("boardId: " + param.get("boardId"));
            System.out.println("postTitle: " + param.get("postTitle"));
            System.out.println("postContent 길이: " + param.get("postContent").toString().length());
            System.out.println("regId: " + param.get("regId"));
            System.out.println("regNm: " + param.get("regNm"));
            System.out.println("postStatus: " + param.get("postStatus"));
            System.out.println("secretYn: " + param.get("secretYn"));
            System.out.println("noticeYn: " + param.get("noticeYn"));

            // 게시물 등록
            System.out.println("게시물 등록 시작");
            int result = postMapper.insertPostInfo(param);
            System.out.println("insertPostInfo 실행 결과: " + result);
            
            Object postSeqObj = param.get("postSeq");
            System.out.println("postSeq 객체: " + postSeqObj);
            
            if (postSeqObj == null) {
                throw new RuntimeException("게시물 등록 후 postSeq를 가져올 수 없습니다. MyBatis useGeneratedKeys 설정을 확인하세요.");
            }
            
            int postSeq = Integer.parseInt(String.valueOf(postSeqObj));
            System.out.println("게시물 등록 완료, postSeq: " + postSeq);

            // 파일 업로드
            if (files != null && !files.isEmpty()) {
                System.out.println("파일 업로드 시작, 파일 수: " + files.size());
                
                // boardId를 안전하게 Integer로 변환
                int boardIdInt;
                Object boardIdObj = param.get("boardId");
                if (boardIdObj instanceof String) {
                    boardIdInt = Integer.parseInt((String) boardIdObj);
                } else if (boardIdObj instanceof Integer) {
                    boardIdInt = (Integer) boardIdObj;
                } else {
                    throw new RuntimeException("boardId 타입이 올바르지 않습니다: " + boardIdObj.getClass());
                }
                
                uploadFiles(files, boardIdInt, postSeq);
                System.out.println("파일 업로드 완료");
            } else {
                System.out.println("업로드할 파일이 없습니다.");
            }

            System.out.println("=== PostService.insertPost 완료 ===");
            return postSeq;
        } catch (Exception e) {
            System.err.println("=== PostService.insertPost 오류 ===");
            System.err.println("오류 메시지: " + e.getMessage());
            e.printStackTrace();
            throw new RuntimeException("게시물 등록 중 오류가 발생했습니다: " + e.getMessage(), e);
        }
    }

    @Transactional
    public void updatePost(Map<String, Object> param, List<MultipartFile> files, List<Integer> deleteFileSeqs) {
        // 게시물 수정
        postMapper.updatePostInfo(param);

        // 파일 삭제
        if (deleteFileSeqs != null && !deleteFileSeqs.isEmpty()) {
            for (Integer fileSeq : deleteFileSeqs) {
                Map<String, Object> fileParam = new HashMap<>();
                fileParam.put("fileSeq", fileSeq);
                fileParam.put("boardId", param.get("boardId"));
                postMapper.deleteFileInfo(fileParam);
            }
        }

        // 파일 업로드
        if (files != null && !files.isEmpty()) {
            uploadFiles(files, (int) param.get("boardId"), (int) param.get("postSeq"));
        }
    }

    @Transactional
    public void deletePost(int boardId, int postSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        param.put("postSeq", postSeq);
        postMapper.deletePostInfo(param);
    }

    @Transactional
    public void updatePostStatus(int boardId, int postSeq, String postStatus) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        param.put("postSeq", postSeq);
        param.put("postStatus", postStatus);
        postMapper.updatePostStatus(param);
    }

    @Transactional
    public void increaseReadCount(int boardId, int postSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        param.put("postSeq", postSeq);
        postMapper.updateReadCount(param);
    }

    @Transactional
    public void insertReply(Map<String, Object> param) {
        if (param.get("replyStatus") == null) {
            param.put("replyStatus", "N"); // 일반
        }
        if (param.get("secretYn") == null) {
            param.put("secretYn", "N");
        }
        postMapper.insertReplyInfo(param);
    }

    @Transactional
    public void updateReply(Map<String, Object> param) {
        postMapper.updateReplyInfo(param);
    }

    @Transactional
    public void deleteReply(int boardId, int replySeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("boardId", boardId);
        param.put("replySeq", replySeq);
        postMapper.deleteReplyInfo(param);
    }

    @Transactional
    public void increaseDownloadCount(int fileSeq) {
        Map<String, Object> param = new HashMap<>();
        param.put("fileSeq", fileSeq);
        postMapper.updateDownloadCount(param);
    }

    private void uploadFiles(List<MultipartFile> files, int boardId, int postSeq) {
        try {
            System.out.println("=== 파일 업로드 시작 ===");
            System.out.println("업로드 경로: " + uploadPath);
            System.out.println("설정 허용 확장자: " + allowedExt);
            
            // 게시판별 허용 확장자 조회
            Map<String, Object> boardParam = new HashMap<>();
            boardParam.put("boardId", boardId);
            Map<String, Object> boardInfo = boardMapper.selectBoardInfo(boardParam);
            
            String boardAllowedExt = null;
            if (boardInfo != null && boardInfo.get("allowed_ext") != null) {
                boardAllowedExt = (String) boardInfo.get("allowed_ext");
                System.out.println("게시판별 허용 확장자: " + boardAllowedExt);
            }
            
            // 사용할 허용 확장자 결정 (게시판 설정 우선, 없으면 시스템 기본값)
            String useAllowedExt = (boardAllowedExt != null && !boardAllowedExt.trim().isEmpty()) 
                                   ? boardAllowedExt : allowedExt;
            System.out.println("최종 사용 허용 확장자: " + useAllowedExt);
            
            // 업로드 디렉토리 생성
            File baseUploadDir = new File(uploadPath);
            if (!baseUploadDir.exists()) {
                boolean created = baseUploadDir.mkdirs();
                System.out.println("기본 업로드 디렉토리 생성: " + baseUploadDir.getAbsolutePath() + " -> " + created);
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String dateFolder = sdf.format(new Date());
            
            File uploadDir = new File(uploadPath + File.separator + dateFolder);
            if (!uploadDir.exists()) {
                boolean created = uploadDir.mkdirs();
                System.out.println("날짜별 디렉토리 생성: " + uploadDir.getAbsolutePath() + " -> " + created);
                if (!created) {
                    System.err.println("디렉토리 생성 실패: " + uploadDir.getAbsolutePath());
                }
            }

            for (MultipartFile file : files) {
                if (file.isEmpty()) {
                    System.out.println("빈 파일 스킵");
                    continue;
                }

                String originalFilename = file.getOriginalFilename();
                if (originalFilename == null || originalFilename.isEmpty()) {
                    System.out.println("파일명이 없는 파일 스킵");
                    continue;
                }
                
                System.out.println("처리 중인 파일: " + originalFilename);
                
                String fileExt = "";
                int lastDotIndex = originalFilename.lastIndexOf(".");
                if (lastDotIndex > 0) {
                    fileExt = originalFilename.substring(lastDotIndex + 1).toLowerCase();
                }
                System.out.println("파일 확장자: " + fileExt);

                // 확장자 체크
                boolean isAllowed = true;
                if (!fileExt.isEmpty() && useAllowedExt != null && !useAllowedExt.trim().isEmpty()) {
                    String[] allowedExtArray = useAllowedExt.toLowerCase().split(",");
                    isAllowed = false;
                    System.out.println("허용 확장자 배열: " + java.util.Arrays.toString(allowedExtArray));
                    
                    for (String ext : allowedExtArray) {
                        String trimmedExt = ext.trim();
                        System.out.println("비교: '" + fileExt + "' vs '" + trimmedExt + "'");
                        if (trimmedExt.equals(fileExt)) {
                            isAllowed = true;
                            System.out.println("확장자 허용됨: " + fileExt);
                            break;
                        }
                    }
                }
                
                if (!isAllowed) {
                    System.out.println("허용되지 않는 확장자: " + fileExt + " (허용: " + useAllowedExt + ")");
                    continue;
                }

                String savedFilename = UUID.randomUUID().toString() + "." + fileExt;
                String filePath = dateFolder + File.separator + savedFilename;

                try {
                    File destFile = new File(uploadDir, savedFilename);
                    file.transferTo(destFile);
                    System.out.println("파일 저장 완료: " + destFile.getAbsolutePath());

                    Map<String, Object> fileParam = new HashMap<>();
                    fileParam.put("boardId", boardId);
                    fileParam.put("postSeq", postSeq);
                    fileParam.put("fileNm", originalFilename);
                    fileParam.put("filePath", filePath);
                    fileParam.put("fileSize", file.getSize());
                    fileParam.put("fileExt", fileExt);
                    fileParam.put("fileType", "NORMAL");
                    fileParam.put("thumbPath", null); // 썸네일 경로는 null로 설정

                    System.out.println("파일 정보 DB 저장 시작: " + fileParam);
                    int result = postMapper.insertFileInfo(fileParam);
                    System.out.println("파일 정보 DB 저장 완료, 결과: " + result);
                } catch (IOException e) {
                    System.err.println("파일 저장 오류: " + originalFilename);
                    e.printStackTrace();
                } catch (Exception e) {
                    System.err.println("파일 DB 저장 오류: " + originalFilename);
                    e.printStackTrace();
                }
            }
            System.out.println("=== 파일 업로드 완료 ===");
        } catch (Exception e) {
            System.err.println("=== 파일 업로드 전체 오류 ===");
            e.printStackTrace();
        }
    }
}
