package com.example.demo.service;

import com.example.demo.bean.*;
import com.example.demo.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

@Service
public class PatientService {
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private PatientCoverageRepository patientCoverageRepository;
    
    @Autowired
    private InsurancePlanRepository insurancePlanRepository;
    
    @Autowired
    private ClaimRepository claimRepository;
    
    // Get patient by ID
    public Patient getPatientById(int patientId) {
        return patientRepository.findById(patientId).orElse(null);
    }
    
 // In PatientService.java - Update the existing method
    public List<Map<String, Object>> getPatientInsuranceDetails(int patientId) {
        List<Map<String, Object>> policies = new ArrayList<>();
        
        try {
            List<PatientCoverage> coverages = patientCoverageRepository.findByPatientId(patientId);
            
            for (PatientCoverage coverage : coverages) {
                Map<String, Object> policy = new HashMap<>();
                
                InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
                
                if (plan != null) {
                    policy.put("coverageOrder", coverage.getCoverageOrder());
                    policy.put("effectiveDate", coverage.getEffectiveDate());
                    policy.put("terminationDate", coverage.getTerminationDate());
                    policy.put("planName", plan.getPlanName());
                    policy.put("payerName", plan.getPayerName());
                    policy.put("planType", plan.getPlanType());
                    policy.put("policyNumber", plan.getPolicyNumber());
                    policy.put("copay", plan.getCopay());
                    policy.put("coveragePercent", plan.getCoveragePercent());
                    policy.put("deductible", plan.getDeductible());
                    policy.put("coinsurance", plan.getCoinsurance());
                    policy.put("isPrimary", coverage.getCoverageOrder() == 1);
                    
                    policies.add(policy);
                }
            }
            
            // Sort by coverage order
            policies.sort((a, b) -> {
                int orderA = (int) a.get("coverageOrder");
                int orderB = (int) b.get("coverageOrder");
                return Integer.compare(orderA, orderB);
            });
            
        } catch (Exception e) {
            // Return empty list if error
            e.printStackTrace();
        }
        
        return policies;
    }

    // OPTIONAL: If you want to keep the old method name for backward compatibility
    public List<Map<String, Object>> getPatientInsurancePolicies(int patientId) {
        return getPatientInsuranceDetails(patientId);
    }
    
    // Get patient's primary insurance copay amount
    public Double getPrimaryInsuranceCopay(int patientId) {
        try {
            Optional<PatientCoverage> primaryCoverage = patientCoverageRepository.findPrimaryCoverage(patientId);
            
            if (primaryCoverage.isPresent()) {
                PatientCoverage coverage = primaryCoverage.get();
                InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
                
                if (plan != null) {
                    return plan.getCopay();
                }
            }
        } catch (Exception e) {
            // Return null if error
        }
        
        return null;
    }
    
