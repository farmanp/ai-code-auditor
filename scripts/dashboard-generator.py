#!/usr/bin/env python3
"""
Audit Report Dashboard Generator
Generates an interactive dashboard for comprehensive codebase analysis.
"""

import json
import yaml
import os
import sys
from datetime import datetime
from pathlib import Path
import argparse
from typing import Dict, List, Any, Optional
import shutil

class DashboardGenerator:
    """Main dashboard generator class."""
    
    def __init__(self, output_dir: str = "audit-dashboard"):
        """Initialize the dashboard generator."""
        self.output_dir = Path(output_dir)
        self.script_dir = Path(__file__).parent
        self.repo_root = self.script_dir.parent
        self.specs_dir = self.repo_root / "specs"
        self.templates_dir = self.repo_root / "templates"
        
        # Dashboard structure
        self.dashboard_structure = {
            "assets": ["css", "js"],
            "data": [],
            "reports": []
        }
        
    def load_specs(self) -> Dict[str, Any]:
        """Load all specification files."""
        specs = {}
        
        spec_files = {
            "design_patterns": "design-patterns-spec.yaml",
            "security_vulnerabilities": "security-vulnerabilities-spec.yaml",
            "algorithms_data_structures": "algorithms-data-structures-spec.yaml",
            "cloud_architecture": "cloud-architecture-spec.yaml",
            "etl_subsystems": "etl-subsystems-spec.yaml",
            "feasibility_analysis": "feasibility-analysis-spec.yaml",
            "datahub": "datahub-spec.yaml",
            "repo_discovery": "repo-discovery-spec.yaml"
        }
        
        for spec_name, spec_file in spec_files.items():
            spec_path = self.specs_dir / spec_file
            if spec_path.exists():
                try:
                    with open(spec_path, 'r') as f:
                        specs[spec_name] = yaml.safe_load(f)
                except Exception as e:
                    print(f"Warning: Could not load {spec_file}: {e}")
                    
        return specs
    
    def create_directory_structure(self):
        """Create the dashboard directory structure."""
        # Create main directory
        self.output_dir.mkdir(exist_ok=True)
        
        # Create subdirectories
        for main_dir, sub_dirs in self.dashboard_structure.items():
            main_path = self.output_dir / main_dir
            main_path.mkdir(exist_ok=True)
            
            for sub_dir in sub_dirs:
                sub_path = main_path / sub_dir
                sub_path.mkdir(exist_ok=True)
    
    def generate_sample_audit_data(self, specs: Dict[str, Any]) -> Dict[str, Any]:
        """Generate sample audit data structure."""
        audit_data = {
            "metadata": {
                "generated_at": datetime.now().isoformat(),
                "version": "1.0.0",
                "repository": "sample-repository",
                "analysis_types": list(specs.keys())
            },
            "summary": {
                "total_patterns": 0,
                "total_vulnerabilities": 0,
                "total_issues": 0,
                "risk_level": "medium"
            },
            "time_series": [
                {
                    "date": "2024-01-01",
                    "vulnerabilities": 15,
                    "patterns": 25,
                    "issues": 40
                },
                {
                    "date": "2024-01-15",
                    "vulnerabilities": 12,
                    "patterns": 28,
                    "issues": 35
                },
                {
                    "date": "2024-02-01",
                    "vulnerabilities": 8,
                    "patterns": 30,
                    "issues": 28
                }
            ],
            "categories": {}
        }
        
        # Generate category data based on specs
        for spec_name, spec_data in specs.items():
            if spec_name == "security_vulnerabilities" and "vulnerabilities" in spec_data:
                audit_data["categories"]["security"] = self._generate_security_data(spec_data["vulnerabilities"])
            elif spec_name == "design_patterns" and "patterns" in spec_data:
                audit_data["categories"]["patterns"] = self._generate_pattern_data(spec_data["patterns"])
            elif spec_name == "cloud_architecture" and "cloud_services" in spec_data:
                audit_data["categories"]["cloud"] = self._generate_cloud_data(spec_data["cloud_services"])
        
        return audit_data
    
    def _generate_security_data(self, vulnerabilities: List[Dict]) -> Dict[str, Any]:
        """Generate security vulnerability data."""
        security_data = {
            "total_vulnerabilities": len(vulnerabilities),
            "severity_distribution": {
                "critical": 3,
                "high": 8,
                "medium": 15,
                "low": 12
            },
            "category_distribution": {},
            "vulnerabilities": []
        }
        
        # Generate category distribution
        categories = {}
        for vuln in vulnerabilities:
            category = vuln.get("category", "unknown")
            categories[category] = categories.get(category, 0) + 1
        
        security_data["category_distribution"] = categories
        
        # Generate sample vulnerability instances
        for i, vuln in enumerate(vulnerabilities[:10]):  # Limit to first 10
            security_data["vulnerabilities"].append({
                "name": vuln["name"],
                "category": vuln.get("category", "unknown"),
                "severity": vuln.get("severity", "medium"),
                "description": vuln.get("description", "No description available"),
                "instances": i + 1,
                "files_affected": [f"src/file_{i+1}.py", f"src/module_{i+1}.py"]
            })
        
        return security_data
    
    def _generate_pattern_data(self, patterns: List[Dict]) -> Dict[str, Any]:
        """Generate design pattern data."""
        pattern_data = {
            "total_patterns": len(patterns),
            "category_distribution": {},
            "complexity_distribution": {
                "low": 8,
                "medium": 12,
                "high": 5
            },
            "patterns": []
        }
        
        # Generate category distribution
        categories = {}
        for pattern in patterns:
            category = pattern.get("category", "unknown")
            categories[category] = categories.get(category, 0) + 1
        
        pattern_data["category_distribution"] = categories
        
        # Generate sample pattern instances
        for i, pattern in enumerate(patterns[:10]):  # Limit to first 10
            pattern_data["patterns"].append({
                "name": pattern["name"],
                "category": pattern.get("category", "unknown"),
                "instances": i + 2,
                "quality_score": 85 - (i * 2),
                "files": [f"src/pattern_{i+1}.py"]
            })
        
        return pattern_data
    
    def _generate_cloud_data(self, cloud_services: List[Dict]) -> Dict[str, Any]:
        """Generate cloud service data."""
        cloud_data = {
            "total_services": len(cloud_services),
            "provider_distribution": {
                "aws": 12,
                "azure": 8,
                "gcp": 5
            },
            "services": []
        }
        
        # Generate sample service instances
        for i, service in enumerate(cloud_services[:10]):  # Limit to first 10
            cloud_data["services"].append({
                "name": service["name"],
                "provider": service.get("provider", "aws"),
                "instances": i + 1,
                "cost_estimate": f"${(i + 1) * 50}/month"
            })
        
        return cloud_data
    
    def generate_main_dashboard(self, audit_data: Dict[str, Any]):
        """Generate the main dashboard HTML file."""
        html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Code Auditor Dashboard</title>
    <link rel="stylesheet" href="assets/css/dashboard.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/date-fns@2.29.3/index.min.js"></script>
