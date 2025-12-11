<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COBNet - Secure Login</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        :root {
            --primary-navy: #004c99;
            --secondary-blue: #3498db;
            --light-accent: #5dade2;
            --light-bg: #f5f7fa;
            --text-dark: #2c3e50;
            --text-light: #7f8c8d;
            --error-red: #e74c3c;
            --success-green: #2ecc71;
        }

        html, body {
            height: 100vh;
            width: 100vw;
            margin: 0;
            padding: 0;
            overflow: hidden;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
        }

        .split-container {
            display: flex;
            height: 100vh;
            width: 100vw;
        }

        /* Left Panel - Login Form */
        .login-panel {
            flex: 1;
            min-width: 400px;
            max-width: 500px;
            background: white;
            display: flex;
            flex-direction: column;
            padding: 0 4rem;
            box-shadow: 5px 0 25px rgba(0, 0, 0, 0.05);
            z-index: 10;
            overflow-y: auto; /* Allow scrolling if content is too long */
        }

        /* Center the content vertically with padding at top */
        .login-content {
            width: 100%;
            max-width: 380px;
            margin: 0 auto;
            padding-top: 60px; /* Added padding to push content down */
            padding-bottom: 40px;
        }

        .logo-container {
            margin-bottom: 2.5rem;
        }

        .app-logo {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 10px;
        }

        .logo-icon {
            font-size: 2.8rem;
            color: var(--primary-navy);
            filter: drop-shadow(0 2px 4px rgba(0, 76, 153, 0.2));
        }

        .logo-text {
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--primary-navy);
            letter-spacing: -0.5px;
        }

        .app-tagline {
            color: var(--text-light);
            font-size: 1.1rem;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        .app-subtitle {
            color: var(--secondary-blue);
            font-size: 0.9rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
        }

        .form-label {
            font-weight: 600;
            color: var(--text-dark);
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .input-group-custom {
            position: relative;
            margin-bottom: 1.8rem;
        }

        .input-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-blue);
            font-size: 1.1rem;
            z-index: 10;
            transition: color 0.3s ease;
        }

        .form-control-custom {
            width: 100%;
            padding: 16px 20px 16px 50px;
            border: 2px solid #e8edf3;
            border-radius: 12px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background-color: #fafcfe;
            color: var(--text-dark);
            height: 52px;
        }

        .form-control-custom:focus {
            outline: none;
            border-color: var(--secondary-blue);
            background-color: white;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.15);
        }

        .form-control-custom::placeholder {
            color: #a0aec0;
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(to right, var(--primary-navy), var(--secondary-blue));
            color: white;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 0.5rem;
            letter-spacing: 0.5px;
            height: 52px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.3);
        }

        .btn-login:active {
            transform: translateY(0);
        }

        .register-link {
            text-align: center;
            margin-top: 2rem;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .register-link a {
            color: var(--secondary-blue);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 5px 10px;
            border-radius: 6px;
        }

        .register-link a:hover {
            color: var(--primary-navy);
            background-color: rgba(52, 152, 219, 0.1);
            text-decoration: none;
        }

        .alert-custom {
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 2rem;
            border-left: 4px solid var(--error-red);
            background-color: #ffeaea;
            color: #c0392b;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 12px;
            animation: slideIn 0.4s ease;
        }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-10px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .alert-icon {
            font-size: 1.2rem;
            flex-shrink: 0;
        }

        /* Right Panel - Visual Area */
        .visual-panel {
            flex: 1.5;
            background: linear-gradient(135deg, var(--primary-navy) 0%, #1a5276 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 4rem;
            position: relative;
            overflow: hidden;
        }

        .visual-panel::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: 
                radial-gradient(circle at 20% 80%, rgba(52, 152, 219, 0.3) 0%, transparent 50%),
                radial-gradient(circle at 80% 20%, rgba(0, 76, 153, 0.2) 0%, transparent 50%);
            z-index: 1;
        }

        .visual-content {
            max-width: 600px;
            color: white;
            text-align: center;
            position: relative;
            z-index: 2;
        }

        .main-visual {
            font-size: 6rem;
            color: white;
            margin-bottom: 2rem;
            opacity: 0.95;
            filter: drop-shadow(0 5px 15px rgba(0, 0, 0, 0.2));
        }

        .visual-title {
            font-size: 2.2rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            line-height: 1.3;
        }

        .visual-subtitle {
            font-size: 1.1rem;
            opacity: 0.9;
            line-height: 1.6;
            margin-bottom: 2.5rem;
            font-weight: 300;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
            margin-top: 3rem;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            backdrop-filter: blur(5px);
            transition: transform 0.3s ease;
        }

        .feature-item:hover {
            transform: translateY(-5px);
            background: rgba(255, 255, 255, 0.15);
        }

        .feature-icon {
            font-size: 1.5rem;
            color: #5dade2;
        }

        .feature-text {
            font-size: 0.9rem;
            font-weight: 500;
            text-align: left;
        }

        .security-note {
            font-size: 0.75rem;
            color: var(--text-light);
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid #e8edf3;
        }

        .security-note i {
            color: var(--success-green);
            margin-right: 5px;
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .split-container {
                flex-direction: column;
            }
            
            .login-panel {
                min-width: 100%;
                max-width: 100%;
                padding: 2rem;
                box-shadow: none;
            }
            
            .login-content {
                padding-top: 40px; /* Less padding on mobile */
            }
            
            .visual-panel {
                display: none;
            }
            
            .login-content {
                max-width: 400px;
            }
        }

        @media (max-height: 800px) {
            .login-content {
                padding-top: 40px; /* Reduce padding on shorter screens */
            }
            
            .logo-container {
                margin-bottom: 2rem;
            }
            
            .main-visual {
                font-size: 5rem;
                margin-bottom: 1.5rem;
            }
            
            .visual-title {
                font-size: 1.9rem;
            }
            
            .features-grid {
                margin-top: 2rem;
                gap: 1rem;
            }
            
            .feature-item {
                padding: 12px;
            }
        }

        @media (max-height: 700px) {
            .login-content {
                padding-top: 30px;
            }
            
            .logo-container {
                margin-bottom: 1.5rem;
            }
            
            .input-group-custom {
                margin-bottom: 1.5rem;
            }
            
            .btn-login {
                margin-top: 0.3rem;
            }
            
            .register-link {
                margin-top: 1.5rem;
            }
            
            .security-note {
                margin-top: 1.5rem;
                padding-top: 1.5rem;
            }
        }

        @media (max-height: 600px) {
            .login-content {
                padding-top: 20px;
                padding-bottom: 20px;
            }
            
            .logo-container {
                margin-bottom: 1rem;
            }
            
            .logo-icon {
                font-size: 2.2rem;
            }
            
            .logo-text {
                font-size: 1.8rem;
            }
            
            .app-tagline {
                font-size: 1rem;
                margin-bottom: 0.3rem;
            }
            
            .input-group-custom {
                margin-bottom: 1.2rem;
            }
            
            .form-control-custom, .btn-login {
                height: 48px;
                padding: 14px 18px 14px 46px;
            }
            
            .btn-login {
                padding: 14px;
            }
        }
    </style>
</head>
<body>

<div class="split-container">
    
    <!-- Left Panel - Login Form -->
    <div class="login-panel">
        <div class="login-content">
            <div class="logo-container">
                <div class="app-logo">
                    <i class="fas fa-handshake logo-icon"></i>
                    <div class="logo-text">COBNet</div>
                </div>
                <p class="app-tagline">Coordination of Benefits Network</p>
                <p class="app-subtitle">Secure Member & Provider Portal</p>
            </div>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null && !error.isEmpty()) {
            %>
                <div class="alert-custom">
                    <i class="fas fa-exclamation-circle alert-icon"></i>
                    <span><%= error %></span>
                </div>
            <%
                }
            %>

            <form action="/auth/login" method="post" id="loginForm">
                <div class="input-group-custom">
                    <label for="username" class="form-label">Username / Member ID</label>
                    <i class="fas fa-user-circle input-icon"></i>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           class="form-control-custom" 
                           placeholder="Enter your username or member ID" 
                           required>
                </div>

                <div class="input-group-custom">
                    <label for="password" class="form-label">Password</label>
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-control-custom" 
                           placeholder="Enter your password" 
                           required>
                </div>

                <button type="submit" class="btn-login">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>Secure Login</span>
                </button>
            </form>

            <div class="register-link">
                New to COBNet? <a href="/auth/register">Create an account</a>
            </div>

            <div class="security-note">
                <i class="fas fa-shield-alt"></i>
                Protected by enterprise-grade security & HIPAA compliant
            </div>
        </div>
    </div>

    <!-- Right Panel - Visual Area -->
    <div class="visual-panel">
        <div class="visual-content">
            <i class="fas fa-heartbeat main-visual"></i>
            
            <h2 class="visual-title">
                Streamlining Healthcare Benefits Coordination
            </h2>
            
            <p class="visual-subtitle">
                A comprehensive platform connecting providers, insurers, and patients 
                for seamless benefits coordination and claim management.
            </p>

            <div class="features-grid">
                <div class="feature-item">
                    <i class="fas fa-shield-alt feature-icon"></i>
                    <div class="feature-text">HIPAA Compliant Security</div>
                </div>
                
                <div class="feature-item">
                    <i class="fas fa-bolt feature-icon"></i>
                    <div class="feature-text">Real-time Claim Processing</div>
                </div>
                
                <div class="feature-item">
                    <i class="fas fa-network-wired feature-icon"></i>
                    <div class="feature-text">Multi-Payer Integration</div>
                </div>
                
                <div class="feature-item">
                    <i class="fas fa-chart-line feature-icon"></i>
                    <div class="feature-text">Advanced Analytics</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const loginForm = document.getElementById('loginForm');
        const inputs = document.querySelectorAll('.form-control-custom');
        
        // Add interactive effects to form inputs
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.querySelector('.input-icon').style.color = 'var(--primary-navy)';
                this.parentElement.querySelector('.input-icon').style.transform = 'translateY(-50%) scale(1.1)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.querySelector('.input-icon').style.color = 'var(--secondary-blue)';
                this.parentElement.querySelector('.input-icon').style.transform = 'translateY(-50%) scale(1)';
            });
        });
        
        // Form submission with visual feedback
        loginForm.addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalContent = submitBtn.innerHTML;
            
            // Show loading state
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Authenticating...</span>';
            submitBtn.disabled = true;
            
            // Simulate API call delay
            setTimeout(() => {
                submitBtn.innerHTML = originalContent;
                submitBtn.disabled = false;
            }, 2000);
        });
        
        // Prevent form submission on Enter in inputs (optional)
        loginForm.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                this.querySelector('button[type="submit"]').click();
            }
        });
        
        // Ensure the logo section is properly positioned
        function adjustLogoPosition() {
            const loginContent = document.querySelector('.login-content');
            const windowHeight = window.innerHeight;
            const contentHeight = loginContent.scrollHeight;
            
            // Only adjust if content is taller than viewport
            if (contentHeight < windowHeight * 0.8) {
                // Center the content vertically with some top padding
                const topPadding = Math.max(40, (windowHeight - contentHeight) * 0.3);
                loginContent.style.paddingTop = topPadding + 'px';
            }
        }
        
        // Initial adjustment
        adjustLogoPosition();
        
        // Adjust on window resize
        window.addEventListener('resize', adjustLogoPosition);
        
        // Ensure no horizontal scrolling
        window.addEventListener('scroll', function(e) {
            if (window.scrollX !== 0 || window.scrollY !== 0) {
                window.scrollTo(0, 0);
            }
        });
    });
</script>

</body>
</html>