<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COBNet - Coordination of Benefits Network</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root {
            --primary-navy: #004c99;
            --secondary-blue: #3498db;
            --accent-gold: #ffb74d; 
            --light-bg: #f7f9fc;
            --contrast-bg: #e6f0f8; 
            --text-dark: #2c3e50;
        }

        /* 1. Base Styles & Layout */
        html { scroll-behavior: smooth; }
        body {
            font-family: 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            background-color: var(--light-bg);
            color: var(--text-dark);
            overflow-x: hidden;
            padding-top: 56px; 
        }
        h1, h2, h3, h4 {
            color: var(--primary-navy);
            font-weight: 700;
        }
        .section-padding {
            padding: 80px 0;
        }

        /* 2. Navbar Styling */
        .navbar-custom {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }
        .navbar-brand .logo-icon {
            color: var(--primary-navy);
            font-size: 1.5rem;
            margin-right: 5px;
        }
        .navbar-brand .logo-text {
            font-weight: 800;
            color: var(--primary-navy);
            font-size: 1.4rem;
        }
        .nav-link.active, .nav-link:hover {
            color: var(--secondary-blue) !important;
        }

        /* 3. Hero Section (Tall, Eye-Catching Banner) */
        .hero-section {
            background: linear-gradient(135deg, #003e7d 0%, #1a5276 100%);
            color: white;
            height: 70vh; /* Takes up 70% of viewport height */
            display: flex;
			opacity:1;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden; 
        }
        .hero-content {
            text-align: center;
            position: relative;
            z-index: 2; 
        }

        /* Hero Title Gradient Effect */
        .hero-title {
            font-size: 4.0rem; /* Larger font size */
            font-weight: 900;
            margin-bottom: 20px;
            background-image: linear-gradient(to right, white, var(--accent-gold));
            -webkit-background-clip: text;
			opacity:1;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 0 10px rgba(0, 0, 0, 0.3); 
            line-height: 1.1;
        }
        .hero-subtitle {
            font-size: 1.75rem;
            opacity: 1;
            margin-bottom: 40px;
        }

        /* Animated Particles */
        .particles { position: absolute; top: 0; left: 0; width: 100%; height: 100%; overflow: hidden; z-index: 1; }
        .particle { position: absolute; width: 10px; height: 10px; background: rgba(255, 255, 255, 0.15); border-radius: 50%; animation: move-particles 20s infinite; }
        .particle:nth-child(1) { top: 20%; left: 10%; animation-duration: 25s; }
        .particle:nth-child(2) { top: 50%; left: 80%; animation-duration: 15s; }
        .particle:nth-child(3) { top: 80%; left: 30%; animation-duration: 30s; }
        .particle:nth-child(4) { top: 10%; left: 50%; animation-duration: 18s; }
        .particle:nth-child(5) { top: 90%; left: 60%; animation-duration: 22s; }
        @keyframes move-particles {
            0% { transform: translateY(0) rotate(0deg); opacity: 0.5; }
            50% { transform: translateY(-500px) rotate(180deg); opacity: 0.8; }
            100% { transform: translateY(0) rotate(360deg); opacity: 0.5; }
        }
        
        /* Slanted Divider for visual separation */
        .hero-section::after {
            content: '';
            position: absolute;
            bottom: -50px; /* Overlap with the next section */
            left: 0;
            width: 100%;
            height: 100px;
            background: var(--light-bg);
            transform: skewY(-2deg); /* Slanted look */
            transform-origin: top left;
            z-index: 5;
            box-shadow: 0 10px 10px rgba(0, 0, 0, 0.05);
        }

        /* 4. Content Sections */
        .section-padding { padding: 120px 0 80px; } /* Increased top padding to clear slanted divider */

        .bg-white-section { background-color: white; }
        .bg-contrast-section { background-color: var(--contrast-bg); }
        
        .info-block {
            padding: 30px; border-radius: 15px; box-shadow: 0 5px 20px rgba(0, 0, 0, 0.05);
            background: white; height: 100%; transition: transform 0.3s;
            border-left: 5px solid var(--accent-gold); 
        }
        
        .benefit-item i { color: var(--accent-gold); margin-right: 10px; }

        /* 5. Dedicated Login Section Styling */
        #login-section {
            background: white;
            border-top: 1px solid var(--contrast-bg);
        }
        .login-card-dedicated {
            background: var(--contrast-bg);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 40px;
            max-width: 450px;
            margin: auto;
        }

        .btn-login {
            background: var(--primary-navy); 
            transition: background 0.3s;
        }
        .btn-login:hover {
            background: var(--secondary-blue);
        }

        /* Mobile Adjustments */
        @media (max-width: 768px) {
            .hero-section { height: 50vh; }
            .hero-title { font-size: 2.5rem; }
            .hero-subtitle { font-size: 1.2rem; }
            .hero-section::after { bottom: -25px; height: 50px; }
            .section-padding { padding: 60px 0; }
        }
    </style>
