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
     PatientRepository patientRepository;
     @Autowired
     ProviderRepository providerRepository;

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
        Credentials stored = credentialsRepository.findByUsername(username)
                .orElse(null);

        if (stored != null && passwordEncoder.matches(password, stored.getPassword())) {
            model.addAttribute("message", "Login successful! Role: " + stored.getRole());

            // Redirect based on role — no welcome.jsp
            switch (stored.getRole().toUpperCase()) {
            case "ADMIN":
                return "admin";   // /WEB-INF/views/admin.jsp
            case "PROVIDER":
                return "redirect:/provider/welcome"; // handled by ProviderController
// /WEB-INF/views/provider.jsp
            case "PATIENT":
                return "patient";  // /WEB-INF/views/patient.jsp
            case "PAYER":
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
            Patient patient = patientRepository.findById(patientId).orElseThrow();
            credentials.setPatient(patient);

        } else if ("PROVIDER".equalsIgnoreCase(role)) {
            if (providerId == null || !providerRepository.existsById(providerId)) {
                model.addAttribute("error", "Invalid Provider ID. Please enter a valid one.");
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
