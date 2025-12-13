<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Claim Submitted Successfully</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .success-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .success-header {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        .info-badge {
            background: rgba(255,255,255,0.2);
            border-radius: 50px;
            padding: 8px 20px;
            font-size: 0.9rem;
        }
        .claim-details {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
        }
        .next-steps li {
            margin-bottom: 10px;
            padding-left: 25px;
            position: relative;
        }
        .next-steps li:before {
            content: "✓";
            position: absolute;
            left: 0;
            color: #28a745;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-light bg-light">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-hospital-alt text-success me-2"></i>
                <span class="fw-bold">Claim Submission Successful</span>
            </a>
        </div>
    </nav>

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card success-card">
                    <!-- Success Header -->
                    <div class="success-header">
                        <div class="mb-4">
                            <i class="fas fa-check-circle fa-5x"></i>
                        </div>
                        <h1 class="display-6 fw-bold">Claim Submitted Successfully!</h1>
                        <p class="lead mb-0">Your claim has been received and is being processed.</p>
                        <div class="mt-3">
                            <span class="info-badge">
                                <i class="fas fa-clock me-1"></i>Submitted: Just now
                            </span>
                        </div>
                    </div>

                    <div class="card-body p-4">
                        <!-- Success Message -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Claim Details -->
                        <div class="claim-details mb-4">
                            <h4 class="mb-4">
                                <i class="fas fa-file-invoice me-2"></i>Claim Information
                            </h4>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light p-2 rounded me-3">
                                            <i class="fas fa-hashtag text-primary"></i>
                                        </div>
                                        <div>
                                            <small class="text-muted d-block">Claim ID</small>
                                            <h5 class="mb-0 fw-bold">#${claimId}</h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light p-2 rounded me-3">
                                            <i class="fas fa-user text-info"></i>
                                        </div>
                                        <div>
                                            <small class="text-muted d-block">Patient ID</small>
                                            <h5 class="mb-0 fw-bold">${patientId}</h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light p-2 rounded me-3">
                                            <i class="fas fa-dollar-sign text-success"></i>
                                        </div>
                                        <div>
                                            <small class="text-muted d-block">Billed Amount</small>
                                            <h5 class="mb-0 fw-bold">
                                                $<fmt:formatNumber value="${billedAmount}" pattern="#,##0.00"/>
                                            </h5>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <div class="d-flex align-items-center">
                                        <div class="bg-light p-2 rounded me-3">
                                            <i class="fas fa-user-md text-warning"></i>
                                        </div>
                                        <div>
                                            <small class="text-muted d-block">Provider</small>
                                            <h5 class="mb-0 fw-bold">${provider.name}</h5>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="alert alert-info mt-3">
                                <div class="d-flex">
                                    <i class="fas fa-info-circle fa-lg mt-1 me-3"></i>
                                    <div>
                                        <strong>What happens next?</strong>
                                        <p class="mb-0 small">
                                            This claim has been assigned to insurers based on the patient's coverage. 
                                            You can track its progress in the "View Claims" section.
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Next Steps -->
                        <div class="mb-5">
                            <h4 class="mb-3">
                                <i class="fas fa-list-ol me-2"></i>Next Steps
                            </h4>
                            <ul class="next-steps">
                                <li>Claim has been assigned to primary insurer</li>
                                <li>Insurers will review and process the claim</li>
                                <li>You will be notified of any updates</li>
                                <li>Patient responsibility will be calculated</li>
                                <li>Payment will be processed once approved</li>
                            </ul>
                        </div>

                        <!-- Action Buttons -->
                        <div class="row g-3">
                            <div class="col-md-4">
                                <a href="/provider/submitclaim?providerId=${providerId}" 
                                   class="btn btn-outline-primary w-100 h-100 py-3">
                                    <i class="fas fa-plus fa-lg me-2"></i>
                                    <div>Submit Another Claim</div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="/provider/viewclaim?claimId=${claimId}&providerId=${providerId}" 
                                   class="btn btn-info w-100 h-100 py-3">
                                    <i class="fas fa-eye fa-lg me-2"></i>
                                    <div>View This Claim</div>
                                </a>
                            </div>
                            <div class="col-md-4">
                                <a href="/provider/viewclaims?providerId=${providerId}" 
                                   class="btn btn-success w-100 h-100 py-3">
                                    <i class="fas fa-list fa-lg me-2"></i>
                                    <div>View All Claims</div>
                                </a>
                            </div>
                        </div>

                        <!-- Return to Dashboard -->
                        <div class="text-center mt-4">
                            <a href="/provider/welcome?providerId=${providerId}" 
                               class="btn btn-outline-secondary">
                                <i class="fas fa-home me-2"></i>Return to Dashboard
                            </a>
                        </div>
                    </div>

                    <!-- Footer -->
                    <div class="card-footer bg-light text-center py-3">
                        <small class="text-muted">
                            <i class="fas fa-shield-alt me-1"></i>
                            Claim submitted securely | 
                            <i class="fas fa-clock ms-3 me-1"></i>
                            <span id="timestamp"></span>
                        </small>
                    </div>
                </div>

                <!-- Support Information -->
                <div class="card mt-4 border-info">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h5 class="mb-2">
                                    <i class="fas fa-headset me-2 text-info"></i>Need Help?
                                </h5>
                                <p class="mb-0 text-muted">
                                    If you have questions about this claim or need assistance, 
                                    contact our provider support team.
                                </p>
                            </div>
                            <div class="col-md-4 text-end">
                                <button class="btn btn-outline-info">
                                    <i class="fas fa-phone me-2"></i>Contact Support
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set current timestamp
        document.addEventListener('DOMContentLoaded', function() {
            const now = new Date();
            const options = { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit'
            };
            document.getElementById('timestamp').textContent = 
                now.toLocaleDateString('en-US', options);
        });
    </script>
</body>
</html>