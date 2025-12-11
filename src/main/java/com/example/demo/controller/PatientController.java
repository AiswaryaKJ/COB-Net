package com.example.demo.controller;

import com.example.demo.service.PatientService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/patient")
public class PatientController {
    
    @Autowired
    private PatientService patientService;
    
    // Patient Dashboard
    @GetMapping("/dashboard")
    public String showDashboard(@RequestParam("patientId") int patientId, Model model) {
        try {
            model.addAttribute("patient", patientService.getPatientById(patientId));
            model.addAttribute("patientId", patientId);
            
            return "patient-dashboard";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading dashboard");
            return "error";
        }
    }
    
    @GetMapping("/insurance")
    public String viewInsurance(@RequestParam("patientId") int patientId, Model model) {
        try {
            model.addAttribute("patient", patientService.getPatientById(patientId));
            model.addAttribute("patientId", patientId);
            
            List<Map<String, Object>> policies = patientService.getPatientInsurancePolicies(patientId);
            model.addAttribute("insurancePolicies", policies);
            
            // Also add primary copay for the info box
            Double primaryCopay = patientService.getPrimaryInsuranceCopay(patientId);
            model.addAttribute("primaryCopay", primaryCopay);
            
            return "patient-insurance";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading insurance information");
            return "error";
        }
    }
    
    // View ALL bills (pending and history)
    @GetMapping("/bills")
    public String viewAllBills(@RequestParam("patientId") int patientId, Model model) {
        try {
            model.addAttribute("patient", patientService.getPatientById(patientId));
            model.addAttribute("patientId", patientId);
            
            // Get all bills
            List<Map<String, Object>> allBills = patientService.getAllBills(patientId);
            model.addAttribute("allBills", allBills);
            
            // Get pending bills count
            List<Map<String, Object>> pendingBills = patientService.getPendingBills(patientId);
            model.addAttribute("pendingCount", pendingBills.size());
            
            // Get bill history
            List<Map<String, Object>> billHistory = patientService.getBillHistory(patientId);
            model.addAttribute("historyCount", billHistory.size());
            
            return "patient-bills";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading bills");
            return "error";
        }
    }
    
    // View only pending bills
    @GetMapping("/bills/pending")
    public String viewPendingBills(@RequestParam("patientId") int patientId, Model model) {
        try {
            model.addAttribute("patient", patientService.getPatientById(patientId));
            model.addAttribute("patientId", patientId);
            
            List<Map<String, Object>> pendingBills = patientService.getPendingBills(patientId);
            model.addAttribute("pendingBills", pendingBills);
            
            return "patient-pending-bills";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading pending bills");
            return "error";
        }
    }
    
    // View bill history
    @GetMapping("/bills/history")
    public String viewBillHistory(@RequestParam("patientId") int patientId, Model model) {
        try {
            model.addAttribute("patient", patientService.getPatientById(patientId));
            model.addAttribute("patientId", patientId);
            
            List<Map<String, Object>> billHistory = patientService.getBillHistory(patientId);
            model.addAttribute("billHistory", billHistory);
            
            return "patient-bill-history";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading bill history");
            return "error";
        }
    }
    
    // Show payment page for a specific claim
    @GetMapping("/pay")
    public String showPaymentPage(@RequestParam("patientId") int patientId,
                                  @RequestParam("claimId") int claimId,
                                  Model model) {
        try {
            model.addAttribute("patientId", patientId);
            model.addAttribute("claimId", claimId);
            
            // Get copay amount
            Double copayAmount = patientService.getPrimaryInsuranceCopay(patientId);
            model.addAttribute("copayAmount", copayAmount);
            
            return "patient-payment";
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading payment page");
            return "error";
        }
    }
    
    // Process copay payment
    @PostMapping("/pay")
    public String processPayment(@RequestParam("patientId") int patientId,
                                 @RequestParam("claimId") int claimId,
                                 RedirectAttributes redirectAttributes) {
        try {
            boolean success = patientService.payCopay(claimId);
            
            if (success) {
                redirectAttributes.addFlashAttribute("success", 
                    "Copay payment recorded successfully! Waiting for provider to process.");
            } else {
                redirectAttributes.addFlashAttribute("error", 
                    "Failed to process payment. Please try again.");
            }
            
            return "redirect:/patient/bills?patientId=" + patientId;
            
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error processing payment");
            return "redirect:/patient/bills?patientId=" + patientId;
        }
    }
    
    // View specific bill details
    @GetMapping("/bill/details")
    public String viewBillDetails(@RequestParam("patientId") int patientId,
                                  @RequestParam("claimId") int claimId,
                                  Model model) {
        try {
            model.addAttribute("patient", patientService.getPatientById(patientId));
            model.addAttribute("patientId", patientId);
            model.addAttribute("claimId", claimId);
            
            // Get all bills and find the specific one
            List<Map<String, Object>> allBills = patientService.getAllBills(patientId);
            Map<String, Object> selectedBill = null;
            
            for (Map<String, Object> bill : allBills) {
                if ((int) bill.get("claimId") == claimId) {
                    selectedBill = bill;
                    break;
                }
            }
            
            if (selectedBill != null) {
                model.addAttribute("bill", selectedBill);
                
                // Get insurance info for context
                Double primaryCopay = patientService.getPrimaryInsuranceCopay(patientId);
                model.addAttribute("primaryCopay", primaryCopay);
                
                return "patient-bill-details";
            } else {
                model.addAttribute("error", "Bill not found");
                return "error";
            }
            
        } catch (Exception e) {
            model.addAttribute("error", "Error loading bill details");
            return "error";
        }
    }
}