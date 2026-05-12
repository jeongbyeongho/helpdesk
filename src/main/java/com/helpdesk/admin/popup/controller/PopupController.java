package com.helpdesk.admin.popup.controller;

import com.helpdesk.admin.popup.service.PopupService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin/popup")
public class PopupController {

    @Autowired
    private PopupService popupService;

    /** 팝업 목록 */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize,
                       @RequestParam(required = false) String keyword,
                       Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);

        Map<String, Object> result = popupService.getPopupListPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("pageTitle", "팝업관리");
        return "admin/popup/list";
    }

    /** 팝업 상세 */
    @GetMapping("/view")
    public String view(@RequestParam int popupSeq, Model model) {
        model.addAttribute("popupInfo", popupService.getPopupInfo(popupSeq));
        model.addAttribute("pageTitle", "팝업 상세");
        return "admin/popup/view";
    }

    /** 팝업 등록/수정 폼 */
    @GetMapping("/form")
    public String form(@RequestParam(required = false) Integer popupSeq, Model model) {
        if (popupSeq != null) {
            model.addAttribute("popupInfo", popupService.getPopupInfo(popupSeq));
            model.addAttribute("pageTitle", "팝업 수정");
        } else {
            model.addAttribute("pageTitle", "팝업 등록");
        }
        return "admin/popup/form";
    }

    /** 팝업 등록 처리 */
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> param,
                         @RequestParam(required = false) List<Map<String, Object>> sysMapList) {
        popupService.insertPopup(param, sysMapList);
        return "redirect:/admin/popup/list";
    }

    /** 팝업 수정 처리 */
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> param,
                         @RequestParam(required = false) List<Map<String, Object>> sysMapList) {
        popupService.updatePopup(param, sysMapList);
        return "redirect:/admin/popup/view?popupSeq=" + param.get("popupSeq");
    }

    /** 팝업 삭제 (Ajax) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam int popupSeq) {
        popupService.deletePopup(popupSeq);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
}
