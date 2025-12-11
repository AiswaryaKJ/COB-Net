package com.example.demo.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.example.demo.bean.Claim;
import com.example.demo.service.ProviderService;

@Controller
@RequestMapping("/provider")
public class ProviderController {
    
    private final ProviderService providerService;
    
    @Autowired
    public ProviderController(ProviderService providerService) {
        this.providerService = providerService;
    }
    
    // Welcome/Home Page
    @GetMapping("/welcome")
    public ModelAndView welcomePage() {
        return new ModelAndView("provider-welcome");
    }
    
    // Show claim submission form
    @GetMapping("/submitclaim")
    public ModelAndView showClaimForm() {
        ModelAndView mav = new ModelAndView("submit-claim");
        mav.addObject("claim", new Claim());
        return mav;
    }
    
    // Process claim submission
    @PostMapping("/submitclaim")
    public String submitClaim(@ModelAttribute("claim") Claim claim, Model model) {
        try {
            Claim savedClaim = providerService.submitClaim(claim);
            model.addAttribute("claimId", savedClaim.getClaimId());
            model.addAttribute("patientId", savedClaim.getPatient().getPatientId());
            model.addAttribute("billedAmount", savedClaim.getBilledAmount());
            return "claim-success";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "submit-claim";
        }
    }
    
    // View all claims
    @GetMapping("/viewclaims")
    public ModelAndView viewAllClaims() {
        ModelAndView mav = new ModelAndView("view-claims");
        List<Claim> claims = providerService.getAllClaims();
        mav.addObject("claims", claims);
        return mav;
    }
    
    // View claim by ID
    @GetMapping("/viewclaim")
    public String viewClaimById(@RequestParam("claimId") int claimId, Model model) {
        try {
            Claim claim = providerService.getClaimById(claimId);
            model.addAttribute("claim", claim);
            return "claim-details";
        } catch (Exception e) {
            model.addAttribute("error", "Claim not found: " + e.getMessage());
            return "view-claims";
        }
    }
    
    // Update claim status
    @PostMapping("/updatestatus")
    public String updateClaimStatus(@RequestParam("claimId") int claimId,
                                   @RequestParam("status") String status,
                                   Model model) {
        try {
            Claim updatedClaim = providerService.updateClaimStatus(claimId, status);
            model.addAttribute("message", "Status updated to: " + status);
            model.addAttribute("claim", updatedClaim);
            return "claim-details";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to update: " + e.getMessage());
            return "view-claims";
        }
    }
    
    // Delete claim
    @PostMapping("/deleteclaim")
    public String deleteClaim(@RequestParam("claimId") int claimId, Model model) {
        try {
            providerService.deleteClaim(claimId);
            model.addAttribute("message", "Claim deleted successfully!");
            List<Claim> claims = providerService.getAllClaims();
            model.addAttribute("claims", claims);
            return "view-claims";
        } catch (Exception e) {
            model.addAttribute("error", "Failed to delete: " + e.getMessage());
            List<Claim> claims = providerService.getAllClaims();
            model.addAttribute("claims", claims);
            return "view-claims";
        }
    }
    
    // Search by patient
    @GetMapping("/searchpatient")
    public String searchPatientForm() {
        return "search-patient";
    }
    
    @PostMapping("/searchpatient")
    public String searchPatient(@RequestParam("patientId") int patientId, Model model) {
        try {
            List<Claim> claims = providerService.getClaimsByPatientId(patientId);
            model.addAttribute("claims", claims);
            model.addAttribute("searchType", "Patient ID: " + patientId);
            return "view-claims";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "search-patient";
        }
    }
    
    // Search by provider
    @GetMapping("/searchprovider")
    public String searchProviderForm() {
        return "search-provider";
    }
    
    @PostMapping("/searchprovider")
    public String searchProvider(@RequestParam("providerId") int providerId, Model model) {
        try {
            List<Claim> claims = providerService.getClaimsByProviderId(providerId);
            model.addAttribute("claims", claims);
            model.addAttribute("searchType", "Provider ID: " + providerId);
            return "view-claims";
        } catch (Exception e) {
            model.addAttribute("error", e.getMessage());
            return "search-provider";
        }
    }
}