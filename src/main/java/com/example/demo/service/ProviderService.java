package com.example.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.demo.bean.Claim;
import com.example.demo.bean.InsurancePlan;
import com.example.demo.bean.Patient;
import com.example.demo.bean.PatientCoverage;
import com.example.demo.bean.Provider;
import com.example.demo.dao.ClaimRepository;
import com.example.demo.dao.InsurancePlanRepository;
import com.example.demo.dao.PatientCoverageRepository;
import com.example.demo.dao.PatientRepository;
import com.example.demo.dao.ProviderRepository;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProviderService {
    
    @Autowired
    private ClaimRepository claimRepository;
    
    @Autowired
    private PatientRepository patientRepository;
    
    @Autowired
    private ProviderRepository providerRepository;
    
    @Autowired
    PatientCoverageRepository patientCoverageRepository;
    
    @Autowired
    InsurancePlanRepository insurancePlanRepository;
    
 // Submit a new claim WITH NETWORK CHECK
    @Transactional
    public Claim submitClaim(Claim claim) {
        // Validate provider exists and is IN-NETWORK
        Provider provider = providerRepository.findById(claim.getProvider().getProviderId())
            .orElseThrow(() -> new RuntimeException("Provider not found with ID: " + claim.getProvider().getProviderId()));
        
        // Check network status
        if (!"IN".equalsIgnoreCase(provider.getNetworkStatus())) {
            throw new RuntimeException("Provider is out of network. Network status: " + provider.getNetworkStatus());
        }
        
        // Validate patient exists
        Patient patient = patientRepository.findById(claim.getPatient().getPatientId())
            .orElseThrow(() -> new RuntimeException("Patient not found with ID: " + claim.getPatient().getPatientId()));
        
        // Get patient's insurance coverage
        List<PatientCoverage> coverages = patientCoverageRepository.findByPatientId(patient.getPatientId());
        
        // Set primary and secondary insurers from coverage
        coverages.sort((c1, c2) -> Integer.compare(c1.getCoverageOrder(), c2.getCoverageOrder()));
        
        for (PatientCoverage coverage : coverages) {
            InsurancePlan plan = insurancePlanRepository.findById(coverage.getPlanId()).orElse(null);
            if (plan != null && plan.getInsurer() != null) {
                if (coverage.getCoverageOrder() == 1) {
                    claim.setPrimaryInsurer(plan.getInsurer());
                } else if (coverage.getCoverageOrder() == 2) {
                    claim.setSecondaryInsurer(plan.getInsurer());
                }
            }
        }
        
        // Validate at least primary insurer exists
        if (claim.getPrimaryInsurer() == null) {
            throw new RuntimeException("Patient does not have primary insurance coverage");
        }
        
        // Set the validated entities
        claim.setPatient(patient);
        claim.setProvider(provider);
        
        // Set default status
        claim.setStatus("submitted");
        
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
    public Map<String, Object> getPatientWithClaims(int patientId) {
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        
        if (patientOpt.isEmpty()) {
            return null;
        }
        
        Patient patient = patientOpt.get();
        Map<String, Object> result = new HashMap<>();
        
        // Patient basic info
        result.put("patientId", patient.getPatientId());
        result.put("fullName", patient.getFirstName() + " " + patient.getLastName());
        result.put("firstName", patient.getFirstName());
        result.put("lastName", patient.getLastName());
        result.put("dob", patient.getDob());
        result.put("formattedDob", patient.getDob() != null ? patient.getDob().toString() : "N/A");
        result.put("gender", patient.getGender());
        result.put("memberId", patient.getMemberId());
        result.put("contactNumber", patient.getContactNumber());
        
        // Get claims for this patient
        List<Claim> patientClaims = claimRepository.findByPatientPatientId(patientId);
        
        // Add claims data
        result.put("totalClaims", patientClaims.size());
        
        if (!patientClaims.isEmpty()) {
            // Calculate total billed amount
            double totalBilled = patientClaims.stream()
                .mapToDouble(Claim::getBilledAmount)
                .sum();
            result.put("totalBilledAmount", totalBilled);
            
            // Count claims by status
            Map<String, Long> statusCounts = patientClaims.stream()
                .collect(java.util.stream.Collectors.groupingBy(
                    claim -> claim.getStatus() != null ? claim.getStatus() : "Unknown",
                    java.util.stream.Collectors.counting()
                ));
            result.put("statusCounts", statusCounts);
            
            // Add recent claims (last 3)
            List<Map<String, Object>> recentClaims = patientClaims.stream()
                .sorted((c1, c2) -> c2.getClaimDate().compareTo(c1.getClaimDate()))
                .limit(3)
                .map(claim -> {
                    Map<String, Object> claimInfo = new HashMap<>();
                    claimInfo.put("claimId", claim.getClaimId());
                    claimInfo.put("claimDate", claim.getClaimDate());
                    claimInfo.put("status", claim.getStatus());
                    claimInfo.put("billedAmount", claim.getBilledAmount());
                    claimInfo.put("diagnosisCode", claim.getDiagnosisCode());
                    return claimInfo;
                })
                .collect(java.util.stream.Collectors.toList());
            result.put("recentClaims", recentClaims);
        } else {
            result.put("totalBilledAmount", 0);
            result.put("statusCounts", new HashMap<>());
            result.put("recentClaims", new ArrayList<>());
        }
        
        return result;
    }

	public Integer getProviderIdByUsername(String name) {
		// TODO Auto-generated method stub
		return null;
	}

	
}