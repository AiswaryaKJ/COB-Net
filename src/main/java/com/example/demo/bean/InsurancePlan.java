package com.example.demo.bean;

import java.util.List;

import jakarta.persistence.*;

@Entity
@Table(name = "InsurancePlan")
public class InsurancePlan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "plan_id")
    private int planId;

    @Column(name = "plan_name", nullable = false, length = 100)
    private String planName;

    @Column(name = "payer_name", nullable = false, length = 100)
    private String payerName;

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

    @OneToMany(mappedBy = "insurancePlan")
    private List<PatientCoverage> patientCoverages;


    // Getters and Setters
    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    public String getPlanName() { return planName; }
    public void setPlanName(String planName) { this.planName = planName; }

    public String getPayerName() { return payerName; }
    public void setPayerName(String payerName) { this.payerName = payerName; }

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
}