</head>
<body>

    <nav class="navbar navbar-expand-lg navbar-light fixed-top navbar-custom">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-handshake logo-icon"></i>
                <span class="logo-text">COBNet</span>
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ms-auto">
                    <li class="nav-item">
                        <a class="nav-link active" aria-current="page" href="#hero">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#about">What is COB?</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link btn btn-sm btn-outline-primary ms-lg-2" href="#login-section" style="color: var(--accent-gold); border-color: var(--accent-gold);">Login / Register</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <header class="hero-section" id="hero">
        <div class="particles">
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
            <div class="particle"></div>
        </div>
        <div class="container hero-content">
            <h1 class="hero-title">COBNet: Streamlining Healthcare Benefits Coordination</h1>
            <p class="hero-subtitle">The centralized platform for Coordination of Benefits (COB) management.</p>
            <a href="#login-section" class="btn btn-lg fw-bold" style="background-color: var(--accent-gold); color: var(--primary-navy); border-radius: 50px;">
                <i class="fas fa-arrow-down me-2"></i> Access Portal
            </a>
        </div>
    </header>

    <section class="section-padding bg-contrast-section" id="about">
        <div class="container">
            <div class="text-center mb-5">
                <h2>Understanding Coordination of Benefits (COB)</h2>
                <p class="lead text-muted">Ensuring proper payment when an individual has multiple health plans.</p>
                
            </div>

            <div class="row g-4">
                <div class="col-md-6">
                    <div class="info-block">
                        <div class="info-icon"><i class="fas fa-search-dollar"></i></div>
                        <h4>The COB Challenge</h4>
                        <p>Coordination of Benefits is necessary when a patient is covered by two or more insurance policies. Without proper coordination, providers may receive inaccurate payments, and patients may be subject to excessive billing or delays. This is often complex due to varying state and payer regulations.</p>
                        <p class="text-muted">COBNet automates the complex process of determining which insurer is the primary payer and which is secondary, minimizing errors and administrative overhead.</p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="info-block">
                        <div class="info-icon"><i class="fas fa-balance-scale"></i></div>
                        <h4>How COBNet Helps</h4>
                        <p>Our system acts as a secure intermediary, providing real-time verification of coverage and claims data between multiple payers. This eliminates manual reconciliation and speeds up the entire revenue cycle.</p>
                        <ul class="list-unstyled mt-3">
                            <li class="benefit-item"><i class="fas fa-check-circle"></i> Reduces claim reprocessing rates.</li>
                            <li class="benefit-item"><i class="fas fa-check-circle"></i> Improves patient financial clarity.</li>
                            <li class="benefit-item"><i class="fas fa-check-circle"></i> Ensures HIPAA-compliant data exchange.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <section class="section-padding bg-white-section" id="features">
        <div class="container">
            <div class="text-center mb-5">
                <h2>COBNet System Key Features</h2>
                <p class="lead text-muted">Designed for efficiency, security, and accuracy.</p>
            </div>
            
            <div class="row g-4">
                <div class="col-md-4">
                    <div class="info-block text-center">
                        <i class="fas fa-bolt info-icon" style="color: var(--accent-gold);"></i>
                        <h4 class="h5">Real-Time Verification</h4>
                        <p>Instantly confirm primary and secondary coverage status for any member before service delivery.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-block text-center">
                        <i class="fas fa-lock info-icon" style="color: var(--primary-navy);"></i>
                        <h4 class="h5">Secure & Compliant</h4>
                        <p>Built on enterprise-grade infrastructure ensuring full HIPAA and privacy compliance.</p>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="info-block text-center">
                        <i class="fas fa-chart-line info-icon" style="color: var(--secondary-blue);"></i>
                        <h4 class="h5">Provider Dashboard</h4>
                        <p>Centralized view for claims history, payment reconciliation, and provider status management.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="section-padding" id="login-section">
        <div class="container">
            <div class="login-card-dedicated">
                <h2 class="text-center" style="color: var(--primary-navy);">Secure Portal Access</h2>
                <p class="text-center text-muted mb-4">Login with your credentials or register for full access.</p>

                <%
                    String error = (String) request.getAttribute("error");
                    if (error != null && !error.isEmpty()) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <%= error %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <%
                    }
                %>
                
                <form action="/auth/login" method="post">
                    
                    <div class="input-group-custom">
                        <i class="fas fa-user input-icon"></i>
                        <label for="username" class="form-label visually-hidden">Username / Member ID</label>
                        <input type="text" name="username" class="form-control form-control-custom" placeholder="Username or Member ID" required>
                    </div>

                    <div class="input-group-custom">
                        <i class="fas fa-lock input-icon"></i>
                        <label for="password" class="form-label visually-hidden">Password</label>
                        <input type="password" name="password" class="form-control form-control-custom" placeholder="Password" required>
                    </div>

                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" value="true" id="rememberMe" name="remember-me">
                            <label class="form-check-label text-muted" for="rememberMe" style="font-size: 0.9rem;">
                                Remember Me
                            </label>
                        </div>
                        <a href="/auth/forgot-password" class="text-decoration-none" style="color: var(--secondary-blue); font-weight: 600;">Forgot Password?</a>
                    </div>

                    <button type="submit" class="btn btn-login btn-primary w-100 mb-3">
                        <i class="fas fa-sign-in-alt me-2"></i> Secure Login
                    </button>
                    
                    <div class="text-center">
                        <small class="text-muted">New user? <a href="/auth/register" style="color: var(--accent-gold); font-weight: 700;">Create an account</a></small>
                    </div>
                </form>
            </div>
        </div>
    </section>


    <footer class="bg-dark text-white py-4">
        <div class="container text-center">
            <p class="mb-0">&copy; 2025 COBNet. All rights reserved. | <i class="fas fa-shield-alt me-1" style="color: var(--accent-gold);"></i> HIPAA Compliant</p>
        </div>
    </footer>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Smooth scrolling for internal links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
    </script>
</body>
</html>