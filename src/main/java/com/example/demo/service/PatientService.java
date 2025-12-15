package com.example.demo.service;

import com.example.demo.bean.*;
import com.example.demo.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class PatientService {
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private PatientCoverageRepository patientCoverageRepository;
    
    @Autowired
    private InsurancePlanRepository insurancePlanRepository;
    
    @Autowired
    private InsurerRepository insurerRepository;
    
    @Autowired
    private ClaimRepository claimRepository;
    
    @Autowired
    private EOB1Repository eob1Repository;
    
    @Autowired
    private EOB2Repository eob2Repository;
    
    @Autowired
    private EOBFinalRepository eobFinalRepository;
    
    // Get patient's insurance policies with details
    public List<Map<String, Object>> getPatientInsurancePolicies(int patientId) {
        List<PatientCoverage> coverages = patientCoverageRepository.findByPatientId(patientId);
        
        List<Map<String, Object>> policies = new ArrayList<>();
        
        for (PatientCoverage coverage : coverages) {
            InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
            if (plan == null) continue;
            
            Insurer insurer = plan.getInsurer();
            if (insurer == null) continue;
            
            // Determine if policy is active
            boolean isActive = true;
            if (coverage.getTerminationDate() != null) {
                isActive = coverage.getTerminationDate().isAfter(LocalDate.now()) || 
                          coverage.getTerminationDate().isEqual(LocalDate.now());
            }
            
            Map<String, Object> policyInfo = new HashMap<>();
            policyInfo.put("coverageId", coverage.getPlanId() + "-" + coverage.getPatientId());
            policyInfo.put("planName", plan.getPlanName());
            policyInfo.put("payerName", insurer.getPayerName());
            policyInfo.put("policyNumber", plan.getPolicyNumber());
            policyInfo.put("coverageOrder", coverage.getCoverageOrder());
            policyInfo.put("coverageType", coverage.getCoverageOrder() == 1 ? "Primary" : "Secondary");
            policyInfo.put("isPrimary", coverage.getCoverageOrder() == 1);
            policyInfo.put("effectiveDate", coverage.getEffectiveDate());
            policyInfo.put("terminationDate", coverage.getTerminationDate());
            policyInfo.put("isActive", isActive);
            policyInfo.put("status", isActive ? "Active" : "Inactive");
            
            // Plan details
            policyInfo.put("coveragePercent", plan.getCoveragePercent());
            policyInfo.put("deductible", plan.getDeductible());
            policyInfo.put("copay", plan.getCopay());
            policyInfo.put("coinsurance", plan.getCoinsurance());
            policyInfo.put("outOfPocketMax", plan.getOutOfPocketMax());
            policyInfo.put("planType", plan.getPlanType());
            
            // Current tracking
            policyInfo.put("deductiblePaid", coverage.getDeductiblePaidThisYear());
            policyInfo.put("deductibleRemaining", coverage.getDeductibleRemaining());
            policyInfo.put("oopPaid", coverage.getOopPaidThisYear());
            policyInfo.put("oopRemaining", coverage.getOopRemaining());
            
            policies.add(policyInfo);
        }
        
        // Sort by coverage order
        policies.sort(Comparator.comparingInt(p -> (Integer) p.get("coverageOrder")));
        
        return policies;
    }
    
    // Get all claims for patient
    public List<Claim> getAllClaims(int patientId) {
        return claimRepository.findByPatientPatientId(patientId);
    }
    
    // Get recent claims
    public List<Claim> getRecentClaims(int patientId, int limit) {
        List<Claim> claims = claimRepository.findByPatientPatientId(patientId);
        
        // Sort by date descending and limit
        return claims.stream()
            .sorted((c1, c2) -> c2.getClaimDate().compareTo(c1.getClaimDate()))
            .limit(limit)
            .collect(Collectors.toList());
    }
    
    // Get claim by ID with patient verification
    public Claim getClaimById(int claimId, int patientId) {
        return claimRepository.findByClaimIdAndPatientPatientId(claimId, patientId);
    }
    
    // Check if EOB is available for a claim
    public boolean isEOBAvailable(int claimId) {
        Optional<EOBFinal> eobFinal = eobFinalRepository.findByClaimClaimId(claimId);
        return eobFinal.isPresent();
    }
    
    // Get EOB details for a claim
    public Map<String, Object> getEOBDetails(int claimId) {
        Map<String, Object> eobDetails = new HashMap<>();
        
        EOB1 eob1 = eob1Repository.findByClaimClaimId(claimId).orElse(null);
        EOB2 eob2 = eob2Repository.findByClaimClaimId(claimId).orElse(null);
        EOBFinal eobFinal = eobFinalRepository.findByClaimClaimId(claimId).orElse(null);
        
        eobDetails.put("eob1", eob1);
        eobDetails.put("eob2", eob2);
        eobDetails.put("eobFinal", eobFinal);
        
        return eobDetails;
    }
    
 // Get pending bills (claims with status "Processed")
    public List<Map<String, Object>> getPendingBills(int patientId) {
        List<Claim> processedClaims = claimRepository.findByPatientPatientIdAndStatus(patientId, "processed");
        
        List<Map<String, Object>> pendingBills = new ArrayList<>();
        
        for (Claim claim : processedClaims) {
            EOBFinal eobFinal = eobFinalRepository.findByClaimClaimId(claim.getClaimId()).orElse(null);
            
            if (eobFinal != null && eobFinal.getTotalPatientResponsibility() > 0) {
                Map<String, Object> bill = new HashMap<>();
                bill.put("claimId", claim.getClaimId());
                bill.put("claimDate", claim.getClaimDate());
                bill.put("providerName", claim.getProvider().getName());
                bill.put("billedAmount", claim.getBilledAmount());
                bill.put("amountDue", eobFinal.getTotalPatientResponsibility());
                
                // Calculate due date (30 days from claim date)
                LocalDate dueDate = claim.getClaimDate().plusDays(30);
                bill.put("dueDate", dueDate);
                
                // Calculate days until due
                long daysUntilDue = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), dueDate);
                bill.put("daysUntilDue", daysUntilDue);
                
                bill.put("description", claim.getDiagnosisCode() + " - " + claim.getProcedureCode());
                bill.put("status", "Pending");
                
                pendingBills.add(bill);
            }
        }
        
        // Sort by due date
        pendingBills.sort(Comparator.comparing(bill -> (LocalDate) bill.get("dueDate")));
        
        return pendingBills;
    }
    
    // Get paid bills
    public List<Map<String, Object>> getPaidBills(int patientId) {
        List<Claim> paidClaims = claimRepository.findByPatientPatientIdAndStatus(patientId, "paid"); // Changed to lowercase
        
        List<Map<String, Object>> paidBills = new ArrayList<>();
        
        for (Claim claim : paidClaims) {
            EOBFinal eobFinal = eobFinalRepository.findByClaimClaimId(claim.getClaimId()).orElse(null);
            
            if (eobFinal != null) {
                Map<String, Object> bill = new HashMap<>();
                bill.put("claimId", claim.getClaimId());
                bill.put("claimDate", claim.getClaimDate());
                bill.put("providerName", claim.getProvider().getName());
                bill.put("billedAmount", claim.getBilledAmount());
                bill.put("amountPaid", eobFinal.getTotalPatientResponsibility());
                bill.put("paidDate", claim.getClaimDate()); // In real system, would have actual payment date
                bill.put("description", claim.getDiagnosisCode() + " - " + claim.getProcedureCode());
                bill.put("status", "Paid");
                
                paidBills.add(bill);
            }
        }
        
        // Sort by paid date descending
        paidBills.sort((b1, b2) -> ((LocalDate) b2.get("paidDate")).compareTo((LocalDate) b1.get("paidDate")));
        
        return paidBills;
    }
    
    // Get bill details for a specific claim
    public Map<String, Object> getBillDetails(int claimId, int patientId) {
        Claim claim = getClaimById(claimId, patientId);
        
        if (claim == null || !"processed".equals(claim.getStatus())) {
            return null;
        }
        
        EOBFinal eobFinal = eobFinalRepository.findByClaimClaimId(claimId).orElse(null);
        
        if (eobFinal == null || eobFinal.getTotalPatientResponsibility() <= 0) {
            return null;
        }
        
        Map<String, Object> billDetails = new HashMap<>();
        billDetails.put("claimId", claim.getClaimId());
        billDetails.put("patientName", claim.getPatient().getFullName());
        billDetails.put("providerName", claim.getProvider().getName());
        billDetails.put("serviceDate", claim.getClaimDate());
        billDetails.put("diagnosis", claim.getDiagnosisCode());
        billDetails.put("procedure", claim.getProcedureCode());
        billDetails.put("billedAmount", claim.getBilledAmount());
        billDetails.put("amountDue", eobFinal.getTotalPatientResponsibility());
        billDetails.put("dueDate", claim.getClaimDate().plusDays(30));
        billDetails.put("insurancePayment", eobFinal.getTotalInsurancePayment());
        
        return billDetails;
    }
    
    // Process payment for a claim
    @Transactional
    public boolean processPayment(int claimId, int patientId, String paymentMethod) {
        try {
            Claim claim = getClaimById(claimId, patientId);
            
            // FIXED: Changed "Processed" to "processed" (lowercase)
            if (claim == null || !"processed".equals(claim.getStatus())) {
                throw new RuntimeException("Claim not found or not ready for payment");
            }
            
            // FIXED: Changed "Paid" to "paid" (lowercase)
            claim.setStatus("paid");
            claimRepository.save(claim);
            
            // In a real system, you would:
            // 1. Create a Payment record
            // 2. Process payment through payment gateway
            // 3. Send confirmation email
            // 4. Update accounting system
            
            return true;
            
        } catch (Exception e) {
            throw new RuntimeException("Payment processing failed: " + e.getMessage());
        }
    }
    
    // Get payment details (for confirmation page)
    public Map<String, Object> getPaymentDetails(int claimId, int patientId) {
        Claim claim = getClaimById(claimId, patientId);
        
        // FIXED: Changed "Paid" to "paid" (lowercase)
        if (claim == null || !"paid".equals(claim.getStatus())) {
            return null;
        }
        
        EOBFinal eobFinal = eobFinalRepository.findByClaimClaimId(claimId).orElse(null);
        
        Map<String, Object> paymentDetails = new HashMap<>();
        paymentDetails.put("claimId", claim.getClaimId());
        paymentDetails.put("patientName", claim.getPatient().getFullName());
        paymentDetails.put("providerName", claim.getProvider().getName());
        paymentDetails.put("paymentDate", LocalDate.now());
        paymentDetails.put("paymentMethod", "Online Payment");
        paymentDetails.put("amountPaid", eobFinal != null ? eobFinal.getTotalPatientResponsibility() : 0.0);
        paymentDetails.put("transactionId", "TXN-" + System.currentTimeMillis());
        paymentDetails.put("status", "Completed");
        
        return paymentDetails;
    }
    
    // Helper methods for dashboard
    public long getTotalClaimsCount(int patientId) {
        return claimRepository.countByPatientPatientId(patientId);
    }
    
    public long getClaimsCountByStatus(int patientId, String status) {
        return claimRepository.countByPatientPatientIdAndStatus(patientId, status);
    }
    
    public Double getTotalPendingBills(int patientId) {
        List<Map<String, Object>> pendingBills = getPendingBills(patientId);
        return pendingBills.stream()
            .mapToDouble(bill -> (Double) bill.get("amountDue"))
            .sum();
    }
}