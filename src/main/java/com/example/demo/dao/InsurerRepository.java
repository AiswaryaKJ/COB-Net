package com.example.demo.dao;

import com.example.demo.bean.Insurer;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface InsurerRepository extends JpaRepository<Insurer, Integer> {
    Optional<Insurer> findByPayerName(String payerName);
    boolean existsByPayerName(String payerName);
}