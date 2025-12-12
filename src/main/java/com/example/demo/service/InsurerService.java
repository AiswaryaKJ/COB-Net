package com.example.demo.service;

import com.example.demo.bean.*;
import com.example.demo.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

@Service
public class InsurerService {
    
    @Autowired
    private ClaimRepository claimRepository;
    
    @Autowired
    private PatientCoverageRepository patientCoverageRepository;
    
    @Autowired
    private InsurancePlanRepository insurancePlanRepository;
    
    @Autowired
    private SettlementRepository settlementRepository;
    
    // Get all pending claims (status = 'Submitted')
    public List<Claim> getPendingClaims() {
        return claimRepository.findByStatus("Submitted");
    }
    
    // Get processed claims
    public List<Claim> getProcessedClaims() {
        return claimRepository.findByStatus("Processed");
    }
    
    // Process a claim - FINAL CORRECTED VERSION
    @Transactional
    public Settlement processClaim(int claimId) {
        Claim claim = claimRepository.findById(claimId).orElse(null);
        if (claim == null || !"Submitted".equals(claim.getStatus())) {
            throw new RuntimeException("Claim not found or already processed");
        }
        
        int patientId = claim.getPatient().getPatientId();
        double billedAmount = claim.getBilledAmount();
        
        // Get patient's insurance coverage
        List<PatientCoverage> coverages = patientCoverageRepository.findByPatientId(patientId);
        
        // Sort by coverage order
        coverages.sort(Comparator.comparingInt(PatientCoverage::getCoverageOrder));
        
        Settlement settlement = new Settlement();
        settlement.setClaimId(claimId);
        settlement.setPatientId(patientId);
        settlement.setProviderId(claim.getProvider().getProviderId());
        settlement.setBilledAmount(billedAmount);
        
        // Find primary and secondary insurance
        PatientCoverage primaryCoverage = null;
        PatientCoverage secondaryCoverage = null;
        InsurancePlan primaryPlan = null;
        InsurancePlan secondaryPlan = null;
        
        for (PatientCoverage coverage : coverages) {
            InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
            if (plan == null) continue;
            
            if (coverage.getCoverageOrder() == 1) {
                primaryCoverage = coverage;
                primaryPlan = plan;
                settlement.setPrimaryPlanId(plan.getPlanId());
            } else if (coverage.getCoverageOrder() == 2) {
                secondaryCoverage = coverage;
                secondaryPlan = plan;
                settlement.setSecondaryPlanId(plan.getPlanId());
            }
        }
        
        double totalPatientResponsibility = 0;
        double totalOopSavings = 0;
        
        // STEP 1: Process PRIMARY INSURANCE (full bill)
        if (primaryPlan != null && primaryCoverage != null) {
            double[] primaryResult = processInsurance(primaryPlan, primaryCoverage, billedAmount, true);
            
            double primaryPatientPays = primaryResult[0];        // What patient pays to primary
            double primaryOopSavings = primaryResult[1];         // OOP savings from primary
            double primaryOopApplied = primaryResult[2];         // OOP amount applied
            double primaryDeductibleApplied = primaryResult[3];  // Deductible applied
            double primaryCopay = primaryResult[4];              // Copay amount
            double primaryCoinsurance = primaryResult[5];        // Coinsurance amount
            double primaryInsurancePays = primaryResult[6];      // Insurance payment
            
            settlement.setPrimaryCopay(primaryCopay);
            settlement.setPrimaryDeductibleApplied(primaryDeductibleApplied);
            settlement.setCoinsuranceAmount(primaryCoinsurance);
            settlement.setPrimaryOopApplied(primaryOopApplied);
            settlement.setPrimaryInsurancePaid(primaryInsurancePays);
            
            totalPatientResponsibility = primaryPatientPays;
            totalOopSavings += primaryOopSavings;
            
            // STEP 2: Process SECONDARY INSURANCE (only if patient has responsibility after primary)
            if (secondaryPlan != null && secondaryCoverage != null && primaryPatientPays > 0) {
                double[] secondaryResult = processInsurance(secondaryPlan, secondaryCoverage, primaryPatientPays, false);
                
                double secondaryPatientPays = secondaryResult[0];       // What patient pays after secondary
                double secondaryOopSavings = secondaryResult[1];        // OOP savings from secondary
                double secondaryOopApplied = secondaryResult[2];        // OOP amount applied
                double secondaryDeductibleApplied = secondaryResult[3]; // Deductible applied
                double secondaryCopay = secondaryResult[4];             // Copay amount
                double secondaryCoinsurance = secondaryResult[5];       // Coinsurance amount
                
                settlement.setSecondaryCopay(secondaryCopay);
                settlement.setSecondaryDeductibleApplied(secondaryDeductibleApplied);
                settlement.setCoinsuranceAmount(settlement.getCoinsuranceAmount() + secondaryCoinsurance);
                settlement.setSecondaryOopApplied(secondaryOopApplied);
                
                totalPatientResponsibility = secondaryPatientPays;
                totalOopSavings += secondaryOopSavings;
                
                // Secondary insurance pays what it covers (patient's reduced responsibility)
                double secondaryInsurancePays = primaryPatientPays - secondaryPatientPays;
                settlement.setSecondaryInsurancePaid(Math.max(0, secondaryInsurancePays));
            }
        }
        
        // Set final amounts
        settlement.setTotalPatientResponsibility(totalPatientResponsibility);
        settlement.setTotalOopSavings(totalOopSavings);
        
        // Save settlement
        settlement = settlementRepository.save(settlement);
        
        // Update claim status
        claim.setStatus("Processed");
        claim.setFinalOutOfPocket(totalPatientResponsibility);
        claimRepository.save(claim);
        
        return settlement;
    }
    
