package com.helpdesk.user.faq.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/user/faq")
public class FaqController {

    /** FAQ 페이지 */
    @GetMapping("")
    public String faq(Model model) {
        model.addAttribute("pageTitle", "자주 묻는 질문");
        return "user/faq";
    }
}