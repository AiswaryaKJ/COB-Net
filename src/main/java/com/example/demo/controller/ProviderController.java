package com.example.demo.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.example.demo.bean.Claim;
import com.example.demo.bean.Provider;
import com.example.demo.service.AdminService;
import com.example.demo.service.ProviderService;

@Controller
@RequestMapping("/provider")
public class ProviderController {
    
    private final ProviderService providerService;
    
    @Autowired
    AdminService adminService;

    @Autowired
    public ProviderController(ProviderService providerService) {
        this.providerService = providerService;
    }
    
    // Helper method to get provider info
    private Provider getProviderInfo(int providerId) {
        return providerService.validateProvider(providerId);
    }
    
    // Welcome/Home Page
    @GetMapping("/welcome")
    public String welcomePage(@RequestParam("providerId") int providerId, Model model) {
        try {
            Provider provider = getProviderInfo(providerId);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            return "provider-welcome";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading provider information: " + e.getMessage());
            return "error";
        }
    }
    
    // Show claim submission form
    @GetMapping("/submitclaim")
    public String showClaimForm(@RequestParam("providerId") int providerId, Model model) {
        try {
            Provider provider = getProviderInfo(providerId);
            Claim claim = new Claim();
            
            // Auto-set the provider for the claim
            claim.setProvider(provider);
            
            model.addAttribute("claim", claim);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            return "submit-claim";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claim form: " + e.getMessage());
            return "error";
        }
    }
    // Process claim submission
    @PostMapping("/submitclaim")
    public String submitClaim(@ModelAttribute("claim") Claim claim,
                             @RequestParam("providerId") int providerId,
                             Model model,
                             RedirectAttributes redirectAttributes) {
        try {
            // Set provider ID (in case form doesn't bind it properly)
            Provider provider = new Provider();
            provider.setProviderId(providerId);
            claim.setProvider(provider);
            
            Claim savedClaim = providerService.submitClaim(claim);
            
            redirectAttributes.addFlashAttribute("success", 
                "Claim #" + savedClaim.getClaimId() + " submitted successfully!");
            redirectAttributes.addFlashAttribute("claimId", savedClaim.getClaimId());
            redirectAttributes.addFlashAttribute("patientId", savedClaim.getPatient().getPatientId());
            redirectAttributes.addFlashAttribute("billedAmount", savedClaim.getBilledAmount());
            
            return "redirect:/provider/claim-success?providerId=" + providerId;
        } catch (Exception e) {
            Provider provider = getProviderInfo(providerId);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            model.addAttribute("error", "Failed to submit claim: " + e.getMessage());
            model.addAttribute("claim", claim);
            return "submit-claim";
        }
    }
    
    // Claim success page
    @GetMapping("/claim-success")
    public String claimSuccessPage(@RequestParam("providerId") int providerId, Model model) {
        try {
            Provider provider = getProviderInfo(providerId);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            return "claim-success";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading page: " + e.getMessage());
            return "error";
        }
    }
    
    // View all claims for this provider
    @GetMapping("/viewclaims")
    public String viewAllClaims(@RequestParam("providerId") int providerId, Model model) {
        try {
            Provider provider = getProviderInfo(providerId);
            List<Claim> claims = providerService.getClaimsByProviderId(providerId);
            
            model.addAttribute("claims", claims);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            return "view-claims";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claims: " + e.getMessage());
            return "error";
        }
    }
    
    // View claim by ID
    @GetMapping("/viewclaim")
    public String viewClaimById(@RequestParam("claimId") int claimId,
                               @RequestParam("providerId") int providerId,
                               Model model) {
        try {
            Provider provider = getProviderInfo(providerId);
            Claim claim = providerService.getClaimById(claimId);
            
            // Security check: ensure claim belongs to logged-in provider
            if (claim.getProvider().getProviderId() != providerId) {
                model.addAttribute("error", "Access denied to this claim.");
                return viewAllClaims(providerId, model);
            }
            
            model.addAttribute("claim", claim);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            return "claim-details";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claim: " + e.getMessage());
            return viewAllClaims(providerId, model);
        }
    }
    
    // Update claim status
    @PostMapping("/updatestatus")
    public String updateClaimStatus(@RequestParam("claimId") int claimId,
                                   @RequestParam("status") String status,
                                   @RequestParam("providerId") int providerId,
                                   RedirectAttributes redirectAttributes) {
        try {
            // First get the claim to check ownership
            Claim claim = providerService.getClaimById(claimId);
            if (claim.getProvider().getProviderId() != providerId) {
                redirectAttributes.addFlashAttribute("error", "Access denied to update this claim.");
                return "redirect:/provider/viewclaim?claimId=" + claimId + "&providerId=" + providerId;
            }
            
            Claim updatedClaim = providerService.updateClaimStatus(claimId, status);
            
            redirectAttributes.addFlashAttribute("success", 
                "Claim status updated to: " + status);
            return "redirect:/provider/viewclaim?claimId=" + claimId + "&providerId=" + providerId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Failed to update status: " + e.getMessage());
            return "redirect:/provider/viewclaim?claimId=" + claimId + "&providerId=" + providerId;
        }
    }
    
    // Delete claim
    @PostMapping("/deleteclaim")
    public String deleteClaim(@RequestParam("claimId") int claimId,
                             @RequestParam("providerId") int providerId,
                             RedirectAttributes redirectAttributes) {
        try {
            // Service method will check if status = "Submitted"
            providerService.deleteClaim(claimId, providerId);
            
            redirectAttributes.addFlashAttribute("success", 
                "Claim #" + claimId + " deleted successfully!");
            return "redirect:/provider/viewclaims?providerId=" + providerId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Failed to delete claim: " + e.getMessage());
            return "redirect:/provider/viewclaims?providerId=" + providerId;
        }
    }
    
    // Search by patient - GET (shows the form page)
    @GetMapping("/searchpatient")
    public String searchPatientForm(@RequestParam("providerId") int providerId,
                                   Model model) {
        try {
            Provider provider = getProviderInfo(providerId);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            return "search-patient";
        } catch (Exception e) {
            model.addAttribute("error", "Error loading search page: " + e.getMessage());
            return "error";
        }
    }
    
    // Search by patient - POST
    @PostMapping("/searchpatient")
    public String searchPatient(@RequestParam("patientId") int patientId,
                               @RequestParam("providerId") int providerId,
                               Model model) {
        try {
            Provider provider = getProviderInfo(providerId);
            List<Claim> claims = providerService.getClaimsByPatientId(patientId);
            
            // Filter claims to only show those belonging to this provider
            List<Claim> filteredClaims = claims.stream()
                .filter(claim -> claim.getProvider().getProviderId() == providerId)
                .toList();
            
            model.addAttribute("claims", filteredClaims);
            model.addAttribute("provider", provider);
            model.addAttribute("providerId", providerId);
            model.addAttribute("searchType", "Patient ID: " + patientId);
            model.addAttribute("searchedPatientId", patientId);
            return "view-claims";
        } catch (Exception e) {
            model.addAttribute("error", "Error searching claims: " + e.getMessage());
            return searchPatientForm(providerId, model);
        }
    }
    
    @GetMapping("/delete/{id}")
    public String activityProvider(@PathVariable("id") int id, 
                                  @RequestParam("providerId") int providerId,
                                  RedirectAttributes redirectAttributes) {
        try {
            adminService.deactivateProvider(id);
            redirectAttributes.addFlashAttribute("success", 
                "Provider ID " + id + " successfully set to Inactive.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Failed to set provider ID " + id + " to inactive: " + e.getMessage());
        }
        return "redirect:/admin";
    }
}