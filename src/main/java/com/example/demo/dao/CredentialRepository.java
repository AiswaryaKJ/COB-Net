package com.example.demo.dao;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.example.demo.bean.Credentials;

import java.util.List;
import java.util.Optional;

public interface CredentialRepository extends JpaRepository<Credentials, Integer> {
    Optional<Credentials> findByUsername(String username);

    Optional<Credentials> findByPatient_PatientId(Integer patientId);
    Optional<Credentials> findByProvider_ProviderId(Integer providerId);

    // Correct delete method
    void deleteByProvider_ProviderId(int providerId);
    
 // In CredentialRepository.java
    @Query("SELECT c FROM Credentials c WHERE c.insurer.insurerId = :insurerId")
    Optional<Credentials> findByInsurerInsurerId(@Param("insurerId") int insurerId);
}
