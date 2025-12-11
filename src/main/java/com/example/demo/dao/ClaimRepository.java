package com.example.demo.dao;

import org.springframework.data.jpa.repository.JpaRepository;
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
}