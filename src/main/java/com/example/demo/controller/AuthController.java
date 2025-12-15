package com.example.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken; // 👈 NEW IMPORT
import org.springframework.security.core.Authentication; // 👈 NEW IMPORT
import org.springframework.security.core.context.SecurityContextHolder; // 👈 NEW IMPORT
import org.springframework.security.core.userdetails.UserDetails; // 👈 NEW IMPORT
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository; // 👈 NEW IMPORT
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.demo.bean.Credentials;
import com.example.demo.bean.Patient;
import com.example.demo.bean.Provider;
import com.example.demo.config.CustomUserDetailsService; // 👈 NEW IMPORT: Assuming you put the service in config
import com.example.demo.dao.CredentialRepository;
import com.example.demo.dao.PatientRepository;
import com.example.demo.dao.ProviderRepository;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest; // 👈 NEW IMPORT
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // 👈 NEW IMPORT
// NOTE: HttpServletResponse is not used in the original login method, so it's removed from imports.
// You might need it if you want to set cookies manually.

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


      } 

      else {

        model.addAttribute("error", "Only Patient or Provider accounts can be registered here.");

        return "register";

      }


      credentialsRepository.save(credentials);

      model.addAttribute("message", "Registration successful! Please log in.");

      return "login";

    }

    @GetMapping("/app/logout-exit")
    public String forceLogoutRedirect(HttpServletRequest request, HttpServletResponse response) {
        
        // 1. Invalidate the HTTP Session (Server-side cleanup)
        // This effectively kills the Spring Security context and all session attributes.
        request.getSession().invalidate();

        // 2. Delete the JSESSIONID Cookie (Client-side cleanup/Token deletion)
        // This removes the "token" that the browser uses to identify the session.
        Cookie cookie = new Cookie("JSESSIONID", null);
        
        // Set the path to ensure the browser deletes the correct cookie
        cookie.setPath(request.getContextPath() + "/"); 
        
        // Set Max-Age to 0 (or a past time) to instruct the browser to delete the cookie
        cookie.setMaxAge(0); 
        
        // Ensure the cookie is marked as secure (if using HTTPS) and HTTP-only (security best practice)
        cookie.setHttpOnly(true);
        // cookie.setSecure(true); // Uncomment if running over HTTPS
        
        response.addCookie(cookie);

        // 3. Clear SecurityContextHolder (Local thread cleanup)
        SecurityContextHolder.clearContext();
        
        // 4. Redirect to your desired login page
        return "redirect:/auth/login?logout";
    }

  }