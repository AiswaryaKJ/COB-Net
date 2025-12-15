<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Confirmation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .container-custom { 
            max-width: 800px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .confirmation-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
            text-align: center;
        }
        .success-icon {
            width: 100px;
            height: 100px;
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            font-size: 48px;
            color: white;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0.7); }
            70% { box-shadow: 0 0 0 20px rgba(40, 167, 69, 0); }
            100% { box-shadow: 0 0 0 0 rgba(40, 167, 69, 0); }
        }
        .amount-display {
            font-size: 3rem;
            font-weight: 700;
            color: #28a745;
            margin: 20px 0;
        }
        .receipt-box {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px;
            padding: 25px;
            margin: 25px 0;
            text-align: left;
        }
        .receipt-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        .receipt-item:last-child {
            border-bottom: none;
        }
        .confirmation-number {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 10px 20px;
            border-radius: 20px;
            font-family: monospace;
            font-size: 1.2rem;
            letter-spacing: 2px;
        }
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        .btn-success-large {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 15px 40px;
            border: none;
            border-radius: 10px;
            font-weight: 600;
            font-size: 1.1rem;
        }
        .status-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 20px;
            font-weight: 600;
            margin: 10px 0;
        }
        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }
        .next-steps {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-radius: 10px;
            padding: 20px;
            margin: 20px 0;
            text-align: left;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark" style="background: linear-gradient(135deg, #2c3e50, #3498db);">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/dashboard?patientId=${patientId}">
                <i class="fas fa-home me-2"></i>Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-check-circle me-2"></i>Payment Confirmation
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="confirmation-card">
            <!-- Success Icon -->
            <div class="success-icon">
                <i class="fas fa-check"></i>
            </div>
            
            <!-- Success Message -->
            <h2>Payment Successful!</h2>
            <p class="lead text-muted">
                Your payment has been processed successfully.
            </p>
            
            <!-- Status Badge -->
            <div class="status-badge status-completed">
                <i class="fas fa-check-circle me-2"></i>Payment Completed
            </div>
            
            <!-- Amount Display -->
            <div class="amount-display">
                $<fmt:formatNumber value="${paymentDetails.amountPaid}" pattern="#,##0.00"/>
            </div>
            
            <!-- Confirmation Number -->
            <div class="mb-4">
                <h6>Confirmation Number</h6>
                <div class="confirmation-number">
                    ${paymentDetails.transactionId}
                </div>
                <small class="text-muted">Keep this number for your records</small>
            </div>
            
            <!-- Receipt Details -->
            <div class="receipt-box">
                <h5 class="mb-3"><i class="fas fa-receipt me-2"></i>Payment Receipt</h5>
                
                <div class="receipt-item">
                    <span>Claim Number</span>
                    <span class="fw-bold">HC-${claimId}</span>
                </div>
                
                <div class="receipt-item">
                    <span>Patient Name</span>
                    <span>${paymentDetails.patientName}</span>
                </div>
                
                <div class="receipt-item">
                    <span>Provider</span>
                    <span>${paymentDetails.providerName}</span>
                </div>
                
                <div class="receipt-item">
                    <span>Payment Date</span>
                    <span>${paymentDetails.paymentDate}</span>
                </div>
                
                <div class="receipt-item">
                    <span>Payment Method</span>
                    <span>${paymentDetails.paymentMethod}</span>
                </div>
                
                <div class="receipt-item">
                    <span>Transaction Status</span>
                    <span class="text-success fw-bold">${paymentDetails.status}</span>
                </div>
                
                <div class="receipt-item">
                    <span>Amount Paid</span>
                    <span class="fw-bold text-success">
                        $<fmt:formatNumber value="${paymentDetails.amountPaid}" pattern="#,##0.00"/>
                    </span>
                </div>
            </div>
            
            <!-- What Happens Next -->
            <div class="next-steps">
                <h6><i class="fas fa-forward me-2"></i>What Happens Next?</h6>
                <ul class="mb-0">
                    <li>Your claim status has been updated to <strong>"Paid"</strong></li>
                    <li>You can view your updated EOB with payment confirmation</li>
                    <li>A receipt has been saved to your account</li>
                    <li>No further action is required for this claim</li>
                </ul>
            </div>
            
            <!-- Important Notes -->
            <div class="alert alert-info mt-4">
                <h6><i class="fas fa-info-circle me-2"></i>Important Information</h6>
                <p class="mb-2 small">
                    <strong>This was a demonstration payment.</strong> No actual money was transferred. 
                    In a real system, this would process through a payment gateway.
                </p>
                <p class="mb-0 small">
                    You can download a copy of this receipt for your records. If you have any questions, 
                    contact our billing department at <strong>(555) 123-4567</strong>.
                </p>
            </div>
            
            <!-- Action Buttons -->
            <div class="action-buttons">
                <a href="/patient/eob/${claimId}?patientId=${patientId}" class="btn btn-primary btn-lg">
                    <i class="fas fa-file-invoice-dollar me-2"></i>View Updated EOB
                </a>
                
                <a href="/patient/bills?patientId=${patientId}" class="btn btn-success-large">
                    <i class="fas fa-money-bill-wave me-2"></i>View Bills
                </a>
                
                <button onclick="window.print()" class="btn btn-outline-secondary btn-lg">
                    <i class="fas fa-print me-2"></i>Print Receipt
                </button>
            </div>
            
            <!-- Additional Links -->
            <div class="mt-4">
                <a href="/patient/dashboard?patientId=${patientId}" class="text-decoration-none me-3">
                    <i class="fas fa-home me-1"></i>Back to Dashboard
                </a>
                <a href="/patient/claims?patientId=${patientId}" class="text-decoration-none me-3">
                    <i class="fas fa-file-medical me-1"></i>View All Claims
                </a>
                <a href="/patient/policies?patientId=${patientId}" class="text-decoration-none">
                    <i class="fas fa-shield-alt me-1"></i>Insurance Policies
                </a>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer class="mt-5 py-3 border-top text-center text-muted">
        <div class="container">
            <p class="mb-0">
                <i class="fas fa-check-circle me-1"></i>
                Health Insurance CoB System &copy; 2024 | 
                Transaction: ${paymentDetails.transactionId}
            </p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Print receipt function
        function printReceipt() {
            window.print();
        }
        
        // Download receipt as PDF
        function downloadReceipt() {
            alert('Receipt download would start here. In a real app, this would generate a PDF.');
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Auto-redirect after 10 seconds (optional)
            setTimeout(() => {
                console.log('Auto-redirect to bills page after 10 seconds');
                // Uncomment to enable auto-redirect
                // window.location.href = '/patient/bills?patientId=${patientId}';
            }, 10000);
        });
    </script>
</body>
</html>