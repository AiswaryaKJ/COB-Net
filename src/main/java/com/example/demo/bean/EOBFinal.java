package com.example.demo.bean;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "eob_final")
public class EOBFinal {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "eob_final_id")
    private int eobFinalId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "claim_id", nullable = false)
    private Claim claim;

    @Column(name = "total_billed_amount", nullable = false)
    private double totalBilledAmount;

    @Column(name = "total_patient_responsibility")
    private double totalPatientResponsibility = 0.0;

    @Column(name = "total_insurance_payment")
    private double totalInsurancePayment = 0.0;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "primary_eob_id")
    private EOB1 primaryEOB;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "secondary_eob_id")
    private EOB2 secondaryEOB;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
    }

    // Getters and Setters
    public int getEobFinalId() { return eobFinalId; }
    public void setEobFinalId(int eobFinalId) { this.eobFinalId = eobFinalId; }

    public Claim getClaim() { return claim; }
    public void setClaim(Claim claim) { this.claim = claim; }

    public double getTotalBilledAmount() { return totalBilledAmount; }
    public void setTotalBilledAmount(double totalBilledAmount) { this.totalBilledAmount = totalBilledAmount; }

    public double getTotalPatientResponsibility() { return totalPatientResponsibility; }
    public void setTotalPatientResponsibility(double totalPatientResponsibility) { 
        this.totalPatientResponsibility = totalPatientResponsibility; 
    }

    public double getTotalInsurancePayment() { return totalInsurancePayment; }
    public void setTotalInsurancePayment(double totalInsurancePayment) { 
        this.totalInsurancePayment = totalInsurancePayment; 
    }

    public EOB1 getPrimaryEOB() { return primaryEOB; }
    public void setPrimaryEOB(EOB1 primaryEOB) { this.primaryEOB = primaryEOB; }

    public EOB2 getSecondaryEOB() { return secondaryEOB; }
    public void setSecondaryEOB(EOB2 secondaryEOB) { this.secondaryEOB = secondaryEOB; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}