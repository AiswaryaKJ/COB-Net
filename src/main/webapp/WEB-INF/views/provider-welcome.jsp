<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Healthcare Claim Management System Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        /* 1. CSS Variables and Base Styles */
        :root {
            --primary-color: #007bff; /* Blue for trust and professionalism */
            --secondary-color: #28a745; /* Green for success/actions */
            --accent-color: #6c757d; /* Grey for subtle elements */
            --background-light: #f4f7fa; /* Very light, clean background */
            --card-background: #ffffff;
            --text-dark: #343a40;
            --shadow-md: 0 4px 15px rgba(0, 0, 0, 0.08);
            --shadow-lg: 0 10px 30px rgba(0, 0, 0, 0.15);
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--background-light);
            color: var(--text-dark);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px 0;
        }

        /* 2. Main Container and Welcome Card */
        .container {
            max-width: 1200px;
            padding: 0; /* Remove default container padding */
        }

        .welcome-card {
            background-color: var(--card-background);
            border-radius: 15px;
            box-shadow: var(--shadow-lg);
            padding: 40px;
            margin: 20px;
            animation: fadeIn 0.8s ease-out;
        }

        /* 3. Header Section */
        .header-section {
            text-align: center;
            padding-bottom: 30px;
            border-bottom: 2px solid #e9ecef;
            margin-bottom: 30px;
        }

        .header-section h1 {
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
            font-size: 2.5rem;
        }

        .header-section .lead {
            font-weight: 300;
            color: var(--accent-color);
        }

        /* 4. Features Grid */
        .features-section h2 {
            font-weight: 500;
            margin-bottom: 30px;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 25px;
            margin-bottom: 50px;
        }

        .feature-card {
            background: linear-gradient(145deg, var(--card-background), #f8f9fa);
            padding: 25px;
            border-radius: 10px;
            box-shadow: var(--shadow-md);
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }

        .feature-icon {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 15px;
            display: inline-block;
        }

        .feature-card h3 {
            font-size: 1.3rem;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .feature-card p {
            font-size: 0.95rem;
            color: var(--accent-color);
        }

        /* 5. Action Buttons (The most critical part) */
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 40px;
        }

        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 15px 30px;
            border-radius: 50px; /* Pill shape for modern look */
            text-decoration: none;
            font-weight: 500;
            font-size: 1.1rem;
            min-width: 250px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden; /* For ripple effect */
        }

        /* Color variations for action buttons */
        .action-btn.btn-primary {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
            color: white;
        }

        .action-btn.btn-success {
            background-color: var(--secondary-color);
            border-color: var(--secondary-color);
            color: white;
        }
        
        .action-btn.btn-info {
            background-color: #17a2b8; /* Bootstrap Info default */
            border-color: #17a2b8;
            color: white;
        }

        .action-btn:hover {
            transform: translateY(-3px);
            opacity: 0.9;
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }
        
        .action-btn:active {
            transform: translateY(0);
        }

        .btn-icon {
            font-size: 1.4rem;
            margin-right: 15px;
        }

        /* 6. Footer Section */
        .footer-section {
            text-align: center;
            padding-top: 30px;
            border-top: 1px solid #e9ecef;
            margin-top: 30px;
            font-size: 0.85rem;
            color: var(--accent-color);
        }

        .quick-links {
            margin-top: 10px;
        }

        .quick-link {
            color: var(--accent-color);
            margin: 0 10px;
            text-decoration: none;
            transition: color 0.2s;
        }

        .quick-link:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }

        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .welcome-card {
                padding: 30px 20px;
            }
            .header-section h1 {
                font-size: 2rem;
            }
            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
            .action-btn {
                min-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="welcome-card">
            <div class="header-section">
                <h1><i class="fas fa-heartbeat me-3"></i>Healthcare Claim Management</h1>
                <p class="lead">Professional Medical Claim Processing System for Healthcare Providers</p>
            </div>
            
            <div class="features-section">
                <h2 class="text-center mb-4" style="color: var(--primary-color);">System Overview</h2>
                
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h3>Fast Processing</h3>
                        <p>Submit and process claims in real-time with automated validation and quick turnaround for payments.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3>Secure & Compliant</h3>
                        <p>Fully HIPAA compliant system with 256-bit encryption ensuring total patient data security and privacy.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3>Real-time Analytics</h3>
                        <p>Track claim status, generate detailed financial reports, and monitor system performance effortlessly.</p>
                    </div>
                </div>
                
                <h3 class="text-center mb-4" style="color: var(--primary-color);">Quick Actions</h3>
                <div class="action-buttons">
                    <a href="submitclaim" class="action-btn btn-primary">
                        <i class="btn-icon fas fa-file-medical"></i>
                        <span>Submit New Claim</span>
                    </a>
                    
                    <a href="viewclaims" class="action-btn btn-success">
                        <i class="btn-icon fas fa-list-alt"></i>
                        <span>View All Claims</span>
                    </a>
                    
                    <a href="searchpatient" class="action-btn btn-info">
                        <i class="btn-icon fas fa-search"></i>
                        <span>Search by Patient</span>
                    </a>
                </div>
            </div>
            
            <div class="footer-section">
                <p>© 2025 Healthcare Claim Management System. All rights reserved.</p>
                <div class="quick-links">
                    <a href="#" class="quick-link">Privacy Policy</a> | 
                    <a href="#" class="quick-link">Terms of Service</a> | 
                    <a href="#" class="quick-link">Support Center</a> | 
                    <a href="#" class="quick-link">Contact Us</a>
                </div>
                <p class="mt-3">
                    <i class="fas fa-phone me-2"></i>Support: 1-800-HEALTH | 
                    <i class="fas fa-envelope ms-3 me-2"></i>Email: support@healthclaim.com
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Future JavaScript, e.g., for form validation or dynamic content loading
        });
    </script>
</body>
</html>