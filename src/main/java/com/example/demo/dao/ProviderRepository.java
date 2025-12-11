package com.example.demo.dao;

import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import com.example.demo.bean.Provider;

public interface ProviderRepository extends JpaRepository<Provider, Integer> {
}
