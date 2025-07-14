#!/bin/bash

# Example Integration Script for AI Code Auditor
# This script demonstrates how to integrate the audit runner into various workflows

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT_RUNNER="$SCRIPT_DIR/../audit-runner.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Example 1: CI/CD Pipeline Integration
example_ci_cd() {
    log_info "Example 1: CI/CD Pipeline Integration"
    
    local repo_path="${1:-$SCRIPT_DIR/..}"
    local report_dir="ci-reports"
    
    # Create report directory
    mkdir -p "$report_dir"
    
    log_info "Running security audit for CI/CD pipeline..."
    if bash "$AUDIT_RUNNER" --type security --format json --output "$report_dir/security-report.json" "$repo_path"; then
        log_success "Security audit completed successfully"
        
        # Check if jq is available for JSON processing
        if command -v jq >/dev/null 2>&1; then
            local issues_found=$(jq -r '.audits[0].summary.issues_found' "$report_dir/security-report.json" 2>/dev/null || echo "0")
            if [ "$issues_found" -gt 0 ]; then
                log_warning "Security issues found: $issues_found"
                log_info "Review the security report at: $report_dir/security-report.json"
            else
                log_success "No security issues found"
            fi
        fi
    else
        log_error "Security audit failed"
        return 1
    fi
    
    log_info "Running comprehensive audit for build artifacts..."
    if bash "$AUDIT_RUNNER" --type all --format html --output "$report_dir/comprehensive-report.html" "$repo_path"; then
        log_success "Comprehensive audit completed"
        log_info "HTML report available at: $report_dir/comprehensive-report.html"
    else
        log_error "Comprehensive audit failed"
        return 1
    fi
    
    echo ""
}

# Example 2: Developer Workflow Integration
example_developer_workflow() {
    log_info "Example 2: Developer Workflow Integration"
    
    local repo_path="${1:-$SCRIPT_DIR/..}"
    local dev_reports="dev-reports"
    
    # Create report directory
    mkdir -p "$dev_reports"
    
    log_info "Running design pattern analysis..."
    if bash "$AUDIT_RUNNER" --type patterns --format markdown --output "$dev_reports/patterns-analysis.md" "$repo_path"; then
        log_success "Pattern analysis completed"
        log_info "Markdown report: $dev_reports/patterns-analysis.md"
    else
        log_error "Pattern analysis failed"
        return 1
    fi
    
    log_info "Running algorithms and data structures audit..."
    if bash "$AUDIT_RUNNER" --type algorithms --format json --output "$dev_reports/algorithms-report.json" "$repo_path"; then
        log_success "Algorithms audit completed"
        log_info "JSON report: $dev_reports/algorithms-report.json"
    else
        log_error "Algorithms audit failed"
        return 1
    fi
    
    echo ""
}

# Example 3: Security Review Integration
example_security_review() {
    log_info "Example 3: Security Review Integration"
    
    local repo_path="${1:-$SCRIPT_DIR/..}"
    local security_reports="security-reports"
    
    # Create report directory
    mkdir -p "$security_reports"
    
    log_info "Running comprehensive security audit..."
    if bash "$AUDIT_RUNNER" --type security --format html --output "$security_reports/security-audit.html" "$repo_path"; then
        log_success "Security audit completed"
        log_info "HTML report: $security_reports/security-audit.html"
    else
        log_error "Security audit failed"
        return 1
    fi
    
    log_info "Running feasibility analysis for security improvements..."
    if bash "$AUDIT_RUNNER" --type feasibility --format markdown --output "$security_reports/feasibility-analysis.md" "$repo_path"; then
        log_success "Feasibility analysis completed"
        log_info "Markdown report: $security_reports/feasibility-analysis.md"
    else
        log_error "Feasibility analysis failed"
        return 1
    fi
    
    echo ""
}

# Main function
main() {
    local repo_path="${1:-$SCRIPT_DIR/..}"
    
    log_info "AI Code Auditor Integration Examples"
    log_info "Repository: $repo_path"
    echo ""
    
    # Check if audit runner exists
    if [ ! -f "$AUDIT_RUNNER" ]; then
        log_error "Audit runner script not found: $AUDIT_RUNNER"
        exit 1
    fi
    
    # Make sure it's executable
    chmod +x "$AUDIT_RUNNER"
    
    # Run examples
    example_ci_cd "$repo_path"
    example_developer_workflow "$repo_path"
    example_security_review "$repo_path"
    
    log_success "All integration examples completed successfully!"
    log_info "Check the generated report directories for results."
    
    echo ""
    echo "Available report directories:"
    echo "  - ci-reports/"
    echo "  - dev-reports/"
    echo "  - security-reports/"
    echo ""
    echo "To clean up generated reports, run:"
    echo "  rm -rf ci-reports dev-reports security-reports"
}

# Show usage if no arguments provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 [repository_path]"
    echo ""
    echo "This script demonstrates various integration patterns for the AI Code Auditor."
    echo "If no repository path is provided, it will use the parent directory."
    echo ""
    echo "Examples:"
    echo "  $0                    # Use parent directory"
    echo "  $0 /path/to/repo     # Use specific repository"
    echo ""
    exit 0
fi

# Run main function
main "$@"