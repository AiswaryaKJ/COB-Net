<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pay Copay</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 600px; margin: 50px auto; padding: 0 20px; }
        .payment-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .navbar-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .payment-method { border: 2px solid #e0e0e0; border-radius: 10px; padding: 15px; margin-bottom: 15px; cursor: pointer; }
        .payment-method:hover { border-color: #007bff; }
        .payment-method.selected { border-color: #28a745; background-color: #f8fff9; }
        .btn-confirm { background: linear-gradient(135deg, #28a745, #20c997); color: white; padding: 12px 30px; border: none; border-radius: 8px; font-weight: 600; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="bills?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Bills
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-credit-card me-2"></i>Pay Copay
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="payment-card">
            <h3 class="mb-4"><i class="fas fa-money-check-alt me-2"></i>Pay Your Copay</h3>
            
            <!-- Payment Summary -->
            <div class="alert alert-info mb-4">
                <h5>Payment Summary</h5>
                <p class="mb-1"><strong>Claim #:</strong> HC-${claimId}</p>
                <p class="mb-1"><strong>Copay Amount:</strong> 
                    <span class="text-danger fw-bold">
                        $<%= request.getAttribute("copayAmount") != null ? 
                            String.format("%.2f", request.getAttribute("copayAmount")) : "0.00" %>
                    </span>
                </p>
            </div>
            
            <!-- Payment Instructions -->
            <div class="alert alert-warning mb-4">
                <h5><i class="fas fa-info-circle me-2"></i>How to Pay</h5>
                <p class="mb-2">This is a demonstration payment system. In a real application, this would connect to a payment gateway.</p>
                <p class="mb-0">For now, click "Confirm Payment" to mark this copay as paid in the system.</p>
            </div>
            
            <!-- Payment Method Selection -->
            <h5 class="mb-3">Select Payment Method</h5>
            
            <div class="payment-method selected" onclick="selectMethod('cash')">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" id="cash" value="cash" checked>
                    <label class="form-check-label" for="cash">
                        <strong><i class="fas fa-money-bill-wave me-2"></i>Cash Payment</strong>
                        <p class="text-muted mb-0 small">Pay at billing department</p>
                    </label>
                </div>
            </div>
            
            <div class="payment-method" onclick="selectMethod('credit')">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" id="credit" value="credit">
                    <label class="form-check-label" for="credit">
                        <strong><i class="fas fa-credit-card me-2"></i>Credit/Debit Card</strong>
                        <p class="text-muted mb-0 small">Visa, MasterCard, American Express</p>
                    </label>
                </div>
            </div>
            
            <div class="payment-method" onclick="selectMethod('check')">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="paymentMethod" id="check" value="check">
                    <label class="form-check-label" for="check">
                        <strong><i class="fas fa-file-signature me-2"></i>Check</strong>
                        <p class="text-muted mb-0 small">Personal or bank check</p>
                    </label>
                </div>
            </div>
            
            <!-- Confirm Payment Form -->
            <form action="pay" method="POST" class="mt-4">
                <input type="hidden" name="patientId" value="${patientId}">
                <input type="hidden" name="claimId" value="${claimId}">
                
                <div class="d-grid gap-2">
                    <button type="submit" class="btn-confirm">
                        <i class="fas fa-check-circle me-2"></i>Confirm Payment
                    </button>
                    <a href="bills?patientId=${patientId}" class="btn btn-secondary">
                        <i class="fas fa-times me-2"></i>Cancel
                    </a>
                </div>
            </form>
            
            <!-- Important Note -->
            <div class="alert alert-light mt-4">
                <p class="mb-0 small text-muted">
                    <i class="fas fa-shield-alt me-1"></i>
                    This is a simulated payment. No actual money will be transferred.
                    The system will mark your copay as paid and update your claim status.
                </p>
            </div>
        </div>
    </div>
    
    <script>
        function selectMethod(method) {
            // Remove selected class from all
            document.querySelectorAll('.payment-method').forEach(el => {
                el.classList.remove('selected');
            });
            
            // Add selected class to clicked method
            document.getElementById(method).parentElement.parentElement.classList.add('selected');
            
            // Check the radio button
            document.getElementById(method).checked = true;
        }
    </script>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>