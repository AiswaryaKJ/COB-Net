<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit New Claim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .claim-form-card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
        }
        .form-header {
            background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
            color: white;
            border-radius: 15px 15px 0 0;
            padding: 20px;
        }
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.25rem rgba(0, 123, 255, 0.25);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-light mb-4 shadow-sm">
        <div class="container-fluid">
            <a class="navbar-brand" href="/provider/welcome?providerId=${providerId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
            <div class="navbar-text">
                <span class="badge bg-primary">
                    <i class="fas fa-user-md me-1"></i>${provider.name}
                </span>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card claim-form-card">
                    <div class="form-header">
                        <h3 class="mb-0">
                            <i class="fas fa-file-medical me-2"></i>Submit New Claim
                        </h3>
                        <p class="mb-0 mt-2 opacity-75">
                            Complete the form below to submit a new healthcare claim
                        </p>
                    </div>

                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <div class="alert alert-info mb-4">
                            <div class="row">
                                <div class="col-md-6">
                                    <strong><i class="fas fa-user-md me-2"></i>Provider:</strong>
                                    ${provider.name} (ID: ${providerId})
                                </div>
                                <div class="col-md-6">
                                    <strong><i class="fas fa-shield-alt me-2"></i>Network Status:</strong>
                                    <span class="badge ${provider.networkStatus == 'IN' ? 'bg-success' : 'bg-warning'}">
                                        ${provider.networkStatusBadge}
                                    </span>
                                </div>
                            </div>
                            <c:if test="${provider.networkStatus != 'IN'}">
                                <div class="mt-2 text-danger">
                                    <i class="fas fa-exclamation-circle me-1"></i>
                                    <strong>Note:</strong> You are out of network. Claims may be subject to different processing rules.
                                </div>
                            </c:if>
                        </div>

                        <form action="/provider/submitclaim?providerId=${providerId}" method="post">
                            <input type="hidden" name="provider.providerId" value="${providerId}">
                            
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="patient.patientId" class="form-label required-field">
                                        <i class="fas fa-user me-2"></i>Patient ID
                                    </label>
                                    <input type="number" 
                                           class="form-control ${not empty error and error.contains('Patient not found') ? 'is-invalid' : ''}" 
                                           id="patient.patientId" 
                                           name="patient.patientId" 
                                           value="${claim.patient.patientId}"
                                           required
                                           placeholder="Enter Patient ID">
                                    <div class="invalid-feedback">
                                        Please enter a valid Patient ID.
                                    </div>
                                    <small class="form-text text-muted">
                                        Enter the patient's unique identifier
                                    </small>
                                </div>

                                <div class="col-md-6">
                                    <label for="billedAmount" class="form-label required-field">
                                        <i class="fas fa-dollar-sign me-2"></i>Billed Amount ($)
                                    </label>
                                    <div class="input-group">
                                        <span class="input-group-text">$</span>
                                        <input type="number" 
                                               step="0.01" 
                                               min="0.01"
                                               class="form-control" 
                                               id="billedAmount" 
                                               name="billedAmount" 
                                               value="${claim.billedAmount}"
                                               required
                                               placeholder="0.00">
                                    </div>
                                    <small class="form-text text-muted">
                                        Enter the total amount billed
                                    </small>
                                </div>

                                <div class="col-md-6">
                                    <label for="diagnosisCode" class="form-label">
                                        <i class="fas fa-stethoscope me-2"></i>Diagnosis Code (ICD-10)
                                    </label>
                                    <select class="form-select" id="diagnosisCode" name="diagnosisCode">
                                        <option value="" disabled ${empty claim.diagnosisCode ? 'selected' : ''}>Select Diagnosis Code</option>
                                        <option value="J06.9" ${claim.diagnosisCode == 'J06.9' ? 'selected' : ''}>J06.9 - Acute upper respiratory infection, unspecified</option>
                                        <option value="I10" ${claim.diagnosisCode == 'I10' ? 'selected' : ''}>I10 - Essential (primary) hypertension</option>
                                        <option value="E11.9" ${claim.diagnosisCode == 'E11.9' ? 'selected' : ''}>E11.9 - Type 2 diabetes mellitus without complications</option>
                                        <option value="K21.9" ${claim.diagnosisCode == 'K21.9' ? 'selected' : ''}>K21.9 - Gastro-esophageal reflux disease without esophagitis</option>
                                        <option value="M54.5" ${claim.diagnosisCode == 'M54.5' ? 'selected' : ''}>M54.5 - Low back pain</option>
                                        <option value="Z00.00" ${claim.diagnosisCode == 'Z00.00' ? 'selected' : ''}>Z00.00 - Encounter for general examination without abnormal findings</option>
                                        <option value="G43.909" ${claim.diagnosisCode == 'G43.909' ? 'selected' : ''}>G43.909 - Migraine, unspecified, not intractable</option>
                                    </select>
                                    <small class="form-text text-muted">
                                        Optional: Select ICD-10 diagnosis code
                                    </small>
                                </div>

                                <div class="col-md-6">
                                    <label for="procedureCode" class="form-label">
                                        <i class="fas fa-procedures me-2"></i>Procedure Code (CPT)
                                    </label>
                                    <select class="form-select" id="procedureCode" name="procedureCode">
                                        <option value="" disabled ${empty claim.procedureCode ? 'selected' : ''}>Select Procedure Code</option>
                                        <option value="99213" ${claim.procedureCode == '99213' ? 'selected' : ''}>99213 - Established patient office visit, low complexity</option>
                                        <option value="99203" ${claim.procedureCode == '99203' ? 'selected' : ''}>99203 - New patient office visit, moderate complexity</option>
                                        <option value="G0439" ${claim.procedureCode == 'G0439' ? 'selected' : ''}>G0439 - Annual wellness visit</option>
                                        <option value="80053" ${claim.procedureCode == '80053' ? 'selected' : ''}>80053 - Comprehensive metabolic panel (CMP)</option>
                                        <option value="90471" ${claim.procedureCode == '90471' ? 'selected' : ''}>90471 - Immunization administration</option>
                                        <option value="71045" ${claim.procedureCode == '71045' ? 'selected' : ''}>71045 - Chest X-ray, single view</option>
                                        <option value="12001" ${claim.procedureCode == '12001' ? 'selected' : ''}>12001 - Simple repair of superficial wounds, 2.5 cm or less</option>
                                    </select>
                                    <small class="form-text text-muted">
                                        Optional: Select CPT procedure code
                                    </small>
                                </div>

                                <div class="col-md-6">
                                    <label for="claimDate" class="form-label required-field">
                                        <i class="fas fa-calendar me-2"></i>Claim Date
                                    </label>
                                    <input type="date" 
                                           class="form-control" 
                                           id="claimDate" 
                                           name="claimDate" 
                                           value="${claim.claimDate}"
                                           required>
                                    <small class="form-text text-muted">
                                        Date of service (defaults to today)
                                    </small>
                                </div>

                                <div class="col-12">
                                    <div class="alert alert-light border">
                                        <h6 class="mb-3">
                                            <i class="fas fa-info-circle me-2"></i>Insurance Information
                                        </h6>
                                        <div class="row">
                                            <div class="col-md-6">
                                                <p class="mb-1">
                                                    <strong>Primary Insurer:</strong>
                                                    <span class="text-muted">Will be automatically determined</span>
                                                </p>
                                            </div>
                                            <div class="col-md-6">
                                                <p class="mb-1">
                                                    <strong>Secondary Insurer:</strong>
                                                    <span class="text-muted">Will be automatically determined</span>
                                                </p>
                                            </div>
                                        </div>
                                        <small class="text-muted">
                                            <i class="fas fa-lightbulb me-1"></i>
                                            Insurers are automatically fetched from patient's coverage records
                                        </small>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <hr class="my-4">
                                    <div class="d-flex justify-content-between">
                                        <a href="/provider/welcome?providerId=${providerId}" 
                                           class="btn btn-outline-secondary">
                                            <i class="fas fa-times me-2"></i>Cancel
                                        </a>
                                        <div>
                                            <button type="reset" class="btn btn-outline-warning me-2">
                                                <i class="fas fa-redo me-2"></i>Clear Form
                                            </button>
                                            <button type="submit" class="btn btn-primary">
                                                <i class="fas fa-paper-plane me-2"></i>Submit Claim
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card mt-4 border-info">
                    <div class="card-header bg-info text-white">
                        <h6 class="mb-0">
                            <i class="fas fa-question-circle me-2"></i>Need Help?
                        </h6>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6><i class="fas fa-lightbulb me-2 text-warning"></i>Tips:</h6>
                                <ul class="small">
                                    <li>Ensure patient ID is correct before submitting</li>
                                    <li>Enter diagnosis and procedure codes for faster processing</li>
                                    <li>Claims are automatically assigned to insurers based on patient coverage</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <h6><i class="fas fa-phone me-2 text-primary"></i>Support:</h6>
                                <p class="small mb-1">Provider Support: 1-800-PROVIDER</p>
                                <p class="small mb-0">Email: provider-support@healthcare.com</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set today's date as default for claim date
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            const dateInput = document.getElementById('claimDate');
            
            if (!dateInput.value) {
                dateInput.value = today;
            }
            
            // Focus on first input field
            document.getElementById('patient.patientId').focus();
        });
    </script>
</body>
</html>