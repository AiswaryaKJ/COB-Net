<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Make Payment</title>
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
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .payment-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
        }
        .payment-method { 
            border: 2px solid #e0e0e0; 
            border-radius: 10px; 
            padding: 15px; 
            margin-bottom: 15px; 
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .payment-method:hover {
            border-color: #007bff;
            transform: translateY(-2px);
        }
        .payment-method.selected { 
            border-color: #28a745; 
            background-color: #f8fff9; 
        }
        .summary-box {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .amount-display {
            font-size: 2.5rem;
            font-weight: 700;
            color: #dc3545;
            text-align: center;
            margin: 20px 0;
        }
        .btn-confirm { 
            background: linear-gradient(135deg, #28a745, #20c997); 
            color: white; 
            padding: 15px 40px; 
            border: none; 
            border-radius: 10px; 
            font-weight: 600;
            font-size: 1.1rem;
            transition: all 0.3s ease;
        }
        .btn-confirm:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        .secure-badge {
            background: linear-gradient(135deg, #ffc107, #e0a800);
            color: #212529;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .form-control:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.25rem rgba(40, 167, 69, 0.25);
        }
        .info-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .payment-details {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }
        .spinner {
            width: 60px;
            height: 60px;
            border: 5px solid #f3f3f3;
            border-top: 5px solid #28a745;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/bills?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Bills
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-credit-card me-2"></i>Make Payment
            </span>
        </div>
    </nav>
    
    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
    </div>
    
    <div class="container-custom">
        <div class="payment-card">
            <!-- Payment Header -->
            <div class="text-center mb-4">
                <h3><i class="fas fa-credit-card me-2"></i>Make a Payment</h3>
                <p class="text-muted">Complete your payment securely</p>
                <div class="secure-badge">
                    <i class="fas fa-shield-alt"></i>
                    256-bit SSL Secured
                </div>
            </div>
            
            <!-- Payment Summary -->
            <div class="payment-details">
                <div class="row">
                    <div class="col-md-6">
                        <h6><i class="fas fa-file-medical-alt me-2"></i>Payment For</h6>
                        <p class="mb-1"><strong>Claim #:</strong> HC-${claimId}</p>
                        <p class="mb-1"><strong>Provider:</strong> 
                            <c:if test="${billDetails.providerName != null}">
                                ${billDetails.providerName}
                            </c:if>
                        </p>
                        <p class="mb-0"><strong>Service:</strong> 
                            <c:if test="${billDetails.diagnosis != null}">
                                ${billDetails.diagnosis}
                            </c:if>
                        </p>
                    </div>
                    <div class="col-md-6 text-end">
                        <h6><i class="fas fa-dollar-sign me-2"></i>Payment Amount</h6>
                        <div class="amount-display">
                            $<fmt:formatNumber value="${amountDue}" pattern="#,##0.00"/>
                        </div>
                        <small class="text-muted">Your share after insurance</small>
                    </div>
                </div>
            </div>
            
            <!-- Payment Instructions -->
            <div class="alert alert-warning mb-4">
                <h5><i class="fas fa-info-circle me-2"></i>Important Information</h5>
                <p class="mb-2">This is a <strong>demonstration payment system</strong>. No actual money will be transferred.</p>
                <p class="mb-0">Clicking "Confirm Payment" will mark this bill as paid in our system for demonstration purposes.</p>
            </div>
            
            <!-- Payment Method Selection -->
            <h5 class="mb-3">Select Payment Method</h5>
            
            <div class="payment-method selected" onclick="selectMethod('cash')">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" 
                           id="cash" value="cash" checked>
                    <label class="form-check-label" for="cash">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-money-bill-wave fa-2x text-success"></i>
                            </div>
                            <div>
                                <strong>Cash Payment</strong>
                                <p class="text-muted mb-0 small">Pay at billing department or hospital front desk</p>
                            </div>
                        </div>
                    </label>
                </div>
            </div>
            
            <div class="payment-method" onclick="selectMethod('credit')">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" 
                           id="credit" value="credit">
                    <label class="form-check-label" for="credit">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-credit-card fa-2x text-primary"></i>
                            </div>
                            <div>
                                <strong>Credit/Debit Card</strong>
                                <p class="text-muted mb-0 small">Visa, MasterCard, American Express, Discover</p>
                            </div>
                        </div>
                    </label>
                </div>
            </div>
            
            <div class="payment-method" onclick="selectMethod('check')">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" 
                           id="check" value="check">
                    <label class="form-check-label" for="check">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-file-signature fa-2x text-warning"></i>
                            </div>
                            <div>
                                <strong>Check</strong>
                                <p class="text-muted mb-0 small">Personal or bank check mailed to billing address</p>
                            </div>
                        </div>
                    </label>
                </div>
            </div>
            
            <div class="payment-method" onclick="selectMethod('bank')">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" 
                           id="bank" value="bank">
                    <label class="form-check-label" for="bank">
                        <div class="d-flex align-items-center">
                            <div class="me-3">
                                <i class="fas fa-university fa-2x text-info"></i>
                            </div>
                            <div>
                                <strong>Bank Transfer</strong>
                                <p class="text-muted mb-0 small">Direct bank transfer or ACH payment</p>
                            </div>
                        </div>
                    </label>
                </div>
            </div>
            
            <!-- Payment Form -->
            <form action="/patient/pay" method="POST" id="paymentForm" onsubmit="return validatePayment()">
                <input type="hidden" name="patientId" value="${patientId}">
                <input type="hidden" name="claimId" value="${claimId}">
                
                <!-- ADD THIS HIDDEN INPUT FOR PAYMENT METHOD -->
                <input type="hidden" name="paymentMethod" id="paymentMethodHidden" value="cash">
                
                <!-- Additional Information for Credit Card -->
                <div id="creditCardInfo" style="display: none;">
                    <div class="info-card mt-4">
                        <h6 class="mb-3"><i class="fas fa-credit-card me-2"></i>Card Details</h6>
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label class="form-label">Card Number</label>
                                <input type="text" class="form-control" 
                                       placeholder="1234 5678 9012 3456" 
                                       maxlength="19" 
                                       oninput="formatCardNumber(this)">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Expiry Date</label>
                                <input type="text" class="form-control" 
                                       placeholder="MM/YY" 
                                       maxlength="5"
                                       oninput="formatExpiryDate(this)">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">CVV</label>
                                <input type="text" class="form-control" 
                                       placeholder="123" 
                                       maxlength="4"
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '')">
                            </div>
                            <div class="col-md-12 mb-3">
                                <label class="form-label">Name on Card</label>
                                <input type="text" class="form-control" 
                                       placeholder="John Doe">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Additional Information for Check -->
                <div id="checkInfo" style="display: none;">
                    <div class="info-card mt-4">
                        <h6 class="mb-3"><i class="fas fa-file-signature me-2"></i>Check Information</h6>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Check Number</label>
                                <input type="text" class="form-control" 
                                       placeholder="e.g., 1001">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Bank Name</label>
                                <input type="text" class="form-control" 
                                       placeholder="e.g., Chase Bank">
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Payment Confirmation -->
                <div class="alert alert-light mt-4">
                    <div class="form-check">
                        <input class="form-check-input" type="checkbox" 
                               id="terms" required>
                        <label class="form-check-label" for="terms">
                            I authorize this payment of 
                            <strong>$<fmt:formatNumber value="${amountDue}" pattern="#,##0.00"/></strong> 
                            for Claim #HC-${claimId}. I understand this is a demonstration and no actual 
                            money will be transferred.
                        </label>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="d-grid gap-3 mt-4">
                    <button type="submit" class="btn-confirm">
                        <i class="fas fa-check-circle me-2"></i>Confirm Payment
                    </button>
                    <a href="/patient/bills?patientId=${patientId}" class="btn btn-secondary btn-lg">
                        <i class="fas fa-times me-2"></i>Cancel Payment
                    </a>
                </div>
            </form>
            
            <!-- Important Notes -->
            <div class="alert alert-info mt-4">
                <h6><i class="fas fa-shield-alt me-2"></i>Security & Privacy</h6>
                <p class="mb-2 small">
                    Your payment information is protected with bank-level security. We use 256-bit SSL encryption 
                    and never store your full payment details on our servers.
                </p>
                <p class="mb-0 small">
                    <strong>Note:</strong> This is a demonstration system. After clicking "Confirm Payment", 
                    the claim status will be updated to "Paid" in our database for demonstration purposes.
                </p>
            </div>
        </div>
    </div>
    
    <!-- Footer -->
    <footer class="mt-5 py-3 border-top text-center text-muted">
        <div class="container">
            <p class="mb-0">
                <i class="fas fa-credit-card me-1"></i>
                Health Insurance CoB System &copy; 2024 | 
                Patient: ${patientName}
            </p>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Select payment method
        function selectMethod(method) {
            // Remove selected class from all
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Add selected class to clicked method
            document.getElementById(method).parentElement.parentElement.classList.add('selected');
            
            // Check the radio button
            document.getElementById(method).checked = true;
            
            // Set the hidden field value
            document.getElementById('paymentMethodHidden').value = method;
            
            // Show/hide additional info sections
            document.getElementById('creditCardInfo').style.display = 
                (method === 'credit') ? 'block' : 'none';
            document.getElementById('checkInfo').style.display = 
                (method === 'check') ? 'block' : 'none';
        }
        
        // Format card number with spaces
        function formatCardNumber(input) {
            let value = input.value.replace(/\s/g, '').replace(/[^0-9]/g, '');
            let formatted = '';
            
            for (let i = 0; i < value.length; i++) {
                if (i > 0 && i % 4 === 0) {
                    formatted += ' ';
                }
                formatted += value[i];
            }
            
            input.value = formatted.substring(0, 19);
        }
        
        // Format expiry date
        function formatExpiryDate(input) {
            let value = input.value.replace(/[^0-9]/g, '');
            
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            
            input.value = value.substring(0, 5);
        }
        
        // Validate payment form
        function validatePayment() {
            const paymentMethod = document.querySelector('input[name="paymentMethod"]:checked');
            const termsChecked = document.getElementById('terms').checked;
            
            if (!paymentMethod) {
                alert('Please select a payment method');
                return false;
            }
            
            if (!termsChecked) {
                alert('Please agree to the terms and conditions');
                return false;
            }
            
            // Show loading overlay
            document.getElementById('loadingOverlay').style.display = 'flex';
            
            // Simulate payment processing
            setTimeout(() => {
                // In a real app, you would submit the form here
                // For demonstration, we'll show a success message
                alert('Payment successful! Your claim will be marked as paid.');
                document.getElementById('paymentForm').submit();
            }, 2000);
            
            return false; // Prevent actual form submission for demo
        }
        
        // Initialize
        document.addEventListener('DOMContentLoaded', function() {
            // Default to cash method
            selectMethod('cash');
            
            // Add event listeners to payment methods
            document.querySelectorAll('.payment-method').forEach(el => {
                el.addEventListener('click', function() {
                    const method = this.querySelector('input').value;
                    selectMethod(method);
                });
            });
        });
    </script>
</body>
</html>