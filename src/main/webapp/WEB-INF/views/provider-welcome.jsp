<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Healthcare Claim Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --accent-color: #e74c3c;
            --success-color: #27ae60;
            --light-bg: #f8f9fa;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .welcome-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            margin-top: 50px;
        }
        
        .header-section {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        .header-section h1 {
            font-size: 3rem;
            margin-bottom: 15px;
            font-weight: 700;
        }
        
        .header-section p {
            font-size: 1.2rem;
            opacity: 0.9;
        }
        
        .features-section {
            padding: 40px;
        }
        
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            margin: 40px 0;
        }
        
        .feature-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid #e0e0e0;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.15);
        }
        
        .feature-icon {
            font-size: 3rem;
            color: var(--secondary-color);
            margin-bottom: 20px;
        }
        
        .feature-card h3 {
            color: var(--primary-color);
            margin-bottom: 15px;
            font-size: 1.5rem;
        }
        
        .feature-card p {
            color: #666;
            line-height: 1.6;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-top: 40px;
        }
        
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            padding: 20px;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--secondary-color), #2980b9);
            color: white;
        }
        
        .btn-success {
            background: linear-gradient(135deg, var(--success-color), #219653);
            color: white;
        }
        
        .btn-info {
            background: linear-gradient(135deg, #00cec9, #0984e3);
            color: white;
        }
        
        .btn-warning {
            background: linear-gradient(135deg, #fdcb6e, #e17055);
            color: white;
        }
        
        .action-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
        }
        
        .btn-icon {
            font-size: 1.5rem;
        }
        
        .statistics-section {
            background: var(--light-bg);
            border-radius: 15px;
            padding: 30px;
            margin-top: 40px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 10px;
        }
        
        .stat-label {
            color: #666;
            font-size: 1rem;
        }
        
        .footer-section {
            text-align: center;
            padding: 30px;
            margin-top: 40px;
            color: #666;
            border-top: 1px solid #e0e0e0;
        }
        
        .quick-links {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        
        .quick-link {
            color: var(--secondary-color);
            text-decoration: none;
            transition: color 0.3s ease;
        }
        
        .quick-link:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }
        
        @media (max-width: 768px) {
            .header-section h1 {
                font-size: 2.2rem;
            }
            
            .features-grid {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
            
            .container {
                padding: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="welcome-card">
            <!-- Header Section -->
            <div class="header-section">
                <h1><i class="fas fa-heartbeat me-3"></i>Healthcare Claim Management</h1>
                <p class="lead">Professional Medical Claim Processing System for Healthcare Providers</p>
            </div>
            
            <!-- Features Section -->
            <div class="features-section">
                <h2 class="text-center mb-4" style="color: var(--primary-color);">Why Choose Our System?</h2>
                
                <div class="features-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h3>Fast Processing</h3>
                        <p>Submit and process claims in real-time with automated validation and quick turnaround.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-shield-alt"></i>
                        </div>
                        <h3>Secure & Compliant</h3>
                        <p>HIPAA compliant with 256-bit encryption ensuring patient data security and privacy.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <h3>Real-time Analytics</h3>
                        <p>Track claim status, generate reports, and monitor performance with detailed analytics.</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h3>Mobile Friendly</h3>
                        <p>Access the system from any device with our responsive, mobile-optimized interface.</p>
                    </div>
                </div>
                
                <!-- Action Buttons -->
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
                    
                    <a href="searchprovider" class="action-btn btn-warning">
                        <i class="btn-icon fas fa-user-md"></i>
                        <span>Search by Provider</span>
                    </a>
                </div>
            </div>
            
            <!-- Statistics Section -->
            <div class="statistics-section">
                <h3 class="text-center mb-4" style="color: var(--primary-color);">System Overview</h3>
                <div class="stats-grid">
                    <div class="stat-item">
                        <div class="stat-value" id="totalClaims">0</div>
                        <div class="stat-label">Total Claims Processed</div>
                    </div>
                    
                    <div class="stat-item">
                        <div class="stat-value">99.7%</div>
                        <div class="stat-label">System Uptime</div>
                    </div>
                    
                    <div class="stat-item">
                        <div class="stat-value">24-48</div>
                        <div class="stat-label">Hours Processing Time</div>
                    </div>
                    
                    <div class="stat-item">
                        <div class="stat-value">100%</div>
                        <div class="stat-label">HIPAA Compliant</div>
                    </div>
                </div>
            </div>
            
            <!-- Footer Section -->
            <div class="footer-section">
                <p>© 2025 Healthcare Claim Management System. All rights reserved.</p>
                <div class="quick-links">
                    <a href="#" class="quick-link">Privacy Policy</a>
                    <a href="#" class="quick-link">Terms of Service</a>
                    <a href="#" class="quick-link">Support Center</a>
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
        // Animate statistics counter
        function animateCounter(element, target, duration) {
            let start = 0;
            const increment = target / (duration / 16);
            const timer = setInterval(() => {
                start += increment;
                if (start >= target) {
                    element.textContent = target;
                    clearInterval(timer);
                } else {
                    element.textContent = Math.floor(start);
                }
            }, 16);
        }
        
        // Start animation when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const totalClaimsElement = document.getElementById('totalClaims');
            animateCounter(totalClaimsElement, 1542, 2000);
        });
    </script>
</body>
</html>