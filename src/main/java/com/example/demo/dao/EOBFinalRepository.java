package com.example.demo.dao;

import com.example.demo.bean.EOBFinal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EOBFinalRepository extends JpaRepository<EOBFinal, Integer> {
    Optional<EOBFinal> findByClaimClaimId(int claimId);
}