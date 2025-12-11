<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Medical Claim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --light-bg: #f8f9fa;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
            color: #333;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header-card {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }
        
        .section-title {
            color: var(--primary-color);
            padding-bottom: 10px;
            margin-bottom: 25px;
            border-bottom: 3px solid var(--secondary-color);
            font-weight: 600;
        }
        
        .form-label {
            font-weight: 600;
            color: #444;
            margin-bottom: 8px;
        }
        
        .required::after {
            content: " *";
            color: #e74c3c;
        }
        
        .form-control, .form-select {
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, var(--secondary-color), #2980b9);
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            margin: 30px auto;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(52, 152, 219, 0.3);
        }
        
        .alert-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            min-width: 300px;
        }
        
        .info-box {
            background: #e8f4fc;
            border-left: 4px solid var(--secondary-color);
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .nav-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        
        .btn-back {
            background: #6c757d;
            color: white;
            padding: 10px 25px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-back:hover {
            background: #5a6268;
            color: white;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .header-card {
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <!-- Error/Success Messages -->
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert-container">
            <div class="alert alert-danger alert-dismissible fade show shadow-lg" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    <% } %>
    
    <div class="container">
        <!-- Header -->
        <div class="header-card">
            <div class="row align-items-center">
                <div class="col-md-2 text-center">
                    <i class="fas fa-file-medical fa-4x"></i>
                </div>
                <div class="col-md-10">
                    <h1><i class="fas fa-stethoscope me-2"></i>Medical Claim Submission</h1>
                    <p class="mb-0">Fill out the form below to submit a new medical claim for processing</p>
                </div>
            </div>
        </div>
        
        <!-- Information Box -->
        <div class="info-box">
            <h5><i class="fas fa-info-circle me-2 text-primary"></i>Important Information</h5>
            <p class="mb-0">Please ensure all required fields (marked with *) are completed accurately. Incomplete or incorrect information may delay claim processing.</p>
        </div>
        
        <!-- Claim Form -->
        <div class="form-container">
            <form action="submitclaim" method="POST">
                <!-- Patient Information Section -->
                <h3 class="section-title">
                    <i class="fas fa-user-injured me-2"></i>Patient Information
                </h3>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Patient ID</label>
                            <input type="number" class="form-control" name="patient.patientId" 
                                   placeholder="Enter patient identification number" required>
                            <small class="form-text text-muted">Unique patient identifier</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Patient Name</label>
                            <input type="text" class="form-control" 
                                   placeholder="Will auto-fetch from system" readonly>
                            <small class="form-text text-muted">Auto-populated from patient ID</small>
                        </div>
                    </div>
                </div>
                
                <!-- Provider Information Section -->
                <h3 class="section-title mt-5">
                    <i class="fas fa-user-md me-2"></i>Provider Information
                </h3>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Provider ID</label>
                            <input type="number" class="form-control" name="provider.providerId" 
                                   placeholder="Enter your provider ID" required>
                            <small class="form-text text-muted">Your unique provider identifier</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Provider Name</label>
                            <input type="text" class="form-control" 
                                   placeholder="Will auto-fetch from system" readonly>
                            <small class="form-text text-muted">Auto-populated from provider ID</small>
                        </div>
                    </div>
                </div>
                
                <!-- Claim Details Section -->
                <h3 class="section-title mt-5">
                    <i class="fas fa-file-invoice-dollar me-2"></i>Claim Details
                </h3>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Billed Amount ($)</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" step="0.01" class="form-control" name="billedAmount" 
                                       placeholder="0.00" required>
                            </div>
                            <small class="form-text text-muted">Enter the total amount billed</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Claim Date</label>
                            <input type="date" class="form-control" 
                                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" readonly>
                            <small class="form-text text-muted">Automatically set to today's date</small>
                        </div>
                    </div>
                </div>
                
                <!-- Medical Codes -->
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Diagnosis Code (ICD-10)</label>
                            <input type="text" class="form-control" name="diagnosisCode" 
                                   placeholder="e.g., J06.9 - Acute upper respiratory infection">
                            <small class="form-text text-muted">Enter ICD-10 diagnosis code</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Procedure Code (CPT/HCPCS)</label>
                            <input type="text" class="form-control" name="procedureCode" 
                                   placeholder="e.g., 99213 - Office visit">
                            <small class="form-text text-muted">Enter CPT/HCPCS procedure code</small>
                        </div>
                    </div>
                </div>
                
                <!-- Hidden Fields -->
                <input type="hidden" name="status" value="Submitted">
                <input type="hidden" name="claimDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                
                <!-- Form Buttons -->
                <div class="nav-buttons">
                    <a href="welcome" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    <div>
                        <button type="reset" class="btn btn-secondary">
                            <i class="fas fa-redo me-1"></i> Clear Form
                        </button>
                        <button type="submit" class="btn btn-submit">
                            <i class="fas fa-paper-plane me-1"></i> Submit Claim
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-dismiss alerts
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
        
        // Format currency input
        document.addEventListener('DOMContentLoaded', function() {
            const amountInput = document.querySelector('input[name="billedAmount"]');
            if (amountInput) {
                amountInput.addEventListener('blur', function(e) {
                    let value = parseFloat(e.target.value);
                    if (!isNaN(value)) {
                        e.target.value = value.toFixed(2);
                    }
                });
            }
            
            // Auto-fetch patient name (simulated)
            const patientIdInput = document.querySelector('input[name="patient.patientId"]');
            const providerIdInput = document.querySelector('input[name="provider.providerId"]');
            
            if (patientIdInput) {
                patientIdInput.addEventListener('blur', function() {
                    // In real implementation, this would fetch from backend
                    console.log('Fetching patient info for ID:', this.value);
                });
            }
            
            if (providerIdInput) {
                providerIdInput.addEventListener('blur', function() {
                    // In real implementation, this would fetch from backend
                    console.log('Fetching provider info for ID:', this.value);
                });
            }
        });
    </script>
</body>
</html>