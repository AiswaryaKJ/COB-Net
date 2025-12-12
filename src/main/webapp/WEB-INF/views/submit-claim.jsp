<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit Medical Claim</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <style>
        :root {
            --primary-color: #2c3e50;
            --secondary-color: #3498db;
            --light-bg: #f8f9fa;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: var(--light-bg);
            color: #333;
            font-size: 0.95rem; /* Base font size adjusted */
        }
        
        .container {
            max-width: 900px; 
            margin: 0 auto;
            padding: 20px;
        }
        
        .header-card {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        }
        
        .header-card h1 {
            font-size: 1.8rem;
        }

        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }
        
        .section-title {
            color: var(--primary-color);
            padding-bottom: 8px;
            margin-bottom: 20px;
            border-bottom: 2px solid var(--secondary-color);
            font-weight: 600;
            font-size: 1.25rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #444;
            margin-bottom: 6px;
            font-size: 0.9rem;
        }
        
        .required::after {
            content: " *";
            color: #e74c3c;
        }
        
        .form-control, .form-select, .select2-container .select2-selection--single {
            border: 1px solid #e0e0e0;
            border-radius: 6px;
            padding: 8px 12px;
            transition: all 0.3s ease;
            height: 38px;
            font-size: 0.9rem;
        }
        
        .form-control:focus, .form-select:focus, .select2-container--focus .select2-selection--single {
            border-color: var(--secondary-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.2);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, var(--secondary-color), #2980b9);
            color: white;
            padding: 10px 30px;
            border: none;
            border-radius: 6px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin: 20px auto;
        }
        
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(52, 152, 219, 0.25);
        }
        
        .alert-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            min-width: 300px;
        }

        .info-box {
            background: #e8f4fc;
            border-left: 3px solid var(--secondary-color);
            padding: 12px;
            border-radius: 5px;
            margin-bottom: 15px;
            font-size: 0.9rem;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .nav-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        .btn-back {
            background: #6c757d;
            color: white;
            padding: 8px 20px;
            border-radius: 6px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-back:hover {
            background: #5a6268;
            color: white;
        }
        
        /* Select2 Custom Styling */
        .select2-container--default .select2-selection--single .select2-selection__rendered {
            line-height: 20px;
            color: #333;
        }
        
        .select2-container--default .select2-selection--single .select2-selection__arrow {
            height: 36px;
        }
        
        .code-preview {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 6px;
            padding: 8px 12px;
            margin-top: 5px;
            font-size: 0.85rem;
            color: #666;
            min-height: 35px;
        }
        
        .code-description {
            color: var(--secondary-color);
            font-weight: 500;
        }
        
        .search-hint {
            font-size: 0.75rem;
            color: #6c757d;
            font-style: italic;
        }
        
        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }
            
            .form-container, .header-card {
                padding: 15px;
            }
        }
    </style>
</head>
<body>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert-container">
            <div class="alert alert-danger alert-dismissible fade show shadow-lg" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <%= request.getAttribute("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </div>
    <% } %>
    
    <div class="container">
        <div class="header-card">
            <div class="row align-items-center">
                <div class="col-md-2 text-center">
                    <i class="fas fa-file-medical fa-3x"></i>
                </div>
                <div class="col-md-10">
                    <h1><i class="fas fa-stethoscope me-2"></i>Medical Claim Submission</h1>
                    <p class="mb-0">Fill out the form below to submit a new medical claim for processing</p>
                </div>
            </div>
        </div>
        
        <div class="info-box">
            <h5><i class="fas fa-info-circle me-2 text-primary"></i>Important Information</h5>
            <p class="mb-0">Please ensure all required fields (marked with *) are completed accurately. Incomplete or incorrect information may delay claim processing.</p>
        </div>
        
        <div class="form-container">
            <form action="submitclaim" method="POST" id="claimForm">
                <h3 class="section-title">
                    <i class="fas fa-user-injured me-2"></i>Patient Information
                </h3>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Patient ID</label>
                            <input type="number" class="form-control" name="patient.patientId" 
                                   placeholder="Enter patient identification number" required>
                            <small class="form-text text-muted">Unique patient identifier</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Patient Name</label>
                            <input type="text" class="form-control" 
                                   placeholder="Will auto-fetch from system" readonly>
                            <small class="form-text text-muted">Auto-populated from patient ID</small>
                        </div>
                    </div>
                </div>
                
                <h3 class="section-title mt-5">
                    <i class="fas fa-user-md me-2"></i>Provider Information
                </h3>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Provider ID</label>
                            
                            <input type="hidden" name="provider.providerId" 
                                   value="${loggedInProviderId}">
                                   
                            <input type="text" class="form-control" 
                                   value="${loggedInProviderId}" 
                                   placeholder="Auto-assigned from login" 
                                   readonly>
                                   
                            <small class="form-text text-muted">Automatically assigned from your login credentials.</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Provider Name</label>
                            <input type="text" class="form-control" 
                                   placeholder="Will auto-fetch from system" readonly>
                            <small class="form-text text-muted">Auto-populated from provider ID</small>
                        </div>
                    </div>
                </div>
                
                <h3 class="section-title mt-5">
                    <i class="fas fa-file-invoice-dollar me-2"></i>Claim Details
                </h3>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label required">Billed Amount ($)</label>
                            <div class="input-group">
                                <span class="input-group-text">$</span>
                                <input type="number" step="0.01" class="form-control" name="billedAmount" 
                                       placeholder="0.00" required>
                            </div>
                            <small class="form-text text-muted">Enter the total amount billed</small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Claim Date</label>
                            <input type="date" class="form-control" 
                                   value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>" readonly>
                            <small class="form-text text-muted">Automatically set to today's date</small>
                        </div>
                    </div>
                </div>
                
                <div class="row mt-3">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Diagnosis Code (ICD-10)</label>
                            <select class="form-control diagnosis-select" name="diagnosisCode" id="diagnosisCode">
                                <option value="">Select a diagnosis code...</option>
                                <optgroup label="Common Diagnoses">
                                    <option value="J06.9">J06.9 - Acute upper respiratory infection, unspecified</option>
                                    <option value="J20.9">J20.9 - Acute bronchitis, unspecified</option>
                                    <option value="I10">I10 - Essential (primary) hypertension</option>
                                    <option value="E11.9">E11.9 - Type 2 diabetes mellitus without complications</option>
                                    <option value="M54.5">M54.5 - Low back pain</option>
                                    <option value="G43.909">G43.909 - Migraine, unspecified, not intractable, without status migrainosus</option>
                                </optgroup>
                                <optgroup label="Infectious Diseases">
                                    <option value="A09">A09 - Infectious gastroenteritis and colitis, unspecified</option>
                                    <option value="B34.9">B34.9 - Viral infection, unspecified</option>
                                    <option value="J18.9">J18.9 - Pneumonia, unspecified organism</option>
                                </optgroup>
                                <optgroup label="Musculoskeletal">
                                    <option value="M25.561">M25.561 - Pain in right knee</option>
                                    <option value="M25.562">M25.562 - Pain in left knee</option>
                                    <option value="M54.2">M54.2 - Cervicalgia (neck pain)</option>
                                    <option value="M79.1">M79.1 - Myalgia (muscle pain)</option>
                                </optgroup>
                                <optgroup label="Respiratory">
                                    <option value="J45.909">J45.909 - Unspecified asthma, uncomplicated</option>
                                    <option value="J30.9">J30.9 - Allergic rhinitis, unspecified</option>
                                    <option value="J44.9">J44.9 - Chronic obstructive pulmonary disease, unspecified</option>
                                </optgroup>
                                <optgroup label="Cardiovascular">
                                    <option value="I25.10">I25.10 - Atherosclerotic heart disease of native coronary artery without angina pectoris</option>
                                    <option value="I48.91">I48.91 - Unspecified atrial fibrillation</option>
                                    <option value="I50.9">I50.9 - Heart failure, unspecified</option>
                                </optgroup>
                            </select>
                            <small class="search-hint">Type to search or scroll to browse codes</small>
                            <div id="diagnosisPreview" class="code-preview">
                                <span id="selectedDiagnosis">No diagnosis code selected</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="form-label">Procedure Code (CPT/HCPCS)</label>
                            <select class="form-control procedure-select" name="procedureCode" id="procedureCode">
                                <option value="">Select a procedure code...</option>
                                <optgroup label="Evaluation & Management">
                                    <option value="99213">99213 - Office or other outpatient visit, established patient (15 min)</option>
                                    <option value="99214">99214 - Office or other outpatient visit, established patient (25 min)</option>
                                    <option value="99203">99203 - Office or other outpatient visit, new patient (30 min)</option>
                                    <option value="99204">99204 - Office or other outpatient visit, new patient (45 min)</option>
                                    <option value="99285">99285 - Emergency department visit, comprehensive</option>
                                </optgroup>
                                <optgroup label="Laboratory Tests">
                                    <option value="80053">80053 - Comprehensive metabolic panel</option>
                                    <option value="85025">85025 - Complete blood count (CBC), automated</option>
                                    <option value="81001">81001 - Urinalysis, automated, with microscopy</option>
                                    <option value="84443">84443 - Thyroid stimulating hormone (TSH)</option>
                                    <option value="80061">80061 - Lipid panel</option>
                                </optgroup>
                                <optgroup label="Radiology">
                                    <option value="71045">71045 - Radiologic examination, chest; single view</option>
                                    <option value="72040">72040 - Radiologic examination, spine, cervical; 2 or 3 views</option>
                                    <option value="72100">72100 - Radiologic examination, spine, lumbosacral; 2 or 3 views</option>
                                    <option value="73510">73510 - Radiologic examination, hip, unilateral; 2 views</option>
                                    <option value="73030">73030 - Radiologic examination, shoulder; complete</option>
                                </optgroup>
                                <optgroup label="Procedures">
                                    <option value="12001">12001 - Simple repair of superficial wounds of scalp, neck, axillae, external genitalia, trunk and/or extremities; 2.5 cm or less</option>
                                    <option value="11750">11750 - Excision of nail and nail matrix, partial or complete, for permanent removal</option>
                                    <option value="69210">69210 - Removal impacted cerumen (ear wax), one or both ears</option>
                                    <option value="G0101">G0101 - Cervical or vaginal cancer screening; pelvic and clinical breast examination</option>
                                    <option value="Q0091">Q0091 - Screening Papanicolaou smear; obtaining, preparing and conveyance of cervical or vaginal smear to laboratory</option>
                                </optgroup>
                                <optgroup label="Injections">
                                    <option value="96372">96372 - Therapeutic, prophylactic, or diagnostic injection (specify substance or drug); subcutaneous or intramuscular</option>
                                    <option value="90471">90471 - Immunization administration (includes percutaneous, intradermal, subcutaneous, or intramuscular injections); one vaccine (single or combination vaccine/toxoid)</option>
                                    <option value="J0696">J0696 - Injection, ceftriaxone sodium, per 250 mg</option>
                                    <option value="J0712">J0712 - Injection, ceftaroline fosamil, 10 mg</option>
                                </optgroup>
                            </select>
                            <small class="search-hint">Type to search or scroll to browse codes</small>
                            <div id="procedurePreview" class="code-preview">
                                <span id="selectedProcedure">No procedure code selected</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <input type="hidden" name="status" value="Submitted">
                <input type="hidden" name="claimDate" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                
                <div class="nav-buttons">
                    <a href="welcome" class="btn-back">
                        <i class="fas fa-arrow-left"></i> Back to Dashboard
                    </a>
                    <div>
                        <button type="reset" class="btn btn-secondary" id="resetBtn">
                            <i class="fas fa-redo me-1"></i> Clear Form
                        </button>
                        <button type="submit" class="btn btn-submit">
                            <i class="fas fa-paper-plane me-1"></i> Submit Claim
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function() {
            // Initialize Select2 for dropdowns
            $('.diagnosis-select').select2({
                placeholder: "Select a diagnosis code...",
                allowClear: true,
                width: '100%',
                templateResult: formatCodeOption,
                templateSelection: formatCodeSelection
            });
            
            $('.procedure-select').select2({
                placeholder: "Select a procedure code...",
                allowClear: true,
                width: '100%',
                templateResult: formatCodeOption,
                templateSelection: formatCodeSelection
            });
            
            // Function to format dropdown options
            function formatCodeOption(code) {
                if (!code.id) { return code.text; }
                var $option = $(
                    '<div><strong>' + code.id + '</strong> - ' + code.text + '</div>'
                );
                return $option;
            }
            
            function formatCodeSelection(code) {
                if (!code.id) { return code.text; }
                return $('<span><strong>' + code.id + '</strong></span>');
            }
            
            // Update preview boxes when selection changes
            $('#diagnosisCode').on('change', function() {
                const selected = $(this).select2('data')[0];
                if (selected && selected.id) {
                    $('#selectedDiagnosis').html(
                        '<strong>' + selected.id + '</strong> - <span class="code-description">' + 
                        selected.text + '</span>'
                    );
                } else {
                    $('#selectedDiagnosis').text('No diagnosis code selected');
                }
            });
            
            $('#procedureCode').on('change', function() {
                const selected = $(this).select2('data')[0];
                if (selected && selected.id) {
                    $('#selectedProcedure').html(
                        '<strong>' + selected.id + '</strong> - <span class="code-description">' + 
                        selected.text + '</span>'
                    );
                } else {
                    $('#selectedProcedure').text('No procedure code selected');
                }
            });
            
            // Auto-dismiss alerts
            setTimeout(function() {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(alert => {
                    if (alert && typeof bootstrap !== 'undefined' && bootstrap.Alert) {
                        const bsAlert = new bootstrap.Alert(alert);
                        bsAlert.close();
                    }
                });
            }, 5000);
            
            // Format currency input
            const amountInput = document.querySelector('input[name="billedAmount"]');
            if (amountInput) {
                amountInput.addEventListener('blur', function(e) {
                    let value = parseFloat(e.target.value);
                    if (!isNaN(value)) {
                        e.target.value = value.toFixed(2);
                    }
                });
            }
            
            // Auto-fetch patient name (simulated)
            const patientIdInput = document.querySelector('input[name="patient.patientId"]');
            const providerIdInput = document.querySelector('input[name="provider.providerId"]');
            
            if (patientIdInput) {
                patientIdInput.addEventListener('blur', function() {
                    console.log('Fetching patient info for ID:', this.value);
                });
            }
            
            if (providerIdInput) {
                providerIdInput.addEventListener('blur', function() {
                    console.log('Fetching provider info for ID:', this.value);
                });
            }
            
            // Handle form reset
            $('#resetBtn').click(function() {
                // Clear Select2 selections
                $('.diagnosis-select').val(null).trigger('change');
                $('.procedure-select').val(null).trigger('change');
                
                // Clear preview boxes
                $('#selectedDiagnosis').text('No diagnosis code selected');
                $('#selectedProcedure').text('No procedure code selected');
                
                // Note: The auto-fetched Provider ID will NOT be reset as it's set by the model.
                // You would need to reload the page or clear the hidden input value separately if desired.
            });
        });
    </script>
</body>
</html>