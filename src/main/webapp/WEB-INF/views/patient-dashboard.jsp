<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .dashboard-container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 20px;
        }
        .welcome-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .action-card {
            background: white;
            border-radius: 15px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            text-decoration: none;
            color: #333;
            display: block;
            transition: transform 0.3s;
        }
        .action-card:hover {
            transform: translateY(-5px);
            text-decoration: none;
            color: #333;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .action-icon {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #007bff;
        }
        .navbar-custom {
            background: linear-gradient(135deg, #2c3e50, #3498db);
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-heartbeat me-2"></i>Patient Portal
            </a>
            <div class="navbar-text text-white">
                <% 
                    Object patientObj = request.getAttribute("patient");
                    if (patientObj != null) {
                        com.example.demo.bean.Patient patient = (com.example.demo.bean.Patient) patientObj;
                        out.print("Welcome, " + patient.getFirstName() + " " + patient.getLastName());
                    }
                %>
            </div>
        </div>
    </nav>
    
    <!-- Dashboard Content -->
    <div class="dashboard-container">
        <!-- Welcome Card -->
        <div class="welcome-card">
            <h2><i class="fas fa-home me-2"></i>Patient Dashboard</h2>
            <p class="text-muted">
                Patient ID: 
                <strong>
                    <% 
                        if (patientObj != null) {
                            com.example.demo.bean.Patient patient = (com.example.demo.bean.Patient) patientObj;
                            out.print("PT-" + patient.getPatientId());
                        }
                    %>
                </strong>
            </p>
            <p>Manage your medical bills and insurance information.</p>
        </div>
        
        <!-- Action Cards -->
        <div class="row">
            <div class="col-md-6">
                <a href="insurance?patientId=${patientId}" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h4>View Insurance Policies</h4>
                    <p class="text-muted">See all your insurance coverage</p>
                </a>
            </div>
            
            <div class="col-md-6">
                <a href="bills?patientId=${patientId}" class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-file-invoice-dollar"></i>
                    </div>
                    <h4>View Medical Bills</h4>
                    <p class="text-muted">Check and pay your pending bills</p>
                </a>
            </div>
        </div>
        
        <!-- Quick Info -->
        <div class="alert alert-info mt-4">
            <h5><i class="fas fa-info-circle me-2"></i>Need Help?</h5>
            <p class="mb-0">
                • For billing questions: Call (123) 456-7890<br>
                • For insurance questions: Contact your provider<br>
                • For technical issues: Email support@cobnet.com
            </p>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>