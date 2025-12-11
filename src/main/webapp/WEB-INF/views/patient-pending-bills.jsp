<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pending Bills</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
        }
        .container-custom { 
            max-width: 1000px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .bill-card { 
            background: white; 
            border-radius: 15px; 
            padding: 25px; 
            margin-bottom: 20px; 
            box-shadow: 0 3px 10px rgba(0,0,0,0.05);
            border-left: 4px solid #ffc107;
        }
        .bill-status { 
            padding: 5px 12px; 
            border-radius: 20px; 
            font-weight: 600; 
            font-size: 0.85rem; 
        }
        .status-submitted { 
            background: #fff3cd; 
            color: #856404; 
        }
        .detail-label { 
            font-weight: 600; 
            color: #495057; 
            font-size: 0.9rem; 
        }
        .detail-value { 
            color: #212529; 
            font-size: 1.1rem;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="bills?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>All Bills
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-clock me-2"></i>Submitted Claims
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <h3 class="mb-4"><i class="fas fa-paper-plane me-2"></i>Submitted Claims</h3>
        <p class="text-muted mb-4">These claims have been submitted and are currently being processed.</p>
        
        <% 
            Object billsObj = request.getAttribute("pendingBills");
            List<Map<String, Object>> pendingBills = null;
            
            if (billsObj instanceof List) {
                pendingBills = (List<Map<String, Object>>) billsObj;
            }
            
            if (pendingBills != null && !pendingBills.isEmpty()) {
        %>
            <% for (Map<String, Object> bill : pendingBills) { 
                int claimId = (int) bill.get("claimId");
                double billedAmount = (double) bill.get("billedAmount");
                String billStatus = (String) bill.get("billStatus");
                String statusMessage = (String) bill.get("statusMessage");
                Double copayAmount = (Double) bill.get("copayAmount");
            %>
                <div class="bill-card">
                    <!-- Processing Notification -->
                    <div class="alert alert-info mb-3">
                        <i class="fas fa-sync-alt fa-spin me-2"></i>
                        <strong>Processing:</strong> This claim is being reviewed. No payment is required at this time.
                    </div>
                    
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h5 class="mb-2">
                                <i class="fas fa-file-medical me-2"></i>Claim #HC-<%= claimId %>
                            </h5>
                            <div class="row mb-2">
                                <div class="col-sm-4">
                                    <div class="detail-label">Billed Amount</div>
                                    <div class="detail-value">$<%= String.format("%.2f", billedAmount) %></div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="detail-label">Date Submitted</div>
                                    <div class="detail-value"><%= bill.get("claimDate") != null ? bill.get("claimDate") : "N/A" %></div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="detail-label">Provider</div>
                                    <div class="detail-value">
                                        <% if (bill.get("providerName") != null) { %>
                                            <%= bill.get("providerName") %>
                                        <% } else { %>
                                            N/A
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">
                                    <div class="detail-label">Diagnosis Code</div>
                                    <div class="detail-value">
                                        <% if (bill.get("diagnosisCode") != null) { %>
                                            <%= bill.get("diagnosisCode") %>
                                        <% } else { %>
                                            N/A
                                        <% } %>
                                    </div>
                                </div>
                                <div class="col-sm-6">
                                    <div class="detail-label">Procedure Code</div>
                                    <div class="detail-value">
                                        <% if (bill.get("procedureCode") != null) { %>
                                            <%= bill.get("procedureCode") %>
                                        <% } else { %>
                                            N/A
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 text-end">
                            <div class="mb-3">
                                <span class="bill-status status-submitted">
                                    <i class="fas fa-paper-plane me-1"></i><%= billStatus %>
                                </span>
                            </div>
							<div class="d-grid">
							    <a href="bill/details?patientId=${patientId}&claimId=<%= claimId %>" 
							       class="btn btn-outline-primary">
							        <i class="fas fa-eye me-1"></i>View Full Details
							    </a>
							</div>
                        </div>
                    </div>
					<div class="mt-3 pt-3 border-top">
					    <small class="text-muted">
					        <i class="fas fa-info-circle me-1"></i>
					        <%= statusMessage %>
					    </small>
					</div>
                </div>
            <% } %>
            
            <div class="alert alert-light mt-4">
                <h5><i class="fas fa-question-circle me-2"></i>About Submitted Claims</h5>
                <p class="mb-2">Submitted claims are being processed by your insurance provider. During this time:</p>
                <ul class="mb-0">
                    <li>No payment is required</li>
                    <li>Final amount will be calculated after processing</li>
                    <li>You will be notified when the claim is processed</li>
                    <li>Check back regularly for status updates</li>
                </ul>
            </div>
            
        <% } else { %>
            <div class="text-center py-5">
                <i class="fas fa-check-circle fa-4x text-success mb-3"></i>
                <h4>No Pending Claims</h4>
                <p class="text-muted">All your claims have been processed or you have no submitted claims.</p>
                <a href="bills?patientId=${patientId}" class="btn btn-primary mt-3">
                    <i class="fas fa-list me-2"></i>View All Bills
                </a>
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>