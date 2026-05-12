package com.helpdesk.user.post.controller;

import com.helpdesk.user.post.service.PostService;
import com.helpdesk.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user/post")
public class PostController {

    @Autowired
    private PostService postService;

    @Value("${file.upload-path}")
    private String uploadPath;

    /** 게시물 목록 */
    @GetMapping("/list")
    public String list(@RequestParam int boardId,
                       @RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize,
                       @RequestParam(required = false) String postStatus,
                       @RequestParam(required = false) String searchType,
                       @RequestParam(required = false) String keyword,
                       @RequestParam(required = false, defaultValue = "N") String searchOnlyMine,
                       HttpServletRequest request, Model model) {

        try {
            Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
            if (loginUser == null) {
                return "redirect:/auth/login";
            }
            
            Map<String, Object> param = new HashMap<>();
            param.put("boardId", boardId);
            param.put("postStatus", postStatus);
            param.put("searchType", searchType);
            param.put("keyword", keyword);
            param.put("searchOnlyMine", searchOnlyMine);
            
            // 사용자 ID 가져오기 (다양한 키 이름 지원)
            String userId = (String) loginUser.get("user_id");
            if (userId == null) userId = (String) loginUser.get("userId");
            param.put("userId", userId);
            
            // 관리자 여부 확인
            Object roleCodeObj = loginUser.get("roleCode");
            if (roleCodeObj == null) roleCodeObj = loginUser.get("role_code");
            boolean isAdmin = roleCodeObj != null && Integer.parseInt(String.valueOf(roleCodeObj)) <= 2;
            
            // 관리자가 아니고 "내 문의만" 체크가 안되어 있으면 자동으로 내 문의만 보기
            if (!isAdmin && !"Y".equals(searchOnlyMine)) {
                param.put("searchOnlyMine", "Y");
                searchOnlyMine = "Y";
            }

            Map<String, Object> result = postService.getPostListPage(param, page, pageSize);
            model.addAllAttributes(result);
            model.addAttribute("boardId", boardId);
            model.addAttribute("pageTitle", result.get("boardTitle"));
            model.addAttribute("isAdmin", isAdmin);
            model.addAttribute("searchOnlyMine", searchOnlyMine);
            model.addAttribute("currentPage", page);
            model.addAttribute("pageSize", pageSize);
            
            return "user/post/list";
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("errorMsg", "게시물 목록을 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            return "common/error";
        }
    }

    /** 게시물 상세 */
    @GetMapping("/view")
    public String view(@RequestParam int boardId,
                       @RequestParam int postSeq,
                       HttpServletRequest request, Model model) {

        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        
        // 조회수 증가
        postService.increaseReadCount(boardId, postSeq);
        
        // 게시물 정보
        Map<String, Object> postInfo = postService.getPostInfo(boardId, postSeq);
        
        // 권한 체크
        String ownerUserId = (String) postInfo.get("reg_id");
        String currentUserId = (String) loginUser.get("user_id");
        if (currentUserId == null) currentUserId = (String) loginUser.get("userId");
        
        boolean isOwner = ownerUserId != null && ownerUserId.equals(currentUserId);
        Object roleCodeObj = loginUser.get("roleCode");
        if (roleCodeObj == null) roleCodeObj = loginUser.get("role_code");
        boolean isAdmin = roleCodeObj != null && Integer.parseInt(String.valueOf(roleCodeObj)) <= 2;
        
        model.addAttribute("postInfo", postInfo);
        model.addAttribute("fileList", postService.getFileList(boardId, postSeq));
        model.addAttribute("replyList", postService.getReplyList(boardId, postSeq));
        model.addAttribute("isOwner", isOwner);
        model.addAttribute("isAdmin", isAdmin);
        model.addAttribute("pageTitle", "게시물 상세");
        return "user/post/view";
    }

    /** 게시물 등록 폼 */
    @GetMapping("/form")
    public String form(@RequestParam int boardId,
                       @RequestParam(required = false) Integer postSeq,
                       Model model) {
        
        model.addAttribute("boardId", boardId);
        
        // 게시판 정보 조회
        Map<String, Object> boardInfo = postService.getBoardInfo(boardId);
        if (boardInfo == null) {
            model.addAttribute("errorMsg", "존재하지 않는 게시판입니다.");
            return "common/error";
        }
        
        // 허용 확장자 설정 (게시판 설정이 없으면 시스템 기본값 사용)
        String allowedExt = (String) boardInfo.get("allowed_ext");
        if (allowedExt == null || allowedExt.trim().isEmpty()) {
            allowedExt = "jpg,jpeg,png,gif,pdf,doc,docx,xls,xlsx,ppt,pptx,hwp,txt,zip";
        }
        boardInfo.put("allowed_ext", allowedExt);
        
        // 파일 최대 개수 설정
        Object fileMaxCntObj = boardInfo.get("file_max_cnt");
        int fileMaxCnt = 5; // 기본값
        if (fileMaxCntObj != null) {
            if (fileMaxCntObj instanceof Integer) {
                fileMaxCnt = (Integer) fileMaxCntObj;
            } else if (fileMaxCntObj instanceof String) {
                try {
                    fileMaxCnt = Integer.parseInt((String) fileMaxCntObj);
                } catch (NumberFormatException e) {
                    fileMaxCnt = 5;
                }
            }
        }
        boardInfo.put("file_max_cnt", fileMaxCnt);
        
        model.addAttribute("boardInfo", boardInfo);
        
        if (postSeq != null) {
            model.addAttribute("postInfo", postService.getPostInfo(boardId, postSeq));
            model.addAttribute("fileList", postService.getFileList(boardId, postSeq));
            model.addAttribute("pageTitle", "게시물 수정");
        } else {
            model.addAttribute("pageTitle", "게시물 등록");
        }
        return "user/post/form";
    }

    /** 게시물 등록 처리 */
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> param,
                         @RequestParam(required = false) List<MultipartFile> files,
                         HttpServletRequest request, Model model) {
        
        try {
            System.out.println("=== PostController.insert 시작 ===");
            
            Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
            if (loginUser == null) {
                System.out.println("로그인 사용자 정보가 없습니다.");
                return "redirect:/auth/login";
            }
            
            System.out.println("로그인 사용자: " + loginUser);
            
            // 사용자 정보 설정 (다양한 키 이름 지원)
            String userId = (String) loginUser.get("user_id");
            if (userId == null) userId = (String) loginUser.get("userId");
            String userNm = (String) loginUser.get("user_nm");
            if (userNm == null) userNm = (String) loginUser.get("userNm");
            
            if (userId == null || userId.trim().isEmpty()) {
                throw new RuntimeException("사용자 ID를 가져올 수 없습니다.");
            }
            
            param.put("regId", userId);
            param.put("regNm", userNm != null ? userNm : userId);
            param.put("regIp", request.getRemoteAddr());
            
            System.out.println("=== 게시물 등록 파라미터 ===");
            System.out.println("boardId: " + param.get("boardId"));
            System.out.println("postTitle: " + param.get("postTitle"));
            System.out.println("postContent 길이: " + (param.get("postContent") != null ? param.get("postContent").toString().length() : 0));
            System.out.println("regId: " + param.get("regId"));
            System.out.println("regNm: " + param.get("regNm"));
            System.out.println("regIp: " + param.get("regIp"));
            System.out.println("files: " + (files != null ? files.size() : 0));
            
            // 필수 파라미터 검증
            if (param.get("boardId") == null) {
                throw new RuntimeException("게시판 ID가 누락되었습니다.");
            }
            if (param.get("postTitle") == null || param.get("postTitle").toString().trim().isEmpty()) {
                throw new RuntimeException("제목이 누락되었습니다.");
            }
            if (param.get("postContent") == null || param.get("postContent").toString().trim().isEmpty()) {
                throw new RuntimeException("내용이 누락되었습니다.");
            }
            
            int postSeq = postService.insertPost(param, files);
            System.out.println("등록된 postSeq: " + postSeq);
            
            System.out.println("=== PostController.insert 완료 ===");
            return "redirect:/user/post/view?boardId=" + param.get("boardId") + "&postSeq=" + postSeq;
            
        } catch (Exception e) {
            System.err.println("=== PostController.insert 오류 ===");
            System.err.println("오류 메시지: " + e.getMessage());
            e.printStackTrace();
            
            model.addAttribute("errorMsg", "게시물 등록 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("boardId", param.get("boardId"));
            return "common/error";
        }
    }

    /** 게시물 수정 처리 */
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> param,
                         @RequestParam(required = false) List<MultipartFile> files,
                         @RequestParam(required = false) List<Integer> deleteFileSeqs) {
        
        postService.updatePost(param, files, deleteFileSeqs);
        return "redirect:/user/post/view?boardId=" + param.get("boardId") + "&postSeq=" + param.get("postSeq");
    }

