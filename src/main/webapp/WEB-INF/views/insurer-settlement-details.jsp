<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.example.demo.bean.Settlement" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Settlement Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 900px; margin: 30px auto; padding: 0 20px; }
        .details-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); }
        .amount-box { background: #f8f9fa; border-radius: 10px; padding: 20px; margin: 15px 0; border: 1px solid #dee2e6; }
        .breakdown-box { background: #fff; border-radius: 8px; padding: 15px; margin: 10px 0; border-left: 4px solid #007bff; }
    </style>
</head>
<body>
    <div class="container-custom">
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2><i class="fas fa-file-invoice-dollar me-2"></i>Settlement Details</h2>
            <a href="processed" class="btn btn-outline-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Processed Claims
            </a>
        </div>
        
        <% 
            Settlement settlement = (Settlement) request.getAttribute("settlement");
            if (settlement != null) {
        %>
            <div class="details-card">
                <!-- Summary -->
                <div class="amount-box">
                    <h4 class="text-center mb-4">Claim Settlement Summary</h4>
                    <div class="row text-center">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <div class="text-muted">Total Billed Amount</div>
                                <div class="h3 text-primary">$<%= String.format("%.2f", settlement.getBilledAmount()) %></div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <div class="text-muted">Patient Responsibility</div>
                                <div class="h3 text-danger">$<%= String.format("%.2f", settlement.getTotalPatientResponsibility()) %></div>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Claim Info -->
                <div class="row mb-4">
                    <div class="col-md-4">
                        <p><strong>Claim ID:</strong> HC-<%= settlement.getClaimId() %></p>
                    </div>
                    <div class="col-md-4">
                        <p><strong>Patient ID:</strong> PT-<%= settlement.getPatientId() %></p>
                    </div>
                    <div class="col-md-4">
                        <p><strong>Provider ID:</strong> PR-<%= settlement.getProviderId() %></p>
                    </div>
                </div>
                
                <!-- Patient Responsibility Breakdown -->
                <h5 class="mb-3"><i class="fas fa-user me-2"></i>Patient Responsibility Breakdown</h5>
                
                <!-- Primary Insurance -->
                <% if (settlement.getPrimaryPlanId() != null) { %>
                    <div class="breakdown-box">
                        <h6 class="text-primary">Primary Insurance</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Copay:</strong> $<%= String.format("%.2f", settlement.getPrimaryCopay()) %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Deductible Applied:</strong> $<%= String.format("%.2f", settlement.getPrimaryDeductibleApplied()) %></p>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <!-- Secondary Insurance -->
                <% if (settlement.getSecondaryPlanId() != null) { %>
                    <div class="breakdown-box">
                        <h6 class="text-info">Secondary Insurance</h6>
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Copay:</strong> $<%= String.format("%.2f", settlement.getSecondaryCopay()) %></p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1"><strong>Deductible Applied:</strong> $<%= String.format("%.2f", settlement.getSecondaryDeductibleApplied()) %></p>
                            </div>
                        </div>
                    </div>
                <% } %>
                
                <!-- Coinsurance -->
                <div class="breakdown-box">
                    <h6 class="text-warning">Coinsurance</h6>
                    <p class="mb-0"><strong>Patient Coinsurance:</strong> $<%= String.format("%.2f", settlement.getCoinsuranceAmount()) %></p>
                </div>
                
                <!-- Insurance Payments -->
                <h5 class="mt-4 mb-3"><i class="fas fa-building me-2"></i>Insurance Payments</h5>
                <div class="row">
                    <% if (settlement.getPrimaryPlanId() != null) { %>
                        <div class="col-md-6">
                            <div class="amount-box">
                                <h6 class="text-primary">Primary Insurance</h6>
                                <div class="h4">$<%= String.format("%.2f", settlement.getPrimaryInsurancePaid()) %></div>
                                <small class="text-muted">Paid by primary insurer</small>
                            </div>
                        </div>
                    <% } %>
                    
                    <% if (settlement.getSecondaryPlanId() != null) { %>
                        <div class="col-md-6">
                            <div class="amount-box">
                                <h6 class="text-info">Secondary Insurance</h6>
                                <div class="h4">$<%= String.format("%.2f", settlement.getSecondaryInsurancePaid()) %></div>
                                <small class="text-muted">Paid by secondary insurer</small>
                            </div>
                        </div>
                    <% } %>
                </div>
                
                <!-- Totals -->
                <div class="amount-box mt-4">
                    <h5>Summary</h5>
                    <table class="table table-borderless">
                        <tr>
                            <td><strong>Total Billed:</strong></td>
                            <td class="text-end">$<%= String.format("%.2f", settlement.getBilledAmount()) %></td>
                        </tr>
                        <tr>
                            <td><strong>Total Insurance Paid:</strong></td>
                            <td class="text-end text-success">$<%= String.format("%.2f", settlement.getPrimaryInsurancePaid() + settlement.getSecondaryInsurancePaid()) %></td>
                        </tr>
                        <tr>
                            <td><strong>Total Patient Responsibility:</strong></td>
                            <td class="text-end text-danger">$<%= String.format("%.2f", settlement.getTotalPatientResponsibility()) %></td>
                        </tr>
                    </table>
                </div>
                
                <!-- Footer -->
                <div class="mt-4 pt-3 border-top text-muted small">
                    <p class="mb-1"><strong>Processed Date:</strong> <%= settlement.getProcessedDate() %></p>
                    <p class="mb-0"><strong>Settlement ID:</strong> STL-<%= settlement.getSettlementId() %></p>
                </div>
            </div>
        <% } else { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle me-2"></i>
                Settlement details not found.
            </div>
        <% } %>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>