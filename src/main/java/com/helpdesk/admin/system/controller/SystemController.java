package com.helpdesk.admin.system.controller;

import com.helpdesk.admin.system.service.SystemService;
import com.helpdesk.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/system")
public class SystemController {

    @Autowired
    private SystemService systemService;

    /** 시스템 목록 */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize,
                       @RequestParam(required = false) String keyword,
                       HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        param.put("userId", loginUser.get("userId"));
        param.put("roleCode", loginUser.get("roleCode"));

        Map<String, Object> result = systemService.getSystemListPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("pageTitle", "시스템관리");
        return "admin/system/list";
    }

    /** 시스템 상세 */
    @GetMapping("/view")
    public String view(@RequestParam String sysId, Model model) {
        model.addAttribute("systemInfo", systemService.getSystemInfo(sysId));
        model.addAttribute("domainList", systemService.getDomainList(sysId));
        model.addAttribute("pageTitle", "시스템 상세");
        return "admin/system/view";
    }

    /** 시스템 등록/수정 폼 */
    @GetMapping("/form")
    public String form(@RequestParam(required = false) String sysId, Model model) {
        if (sysId != null) {
            model.addAttribute("systemInfo", systemService.getSystemInfo(sysId));
            model.addAttribute("pageTitle", "시스템 수정");
        } else {
            model.addAttribute("pageTitle", "시스템 등록");
        }
        return "admin/system/form";
    }

    /** 시스템 등록 처리 */
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> param, HttpServletRequest request) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        param.put("regId", loginUser.get("userId"));
        param.put("regNm", loginUser.get("userNm"));
        param.put("regIp", request.getRemoteAddr());
        systemService.insertSystem(param);
        return "redirect:/admin/system/list";
    }

    /** 시스템 수정 처리 */
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> param) {
        systemService.updateSystem(param);
        return "redirect:/admin/system/view?sysId=" + param.get("sysId");
    }

    /** 시스템 삭제 (Ajax) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam String sysId) {
        systemService.deleteSystem(sysId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 시스템ID 중복 확인 (Ajax) */
    @GetMapping("/checkId")
    @ResponseBody
    public boolean checkId(@RequestParam String sysId) {
        return systemService.checkSystemIdDup(sysId);
    }

    /** 도메인 목록 (Ajax) */
    @GetMapping("/domain/list")
    @ResponseBody
    public List<Map<String, Object>> domainList(@RequestParam String sysId) {
        return systemService.getDomainList(sysId);
    }

    /** 도메인 등록 (Ajax) */
    @PostMapping("/domain/insert")
    @ResponseBody
    public Map<String, Object> domainInsert(@RequestParam Map<String, Object> param) {
        systemService.insertDomain(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 도메인 수정 (Ajax) */
    @PostMapping("/domain/update")
    @ResponseBody
    public Map<String, Object> domainUpdate(@RequestParam Map<String, Object> param) {
        systemService.updateDomain(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 도메인 삭제 (Ajax) */
    @PostMapping("/domain/delete")
    @ResponseBody
    public Map<String, Object> domainDelete(@RequestParam int domainSeq) {
        systemService.deleteDomain(domainSeq);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 부서 목록 (Ajax) */
    @GetMapping("/dept/list")
    @ResponseBody
    public List<Map<String, Object>> deptList(@RequestParam String orgCode) {
        return systemService.getDeptList(orgCode);
    }

    /** 부서 등록 (Ajax) */
    @PostMapping("/dept/insert")
    @ResponseBody
    public Map<String, Object> deptInsert(@RequestParam Map<String, Object> param, HttpServletRequest request) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        param.put("regId", loginUser.get("userId"));
        param.put("regNm", loginUser.get("userNm"));
        param.put("regIp", request.getRemoteAddr());
        systemService.insertDept(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 부서 수정 (Ajax) */
    @PostMapping("/dept/update")
    @ResponseBody
    public Map<String, Object> deptUpdate(@RequestParam Map<String, Object> param) {
        systemService.updateDept(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 부서 삭제 (Ajax) */
    @PostMapping("/dept/delete")
    @ResponseBody
    public Map<String, Object> deptDelete(@RequestParam int deptSeq) {
        systemService.deleteDept(deptSeq);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
}
