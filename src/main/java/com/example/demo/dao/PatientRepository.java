// PatientRepository.java
package com.example.demo.dao;

import com.example.demo.bean.Patient;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Integer> {
    // Basic CRUD operations are provided by JpaRepository
}