package com.example.demo.bean;
import java.time.LocalDate;
import jakarta.persistence.*;

@Entity
@Table(name = "PatientCoverage")
@IdClass(PatientCoverageId.class)
public class PatientCoverage {
    @Id
    @Column(name = "patient_id")
    private int patientId;

    @Id
    @Column(name = "plan_id")
    private int planId;

    @Column(name = "coverage_order")
    private int coverageOrder;

    @Column(name = "effective_date")
    private LocalDate effectiveDate;

    @Column(name = "termination_date")
    private LocalDate terminationDate;
    
    // Deductible tracking
    @Column(name = "deductible_paid_this_year")
    private Double deductiblePaidThisYear = 0.0;
    
    @Column(name = "deductible_remaining")
    private Double deductibleRemaining;
    
    // OOP Max tracking PER PLAN
    @Column(name = "oop_paid_this_year")
    private Double oopPaidThisYear = 0.0;
    
    @Column(name = "oop_remaining")
    private Double oopRemaining;
    
    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false, insertable = false, updatable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "plan_id", nullable = false, insertable = false, updatable = false)
    private InsurancePlan insurancePlan;

    // Constructor to initialize
    public PatientCoverage() {
        this.deductiblePaidThisYear = 0.0;
        this.oopPaidThisYear = 0.0;
    }
    
    // Getters and Setters
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    public int getCoverageOrder() { return coverageOrder; }
    public void setCoverageOrder(int coverageOrder) { this.coverageOrder = coverageOrder; }

    public LocalDate getEffectiveDate() { return effectiveDate; }
    public void setEffectiveDate(LocalDate effectiveDate) { this.effectiveDate = effectiveDate; }

    public LocalDate getTerminationDate() { return terminationDate; }
    public void setTerminationDate(LocalDate terminationDate) { this.terminationDate = terminationDate; }
    
    // Deductible getters and setters
    public Double getDeductiblePaidThisYear() { 
        return deductiblePaidThisYear != null ? deductiblePaidThisYear : 0.0; 
    }
    
    public void setDeductiblePaidThisYear(Double deductiblePaidThisYear) { 
        this.deductiblePaidThisYear = deductiblePaidThisYear != null ? deductiblePaidThisYear : 0.0; 
    }
    
    public Double getDeductibleRemaining() { 
        return deductibleRemaining; 
    }
    
    public void setDeductibleRemaining(Double deductibleRemaining) { 
        this.deductibleRemaining = deductibleRemaining; 
    }
    
    // OOP getters and setters
    public Double getOopPaidThisYear() { 
        return oopPaidThisYear != null ? oopPaidThisYear : 0.0; 
    }
    
    public void setOopPaidThisYear(Double oopPaidThisYear) { 
        this.oopPaidThisYear = oopPaidThisYear; 
    }
    
    public Double getOopRemaining() { return oopRemaining; }
    public void setOopRemaining(Double oopRemaining) { this.oopRemaining = oopRemaining; }
    
    // Relationship getters and setters
    public Patient getPatient() { return patient; }
    public void setPatient(Patient patient) { this.patient = patient; }
    
    public InsurancePlan getInsurancePlan() { return insurancePlan; }
    public void setInsurancePlan(InsurancePlan insurancePlan) { this.insurancePlan = insurancePlan; }
}