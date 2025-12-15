package com.example.demo.dao;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.example.demo.bean.Claim;
import com.example.demo.bean.PatientCoverage;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

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
    
 // NEW: Find claims by primary insurer and status
    List<Claim> findByPrimaryInsurerInsurerIdAndStatus(int insurerId, String status);
    
    // NEW: Find claims by secondary insurer and status
    List<Claim> findBySecondaryInsurerInsurerIdAndStatus(int insurerId, String status);
    
    // NEW: Find primary coverage by patient ID and order
    @Query("SELECT pc FROM PatientCoverage pc WHERE pc.patientId = :patientId AND pc.coverageOrder = 1")
    Optional<PatientCoverage> findPrimaryCoverage(@Param("patientId") int patientId);
    
    // NEW: Find coverage by patient ID and order
    @Query("SELECT pc FROM PatientCoverage pc WHERE pc.patientId = :patientId AND pc.coverageOrder = :coverageOrder")
    Optional<PatientCoverage> findByPatientIdAndCoverageOrder(@Param("patientId") int patientId, 
                                                              @Param("coverageOrder") int coverageOrder);

  
    // NEW: Find by primary insurer with multiple statuses
    @Query("SELECT c FROM Claim c WHERE c.primaryInsurer.insurerId = :insurerId AND c.status IN ('processed', 'paid')")
    List<Claim> findHistoryByPrimaryInsurer(@Param("insurerId") int insurerId);
    
    // NEW: Find by secondary insurer with multiple statuses
    @Query("SELECT c FROM Claim c WHERE c.secondaryInsurer.insurerId = :insurerId AND c.status IN ('processed', 'paid')")
    List<Claim> findHistoryBySecondaryInsurer(@Param("insurerId") int insurerId);
    
    // Helper method to get insurer from credentials
    @Query("SELECT c.insurer.insurerId FROM Credentials c WHERE c.userId = :userId")
    Optional<Integer> findInsurerIdByUserId(@Param("userId") int userId);
    
 // Add these methods
    List<Claim> findByPatientPatientIdAndStatus(int patientId, String status);
    Claim findByClaimIdAndPatientPatientId(int claimId, int patientId);
    long countByPatientPatientId(int patientId);
    long countByPatientPatientIdAndStatus(int patientId, String status);
    
}