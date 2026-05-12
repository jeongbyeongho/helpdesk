package com.helpdesk.admin.role.controller;

import com.helpdesk.admin.role.service.RoleService;
import com.helpdesk.common.util.SessionUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/admin/role")
public class RoleController {

    @Autowired
    private RoleService roleService;

    /** 권한 목록 */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize,
                       @RequestParam(required = false) String keyword,
                       HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", SessionUtil.getLoginSysId(request));
        param.put("keyword", keyword);
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        param.put("roleCode", loginUser.get("roleCode"));

        Map<String, Object> result = roleService.getRoleListPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("pageTitle", "권한관리");
        return "admin/role/list";
    }

    /** 권한 상세 */
    @GetMapping("/view")
    public String view(@RequestParam int roleSeq,
                       @RequestParam(defaultValue = "1") int page,
                       HttpServletRequest request, Model model) {
        String sysId = SessionUtil.getLoginSysId(request);
        Map<String, Object> roleInfo = roleService.getRoleInfo(roleSeq, sysId);
        int roleCode = Integer.parseInt(String.valueOf(roleInfo.get("roleCode")));

        Map<String, Object> param = new HashMap<>();
        param.put("roleCode", roleCode);
        param.put("sysId", sysId);

        Map<String, Object> userListResult = roleService.getUserListByRolePage(param, page, 10);

        model.addAttribute("roleInfo", roleInfo);
        model.addAllAttributes(userListResult);
        model.addAttribute("pageTitle", "권한 상세");
        return "admin/role/view";
    }

    /** 권한 등록 폼 */
    @GetMapping("/form")
    public String form(@RequestParam(required = false) Integer roleSeq,
                       HttpServletRequest request, Model model) {
        if (roleSeq != null) {
            model.addAttribute("roleInfo", roleService.getRoleInfo(roleSeq, SessionUtil.getLoginSysId(request)));
            model.addAttribute("pageTitle", "권한 수정");
        } else {
            model.addAttribute("pageTitle", "권한 등록");
        }
        return "admin/role/form";
    }

    /** 권한 등록 처리 */
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> param, HttpServletRequest request) {
        param.put("sysId", SessionUtil.getLoginSysId(request));
        roleService.insertRole(param);
        return "redirect:/admin/role/list";
    }

    /** 권한 수정 처리 */
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> param) {
        roleService.updateRole(param);
        return "redirect:/admin/role/view?roleSeq=" + param.get("roleSeq");
    }

    /** 권한 삭제 (Ajax) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam int roleSeq, @RequestParam int roleCode) {
        roleService.deleteRole(roleSeq, roleCode);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 권한 부여 (Ajax) */
    @PostMapping("/grant")
    @ResponseBody
    public Map<String, Object> grant(@RequestParam Map<String, Object> param, HttpServletRequest request) {
        param.put("sysId", SessionUtil.getLoginSysId(request));
        roleService.grantRole(param);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 권한 회수 (Ajax) */
    @PostMapping("/revoke")
    @ResponseBody
    public Map<String, Object> revoke(@RequestParam int userRoleSeq) {
        roleService.revokeRole(userRoleSeq);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }
}
