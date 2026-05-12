package com.helpdesk.user.main.controller;

import com.helpdesk.common.util.SessionUtil;
import com.helpdesk.user.main.service.MainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/main")
public class MainController {

    @Autowired
    private MainService mainService;

    @GetMapping("")
    public String main(HttpServletRequest request, Model model) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        String userId = (String) loginUser.get("userId");
        
        // 나의 요청 현황 (실제 DB 조회)
        Map<String, Object> myStats = mainService.getMyStats(userId);
        
        // 전체 현황 (실제 DB 조회)
        Map<String, Object> totalStats = mainService.getTotalStats();
        
        // 공지사항 목록 조회
        List<Map<String, Object>> noticeList = mainService.getNoticeList();
        
        // 게시판 목록 조회
        List<Map<String, Object>> boardList = mainService.getBoardList();
        
        model.addAttribute("pageTitle", "메인");
        model.addAttribute("myStats", myStats);
        model.addAttribute("totalStats", totalStats);
        model.addAttribute("noticeList", noticeList);
        model.addAttribute("boardList", boardList);
        
        return "user/main";
    }
}
