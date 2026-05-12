package com.helpdesk.admin.stats.controller;

import com.helpdesk.admin.stats.service.StatsService;
import com.helpdesk.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/stats")
public class StatsController {

    @Autowired
    private StatsService statsService;

    /** 통계 대시보드 */
    @GetMapping("/dashboard")
    public String dashboard(HttpServletRequest request, Model model) {
        String sysId = SessionUtil.getLoginSysId(request);
        model.addAttribute("postStatusStats", statsService.getPostStatusStats(sysId));

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", sysId);
        model.addAttribute("dailyStats", statsService.getDailyStats(param));
        model.addAttribute("pageTitle", "통계 대시보드");
        return "admin/stats/dashboard";
    }

    /** 접속 통계 */
    @GetMapping("/access")
    public String access(@RequestParam(required = false) String startDate,
                        @RequestParam(required = false) String endDate,
                        HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", SessionUtil.getLoginSysId(request));
        param.put("startDate", startDate != null ? startDate : java.time.LocalDate.now().minusDays(7).toString());
        param.put("endDate", endDate != null ? endDate : java.time.LocalDate.now().toString());

        model.addAttribute("accessSummary", statsService.getAccessStatsSummary(param));
        model.addAttribute("dailyAccessStats", statsService.getDailyAccessStats(param));
        model.addAttribute("pageAccessStats", statsService.getPageAccessStats(param));
        model.addAttribute("browserStats", statsService.getBrowserStats(param));
        model.addAttribute("osStats", statsService.getOsStats(param));
        model.addAttribute("startDate", param.get("startDate"));
        model.addAttribute("endDate", param.get("endDate"));
        model.addAttribute("pageTitle", "접속 통계");
        return "admin/stats/access";
    }

    /** 사용자 접속 로그 */
    @GetMapping("/user-access")
    public String userAccess(@RequestParam(defaultValue = "1") int page,
                             @RequestParam(defaultValue = "20") int pageSize,
                             @RequestParam(required = false) String userId,
                             @RequestParam(required = false) String beginDt,
                             @RequestParam(required = false) String endDt,
                             HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", SessionUtil.getLoginSysId(request));
        param.put("userId", userId);
        param.put("beginDt", beginDt);
        param.put("endDt", endDt);

        Map<String, Object> result = statsService.getUserAccessLogPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("pageTitle", "사용자 접속 로그");
        return "admin/stats/user_access";
    }

    /** 관리자 접속 로그 */
    @GetMapping("/admin-access")
    public String adminAccess(@RequestParam(defaultValue = "1") int page,
                              @RequestParam(defaultValue = "20") int pageSize,
                              @RequestParam(required = false) String userId,
                              @RequestParam(required = false) String beginDt,
                              @RequestParam(required = false) String endDt,
                              HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", SessionUtil.getLoginSysId(request));
        param.put("userId", userId);
        param.put("beginDt", beginDt);
        param.put("endDt", endDt);

        Map<String, Object> result = statsService.getAdminAccessLogPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("pageTitle", "관리자 접속 로그");
        return "admin/stats/admin_access";
    }

    /** 방문 통계 */
    @GetMapping("/visit")
    public String visit(@RequestParam(required = false) String beginDt,
                        @RequestParam(required = false) String endDt,
                        HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", SessionUtil.getLoginSysId(request));
        param.put("beginDt", beginDt);
        param.put("endDt", endDt);

        model.addAttribute("visitStats", statsService.getVisitStats(param));
        model.addAttribute("pageTitle", "방문 통계");
        return "admin/stats/visit";
    }

    /** 메뉴 통계 */
    @GetMapping("/menu")
    public String menu(@RequestParam(required = false) String beginDt,
                       @RequestParam(required = false) String endDt,
                       HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", SessionUtil.getLoginSysId(request));
        param.put("beginDt", beginDt);
        param.put("endDt", endDt);

        model.addAttribute("menuStats", statsService.getMenuStats(param));
        model.addAttribute("pageTitle", "메뉴 통계");
        return "admin/stats/menu";
    }
}
