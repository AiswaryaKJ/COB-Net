package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.bean.Claim;
import com.example.demo.bean.Patient;
import com.example.demo.bean.Provider;
import com.example.demo.dao.ClaimRepository;
import com.example.demo.dao.PatientRepository;
import com.example.demo.dao.ProviderRepository;

import java.util.List;
import java.util.Optional;

@Service
public class ProviderService {
    
    @Autowired
    private ClaimRepository claimRepository;
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private ProviderRepository providerRepository;
    
    // Submit a new claim
    @Transactional
    public Claim submitClaim(Claim claim) {
        // Validate patient exists
        Patient patient = patientRepository.findById(claim.getPatient().getPatientId())
            .orElseThrow(() -> new RuntimeException("Patient not found with ID: " + claim.getPatient().getPatientId()));
        
        // Validate provider exists
        Provider provider = providerRepository.findById(claim.getProvider().getProviderId())
            .orElseThrow(() -> new RuntimeException("Provider not found with ID: " + claim.getProvider().getProviderId()));
        
        // Set the validated entities
        claim.setPatient(patient);
        claim.setProvider(provider);
        
        // Set default status if not set
        if (claim.getStatus() == null) {
            claim.setStatus("Submitted");
        }
        
        // Set claim date if not set
        if (claim.getClaimDate() == null) {
            claim.setClaimDate(java.time.LocalDate.now());
        }
        
        return claimRepository.save(claim);
    }
    
    // Get all claims
    public List<Claim> getAllClaims() {
        return claimRepository.findAll();
    }
    
    // Get claim by ID
    public Claim getClaimById(int claimId) {
        return claimRepository.findById(claimId)
            .orElseThrow(() -> new RuntimeException("Claim not found with ID: " + claimId));
    }
    
    // Update claim status
    @Transactional
    public Claim updateClaimStatus(int claimId, String status) {
        Claim claim = claimRepository.findById(claimId)
            .orElseThrow(() -> new RuntimeException("Claim not found with ID: " + claimId));
        
        claim.setStatus(status);
        return claimRepository.save(claim);
    }
    
    // Delete claim
    @Transactional
    public void deleteClaim(int claimId) {
        if (!claimRepository.existsById(claimId)) {
            throw new RuntimeException("Claim not found with ID: " + claimId);
        }
        claimRepository.deleteById(claimId);
    }
    
    // Get claims by patient ID
    public List<Claim> getClaimsByPatientId(int patientId) {
        return claimRepository.findByPatientPatientId(patientId);
    }
    
    // Get claims by provider ID
    public List<Claim> getClaimsByProviderId(int providerId) {
        return claimRepository.findByProviderProviderId(providerId);
    }
    
    // Validate patient
    public Patient validatePatient(int patientId) {
        return patientRepository.findById(patientId)
            .orElseThrow(() -> new RuntimeException("Invalid Patient ID"));
    }
    
    // Validate provider
    public Provider validateProvider(int providerId) {
        return providerRepository.findById(providerId)
            .orElseThrow(() -> new RuntimeException("Invalid Provider ID"));
    }
}