// Dashboard JavaScript
let charts = {};

// Navigation functions
function showSection(sectionId) {
    // Hide all sections
    document.querySelectorAll('.section').forEach(section => {
        section.classList.remove('active');
    });
    
    // Show selected section
    document.getElementById(sectionId).classList.add('active');
    
    // Update navigation buttons
    document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    event.target.classList.add('active');
    
    // Initialize charts for the section
    setTimeout(() => {
        initializeCharts(sectionId);
    }, 100);
}

// Initialize charts based on section
function initializeCharts(sectionId) {
    switch(sectionId) {
        case 'overview':
            createOverviewChart();
            break;
        case 'security':
            createSecurityCharts();
            break;
        case 'patterns':
            createPatternCharts();
            break;
        case 'cloud':
            createCloudCharts();
            break;
        case 'trends':
            createTrendChart();
            break;
    }
}

// Overview chart
function createOverviewChart() {
    const ctx = document.getElementById('overviewChart');
    if (!ctx) return;
    
    if (charts.overview) {
        charts.overview.destroy();
    }
    
    const data = auditData.categories;
    const labels = Object.keys(data);
    const values = labels.map(label => {
        if (data[label].total_patterns) return data[label].total_patterns;
        if (data[label].total_vulnerabilities) return data[label].total_vulnerabilities;
        if (data[label].total_services) return data[label].total_services;
        return 0;
    });
    
    charts.overview = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels.map(l => l.charAt(0).toUpperCase() + l.slice(1)),
            datasets: [{
                label: 'Items Found',
                data: values,
                backgroundColor: [
                    '#3498db',
                    '#e74c3c',
                    '#f39c12',
                    '#27ae60',
                    '#9b59b6'
                ]
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

// Security charts
function createSecurityCharts() {
    createSecurityHeatmap();
    createSeverityChart();
    populateVulnerabilityList();
}

function createSecurityHeatmap() {
    const ctx = document.getElementById('securityHeatmap');
    if (!ctx || !auditData.categories.security) return;
    
    if (charts.securityHeatmap) {
        charts.securityHeatmap.destroy();
    }
    
    const data = auditData.categories.security.category_distribution;
    
    charts.securityHeatmap = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(data),
            datasets: [{
                data: Object.values(data),
                backgroundColor: [
                    '#e74c3c',
                    '#f39c12',
                    '#f1c40f',
                    '#27ae60',
                    '#3498db'
                ]
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
}

function createSeverityChart() {
    const ctx = document.getElementById('severityChart');
    if (!ctx || !auditData.categories.security) return;
    
    if (charts.severity) {
        charts.severity.destroy();
    }
    
    const data = auditData.categories.security.severity_distribution;
    
    charts.severity = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Object.keys(data),
            datasets: [{
                label: 'Vulnerabilities',
                data: Object.values(data),
                backgroundColor: [
                    '#e74c3c',
                    '#f39c12',
                    '#f1c40f',
                    '#27ae60'
                ]
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

function populateVulnerabilityList() {
    const container = document.getElementById('vulnerabilityList');
    if (!container || !auditData.categories.security) return;
    
    const vulnerabilities = auditData.categories.security.vulnerabilities;
    
    container.innerHTML = vulnerabilities.map(vuln => `
        <div class="vulnerability-item">
            <div class="item-info">
                <div class="item-title">${vuln.name}</div>
                <div class="item-description">${vuln.description}</div>
                <div class="item-description">Files: ${vuln.files_affected.join(', ')}</div>
            </div>
            <div class="item-badge severity-${vuln.severity.toLowerCase()}">${vuln.severity}</div>
        </div>
    `).join('');
}

// Pattern charts
function createPatternCharts() {
    createPatternChart();
    createComplexityChart();
    populatePatternList();
}

function createPatternChart() {
    const ctx = document.getElementById('patternChart');
    if (!ctx || !auditData.categories.patterns) return;
    
    if (charts.pattern) {
        charts.pattern.destroy();
    }
    
    const data = auditData.categories.patterns.category_distribution;
    
    charts.pattern = new Chart(ctx, {
        type: 'pie',
        data: {
            labels: Object.keys(data),
            datasets: [{
                data: Object.values(data),
                backgroundColor: [
                    '#3498db',
                    '#9b59b6',
                    '#e67e22',
                    '#27ae60',
                    '#f39c12'
                ]
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
}

function createComplexityChart() {
    const ctx = document.getElementById('complexityChart');
    if (!ctx || !auditData.categories.patterns) return;
    
    if (charts.complexity) {
        charts.complexity.destroy();
    }
    
    const data = auditData.categories.patterns.complexity_distribution;
    
    charts.complexity = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: Object.keys(data),
            datasets: [{
                label: 'Patterns',
                data: Object.values(data),
                backgroundColor: [
                    '#27ae60',
                    '#f39c12',
                    '#e74c3c'
                ]
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

function populatePatternList() {
    const container = document.getElementById('patternList');
    if (!container || !auditData.categories.patterns) return;
    
    const patterns = auditData.categories.patterns.patterns;
    
    container.innerHTML = patterns.map(pattern => `
        <div class="pattern-item">
            <div class="item-info">
                <div class="item-title">${pattern.name}</div>
                <div class="item-description">Quality Score: ${pattern.quality_score}%</div>
                <div class="item-description">Files: ${pattern.files.join(', ')}</div>
            </div>
            <div class="item-badge category-${pattern.category}">${pattern.category}</div>
        </div>
    `).join('');
}

// Cloud charts
function createCloudCharts() {
    createCloudChart();
    populateServiceList();
}

function createCloudChart() {
    const ctx = document.getElementById('cloudChart');
    if (!ctx || !auditData.categories.cloud) return;
    
    if (charts.cloud) {
        charts.cloud.destroy();
    }
    
    const data = auditData.categories.cloud.provider_distribution;
    
    charts.cloud = new Chart(ctx, {
        type: 'radar',
        data: {
            labels: Object.keys(data),
            datasets: [{
                label: 'Services',
                data: Object.values(data),
                backgroundColor: 'rgba(52, 152, 219, 0.2)',
                borderColor: '#3498db',
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            scales: {
                r: {
                    beginAtZero: true
                }
            }
        }
    });
}

function populateServiceList() {
    const container = document.getElementById('serviceList');
    if (!container || !auditData.categories.cloud) return;
    
    const services = auditData.categories.cloud.services;
    
    container.innerHTML = services.map(service => `
        <div class="service-item">
            <div class="item-info">
                <div class="item-title">${service.name}</div>
                <div class="item-description">Cost: ${service.cost_estimate}</div>
                <div class="item-description">Instances: ${service.instances}</div>
            </div>
            <div class="item-badge category-${service.provider}">${service.provider.toUpperCase()}</div>
        </div>
    `).join('');
}

// Trend chart
function createTrendChart() {
    const ctx = document.getElementById('trendChart');
    if (!ctx) return;
    
    if (charts.trend) {
        charts.trend.destroy();
    }
    
    const timeSeriesData = auditData.time_series;
    
    charts.trend = new Chart(ctx, {
        type: 'line',
        data: {
            labels: timeSeriesData.map(d => d.date),
            datasets: [
                {
                    label: 'Vulnerabilities',
                    data: timeSeriesData.map(d => d.vulnerabilities),
                    borderColor: '#e74c3c',
                    backgroundColor: 'rgba(231, 76, 60, 0.1)',
                    fill: false
                },
                {
                    label: 'Patterns',
                    data: timeSeriesData.map(d => d.patterns),
                    borderColor: '#3498db',
                    backgroundColor: 'rgba(52, 152, 219, 0.1)',
                    fill: false
                },
                {
                    label: 'Issues',
                    data: timeSeriesData.map(d => d.issues),
                    borderColor: '#f39c12',
                    backgroundColor: 'rgba(243, 156, 18, 0.1)',
                    fill: false
                }
            ]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

// Export functions
function exportData(format) {
    if (format === 'json') {
        const dataStr = JSON.stringify(auditData, null, 2);
        const dataUri = 'data:application/json;charset=utf-8,'+ encodeURIComponent(dataStr);
        
        const exportFileDefaultName = 'audit-data.json';
        
        const linkElement = document.createElement('a');
        linkElement.setAttribute('href', dataUri);
        linkElement.setAttribute('download', exportFileDefaultName);
        linkElement.click();
    } else if (format === 'pdf') {
        window.print();
    }
}

// Filter function
function filterData() {
    const searchTerm = document.getElementById('searchFilter').value.toLowerCase();
    // Implementation for filtering would go here
    console.log('Filtering data with term:', searchTerm);
}

// Initialize dashboard
document.addEventListener('DOMContentLoaded', function() {
    // Initialize overview charts by default
    setTimeout(() => {
        initializeCharts('overview');
    }, 100);
    
    // Update summary statistics
    updateSummaryStats();
});

function updateSummaryStats() {
    const categories = auditData.categories;
    let totalPatterns = 0;
    let totalVulnerabilities = 0;
    let totalIssues = 0;
    
    Object.values(categories).forEach(category => {
        if (category.total_patterns) totalPatterns += category.total_patterns;
        if (category.total_vulnerabilities) totalVulnerabilities += category.total_vulnerabilities;
        if (category.total_services) totalIssues += category.total_services;
    });
    
    auditData.summary.total_patterns = totalPatterns;
    auditData.summary.total_vulnerabilities = totalVulnerabilities;
    auditData.summary.total_issues = totalIssues;
    
    // Update the display
    document.querySelectorAll('.stat-value').forEach((element, index) => {
        switch(index) {
            case 0: element.textContent = totalPatterns; break;
            case 1: element.textContent = totalVulnerabilities; break;
            case 2: element.textContent = totalIssues; break;
        }
    });
}
