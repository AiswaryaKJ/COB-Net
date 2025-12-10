package com.example.demo.controller;

import com.example.demo.bean.Credentials;
import com.example.demo.dao.CredentialRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/auth")
public class AuthController {

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
                return "provider"; // /WEB-INF/views/provider.jsp
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
                           Model model) {
        Credentials credentials = new Credentials();
        credentials.setUsername(username);
        credentials.setPassword(passwordEncoder.encode(password));
        credentials.setRole(role);

        credentialsRepository.save(credentials);

        model.addAttribute("message", "User registered successfully!");
        return "login"; // after registration, redirect to login page
    }
}
