#!/bin/bash

# Test Suite for Audit Runner Script
# This script runs comprehensive tests to verify audit runner functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT_RUNNER="$SCRIPT_DIR/audit-runner.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Helper functions
log_test() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED_TESTS++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED_TESTS++))
}

log_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

# Test execution wrapper
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    ((TOTAL_TESTS++))
    log_test "$test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        log_pass "$test_name"
        return 0
    else
        log_fail "$test_name"
        return 1
    fi
}

# Test basic functionality
test_basic_functionality() {
    log_info "Testing basic functionality..."
    
    # Test help option
    run_test "Help option" "bash '$AUDIT_RUNNER' --help"
    
    # Test list types
    run_test "List audit types" "bash '$AUDIT_RUNNER' --list-types"
    
    # Test config generation
    run_test "Generate configuration" "bash '$AUDIT_RUNNER' --generate-config test-config.conf"
    
    # Test config validation
    run_test "Validate configuration" "bash '$AUDIT_RUNNER' --validate-config"
}

# Test output formats
test_output_formats() {
    log_info "Testing output formats..."
    
    # Test JSON output
    run_test "JSON output format" "bash '$AUDIT_RUNNER' --type security --format json --output test-json.json '$SCRIPT_DIR' && [ -f test-json.json ]"
    
    # Test Markdown output
    run_test "Markdown output format" "bash '$AUDIT_RUNNER' --type patterns --format markdown --output test-markdown.md '$SCRIPT_DIR' && [ -f test-markdown.md ]"
    
    # Test HTML output
    run_test "HTML output format" "bash '$AUDIT_RUNNER' --type algorithms --format html --output test-html.html '$SCRIPT_DIR' && [ -f test-html.html ]"
    
    # Test CSV output
    run_test "CSV output format" "bash '$AUDIT_RUNNER' --type all --format csv --output test-csv.csv '$SCRIPT_DIR' && [ -f test-csv.csv ]"
}

# Test audit types
test_audit_types() {
    log_info "Testing individual audit types..."
    
    # Test each audit type
    local audit_types=("security" "patterns" "algorithms" "datahub" "feasibility" "etl" "cloud" "repository")
    
    for audit_type in "${audit_types[@]}"; do
        run_test "Audit type: $audit_type" "bash '$AUDIT_RUNNER' --type '$audit_type' --format json --output 'test-$audit_type.json' '$SCRIPT_DIR' && [ -f 'test-$audit_type.json' ]"
    done
    
    # Test all audit types
    run_test "All audit types" "bash '$AUDIT_RUNNER' --type all --format json --output test-all.json '$SCRIPT_DIR' && [ -f test-all.json ]"
}

# Cleanup test files
cleanup_test_files() {
    rm -f test-*.json test-*.md test-*.html test-*.csv test-*.conf
    rm -rf test-reports
}

# Run all tests
run_all_tests() {
    log_info "Starting audit runner test suite..."
    
    # Cleanup any existing test files
    cleanup_test_files
    
    # Run test categories
    test_basic_functionality
    test_output_formats
    test_audit_types
    
    # Cleanup test files
    cleanup_test_files
    
    # Print summary
    echo ""
    echo "=========================================="
    echo "Test Summary:"
    echo "=========================================="
    echo "Total tests: $TOTAL_TESTS"
    echo "Passed: $PASSED_TESTS"
    echo "Failed: $FAILED_TESTS"
    echo "Success rate: $(( PASSED_TESTS * 100 / TOTAL_TESTS ))%"
    echo "=========================================="
    
    if [ $FAILED_TESTS -eq 0 ]; then
        log_info "All tests passed!"
        exit 0
    else
        log_info "Some tests failed. Please check the output above."
        exit 1
    fi
}

# Main execution
main() {
    # Check if audit runner exists
    if [ ! -f "$AUDIT_RUNNER" ]; then
        log_fail "Audit runner script not found: $AUDIT_RUNNER"
        exit 1
    fi
    
    # Check if audit runner is executable
    if [ ! -x "$AUDIT_RUNNER" ]; then
        log_info "Making audit runner executable..."
        chmod +x "$AUDIT_RUNNER"
    fi
    
    # Run tests
    run_all_tests
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi