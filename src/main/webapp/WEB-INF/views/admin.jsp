<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.demo.bean.Provider" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>COBNet - Admin Dashboard</title>
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"/>
    
    <style>
        /* --- GLOBAL RESET & BASE STYLES --- */
        body { margin: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f6; color: #333; }
        a { text-decoration: none; color: inherit; }
        h2, h3 { color: #1f2937; }

        /* --- LAYOUT: SIDEBAR & MAIN --- */
        .dashboard-container { display: flex; min-height: 100vh; }

        /* Sidebar Styling */
        .sidebar {
            width: 250px;
            background-color: #1f2937; /* Darker primary color */
            color: #ffffff;
            padding: 20px 0;
            box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            display: flex;
            flex-direction: column;
            position: fixed; /* Keep sidebar fixed */
            height: 100%;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 30px;
            font-size: 1.8em;
            color: #4ade80; /* Highlight color for logo */
            font-weight: 700;
        }
        .sidebar a {
            padding: 15px 20px;
            display: block;
            font-size: 1.0em;
            transition: background-color 0.3s, color 0.3s;
            border-left: 5px solid transparent;
        }
        .sidebar a:hover {
            background-color: #374151; /* Lighter background on hover */
            color: #ffffff;
            border-left-color: #4ade80; /* Highlight border on hover */
        }
        .sidebar a i {
            margin-right: 10px;
        }

        /* Main Content Styling */
        .main {
            margin-left: 250px; /* Offset for the fixed sidebar */
            flex-grow: 1;
            padding: 30px;
        }
        .main h2 {
            margin-top: 0;
            margin-bottom: 25px;
            border-bottom: 1px solid #ddd;
            padding-bottom: 10px;
        }

        /* Header Styling */
        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            margin-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
        }
        header .logo {
            font-size: 1.5em;
            font-weight: 600;
            color: #1f2937;
        }
        header a {
            color: #ef4444; /* Red color for logout */
            padding: 8px 15px;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        header a:hover {
            background-color: #fee2e2;
        }

        /* --- CARD STYLING --- */
        .card {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05); /* Soft shadow */
        }
        .card h3 {
            margin-top: 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #f3f4f6;
            margin-bottom: 15px;
            font-size: 1.4em;
            font-weight: 600;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        /* --- BUTTON STYLING --- */
        .btn {
            padding: 8px 16px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 600;
            transition: background-color 0.3s, opacity 0.3s;
            text-align: center;
            display: inline-block;
            font-size: 0.9em;
        }
        .btn-add { background-color: #10b981; color: #ffffff; } /* Green */
        .btn-add:hover { background-color: #059669; }

        .btn-edit { background-color: #3b82f6; color: #ffffff; margin-right: 5px; } /* Blue */
        .btn-edit:hover { background-color: #2563eb; }

        .btn-delete { background-color: #ef4444; color: #ffffff; } /* Red */
        .btn-delete:hover { background-color: #dc2626; }

        /* --- TABLE STYLING --- */
        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        thead th {
            background-color: #f3f4f6;
            color: #374151;
            font-weight: 600;
            text-align: left;
            padding: 12px 15px;
            font-size: 0.9em;
        }
        tbody tr {
            border-bottom: 1px solid #e5e7eb;
        }
        tbody tr:nth-child(even) {
            background-color: #f9fafb; /* Subtle zebra striping */
        }
        tbody tr:hover {
            background-color: #f0f4f7;
        }
        tbody td {
            padding: 12px 15px;
            vertical-align: middle;
            font-size: 0.9em;
        }

        /* --- MODAL STYLES --- */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.6);
            z-index: 1000;
            overflow: auto;
        }
        .modal-content {
            background: #ffffff;
            margin: 5% auto;
            padding: 30px;
            width: 90%;
            max-width: 450px; /* Max width for a clean look */
            border-radius: 8px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            position: relative;
        }
        .close {
            position: absolute;
            top: 10px;
            right: 20px;
            cursor: pointer;
            font-size: 24px;
            color: #9ca3af;
            transition: color 0.3s;
        }
        .close:hover {
            color: #333;
        }
        .modal-content h3 {
            margin-top: 0;
            margin-bottom: 20px;
            border-bottom: 1px solid #e5e7eb;
            padding-bottom: 10px;
        }
        .form-field { margin-bottom: 15px; }
        .form-field label { display: block; font-weight: 600; margin-bottom: 5px; color: #4b5563; }
        .form-field input {
            width: calc(100% - 12px);
            padding: 8px 6px;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        .form-field input:focus {
            border-color: #3b82f6;
            outline: none;
            box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.2);
        }
    </style>
</head>
<body>

    <div class="dashboard-container">
        <div class="sidebar">
            <h2>COBNet</h2>
            <a href="#"><i class="fas fa-user-md"></i> Providers</a>
            <a href="#"><i class="fas fa-file-medical"></i> Claims</a>
            <a href="#"><i class="fas fa-clipboard-list"></i> Audit Logs</a>
            <a href="#"><i class="fas fa-chart-line"></i> Analytics</a>
            <div style="margin-top: auto;">
                 <a href="/auth/login" style="color: #ef4444; border-left-color: #ef4444;"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>

        <div class="main">
            <header>
                <div class="logo">Admin Dashboard</div>
            </header>

            <h2>Welcome, Admin</h2>

            <div class="card">
                <h3>
                    <span><i class="fas fa-user-md"></i> Manage Providers</span>
                    <button class="btn btn-add" onclick="openModal('addProviderModal')"><i class="fas fa-plus"></i> Add Provider</button>
                </h3>
                <table>
                    <thead>
                        <tr>
                            <th>Provider ID</th>
                            <th>Name</th>
                            <th>Specialty</th>
                            <th>Status</th>
                            <th>NPI</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Provider> providers = (List<Provider>) request.getAttribute("providers");
                            if (providers != null) {
                                for (Provider provider : providers) {
                        %>
                            <tr>
                                <td><%= provider.getProviderId() %></td>
                                <td><%= provider.getName() %></td>
                                <td><%= provider.getSpecialty() %></td>
                                <td><%= provider.getNetworkStatus() %></td>
                                <td><%= provider.getNpi() %></td>
                                <td>
                                    <button class="btn btn-edit"
                                            onclick="openEditModal('<%= provider.getProviderId() %>',
                                                                   '<%= provider.getName() %>',
                                                                   '<%= provider.getSpecialty() %>',
                                                                   '<%= provider.getNetworkStatus() %>',
                                                                   '<%= provider.getNpi() %>')"><i class="fas fa-edit"></i> Edit</button>
                                    <a href="/admin/delete/<%= provider.getProviderId() %>" class="btn btn-delete"
                                       onclick="return confirm('Are you sure you want to delete this provider?')"><i class="fas fa-trash-alt"></i> Delete</a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr><td colspan="6" style="text-align:center; padding: 20px;">No providers found.</td></tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
            
            </div>
    </div>

    <div id="addProviderModal" class="modal">
      <div class="modal-content">
        <span class="close" onclick="closeModal('addProviderModal')">&times;</span>
        <h3>Add New Provider</h3>
        <form action="/admin/add" method="post">
          <div class="form-field">
            <label for="addName">Name</label>
            <input type="text" name="name" id="addName" required/>
          </div>
          <div class="form-field">
            <label for="addSpecialty">Specialty</label>
            <input type="text" name="specialty" id="addSpecialty" required/>
          </div>
          <div class="form-field">
            <label for="addNetworkStatus">Status</label>
            <input type="text" name="networkStatus" id="addNetworkStatus" required/>
          </div>
          <div class="form-field">
            <label for="addNpi">NPI</label>
            <input type="text" name="npi" id="addNpi" required/>
          </div>
          <button type="submit" class="btn btn-add" style="width: 100%; margin-top: 15px;">Save Provider</button>
        </form>
      </div>
    </div>

    <div id="editProviderModal" class="modal">
      <div class="modal-content">
        <span class="close" onclick="closeModal('editProviderModal')">&times;</span>
        <h3>Edit Provider Details</h3>
        <form action="/admin/edit" method="post">
          <input type="hidden" name="providerId" id="editProviderId"/>
          <div class="form-field">
            <label for="editName">Name</label>
            <input type="text" name="name" id="editName" required/>
          </div>
          <div class="form-field">
            <label for="editSpecialty">Specialty</label>
            <input type="text" name="specialty" id="editSpecialty" required/>
          </div>
          <div class="form-field">
            <label for="editStatus">Status</label>
            <input type="text" name="networkStatus" id="editStatus" required/>
          </div>
          <div class="form-field">
            <label for="editNpi">NPI</label>
            <input type="text" name="npi" id="editNpi" required/>
          </div>
          <button type="submit" class="btn btn-edit" style="width: 100%; margin-top: 15px;">Update Provider</button>
        </form>
      </div>
    </div>

    <script>
        // --- Modal Functions ---
        function openModal(id) {
          document.getElementById(id).style.display = 'block';
        }
        function closeModal(id) {
          document.getElementById(id).style.display = 'none';
        }
        function openEditModal(id, name, specialty, status, npi) {
          document.getElementById('editProviderId').value = id;
          document.getElementById('editName').value = name;
          document.getElementById('editSpecialty').value = specialty;
          document.getElementById('editStatus').value = status;
          document.getElementById('editNpi').value = npi;
          openModal('editProviderModal');
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
          if (event.target.classList.contains('modal')) {
            event.target.style.display = 'none';
          }
        }
    </script>
</body>
</html>