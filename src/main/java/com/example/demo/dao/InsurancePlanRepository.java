package com.example.demo.dao;

import com.example.demo.bean.InsurancePlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InsurancePlanRepository extends JpaRepository<InsurancePlan, Integer> {
    // Basic CRUD operations provided by JpaRepository
    // No custom methods needed for now
}