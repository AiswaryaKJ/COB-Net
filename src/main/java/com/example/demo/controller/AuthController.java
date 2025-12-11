package com.example.demo.controller;

import com.example.demo.bean.Credentials;
import com.example.demo.bean.Patient;
import com.example.demo.bean.Provider;
import com.example.demo.dao.CredentialRepository;
import com.example.demo.dao.PatientRepository;
import com.example.demo.dao.ProviderRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/auth")
public class AuthController {

    @Autowired
    private PatientRepository patientRepository;

    @Autowired
    private ProviderRepository providerRepository;

    private final CredentialRepository credentialsRepository;
    private final PasswordEncoder passwordEncoder;

    public AuthController(CredentialRepository credentialsRepository, PasswordEncoder passwordEncoder) {
        this.credentialsRepository = credentialsRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // Show login page
    @GetMapping("/login")
    public String showLoginPage() {
        return "login"; // resolves to /WEB-INF/views/login.jsp
    }

    // Handle login form submission
    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        Model model) {
        Credentials stored = credentialsRepository.findByUsername(username).orElse(null);

        if (stored != null && passwordEncoder.matches(password, stored.getPassword())) {
            model.addAttribute("message", "Login successful! Role: " + stored.getRole());

            // Redirect based on role
            switch (stored.getRole().toUpperCase()) {
                case "ADMIN":
                    return "redirect:/admin/dashboard";   // /WEB-INF/views/admin.jsp
                case "PROVIDER":
                    return "redirect:/provider/welcome"; // handled by ProviderController
                case "PATIENT":
                	if (stored.getPatient() != null) {
                        int patientId = stored.getPatient().getPatientId();
                        return "redirect:/patient/dashboard?patientId=" + patientId;
                    } else {
                        model.addAttribute("error", "No patient linked to this account");
                        return "login";
                    }                case "PAYER":
                    return "payer";    // /WEB-INF/views/payer.jsp
                default:
                    model.addAttribute("error", "Unknown role");
                    return "login";
            }
        } else {
            model.addAttribute("error", "Invalid username or password");
            return "login"; // reload login.jsp with error
        }
    }

    // Show registration page
    @GetMapping("/register")
    public String showRegisterPage() {
        return "register"; // resolves to /WEB-INF/views/register.jsp
    }

    // Handle registration form submission
    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam String role,
                           @RequestParam(required = false) Integer patientId,
                           @RequestParam(required = false) Integer providerId,
                           Model model) {

        // Check if username already exists
        if (credentialsRepository.findByUsername(username).isPresent()) {
            model.addAttribute("error", "Username already taken!");
            return "register";
        }

        Credentials credentials = new Credentials();
        credentials.setUsername(username);
        credentials.setPassword(passwordEncoder.encode(password));
        credentials.setRole(role);

        if ("PATIENT".equalsIgnoreCase(role)) {
            if (patientId == null || !patientRepository.existsById(patientId)) {
                model.addAttribute("error", "Invalid Patient ID. Please enter a valid one.");
                return "register";
            }

            // Check if patient already has credentials
            if (credentialsRepository.findByPatient_PatientId(patientId).isPresent()) {
                model.addAttribute("error", "This Patient ID is already registered!");
                return "register";
            }

            Patient patient = patientRepository.findById(patientId).orElseThrow();
            credentials.setPatient(patient);

        } else if ("PROVIDER".equalsIgnoreCase(role)) {
            if (providerId == null || !providerRepository.existsById(providerId)) {
                model.addAttribute("error", "Invalid Provider ID. Please enter a valid one.");
                return "register";
            }

            // Check if provider already has credentials
            if (credentialsRepository.findByProvider_ProviderId(providerId).isPresent()) {
                model.addAttribute("error", "This Provider ID is already registered!");
                return "register";
            }

            Provider provider = providerRepository.findById(providerId).orElseThrow();
            credentials.setProvider(provider);

        } else {
            model.addAttribute("error", "Only Patient or Provider accounts can be registered here.");
            return "register";
        }

        credentialsRepository.save(credentials);
        model.addAttribute("message", "Registration successful! Please log in.");
        return "login";
    }
}
