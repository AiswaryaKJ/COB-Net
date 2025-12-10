package com.example.demo.bean;
import java.io.Serializable;
import java.util.Objects;

public class PatientCoverageId implements Serializable {
    private int patientId;
    private int planId;

    public PatientCoverageId() {}

    public PatientCoverageId(int patientId, int planId) {
        this.patientId = patientId;
        this.planId = planId;
    }

    // Getters and Setters
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    // equals and hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof PatientCoverageId)) return false;
        PatientCoverageId that = (PatientCoverageId) o;
        return patientId == that.patientId && planId == that.planId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(patientId, planId);
    }
}
