package com.example.demo.service;

import com.example.demo.bean.*;
import com.example.demo.dao.*;
import org.springframework.beans.factory.annotation.Autowired;
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
    
    // Process a claim - MAIN LOGIC
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
        
        // Initialize calculation variables
        double remainingBill = billedAmount;
        double totalPatientResponsibility = 0;
        
        Settlement settlement = new Settlement();
        settlement.setClaimId(claimId);
        settlement.setPatientId(patientId);
        settlement.setProviderId(claim.getProvider().getProviderId());
        settlement.setBilledAmount(billedAmount);
        
        // Process each insurance
        for (PatientCoverage coverage : coverages) {
            InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
            if (plan == null) continue;
            
            if (coverage.getCoverageOrder() == 1) {
                // Primary Insurance
                settlement.setPrimaryPlanId(plan.getPlanId());
                processPrimaryInsurance(plan, coverage, remainingBill, settlement);
            } else if (coverage.getCoverageOrder() == 2) {
                // Secondary Insurance
                settlement.setSecondaryPlanId(plan.getPlanId());
                processSecondaryInsurance(plan, coverage, remainingBill, settlement);
            }
            
            // Update remaining bill for next insurance
            remainingBill = settlement.getTotalPatientResponsibility();
        }
        
        // Save settlement
        settlement = settlementRepository.save(settlement);
        
        // Update claim status
        claim.setStatus("Processed");
        claim.setFinalOutOfPocket(settlement.getTotalPatientResponsibility());
        claimRepository.save(claim);
        
        return settlement;
    }
    
    private void processPrimaryInsurance(InsurancePlan plan, PatientCoverage coverage, 
                                         double billedAmount, Settlement settlement) {
        
        double deductible = plan.getDeductible();
        double deductiblePaid = coverage.getDeductiblePaidThisYear() != null ? 
                               coverage.getDeductiblePaidThisYear() : 0;
        double deductibleRemaining = Math.max(0, deductible - deductiblePaid);
        
        double remainingAfterDeductible = billedAmount;
        double deductibleApplied = 0;
        
        // Apply deductible if needed
        if (deductibleRemaining > 0) {
            deductibleApplied = Math.min(billedAmount, deductibleRemaining);
            remainingAfterDeductible = billedAmount - deductibleApplied;
            
            // Update deductible tracking
            coverage.setDeductiblePaidThisYear(deductiblePaid + deductibleApplied);
            coverage.setDeductibleRemaining(deductible - (deductiblePaid + deductibleApplied));
            patientCoverageRepository.save(coverage);
        }
        
        // Apply copay
        double copay = plan.getCopay();
        double remainingAfterCopay = remainingAfterDeductible - copay;
        
        // Apply coinsurance (insurance pays 80%, patient pays 20%)
        double coinsuranceRate = plan.getCoinsurance() / 100.0; // e.g., 20% = 0.20
        double patientCoinsurance = remainingAfterCopay * coinsuranceRate;
        double insurancePays = remainingAfterCopay - patientCoinsurance;
        
        // Calculate patient responsibility for this insurance
        double patientResponsibility = deductibleApplied + copay + patientCoinsurance;
        
        // Update settlement
        settlement.setPrimaryCopay(copay);
        settlement.setPrimaryDeductibleApplied(deductibleApplied);
        settlement.setCoinsuranceAmount(patientCoinsurance);
        settlement.setPrimaryInsurancePaid(insurancePays);
        settlement.setTotalPatientResponsibility(patientResponsibility);
    }
    
    private void processSecondaryInsurance(InsurancePlan plan, PatientCoverage coverage, 
                                           double remainingFromPrimary, Settlement settlement) {
        
        // Secondary insurance processes what's left after primary
        double remainingBill = settlement.getTotalPatientResponsibility();
        
        double deductible = plan.getDeductible();
        double deductiblePaid = coverage.getDeductiblePaidThisYear() != null ? 
                               coverage.getDeductiblePaidThisYear() : 0;
        double deductibleRemaining = Math.max(0, deductible - deductiblePaid);
        
        double remainingAfterDeductible = remainingBill;
        double deductibleApplied = 0;
        
        // Apply deductible if needed
        if (deductibleRemaining > 0) {
            deductibleApplied = Math.min(remainingBill, deductibleRemaining);
            remainingAfterDeductible = remainingBill - deductibleApplied;
            
            // Update deductible tracking
            coverage.setDeductiblePaidThisYear(deductiblePaid + deductibleApplied);
            coverage.setDeductibleRemaining(deductible - (deductiblePaid + deductibleApplied));
            patientCoverageRepository.save(coverage);
        }
        
        // Apply copay
        double copay = plan.getCopay();
        double remainingAfterCopay = remainingAfterDeductible - copay;
        
        // Apply coinsurance
        double coinsuranceRate = plan.getCoinsurance() / 100.0;
        double patientCoinsurance = remainingAfterCopay * coinsuranceRate;
        double insurancePays = remainingAfterCopay - patientCoinsurance;
        
        // Calculate patient responsibility for this insurance
        double patientResponsibility = deductibleApplied + copay + patientCoinsurance;
        
        // Update settlement (add to existing amounts)
        settlement.setSecondaryCopay(copay);
        settlement.setSecondaryDeductibleApplied(deductibleApplied);
        settlement.setCoinsuranceAmount(settlement.getCoinsuranceAmount() + patientCoinsurance);
        settlement.setSecondaryInsurancePaid(insurancePays);
        settlement.setTotalPatientResponsibility(patientResponsibility);
    }
    
    // Get settlement details for a claim
    public Settlement getSettlementByClaimId(int claimId) {
        return settlementRepository.findByClaimId(claimId);
    }
    
    // Get all settlements
    public List<Settlement> getAllSettlements() {
        return settlementRepository.findAll();
    }
}