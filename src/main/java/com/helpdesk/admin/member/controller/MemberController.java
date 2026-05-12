package com.helpdesk.admin.member.controller;

import com.helpdesk.admin.member.service.MemberService;
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
@RequestMapping("/admin/member")
public class MemberController {

    @Autowired
    private MemberService memberService;

    /** 회원 목록 */
    @GetMapping("/list")
    public String list(@RequestParam(defaultValue = "1") int page,
                       @RequestParam(defaultValue = "10") int pageSize,
                       @RequestParam(required = false) String approvalYn,
                       @RequestParam(required = false) String userType,
                       @RequestParam(required = false) String keyword,
                       HttpServletRequest request, Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("sysId", SessionUtil.getLoginSysId(request));
        param.put("approvalYn", approvalYn);
        param.put("userType", userType);
        param.put("keyword", keyword);

        Map<String, Object> result = memberService.getMemberListPage(param, page, pageSize);
        model.addAllAttributes(result);
        model.addAttribute("pageTitle", "회원관리");
        return "admin/member/list";
    }

    /** 회원 상세 */
    @GetMapping("/view")
    public String view(@RequestParam String userId,
                       HttpServletRequest request, Model model) {
        String sysId = SessionUtil.getLoginSysId(request);
        Map<String, Object> memberInfo = memberService.getMemberInfo(userId, sysId);
        model.addAttribute("memberInfo", memberInfo);
        model.addAttribute("pageTitle", "회원 상세");
        return "admin/member/view";
    }

    /** 회원 등록 폼 */
    @GetMapping("/form")
    public String form(Model model) {
        model.addAttribute("pageTitle", "회원 등록");
        return "admin/member/form";
    }

    /** 회원 수정 폼 */
    @GetMapping("/form/{userId}")
    public String editForm(@PathVariable String userId,
                           HttpServletRequest request, Model model) {
        String sysId = SessionUtil.getLoginSysId(request);
        model.addAttribute("memberInfo", memberService.getMemberInfo(userId, sysId));
        model.addAttribute("pageTitle", "회원 수정");
        return "admin/member/form";
    }

    /** 회원 등록 처리 */
    @PostMapping("/insert")
    public String insert(@RequestParam Map<String, Object> param,
                         HttpServletRequest request) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        param.put("regId", loginUser.get("userId"));
        param.put("regNm", loginUser.get("userNm"));
        param.put("regIp", request.getRemoteAddr());
        memberService.insertMember(param);
        return "redirect:/admin/member/list";
    }

    /** 회원 수정 처리 */
    @PostMapping("/update")
    public String update(@RequestParam Map<String, Object> param) {
        memberService.updateMember(param);
        return "redirect:/admin/member/view?userId=" + param.get("userId");
    }

    /** 회원 승인 (Ajax) */
    @PostMapping("/approve")
    @ResponseBody
    public Map<String, Object> approve(@RequestParam String userId,
                                       HttpServletRequest request) {
        Map<String, Object> loginUser = SessionUtil.getLoginUser(request);
        memberService.approveMember(userId,
                SessionUtil.getLoginSysId(request),
                (String) loginUser.get("userId"),
                (String) loginUser.get("userNm"));

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 비밀번호 초기화 (Ajax) */
    @PostMapping("/resetPwd")
    @ResponseBody
    public Map<String, Object> resetPwd(@RequestParam String userId,
                                        @RequestParam String newPwd) {
        memberService.resetPassword(userId, newPwd);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 회원 삭제 (Ajax) */
    @PostMapping("/delete")
    @ResponseBody
    public Map<String, Object> delete(@RequestParam String userId) {
        memberService.deleteMember(userId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return result;
    }

    /** 아이디 중복 확인 (Ajax) */
    @GetMapping("/checkId")
    @ResponseBody
    public int checkId(@RequestParam String userId) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        Map<String, Object> info = memberService.getMemberInfo(userId, null);
        return info != null ? 1 : 0;
    }

    /** 부서 목록 (Ajax) */
    @GetMapping("/deptList")
    @ResponseBody
    public List<Map<String, Object>> deptList(@RequestParam String orgCode) {
        return memberService.getDeptList(orgCode);
    }
}
