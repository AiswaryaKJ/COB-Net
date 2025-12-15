package com.example.demo.controller;

import com.example.demo.bean.Credentials;
import com.example.demo.bean.Patient;
import com.example.demo.bean.Provider;
import com.example.demo.dao.CredentialRepository;
import com.example.demo.dao.PatientRepository;
import com.example.demo.dao.ProviderRepository;

import com.example.demo.config.CustomUserDetailsService; // 👈 NEW IMPORT: Assuming you put the service in config
import jakarta.servlet.http.HttpServletRequest; // 👈 NEW IMPORT
import jakarta.servlet.http.HttpSession; // 👈 NEW IMPORT
// NOTE: HttpServletResponse is not used in the original login method, so it's removed from imports.
// You might need it if you want to set cookies manually.

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken; // 👈 NEW IMPORT
import org.springframework.security.core.Authentication; // 👈 NEW IMPORT
import org.springframework.security.core.context.SecurityContextHolder; // 👈 NEW IMPORT
import org.springframework.security.core.userdetails.UserDetails; // 👈 NEW IMPORT
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository; // 👈 NEW IMPORT
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
    private final CustomUserDetailsService userDetailsService; // 👈 NEW FIELD: Inject the UserDetailsService

    // 🔑 UPDATED CONSTRUCTOR: Must include CustomUserDetailsService
    public AuthController(CredentialRepository credentialsRepository, 
                          PasswordEncoder passwordEncoder,
                          CustomUserDetailsService userDetailsService) {
        this.credentialsRepository = credentialsRepository;
        this.passwordEncoder = passwordEncoder;
        this.userDetailsService = userDetailsService; // 👈 Assignment
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
                        Model model,
                        HttpServletRequest request) { // 👈 ADDED: Request parameter for session access
                        
        Credentials stored = credentialsRepository.findByUsername(username).orElse(null);

        if (stored != null && passwordEncoder.matches(password, stored.getPassword())) {
            
            // *****************************************************************
            // 🚨 REQUIRED CODE TO MANUALLY CREATE THE SESSION
            // *****************************************************************
            try {
                // 1. Create the Authentication object
                UserDetails userDetails = userDetailsService.loadUserByUsername(username);
                Authentication authentication = new UsernamePasswordAuthenticationToken(
                    userDetails, null, userDetails.getAuthorities());

                // 2. Set the context (this establishes the logged-in state)
                SecurityContextHolder.getContext().setAuthentication(authentication);

                // 3. Save it to the session
                HttpSession session = request.getSession(true);
                session.setAttribute(HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY, 
                                     SecurityContextHolder.getContext());
                
            } catch (Exception e) {
                // Handle case where UserDetails could not be loaded, although password matched
                model.addAttribute("error", "Error creating session context.");
                return "login";
            }
            // *****************************************************************

            model.addAttribute("message", "Login successful! Role: " + stored.getRole());

            // Redirect based on role (Your existing logic)
            switch (stored.getRole().toUpperCase()) {
                case "ADMIN":
                    return "redirect:/admin/dashboard";
                case "PROVIDER":
                    if (stored.getProvider() != null) {
                        int providerId = stored.getProvider().getProviderId();
                        return "redirect:/provider/welcome?providerId=" + providerId;
                    } else {
                        model.addAttribute("error", "No provider linked to this account");
                        return "login";
                    }
                case "PATIENT":
                    if (stored.getPatient() != null) {
                        int patientId = stored.getPatient().getPatientId();
                        return "redirect:/patient/dashboard?patientId=" + patientId;
                    } else {
                        model.addAttribute("error", "No patient linked to this account");
                        return "login";
                    }
                case "INSURER":
                    if (stored.getInsurer() != null) {
                        int insurerId = stored.getInsurer().getInsurerId();
                        return "redirect:/insurer/dashboard?insurerId=" + insurerId;
                    } else {
                        model.addAttribute("error", "No insurer linked to this account");
                        return "login";
                    }
                default:
                    model.addAttribute("error", "Unknown role");
                    return "login";
            }
        } else {
            model.addAttribute("error", "Invalid username or password");
            return "login"; // reload login.jsp with error
        }
    }

    // ... (rest of the AuthController remains the same: /register, etc.)
}