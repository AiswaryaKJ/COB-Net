<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.lang.Number" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bill History</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        .navbar-custom { background: linear-gradient(135deg, #2c3e50, #3498db); }
        .container-custom { max-width: 900px; margin: 30px auto; }
    </style>
</head>
<body>

<%
    // --- UTILITY SETUP ---
    // Use Locale.US for consistent currency formatting
    NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(Locale.US);

    // ==============================================================================
    // DEFENSIVE DATA RETRIEVAL (Preventing ClassCastException)
    // ==============================================================================

    // 1. Patient ID: MUST be converted to String safely.
    Object patientIdObj = request.getAttribute("patientId");
    String patientId = String.valueOf(patientIdObj);
    if (patientId.equals("null")) patientId = "0";

    // 2. Patient Name: MUST be converted to String safely.
    Object patientNameObj = request.getAttribute("patientName");
    String patientName = String.valueOf(patientNameObj);
    if (patientName.equals("null")) patientName = "Patient";

    // 3. Bill History List: Safely retrieve and cast, defaulting to an empty list.
    Object historyObj = request.getAttribute("billHistory");
    @SuppressWarnings("unchecked")
    List<Map<String,Object>> billHistory = Collections.emptyList();
    
    if (historyObj instanceof List) {
        billHistory = (List<Map<String,Object>>) historyObj;
    }
%>

   
    <div class="container-custom">
        <h3 class="mt-4 mb-4"><i class="fas fa-list-alt me-2 text-primary"></i>Claim History for <%= patientName %></h3>
        
        <div class="card shadow-sm">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-striped table-hover mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Claim ID</th>
                                <th>Claim Date</th>
                                <th class="text-end">Billed Amount</th>
                                <th class="text-end text-danger">Out-of-Pocket</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (!billHistory.isEmpty()) {
                                    for (Map<String,Object> bill : billHistory) {
                                        
                                        // 4. CLAIM ID: Safest retrieval, using String.valueOf() to defeat Integer cast error
                                        String claimIdStr = String.valueOf(bill.getOrDefault("claimId", "N/A"));
                                        
                                        // 5. DATE: Requires checking, assuming it comes as java.time.LocalDate or similar
                                        String claimDateStr = "N/A";
                                        Object dateObj = bill.get("claimDate");
                                        if (dateObj != null) {
                                            claimDateStr = String.valueOf(dateObj); 
                                        }
                                        
                                        // 6. NUMERICS: Must be safely retrieved using Number interface
                                        double billedAmount = 0.0;
                                        Object billedObj = bill.getOrDefault("billedAmount", 0.0);
                                        if (billedObj instanceof Number) {
                                            billedAmount = ((Number) billedObj).doubleValue();
                                        }
                                        
                                        double outOfPocket = 0.0;
                                        Object oopObj = bill.getOrDefault("finalOutOfPocket", 0.0);
                                        if (oopObj instanceof Number) {
                                            outOfPocket = ((Number) oopObj).doubleValue();
                                        }
                            %>
                                    <tr>
                                        <td>HC-<%= claimIdStr %></td>
                                        <td><%= claimDateStr %></td>
                                        <td class="text-end"><%= currencyFormatter.format(billedAmount) %></td>
                                        <td class="text-end text-danger fw-bold"><%= currencyFormatter.format(outOfPocket) %></td>
                                        <td>
                                            <a href="bill/details?patientId=<%= patientId %>&claimId=<%= claimIdStr %>"  
                                               class="btn btn-sm btn-outline-info" title="View Details">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                        </td>
                                    </tr>
                            <%
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="5" class="text-center py-4">
                                        <i class="fas fa-file-invoice fa-3x text-muted mb-2"></i>
                                        <p>No processed billing records found.</p>
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>