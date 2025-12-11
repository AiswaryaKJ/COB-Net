<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COBNet - Register</title>
    
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
            --warning-orange: #f39c12;
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

        /* Left Panel - Registration Form */
        .register-panel {
            flex: 1;
            min-width: 450px;
            max-width: 550px;
            background: white;
            display: flex;
            flex-direction: column;
            padding: 0 4rem;
            box-shadow: 5px 0 25px rgba(0, 0, 0, 0.05);
            z-index: 10;
            overflow-y: auto;
        }

        .register-content {
            width: 100%;
            max-width: 420px;
            margin: 0 auto;
            padding-top: 50px;
            padding-bottom: 40px;
        }

        .logo-container {
            margin-bottom: 2rem;
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
            margin-bottom: 1.5rem;
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

        .select-custom {
            width: 100%;
            padding: 16px 20px 16px 50px;
            border: 2px solid #e8edf3;
            border-radius: 12px;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            background-color: #fafcfe;
            color: var(--text-dark);
            height: 52px;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%233498db' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14 2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 20px center;
            background-size: 16px;
        }

        .select-custom:focus {
            outline: none;
            border-color: var(--secondary-blue);
            background-color: white;
            box-shadow: 0 0 0 4px rgba(52, 152, 219, 0.15);
        }

        .select-icon {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--secondary-blue);
            font-size: 1.1rem;
            z-index: 10;
            pointer-events: none;
        }

        .id-field {
            margin-top: 10px;
            animation: fadeIn 0.3s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .btn-register {
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
            margin-top: 1rem;
            letter-spacing: 0.5px;
            height: 52px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(52, 152, 219, 0.3);
        }

        .btn-register:active {
            transform: translateY(0);
        }

        .login-link {
            text-align: center;
            margin-top: 2rem;
            font-size: 0.9rem;
            color: var(--text-light);
        }

        .login-link a {
            color: var(--secondary-blue);
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            padding: 5px 10px;
            border-radius: 6px;
        }

        .login-link a:hover {
            color: var(--primary-navy);
            background-color: rgba(52, 152, 219, 0.1);
            text-decoration: none;
        }

        .message-container {
            margin-bottom: 1.5rem;
            animation: slideIn 0.4s ease;
        }

        .alert-error {
            padding: 14px 18px;
            border-radius: 12px;
            border-left: 4px solid var(--error-red);
            background-color: #ffeaea;
            color: #c0392b;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-success {
            padding: 14px 18px;
            border-radius: 12px;
            border-left: 4px solid var(--success-green);
            background-color: #e8f6ef;
            color: #27ae60;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert-warning {
            padding: 14px 18px;
            border-radius: 12px;
            border-left: 4px solid var(--warning-orange);
            background-color: #fef9e7;
            color: #d68910;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 12px;
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

        .password-requirements {
            font-size: 0.75rem;
            color: var(--text-light);
            margin-top: 5px;
            padding-left: 10px;
        }

        /* Responsive adjustments */
        @media (max-width: 992px) {
            .split-container {
                flex-direction: column;
            }
            
            .register-panel {
                min-width: 100%;
                max-width: 100%;
                padding: 2rem;
                box-shadow: none;
            }
            
            .register-content {
                padding-top: 30px;
                max-width: 400px;
            }
            
            .visual-panel {
                display: none;
            }
        }

        @media (max-height: 800px) {
            .register-content {
                padding-top: 30px;
            }
            
            .logo-container {
                margin-bottom: 1.5rem;
            }
            
            .main-visual {
                font-size: 5rem;
                margin-bottom: 1.5rem;
            }
            
            .visual-title {
                font-size: 1.9rem;
            }
        }

        @media (max-height: 700px) {
            .register-content {
                padding-top: 20px;
                padding-bottom: 20px;
            }
            
            .input-group-custom {
                margin-bottom: 1.2rem;
            }
            
            .btn-register {
                margin-top: 0.8rem;
            }
            
            .login-link {
                margin-top: 1.5rem;
            }
            
            .security-note {
                margin-top: 1.5rem;
                padding-top: 1.5rem;
            }
        }
    </style>
</head>
<body>

<div class="split-container">
    
    <!-- Left Panel - Registration Form -->
    <div class="register-panel">
        <div class="register-content">
            <div class="logo-container">
                <div class="app-logo">
                    <i class="fas fa-handshake logo-icon"></i>
                    <div class="logo-text">COBNet</div>
                </div>
                <p class="app-tagline">Coordination of Benefits Network</p>
                <p class="app-subtitle">Create Your Account</p>
            </div>

            <!-- Error/Success Messages -->
            <div class="message-container">
                <%
                    String error = (String) request.getAttribute("error");
                    String message = (String) request.getAttribute("message");
                    
                    if (error != null && !error.isEmpty()) {
                %>
                    <div class="alert-error">
                        <i class="fas fa-exclamation-circle alert-icon"></i>
                        <span><%= error %></span>
                    </div>
                <%
                    } else if (message != null && !message.isEmpty()) {
                %>
                    <div class="alert-success">
                        <i class="fas fa-check-circle alert-icon"></i>
                        <span><%= message %></span>
                    </div>
                <%
                    }
                %>
            </div>

            <form action="/auth/register" method="post" id="registerForm">
                <div class="input-group-custom">
                    <label for="username" class="form-label">Username</label>
                    <i class="fas fa-user-circle input-icon"></i>
                    <input type="text" 
                           id="username" 
                           name="username" 
                           class="form-control-custom" 
                           placeholder="Enter your username" 
                           required>
                </div>

                <div class="input-group-custom">
                    <label for="password" class="form-label">Password</label>
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" 
                           id="password" 
                           name="password" 
                           class="form-control-custom" 
                           placeholder="Create a secure password" 
                           required>
                    <div class="password-requirements">
                        <i class="fas fa-info-circle"></i> Use at least 8 characters with mix of letters and numbers
                    </div>
                </div>

                <div class="input-group-custom">
                    <label for="role" class="form-label">Select Your Role</label>
                    <i class="fas fa-user-tag select-icon"></i>
                    <select id="role" name="role" class="select-custom" required onchange="toggleIdField(this.value)">
                        <option value="">Choose your role...</option>
                        <option value="PATIENT">Patient</option>
                        <option value="PROVIDER">Healthcare Provider</option>
                    </select>
                </div>

                <!-- Patient ID Field (Hidden by default) -->
                <div id="patientField" class="input-group-custom id-field" style="display: none;">
                    <label for="patientId" class="form-label">Patient ID</label>
                    <i class="fas fa-id-card input-icon"></i>
                    <input type="number" 
                           id="patientId" 
                           name="patientId" 
                           class="form-control-custom" 
                           placeholder="Enter your patient ID (e.g., 12345)">
                </div>

                <!-- Provider ID Field (Hidden by default) -->
                <div id="providerField" class="input-group-custom id-field" style="display: none;">
                    <label for="providerId" class="form-label">Provider ID</label>
                    <i class="fas fa-id-badge input-icon"></i>
                    <input type="number" 
                           id="providerId" 
                           name="providerId" 
                           class="form-control-custom" 
                           placeholder="Enter your provider ID (e.g., 67890)">
                </div>

                <button type="submit" class="btn-register">
                    <i class="fas fa-user-plus"></i>
                    <span>Create Account</span>
                </button>
            </form>

            <div class="login-link">
                Already have an account? <a href="/auth/login">Sign in here</a>
            </div>

            <div class="security-note">
                <i class="fas fa-shield-alt"></i>
                Your data is protected with 256-bit encryption & HIPAA compliance
            </div>
        </div>
    </div>

    <!-- Right Panel - Visual Area -->
    <div class="visual-panel">
        <div class="visual-content">
            <i class="fas fa-user-plus main-visual"></i>
            
            <h2 class="visual-title">
                Join the COBNet Community
            </h2>
            
            <p class="visual-subtitle">
                Register to access seamless benefits coordination, claim tracking, 
                and healthcare management tools designed for patients and providers.
            </p>

            <div class="features-grid">
                <div class="feature-item">
                    <i class="fas fa-bullseye feature-icon"></i>
                    <div class="feature-text">Accurate Benefits Coordination</div>
                </div>
                
                <div class="feature-item">
                    <i class="fas fa-clock feature-icon"></i>
                    <div class="feature-text">24/7 Claim Tracking</div>
                </div>
                
                <div class="feature-item">
                    <i class="fas fa-file-medical feature-icon"></i>
                    <div class="feature-text">Digital Records Access</div>
                </div>
                
                <div class="feature-item">
                    <i class="fas fa-comments feature-icon"></i>
                    <div class="feature-text">Provider Communication</div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleIdField(role) {
        const patientField = document.getElementById("patientField");
        const providerField = document.getElementById("providerField");
        
        // Reset both fields
        patientField.style.display = "none";
        providerField.style.display = "none";
        
        // Clear values when switching
        document.getElementById("patientId").value = "";
        document.getElementById("providerId").value = "";
        
        // Show appropriate field
        if (role === "PATIENT") {
            patientField.style.display = "block";
        } else if (role === "PROVIDER") {
            providerField.style.display = "block";
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const registerForm = document.getElementById('registerForm');
        const inputs = document.querySelectorAll('.form-control-custom, .select-custom');
        
        // Add interactive effects to form inputs
        inputs.forEach(input => {
            input.addEventListener('focus', function() {
                const parent = this.parentElement;
                const icon = parent.querySelector('.input-icon, .select-icon');
                if (icon) {
                    icon.style.color = 'var(--primary-navy)';
                    icon.style.transform = 'translateY(-50%) scale(1.1)';
                }
            });
            
            input.addEventListener('blur', function() {
                const parent = this.parentElement;
                const icon = parent.querySelector('.input-icon, .select-icon');
                if (icon) {
                    icon.style.color = 'var(--secondary-blue)';
                    icon.style.transform = 'translateY(-50%) scale(1)';
                }
            });
        });
        
        // Form submission with visual feedback
        registerForm.addEventListener('submit', function(e) {
            const submitBtn = this.querySelector('button[type="submit"]');
            const originalContent = submitBtn.innerHTML;
            
            // Show loading state
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Creating Account...</span>';
            submitBtn.disabled = true;
            
            // Simulate API call delay
            setTimeout(() => {
                submitBtn.innerHTML = originalContent;
                submitBtn.disabled = false;
            }, 2000);
        });
        
        // Auto-focus username field on page load
        document.getElementById('username').focus();
        
        // Adjust form position for different screen heights
        function adjustFormPosition() {
            const registerContent = document.querySelector('.register-content');
            const windowHeight = window.innerHeight;
            const contentHeight = registerContent.scrollHeight;
            
            // Center the content vertically if it's smaller than viewport
            if (contentHeight < windowHeight * 0.8) {
                const topPadding = Math.max(30, (windowHeight - contentHeight) * 0.25);
                registerContent.style.paddingTop = topPadding + 'px';
            }
        }
        
        // Initial adjustment
        adjustFormPosition();
        
        // Adjust on window resize
        window.addEventListener('resize', adjustFormPosition);
        
        // Ensure no scrolling
        window.addEventListener('scroll', function(e) {
            if (window.scrollX !== 0 || window.scrollY !== 0) {
                window.scrollTo(0, 0);
            }
        });
        
        // Add password strength indicator (optional enhancement)
        const passwordInput = document.getElementById('password');
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            const requirements = this.parentElement.querySelector('.password-requirements');
            
            if (password.length > 0) {
                let strength = '';
                let color = '';
                
                if (password.length < 8) {
                    strength = 'Weak';
                    color = '#e74c3c';
                } else if (password.length < 12) {
                    strength = 'Good';
                    color = '#f39c12';
                } else if (/[A-Z]/.test(password) && /[0-9]/.test(password)) {
                    strength = 'Strong';
                    color = '#2ecc71';
                } else {
                    strength = 'Good';
                    color = '#f39c12';
                }
                
                requirements.innerHTML = `<i class="fas fa-info-circle"></i> Password strength: <span style="font-weight: bold; color: ${color}">${strength}</span>`;
            }
        });
    });
</script>

</body>
</html>