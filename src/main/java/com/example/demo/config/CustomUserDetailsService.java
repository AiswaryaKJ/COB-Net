package com.example.demo.config;


import com.example.demo.dao.CredentialRepository;
import com.example.demo.bean.Credentials;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import java.util.Collections;
import java.util.List;

/**
 * Required implementation of Spring Security's UserDetailsService.
 * This loads user-specific data used by the Authentication process.
 */
@Service 
public class CustomUserDetailsService implements UserDetailsService {

    private final CredentialRepository credentialsRepository;

    // Spring will automatically inject the CredentialRepository bean
    public CustomUserDetailsService(CredentialRepository credentialsRepository) {
        this.credentialsRepository = credentialsRepository;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        
        // 1. Fetch the custom Credentials object from the database
        Credentials stored = credentialsRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found: " + username));
        
        // 2. Build the Spring Security UserDetails object
        // NOTE: The password MUST be the BCrypt-encoded password from the DB!
        String roleName = stored.getRole().toUpperCase();
        
        List<SimpleGrantedAuthority> authorities = Collections.singletonList(
            new SimpleGrantedAuthority("ROLE_" + roleName)
        );
        
        return new User(
            stored.getUsername(),
            stored.getPassword(), // Encoded password
            authorities          // User roles
        );
    }
}