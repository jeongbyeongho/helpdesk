package com.helpdesk.admin.menu.controller;

import com.helpdesk.admin.menu.service.MenuService;
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
@RequestMapping("/admin/menu")
public class MenuController {

    @Autowired
    private MenuService menuService;

    /** 메뉴 목록 (트리 구조) */
    @GetMapping("/list")
    public String list(HttpServletRequest request, Model model) {
        String sysId = SessionUtil.getLoginSysId(request);
        model.addAttribute("menuList", menuService.getMenuList(sysId));
        model.addAttribute("sysId", sysId);
        model.addAttribute("pageTitle", "메뉴관리");
        return "admin/menu/list";
    }

    /** 메뉴 상세 (Ajax) */
    @GetMapping("/info")
    @ResponseBody
    public Map<String, Object> info(@RequestParam int menuId, HttpServletRequest request) {
        Map<String, Object> result = menuService.getMenuInfo(menuId);
        result.put("roleList", menuService.getMenuRoleList(menuId));
        return result;
    }

    /** 메뉴 등록 폼 */
    @GetMapping("/form")
    public String form(@RequestParam(required = false) Integer menuId,
                       HttpServletRequest request, Model model) {
        String sysId = SessionUtil.getLoginSysId(request);
        model.addAttribute("upperMenuList", menuService.getUpperMenuList(sysId));
        model.addAttribute("connectMenuList", menuService.getConnectMenuList(sysId));
        model.addAttribute("boardList", menuService.getBoardListForMenu(sysId));
        model.addAttribute("nextSortOrder", menuService.getNextSortOrder(sysId));
        if (menuId != null) {
            model.addAttribute("menuInfo", menuService.getMenuInfo(menuId));
        }
        model.addAttribute("pageTitle", menuId != null ? "메뉴 수정" : "메뉴 등록");
        return "admin/menu/form";
    }

    /** 메뉴 등록 처리 */
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> param, HttpServletRequest request) {
        param.put("sysId", SessionUtil.getLoginSysId(request));
        menuService.insertMenu(param);
        return "redirect:/admin/menu/list";
    }

    /** 메뉴 수정 처리 */
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> param) {
        menuService.updateMenu(param);
        return "redirect:/admin/menu/list";
    }

    /** 메뉴 순서 저장 (Ajax - drag & drop) */
    @PostMapping("/sort")
    @ResponseBody
    public Map<String, Object> sort(@RequestBody List<Map<String, Object>> sortList) {
        menuService.updateMenuSortOrder(sortList);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 메뉴 삭제 (Ajax) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam int menuId) {
        menuService.deleteMenu(menuId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 메뉴 권한 저장 (Ajax) */
    @PostMapping("/role/save")
    @ResponseBody
    public Map<String, Object> saveRoles(@RequestParam int menuId,
                                         @RequestParam(required = false) String menuType,
                                         @RequestParam(required = false) Integer contentId,
                                         @RequestParam(required = false) List<Integer> roleNos) {
        menuService.saveMenuRoles(menuId, menuType, contentId, roleNos);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
}
