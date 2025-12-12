package com.example.demo.bean;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "eob2")
public class EOB2 {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "eob2_id")
    private int eob2Id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "claim_id", nullable = false)
    private Claim claim;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "insurer_id", nullable = false)
    private Insurer insurer;

    @Column(name = "billed_amount", nullable = false)
    private double billedAmount;

    @Column(name = "deductible_applied")
    private double deductibleApplied = 0.0;

    @Column(name = "copay_applied")
    private double copayApplied = 0.0;

    @Column(name = "coinsurance_applied")
    private double coinsuranceApplied = 0.0;

    @Column(name = "patient_responsibility")
    private double patientResponsibility = 0.0;

    @Column(name = "insurer_payment")
    private double insurerPayment = 0.0;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // Getters and Setters (similar to EOB1)
    public int getEob2Id() { return eob2Id; }
    public void setEob2Id(int eob2Id) { this.eob2Id = eob2Id; }

    public Claim getClaim() { return claim; }
    public void setClaim(Claim claim) { this.claim = claim; }

    public Insurer getInsurer() { return insurer; }
    public void setInsurer(Insurer insurer) { this.insurer = insurer; }

    public double getBilledAmount() { return billedAmount; }
    public void setBilledAmount(double billedAmount) { this.billedAmount = billedAmount; }

    public double getDeductibleApplied() { return deductibleApplied; }
    public void setDeductibleApplied(double deductibleApplied) { this.deductibleApplied = deductibleApplied; }

    public double getCopayApplied() { return copayApplied; }
    public void setCopayApplied(double copayApplied) { this.copayApplied = copayApplied; }

    public double getCoinsuranceApplied() { return coinsuranceApplied; }
    public void setCoinsuranceApplied(double coinsuranceApplied) { this.coinsuranceApplied = coinsuranceApplied; }

    public double getPatientResponsibility() { return patientResponsibility; }
    public void setPatientResponsibility(double patientResponsibility) { this.patientResponsibility = patientResponsibility; }

    public double getInsurerPayment() { return insurerPayment; }
    public void setInsurerPayment(double insurerPayment) { this.insurerPayment = insurerPayment; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}