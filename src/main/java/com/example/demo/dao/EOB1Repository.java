package com.example.demo.dao;

import com.example.demo.bean.EOB1;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EOB1Repository extends JpaRepository<EOB1, Integer> {
    Optional<EOB1> findByClaimClaimId(int claimId);
}