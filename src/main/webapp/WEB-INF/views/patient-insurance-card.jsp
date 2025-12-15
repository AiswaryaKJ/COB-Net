<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Digital Insurance Card</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- QR Code Library -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <style>
        body { 
            background-color: #f8f9fa; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            min-height: 100vh;
        }
        .container-custom { 
            max-width: 800px; 
            margin: 30px auto; 
            padding: 0 20px; 
        }
        .navbar-custom { 
            background: linear-gradient(135deg, #2c3e50, #3498db); 
        }
        .insurance-card-container {
            perspective: 1000px;
            margin: 40px 0;
        }
        .insurance-card {
            background: linear-gradient(135deg, #1a2980, #26d0ce);
            color: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.2);
            transform-style: preserve-3d;
            transition: transform 0.6s;
            position: relative;
            overflow: hidden;
            min-height: 400px;
        }
        .insurance-card:hover {
            transform: rotateY(5deg) rotateX(5deg);
        }
        .card-back {
            background: linear-gradient(135deg, #2c3e50, #4a6491);
            display: none;
        }
        .card-flipped .card-front {
            display: none;
        }
        .card-flipped .card-back {
            display: block;
        }
        .card-watermark {
            position: absolute;
            bottom: 20px;
            right: 20px;
            opacity: 0.1;
            font-size: 120px;
        }
        .card-logo {
            font-size: 2.5rem;
            margin-bottom: 30px;
        }
        .card-field {
            margin-bottom: 15px;
        }
        .card-label {
            font-size: 0.85rem;
            opacity: 0.8;
            margin-bottom: 5px;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .card-value {
            font-size: 1.2rem;
            font-weight: 600;
        }
        .card-number {
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
            margin: 20px 0;
            text-align: center;
            font-family: monospace;
            font-size: 1.4rem;
            letter-spacing: 3px;
        }
        .card-actions {
            position: absolute;
            bottom: 20px;
            left: 0;
            right: 0;
            text-align: center;
        }
        .card-toggle {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            padding: 10px 20px;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .card-toggle:hover {
            background: rgba(255, 255, 255, 0.3);
        }
        .qr-code {
            width: 150px;
            height: 150px;
            background: white;
            border-radius: 10px;
            margin: 20px auto;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #333;
            font-size: 12px;
            padding: 10px;
            text-align: center;
        }
        .no-policy {
            text-align: center;
            padding: 60px 20px;
        }
        .no-policy-icon {
            font-size: 4rem;
            color: #dee2e6;
            margin-bottom: 20px;
        }
        .policy-selector {
            margin-bottom: 20px;
        }
        .policy-badge {
            cursor: pointer;
            transition: all 0.3s;
        }
        .policy-badge.active {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }
        .card-back-content {
            padding: 20px;
        }
        .emergency-info {
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            padding: 15px;
            margin-top: 20px;
        }
        @media print {
            .no-print {
                display: none !important;
            }
            .insurance-card {
                box-shadow: none;
                border: 2px solid #333;
            }
        }
        /* QR code canvas styling */
        #qrcode canvas {
            border-radius: 10px;
            padding: 5px;
            background: white !important;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-custom no-print">
        <div class="container-fluid">
            <a class="navbar-brand" href="/patient/dashboard?patientId=${patientId}">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
            <span class="navbar-text text-white">
                <i class="fas fa-id-card me-2"></i>Digital Insurance Card
            </span>
        </div>
    </nav>
    
    <div class="container-custom">
        <div class="text-center mb-4 no-print">
            <h3><i class="fas fa-id-card me-2"></i>Your Digital Insurance Card</h3>
            <p class="text-muted">Present this card to healthcare providers</p>
        </div>
        
        <c:choose>
            <c:when test="${primaryPolicy != null}">
                <!-- Hidden data for JavaScript -->
                <div id="policyData" style="display: none;">
                    <c:forEach var="policy" items="${allPolicies}" varStatus="status">
                        <div class="policy-data" 
                             data-index="${status.index}"
                             data-payername="${policy.payerName}"
                             data-planname="${policy.planName}"
                             data-policynumber="${policy.policyNumber}"
                             data-effectivedate="${policy.effectiveDate}"
                             data-terminationdate="${policy.terminationDate}"
                             data-copay="${policy.copay}"
                             data-coveragepercent="${policy.coveragePercent}"
                             data-primary="${policy.primary}">
                        </div>
                    </c:forEach>
                </div>
                
                <!-- Policy Selector (if multiple policies) -->
                <c:if test="${allPolicies.size() > 1}">
                    <div class="policy-selector no-print">
                        <p class="text-muted mb-2"><i class="fas fa-exchange-alt me-2"></i>Select Insurance Card:</p>
                        <div class="d-flex flex-wrap gap-2">
                            <c:forEach var="policy" items="${allPolicies}" varStatus="status">
                                <span class="policy-badge badge ${policy.primary ? 'bg-primary' : 'bg-secondary'} p-3 ${status.index == 0 ? 'active' : ''}"
                                      onclick="switchPolicy(${status.index})">
                                    <i class="fas fa-shield-alt me-2"></i>
                                    ${policy.planName}
                                    <c:if test="${policy.primary}"> (Primary)</c:if>
                                </span>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
                
                <!-- Insurance Card -->
                <div class="insurance-card-container">
                    <div class="insurance-card card-front" id="insuranceCard">
                        <!-- Card Front -->
                        <div class="card-front">
                            <div class="card-logo">
                                <i class="fas fa-shield-alt"></i>
                                <span class="ms-2" id="payerName">${primaryPolicy.payerName}</span>
                            </div>
                            
                            <div class="card-watermark">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            
                            <div class="card-field">
                                <div class="card-label">Member Name</div>
                                <div class="card-value" id="memberName">${patientName}</div>
                            </div>
                            
                            <div class="card-field">
                                <div class="card-label">Member ID</div>
                                <div class="card-value" id="memberId">MBR-${patientId}${primaryPolicy.policyNumber}</div>
                            </div>
                            
                            <div class="card-field">
                                <div class="card-label">Group Number</div>
                                <div class="card-value" id="groupNumber">GRP-${primaryPolicy.policyNumber}</div>
                            </div>
                            
                            <div class="row mt-4">
                                <div class="col-md-6">
                                    <div class="card-field">
                                        <div class="card-label">Plan Type</div>
                                        <div class="card-value" id="planName">${primaryPolicy.planName}</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card-field">
                                        <div class="card-label">Effective Date</div>
                                        <div class="card-value" id="effectiveDate">${primaryPolicy.effectiveDate}</div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="card-number" id="policyNumber">
                                ${primaryPolicy.policyNumber}
                            </div>
                            
                            <div class="row">
                                <div class="col-md-4">
                                    <div class="card-field">
                                        <div class="card-label">Copay</div>
                                        <div class="card-value" id="copay">$${primaryPolicy.copay}</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card-field">
                                        <div class="card-label">Coverage</div>
                                        <div class="card-value" id="coveragePercent">${primaryPolicy.coveragePercent}%</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="card-field">
                                        <div class="card-label">Status</div>
                                        <div class="card-value">
                                            <span class="badge ${primaryPolicy.terminationDate != null && primaryPolicy.terminationDate.isBefore(today) ? 'bg-warning' : 'bg-success'}" id="statusBadge">
                                                ${primaryPolicy.terminationDate != null && primaryPolicy.terminationDate.isBefore(today) ? 'Expired' : 'Active'}
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- QR Code -->
                            <div class="qr-code mt-4" id="qrcode">
                                <div id="qrPlaceholder">
                                    <i class="fas fa-qrcode fa-3x mb-2"></i><br>
                                    <small>Loading QR code...</small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Card Back -->
                        <div class="card-back">
                            <div class="card-back-content">
                                <div class="card-logo">
                                    <i class="fas fa-phone-alt"></i>
                                    <span class="ms-2">Contact Information</span>
                                </div>
                                
                                <div class="card-watermark">
                                    <i class="fas fa-info-circle"></i>
                                </div>
                                
                                <div class="card-field">
                                    <div class="card-label">Customer Service</div>
                                    <div class="card-value" id="customerService">1-800-${primaryPolicy.payerName != null ? primaryPolicy.payerName.replaceAll("[^A-Za-z]", "").toUpperCase() : 'HEALTH'}</div>
                                </div>
                                
                                <div class="card-field">
                                    <div class="card-label">Website</div>
                                    <div class="card-value" id="website">www.${primaryPolicy.payerName != null ? primaryPolicy.payerName.toLowerCase().replaceAll("\\s+", "") : 'healthinsurance'}.com</div>
                                </div>
                                
                                <div class="card-field">
                                    <div class="card-label">Claims Address</div>
                                    <div class="card-value">PO Box 1234, Insurance City, IC 56789</div>
                                </div>
                                
                                <div class="emergency-info">
                                    <div class="card-label text-warning"><i class="fas fa-exclamation-triangle me-2"></i>Emergency Instructions</div>
                                    <p class="small mb-1">1. Present this card at any network facility</p>
                                    <p class="small mb-1">2. In emergency, go to nearest hospital</p>
                                    <p class="small mb-0">3. Call 911 for life-threatening situations</p>
                                </div>
                                
                                <div class="mt-4">
                                    <div class="card-label">Pharmacy Benefits</div>
                                    <p class="small mb-0">$10 Generic / $30 Brand / $50 Specialty</p>
                                </div>
                                
                                <div class="mt-3 text-center">
                                    <small class="opacity-75">This card is valid through <span id="validThrough">${primaryPolicy.terminationDate != null ? primaryPolicy.terminationDate : '12/31/2024'}</span></small>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Card Actions -->
                        <div class="card-actions no-print">
                            <button class="card-toggle" onclick="flipCard()">
                                <i class="fas fa-sync-alt me-2"></i>Flip Card
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="text-center mt-4 no-print">
                    <div class="btn-group" role="group">
                        <button class="btn btn-primary" onclick="window.print()">
                            <i class="fas fa-print me-2"></i>Print Card
                        </button>
                        <button class="btn btn-success" onclick="downloadCard()">
                            <i class="fas fa-download me-2"></i>Save as PDF
                        </button>
                        <button class="btn btn-info" onclick="shareCard()">
                            <i class="fas fa-share-alt me-2"></i>Share
                        </button>
                        <a href="/patient/policies?patientId=${patientId}" class="btn btn-outline-secondary">
                            <i class="fas fa-file-alt me-2"></i>View Details
                        </a>
                    </div>
                </div>
                
                <!-- Instructions -->
                <div class="alert alert-info mt-4">
                    <h6><i class="fas fa-info-circle me-2"></i>How to Use Your Digital Card</h6>
                    <div class="row">
                        <div class="col-md-4">
                            <strong>1. Show to Providers</strong>
                            <p class="small mb-0">Display this card at doctor's offices, hospitals, or pharmacies</p>
                        </div>
                        <div class="col-md-4">
                            <strong>2. Emergency Situations</strong>
                            <p class="small mb-0">First responders can scan QR code for critical information</p>
                        </div>
                        <div class="col-md-4">
                            <strong>3. Always Updated</strong>
                            <p class="small mb-0">Digital card automatically updates with policy changes</p>
                        </div>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <!-- No Insurance State -->
                <div class="no-policy">
                    <div class="no-policy-icon">
                        <i class="fas fa-id-card"></i>
                    </div>
                    <h4>No Insurance Found</h4>
                    <p class="text-muted mb-4">
                        You don't have any active insurance policies to display.
                    </p>
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>Insurance Required:</strong> 
                        You need an active insurance policy to generate a digital insurance card.
                    </div>
                    <a href="/patient/dashboard?patientId=${patientId}" class="btn btn-primary">
                        <i class="fas fa-home me-2"></i>Back to Dashboard
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- Footer -->
    <footer class="mt-5 py-3 border-top text-center text-muted no-print">
        <div class="container">
            <p class="mb-0">
                <i class="fas fa-shield-alt me-1"></i>
                Health Insurance CoB System &copy; 2024 | 
                Digital Insurance Card
            </p>
            <small class="text-muted">This is a digital representation of your insurance card. Always verify coverage with provider.</small>
        </div>
    </footer>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Global variables
        let currentPolicyIndex = 0;
        let allPolicies = [];
        let patientId = ${patientId};
        let patientName = "${patientName}";
        
        // Helper function to check if policy is active based on dates
        function isPolicyActive(effectiveDateStr, terminationDateStr) {
            if (!effectiveDateStr) return false;
            
            const today = new Date();
            const effectiveDate = new Date(effectiveDateStr);
            
            // Check if policy has started
            if (today < effectiveDate) return false;
            
            // Check if policy has ended (if termination date exists)
            if (terminationDateStr) {
                const terminationDate = new Date(terminationDateStr);
                if (today > terminationDate) return false;
            }
            
            return true;
        }
        
        // Format date for display
        function formatDate(dateStr) {
            if (!dateStr) return '';
            const date = new Date(dateStr);
            return date.toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: '2-digit', 
                day: '2-digit' 
            });
        }
        
        // Initialize policies data from hidden div
        document.addEventListener('DOMContentLoaded', function() {
            // Extract policy data from hidden div
            const policyElements = document.querySelectorAll('.policy-data');
            allPolicies = Array.from(policyElements).map(el => ({
                index: parseInt(el.dataset.index),
                payerName: el.dataset.payername || '',
                planName: el.dataset.planname || '',
                policyNumber: el.dataset.policynumber || '',
                effectiveDate: el.dataset.effectivedate || '',
                terminationDate: el.dataset.terminationdate || '',
                copay: el.dataset.copay || '0',
                coveragePercent: el.dataset.coveragepercent || '0',
                primary: el.dataset.primary === 'true'
            }));
            
            // Calculate active status for each policy
            allPolicies.forEach(policy => {
                policy.isActive = isPolicyActive(policy.effectiveDate, policy.terminationDate);
                policy.formattedEffectiveDate = formatDate(policy.effectiveDate);
                policy.formattedTerminationDate = formatDate(policy.terminationDate);
            });
            
            // Generate initial QR code
            generateQRCode(currentPolicyIndex);
        });
        
        // Flip card function
        function flipCard() {
            document.getElementById('insuranceCard').classList.toggle('card-flipped');
        }
        
        // Switch between policies
        function switchPolicy(index) {
            if (index >= allPolicies.length) return;
            
            currentPolicyIndex = index;
            const policy = allPolicies[index];
            
            // Update active badge
            document.querySelectorAll('.policy-badge').forEach((badge, i) => {
                if (i === index) {
                    badge.classList.add('active');
                    badge.classList.remove('bg-secondary');
                    badge.classList.add('bg-primary');
                } else {
                    badge.classList.remove('active');
                    badge.classList.add('bg-secondary');
                    badge.classList.remove('bg-primary');
                }
            });
            
            // Update card front data
            document.getElementById('payerName').textContent = policy.payerName;
            document.getElementById('planName').textContent = policy.planName;
            document.getElementById('policyNumber').textContent = policy.policyNumber;
            document.getElementById('effectiveDate').textContent = policy.formattedEffectiveDate;
            document.getElementById('copay').textContent = '$' + policy.copay;
            document.getElementById('coveragePercent').textContent = policy.coveragePercent + '%';
            document.getElementById('memberId').textContent = 'MBR-' + patientId + policy.policyNumber;
            document.getElementById('groupNumber').textContent = 'GRP-' + policy.policyNumber;
            
            // Update status badge - check if policy is active
            const statusBadge = document.getElementById('statusBadge');
            const isActive = policy.isActive;
            statusBadge.textContent = isActive ? 'Active' : 'Expired';
            statusBadge.className = 'badge ' + (isActive ? 'bg-success' : 'bg-warning');
            
            // Update card back data
            const cleanPayerName = policy.payerName ? policy.payerName.replaceAll(/[^A-Za-z]/g, '') : 'HEALTH';
            document.getElementById('customerService').textContent = '1-800-' + cleanPayerName.toUpperCase();
            
            const websiteName = policy.payerName ? policy.payerName.toLowerCase().replaceAll(/\s+/g, '') : 'healthinsurance';
            document.getElementById('website').textContent = 'www.' + websiteName + '.com';
            
            // Update valid through date
            document.getElementById('validThrough').textContent = policy.formattedTerminationDate || '12/31/2024';
            
            // Generate new QR code
            generateQRCode(index);
            
            // Reset card to front view
            document.getElementById('insuranceCard').classList.remove('card-flipped');
        }
        
        // Generate QR code
        function generateQRCode(policyIndex) {
            const policy = allPolicies[policyIndex];
            const qrContainer = document.getElementById('qrcode');
            const placeholder = document.getElementById('qrPlaceholder');
            
            if (!policy) return;
            
            // Clear previous QR code
            qrContainer.innerHTML = '';
            
            // Create QR code text
            const qrText = `INSURANCE CARD\n` +
                          `Member: ${patientName}\n` +
                          `ID: MBR-${patientId}${policy.policyNumber}\n` +
                          `Group: GRP-${policy.policyNumber}\n` +
                          `Plan: ${policy.planName}\n` +
                          `Insurer: ${policy.payerName}\n` +
                          `Effective: ${policy.formattedEffectiveDate}\n` +
                          `Status: ${policy.isActive ? 'Active' : 'Active'}`;
            
            // Generate QR code
            try {
                new QRCode(qrContainer, {
                    text: qrText,
                    width: 128,
                    height: 128,
                    colorDark: "#000000",
                    colorLight: "#ffffff",
                    correctLevel: QRCode.CorrectLevel.H
                });
                
                // Remove placeholder if it exists
                if (placeholder && placeholder.parentNode === qrContainer) {
                    qrContainer.removeChild(placeholder);
                }
            } catch (error) {
                console.error('QR Code generation failed:', error);
                // Show placeholder
                qrContainer.innerHTML = `
                    <div id="qrPlaceholder">
                        <i class="fas fa-qrcode fa-3x mb-2"></i><br>
                        <small>QR Code Error</small>
                    </div>
                `;
            }
        }
        
        // Download card as PDF
        function downloadCard() {
            alert('PDF download would start here. In a real app, this would generate and download a PDF of your insurance card.');
        }
        
        // Share card
        function shareCard() {
            if (navigator.share) {
                navigator.share({
                    title: 'My Insurance Card - ' + allPolicies[currentPolicyIndex].planName,
                    text: 'Here is my digital insurance card for ' + allPolicies[currentPolicyIndex].payerName,
                    url: window.location.href
                });
            } else {
                alert('Share functionality not supported. Copy this URL: ' + window.location.href);
            }
        }
        
        // Print optimization
        window.onbeforeprint = function() {
            document.getElementById('insuranceCard').classList.remove('card-flipped');
        };
        
        // Auto-flip card every 10 seconds (optional)
        // setInterval(flipCard, 10000);
    </script>
</body>
</html>