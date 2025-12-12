package com.example.demo.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.demo.bean.Claim;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface ClaimRepository extends JpaRepository<Claim, Integer> {
    
    // Find claims by patient ID - using JPA property path
    List<Claim> findByPatientPatientId(int patientId);
    
    // Find claims by provider ID - using JPA property path  
    List<Claim> findByProviderProviderId(int providerId);
    
    // Find claims by status
    List<Claim> findByStatus(String status);
    
    // Find claims by date range
    List<Claim> findByClaimDateBetween(LocalDate startDate, LocalDate endDate);
    
    // Custom query for patient ID and status
    @Query("SELECT c FROM Claim c WHERE c.patient.patientId = :patientId AND c.status = :status")
    List<Claim> findByPatientIdAndStatus(@Param("patientId") int patientId, @Param("status") String status);
    
    // Custom query for getting all claims by patient ID
    @Query("SELECT c FROM Claim c WHERE c.patient.patientId = :patientId")
    List<Claim> findByPatientId(@Param("patientId") int patientId);
    
    // Custom query for getting all claims by provider ID
    @Query("SELECT c FROM Claim c WHERE c.provider.providerId = :providerId")
    List<Claim> findByProviderId(@Param("providerId") int providerId);
    
    // NEW: Count claims by status - ADD THIS METHOD
    @Query("SELECT COUNT(c) FROM Claim c WHERE c.status = :status")
    Integer countClaimsByStatus(@Param("status") String status);
    
    // NEW: Get total number of claims - ADD THIS METHOD
    @Query("SELECT COUNT(c) FROM Claim c")
    Integer getTotalClaimsCount();
    
    // NEW: Get sum of billed amount - ADD THIS METHOD
    @Query("SELECT COALESCE(SUM(c.billedAmount), 0) FROM Claim c")
    Double getTotalBilledAmount();
    
    // NEW: Get claims with specific statuses for dashboard - ADD THIS METHOD
    @Query("SELECT c FROM Claim c ORDER BY c.claimDate DESC")
    List<Claim> findAllOrderByDateDesc();
}