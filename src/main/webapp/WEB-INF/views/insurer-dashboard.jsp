<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insurer Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI'; }
        .container-custom { max-width: 1200px; margin: 30px auto; padding: 0 20px; }
        .dashboard-card { background: white; border-radius: 15px; padding: 30px; margin-bottom: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .stat-card { background: linear-gradient(135deg, #2c3e50, #3498db); color: white; border-radius: 10px; padding: 20px; text-align: center; margin-bottom: 20px; }
        .action-card { background: white; border-radius: 10px; padding: 20px; text-align: center; box-shadow: 0 3px 10px rgba(0,0,0,0.05); margin-bottom: 20px; border: 1px solid #e0e0e0; }
    </style>
</head>
<body>
    <div class="container-custom">
        <!-- Header -->
        <div class="dashboard-card">
            <h2><i class="fas fa-building me-2"></i>Insurance Provider Dashboard</h2>
            <p class="text-muted">Process and manage medical claims</p>
        </div>
        
        <!-- Stats -->
        <div class="row">
            <div class="col-md-6">
                <div class="stat-card">
                    <h3>${pendingCount}</h3>
                    <p>Pending Claims</p>
                    <a href="pending" class="btn btn-warning">View Pending</a>
                </div>
            </div>
            <div class="col-md-6">
                <div class="stat-card">
                    <h3>${processedCount}</h3>
                    <p>Processed Claims</p>
                    <a href="processed" class="btn btn-success">View History</a>
                </div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="dashboard-card">
            <h4 class="mb-4"><i class="fas fa-bolt me-2"></i>Quick Actions</h4>
            <div class="row">
                <div class="col-md-4">
                    <div class="action-card">
                        <i class="fas fa-clipboard-list fa-3x mb-3 text-primary"></i>
                        <h5>Process Claims</h5>
                        <p>Review and process pending claims</p>
                        <a href="pending" class="btn btn-primary">Go to Pending</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="action-card">
                        <i class="fas fa-history fa-3x mb-3 text-success"></i>
                        <h5>Claim History</h5>
                        <p>View processed claims</p>
                        <a href="processed" class="btn btn-success">View History</a>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="action-card">
                        <i class="fas fa-file-invoice-dollar fa-3x mb-3 text-info"></i>
                        <h5>Settlements</h5>
                        <p>View all settlements</p>
                        <a href="#" class="btn btn-info">View Settlements</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>