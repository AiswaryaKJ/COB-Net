package com.example.demo.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.security.web.context.SecurityContextRepository;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityContextRepository securityContextRepository() {
        return new HttpSessionSecurityContextRepository();
    }
 // SecurityConfig.java

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http, SecurityContextRepository securityContextRepository) throws Exception {
        http
            .cors(Customizer.withDefaults())
            
            .csrf(AbstractHttpConfigurer::disable)
            .authorizeHttpRequests(auth -> auth
              
                // -- Public/Permitted Resources --
                .requestMatchers("/error", "/favicon.ico").permitAll()
                .requestMatchers("/WEB-INF/views/**").permitAll() // IMPORTANT: Allow direct access to JSPs for forward/include

                // 🔑 Explicitly allow the login and register controllers
                .requestMatchers("/auth/**").permitAll() 
                
                // 2. Allow OPTIONS requests (Pre-flight checks)
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

                // 🛑 CRITICAL FIX: Protect all other endpoints
                .anyRequest().authenticated()
            )
            
            // ⚠️ REMOVED .formLogin() BLOCK (Correct for manual login)

            .sessionManagement(session -> session
                .sessionCreationPolicy(org.springframework.security.config.http.SessionCreationPolicy.IF_REQUIRED)
            )
            .securityContext(context -> context
                .securityContextRepository(securityContextRepository) 
            );

        return http.build();
    }
    // ... (rest of the file remains the same)
    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
