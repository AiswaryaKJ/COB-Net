package com.example.demo.bean;

import java.time.LocalDate;
import jakarta.persistence.*;

@Entity
@Table(name = "ClaimPayment")
public class ClaimPayment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "payment_id")
    private int paymentId;   // Primary key for ClaimPayment

    @Column(name = "plan_id", nullable = false)
    private int planId;

    @Column(name = "paid_amount", nullable = false)
    private double paidAmount;

    @Column(name = "patient_responsibility", nullable = false)
    private double patientResponsibility;

    @Column(name = "payment_date")
    private LocalDate paymentDate;

    // Default constructor
    public ClaimPayment() {}

    @OneToOne
    @JoinColumn(name = "claim_id", nullable = false)
    private Claim claim;


    // Getters and Setters
    public int getPaymentId() { return paymentId; }
    public void setPaymentId(int paymentId) { this.paymentId = paymentId; }

    public int getPlanId() { return planId; }
    public void setPlanId(int planId) { this.planId = planId; }

    public double getPaidAmount() { return paidAmount; }
    public void setPaidAmount(double paidAmount) { this.paidAmount = paidAmount; }

    public double getPatientResponsibility() { return patientResponsibility; }
    public void setPatientResponsibility(double patientResponsibility) { this.patientResponsibility = patientResponsibility; }

    public LocalDate getPaymentDate() { return paymentDate; }
    public void setPaymentDate(LocalDate paymentDate) { this.paymentDate = paymentDate; }
}
