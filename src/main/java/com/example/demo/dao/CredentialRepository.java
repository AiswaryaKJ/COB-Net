package com.example.demo.dao;


import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.bean.Credentials;

import java.util.List;
import java.util.Optional;

public interface CredentialRepository extends JpaRepository<Credentials, Integer> {
    Optional<Credentials> findByUsername(String username);

    Optional<Credentials> findByPatient_PatientId(Integer patientId);
    Optional<Credentials> findByProvider_ProviderId(Integer providerId);

    // Correct delete method
    void deleteByProvider_ProviderId(int providerId);
}
