<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.demo.bean.Claim" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Claim Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .container-custom { 
            max-width: 900px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .details-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 20px rgba(0,0,0,0.08); 
        }
        .detail-section { 
            margin-bottom: 25px; 
            padding-bottom: 25px; 
            border-bottom: 1px solid #eaeaea; 
        }
        .detail-section:last-child { 
            border-bottom: none; 
        }
        .detail-label { 
            font-weight: 600; 
            color: #495057; 
            font-size: 0.9rem;
            margin-bottom: 5px;
        }
        .detail-value { 
            color: #212529; 
            font-size: 1.1rem;
            font-weight: 500;
        }
        .status-badge { 
            padding: 6px 15px; 
            border-radius: 20px; 
            font-weight: 600; 
            font-size: 0.9rem; 
        }
        .status-submitted { 
            background: #fff3cd; 
            color: #856404; 
        }
        .status-processed { 
            background: #d4edda; 
            color: #155724; 
        }
        .status-denied { 
            background: #f8d7da; 
            color: #721c24; 
        }
        .status-paid { 
            background: #cce5ff; 
            color: #004085; 
        }
        .processing-notice { 
            background: #e7f1ff; 
            border-left: 4px solid #0d6efd; 
            padding: 15px; 
            margin-bottom: 25px; 
            border-radius: 5px; 
        }
        .amount-box { 
            background: linear-gradient(135deg, #f8f9fa, #e9ecef); 
            border-radius: 10px; 
            padding: 20px; 
            margin: 15px 0; 
            border: 1px solid #dee2e6; 
        }
        .back-button { 
            background: linear-gradient(135deg, #6c757d, #495057); 
            color: white; 
            border: none; 
            padding: 10px 25px; 
            border-radius: 8px; 
            text-decoration: none; 
            display: inline-flex; 
            align-items: center; 
        }
        .back-button:hover { 
            color: white; 
            text-decoration: none; 
            opacity: 0.9; 
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="bills?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to All Bills
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-file-medical-alt me-2"></i>Claim Details
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="details-card">
            <!-- Page Header -->
            <div class="detail-section">
                <h3 class="mb-3"><i class="fas fa-file-invoice me-2"></i>Claim Details</h3>
                <p class="text-muted">Complete information for Claim #HC-${claim.claimId}</p>
            </div>
            
            <% 
                Claim claim = (Claim) request.getAttribute("claim");
                String providerName = (String) request.getAttribute("providerName");
                String patientName = (String) request.getAttribute("patientName");
                String status = claim.getStatus();
                String statusClass = "";
                
                if ("Submitted".equals(status)) {
                    statusClass = "status-submitted";
                } else if ("Processed".equals(status)) {
                    statusClass = "status-processed";
                } else if ("Denied".equals(status)) {
                    statusClass = "status-denied";
                } else if ("Paid".equals(status)) {
                    statusClass = "status-paid";
                }
            %>
            
            <!-- Processing Notice for Submitted Claims -->
            <% if ("Submitted".equals(status)) { %>
                <div class="processing-notice">
                    <i class="fas fa-sync-alt fa-spin me-2"></i>
                    <strong>Processing Notice:</strong> This claim is currently being reviewed by insurance. 
                    The final amount will be calculated after processing is complete. No payment is required at this time.
                </div>
            <% } %>
            
            <!-- Claim Information -->
            <div class="detail-section">
                <h5 class="mb-4"><i class="fas fa-info-circle me-2"></i>Claim Information</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Claim ID</div>
                        <div class="detail-value">HC-${claim.claimId}</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Date Submitted</div>
                        <div class="detail-value">${claim.claimDate}</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Status</div>
                        <div>
                            <span class="status-badge <%= statusClass %>">
                                <%= status %>
                            </span>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Patient</div>
                        <div class="detail-value"><%= patientName != null ? patientName : "N/A" %></div>
                    </div>
                </div>
            </div>
            
            <!-- Medical Information -->
            <div class="detail-section">
                <h5 class="mb-4"><i class="fas fa-stethoscope me-2"></i>Medical Information</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Diagnosis Code</div>
                        <div class="detail-value">
                            <%= claim.getDiagnosisCode() != null ? claim.getDiagnosisCode() : "N/A" %>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Procedure Code</div>
                        <div class="detail-value">
                            <%= claim.getProcedureCode() != null ? claim.getProcedureCode() : "N/A" %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Provider Information -->
            <div class="detail-section">
                <h5 class="mb-4"><i class="fas fa-user-md me-2"></i>Provider Information</h5>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Provider</div>
                        <div class="detail-value">
                            <%= providerName != null ? providerName : "N/A" %>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="detail-label">Provider ID</div>
                        <div class="detail-value">
                            <%= claim.getProvider() != null ? claim.getProvider().getProviderId() : "N/A" %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Financial Information -->
            <div class="detail-section">
                <h5 class="mb-4"><i class="fas fa-money-bill-wave me-2"></i>Financial Information</h5>
                
                <div class="amount-box">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="detail-label">Total Billed Amount</div>
                            <div class="detail-value text-primary" style="font-size: 1.5rem;">
                                $<%= String.format("%.2f", claim.getBilledAmount()) %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <% if ("Submitted".equals(status)) { %>
                                <div class="detail-label">Current Status</div>
                                <div class="detail-value">Processing - Amount being calculated</div>
                            <% } else if (claim.getFinalOutOfPocket() != null) { %>
                                <div class="detail-label">Final Amount Due</div>
                                <div class="detail-value" style="font-size: 1.5rem; color: #dc3545;">
                                    $<%= String.format("%.2f", claim.getFinalOutOfPocket()) %>
                                </div>
                            <% } else { %>
                                <div class="detail-label">Amount Due</div>
                                <div class="detail-value">To be determined</div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- Status Explanation -->
                <div class="mt-3">
                    <% if ("Submitted".equals(status)) { %>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Submitted Claim:</strong> This claim has been submitted to insurance. 
                            The final amount you owe will be calculated after insurance processes the claim.
                        </div>
                    <% } else if ("Processed".equals(status) && claim.getFinalOutOfPocket() != null) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-circle me-2"></i>
                            <strong>Processed Claim:</strong> This claim has been processed. 
                            <% if (claim.getFinalOutOfPocket() > 0) { %>
                                Your final amount due is $<%= String.format("%.2f", claim.getFinalOutOfPocket()) %>.
                            <% } else { %>
                                Insurance has covered the entire amount. You owe $0.00.
                            <% } %>
                        </div>
                    <% } else if ("Denied".equals(status)) { %>
                        <div class="alert alert-danger">
                            <i class="fas fa-times-circle me-2"></i>
                            <strong>Claim Denied:</strong> This claim was denied by insurance. 
                            Please contact your insurance provider for more information.
                        </div>
                    <% } else if ("Paid".equals(status)) { %>
                        <div class="alert alert-success">
                            <i class="fas fa-check-double me-2"></i>
                            <strong>Claim Paid:</strong> This claim has been fully paid.
                        </div>
                    <% } %>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="detail-section">
                <div class="d-flex justify-content-between">
                    <a href="bills?patientId=${patientId}" class="back-button">
                        <i class="fas fa-arrow-left me-2"></i>Back to All Bills
                    </a>
                    
                    <!-- Payment Button only for Processed claims with amount due -->
                    <% if ("Processed".equals(status) && claim.getFinalOutOfPocket() != null && claim.getFinalOutOfPocket() > 0) { %>
                        <a href="pay?patientId=${patientId}&claimId=${claim.claimId}" 
                           class="btn btn-success" style="padding: 10px 25px;">
                            <i class="fas fa-credit-card me-2"></i>Pay Now
                        </a>
                    <% } %>
                </div>
            </div>
            
            <!-- Important Notes -->
            <div class="alert alert-light mt-4">
                <h6><i class="fas fa-exclamation-circle me-2"></i>Important Information</h6>
                <ul class="mb-0">
                    <li>Claims typically take 7-14 business days to process</li>
                    <li>You will be notified when your claim status changes</li>
                    <li>For questions about claims, contact your insurance provider</li>
                    <li>For billing questions, contact the healthcare provider</li>
                </ul>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>