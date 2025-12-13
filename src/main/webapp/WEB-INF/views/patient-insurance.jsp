<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurance Policies</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .container-custom { 
            max-width: 1200px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .insurance-card { 
            background: white; 
            border-radius: 15px; 
            padding: 30px; 
            box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
        }
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .policy-card { 
            border: 1px solid #e0e0e0; 
            border-radius: 10px; 
            padding: 25px; 
            margin-bottom: 25px; 
            transition: all 0.3s ease;
        }
        .policy-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .policy-card.primary { 
            border-left: 4px solid #007bff; 
            background-color: #f8f9ff; 
        }
        .policy-card.secondary { 
            border-left: 4px solid #6c757d; 
        }
        .badge-primary { 
            background-color: #007bff; 
        }
        .financial-box { 
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 10px; 
            padding: 15px; 
            margin: 10px 0;
            border: 1px solid #dee2e6;
        }
        .detail-label { 
            font-weight: 600; 
            color: #495057; 
            font-size: 0.9rem;
        }
        .detail-value { 
            color: #212529; 
            font-size: 1.1rem;
            font-weight: 600;
        }
        .coverage-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: conic-gradient(#28a745 0% var(--percentage), #e9ecef 0);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            position: relative;
        }
        .coverage-circle::before {
            content: '';
            position: absolute;
            width: 70px;
            height: 70px;
            background: white;
            border-radius: 50%;
        }
        .coverage-text {
            position: relative;
            z-index: 1;
            font-size: 1rem;
            font-weight: 600;
            color: #28a745;
        }
        .amount-badge {
            background: linear-gradient(135deg, #007bff, #0056b3);
            color: white;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="dashboard?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-shield-alt me-2"></i>Insurance Policies
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="insurance-card">
            <h3 class="mb-4"><i class="fas fa-shield-alt me-2"></i>Your Insurance Policies</h3>
            
            <% 
                Object policiesObj = request.getAttribute("insurancePolicies");
                Object primaryCopayObj = request.getAttribute("primaryCopay");
                
                List<Map<String, Object>> policies = null;
                Double primaryCopay = null;
                
                if (policiesObj instanceof List) {
                    policies = (List<Map<String, Object>>) policiesObj;
                }
                
                if (primaryCopayObj instanceof Double) {
                    primaryCopay = (Double) primaryCopayObj;
                }
                
                if (policies != null && !policies.isEmpty()) {
            %>
                
                
                <!-- Insurance Policies List -->
                <% 
                    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
                    for (Map<String, Object> policy : policies) { 
                        boolean isPrimary = (boolean) policy.get("isPrimary");
                        double coveragePercent = (double) policy.get("coveragePercent");
                        double deductible = (double) policy.get("deductible");
                        double copay = (double) policy.get("copay");
                        double coinsurance = (double) policy.get("coinsurance");
                %>
                    <div class="policy-card <%= isPrimary ? "primary" : "secondary" %>">
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div class="flex-grow-1">
                                <h4 class="mb-2">
                                    <i class="fas fa-hospital me-2"></i><%= policy.get("planName") %>
                                    <% if (isPrimary) { %>
                                        <span class="badge bg-primary ms-2">Primary</span>
                                    <% } else { %>
                                        <span class="badge bg-secondary ms-2">Secondary</span>
                                    <% } %>
                                </h4>
                                <p class="text-muted mb-1">
                                    <i class="fas fa-building me-1"></i>
                                    <strong>Payer:</strong> <%= policy.get("payerName") %>
                                </p>
                                <p class="text-muted mb-1">
                                    <i class="fas fa-id-card me-1"></i>
                                    <strong>Policy #:</strong> <%= policy.get("policyNumber") %>
                                </p>
                                <p class="text-muted mb-0">
                                    <i class="fas fa-sort-numeric-up me-1"></i>
                                    <strong>Coverage Order:</strong> #<%= policy.get("coverageOrder") %>
                                </p>
                            </div>
                            <div class="text-end">
                                <div class="coverage-circle" style="--percentage: <%= coveragePercent %>%">
                                    <div class="coverage-text"><%= String.format("%.0f", coveragePercent) %>%</div>
                                </div>
                                <small class="text-muted mt-2 d-block">Coverage</small>
                            </div>
                        </div>
                        
                        <!-- Financial Details -->
                        <div class="row mt-4">
                            <div class="col-md-3">
                                <div class="financial-box">
                                    <div class="detail-label">Copay Amount</div>
                                    <div class="detail-value text-primary">$<%= String.format("%.2f", copay) %></div>
                                    <small class="text-muted">Per visit</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="financial-box">
                                    <div class="detail-label">Deductible</div>
                                    <div class="detail-value">$<%= String.format("%.2f", deductible) %></div>
                                    <small class="text-muted">Annual</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="financial-box">
                                    <div class="detail-label">Coinsurance</div>
                                    <div class="detail-value"><%= String.format("%.0f", coinsurance) %>%</div>
                                    <small class="text-muted">Your share after deductible</small>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="financial-box">
                                    <div class="detail-label">Coverage</div>
                                    <div class="detail-value text-success"><%= String.format("%.0f", coveragePercent) %>%</div>
                                    <small class="text-muted">Insurance pays</small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Additional Details -->
                        <div class="row mt-4">
                            <div class="col-md-4">
                                <p class="mb-2">
                                    <strong><i class="fas fa-tag me-1"></i>Plan Type:</strong> 
                                    <span class="badge bg-info"><%= policy.get("planType") %></span>
                                </p>
                            </div>
                            <div class="col-md-4">
                                <p class="mb-2">
                                    <strong><i class="fas fa-calendar-check me-1"></i>Effective:</strong> 
                                    <%= policy.get("effectiveDate") != null ? policy.get("effectiveDate") : "N/A" %>
                                </p>
                            </div>
                            <div class="col-md-4">
                                <p class="mb-2">
                                    <strong><i class="fas fa-calendar-times me-1"></i>Termination:</strong> 
                                    <%= policy.get("terminationDate") != null ? policy.get("terminationDate") : "Active" %>
                                </p>
                            </div>
                        </div>
                        
                        <!-- Explanation for Primary Insurance -->
                        <% if (isPrimary) { %>
                            <div class="alert alert-light mt-3 mb-0">
                                <small class="text-muted">
                                    <i class="fas fa-lightbulb me-1"></i>
                                    <strong>Note:</strong> This is your primary insurance. Your copay of $<%= String.format("%.2f", copay) %> 
                                    will be applied to medical bills first. After you meet your $<%= String.format("%.2f", deductible) %> 
                                    deductible, you'll pay <%= String.format("%.0f", coinsurance) %>% of covered services.
                                </small>
                            </div>
                        <% } %>
                    </div>
                <% } %>
                
            <% } else { %>
                <div class="alert alert-warning text-center py-5">
                    <div class="py-4">
                        <i class="fas fa-exclamation-triangle fa-3x mb-3 text-warning"></i>
                        <h4>No Insurance Policies Found</h4>
                        <p class="mb-0">You don't have any insurance policies registered. Please contact your provider.</p>
                    </div>
                </div>
            <% } %>
            
            <!-- Footer Actions -->
            <div class="mt-4 pt-3 border-top text-center">
                <a href="dashboard?patientId=${patientId}" class="btn btn-outline-secondary me-3">
                    <i class="fas fa-home me-2"></i>Back to Dashboard
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>