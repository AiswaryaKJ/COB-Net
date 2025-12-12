package com.example.demo.bean;

import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "insurance_plan")
public class InsurancePlan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "plan_id")
    private int planId;

    @Column(name = "plan_name", nullable = false, length = 100)
    private String planName;

    // REMOVED: payerName field
    
    @Column(name = "policy_number", unique = true, nullable = false, length = 50)
    private String policyNumber;

    @Column(name = "plan_type", nullable = false, length = 20)
    private String planType; // Primary, Secondary, Tertiary

    @Column(name = "coverage_percent", nullable = false)
    private double coveragePercent;

    @Column(name = "deductible", nullable = false)
    private double deductible;

    @Column(name = "copay", nullable = false)
    private double copay;

    @Column(name = "coinsurance", nullable = false)
    private double coinsurance;
    
    @Column(name = "out_of_pocket_max", nullable = false)
    private double outOfPocketMax = 5000.00;

    // NEW: Relationship with Insurer
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "insurer_id", nullable = false)
    private Insurer insurer;

    @OneToMany(mappedBy = "insurancePlan")
    private List<PatientCoverage> patientCoverages;

    // Constructors
    public InsurancePlan() {
        this.outOfPocketMax = 5000.00;
    }

    // Getters and Setters
    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }

    // REMOVED: getPayerName() and setPayerName()
    
    public String getPolicyNumber() { return policyNumber; }
    public void setPolicyNumber(String policyNumber) { this.policyNumber = policyNumber; }

    public String getPlanType() { return planType; }
    public void setPlanType(String planType) { this.planType = planType; }

    public double getCoveragePercent() { return coveragePercent; }
    public void setCoveragePercent(double coveragePercent) { this.coveragePercent = coveragePercent; }

    public double getDeductible() { return deductible; }
    public void setDeductible(double deductible) { this.deductible = deductible; }

    public double getCopay() { return copay; }
    public void setCopay(double copay) { this.copay = copay; }

    public double getCoinsurance() { return coinsurance; }
    public void setCoinsurance(double coinsurance) { this.coinsurance = coinsurance; }
    
    public double getOutOfPocketMax() { return outOfPocketMax; }
    public void setOutOfPocketMax(double outOfPocketMax) { 
        this.outOfPocketMax = outOfPocketMax; 
    }

    // NEW: Insurer getter and setter
    public Insurer getInsurer() { return insurer; }
    public void setInsurer(Insurer insurer) { this.insurer = insurer; }

    // Convenience method to get payer name through insurer
    public String getPayerName() {
        return (insurer != null) ? insurer.getPayerName() : null;
    }

    public List<PatientCoverage> getPatientCoverages() { return patientCoverages; }
    public void setPatientCoverages(List<PatientCoverage> patientCoverages) { 
        this.patientCoverages = patientCoverages; 
    }

    @Override
    public String toString() {
        return "InsurancePlan{" +
                "planId=" + planId +
                ", planName='" + planName + '\'' +
                ", insurer=" + (insurer != null ? insurer.getPayerName() : "null") +
                ", policyNumber='" + policyNumber + '\'' +
                '}';
    }
}