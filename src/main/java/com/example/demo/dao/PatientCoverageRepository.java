package com.example.demo.dao;

import com.example.demo.bean.PatientCoverage;
import com.example.demo.bean.PatientCoverageId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PatientCoverageRepository extends JpaRepository<PatientCoverage, PatientCoverageId> {
    
    // Find all coverages for a patient
    @Query("SELECT pc FROM PatientCoverage pc WHERE pc.patientId = :patientId")
    List<PatientCoverage> findByPatientId(@Param("patientId") int patientId);
    
    // Find primary coverage (coverage_order = 1)
    @Query("SELECT pc FROM PatientCoverage pc WHERE pc.patientId = :patientId AND pc.coverageOrder = 1")
    Optional<PatientCoverage> findPrimaryCoverage(@Param("patientId") int patientId);

 // NEW: Find coverage by patient ID and order
    @Query("SELECT pc FROM PatientCoverage pc WHERE pc.patientId = :patientId AND pc.coverageOrder = :coverageOrder")
    Optional<PatientCoverage> findByPatientIdAndCoverageOrder(@Param("patientId") int patientId, 
                                                              @Param("coverageOrder") int coverageOrder);
    
    // Find by plan ID
    List<PatientCoverage> findByPlanId(int planId);
}