package com.example.demo.bean;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "Settlement")
public class Settlement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "settlement_id")
    private int settlementId;
    
    @Column(name = "claim_id", nullable = false)
    private int claimId;
    
    @Column(name = "patient_id", nullable = false)
    private int patientId;
    
    @Column(name = "provider_id", nullable = false)
    private int providerId;
    
    // Insurance Plan IDs
    @Column(name = "primary_plan_id")
    private Integer primaryPlanId;
    
    @Column(name = "secondary_plan_id")
    private Integer secondaryPlanId;
    
    // Amounts
    @Column(name = "billed_amount", nullable = false)
    private double billedAmount;
    
    // Patient Responsibility Breakdown
    @Column(name = "primary_copay")
    private double primaryCopay;
    
    @Column(name = "secondary_copay")
    private double secondaryCopay;
    
    @Column(name = "primary_deductible_applied")
    private double primaryDeductibleApplied;
    
    @Column(name = "secondary_deductible_applied")
    private double secondaryDeductibleApplied;
    
    @Column(name = "coinsurance_amount")
    private double coinsuranceAmount;
    
    @Column(name = "total_patient_responsibility")
    private double totalPatientResponsibility;
    
    // OOP Max Impact Tracking
    @Column(name = "primary_oop_applied")
    private Double primaryOopApplied = 0.0;
    
    @Column(name = "secondary_oop_applied")
    private Double secondaryOopApplied = 0.0;
    
    @Column(name = "total_oop_savings")
    private Double totalOopSavings = 0.0;
    
    // Insurance Payments
    @Column(name = "primary_insurance_paid")
    private double primaryInsurancePaid;
    
    @Column(name = "secondary_insurance_paid")
    private double secondaryInsurancePaid;
    
    // Status
    @Column(name = "settlement_status", length = 20)
    private String settlementStatus = "Processed";
    
    @Column(name = "processed_date")
    private LocalDate processedDate;
    
    // Relationships
    @ManyToOne
    @JoinColumn(name = "claim_id", insertable = false, updatable = false)
    private Claim claim;
    
    @ManyToOne
    @JoinColumn(name = "patient_id", insertable = false, updatable = false)
    private Patient patient;
    
    @ManyToOne
    @JoinColumn(name = "provider_id", insertable = false, updatable = false)
    private Provider provider;
    
    // Constructors
    public Settlement() {
        this.processedDate = LocalDate.now();
        this.primaryOopApplied = 0.0;
        this.secondaryOopApplied = 0.0;
        this.totalOopSavings = 0.0;
    }
    
    // Getters and Setters
    public int getSettlementId() { return settlementId; }
    public void setSettlementId(int settlementId) { this.settlementId = settlementId; }
    
    public int getClaimId() { return claimId; }
    public void setClaimId(int claimId) { this.claimId = claimId; }
    
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }
    
    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }
    
    public Integer getPrimaryPlanId() { return primaryPlanId; }
    public void setPrimaryPlanId(Integer primaryPlanId) { this.primaryPlanId = primaryPlanId; }
    
    public Integer getSecondaryPlanId() { return secondaryPlanId; }
    public void setSecondaryPlanId(Integer secondaryPlanId) { this.secondaryPlanId = secondaryPlanId; }
    
    public double getBilledAmount() { return billedAmount; }
    public void setBilledAmount(double billedAmount) { this.billedAmount = billedAmount; }
    
    public double getPrimaryCopay() { return primaryCopay; }
    public void setPrimaryCopay(double primaryCopay) { this.primaryCopay = primaryCopay; }
    
    public double getSecondaryCopay() { return secondaryCopay; }
    public void setSecondaryCopay(double secondaryCopay) { this.secondaryCopay = secondaryCopay; }
    
    public double getPrimaryDeductibleApplied() { return primaryDeductibleApplied; }
    public void setPrimaryDeductibleApplied(double primaryDeductibleApplied) { this.primaryDeductibleApplied = primaryDeductibleApplied; }
    
    public double getSecondaryDeductibleApplied() { return secondaryDeductibleApplied; }
    public void setSecondaryDeductibleApplied(double secondaryDeductibleApplied) { this.secondaryDeductibleApplied = secondaryDeductibleApplied; }
    
    public double getCoinsuranceAmount() { return coinsuranceAmount; }
    public void setCoinsuranceAmount(double coinsuranceAmount) { this.coinsuranceAmount = coinsuranceAmount; }
    
    public double getTotalPatientResponsibility() { return totalPatientResponsibility; }
    public void setTotalPatientResponsibility(double totalPatientResponsibility) { this.totalPatientResponsibility = totalPatientResponsibility; }
    
    // OOP Max Getters and Setters
    public Double getPrimaryOopApplied() { return primaryOopApplied; }
    public void setPrimaryOopApplied(Double primaryOopApplied) { this.primaryOopApplied = primaryOopApplied; }
    
    public Double getSecondaryOopApplied() { return secondaryOopApplied; }
    public void setSecondaryOopApplied(Double secondaryOopApplied) { this.secondaryOopApplied = secondaryOopApplied; }
    
    public Double getTotalOopSavings() { return totalOopSavings; }
    public void setTotalOopSavings(Double totalOopSavings) { this.totalOopSavings = totalOopSavings; }
    
    public double getPrimaryInsurancePaid() { return primaryInsurancePaid; }
    public void setPrimaryInsurancePaid(double primaryInsurancePaid) { this.primaryInsurancePaid = primaryInsurancePaid; }
    
    public double getSecondaryInsurancePaid() { return secondaryInsurancePaid; }
    public void setSecondaryInsurancePaid(double secondaryInsurancePaid) { this.secondaryInsurancePaid = secondaryInsurancePaid; }
    
    public String getSettlementStatus() { return settlementStatus; }
    public void setSettlementStatus(String settlementStatus) { this.settlementStatus = settlementStatus; }
    
    public LocalDate getProcessedDate() { return processedDate; }
    public void setProcessedDate(LocalDate processedDate) { this.processedDate = processedDate; }
    
    public Claim getClaim() { return claim; }
    public void setClaim(Claim claim) { this.claim = claim; }
    
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
    
    public Provider getProvider() { return provider; }
    public void setProvider(Provider provider) { this.provider = provider; }
}