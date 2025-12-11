package com.example.demo.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.demo.bean.Claim;
import java.util.List;

@Repository
public interface ClaimRepository extends JpaRepository<Claim, Integer> {
    
    // Find claims by patient ID
    List<Claim> findByPatientPatientId(int patientId);
    
    // Find claims by provider ID
    List<Claim> findByProviderProviderId(int providerId);
    
    // Find claims by status
    List<Claim> findByStatus(String status);
    
    // Find claims by date range
    List<Claim> findByClaimDateBetween(java.time.LocalDate startDate, java.time.LocalDate endDate);
    
    @Query("SELECT c FROM Claim c WHERE c.patient.patientId = :patientId AND c.status = :status")
    List<Claim> findByPatientIdAndStatus(@Param("patientId") int patientId, @Param("status") String status);
    
    // NEW: Get all claims for a patient
    @Query("SELECT c FROM Claim c WHERE c.patient.patientId = :patientId")
    List<Claim> findByPatientId(@Param("patientId") int patientId);
}