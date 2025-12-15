package com.example.demo.controller;

import com.example.demo.bean.*;
import com.example.demo.service.PatientService;
import com.example.demo.dao.CredentialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/patient")
public class PatientController {
    
    @Autowired
    private PatientService patientService;
    
    @Autowired
    private CredentialRepository credentialRepository;
    
    // Helper method to get patient info
    private Map<String, Object> getPatientInfo(int patientId) {
        Credentials creds = credentialRepository.findByPatient_PatientId(patientId)
            .orElseThrow(() -> new RuntimeException("Patient not found with ID: " + patientId));
        
        return Map.of(
            "patientId", patientId,
            "patientName", creds.getPatient().getFullName(),
            "credentials", creds
        );
    }
    
    // Patient Dashboard
    @GetMapping("/dashboard")
    public String showDashboard(@RequestParam("patientId") int patientId, Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            
            // Get summary data for dashboard
            List<Claim> recentClaims = patientService.getRecentClaims(patientId, 5);
            List<Map<String, Object>> insurancePolicies = patientService.getPatientInsurancePolicies(patientId);
            
            // Get counts for dashboard cards
            long totalClaims = patientService.getTotalClaimsCount(patientId);
            long pendingClaims = patientService.getClaimsCountByStatus(patientId, "Submitted");
            long processedClaims = patientService.getClaimsCountByStatus(patientId, "Processed");
            long paidClaims = patientService.getClaimsCountByStatus(patientId, "Paid");
            
            // Get total pending bills amount
            Double totalPendingBills = patientService.getTotalPendingBills(patientId);
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("recentClaims", recentClaims);
            model.addAttribute("insurancePolicies", insurancePolicies);
            model.addAttribute("totalClaims", totalClaims);
            model.addAttribute("pendingClaims", pendingClaims);
            model.addAttribute("processedClaims", processedClaims);
            model.addAttribute("paidClaims", paidClaims);
            model.addAttribute("totalPendingBills", totalPendingBills != null ? totalPendingBills : 0.0);
            model.addAttribute("hasInsurance", !insurancePolicies.isEmpty());
            
            return "patient-dashboard";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading dashboard: " + e.getMessage());
            return "error";
        }
    }
    
    // View Insurance Policies
    @GetMapping("/policies")
    public String viewInsurancePolicies(@RequestParam("patientId") int patientId, Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            List<Map<String, Object>> insurancePolicies = patientService.getPatientInsurancePolicies(patientId);
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("insurancePolicies", insurancePolicies);
            
            return "patient-policies";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading insurance policies: " + e.getMessage());
            return "error";
        }
    }
    
    // View Claims History
    @GetMapping("/claims")
    public String viewClaimsHistory(@RequestParam("patientId") int patientId, Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            List<Claim> claims = patientService.getAllClaims(patientId);
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("claims", claims);
            
            return "patient-claims";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claims: " + e.getMessage());
            return "error";
        }
    }
    
    // View Claim Details
    @GetMapping("/claim/{claimId}")
    public String viewClaimDetails(@PathVariable("claimId") int claimId,
                                   @RequestParam("patientId") int patientId,
                                   Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            Claim claim = patientService.getClaimById(claimId, patientId);
            
            if (claim == null) {
                model.addAttribute("error", "Claim not found or you don't have access");
                return "error";
            }
            
            // Check if EOB is available
            boolean eobAvailable = patientService.isEOBAvailable(claimId);
            
            model.addAttribute("claim", claim);
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("eobAvailable", eobAvailable);
            
            return "patient-claim-details";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading claim details: " + e.getMessage());
            return "error";
        }
    }
    
    // View EOB Details
    @GetMapping("/eob/{claimId}")
    public String viewEOBDetails(@PathVariable("claimId") int claimId,
                                 @RequestParam("patientId") int patientId,
                                 Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            
            // Verify patient owns this claim
            Claim claim = patientService.getClaimById(claimId, patientId);
            if (claim == null) {
                model.addAttribute("error", "Claim not found or you don't have access");
                return "error";
            }
            
            // Check if claim is processed/paid
            if (!"Processed".equalsIgnoreCase(claim.getStatus()) && 
                !"Paid".equalsIgnoreCase(claim.getStatus())) {
                model.addAttribute("error", "EOB is not available yet. Claim status: " + claim.getStatus());
                return "error";
            }
            
            // Get EOB details
            Map<String, Object> eobDetails = patientService.getEOBDetails(claimId);
            
            model.addAttribute("claim", claim);
            model.addAttribute("eobDetails", eobDetails);
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            
            return "patient-eob-details";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading EOB details: " + e.getMessage());
            return "error";
        }
    }
    
    // View Bills (Pending Payments)
    @GetMapping("/bills")
    public String viewBills(@RequestParam("patientId") int patientId, Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            List<Map<String, Object>> pendingBills = patientService.getPendingBills(patientId);
            List<Map<String, Object>> paidBills = patientService.getPaidBills(patientId);
            
            Double totalPendingAmount = pendingBills.stream()
                .mapToDouble(bill -> (Double) bill.get("amountDue"))
                .sum();
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("pendingBills", pendingBills);
            model.addAttribute("paidBills", paidBills);
            model.addAttribute("totalPendingAmount", totalPendingAmount);
            
            return "patient-bills";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading bills: " + e.getMessage());
            return "error";
        }
    }
    
    // Show Payment Page
    @GetMapping("/pay")
    public String showPaymentPage(@RequestParam("patientId") int patientId,
                                  @RequestParam("claimId") int claimId,
                                  Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            
            // Verify the bill exists and is payable
            Map<String, Object> billDetails = patientService.getBillDetails(claimId, patientId);
            if (billDetails == null) {
                model.addAttribute("error", "Bill not found or already paid");
                return "error";
            }
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("claimId", claimId);
            model.addAttribute("billDetails", billDetails);
            model.addAttribute("amountDue", billDetails.get("amountDue"));
            
            return "patient-payment";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading payment page: " + e.getMessage());
            return "error";
        }
    }
    
    // Process Payment
    @PostMapping("/pay")
    public String processPayment(@RequestParam("patientId") int patientId,
                                 @RequestParam("claimId") int claimId,
                                 @RequestParam("paymentMethod") String paymentMethod,
                                 RedirectAttributes redirectAttributes) {
        try {
            // Process the payment
            boolean paymentSuccess = patientService.processPayment(claimId, patientId, paymentMethod);
            
            if (paymentSuccess) {
                redirectAttributes.addFlashAttribute("success", 
                    "Payment processed successfully! Your claim status has been updated to 'Paid'.");
            } else {
                redirectAttributes.addFlashAttribute("error", 
                    "Payment failed. Please try again or contact support.");
            }
            
            return "redirect:/patient/bills?patientId=" + patientId;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", 
                "Error processing payment: " + e.getMessage());
            return "redirect:/patient/bills?patientId=" + patientId;
        }
    }
    
    // Payment Confirmation Page
    @GetMapping("/payment-confirmation")
    public String showPaymentConfirmation(@RequestParam("patientId") int patientId,
                                          @RequestParam("claimId") int claimId,
                                          Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            
            // Get payment details
            Map<String, Object> paymentDetails = patientService.getPaymentDetails(claimId, patientId);
            
            if (paymentDetails == null) {
                model.addAttribute("error", "Payment details not found");
                return "error";
            }
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("claimId", claimId);
            model.addAttribute("paymentDetails", paymentDetails);
            
            return "patient-payment-confirmation";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading confirmation: " + e.getMessage());
            return "error";
        }
    }
    
 // View Bill Details
    @GetMapping("/bill/{claimId}")
    public String viewBillDetails(@PathVariable("claimId") int claimId,
                                   @RequestParam("patientId") int patientId,
                                   Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            
            // Get bill details from service
            Map<String, Object> billDetails = patientService.getBillDetails(claimId, patientId);
            if (billDetails == null) {
                model.addAttribute("error", "Bill not found or already paid");
                return "error";
            }
            
            // Get the claim for additional info
            Claim claim = patientService.getClaimById(claimId, patientId);
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("claim", claim);
            model.addAttribute("billDetails", billDetails);
            
            return "patient-bill-details";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading bill details: " + e.getMessage());
            return "error";
        }
    }

    // View Receipt (for paid bills)
    @GetMapping("/receipt/{claimId}")
    public String viewReceipt(@PathVariable("claimId") int claimId,
                              @RequestParam("patientId") int patientId,
                              Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            
            // Get payment details
            Map<String, Object> paymentDetails = patientService.getPaymentDetails(claimId, patientId);
            if (paymentDetails == null) {
                model.addAttribute("error", "Receipt not found or bill not paid");
                return "error";
            }
            
            // Get the claim for additional info
            Claim claim = patientService.getClaimById(claimId, patientId);
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("claim", claim);
            model.addAttribute("paymentDetails", paymentDetails);
            
            return "patient-receipt";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading receipt: " + e.getMessage());
            return "error";
        }
    }
    @GetMapping("/insurance-card")
    public String showInsuranceCard(@RequestParam("patientId") int patientId, Model model) {
        try {
            Map<String, Object> patientInfo = getPatientInfo(patientId);
            
            // Get primary insurance policy
            List<Map<String, Object>> insurancePolicies = patientService.getPatientInsurancePolicies(patientId);
            Map<String, Object> primaryPolicy = null;
            
            if (!insurancePolicies.isEmpty()) {
                // Find primary policy (coverageOrder == 1)
                primaryPolicy = insurancePolicies.stream()
                    .filter(policy -> (Integer) policy.get("coverageOrder") == 1)
                    .findFirst()
                    .orElse(insurancePolicies.get(0));
                
                // Calculate if policy is active based on dates
                LocalDate today = LocalDate.now();
                LocalDate effectiveDate = (LocalDate) primaryPolicy.get("effectiveDate");
                LocalDate terminationDate = (LocalDate) primaryPolicy.get("terminationDate");
                
                boolean isActive = false;
                if (effectiveDate != null) {
                    if (terminationDate != null) {
                        // Has both dates
                        isActive = !today.isBefore(effectiveDate) && !today.isAfter(terminationDate);
                    } else {
                        // No termination date
                        isActive = !today.isBefore(effectiveDate);
                    }
                }
                
                primaryPolicy.put("isActive", isActive);
            }
            
            model.addAttribute("patientId", patientId);
            model.addAttribute("patientName", patientInfo.get("patientName"));
            model.addAttribute("primaryPolicy", primaryPolicy);
            model.addAttribute("allPolicies", insurancePolicies);
            model.addAttribute("today", LocalDate.now()); // Add current date
            
            return "patient-insurance-card";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading insurance card: " + e.getMessage());
            return "error";
        }
    }
}