    /** 게시물 삭제 (Ajax) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam int boardId,
                                      @RequestParam int postSeq,
                                      HttpServletRequest request) {
        
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        Map<String, Object> postInfo = postService.getPostInfo(boardId, postSeq);
        
        Map<String, Object> result = new HashMap<>();
        
        // 권한 체크
        String ownerUserId = (String) postInfo.get("reg_id");
        String currentUserId = (String) loginUser.get("user_id");
        if (currentUserId == null) currentUserId = (String) loginUser.get("userId");
        
        boolean isOwner = ownerUserId != null && ownerUserId.equals(currentUserId);
        Object roleCodeObj = loginUser.get("roleCode");
        if (roleCodeObj == null) roleCodeObj = loginUser.get("role_code");
        boolean isAdmin = roleCodeObj != null && Integer.parseInt(String.valueOf(roleCodeObj)) <= 2;
        
        if (isOwner || isAdmin) {
            postService.deletePost(boardId, postSeq);
            result.put("success", true);
        } else {
            result.put("success", false);
            result.put("message", "삭제 권한이 없습니다.");
        }
        
        return result;
    }

    /** 게시물 상태 변경 (Ajax) */
    @PostMapping("/status")
    @ResponseBody
    public Map<String, Object> updateStatus(@RequestParam int boardId,
                                            @RequestParam int postSeq,
                                            @RequestParam String postStatus) {
        
        postService.updatePostStatus(boardId, postSeq, postStatus);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 답변 등록 (Ajax) */
    @PostMapping("/reply/insert")
    @ResponseBody
    public Map<String, Object> insertReply(@RequestParam Map<String, Object> param,
                                           HttpServletRequest request) {
        
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        
        // 사용자 정보 설정 (다양한 키 이름 지원)
        String userId = (String) loginUser.get("user_id");
        if (userId == null) userId = (String) loginUser.get("userId");
        String userNm = (String) loginUser.get("user_nm");
        if (userNm == null) userNm = (String) loginUser.get("userNm");
        
        param.put("regId", userId);
        param.put("regNm", userNm);
        param.put("regIp", request.getRemoteAddr());
        
        postService.insertReply(param);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 답변 수정 (Ajax) */
    @PostMapping("/reply/update")
    @ResponseBody
    public Map<String, Object> updateReply(@RequestParam Map<String, Object> param) {
        postService.updateReply(param);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 답변 삭제 (Ajax) */
    @PostMapping("/reply/delete")
    @ResponseBody
    public Map<String, Object> deleteReply(@RequestParam int boardId,
                                           @RequestParam int replySeq) {
        
        postService.deleteReply(boardId, replySeq);
        
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 파일 다운로드 */
    @GetMapping("/file/download")
    public ResponseEntity<Resource> downloadFile(@RequestParam int fileSeq) throws UnsupportedEncodingException {
        
        Map<String, Object> fileInfo = postService.getFileInfo(fileSeq);
        
        if (fileInfo == null) {
            return ResponseEntity.notFound().build();
        }
        
        // 다운로드 수 증가
        postService.increaseDownloadCount(fileSeq);
        
        String filePath = (String) fileInfo.get("file_path");
        String fileNm = (String) fileInfo.get("file_nm");
        
        File file = new File(uploadPath + File.separator + filePath);
        
        if (!file.exists()) {
            return ResponseEntity.notFound().build();
        }
        
        Resource resource = new FileSystemResource(file);
        
        String encodedFileName = URLEncoder.encode(fileNm, "UTF-8").replaceAll("\\+", "%20");
        
        return ResponseEntity.ok()
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + encodedFileName + "\"")
                .body(resource);
    }
}
