package com.example.demo.controller;

import com.example.demo.bean.*;
import com.example.demo.service.InsurerService;
import com.example.demo.dao.CredentialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/insurer")
public class InsurerController {
    
    @Autowired
    private InsurerService insurerService;
    
    @Autowired
    private CredentialRepository credentialRepository;
    
    // Helper method to get insurer info
    private Map<String, Object> getInsurerInfo(int insurerId) {
        Credentials creds = credentialRepository.findByInsurerInsurerId(insurerId)
            .orElseThrow(() -> new RuntimeException("Insurer not found with ID: " + insurerId));
        
        return Map.of(
            "insurerId", insurerId,
            "insurerName", creds.getInsurer().getPayerName(),
            "credentials", creds
        );
    }
    
    // Insurer Dashboard
    @GetMapping("/dashboard")
    public String showDashboard(@RequestParam("insurerId") int insurerId, Model model) {
        try {
            Map<String, Object> insurerInfo = getInsurerInfo(insurerId);
            
            List<Claim> primaryClaims = insurerService.getClaimsForPrimaryInsurer(insurerId);
            List<Claim> secondaryClaims = insurerService.getClaimsForSecondaryInsurer(insurerId);
            
            model.addAttribute("primaryClaimsCount", primaryClaims.size());
            model.addAttribute("secondaryClaimsCount", secondaryClaims.size());
            model.addAttribute("insurerId", insurerId);
            model.addAttribute("insurerName", insurerInfo.get("insurerName"));
            
            return "insurer-dashboard";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading dashboard: " + e.getMessage());
            return "error";
        }
    }
    
    // View Primary Claims (status = 'submitted')
    @GetMapping("/primary-claims")
    public String viewPrimaryClaims(@RequestParam("insurerId") int insurerId, Model model) {
        try {
            Map<String, Object> insurerInfo = getInsurerInfo(insurerId);
            List<Claim> primaryClaims = insurerService.getClaimsForPrimaryInsurer(insurerId);
            
            model.addAttribute("claims", primaryClaims);
            model.addAttribute("claimType", "Primary");
            model.addAttribute("insurerId", insurerId);
            model.addAttribute("insurerName", insurerInfo.get("insurerName"));
            
            return "insurer-claims-list";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claims: " + e.getMessage());
            return "error";
        }
    }
    
    // View Secondary Claims (status = 'pending')
    @GetMapping("/secondary-claims")
    public String viewSecondaryClaims(@RequestParam("insurerId") int insurerId, Model model) {
        try {
            Map<String, Object> insurerInfo = getInsurerInfo(insurerId);
            List<Claim> secondaryClaims = insurerService.getClaimsForSecondaryInsurer(insurerId);
            
            model.addAttribute("claims", secondaryClaims);
            model.addAttribute("claimType", "Secondary");
            model.addAttribute("insurerId", insurerId);
            model.addAttribute("insurerName", insurerInfo.get("insurerName"));
            
            return "insurer-claims-list";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claims: " + e.getMessage());
            return "error";
        }
    }
    
    // View Claim Details
    @GetMapping("/claim/{claimId}")
    public String viewClaimDetails(@PathVariable("claimId") int claimId,
                                  @RequestParam("insurerId") int insurerId,
                                  Model model) {
        try {
            Map<String, Object> insurerInfo = getInsurerInfo(insurerId);
            Claim claim = insurerService.getClaimById(claimId);
            
            if (claim == null) {
                model.addAttribute("error", "Claim not found");
                return "error";
            }
            
            // Check if this insurer can process this claim
            String canProcess = "none";
            if (claim.getPrimaryInsurer() != null && claim.getPrimaryInsurer().getInsurerId() == insurerId) {
                canProcess = "primary";
            } else if (claim.getSecondaryInsurer() != null && claim.getSecondaryInsurer().getInsurerId() == insurerId) {
                canProcess = "secondary";
            }
            
            model.addAttribute("claim", claim);
            model.addAttribute("canProcess", canProcess);
            model.addAttribute("insurerId", insurerId);
            model.addAttribute("insurerName", insurerInfo.get("insurerName"));
            
            // Get EOB details if available
            if ("processed".equals(claim.getStatus()) || "paid".equals(claim.getStatus())) {
                Map<String, Object> eobDetails = insurerService.getEOBDetails(claimId);
                model.addAttribute("eobDetails", eobDetails);
            }
            
            return "insurer-claim-details";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claim details: " + e.getMessage());
            return "error";
        }
    }
    
