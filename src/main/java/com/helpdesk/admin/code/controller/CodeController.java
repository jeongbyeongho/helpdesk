package com.helpdesk.admin.code.controller;

import com.helpdesk.admin.code.service.CodeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/code")
public class CodeController {

    @Autowired
    private CodeService codeService;

    /** 코드 그룹 목록 */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize,
                       @RequestParam(required = false) String keyword,
                       Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);

        Map<String, Object> result = codeService.getCodeGroupListPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("pageTitle", "공통코드관리");
        return "admin/code/list";
    }

    /** 코드 상세 목록 */
    @GetMapping("/detail")
    public String detail(@RequestParam String codeGroup, Model model) {
        model.addAttribute("codeGroupInfo", codeService.getCodeGroupInfo(codeGroup));
        model.addAttribute("codeDetailList", codeService.getCodeDetailList(codeGroup));
        model.addAttribute("pageTitle", "코드 상세");
        return "admin/code/detail";
    }

    /** 코드 그룹 등록 (Ajax) */
    @PostMapping("/insertGroup")
    @ResponseBody
    public Map<String, Object> groupInsert(@RequestParam Map<String, Object> param) {
        codeService.insertCodeGroup(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 코드 그룹 수정 (Ajax) */
    @PostMapping("/updateGroup")
    @ResponseBody
    public Map<String, Object> groupUpdate(@RequestParam Map<String, Object> param) {
        codeService.updateCodeGroup(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 코드 그룹 삭제 (Ajax) */
    @PostMapping("/deleteGroup")
    @ResponseBody
    public Map<String, Object> groupDelete(@RequestParam String codeGroup) {
        codeService.deleteCodeGroup(codeGroup);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 코드 그룹 정보 조회 (Ajax) */
    @GetMapping("/groupInfo")
    @ResponseBody
    public Map<String, Object> getGroupInfo(@RequestParam String codeGroup) {
        return codeService.getCodeGroupInfo(codeGroup);
    }

    /** 코드 상세 등록 (Ajax) */
    @PostMapping("/detail/insert")
    @ResponseBody
    public Map<String, Object> detailInsert(@RequestParam Map<String, Object> param) {
        codeService.insertCodeDetail(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 코드 상세 수정 (Ajax) */
    @PostMapping("/detail/update")
    @ResponseBody
    public Map<String, Object> detailUpdate(@RequestParam Map<String, Object> param) {
        codeService.updateCodeDetail(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 코드 상세 삭제 (Ajax) */
    @PostMapping("/detail/delete")
    @ResponseBody
    public Map<String, Object> detailDelete(@RequestParam Map<String, Object> param) {
        codeService.deleteCodeDetail(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 코드 순서 저장 (Ajax) */
    @PostMapping("/detail/sort")
    @ResponseBody
    public Map<String, Object> detailSort(@RequestBody List<Map<String, Object>> orderList) {
        codeService.updateCodeDetailOrder(orderList);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 코드 그룹별 코드 목록 조회 (Ajax) */
    @GetMapping("/api/codes")
    @ResponseBody
    public List<Map<String, Object>> getCodesByGroup(@RequestParam String codeGroup) {
        return codeService.getCodeDetailList(codeGroup);
    }
}
