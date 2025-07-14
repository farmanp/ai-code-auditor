#!/bin/bash

# Test Suite for Audit Runner Script
# This script runs comprehensive tests to verify audit runner functionality

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUDIT_RUNNER="$SCRIPT_DIR/audit-runner.sh"
TEST_DIR="/tmp/audit-runner-tests"
TEST_REPO_DIR="$TEST_DIR/sample-repo"

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

# Setup test environment
setup_tests() {
    log_info "Setting up test environment..."
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    mkdir -p "$TEST_REPO_DIR"
    
    # Create sample repository structure
    mkdir -p "$TEST_REPO_DIR/src"
    mkdir -p "$TEST_REPO_DIR/tests"
    mkdir -p "$TEST_REPO_DIR/docs"
    
    # Create sample files
    cat > "$TEST_REPO_DIR/src/main.java" << 'EOF'
public class Main {
    private static Main instance;
    
    private Main() {}
    
    public static Main getInstance() {
        if (instance == null) {
            instance = new Main();
        }
        return instance;
    }
    
    public void doSomething() {
        System.out.println("Hello World");
    }
}
EOF

    cat > "$TEST_REPO_DIR/src/factory.py" << 'EOF'
class ProductFactory:
    def create_product(self, product_type):
        if product_type == "A":
            return ProductA()
        elif product_type == "B":
            return ProductB()
        else:
            raise ValueError("Unknown product type")

class ProductA:
    def operate(self):
        return "Product A operation"

class ProductB:
    def operate(self):
        return "Product B operation"
EOF

    cat > "$TEST_REPO_DIR/README.md" << 'EOF'
# Sample Repository

This is a sample repository for testing the audit runner.
EOF

    cat > "$TEST_REPO_DIR/package.json" << 'EOF'
{
  "name": "sample-repo",
  "version": "1.0.0",
  "dependencies": {
    "express": "^4.18.0",
    "react": "^18.0.0"
  }
}
EOF

    # Initialize git repository
    cd "$TEST_REPO_DIR"
    git init >/dev/null 2>&1
    git config user.email "test@example.com"
    git config user.name "Test User"
    git add .
    git commit -m "Initial commit" >/dev/null 2>&1
    
    cd "$SCRIPT_DIR"
    log_info "Test environment setup complete"
}

# Cleanup test environment
cleanup_tests() {
    log_info "Cleaning up test environment..."
    rm -rf "$TEST_DIR"
    rm -f "$SCRIPT_DIR/test-config.conf"
    rm -f "$SCRIPT_DIR"/test-*.json
    rm -f "$SCRIPT_DIR"/test-*.md
    rm -f "$SCRIPT_DIR"/test-*.html
    rm -f "$SCRIPT_DIR"/test-*.csv
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
    run_test "JSON output format" "bash '$AUDIT_RUNNER' --type security --format json --output test-json.json '$TEST_REPO_DIR' && [ -f test-json.json ]"
    
    # Test Markdown output
    run_test "Markdown output format" "bash '$AUDIT_RUNNER' --type patterns --format markdown --output test-markdown.md '$TEST_REPO_DIR' && [ -f test-markdown.md ]"
    
    # Test HTML output
    run_test "HTML output format" "bash '$AUDIT_RUNNER' --type algorithms --format html --output test-html.html '$TEST_REPO_DIR' && [ -f test-html.html ]"
    
    # Test CSV output
    run_test "CSV output format" "bash '$AUDIT_RUNNER' --type all --format csv --output test-csv.csv '$TEST_REPO_DIR' && [ -f test-csv.csv ]"
}

# Test audit types
test_audit_types() {
    log_info "Testing individual audit types..."
    
    # Test each audit type
    local audit_types=("security" "patterns" "algorithms" "datahub" "feasibility" "etl" "cloud" "repository")
    
    for audit_type in "${audit_types[@]}"; do
        run_test "Audit type: $audit_type" "bash '$AUDIT_RUNNER' --type '$audit_type' --format json --output 'test-$audit_type.json' '$TEST_REPO_DIR' && [ -f 'test-$audit_type.json' ]"
    done
    
    # Test all audit types
    run_test "All audit types" "bash '$AUDIT_RUNNER' --type all --format json --output test-all.json '$TEST_REPO_DIR' && [ -f test-all.json ]"
}

