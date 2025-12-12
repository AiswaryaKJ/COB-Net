package com.example.demo.bean;

import java.time.LocalDate;
import jakarta.persistence.*;

@Entity
@Table(name = "Claim")
public class Claim {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "claim_id")
    private int claimId;

    @Column(name = "billed_amount", nullable = false)
    private double billedAmount;

    @Column(name = "claim_date")
    private LocalDate claimDate;

    @Column(name = "diagnosis_code", length = 10)
    private String diagnosisCode;

    @Column(name = "procedure_code", length = 10)
    private String procedureCode;

    @Column(name = "status", length = 20)
    private String status = "Submitted"; // Default value

    @Column(name = "final_out_of_pocket")
    private Double finalOutOfPocket;

    // Relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "patient_id", nullable = false)
    private Patient patient;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "provider_id", nullable = false)
    private Provider provider;

    @Transient
    public Integer getPatientIdValue() {
        return this.patient != null ? this.patient.getPatientId() : null;
    }
    
    // Helper method to get provider ID directly (for queries)
    @Transient  
    public Integer getProviderIdValue() {
        return this.provider != null ? this.provider.getProviderId() : null;
    }
    
    // Helper method for display in admin interface
    public String getFormattedClaimDate() {
        return this.claimDate != null ? this.claimDate.toString() : "N/A";
    }
    
    // Helper method for display in admin interface
    public String getStatusBadgeClass() {
        if (this.status == null) return "";
        switch (this.status.toLowerCase()) {
            case "submitted": return "badge-submitted";
            case "processed": return "badge-processed";
            case "approved": return "badge-approved";
            case "denied": return "badge-denied";
            default: return "badge-pending";
        }
    }
    
    // Constructors
    public Claim() {
        this.claimDate = LocalDate.now();
        this.status = "Submitted";
    }
    
    public Claim(double billedAmount, String diagnosisCode, String procedureCode, 
                 Patient patient, Provider provider) {
        this();
        this.billedAmount = billedAmount;
        this.diagnosisCode = diagnosisCode;
        this.procedureCode = procedureCode;
        this.patient = patient;
        this.provider = provider;
    }
    
    // NEW: Insurer relationships
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "primary_insurer_id")
    private Insurer primaryInsurer;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "secondary_insurer_id")
    private Insurer secondaryInsurer;

    // NEW: Helper methods for insurer names
    @Transient
    public String getPrimaryInsurerName() {
        return primaryInsurer != null ? primaryInsurer.getPayerName() : null;
    }

    @Transient
    public String getSecondaryInsurerName() {
        return secondaryInsurer != null ? secondaryInsurer.getPayerName() : null;
    }

    // ... existing constructors, getters, and setters ...

    // NEW: Insurer getters and setters
    public Insurer getPrimaryInsurer() { return primaryInsurer; }
    public void setPrimaryInsurer(Insurer primaryInsurer) { 
        this.primaryInsurer = primaryInsurer; 
    }

    public Insurer getSecondaryInsurer() { return secondaryInsurer; }
    public void setSecondaryInsurer(Insurer secondaryInsurer) { 
        this.secondaryInsurer = secondaryInsurer; 
    }

    // Getters and Setters (including patient and provider)
    public int getClaimId() { return claimId; }
    public void setClaimId(int claimId) { this.claimId = claimId; }

    public double getBilledAmount() { return billedAmount; }
    public void setBilledAmount(double billedAmount) { this.billedAmount = billedAmount; }

    public LocalDate getClaimDate() { return claimDate; }
    public void setClaimDate(LocalDate claimDate) { this.claimDate = claimDate; }

    public String getDiagnosisCode() { return diagnosisCode; }
    public void setDiagnosisCode(String diagnosisCode) { this.diagnosisCode = diagnosisCode; }

    public String getProcedureCode() { return procedureCode; }
    public void setProcedureCode(String procedureCode) { this.procedureCode = procedureCode; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Double getFinalOutOfPocket() { return finalOutOfPocket; }
    public void setFinalOutOfPocket(Double finalOutOfPocket) { this.finalOutOfPocket = finalOutOfPocket; }

    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }

    public Provider getProvider() { return provider; }
    public void setProvider(Provider provider) { this.provider = provider; }
}