</head>
<body>
    <div class="dashboard-container">
        <header class="dashboard-header">
            <h1>AI Code Auditor Dashboard</h1>
            <div class="header-info">
                <span>Repository: {audit_data['metadata']['repository']}</span>
                <span>Generated: {audit_data['metadata']['generated_at'][:10]}</span>
            </div>
        </header>
        
        <nav class="dashboard-nav">
            <button class="nav-btn active" onclick="showSection('overview')">Overview</button>
            <button class="nav-btn" onclick="showSection('security')">Security</button>
            <button class="nav-btn" onclick="showSection('patterns')">Patterns</button>
            <button class="nav-btn" onclick="showSection('cloud')">Cloud</button>
            <button class="nav-btn" onclick="showSection('trends')">Trends</button>
        </nav>
        
        <main class="dashboard-main">
            <!-- Overview Section -->
            <section id="overview" class="section active">
                <h2>Overview</h2>
                <div class="stats-grid">
                    <div class="stat-card">
                        <h3>Total Patterns</h3>
                        <div class="stat-value">{audit_data['summary']['total_patterns']}</div>
                    </div>
                    <div class="stat-card">
                        <h3>Vulnerabilities</h3>
                        <div class="stat-value">{audit_data['summary']['total_vulnerabilities']}</div>
                    </div>
                    <div class="stat-card">
                        <h3>Issues</h3>
                        <div class="stat-value">{audit_data['summary']['total_issues']}</div>
                    </div>
                    <div class="stat-card">
                        <h3>Risk Level</h3>
                        <div class="stat-value risk-{audit_data['summary']['risk_level']}">{audit_data['summary']['risk_level'].upper()}</div>
                    </div>
                </div>
                
                <div class="chart-container">
                    <canvas id="overviewChart"></canvas>
                </div>
            </section>
            
            <!-- Security Section -->
            <section id="security" class="section">
                <h2>Security Analysis</h2>
                <div class="section-content">
                    <div class="chart-grid">
                        <div class="chart-container">
                            <h3>Vulnerability Heatmap</h3>
                            <canvas id="securityHeatmap"></canvas>
                        </div>
                        <div class="chart-container">
                            <h3>Severity Distribution</h3>
                            <canvas id="severityChart"></canvas>
                        </div>
                    </div>
                    <div class="vulnerability-list">
                        <h3>Top Vulnerabilities</h3>
                        <div id="vulnerabilityList"></div>
                    </div>
                </div>
            </section>
            
            <!-- Patterns Section -->
            <section id="patterns" class="section">
                <h2>Design Patterns Analysis</h2>
                <div class="section-content">
                    <div class="chart-grid">
                        <div class="chart-container">
                            <h3>Pattern Distribution</h3>
                            <canvas id="patternChart"></canvas>
                        </div>
                        <div class="chart-container">
                            <h3>Complexity Analysis</h3>
                            <canvas id="complexityChart"></canvas>
                        </div>
                    </div>
                    <div class="pattern-list">
                        <h3>Detected Patterns</h3>
                        <div id="patternList"></div>
                    </div>
                </div>
            </section>
            
            <!-- Cloud Section -->
            <section id="cloud" class="section">
                <h2>Cloud Architecture Analysis</h2>
                <div class="section-content">
                    <div class="chart-container">
                        <h3>Cloud Service Usage</h3>
                        <canvas id="cloudChart"></canvas>
                    </div>
                    <div class="cloud-services">
                        <h3>Services Detected</h3>
                        <div id="serviceList"></div>
                    </div>
                </div>
            </section>
            
            <!-- Trends Section -->
            <section id="trends" class="section">
                <h2>Technical Debt Trends</h2>
                <div class="section-content">
                    <div class="chart-container">
                        <h3>Trend Analysis</h3>
                        <canvas id="trendChart"></canvas>
                    </div>
                    <div class="trend-controls">
                        <button onclick="exportData('json')">Export JSON</button>
                        <button onclick="exportData('pdf')">Export PDF</button>
                        <input type="text" id="searchFilter" placeholder="Search..." onkeyup="filterData()">
                    </div>
                </div>
            </section>
        </main>
    </div>
    
    <script>
        // Audit data
        const auditData = {json.dumps(audit_data, indent=2)};
    </script>
    <script src="assets/js/dashboard.js"></script>