# Test configuration options
test_configuration_options() {
    log_info "Testing configuration options..."
    
    # Test custom config file
    run_test "Custom config file" "bash '$AUDIT_RUNNER' --config test-config.conf --type security --format json --output test-custom-config.json '$TEST_REPO_DIR' && [ -f test-custom-config.json ]"
    
    # Test report directory
    run_test "Custom report directory" "mkdir -p test-reports && bash '$AUDIT_RUNNER' --type security --report-dir test-reports --format json '$TEST_REPO_DIR' && [ -d test-reports ] && [ \$(ls test-reports/*.json | wc -l) -gt 0 ]"
    
    # Test verbose mode
    run_test "Verbose mode" "bash '$AUDIT_RUNNER' --type security --verbose --format json --output test-verbose.json '$TEST_REPO_DIR' && [ -f test-verbose.json ]"
    
    # Test quiet mode
    run_test "Quiet mode" "bash '$AUDIT_RUNNER' --type security --quiet --format json --output test-quiet.json '$TEST_REPO_DIR' && [ -f test-quiet.json ]"
}

# Test error handling
test_error_handling() {
    log_info "Testing error handling..."
    
    # Test invalid audit type
    run_test "Invalid audit type handling" "! bash '$AUDIT_RUNNER' --type invalid_type '$TEST_REPO_DIR'"
    
    # Test invalid format
    run_test "Invalid format handling" "! bash '$AUDIT_RUNNER' --type security --format invalid_format '$TEST_REPO_DIR'"
    
    # Test invalid repository path
    run_test "Invalid repository path handling" "! bash '$AUDIT_RUNNER' --type security /nonexistent/path"
    
    # Test invalid parallel jobs
    run_test "Invalid parallel jobs handling" "! bash '$AUDIT_RUNNER' --type security --jobs 0 '$TEST_REPO_DIR'"
}

# Test JSON output validation
test_json_validation() {
    log_info "Testing JSON output validation..."
    
    # Generate JSON output
    bash "$AUDIT_RUNNER" --type security --format json --output test-validation.json "$TEST_REPO_DIR" >/dev/null 2>&1
    
    if [ -f test-validation.json ]; then
        # Test if JSON is valid
        if command -v jq >/dev/null 2>&1; then
            run_test "Valid JSON output" "jq empty test-validation.json"
            
            # Test required fields
            run_test "JSON contains repository_path" "jq -e '.repository_path' test-validation.json"
            run_test "JSON contains audit_timestamp" "jq -e '.audit_timestamp' test-validation.json"
            run_test "JSON contains audit_type" "jq -e '.audit_type' test-validation.json"
            run_test "JSON contains audits array" "jq -e '.audits | type == \"array\"' test-validation.json"
        else
            log_info "jq not available, skipping JSON validation tests"
        fi
    else
        log_fail "JSON validation - output file not created"
        ((FAILED_TESTS++))
    fi
}

# Test file filtering
test_file_filtering() {
    log_info "Testing file filtering..."
    
    # Test ignore patterns
    run_test "Ignore patterns" "bash '$AUDIT_RUNNER' --type security --ignore '*.java' --format json --output test-ignore.json '$TEST_REPO_DIR' && [ -f test-ignore.json ]"
    
    # Test include patterns
    run_test "Include patterns" "bash '$AUDIT_RUNNER' --type security --include '*.py' --format json --output test-include.json '$TEST_REPO_DIR' && [ -f test-include.json ]"
    
    # Test multiple ignore patterns
    run_test "Multiple ignore patterns" "bash '$AUDIT_RUNNER' --type security --ignore '*.java' --ignore '*.py' --format json --output test-multi-ignore.json '$TEST_REPO_DIR' && [ -f test-multi-ignore.json ]"
}

# Run all tests
run_all_tests() {
    log_info "Starting audit runner test suite..."
    
    # Setup test environment
    setup_tests
    
    # Run test categories
    test_basic_functionality
    test_output_formats
    test_audit_types
    test_configuration_options
    test_error_handling
    test_json_validation
    test_file_filtering
    
    # Cleanup
    cleanup_tests
    
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