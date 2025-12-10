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
    
    @ManyToOne
    @JoinColumn(name = "patient_id", nullable = false, insertable = false, updatable = false)
    private Patient patient;

    @ManyToOne
    @JoinColumn(name = "plan_id", nullable = false, insertable = false, updatable = false)
    private InsurancePlan insurancePlan;


	public int getPatientId() {
		return patientId;
	}

	public void setPatientId(int patientId) {
		this.patientId = patientId;
	}

	public int getPlanId() {
		return planId;
	}

	public void setPlanId(int planId) {
		this.planId = planId;
	}

	public int getCoverageOrder() {
		return coverageOrder;
	}

	public void setCoverageOrder(int coverageOrder) {
		this.coverageOrder = coverageOrder;
	}

	public LocalDate getEffectiveDate() {
		return effectiveDate;
	}

	public void setEffectiveDate(LocalDate effectiveDate) {
		this.effectiveDate = effectiveDate;
	}

	public LocalDate getTerminationDate() {
		return terminationDate;
	}

	public void setTerminationDate(LocalDate terminationDate) {
		this.terminationDate = terminationDate;
	}

    // Getters and Setters...
}
