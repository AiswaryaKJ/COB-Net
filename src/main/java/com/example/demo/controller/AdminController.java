package com.example.demo.controller;

import com.example.demo.bean.Claim;
import com.example.demo.bean.Provider;
import com.example.demo.service.AdminService;
import com.example.demo.service.ClaimService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final AdminService adminService;
    @Autowired
    ClaimService claimService;
    @Autowired
    public AdminController(AdminService adminService) {
        this.adminService = adminService;
    }

    // Show dashboard with providers list
    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        List<Provider> providers = adminService.getAllProviders();
        model.addAttribute("providers", providers);
   
        
        // Get all claims data
        List<Claim> claims = claimService.getAllClaims();
        model.addAttribute("claims", claims);
        
        // Get claims counts
        Map<String, Integer> claimsCount = claimService.getClaimsCountByStatus();
        model.addAttribute("submittedClaims", claimsCount.get("Submitted"));
        model.addAttribute("processedClaims", claimsCount.get("Processed"));
        model.addAttribute("approvedClaims", claimsCount.get("Approved"));
        model.addAttribute("deniedClaims", claimsCount.get("Denied"));
        model.addAttribute("pendingClaims", claimsCount.get("Pending"));
        
        // Get totals
        model.addAttribute("totalClaims", claimService.getTotalClaims());
        model.addAttribute("totalBilledAmount", claimService.getTotalBilledAmount());
        
        return "admin";
         // resolves to /WEB-INF/views/admin.jsp
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
    @GetMapping("/api/claims/refresh")
    @ResponseBody
    public Map<String, Object> refreshClaimsData() {
        Map<String, Object> response = new HashMap<>();
        
        // Get updated counts
        Map<String, Integer> claimsCount = claimService.getClaimsCountByStatus();
        response.put("submitted", claimsCount.get("Submitted"));
        response.put("processed", claimsCount.get("Processed"));
        response.put("approved", claimsCount.get("Approved"));
        response.put("denied", claimsCount.get("Denied"));
        response.put("pending", claimsCount.get("Pending"));
        response.put("total", claimService.getTotalClaims());
        response.put("totalAmount", claimService.getTotalBilledAmount());
        
        return response;
    }

    // Delete provider
    @GetMapping("/delete/{id}")
    public String deleteProvider(@PathVariable("id") int id) {
        adminService.deleteProvider(id); // cascade removes credentials automatically
        return "redirect:/admin/dashboard";
    }
}
