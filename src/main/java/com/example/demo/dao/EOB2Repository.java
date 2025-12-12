package com.example.demo.dao;

import com.example.demo.bean.EOB2;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.Optional;

@Repository
public interface EOB2Repository extends JpaRepository<EOB2, Integer> {
    Optional<EOB2> findByClaimClaimId(int claimId);
}