</body>
</html>"""
        
        # Write the HTML file
        with open(self.output_dir / "index.html", "w") as f:
            f.write(html_content)
    
    def generate_css(self):
        """Generate the CSS file for the dashboard."""
        css_content = """/* Dashboard CSS */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #f5f5f5;
    color: #333;
}

.dashboard-container {
    max-width: 1200px;
    margin: 0 auto;
    background: white;
    min-height: 100vh;
    box-shadow: 0 0 20px rgba(0,0,0,0.1);
}

.dashboard-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 2rem;
    text-align: center;
}

.dashboard-header h1 {
    font-size: 2.5rem;
    margin-bottom: 1rem;
}

.header-info {
    display: flex;
    justify-content: center;
    gap: 2rem;
    font-size: 1.1rem;
}

.dashboard-nav {
    background: #2c3e50;
    padding: 0;
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
}

.nav-btn {
    background: none;
    border: none;
    color: white;
    padding: 1rem 2rem;
    cursor: pointer;
    font-size: 1rem;
    transition: background-color 0.3s;
}

.nav-btn:hover {
    background: #34495e;
}

.nav-btn.active {
    background: #3498db;
}

.dashboard-main {
    padding: 2rem;
}

.section {
    display: none;
}

.section.active {
    display: block;
}