    // Main insurance processing logic - CORRECTED
    private double[] processInsurance(InsurancePlan plan, PatientCoverage coverage, 
                                     double amountToProcess, boolean isPrimary) {
        
        // Get plan details
        double deductible = plan.getDeductible();
        double copay = plan.getCopay();
        double coinsuranceRate = plan.getCoinsurance() / 100.0;
        double oopMax = plan.getOutOfPocketMax();
        
        // Get current patient tracking
        double deductiblePaid = coverage.getDeductiblePaidThisYear() != null ? 
                               coverage.getDeductiblePaidThisYear() : 0.0;
        double oopPaid = coverage.getOopPaidThisYear() != null ? 
                        coverage.getOopPaidThisYear() : 0.0;
        
        // If secondary and nothing to process, return zeros
        if (!isPrimary && amountToProcess <= 0) {
            return new double[]{0, 0, 0, 0, 0, 0, 0};
        }
        
        // 1. APPLY DEDUCTIBLE
        double deductibleApplied = 0;
        double remainingAfterDeductible = amountToProcess;
        
        if (deductiblePaid < deductible) {
            double deductibleRemaining = deductible - deductiblePaid;
            deductibleApplied = Math.min(amountToProcess, deductibleRemaining);
            remainingAfterDeductible = Math.max(0, amountToProcess - deductibleApplied);
        }
        
        // 2. APPLY COPAY (only if amount remains after deductible)
        double copayApplied = 0;
        double remainingAfterCopay = remainingAfterDeductible;
        
        if (remainingAfterDeductible > 0) {
            copayApplied = Math.min(remainingAfterDeductible, copay);
            remainingAfterCopay = Math.max(0, remainingAfterDeductible - copayApplied);
        }
        
        // 3. APPLY COINSURANCE (only if amount remains after copay)
        double coinsuranceApplied = 0;
        
        if (remainingAfterCopay > 0) {
            coinsuranceApplied = remainingAfterCopay * coinsuranceRate;
        }
        
        // Base patient responsibility for THIS CLAIM
        double basePatientResponsibility = deductibleApplied + copayApplied + coinsuranceApplied;
        
        // 4. APPLY OOP MAX LOGIC
        double actualPatientPays;
        double oopSavings = 0;
        double oopApplied = 0;
        
        if (oopPaid >= oopMax) {
            // Already reached OOP Max - patient pays NOTHING
            actualPatientPays = 0;
            oopSavings = basePatientResponsibility; // Full savings
            oopApplied = 0;
            
            // Update OOP tracking (already at max)
            coverage.setOopPaidThisYear(oopMax);
            coverage.setOopRemaining(0.0);
            
        } else if (oopPaid + basePatientResponsibility > oopMax) {
            // Would exceed OOP Max
            double roomUntilMax = oopMax - oopPaid;
            actualPatientPays = roomUntilMax; // Patient pays only up to max
            oopSavings = basePatientResponsibility - actualPatientPays; // Insurance covers the rest
            oopApplied = actualPatientPays;
            
            // Update OOP tracking (reached max)
            coverage.setOopPaidThisYear(oopMax);
            coverage.setOopRemaining(0.0);
            
        } else {
            // Within OOP Max
            actualPatientPays = basePatientResponsibility;
            oopSavings = 0;
            oopApplied = actualPatientPays;
            
            // Update OOP tracking
            coverage.setOopPaidThisYear(oopPaid + actualPatientPays);
            coverage.setOopRemaining(oopMax - (oopPaid + actualPatientPays));
        }
        
        // 5. UPDATE DEDUCTIBLE TRACKING
        coverage.setDeductiblePaidThisYear(deductiblePaid + deductibleApplied);
        coverage.setDeductibleRemaining(Math.max(0, deductible - (deductiblePaid + deductibleApplied)));
        patientCoverageRepository.save(coverage);
        
        // 6. Calculate insurance payment
        double insurancePays = amountToProcess - actualPatientPays;
        
        // Return: [actualPatientPays, oopSavings, oopApplied, deductibleApplied, copayApplied, coinsuranceApplied, insurancePays]
        return new double[]{
            actualPatientPays,      // 0 - What patient actually pays
            oopSavings,             // 1 - OOP savings
            oopApplied,             // 2 - OOP amount applied
            deductibleApplied,      // 3 - Deductible applied
            copayApplied,           // 4 - Copay amount (ACTUALLY APPLIED, not full copay)
            coinsuranceApplied,     // 5 - Coinsurance amount
            insurancePays           // 6 - Insurance payment
        };
    }
    
