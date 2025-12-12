package com.example.demo.bean;

import jakarta.persistence.*;

@Entity
@Table(name = "Provider")
public class Provider {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "provider_id")
    private int providerId;

    @Column(name = "name", nullable = false, length = 100)
    private String name;

    @Column(name = "specialty", length = 100)
    private String specialty;

    @Column(name = "network_status", length = 10)
    private String networkStatus; // IN or OUT

    @Column(name = "npi", unique = true, length = 20)
    private String npi;
    
    @OneToOne(mappedBy = "provider", cascade = CascadeType.REMOVE, orphanRemoval = true)
    private Credentials credentials;

    @Transient
    public Integer getId() {
        return this.providerId;
    }
    
    // Helper method for display
    public String getDisplayName() {
        return this.name + (this.specialty != null ? " - " + this.specialty : "");
    }
    
    // Helper method for status display
    public String getNetworkStatusBadge() {
        if ("IN".equalsIgnoreCase(this.networkStatus)) {
            return "In-Network";
        } else if ("OUT".equalsIgnoreCase(this.networkStatus)) {
            return "Out-of-Network";
        }
        return this.networkStatus != null ? this.networkStatus : "Unknown";
    }
    // Getters and Setters
    public int getProviderId() { return providerId; }
    public void setProviderId(int providerId) { this.providerId = providerId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getSpecialty() { return specialty; }
    public void setSpecialty(String specialty) { this.specialty = specialty; }

    public String getNetworkStatus() { return networkStatus; }
    public void setNetworkStatus(String networkStatus) { this.networkStatus = networkStatus; }

    public String getNpi() { return npi; }
    public void setNpi(String npi) { this.npi = npi; }
}
