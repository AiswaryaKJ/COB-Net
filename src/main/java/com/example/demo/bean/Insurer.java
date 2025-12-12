package com.example.demo.bean;

import java.util.List;
import jakarta.persistence.*;

@Entity
@Table(name = "insurer")
public class Insurer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "insurer_id")
    private int insurerId;

    @Column(name = "payer_name", nullable = false, length = 100, unique = true)
    private String payerName;

    @Column(name = "address", length = 255)
    private String address;

    @Column(name = "phone", length = 20)
    private String phone;

    @Column(name = "email", length = 100)
    private String email;

    @OneToMany(mappedBy = "insurer", cascade = CascadeType.ALL)
    private List<InsurancePlan> insurancePlans;

    @Column(name = "created_at", updatable = false)
    private java.time.LocalDateTime createdAt;

    @Column(name = "updated_at")
    private java.time.LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = java.time.LocalDateTime.now();
        updatedAt = java.time.LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = java.time.LocalDateTime.now();
    }

    // Constructors
    public Insurer() {}

    public Insurer(String payerName) {
        this.payerName = payerName;
    }

    // Getters and Setters
    public int getInsurerId() { return insurerId; }
    public void setInsurerId(int insurerId) { this.insurerId = insurerId; }

    public String getPayerName() { return payerName; }
    public void setPayerName(String payerName) { this.payerName = payerName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public List<InsurancePlan> getInsurancePlans() { return insurancePlans; }
    public void setInsurancePlans(List<InsurancePlan> insurancePlans) { 
        this.insurancePlans = insurancePlans; 
    }

    public java.time.LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(java.time.LocalDateTime createdAt) { this.createdAt = createdAt; }

    public java.time.LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(java.time.LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Insurer{" +
                "insurerId=" + insurerId +
                ", payerName='" + payerName + '\'' +
                '}';
    }
}