<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Patient Claims</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .search-container { 
            max-width: 600px; 
            margin: 50px auto; 
            padding: 30px; 
            border-radius: 10px; 
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); 
            background-color: #fff; 
        }
        .result-box { 
            min-height: 150px; 
            border: 1px dashed #ccc; 
            border-radius: 8px; 
            padding: 20px; 
            margin-top: 20px; 
            background-color: #f9f9f9; 
            text-align: left;
        }
        .error-message { 
            color: #e74c3c; 
            font-weight: bold; 
        }
        .spinner-border { 
            margin-right: 10px; 
        }
        .text-center-placeholder {
            text-align: center;
        }
        .patient-details {
             padding: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="search-container">
            <h2 class="mb-4 text-center"><i class="fas fa-search me-2"></i>Patient Quick Search</h2>
            
            <form id="patientSearchForm" onsubmit="searchPatientDetails(event)">
                <div class="mb-3">
                    <label for="patientId" class="form-label">Enter Patient ID</label>
                    <input type="number" class="form-control" id="patientId" name="patientId" required placeholder="e.g., 1001">
                </div>
                <button type="submit" class="btn btn-primary w-100">
                    <i class="fas fa-search me-1"></i> Quick View Details
                </button>
                <div id="loadingIndicator" class="mt-3 text-center d-none">
                    <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                    Fetching details...
                </div>
            </form>

            <div id="resultDiv" class="result-box text-center-placeholder text-muted">
                Enter a Patient ID above to see quick details.
            </div>

            <div class="mt-4 text-center">
                <a href="<c:url value="/provider/welcome"/>" class="btn btn-sm btn-outline-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Back to Dashboard
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        const resultDiv = document.getElementById("resultDiv");
        const patientIdInput = document.getElementById("patientId");
        const loadingIndicator = document.getElementById("loadingIndicator");

        function searchPatientDetails(event) {
            event.preventDefault();
            const patientId = patientIdInput.value;
            resultDiv.innerHTML = "";
            loadingIndicator.classList.remove("d-none");

            fetch('/provider/api/patientDetails?patientId=' + patientId)
                .then(response => {
                    loadingIndicator.classList.add("d-none");
                    if (!response.ok) {
                        return response.text().then(text => { 
                            try {
                                const errorJson = JSON.parse(text);
                                throw new Error(errorJson.message || "Patient not found or server error.");
                            } catch (e) {
                                throw new Error(text || response.statusText);
                            }
                        });
                    }
                    return response.json();
                })
                .then(data => {
                    displayPatientDetails(data);
                })
                .catch(error => {
                    console.error("Fetch error:", error);
                    resultDiv.innerHTML = '<div class="error-message text-center"><i class="fas fa-exclamation-triangle me-2"></i>' + error.message + '</div>';
                });
        }
        
        function displayPatientDetails(patientData) {
            // 1. Status Counts HTML
            let statusHtml = "";
            if (patientData.statusCounts && Object.keys(patientData.statusCounts).length > 0) {
                const statusBadges = Object.entries(patientData.statusCounts).map(function([status, count]) {
                    let badgeClass;
                    switch (status) {
                        case "Approved":
                            badgeClass = "bg-success";
                            break;
                        case "Processed":
                            badgeClass = "bg-warning text-dark";
                            break;
                        case "Submitted":
                            badgeClass = "bg-info text-dark";
                            break;
                        default:
                            badgeClass = "bg-secondary";
                    }
                    return '<span class="badge ' + badgeClass + ' p-2">' + status + ': ' + count + '</span>';
                }).join("");

                statusHtml = '<div class="mt-3">' +
                    '<strong><i class="fas fa-chart-pie me-2"></i>Claims by Status:</strong>' +
                    '<div class="d-flex flex-wrap gap-2 mt-2">' +
                    statusBadges +
                    '</div>' +
                    '</div>';
            }
            
            // 2. Recent Claims HTML
            let recentClaimsHtml = "";
            if (patientData.recentClaims && patientData.recentClaims.length > 0) {
                const claimListItems = patientData.recentClaims.map(function(claim) {
                    let statusClass;
                    switch (claim.status) {
                        case "Approved":
                            statusClass = "bg-success";
                            break;
                        case "Processed":
                            statusClass = "bg-warning text-dark";
                            break;
                        default:
                            statusClass = "bg-info text-dark";
                    }
                    return '<div class="list-group-item">' +
                        '<div class="d-flex justify-content-between">' +
                        '<span>Claim #' + claim.claimId + '</span>' +
                        '<span class="badge ' + statusClass + '">' + claim.status + '</span>' +
                        '</div>' +
                        '<small class="text-muted">' +
                        claim.claimDate + ' | $' + claim.billedAmount + ' | Diagnosis: ' + (claim.diagnosisCode || "N/A") +
                        '</small>' +
                        '</div>';
                }).join("");

                recentClaimsHtml = '<div class="mt-3">' +
                    '<strong><i class="fas fa-history me-2"></i>Recent Claims:</strong>' +
                    '<div class="list-group mt-2">' +
                    claimListItems +
                    '</div>' +
                    '</div>';
            }
            
            // 3. Final Details HTML
            const totalBilled = (patientData.totalBilledAmount || 0).toFixed(2);

            const detailsHtml = '<div class="patient-details">' +
                '<h5 class="text-success mb-3">' +
                '<i class="fas fa-user me-2"></i>' + (patientData.fullName || "N/A") + ' (ID: ' + patientData.patientId + ')' +
                '</h5>' +
                '<div class="row">' +
                '<div class="col-md-6">' +
                '<div class="mb-2"><strong><i class="fas fa-id-card me-2"></i>Member ID:</strong> ' + (patientData.memberId || "N/A") + '</div>' +
                '<div class="mb-2"><strong><i class="fas fa-calendar me-2"></i>Date of Birth:</strong> ' + (patientData.formattedDob || "N/A") + '</div>' +
                '<div class="mb-2"><strong><i class="fas fa-venus-mars me-2"></i>Gender:</strong> ' + (patientData.gender || "N/A") + '</div>' +
                '<div class="mb-2"><strong><i class="fas fa-phone me-2"></i>Contact:</strong> ' + (patientData.contactNumber || "N/A") + '</div>' +
                '</div>' +
                '<div class="col-md-6">' +
                '<div class="mb-2"><strong><i class="fas fa-file-medical me-2"></i>Total Claims:</strong> ' + (patientData.totalClaims || 0) + '</div>' +
                '<div class="mb-2"><strong><i class="fas fa-dollar-sign me-2"></i>Total Billed:</strong> $' + totalBilled + '</div>' +
                '</div>' +
                '</div>' +
                statusHtml +
                recentClaimsHtml +
                '<div class="mt-3">' +
                '<form method="post" action="/provider/searchpatient">' +
                '<input type="hidden" name="patientId" value="' + patientData.patientId + '">' +
                '<button type="submit" class="btn btn-sm btn-primary">' +
                '<i class="fas fa-external-link-alt me-1"></i> View All Claims (Full List)' +
                '</button>' +
                '</form>' +
                '</div>' +
                '</div>';
            
            resultDiv.innerHTML = detailsHtml;
        }
    </script>
</body>
</html>