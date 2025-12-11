package com.example.demo.controller;

import com.example.demo.bean.Provider;
import com.example.demo.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;

    @Autowired
    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    // Show dashboard with providers list
    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        List<Provider> providers = adminService.getAllProviders();
        model.addAttribute("providers", providers);
        return "admin"; // resolves to /WEB-INF/views/admin.jsp
    }

    // Add provider
    @PostMapping("/add")
    public String addProvider(@ModelAttribute Provider provider) {
        adminService.addProvider(provider);
        return "redirect:/admin/dashboard";
    }

    // Edit provider
    @PostMapping("/edit")
    public String editProvider(@ModelAttribute Provider provider) {
        adminService.updateProvider(provider);
        return "redirect:/admin/dashboard";
    }

    // Delete provider
    @GetMapping("/delete/{id}")
    public String deleteProvider(@PathVariable("id") int id) {
        adminService.deleteProvider(id); // cascade removes credentials automatically
        return "redirect:/admin/dashboard";
    }
}
