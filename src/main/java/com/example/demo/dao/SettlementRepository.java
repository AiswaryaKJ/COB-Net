package com.example.demo.dao;

import com.example.demo.bean.Settlement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SettlementRepository extends JpaRepository<Settlement, Integer> {
    
    // Find settlement by claim ID
    Settlement findByClaimId(int claimId);
    
    // Find all settlements for a patient
    List<Settlement> findByPatientId(int patientId);
    
    // Find all settlements for a provider
    List<Settlement> findByProviderId(int providerId);
    
    // Find settlements by status
    List<Settlement> findBySettlementStatus(String status);
}