<%-- admin.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>COBNet Admin Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <style>
        /* Simplified styles - removed complex properties that might cause issues */
        body { 
            font-family: Arial, sans-serif; 
            padding: 20px; 
            background: #f5f5f5; 
            margin: 0;
        }
        
        .container { 
            max-width: 1400px; 
            margin: 0 auto; 
        }
        
        .header { 
            background: #1a365d;
            color: white; 
            padding: 25px; 
            border-radius: 10px; 
            margin-bottom: 30px;
        }
        
        .header h1 { 
            margin: 0; 
            margin-bottom: 10px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        @media (max-width: 1200px) {
            .stats-grid { grid-template-columns: repeat(3, 1fr); }
        }
        
        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
        
        @media (max-width: 480px) {
            .stats-grid { grid-template-columns: 1fr; }
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            text-align: center;
            border-top: 4px solid;
        }
        
        .stat-card.submitted { border-top-color: #8b5cf6; }
        .stat-card.processed { border-top-color: #3b82f6; }
        .stat-card.approved { border-top-color: #10b981; }
        .stat-card.denied { border-top-color: #ef4444; }
        .stat-card.pending { border-top-color: #f59e0b; }
        
        .stat-value {
            font-size: 32px;
            font-weight: bold;
            margin: 10px 0;
            color: #1a365d;
        }
        
        .stat-label {
            color: #666;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 14px;
        }
        
        .section {
            background: white;
            padding: 25px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #1a365d;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            text-decoration: none;
            font-size: 14px;
        }
        
        .btn-primary {
            background: #1a365d;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2d5aa0;
        }
        
        .btn-success {
            background: #10b981;
            color: white;
        }
        
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        
        .btn-danger {
            background: #ef4444;
            color: white;
        }
        
        .btn-secondary { /* Ensure secondary button style is defined */
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .btn-sm {
            padding: 6px 12px;
            font-size: 14px;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        th {
            background: #2c3e50;
            color: white;
            padding: 12px;
            text-align: left;
            border: 1px solid #ddd;
        }
        
        td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: left;
        }
        
        tr:hover {
            background-color: #f5f5f5;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-submitted { background: #e3f2fd; color: #1976d2; }
        .status-processed { background: #fff3e0; color: #f57c00; }
        .status-approved { background: #e8f5e9; color: #388e3c; }
        .status-denied { background: #ffebee; color: #d32f2f; }
        
        /* Modal Styles */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        
        .modal-content {
            background: white;
            padding: 30px;
            border-radius: 10px;
            width: 90%;
            max-width: 500px;
        }
        
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #666;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }
        
        .form-control {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            box-sizing: border-box;
        }
        
        .refresh-btn {
            background: #10b981;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            margin-top: 10px;
        }
        
        .message {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .error-message {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .success-message {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><i class="fas fa-handshake"></i> COBNet Admin Dashboard</h1>
            <p>Real-time Claims & Provider Management</p>
            <button class="refresh-btn" onclick="refreshClaimsData()">
                <i class="fas fa-sync-alt"></i> Refresh Data
            </button>
        </div>
        
        <c:if test="${not empty error}">
            <div class="message error-message">
                <strong>Error:</strong> ${error}
            </div>
        </c:if>
        
        <c:if test="${not empty success}">
            <div class="message success-message">
                <strong>Success:</strong> ${success}
            </div>
        </c:if>
        
        <div class="stats-grid">
            <div class="stat-card submitted">
                <div class="stat-label">Submitted</div>
                <div class="stat-value" id="submittedCount">
                    <c:out value="${submittedClaims != null ? submittedClaims : 0}" />
                </div>
                <div>Claims</div>
            </div>
            <div class="stat-card processed">
                <div class="stat-label">Processed</div>
                <div class="stat-value" id="processedCount">
                    <c:out value="${processedClaims != null ? processedClaims : 0}" />
                </div>
                <div>Claims</div>
            </div>
            <div class="stat-card approved">
                <div class="stat-label">Approved</div>
                <div class="stat-value" id="approvedCount">
                    <c:out value="${approvedClaims != null ? approvedClaims : 0}" />
                </div>
                <div>Claims</div>
            </div>
            <div class="stat-card denied">
                <div class="stat-label">Denied</div>
                <div class="stat-value" id="deniedCount">
                    <c:out value="${deniedClaims != null ? deniedClaims : 0}" />
                </div>
                <div>Claims</div>
            </div>
            <div class="stat-card pending">
                <div class="stat-label">Pending</div>
                <div class="stat-value" id="pendingCount">
                    <c:out value="${pendingClaims != null ? pendingClaims : 0}" />
                </div>
                <div>Claims</div>
            </div>
        </div>
        
        <div class="section">
            <div class="section-header">
                <div class="section-title">
                    <i class="fas fa-file-medical"></i>
                    Claims Overview
                </div>
               
            </div>
            
            <c:choose>
                <c:when test="${not empty claims}">
                    <table>
                        <thead>
                            <tr>
                                <th>Claim ID</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Billed Amount</th>
                                <th>Patient ID</th>
                                <th>Provider ID</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="claim" items="${claims}">
                                <tr>
                                    <td><strong>#<c:out value="${claim.claimId}" /></strong></td>
                                    <td><c:out value="${claim.claimDate}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${claim.status == 'Submitted'}">
                                                <span class="status-badge status-submitted">
                                                    <i class="fas fa-paper-plane"></i> Submitted
                                                </span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Processed'}">
                                                <span class="status-badge status-processed">
                                                    <i class="fas fa-cogs"></i> Processed
                                                </span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Approved'}">
                                                <span class="status-badge status-approved">
                                                    <i class="fas fa-check-circle"></i> Approved
                                                </span>
                                            </c:when>
                                            <c:when test="${claim.status == 'Denied'}">
                                                <span class="status-badge status-denied">
                                                    <i class="fas fa-times-circle"></i> Denied
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="status-badge">
                                                    <i class="fas fa-clock"></i> <c:out value="${claim.status}" />
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><strong>$<c:out value="${claim.billedAmount}" /></strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${claim.patient != null}">
                                                <c:out value="${claim.patient.patientId}" />
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${claim.provider != null}">
                                                <c:out value="${claim.provider.providerId}" />
                                            </c:when>
                                            <c:otherwise>
                                                N/A
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 40px; color: #666;">
                        <i class="fas fa-file-medical" style="font-size: 48px; margin-bottom: 15px;"></i>
                        <h3>No Claims Found</h3>
                        <p>Claims will appear here once they are submitted</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        
        <div class="section">
            <div class="section-header">
                <div class="section-title">
                    <i class="fas fa-user-md"></i>
                    Healthcare Providers Management
                </div>
                <button class="btn btn-primary" onclick="openAddProviderModal()">
                    <i class="fas fa-plus"></i> Add New Provider
                </button>
            </div>
            
            <c:choose>
                <c:when test="${not empty providers}">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Specialty</th>
                                <th>NPI</th>
                                <th>Network Status</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="provider" items="${providers}">
                                <tr>
                                    <td><strong>#<c:out value="${provider.providerId}" /></strong></td>
                                    <td><c:out value="${provider.name}" /></td>
                                    <td><c:out value="${provider.specialty}" /></td>
                                    <td><code><c:out value="${provider.npi}" /></code></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${provider.networkStatus == 'IN'}">
                                                <span style="color: #10b981; font-weight: 600;">
                                                    <i class="fas fa-check-circle"></i> In-Network
                                                </span>
                                            </c:when>
                                            <c:when test="${provider.networkStatus == 'OUT'}">
                                                <span style="color: #ef4444; font-weight: 600;">
                                                    <i class="fas fa-times-circle"></i> Out-of-Network
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${provider.networkStatus}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${provider.isActive == 1}">
                                                <span style="color: #10b981; font-weight: 600;">
                                                    <i class="fas fa-check-circle"></i> Active
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #757575; font-weight: 600;">
                                                    <i class="fas fa-minus-circle"></i> Inactive
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <div class="action-buttons">
                                            <button class="btn btn-warning btn-sm" 
                                                    onclick="openEditProviderModal(
                                                        ${provider.providerId}, 
                                                        '${provider.name}', 
                                                        '${provider.specialty}', 
                                                        '${provider.npi}', 
                                                        '${provider.networkStatus}'
                                                    )">
                                                <i class="fas fa-edit"></i> Edit
                                            </button>
                                            <c:if test="${provider.isActive == 1}">
                                                <a href="/admin/delete/${provider.providerId}" 
                                                   class="btn btn-secondary btn-sm"
                                                   onclick="return confirm('Are you sure you want to set ${provider.name} status to Inactive?')">
                                                    <i class="fas fa-user-slash"></i> Inactive
                                                </a>
                                            </c:if>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 40px; color: #666;">
                        <i class="fas fa-user-md" style="font-size: 48px; margin-bottom: 15px;"></i>
                        <h3>No Providers Found</h3>
                        <p>Add your first healthcare provider to get started</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    
    <div id="addProviderModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-user-plus"></i> Add New Provider</h3>
                <button class="modal-close" onclick="closeModal('addProviderModal')">&times;</button>
            </div>
            <form action="/admin/add" method="post">
                <div class="form-group">
                    <label class="form-label">Provider Name</label>
                    <input type="text" name="name" class="form-control" placeholder="Dr. John Smith" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Specialty</label>
                    <input type="text" name="specialty" class="form-control" placeholder="Cardiology" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">NPI Number</label>
                    <input type="text" name="npi" class="form-control" placeholder="1234567890" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Network Status</label>
                    <select name="networkStatus" class="form-control" required>
                        <option value="">Select Status</option>
                        <option value="IN">In-Network</option>
                        <option value="OUT">Out-of-Network</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-success" style="width: 100%;">
                    <i class="fas fa-save"></i> Save Provider
                </button>
            </form>
        </div>
    </div>
    
    <div id="editProviderModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-edit"></i> Edit Provider</h3>
                <button class="modal-close" onclick="closeModal('editProviderModal')">&times;</button>
            </div>
            <form action="/admin/edit" method="post">
                <input type="hidden" name="providerId" id="editProviderId">
                
                <div class="form-group">
                    <label class="form-label">Provider Name</label>
                    <input type="text" name="name" id="editName" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Specialty</label>
                    <input type="text" name="specialty" id="editSpecialty" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">NPI Number</label>
                    <input type="text" name="npi" id="editNpi" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Network Status</label>
                    <select name="networkStatus" id="editNetworkStatus" class="form-control" required>
                        <option value="IN">In-Network</option>
                        <option value="OUT">Out-of-Network</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-success" style="width: 100%;">
                    <i class="fas fa-sync-alt"></i> Update Provider
                </button>
            </form>
        </div>
    </div>
    
    <script>
        // Modal functions
        function openModal(id) {
            document.getElementById(id).style.display = 'flex';
        }
        
        function closeModal(id) {
            document.getElementById(id).style.display = 'none';
        }
        
        function openAddProviderModal() {
            openModal('addProviderModal');
        }
        
        function openEditProviderModal(id, name, specialty, npi, networkStatus) {
            document.getElementById('editProviderId').value = id;
            document.getElementById('editName').value = name;
            document.getElementById('editSpecialty').value = specialty;
            document.getElementById('editNpi').value = npi;
            document.getElementById('editNetworkStatus').value = networkStatus;
            openModal('editProviderModal');
        }
        
        // Close modal when clicking outside
        window.onclick = function(event) {
            if (event.target.classList.contains('modal')) {
                event.target.style.display = 'none';
            }
        }
        
        // Refresh claims data
        function refreshClaimsData() {
            fetch('/admin/api/claims/refresh')
                .then(response => response.json())
                .then(data => {
                    // Update counts
                    if (data.submitted !== undefined) {
                        document.getElementById('submittedCount').textContent = data.submitted;
                    }
                    if (data.processed !== undefined) {
                        document.getElementById('processedCount').textContent = data.processed;
                    }
                    if (data.approved !== undefined) {
                        document.getElementById('approvedCount').textContent = data.approved;
                    }
                    if (data.denied !== undefined) {
                        document.getElementById('deniedCount').textContent = data.denied;
                    }
                    if (data.pending !== undefined) {
                        document.getElementById('pendingCount').textContent = data.pending;
                    }
                    
                    // Show notification
                    alert('Data refreshed successfully!');
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to refresh data');
                });
        }
        
        // Auto-refresh every 30 seconds (optional)
        // setInterval(refreshClaimsData, 30000);
    </script>
</body>
</html>