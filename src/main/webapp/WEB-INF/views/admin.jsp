<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>COBNet - Admin Dashboard</title>
    <link rel="stylesheet" 
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            background: #f8f9fa;
            color: #212529;
            font-size: 14px;
        }
        /* Sidebar */
        .sidebar {
            width: 220px;
            background: #1c1f23;
            color: #dee2e6;
            height: 100vh;
            position: fixed;
            top: 0; left: 0;
            display: flex;
            flex-direction: column;
            padding-top: 20px;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 25px;
            font-size: 18px;
            color: #0d6efd;
        }
        .sidebar a {
            color: #dee2e6;
            padding: 10px 18px;
            text-decoration: none;
            display: flex;
            align-items: center;
            transition: background 0.2s ease;
            font-size: 13px;
        }
        .sidebar a:hover { background: #343a40; }
        .sidebar i { margin-right: 8px; }

        /* Main */
        .main { margin-left: 220px; padding: 20px; }
        header {
            background: #fff;
            padding: 12px 18px;
            border-bottom: 1px solid #dee2e6;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        header .logo { font-weight: 600; font-size: 16px; color: #0d6efd; }
        header a { color: #0d6efd; text-decoration: none; font-weight: 500; font-size: 13px; }

        h2, h3 { font-weight: 500; margin-top: 20px; font-size: 15px; }

        /* Tables */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
            background: #fff;
            border-radius: 6px;
            overflow: hidden;
            font-size: 13px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #e9ecef;
        }
        th { background: #f1f3f5; font-weight: 500; }
        tr:hover { background: #f8f9fa; }

        /* Buttons */
        .btn {
            padding: 6px 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            font-size: 12px;
            transition: background 0.2s ease;
        }
        .btn-add { background: #0d6efd; color: #fff; }
        .btn-edit { background: #ffc107; color: #212529; }
        .btn-delete { background: #dc3545; color: #fff; }
        .btn:hover { opacity: 0.9; }

        /* Chart container */
        .chart-container {
            background: #fff;
            padding: 15px;
            border-radius: 6px;
            margin-top: 15px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.05);
            height: 300px; /* fixed height */
        }
        canvas { max-height: 250px; }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <div class="sidebar">
        <h2>COBNet</h2>
        <a href="#"><i class="fas fa-user-md"></i> Providers</a>
        <a href="#"><i class="fas fa-file-medical"></i> Claims</a>
        <a href="#"><i class="fas fa-clipboard-list"></i> Audit Logs</a>
        <a href="#"><i class="fas fa-chart-line"></i> Analytics</a>
        <a href="#"><i class="fas fa-shield-alt"></i> Compliance</a>
        <a href="/auth/login"><i class="fas fa-sign-out-alt"></i> Logout</a>
    </div>

    <!-- Main -->
    <div class="main">
        <header>
            <div class="logo">Admin Dashboard</div>
            <a href="/auth/login">Logout</a>
        </header>

        <h2>Welcome, Admin</h2>
        <p>${message}</p>

        <!-- CRUD Providers -->
        <h3>Manage Providers</h3>
        <button class="btn btn-add">+ Add Provider</button>
        <table>
            <thead>
                <tr>
                    <th>Provider ID</th>
                    <th>Name</th>
                    <th>Specialization</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <tr><td>101</td><td>Dr. Smith</td><td>Cardiology</td><td>Active</td>
                    <td><button class="btn btn-edit">Edit</button> <button class="btn btn-delete">Delete</button></td></tr>
                <tr><td>102</td><td>Dr. Johnson</td><td>Orthopedics</td><td>Inactive</td>
                    <td><button class="btn btn-edit">Edit</button> <button class="btn btn-delete">Delete</button></td></tr>
            </tbody>
        </table>

        <!-- Claims -->
        <h3>Recent Claims</h3>
        <table>
            <thead>
                <tr>
                    <th>Claim ID</th>
                    <th>Patient</th>
                    <th>Provider</th>
                    <th>Amount</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
                <tr><td>C-5001</td><td>Aiswarya</td><td>Dr. Smith</td><td>$1200</td><td>Approved</td></tr>
                <tr><td>C-5002</td><td>Ayisha</td><td>Dr. Johnson</td><td>$800</td><td>Pending</td></tr>
            </tbody>
        </table>

        <!-- Audit Logs -->
        <h3>Audit Logs</h3>
        <table>
            <thead>
                <tr><th>Timestamp</th><th>User</th><th>Action</th></tr>
            </thead>
            <tbody>
                <tr><td>2025-12-10 14:32</td><td>Admin</td><td>Deleted Provider #102</td></tr>
                <tr><td>2025-12-10 14:10</td><td>Admin</td><td>Approved Claim #C-5001</td></tr>
            </tbody>
        </table>

        <!-- Analytics -->
        <div class="chart-container">
            <h3>Claims Trend</h3>
            <canvas id="claimsChart"></canvas>
        </div>
    </div>

    <script>
        // Chart.js example with controlled bar size
        const ctx = document.getElementById('claimsChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Jan','Feb','Mar','Apr','May','Jun'],
                datasets: [{
                    label: 'Claims Processed',
                    data: [20, 35, 40, 50, 65, 70],
                    backgroundColor: '#0d6efd',
                    barThickness: 25,   // controlled bar width
                    maxBarThickness: 30
                }]
            },
            options: {
                maintainAspectRatio: false,
                responsive: true,
                scales: {
                    y: { beginAtZero: true }
                }
            }
        });
    </script>
</body>
</html>
