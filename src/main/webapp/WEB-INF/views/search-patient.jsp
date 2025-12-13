<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search by Patient</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .search-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .search-header {
            background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 25px;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm mb-4">
        <div class="container-fluid">
            <a class="navbar-brand" href="/provider/welcome?providerId=${providerId}">
                <i class="fas fa-arrow-left me-2"></i>Provider Dashboard
            </a>
            <div class="navbar-text">
                <span class="badge bg-info">
                    <i class="fas fa-user-md me-1"></i>${provider.name}
                </span>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card search-card">
                    <!-- Header -->
                    <div class="search-header">
                        <h3 class="mb-2">
                            <i class="fas fa-search me-2"></i>Search Claims by Patient
                        </h3>
                        <p class="mb-0 opacity-75">
                            Find claims for a specific patient
                        </p>
                    </div>

                    <div class="card-body p-4">
                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show mb-4">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Provider Info -->
                        <div class="alert alert-light mb-4">
                            <div class="d-flex align-items-center">
                                <i class="fas fa-info-circle fa-lg text-info me-3"></i>
                                <div>
                                    <strong>Search Scope:</strong> 
                                    You are searching for claims submitted by 
                                    <strong>${provider.name}</strong> (ID: ${providerId}) only.
                                    <br>
                                    <small class="text-muted">
                                        Results will show only your claims for the specified patient.
                                    </small>
                                </div>
                            </div>
                        </div>

                        <!-- Search Form -->
                        <form action="/provider/searchpatient?providerId=${providerId}" method="post">
                            <div class="mb-4">
                                <label for="patientId" class="form-label fw-bold">
                                    <i class="fas fa-user me-2"></i>Enter Patient ID
                                </label>
                                <div class="input-group input-group-lg">
                                    <span class="input-group-text bg-light">
                                        <i class="fas fa-id-card"></i>
                                    </span>
                                    <input type="number" 
                                           class="form-control form-control-lg" 
                                           id="patientId" 
                                           name="patientId" 
                                           placeholder="Enter Patient ID (e.g., 1001)"
                                           required
                                           autofocus>
                                </div>
                                <div class="form-text mt-2">
                                    <i class="fas fa-lightbulb me-1 text-warning"></i>
                                    Enter the patient's unique identifier to search for their claims.
                                </div>
                            </div>

                            <!-- Form Buttons -->
                            <div class="d-flex justify-content-between">
                                <a href="/provider/viewclaims?providerId=${providerId}" 
                                   class="btn btn-outline-secondary">
                                    <i class="fas fa-list me-2"></i>View All Claims
                                </a>
                                <div>
                                    <button type="reset" class="btn btn-outline-warning me-2">
                                        <i class="fas fa-redo me-2"></i>Clear
                                    </button>
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-search me-2"></i>Search Claims
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Help Section -->
                <div class="card mt-4 border-light">
                    <div class="card-body">
                        <h5 class="card-title">
                            <i class="fas fa-question-circle me-2 text-primary"></i>How to Use This Search
                        </h5>
                        <div class="row mt-3">
                            <div class="col-md-6">
                                <h6><i class="fas fa-check-circle me-2 text-success"></i>What You Can Do:</h6>
                                <ul class="small">
                                    <li>Search for claims by patient ID</li>
                                    <li>View all claims you submitted for a patient</li>
                                    <li>See claim status and details</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-exclamation-circle me-2 text-warning"></i>Limitations:</h6>
                                <ul class="small">
                                    <li>Only shows claims submitted by you</li>
                                    <li>Cannot view claims from other providers</li>
                                    <li>Patient ID must be exact match</li>
                                </ul>
                            </div>
                        </div>
                        <div class="mt-3 p-3 bg-light rounded">
                            <h6><i class="fas fa-lightbulb me-2 text-info"></i>Tip:</h6>
                            <p class="mb-0 small">
                                Need to see all patients? Use the "View All Claims" button to see 
                                all claims you've submitted regardless of patient.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Quick Links -->
                <div class="mt-4">
                    <div class="d-grid gap-2 d-md-flex justify-content-center">
                        <a href="/provider/submitclaim?providerId=${providerId}" 
                           class="btn btn-success">
                            <i class="fas fa-plus me-2"></i>Submit New Claim
                        </a>
                        <a href="/provider/welcome?providerId=${providerId}" 
                           class="btn btn-outline-primary">
                            <i class="fas fa-home me-2"></i>Back to Dashboard
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>