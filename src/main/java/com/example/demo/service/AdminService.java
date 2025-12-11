package com.example.demo.service;

import com.example.demo.bean.Provider;
import com.example.demo.dao.ProviderRepository;
import com.example.demo.dao.CredentialRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // <-- important

import java.util.List;

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
    public void deleteProvider(int id) {
        // If you want to manually delete credentials first:
        credentialRepository.deleteByProvider_ProviderId(id);

        // Then delete provider
        providerRepository.deleteById(id);
    }
}
