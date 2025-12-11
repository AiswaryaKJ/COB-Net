package com.example.demo.controller;

import com.example.demo.bean.Claim;
import com.example.demo.bean.Settlement;
import com.example.demo.service.InsurerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequestMapping("/insurer")
public class InsurerController {
    
    @Autowired
    private InsurerService insurerService;
    
    // Insurer Dashboard
    @GetMapping("/dashboard")
    public String showDashboard(Model model) {
        List<Claim> pendingClaims = insurerService.getPendingClaims();
        List<Claim> processedClaims = insurerService.getProcessedClaims();
        
        model.addAttribute("pendingCount", pendingClaims.size());
        model.addAttribute("processedCount", processedClaims.size());
        
        return "insurer-dashboard";
    }
    
    // View Pending Claims
    @GetMapping("/pending")
    public String viewPendingClaims(Model model) {
        List<Claim> pendingClaims = insurerService.getPendingClaims();
        model.addAttribute("pendingClaims", pendingClaims);
        return "insurer-pending-claims";
    }
    
    // View Processed Claims
    @GetMapping("/processed")
    public String viewProcessedClaims(Model model) {
        List<Claim> processedClaims = insurerService.getProcessedClaims();
        model.addAttribute("processedClaims", processedClaims);
        return "insurer-processed-claims";
    }
    
    // Process a specific claim
    @PostMapping("/process/{claimId}")
    public String processClaim(@PathVariable("claimId") int claimId,
                               RedirectAttributes redirectAttributes) {
        try {
            Settlement settlement = insurerService.processClaim(claimId);
            
            redirectAttributes.addFlashAttribute("success", 
                "Claim processed successfully! Patient responsibility: $" + 
                String.format("%.2f", settlement.getTotalPatientResponsibility()));
            
            return "redirect:/insurer/pending";
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Error processing claim: " + e.getMessage());
            return "redirect:/insurer/pending";
        }
    }
    
    // View Settlement Details
    @GetMapping("/settlement/{claimId}")
    public String viewSettlement(@PathVariable("claimId") int claimId, Model model) {
        Settlement settlement = insurerService.getSettlementByClaimId(claimId);
        
        if (settlement != null) {
            model.addAttribute("settlement", settlement);
            return "insurer-settlement-details";
        } else {
            model.addAttribute("error", "Settlement not found");
            return "error";
        }
    }
}