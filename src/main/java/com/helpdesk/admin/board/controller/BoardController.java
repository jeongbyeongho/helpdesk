package com.helpdesk.admin.board.controller;

import com.helpdesk.admin.board.service.BoardService;
import com.helpdesk.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/board")
public class BoardController {

    @Autowired
    private BoardService boardService;

    /** 게시판 목록 */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize,
                       @RequestParam(required = false) String sysId,
                       @RequestParam(required = false) String boardType,
                       @RequestParam(required = false) String keyword,
                       HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        
        // sysId 파라미터가 없으면 세션에서 가져오기 (없으면 null로 전체 조회)
        if (sysId == null || sysId.isEmpty()) {
            sysId = SessionUtil.getLoginSysId(request);
        }
        param.put("sysId", sysId);
        param.put("boardType", boardType);
        param.put("keyword", keyword);

        Map<String, Object> result = boardService.getBoardListPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("sysList", boardService.getSystemList());
        model.addAttribute("selectedSysId", sysId);
        model.addAttribute("pageTitle", "게시판관리");
        return "admin/board/list";
    }

    /** 게시판 상세 */
    @GetMapping("/view")
    public String view(@RequestParam int boardId, Model model) {
        model.addAttribute("boardInfo", boardService.getBoardInfo(boardId));
        model.addAttribute("boardRoleCfg", boardService.getBoardRoleCfg(boardId));
        model.addAttribute("boardFieldList", boardService.getBoardFieldList(boardId));
        model.addAttribute("pageTitle", "게시판 상세");
        return "admin/board/view";
    }

    /** 게시판 등록/수정 폼 */
    @GetMapping("/form")
    public String form(@RequestParam(required = false) Integer boardId, 
                       HttpServletRequest request, Model model) {
        
        // 시스템 목록 조회
        model.addAttribute("sysList", boardService.getSystemList());
        
        if (boardId != null) {
            model.addAttribute("boardInfo", boardService.getBoardInfo(boardId));
            model.addAttribute("boardRoleCfg", boardService.getBoardRoleCfg(boardId));
            model.addAttribute("pageTitle", "게시판 수정");
        } else {
            model.addAttribute("pageTitle", "게시판 등록");
        }
        return "admin/board/form";
    }

    /** 게시판 등록 처리 */
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> param,
                         HttpServletRequest request) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        param.put("regId", loginUser.get("userId"));
        param.put("regNm", loginUser.get("userNm"));
        param.put("regIp", request.getRemoteAddr());
        boardService.insertBoard(param);
        return "redirect:/admin/board/list";
    }

    /** 게시판 수정 처리 */
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> param) {
        boardService.updateBoard(param);
        return "redirect:/admin/board/view?boardId=" + param.get("boardId");
    }

    /** 게시판 삭제 (Ajax) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam int boardId) {
        boardService.deleteBoard(boardId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 추가항목 등록 (Ajax) */
    @PostMapping("/field/insert")
    @ResponseBody
    public Map<String, Object> insertField(@RequestParam Map<String, Object> param) {
        boardService.insertBoardField(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 추가항목 수정 (Ajax) */
    @PostMapping("/field/update")
    @ResponseBody
    public Map<String, Object> updateField(@RequestParam Map<String, Object> param) {
        boardService.updateBoardField(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 추가항목 삭제 (Ajax) */
    @PostMapping("/field/delete")
    @ResponseBody
    public Map<String, Object> deleteField(@RequestParam int fieldSeq) {
        boardService.deleteBoardField(fieldSeq);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
}