    // Process as Primary Insurer
    @PostMapping("/process-primary/{claimId}")
    public String processAsPrimary(@PathVariable("claimId") int claimId,
                                  @RequestParam("insurerId") int insurerId,
                                  RedirectAttributes redirectAttributes) {
        try {
            EOB1 eob1 = insurerService.processAsPrimaryInsurer(claimId, insurerId);
            
            redirectAttributes.addFlashAttribute("success", 
                "Claim processed successfully! Created EOB #" + eob1.getEob1Id());
            
            return "redirect:/insurer/primary-claims?insurerId=" + insurerId;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Error processing claim: " + e.getMessage());
            return "redirect:/insurer/primary-claims?insurerId=" + insurerId;
        }
    }
    
    // Process as Secondary Insurer
    @PostMapping("/process-secondary/{claimId}")
    public String processAsSecondary(@PathVariable("claimId") int claimId,
                                    @RequestParam("insurerId") int insurerId,
                                    RedirectAttributes redirectAttributes) {
        try {
            EOB2 eob2 = insurerService.processAsSecondaryInsurer(claimId, insurerId);
            
            redirectAttributes.addFlashAttribute("success", 
                "Claim processed successfully! Created EOB #" + eob2.getEob2Id());
            
            return "redirect:/insurer/secondary-claims?insurerId=" + insurerId;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Error processing claim: " + e.getMessage());
            return "redirect:/insurer/secondary-claims?insurerId=" + insurerId;
        }
    }
    
    // View EOB Details
    @GetMapping("/eob/{claimId}")
    public String viewEOBDetails(@PathVariable("claimId") int claimId,
                                @RequestParam("insurerId") int insurerId,
                                Model model) {
        try {
            Map<String, Object> insurerInfo = getInsurerInfo(insurerId);
            Map<String, Object> eobDetails = insurerService.getEOBDetails(claimId);
            Claim claim = insurerService.getClaimById(claimId);
            
            model.addAttribute("eobDetails", eobDetails);
            model.addAttribute("claim", claim);
            model.addAttribute("insurerId", insurerId);
            model.addAttribute("insurerName", insurerInfo.get("insurerName"));
            
            return "insurer-eob-details";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading EOB details: " + e.getMessage());
            return "error";
        }
    }
    
 // View History (processed/paid claims)
    @GetMapping("/history")
    public String viewHistory(@RequestParam("insurerId") int insurerId, Model model) {
        try {
            Map<String, Object> insurerInfo = getInsurerInfo(insurerId);
            
            // Get claims where this insurer was primary and status is processed/paid
            List<Claim> primaryHistory = new ArrayList<>();
            
            // Add processed claims
            List<Claim> primaryProcessed = insurerService.getClaimsByPrimaryInsurerAndStatus(insurerId, "processed");
            if (primaryProcessed != null) primaryHistory.addAll(primaryProcessed);
            
            // Add paid claims
            List<Claim> primaryPaid = insurerService.getClaimsByPrimaryInsurerAndStatus(insurerId, "paid");
            if (primaryPaid != null) primaryHistory.addAll(primaryPaid);
            
            // Get claims where this insurer was secondary and status is processed/paid
            List<Claim> secondaryHistory = new ArrayList<>();
            
            List<Claim> secondaryProcessed = insurerService.getClaimsBySecondaryInsurerAndStatus(insurerId, "processed");
            if (secondaryProcessed != null) secondaryHistory.addAll(secondaryProcessed);
            
            List<Claim> secondaryPaid = insurerService.getClaimsBySecondaryInsurerAndStatus(insurerId, "paid");
            if (secondaryPaid != null) secondaryHistory.addAll(secondaryPaid);
            
            model.addAttribute("primaryHistory", primaryHistory);
            model.addAttribute("secondaryHistory", secondaryHistory);
            model.addAttribute("insurerId", insurerId);
            model.addAttribute("insurerName", insurerInfo.get("insurerName"));
            
            return "insurer-history";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading history: " + e.getMessage());
            return "error";
        }
}
}