    // Get ALL bills (pending and processed)
    public List<Map<String, Object>> getAllBills(int patientId) {
        List<Map<String, Object>> allBills = new ArrayList<>();
        
        try {
            // Get all claims for this patient
            List<Claim> allClaims = claimRepository.findByPatientId(patientId);
            
            // Get primary insurance copay
            Double primaryCopay = getPrimaryInsuranceCopay(patientId);
            
            for (Claim claim : allClaims) {
                Map<String, Object> bill = new HashMap<>();
                
                bill.put("claimId", claim.getClaimId());
                bill.put("billedAmount", claim.getBilledAmount());
                bill.put("claimDate", claim.getClaimDate());
                bill.put("diagnosisCode", claim.getDiagnosisCode());
                bill.put("procedureCode", claim.getProcedureCode());
                bill.put("status", claim.getStatus());
                bill.put("finalOutOfPocket", claim.getFinalOutOfPocket());
                
                // Provider details
                if (claim.getProvider() != null) {
                    bill.put("providerName", claim.getProvider().getName());
                }
                
                // Determine bill status and message
                String status = claim.getStatus();
                Double outOfPocket = claim.getFinalOutOfPocket();
                
                String billStatus = "";
                String statusMessage = "";
                
                if ("Submitted".equals(status)) {
                    if (outOfPocket == null || outOfPocket == 0.0) {
                        billStatus = "Pending Payment";
                        statusMessage = "Your copay is pending";
                        bill.put("copayAmount", primaryCopay);
                    } else if (outOfPocket != null && primaryCopay != null && 
                              Math.abs(outOfPocket - primaryCopay) < 0.01) {
                        billStatus = "Waiting for Processing";
                        statusMessage = "Copay paid. Waiting for provider to process";
                        bill.put("copayAmount", primaryCopay);
                        bill.put("copayPaid", true);
                    } else {
                        billStatus = "Submitted";
                        statusMessage = "Claim submitted";
                    }
                } else if ("Processed".equals(status)) {
                    billStatus = "Processed";
                    statusMessage = "Claim processed by provider";
                    bill.put("copayAmount", outOfPocket);
                    bill.put("copayPaid", true);
                } else if ("Denied".equals(status)) {
                    billStatus = "Denied";
                    statusMessage = "Claim denied by insurance";
                } else if ("Paid".equals(status)) {
                    billStatus = "Paid";
                    statusMessage = "Claim fully paid";
                }
                
                bill.put("billStatus", billStatus);
                bill.put("statusMessage", statusMessage);
                bill.put("primaryCopay", primaryCopay);
                
                allBills.add(bill);
            }
            
            // Sort by claim date (newest first)
            allBills.sort((a, b) -> {
                LocalDate dateA = (LocalDate) a.get("claimDate");
                LocalDate dateB = (LocalDate) b.get("claimDate");
                return dateB.compareTo(dateA);
            });
            
        } catch (Exception e) {
            // Return empty list if error
        }
        
        return allBills;
    }
    
    // Get pending bills (outOfPocket = 0/null and status = Submitted)
    public List<Map<String, Object>> getPendingBills(int patientId) {
        List<Map<String, Object>> pendingBills = new ArrayList<>();
        
        try {
            // Get all bills
            List<Map<String, Object>> allBills = getAllBills(patientId);
            
            // Filter for pending bills
            for (Map<String, Object> bill : allBills) {
                String status = (String) bill.get("status");
                Double outOfPocket = (Double) bill.get("finalOutOfPocket");
                String billStatus = (String) bill.get("billStatus");
                
                if ("Submitted".equals(status) && 
                    (outOfPocket == null || outOfPocket == 0.0) &&
                    "Pending Payment".equals(billStatus)) {
                    pendingBills.add(bill);
                }
            }
            
        } catch (Exception e) {
            // Return empty list if error
        }
        
        return pendingBills;
    }
    
    // Pay copay - ONLY updates final_out_of_pocket, NOT status
    @Transactional
    public boolean payCopay(int claimId) {
        try {
            Claim claim = claimRepository.findById(claimId).orElse(null);
            
            if (claim != null && "Submitted".equals(claim.getStatus())) {
                // Get patient's primary copay
                int patientId = claim.getPatient().getPatientId();
                Double copayAmount = getPrimaryInsuranceCopay(patientId);
                
                if (copayAmount != null) {
                    // Update ONLY final_out_of_pocket, keep status as "Submitted"
                    claim.setFinalOutOfPocket(copayAmount);
                    claimRepository.save(claim);
                    return true;
                }
            }
        } catch (Exception e) {
            // Return false if error
        }
        
        return false;
    }
    
    // Get processed/paid bills for history
    public List<Map<String, Object>> getBillHistory(int patientId) {
        List<Map<String, Object>> historyBills = new ArrayList<>();
        
        try {
            // Get all bills
            List<Map<String, Object>> allBills = getAllBills(patientId);
            
            // Filter for processed/paid/denied bills
            for (Map<String, Object> bill : allBills) {
                String status = (String) bill.get("status");
                
                if ("Processed".equals(status) || "Paid".equals(status) || 
                    "Denied".equals(status)) {
                    historyBills.add(bill);
                }
            }
            
        } catch (Exception e) {
            // Return empty list if error
        }
        
        return historyBills;
    }
}