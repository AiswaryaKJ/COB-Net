package com.example.demo.dao;


import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.bean.Credentials;

import java.util.Optional;

public interface CredentialRepository extends JpaRepository<Credentials, Integer> {
    Optional<Credentials> findByUsername(String username);
}

