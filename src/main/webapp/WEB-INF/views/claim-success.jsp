<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claim Submitted Successfully</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        :root {
            --success-color: #27ae60;
            --primary-color: #2c3e50;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
        }
        
        .success-container {
            width: 100%;
            max-width: 800px;
            padding: 20px;
        }
        
        .success-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            text-align: center;
            animation: fadeIn 0.5s ease-out;
        }
        
        .success-header {
            background: linear-gradient(135deg, var(--success-color), #219653);
            color: white;
            padding: 50px 30px;
        }
        
        .success-icon {
            font-size: 5rem;
            margin-bottom: 20px;
            animation: bounce 1s ease infinite alternate;
        }
        
        .claim-details {
            padding: 40px;
        }
        
        .details-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 30px;
            margin: 30px 0;
            text-align: left;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 15px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            color: #666;
            font-weight: 600;
        }
        
        .detail-value {
            color: var(--primary-color);
            font-weight: 700;
        }
        
        .action-buttons {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-top: 30px;
        }
        
        .action-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            padding: 15px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #3498db, #2980b9);
            color: white;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-outline {
            background: white;
            color: var(--primary-color);
            border: 2px solid var(--primary-color);
        }
        
        .action-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        
        .confirmation-note {
            background: #e8f6ef;
            border-left: 4px solid var(--success-color);
            padding: 15px;
            border-radius: 5px;
            margin: 20px 0;
            text-align: left;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes bounce {
            from { transform: translateY(0); }
            to { transform: translateY(-10px); }
        }
        
        @media (max-width: 768px) {
            .success-container {
                padding: 10px;
            }
            
            .claim-details {
                padding: 20px;
            }
            
            .detail-row {
                flex-direction: column;
                gap: 5px;
            }
            
            .action-buttons {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="success-container">
        <div class="success-card">
            <div class="success-header">
                <div class="success-icon">
                    <i class="fas fa-check-circle"></i>
                </div>
                <h1>Claim Submitted Successfully!</h1>
                <p class="lead">Your medical claim has been received and is now being processed.</p>
            </div>
            
            <div class="claim-details">
                <h3 style="color: var(--primary-color); margin-bottom: 30px;">
                    <i class="fas fa-receipt me-2"></i>Claim Summary
                </h3>
                
                <div class="details-card">
                    <div class="detail-row">
                        <span class="detail-label">Claim Reference Number:</span>
                        <span class="detail-value">HC-<%= request.getAttribute("claimId") != null ? request.getAttribute("claimId") : "0000" %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Patient ID:</span>
                        <span class="detail-value"><%= request.getAttribute("patientId") != null ? request.getAttribute("patientId") : "N/A" %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Billed Amount:</span>
                        <span class="detail-value">$<%= request.getAttribute("billedAmount") != null ? request.getAttribute("billedAmount") : "0.00" %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Submission Date:</span>
                        <span class="detail-value"><%= new java.text.SimpleDateFormat("MMM dd, yyyy hh:mm a").format(new java.util.Date()) %></span>
                    </div>
                    
                    <div class="detail-row">
                        <span class="detail-label">Status:</span>
                        <span class="detail-value"><span style="color: #3498db; font-weight: 600;">Submitted</span></span>
                    </div>
                </div>
                
                <div class="confirmation-note">
                    <h5><i class="fas fa-info-circle me-2"></i>Important Next Steps:</h5>
                    <ul class="mb-0">
                        <li>A confirmation email has been sent to your registered email address</li>
                        <li>Please save your Claim Reference Number for future reference</li>
                        <li>Typical processing time is 24-48 business hours</li>
                        <li>You can track the status using your Claim Reference Number</li>
                    </ul>
                </div>
                
                <div class="action-buttons">
                    <a href="submitclaim" class="action-btn btn-primary">
                        <i class="fas fa-plus-circle"></i>
                        Submit Another Claim
                    </a>
                    
                    <a href="viewclaims" class="action-btn btn-secondary">
                        <i class="fas fa-list-alt"></i>
                        View All Claims
                    </a>
                    
                    <a href="welcome" class="action-btn btn-outline">
                        <i class="fas fa-home"></i>
                        Back to Dashboard
                    </a>
                </div>
                
                <p class="text-muted mt-4">
                    <i class="fas fa-phone me-1"></i>Need assistance? Call 1-800-HEALTH-CLAIM
                </p>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Print functionality
        function printClaim() {
            window.print();
        }
        
        // Share functionality (simulated)
        function shareClaim() {
            alert('Share functionality would be implemented here!');
        }
    </script>
</body>
</html>