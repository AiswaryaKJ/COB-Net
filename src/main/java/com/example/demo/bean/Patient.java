package com.example.demo.bean;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import jakarta.persistence.*;

@Entity
@Table(name = "Patient")
public class Patient {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "patient_id")
    private int patientId;

    @Column(name = "first_name", nullable = false, length = 50)
    private String firstName;

    @Column(name = "last_name", nullable = false, length = 50)
    private String lastName;

    @Column(name = "dob")
    private LocalDate dob;

    @Column(name = "gender", length = 10)
    private String gender;

    @Column(name = "member_id", unique = true, length = 50)
    private String memberId;

    @Column(name = "contact_number", length = 15)
    private String contactNumber;

    @OneToMany(mappedBy = "patient")
    private List<Claim> claims;

    @OneToMany(mappedBy = "patient")
    private List<PatientCoverage> coverages;

    @Transient
    public Integer getId() {
        return this.patientId;
    }
    
    // Helper method for display
    public String getFullName() {
        return this.firstName + " " + this.lastName;
    }
    
    // Helper method for display
    public String getFormattedDob() {
        return this.dob != null ? this.dob.toString() : "N/A";
    }
    // Getters and Setters
    public int getPatientId() { return patientId; }
    public void setPatientId(int patientId) { this.patientId = patientId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public LocalDate getDob() { return dob; }
    public void setDob(LocalDate dob) { this.dob = dob; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getMemberId() { return memberId; }
    public void setMemberId(String memberId) { this.memberId = memberId; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

}
