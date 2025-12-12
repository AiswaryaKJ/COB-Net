package com.example.demo.service;

import com.example.demo.bean.Claim;
import com.example.demo.dao.ClaimRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@Service
public class ClaimService {
    
    @Autowired
    private ClaimRepository claimRepository;
    
    public List<Claim> getAllClaims() {
        // Use the ordered method for better display
        return claimRepository.findAllOrderByDateDesc();
    }
    
    public Map<String, Integer> getClaimsCountByStatus() {
        Map<String, Integer> counts = new HashMap<>();
        
        try {
            // Use the new repository methods for counting
            counts.put("Submitted", claimRepository.countClaimsByStatus("Submitted"));
            counts.put("Processed", claimRepository.countClaimsByStatus("Processed"));
            counts.put("Approved", claimRepository.countClaimsByStatus("Approved"));
            counts.put("Denied", claimRepository.countClaimsByStatus("Denied"));
            counts.put("Pending", claimRepository.countClaimsByStatus("Pending"));
        } catch (Exception e) {
            // Fallback to the original method if new methods fail
            System.out.println("Using fallback counting method: " + e.getMessage());
            
            // Initialize all status counts to 0
            counts.put("Submitted", 0);
            counts.put("Processed", 0);
            counts.put("Approved", 0);
            counts.put("Denied", 0);
            counts.put("Pending", 0);
            
            // Count claims by status
            List<Claim> allClaims = claimRepository.findAll();
            for (Claim claim : allClaims) {
                String status = claim.getStatus();
                if (status != null) {
                    counts.put(status, counts.getOrDefault(status, 0) + 1);
                }
            }
        }
        
        return counts;
    }
    
    public Integer getTotalClaims() {
        try {
            return claimRepository.getTotalClaimsCount();
        } catch (Exception e) {
            // Fallback
            return claimRepository.findAll().size();
        }
    }
    
    public Double getTotalBilledAmount() {
        try {
            Double amount = claimRepository.getTotalBilledAmount();
            return amount != null ? amount : 0.0;
        } catch (Exception e) {
            // Fallback
            return claimRepository.findAll().stream()
                    .mapToDouble(Claim::getBilledAmount)
                    .sum();
        }
    }
    
    // ADD THESE NEW HELPER METHODS FOR THE ADMIN DASHBOARD
    
    public List<Claim> getClaimsByStatus(String status) {
        return claimRepository.findByStatus(status);
    }
    
    public List<Claim> getRecentClaims(int limit) {
        List<Claim> allClaims = claimRepository.findAllOrderByDateDesc();
        return allClaims.size() > limit ? allClaims.subList(0, limit) : allClaims;
    }
    
    public Map<String, Double> getAverageAmountByStatus() {
        Map<String, Double> averages = new HashMap<>();
        List<String> statuses = List.of("Submitted", "Processed", "Approved", "Denied", "Pending");
        
        for (String status : statuses) {
            List<Claim> claims = claimRepository.findByStatus(status);
            if (!claims.isEmpty()) {
                double avg = claims.stream()
                        .mapToDouble(Claim::getBilledAmount)
                        .average()
                        .orElse(0.0);
                averages.put(status, avg);
            } else {
                averages.put(status, 0.0);
            }
        }
        
        return averages;
    }
}