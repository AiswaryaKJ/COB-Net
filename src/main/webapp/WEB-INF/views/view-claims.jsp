<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Claims</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h2>Healthcare Claims</h2>
        
        <div class="row mb-3">
            <div class="col-md-12">
                <form onsubmit="return false;" class="d-flex">
                    <input type="number" id="patientIdSearchInput" class="form-control me-2" placeholder="Search by Patient ID">
                    <button type="button" class="btn btn-primary" id="filterPatientBtn">Search</button>
                    <button type="button" class="btn btn-secondary ms-2" id="resetFilterBtn">Reset</button>
                </form>
            </div>
        </div>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">${error}</div>
        <% } %>
        <% if (request.getAttribute("message") != null) { %>
            <div class="alert alert-success">${message}</div>
        <% } %>
        
        <% if (request.getAttribute("searchType") != null) { %>
            <h4>${searchType}</h4>
        <% } %>
        
        <table class="table table-striped" id="claimsTable">
            <thead>
                <tr>
                    <th>Claim ID</th>
                    <th>Patient ID</th>
                    <th>Provider ID</th>
                    <th>Billed Amount</th>
                    <th>Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% java.util.List<com.example.demo.bean.Claim> claims = (java.util.List<com.example.demo.bean.Claim>) request.getAttribute("claims");
                   if (claims != null && !claims.isEmpty()) {
                       for (com.example.demo.bean.Claim claim : claims) { %>
                        <tr>
                            <td><%= claim.getClaimId() %></td>
                            <td data-patient-id="<%= claim.getPatient().getPatientId() %>"><%= claim.getPatient().getPatientId() %></td>
                            <td><%= claim.getProvider().getProviderId() %></td>
                            <td>$<%= claim.getBilledAmount() %></td>
                            <td><%= claim.getClaimDate() %></td>
                            <td><%= claim.getStatus() %></td>
                            <td>
                                <a href="viewclaim?claimId=<%= claim.getClaimId() %>" class="btn btn-info btn-sm">View</a>
                                <button type="button" class="btn btn-warning btn-sm" onclick="updateStatus(<%= claim.getClaimId() %>)">Update</button>
                                <form action="deleteclaim" method="POST" style="display:inline;">
                                    <input type="hidden" name="claimId" value="<%= claim.getClaimId() %>">
                                    <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Delete this claim?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                <%   }
                   } else { %>
                    <tr>
                        <td colspan="7" class="text-center">No claims found</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        
        <div class="modal fade" id="statusModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Update Claim Status</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="updatestatus" method="POST">
                        <div class="modal-body">
                            <input type="hidden" name="claimId" id="claimIdInput">
                            <select name="status" class="form-select">
                                <option value="Submitted">Submitted</option>
                                <option value="Processed">Processed</option>
                                <option value="Approved">Approved</option>
                                <option value="Denied">Denied</option>
                                <option value="Paid">Paid</option>
                            </select>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Update Status</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <a href="submitclaim" class="btn btn-success">Submit New Claim</a>
        <a href="welcome" class="btn btn-secondary">Back to Home</a>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateStatus(claimId) {
            document.getElementById('claimIdInput').value = claimId;
            new bootstrap.Modal(document.getElementById('statusModal')).show();
        }

        document.addEventListener('DOMContentLoaded', function () {
            const searchInput = document.getElementById('patientIdSearchInput');
            const filterBtn = document.getElementById('filterPatientBtn');
            const resetBtn = document.getElementById('resetFilterBtn');
            const tableBody = document.querySelector('#claimsTable tbody');
            const rows = tableBody ? tableBody.querySelectorAll('tr') : [];

            // Function to perform the filtering
            function filterClaims() {
                const filterValue = searchInput.value.trim();
                
                // If there is no input, show all rows
                if (filterValue === '') {
                    rows.forEach(row => row.style.display = '');
                    return;
                }
                
                rows.forEach(row => {
                    // Check if the row is the "No claims found" row and skip it
                    if (row.querySelector('td[colspan="7"]')) {
                        return;
                    }

                    // Get the Patient ID from the data attribute (for accuracy)
                    const patientIdCell = row.querySelector('td[data-patient-id]');
                    
                    if (patientIdCell) {
                        const rowPatientId = patientIdCell.getAttribute('data-patient-id');
                        
                        // Check if the row's Patient ID starts with the filter value
                        if (rowPatientId.startsWith(filterValue)) {
                            row.style.display = ''; // Show row
                        } else {
                            row.style.display = 'none'; // Hide row
                        }
                    }
                });
            }

            // Event listener for the Search button
            if (filterBtn) {
                filterBtn.addEventListener('click', filterClaims);
            }

            // Optional: Filter as the user types
            if (searchInput) {
                 searchInput.addEventListener('keyup', filterClaims);
            }

            // Event listener for the Reset button
            if (resetBtn) {
                resetBtn.addEventListener('click', function() {
                    searchInput.value = ''; // Clear the input field
                    rows.forEach(row => row.style.display = ''); // Show all rows
                });
            }
        });
    </script>
</body>
</html>