    // Test calculation for debugging
    public Map<String, Object> testCalculation(double billedAmount, 
                                              double primaryDeductible, double primaryCopay, double primaryCoinsurancePct,
                                              double secondaryDeductible, double secondaryCopay, double secondaryCoinsurancePct) {
        
        Map<String, Object> result = new HashMap<>();
        
        // Simulate primary processing
        double remaining = billedAmount;
        
        // Primary deductible
        double primDeductApplied = Math.min(remaining, primaryDeductible);
        remaining -= primDeductApplied;
        
        // Primary copay
        double primCopayApplied = Math.min(remaining, primaryCopay);
        remaining -= primCopayApplied;
        
        // Primary coinsurance (patient pays percentage)
        double primCoinsurance = remaining * (primaryCoinsurancePct / 100.0);
        double primInsurancePays = remaining - primCoinsurance;
        
        double primaryPatientPays = primDeductApplied + primCopayApplied + primCoinsurance;
        double primaryInsurancePays = billedAmount - primaryPatientPays;
        
        // What goes to secondary
        double toSecondary = primaryPatientPays;
        
        // Secondary processing
        double secRemaining = toSecondary;
        double secDeductApplied = 0;
        double secCopayApplied = 0;
        double secCoinsurance = 0;
        
        if (secRemaining > 0) {
            // Secondary deductible
            secDeductApplied = Math.min(secRemaining, secondaryDeductible);
            secRemaining -= secDeductApplied;
            
            // Secondary copay (only if amount left)
            if (secRemaining > 0) {
                secCopayApplied = Math.min(secRemaining, secondaryCopay);
                secRemaining -= secCopayApplied;
            }
            
            // Secondary coinsurance (only if amount left)
            if (secRemaining > 0) {
                secCoinsurance = secRemaining * (secondaryCoinsurancePct / 100.0);
                secRemaining -= secCoinsurance;
            }
        }
        
        double secondaryPatientPays = secDeductApplied + secCopayApplied + secCoinsurance;
        double secondaryInsurancePays = toSecondary - secondaryPatientPays;
        
        double totalPatientPays = secondaryPatientPays;
        
        result.put("billedAmount", billedAmount);
        result.put("primaryPatientPays", primaryPatientPays);
        result.put("primaryInsurancePays", primaryInsurancePays);
        result.put("primaryBreakdown", Map.of(
            "deductible", primDeductApplied,
            "copay", primCopayApplied,
            "coinsurance", primCoinsurance
        ));
        result.put("toSecondary", toSecondary);
        result.put("secondaryPatientPays", secondaryPatientPays);
        result.put("secondaryInsurancePays", secondaryInsurancePays);
        result.put("secondaryBreakdown", Map.of(
            "deductible", secDeductApplied,
            "copay", secCopayApplied,
            "coinsurance", secCoinsurance
        ));
        result.put("totalPatientPays", totalPatientPays);
        result.put("totalInsurancePays", primaryInsurancePays + secondaryInsurancePays);
        
        return result;
    }
    
    // Get settlement details for a claim
    public Settlement getSettlementByClaimId(int claimId) {
        return settlementRepository.findByClaimId(claimId);
    }
    
    // Get all settlements
    public List<Settlement> getAllSettlements() {
        return settlementRepository.findAll();
    }
    
    // Annual reset of deductibles and OOP
    @Scheduled(cron = "0 0 0 1 1 *")
    @Transactional
    public void resetAnnualLimits() {
        List<PatientCoverage> allCoverages = patientCoverageRepository.findAll();
        
        for (PatientCoverage coverage : allCoverages) {
            // Reset deductible
            coverage.setDeductiblePaidThisYear(0.0);
            
            // Reset OOP
            coverage.setOopPaidThisYear(0.0);
            
            // Set remaining amounts from plan
            InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
            if (plan != null) {
                coverage.setDeductibleRemaining(plan.getDeductible());
                coverage.setOopRemaining(plan.getOutOfPocketMax());
            }
        }
        
        patientCoverageRepository.saveAll(allCoverages);
        System.out.println("Annual limits reset completed at " + LocalDate.now());
    }
}