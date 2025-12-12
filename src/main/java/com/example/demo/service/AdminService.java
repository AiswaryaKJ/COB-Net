package com.example.demo.service;

import com.example.demo.bean.Provider;
import com.example.demo.dao.ProviderRepository;
import com.example.demo.dao.CredentialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // <-- important

import java.util.List;
import java.util.Optional;

@Service
public class AdminService {

    private final ProviderRepository providerRepository;
    private final CredentialRepository credentialRepository;

    @Autowired
    public AdminService(ProviderRepository providerRepository,
                        CredentialRepository credentialRepository) {
        this.providerRepository = providerRepository;
        this.credentialRepository = credentialRepository;
    }

    public List<Provider> getAllProviders() {
        return providerRepository.findAll();
    }

    public Provider getProviderById(int id) {
        return providerRepository.findById(id).orElse(null);
    }

    @Transactional
    public Provider addProvider(Provider provider) {
        return providerRepository.save(provider);
    }

    @Transactional
    public Provider updateProvider(Provider provider) {
        return providerRepository.save(provider);
    }

    @Transactional
    public void deactivateProvider(int id) {
        
        // 1. Permanently delete credentials associated with the provider
        // This ensures the user cannot log in once deactivated.
        credentialRepository.deleteByProvider_ProviderId(id);
        
        // 2. Set the provider's status to inactive (0) in the Provider table
        Optional<Provider> providerOptional = providerRepository.findById(id);

        if (providerOptional.isPresent()) {
            Provider provider = providerOptional.get();
            
            // *** CORRECTED LINE: Using your specific setter and passing the integer value 0 ***
            provider.setIsActive(0); 
            
            providerRepository.save(provider);
        } else {
            // It's good practice to throw an exception if the provider ID is invalid.
            throw new RuntimeException("Provider with ID " + id + " not found for deactivation.");
        }
    }
    }
