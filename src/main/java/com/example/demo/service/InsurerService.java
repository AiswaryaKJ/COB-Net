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
    
    // Process a claim - WITH CORRECT OOPM LOGIC
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
        
        double totalPatientResponsibility = 0;
        double totalOopSavings = 0;
        double remainingForNextInsurance = billedAmount;
        
        // Process each insurance in order (Primary → Secondary)
        for (PatientCoverage coverage : coverages) {
            InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
            if (plan == null) continue;
            
            if (coverage.getCoverageOrder() == 1) {
                // PRIMARY INSURANCE
                settlement.setPrimaryPlanId(plan.getPlanId());
                double[] primaryResult = processInsuranceWithCorrectOopM(
                    plan, coverage, remainingForNextInsurance, true);
                
                double primaryPatientPays = primaryResult[0];
                double primaryOopSavings = primaryResult[1];
                double primaryOopApplied = primaryResult[2];
                double primaryDeductibleApplied = primaryResult[3];
                double primaryCopay = primaryResult[4];
                double primaryCoinsurance = primaryResult[5];
                
                settlement.setPrimaryCopay(primaryCopay);
                settlement.setPrimaryDeductibleApplied(primaryDeductibleApplied);
                settlement.setCoinsuranceAmount(primaryCoinsurance);
                settlement.setPrimaryOopApplied(primaryOopApplied);
                
                totalPatientResponsibility = primaryPatientPays;
                totalOopSavings += primaryOopSavings;
                
                // What's left for secondary insurance = what patient would pay after primary
                remainingForNextInsurance = primaryPatientPays;
                
                // Calculate primary insurance payment
                double primaryInsurancePays = billedAmount - totalPatientResponsibility;
                settlement.setPrimaryInsurancePaid(primaryInsurancePays);
                
            } else if (coverage.getCoverageOrder() == 2) {
                // SECONDARY INSURANCE (processes what primary didn't cover)
                settlement.setSecondaryPlanId(plan.getPlanId());
                double[] secondaryResult = processInsuranceWithCorrectOopM(
                    plan, coverage, totalPatientResponsibility, false);
                
                double secondaryPatientPays = secondaryResult[0];
                double secondaryOopSavings = secondaryResult[1];
                double secondaryOopApplied = secondaryResult[2];
                double secondaryDeductibleApplied = secondaryResult[3];
                double secondaryCopay = secondaryResult[4];
                double secondaryCoinsurance = secondaryResult[5];
                
                settlement.setSecondaryCopay(secondaryCopay);
                settlement.setSecondaryDeductibleApplied(secondaryDeductibleApplied);
                settlement.setCoinsuranceAmount(settlement.getCoinsuranceAmount() + secondaryCoinsurance);
                settlement.setSecondaryOopApplied(secondaryOopApplied);
                
                totalPatientResponsibility = secondaryPatientPays;
                totalOopSavings += secondaryOopSavings;
                
                // Calculate secondary insurance payment
                double secondaryInsurancePays = billedAmount - totalPatientResponsibility - settlement.getPrimaryInsurancePaid();
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
    
    // CORRECT OOPM LOGIC - cumulative tracking
    private double[] processInsuranceWithCorrectOopM(InsurancePlan plan, PatientCoverage coverage, 
                                                     double amountToProcess, boolean isPrimary) {
        
        // Get current tracking values
        double deductible = plan.getDeductible();
        double copay = plan.getCopay();
        double coinsuranceRate = plan.getCoinsurance() / 100.0;
        double oopMax = plan.getOutOfPocketMax();
        
        // Current patient payments for this plan (cumulative for the year)
        double deductiblePaid = coverage.getDeductiblePaidThisYear() != null ? 
                               coverage.getDeductiblePaidThisYear() : 0.0;
        double oopPaid = coverage.getOopPaidThisYear() != null ? 
                        coverage.getOopPaidThisYear() : 0.0;
        
        // 1. CALCULATE BASE AMOUNTS for this claim
        double deductibleApplied = 0;
        double remainingAfterDeductible = amountToProcess;
        
        // Apply deductible if not met for the year
        if (deductiblePaid < deductible) {
            double deductibleRemaining = deductible - deductiblePaid;
            deductibleApplied = Math.min(amountToProcess, deductibleRemaining);
            remainingAfterDeductible = amountToProcess - deductibleApplied;
        }
        
        // Apply copay (always applies per service)
        double remainingAfterCopay = Math.max(0, remainingAfterDeductible - copay);
        
        // Apply coinsurance (patient pays percentage of remaining)
        double patientCoinsurance = remainingAfterCopay * coinsuranceRate;
        
        // Base patient responsibility for THIS CLAIM
        double basePatientResponsibility = deductibleApplied + copay + patientCoinsurance;
        
        // 2. APPLY OOP MAX LOGIC (cumulative)
        double actualPatientPays;
        double oopSavings = 0;
        double oopApplied = 0;
        
        if (oopPaid >= oopMax) {
            // Already reached OOP Max for the year - patient pays NOTHING for this claim
            actualPatientPays = 0;
            oopSavings = basePatientResponsibility; // Full savings
            oopApplied = 0;
            
        } else if (oopPaid + basePatientResponsibility > oopMax) {
            // This claim would push patient over OOP Max
            double roomUntilMax = oopMax - oopPaid;
            actualPatientPays = roomUntilMax; // Patient pays only up to OOP Max
            oopSavings = basePatientResponsibility - actualPatientPays;
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
        
        // 3. UPDATE DEDUCTIBLE TRACKING
        coverage.setDeductiblePaidThisYear(deductiblePaid + deductibleApplied);
        coverage.setDeductibleRemaining(Math.max(0, deductible - (deductiblePaid + deductibleApplied)));
        patientCoverageRepository.save(coverage);
        
        // Return: [actualPatientPays, oopSavings, oopApplied, deductibleApplied, copay, patientCoinsurance]
        return new double[]{
            actualPatientPays,    // 0 - What patient actually pays for this claim
            oopSavings,           // 1 - OOP savings due to reaching max
            oopApplied,           // 2 - OOP amount applied
            deductibleApplied,    // 3 - Deductible applied for this claim
            copay,                // 4 - Copay amount
            patientCoinsurance    // 5 - Coinsurance amount
        };
    }
    
    // Calculate how insurance processes work (example from your explanation)
    public Map<String, Object> calculateInsuranceExample(double billedAmount) {
        Map<String, Object> result = new HashMap<>();
        
        // Example insurance plans (hardcoded for demonstration)
        Map<String, Object> primaryPlan = new HashMap<>();
        primaryPlan.put("copay", 75.00);
        primaryPlan.put("deductible", 2000.00);
        primaryPlan.put("coinsurance", 30.0); // Patient pays 30%
        primaryPlan.put("oopMax", 6000.00);
        
        Map<String, Object> secondaryPlan = new HashMap<>();
        secondaryPlan.put("copay", 20.00);
        secondaryPlan.put("deductible", 500.00);
        secondaryPlan.put("coinsurance", 5.0); // Patient pays 5%
        secondaryPlan.put("oopMax", 3000.00);
        
        // Track running totals
        double runningPrimaryOop = 0;
        double runningSecondaryOop = 0;
        
        // Primary Insurance Calculation
        double remaining = billedAmount;
        
        // 1. Primary Deductible
        double primaryDeductibleApplied = Math.min(remaining, 2000.00);
        remaining -= primaryDeductibleApplied;
        runningPrimaryOop += primaryDeductibleApplied;
        
        // 2. Primary Copay
        double primaryCopay = 75.00;
        remaining -= primaryCopay;
        runningPrimaryOop += primaryCopay;
        
        // 3. Primary Coinsurance (30% patient responsibility)
        double primaryPatientCoinsurance = remaining * 0.30;
        double primaryInsurancePaysCoinsurance = remaining * 0.70;
        runningPrimaryOop += primaryPatientCoinsurance;
        
        // What goes to secondary insurance
        double toSecondary = primaryPatientCoinsurance;
        
        // Secondary Insurance Calculation
        double secondaryRemaining = toSecondary;
        
        // 1. Secondary Deductible
        double secondaryDeductibleApplied = Math.min(secondaryRemaining, 500.00);
        secondaryRemaining -= secondaryDeductibleApplied;
        runningSecondaryOop += secondaryDeductibleApplied;
        
        // 2. Secondary Copay
        double secondaryCopay = 20.00;
        secondaryRemaining -= secondaryCopay;
        runningSecondaryOop += secondaryCopay;
        
        // 3. Secondary Coinsurance (5% patient responsibility)
        double secondaryPatientCoinsurance = secondaryRemaining * 0.05;
        double secondaryInsurancePaysCoinsurance = secondaryRemaining * 0.95;
        runningSecondaryOop += secondaryPatientCoinsurance;
        
        // Total patient responsibility BEFORE OOPM
        double totalPatientBeforeOopm = runningPrimaryOop + runningSecondaryOop;
        
        // Apply OOP Max limits
        double primaryOopApplied = Math.min(runningPrimaryOop, 6000.00);
        double secondaryOopApplied = Math.min(runningSecondaryOop, 3000.00);
        double totalPatientAfterOopm = primaryOopApplied + secondaryOopApplied;
        
        double oopSavings = totalPatientBeforeOopm - totalPatientAfterOopm;
        
        result.put("billedAmount", billedAmount);
        result.put("primaryDeductibleApplied", primaryDeductibleApplied);
        result.put("primaryCopay", primaryCopay);
        result.put("primaryPatientCoinsurance", primaryPatientCoinsurance);
        result.put("primaryInsurancePays", billedAmount - runningPrimaryOop);
        result.put("secondaryDeductibleApplied", secondaryDeductibleApplied);
        result.put("secondaryCopay", secondaryCopay);
        result.put("secondaryPatientCoinsurance", secondaryPatientCoinsurance);
        result.put("secondaryInsurancePays", toSecondary - runningSecondaryOop);
        result.put("totalPatientBeforeOopm", totalPatientBeforeOopm);
        result.put("totalPatientAfterOopm", totalPatientAfterOopm);
        result.put("oopSavings", oopSavings);
        result.put("primaryOopUsed", runningPrimaryOop);
        result.put("secondaryOopUsed", runningSecondaryOop);
        result.put("primaryOopRemaining", 6000.00 - runningPrimaryOop);
        result.put("secondaryOopRemaining", 3000.00 - runningSecondaryOop);
        
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