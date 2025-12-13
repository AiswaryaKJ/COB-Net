<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Claims</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .claims-table th {
            background-color: #f8f9fa;
            font-weight: 600;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 5px 10px;
            border-radius: 20px;
        }
        .status-submitted { background-color: #6c757d; color: white; }
        .status-processed { background-color: #17a2b8; color: white; }
        .status-approved { background-color: #28a745; color: white; }
        .status-denied { background-color: #dc3545; color: white; }
        .status-paid { background-color: #20c997; color: white; }
        .status-pending { background-color: #ffc107; color: black; }
        .action-buttons .btn { margin-right: 5px; }
        .search-box {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
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
                <span class="badge bg-primary">
                    <i class="fas fa-user-md me-1"></i>${provider.name}
                </span>
                <span class="badge bg-info ms-2">
                    Claims: ${claims.size()}
                </span>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- Success/Error Messages -->
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2><i class="fas fa-list-alt me-2"></i>Your Claims</h2>
                <p class="text-muted mb-0">
                    View and manage all claims submitted by ${provider.name}
                    <c:if test="${not empty searchType}">
                        | <span class="text-primary">${searchType}</span>
                    </c:if>
                </p>
            </div>
            <div>
                <a href="/provider/submitclaim?providerId=${providerId}" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>New Claim
                </a>
            </div>
        </div>

        <!-- Search Box -->
        <div class="search-box">
            <h5><i class="fas fa-search me-2"></i>Search Claims</h5>
            <form action="/provider/searchpatient?providerId=${providerId}" method="post" class="row g-3">
                <div class="col-md-8">
                    <label for="patientId" class="form-label">Search by Patient ID</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="number" 
                               class="form-control" 
                               id="patientId" 
                               name="patientId" 
                               placeholder="Enter Patient ID"
                               value="${searchedPatientId}">
                    </div>
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <div class="d-grid gap-2 d-md-flex">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search me-2"></i>Search
                        </button>
                        <c:if test="${not empty searchedPatientId}">
                            <a href="/provider/viewclaims?providerId=${providerId}" class="btn btn-outline-secondary">
                                <i class="fas fa-times me-2"></i>Clear
                            </a>
                        </c:if>
                    </div>
                </div>
            </form>
        </div>

        <!-- Claims Table -->
        <c:choose>
            <c:when test="${not empty claims and claims.size() > 0}">
                <div class="table-responsive">
                    <table class="table table-hover claims-table">
                        <thead>
                            <tr>
                                <th>Claim ID</th>
                                <th>Patient ID</th>
                                <th>Billed Amount</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Primary Insurer</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="claim" items="${claims}">
                                <tr>
                                    <td>
                                        <strong>#${claim.claimId}</strong>
                                    </td>
                                    <td>
                                        <i class="fas fa-user me-1 text-muted"></i>
                                        ${claim.patient.patientId}
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark">
                                            $<fmt:formatNumber value="${claim.billedAmount}" pattern="#,##0.00"/>
                                        </span>
                                    </td>
                                    <td>
<td>${claim.claimDate}</td>                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${claim.status == 'Submitted'}">
                                                <span class="status-badge status-submitted">Submitted</span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Processed'}">
                                                <span class="status-badge status-processed">Processed</span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Approved'}">
                                                <span class="status-badge status-approved">Approved</span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Denied'}">
                                                <span class="status-badge status-denied">Denied</span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Paid'}">
                                                <span class="status-badge status-paid">Paid</span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Pending'}">
                                                <span class="status-badge status-pending">Pending</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge bg-secondary">${claim.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${claim.primaryInsurer != null}">
                                                <small>${claim.primaryInsurer.payerName}</small>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="action-buttons">
                                        <!-- View Button -->
                                        <a href="/provider/viewclaim?claimId=${claim.claimId}&providerId=${providerId}" 
                                           class="btn btn-sm btn-info" 
                                           title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        
                                        <!-- Delete Button (only for Submitted claims) -->
                                        <c:if test="${claim.status == 'Submitted'}">
                                            <form action="/provider/deleteclaim?providerId=${providerId}" 
                                                  method="POST" 
                                                  style="display:inline;"
                                                  onsubmit="return confirmDelete(${claim.claimId})">
                                                <input type="hidden" name="claimId" value="${claim.claimId}">
                                                <button type="submit" 
                                                        class="btn btn-sm btn-danger" 
                                                        title="Delete Claim">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </c:if>
                                        <c:if test="${claim.status != 'Submitted'}">
                                            <button class="btn btn-sm btn-secondary" disabled title="Cannot delete processed claims">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Summary -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h6><i class="fas fa-chart-pie me-2"></i>Claim Summary</h6>
                                <div class="row mt-3">
                                    <c:forEach var="statusCount" items="<%=new String[]{\"Submitted\", \"Processed\", \"Approved\", \"Denied\", \"Paid\"}%>">
                                        <div class="col-6 col-md-4 mb-2">
                                            <c:set var="count" value="0" />
                                            <c:forEach var="claim" items="${claims}">
                                                <c:if test="${claim.status == statusCount}">
                                                    <c:set var="count" value="${count + 1}" />
                                                </c:if>
                                            </c:forEach>
                                            <small class="text-muted">${statusCount}:</small>
                                            <br><strong>${count}</strong>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-body">
                                <h6><i class="fas fa-dollar-sign me-2"></i>Financial Summary</h6>
                                <div class="row mt-3">
                                    <div class="col-6">
                                        <small class="text-muted">Total Billed:</small>
                                        <br>
                                        <strong>
                                            $<fmt:formatNumber value="${claims.stream().map(c -> c.billedAmount).sum()}" pattern="#,##0.00"/>
                                        </strong>
                                    </div>
                                    <div class="col-6">
                                        <small class="text-muted">Total Claims:</small>
                                        <br><strong>${claims.size()}</strong>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- No Claims Found -->
                <div class="text-center py-5">
                    <div class="mb-4">
                        <i class="fas fa-inbox fa-4x text-muted"></i>
                    </div>
                    <h4 class="text-muted">No Claims Found</h4>
                    <p class="text-muted mb-4">
                        <c:choose>
                            <c:when test="${not empty searchType}">
                                No claims found for ${searchType.toLowerCase()}.
                            </c:when>
                            <c:otherwise>
                                You haven't submitted any claims yet.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <a href="/provider/submitclaim?providerId=${providerId}" class="btn btn-primary">
                        <i class="fas fa-plus me-2"></i>Submit Your First Claim
                    </a>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Quick Links -->
        <div class="mt-4 pt-3 border-top">
            <div class="d-flex justify-content-between">
                <div>
                    <a href="/provider/welcome?providerId=${providerId}" class="btn btn-outline-secondary">
                        <i class="fas fa-home me-2"></i>Back to Dashboard
                    </a>
                </div>
                <div>
                    <span class="text-muted">
                        <i class="fas fa-info-circle me-1"></i>
                        Showing claims for Provider ID: ${providerId}
                    </span>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(claimId) {
            return confirm('Are you sure you want to delete Claim #' + claimId + '?\n\nNote: Only claims with "Submitted" status can be deleted.');
        }
        
        // Auto-focus search input
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.getElementById('patientId');
            if (searchInput) {
                searchInput.focus();
            }
        });
    </script>
</body>
</html>