.section h2 {
    color: #2c3e50;
    margin-bottom: 2rem;
    font-size: 2rem;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.stat-card {
    background: white;
    padding: 1.5rem;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    text-align: center;
    border-left: 4px solid #3498db;
}

.stat-card h3 {
    color: #7f8c8d;
    font-size: 0.9rem;
    margin-bottom: 0.5rem;
    text-transform: uppercase;
}

.stat-value {
    font-size: 2rem;
    font-weight: bold;
    color: #2c3e50;
}

.stat-value.risk-high {
    color: #e74c3c;
}

.stat-value.risk-medium {
    color: #f39c12;
}

.stat-value.risk-low {
    color: #27ae60;
}

.chart-container {
    background: white;
    padding: 1.5rem;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    margin-bottom: 2rem;
}

.chart-container h3 {
    color: #2c3e50;
    margin-bottom: 1rem;
    font-size: 1.2rem;
}

.chart-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.vulnerability-list,
.pattern-list,
.cloud-services {
    background: white;
    padding: 1.5rem;
    border-radius: 8px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.vulnerability-list h3,
.pattern-list h3,
.cloud-services h3 {
    color: #2c3e50;
    margin-bottom: 1rem;
    font-size: 1.2rem;
}

.vulnerability-item,
.pattern-item,
.service-item {
    padding: 1rem;
    border-bottom: 1px solid #ecf0f1;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.vulnerability-item:last-child,
.pattern-item:last-child,
.service-item:last-child {
    border-bottom: none;
}

.item-info {
    flex: 1;
}

.item-title {
    font-weight: bold;
    color: #2c3e50;
    margin-bottom: 0.25rem;
}

.item-description {
    color: #7f8c8d;
    font-size: 0.9rem;
}

.item-badge {
    padding: 0.25rem 0.75rem;
    border-radius: 20px;
    font-size: 0.8rem;
    font-weight: bold;
    text-transform: uppercase;
}

.severity-critical {
    background: #e74c3c;
    color: white;
}

.severity-high {
    background: #f39c12;
    color: white;
}

.severity-medium {
    background: #f1c40f;
    color: #2c3e50;
}

.severity-low {
    background: #27ae60;
    color: white;
}

.category-creational {
    background: #3498db;
    color: white;
}

.category-structural {
    background: #9b59b6;
    color: white;
}

.category-behavioral {
    background: #e67e22;
    color: white;
}

.trend-controls {
    margin-top: 2rem;
    display: flex;
    gap: 1rem;
    align-items: center;
    flex-wrap: wrap;
}

.trend-controls button {
    background: #3498db;
    color: white;
    border: none;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: background-color 0.3s;
}

.trend-controls button:hover {
    background: #2980b9;
}

.trend-controls input {
    padding: 0.5rem;
    border: 1px solid #bdc3c7;
    border-radius: 4px;
    font-size: 0.9rem;
}

@media (max-width: 768px) {
    .dashboard-header h1 {
        font-size: 2rem;
    }
    
    .header-info {
        flex-direction: column;
        gap: 0.5rem;
    }
    
    .dashboard-nav {
        flex-direction: column;
    }
    
    .nav-btn {
        padding: 0.75rem 1rem;
    }
    
    .chart-grid {
        grid-template-columns: 1fr;
    }
    
    .stats-grid {
        grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    }
}
"""
        
        # Write the CSS file
        css_path = self.output_dir / "assets" / "css" / "dashboard.css"
        with open(css_path, "w") as f:
            f.write(css_content)
    
    def generate_javascript(self):
        """Generate the JavaScript file for the dashboard."""
        js_content = """// Dashboard JavaScript
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
"""
        
        # Write the JavaScript file
        js_path = self.output_dir / "assets" / "js" / "dashboard.js"
        with open(js_path, "w") as f:
            f.write(js_content)
    
    def generate_audit_data_file(self, audit_data: Dict[str, Any]):
        """Generate the audit data JSON file."""
        data_path = self.output_dir / "data" / "audit-results.json"
        with open(data_path, "w") as f:
            json.dump(audit_data, f, indent=2)
    
    def generate_report_pages(self):
        """Generate individual report pages."""
        reports = {
            "security": "Security Analysis Report",
            "patterns": "Design Patterns Report",
            "cloud": "Cloud Architecture Report"
        }
        
        for report_type, title in reports.items():
            html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{title}</title>
    <link rel="stylesheet" href="../assets/css/dashboard.css">
</head>
<body>
    <div class="dashboard-container">
        <header class="dashboard-header">
            <h1>{title}</h1>
            <div class="header-info">
                <a href="../index.html" style="color: white; text-decoration: none;">← Back to Dashboard</a>
            </div>
        </header>
        
        <main class="dashboard-main">
            <section class="section active">
                <h2>{title}</h2>
                <p>Detailed {report_type} analysis would be displayed here.</p>
                <p>This page would contain comprehensive information about {report_type} findings.</p>
            </section>
        </main>
    </div>
</body>
</html>"""
            
            report_path = self.output_dir / "reports" / f"{report_type}.html"
            with open(report_path, "w") as f:
                f.write(html_content)
    
    def generate_deployment_guide(self):
        """Generate deployment guide."""
        guide_content = """# Audit Report Dashboard Deployment Guide

## Overview
This dashboard provides an interactive interface for viewing AI Code Auditor results. It's built as a static HTML/CSS/JavaScript application that can be deployed anywhere.

## Directory Structure
```
audit-dashboard/
├── index.html              # Main dashboard page
├── assets/
│   ├── css/
│   │   └── dashboard.css   # Dashboard styles
│   └── js/
│       └── dashboard.js    # Dashboard functionality
├── data/
│   └── audit-results.json  # Audit data
└── reports/
    ├── security.html       # Security report page
    ├── patterns.html       # Patterns report page
    └── cloud.html          # Cloud report page
```

## Deployment Options

### 1. Local Development
```bash
# Navigate to the dashboard directory
cd audit-dashboard

# Start a simple HTTP server
python -m http.server 8000

# Or use Node.js
npx http-server -p 8000

# Open browser to http://localhost:8000
```

### 2. Static Hosting (Netlify, Vercel, GitHub Pages)
1. Upload the entire `audit-dashboard` directory to your hosting provider
2. Set `index.html` as the main page
3. No server-side processing required

### 3. Web Server (Apache, Nginx)
1. Copy the `audit-dashboard` directory to your web server's document root
2. Configure your web server to serve static files
3. No special configuration needed

## Customization

### Adding New Data
1. Update `data/audit-results.json` with new audit results
2. The dashboard will automatically load and display the new data

### Modifying Visualizations
1. Edit `assets/js/dashboard.js` to customize charts
2. Chart.js is used for visualizations - see their documentation for options

### Styling Changes
1. Edit `assets/css/dashboard.css` to modify the appearance
2. The dashboard uses responsive design principles

## Features

### Interactive Elements
- Navigation between different analysis sections
- Drill-down capabilities for detailed views
- Search and filter functionality
- Export options (JSON, PDF)

### Visualizations
- Security vulnerability heatmap
- Pattern distribution charts
- Complexity metrics graphs
- Cloud service usage diagrams
- Technical debt trends

### Responsive Design
- Works on desktop, tablet, and mobile devices
- Optimized for different screen sizes

## Browser Support
- Chrome/Chromium 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## Dependencies
- Chart.js (loaded via CDN)
- No other external dependencies required

## Security Considerations
- All data is processed client-side
- No server-side processing or data storage
- Audit data is included in the static files

## Troubleshooting

### Charts Not Displaying
- Check browser console for JavaScript errors
- Ensure Chart.js is loading properly
- Verify audit data format is correct

### Data Not Loading
- Check that `audit-results.json` exists and is valid JSON
- Verify file paths are correct
- Check browser network tab for failed requests

### Responsive Issues
- Test on different devices and browsers
- Check CSS media queries
- Verify viewport meta tag is present

## Future Enhancements
- Real-time data updates
- More visualization types
- Advanced filtering options
- Multi-repository support
- Historical data comparison
"""
        
        guide_path = self.output_dir / "DEPLOYMENT.md"
        with open(guide_path, "w") as f:
            f.write(guide_content)
    
    def generate_dashboard(self):
        """Generate the complete dashboard."""
        print("Generating Audit Report Dashboard...")
        
        # Create directory structure
        self.create_directory_structure()
        print("✓ Created directory structure")
        
        # Load specifications
        specs = self.load_specs()
        print(f"✓ Loaded {len(specs)} specifications")
        
        # Generate sample audit data
        audit_data = self.generate_sample_audit_data(specs)
        print("✓ Generated sample audit data")
        
        # Generate dashboard files
        self.generate_main_dashboard(audit_data)
        print("✓ Generated main dashboard HTML")
        
        self.generate_css()
        print("✓ Generated CSS styles")
        
        self.generate_javascript()
        print("✓ Generated JavaScript functionality")
        
        self.generate_audit_data_file(audit_data)
        print("✓ Generated audit data file")
        
        self.generate_report_pages()
        print("✓ Generated report pages")
        
        self.generate_deployment_guide()
        print("✓ Generated deployment guide")
        
        print(f"\nDashboard generated successfully in: {self.output_dir}")
        print("Open index.html in your browser to view the dashboard.")

def main():
    """Main function."""
    parser = argparse.ArgumentParser(description="Generate AI Code Auditor Dashboard")
    parser.add_argument(
        "--output-dir", 
        default="audit-dashboard",
        help="Output directory for the dashboard (default: audit-dashboard)"
    )
    parser.add_argument(
        "--specs-dir",
        help="Directory containing specification files (default: auto-detect)"
    )
    
    args = parser.parse_args()
    
    # Create generator instance
    generator = DashboardGenerator(args.output_dir)
    
    # Override specs directory if provided
    if args.specs_dir:
        generator.specs_dir = Path(args.specs_dir)
    
    # Generate the dashboard
    try:
        generator.generate_dashboard()
    except Exception as e:
        print(f"Error generating dashboard: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()