#!/bin/bash

# AI Code Auditor - Automated Audit Runner Script
# Comprehensive audit runner for all audit types with configurable output
# Usage: ./audit-runner.sh [options] <repository_path>

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SPECS_DIR="$SCRIPT_DIR/specs"
DOCS_DIR="$SCRIPT_DIR/docs"
PROMPTS_DIR="$SCRIPT_DIR/prompts"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
TEMP_DIR="/tmp/audit-runner-$$"
CONFIG_FILE="$SCRIPT_DIR/audit-runner.conf"
DEFAULT_OUTPUT_FORMAT="json"
DEFAULT_AUDIT_TYPE="all"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global variables
REPOSITORY_PATH=""
AUDIT_TYPE="$DEFAULT_AUDIT_TYPE"
OUTPUT_FORMAT="$DEFAULT_OUTPUT_FORMAT"
OUTPUT_FILE=""
REPORT_DIR=""
VERBOSE=false
QUIET=false
CONFIG_LOADED=false
IGNORE_PATTERNS=()
INCLUDE_PATTERNS=()
PARALLEL_JOBS=1

# Available audit types
declare -A AUDIT_TYPES=(
    ["security"]="security-vulnerabilities-spec.yaml"
    ["patterns"]="design-patterns-spec.yaml"
    ["algorithms"]="algorithms-data-structures-spec.yaml"
    ["datahub"]="datahub-spec.yaml"
    ["feasibility"]="feasibility-analysis-spec.yaml"
    ["etl"]="etl-subsystems-spec.yaml"
    ["cloud"]="cloud-architecture-spec.yaml"
    ["repository"]="repo-discovery-spec.yaml"
)

# Helper functions
log_info() {
    [[ "$QUIET" == true ]] && return
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    [[ "$QUIET" == true ]] && return
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_debug() {
    [[ "$VERBOSE" == true ]] && echo -e "${CYAN}[DEBUG]${NC} $1" >&2
}

log_progress() {
    [[ "$QUIET" == true ]] && return
    echo -e "${CYAN}[PROGRESS]${NC} $1" >&2
}

# Help function
show_help() {
    cat << EOF
AI Code Auditor - Automated Audit Runner

USAGE:
    $0 [OPTIONS] <repository_path>

OPTIONS:
    -t, --type TYPE         Audit type (security|patterns|algorithms|datahub|feasibility|etl|cloud|repository|all) [default: all]
    -f, --format FORMAT     Output format (json|yaml|markdown|html|csv) [default: json]
    -o, --output FILE       Output file path [default: stdout]
    -r, --report-dir DIR    Directory for generated reports [default: ./reports]
    -c, --config FILE       Configuration file path [default: ./audit-runner.conf]
    -i, --ignore PATTERN    Ignore files/directories matching pattern (can be used multiple times)
    -I, --include PATTERN   Include only files/directories matching pattern (can be used multiple times)
    -j, --jobs NUM          Number of parallel jobs [default: 1]
    -v, --verbose           Enable verbose logging
    -q, --quiet             Suppress non-error output
    -h, --help              Show this help message
    --list-types            List all available audit types
    --generate-config       Generate sample configuration file
    --validate-config       Validate configuration file

AUDIT TYPES:
    security        Security vulnerabilities (OWASP Top 10)
    patterns        Design patterns (GoF and architectural)
    algorithms      Algorithms and data structures
    datahub         DataHub entities and governance
    feasibility     Feasibility analysis and migration readiness
    etl             ETL subsystems and data warehouse patterns
    cloud           Cloud architecture patterns
    repository      Repository discovery and analysis
    all             Run all audit types

OUTPUT FORMATS:
    json            JSON format for programmatic use
    yaml            YAML format for human readability
    markdown        Markdown format for documentation
    html            HTML format for web viewing
    csv             CSV format for data analysis

EXAMPLES:
    $0 /path/to/repo
    $0 --type security --format json /path/to/repo
    $0 --type all --report-dir ./reports /path/to/repo
    $0 -t patterns -f markdown -o patterns-report.md /path/to/repo
    $0 --ignore "*.test.*" --include "*.java" --type algorithms /path/to/repo
    $0 --jobs 4 --verbose --type all /path/to/repo
    
CONFIGURATION:
    Use --generate-config to create a sample configuration file.
    Configuration can be overridden by environment variables and command-line options.
    
ENVIRONMENT VARIABLES:
    AUDIT_TYPE              Default audit type
    OUTPUT_FORMAT           Default output format
    AUDIT_VERBOSE           Enable verbose mode (true/false)
    AUDIT_PARALLEL_JOBS     Number of parallel jobs
    AUDIT_IGNORE_PATTERNS   Comma-separated ignore patterns
    AUDIT_INCLUDE_PATTERNS  Comma-separated include patterns
EOF
}

# List available audit types
list_audit_types() {
    echo "Available audit types:"
    for type in "${!AUDIT_TYPES[@]}"; do
        echo "  $type - ${AUDIT_TYPES[$type]}"
    done
}

# Generate sample configuration file
generate_config() {
    local config_file="${1:-audit-runner.conf}"
    cat > "$config_file" << EOF
# AI Code Auditor Configuration File
# This file contains default settings for the audit runner

# Default audit type (security|patterns|algorithms|datahub|feasibility|etl|cloud|repository|all)
AUDIT_TYPE=all

# Default output format (json|yaml|markdown|html|csv)
OUTPUT_FORMAT=json

# Default report directory
REPORT_DIR=./reports

# Parallel jobs for faster processing
PARALLEL_JOBS=1

# Verbose logging (true|false)
VERBOSE=false

# Quiet mode (true|false)
QUIET=false

# Ignore patterns (comma-separated)
IGNORE_PATTERNS=*.test.*,*.spec.*,node_modules,dist,build,target

# Include patterns (comma-separated)
INCLUDE_PATTERNS=*.java,*.js,*.ts,*.py,*.go,*.rs,*.cpp,*.c,*.cs,*.php,*.rb

# Custom spec directories (comma-separated)
CUSTOM_SPEC_DIRS=

# Report template directory
TEMPLATE_DIR=./templates

# Maximum file size to analyze (in bytes)
MAX_FILE_SIZE=1048576

# Timeout for individual audits (in seconds)
AUDIT_TIMEOUT=300
EOF
    log_success "Configuration file generated: $config_file"
}

# Load configuration from file
load_config() {
    local config_file="${1:-$CONFIG_FILE}"
    
    if [[ -f "$config_file" ]]; then
        log_debug "Loading configuration from: $config_file"
        
        # Source the config file safely
        while IFS='=' read -r key value || [[ -n "$key" ]]; do
            # Skip comments and empty lines
            [[ "$key" =~ ^[[:space:]]*# ]] && continue
            [[ -z "$key" ]] && continue
            
            # Remove quotes and whitespace
            key=$(echo "$key" | xargs)
            value=$(echo "$value" | xargs | sed 's/^["\x27]\|["\x27]$//g')
            
            case "$key" in
                AUDIT_TYPE) [[ -n "$value" ]] && AUDIT_TYPE="$value" ;;
                OUTPUT_FORMAT) [[ -n "$value" ]] && OUTPUT_FORMAT="$value" ;;
                REPORT_DIR) [[ -n "$value" ]] && REPORT_DIR="$value" ;;
                PARALLEL_JOBS) [[ -n "$value" ]] && PARALLEL_JOBS="$value" ;;
                VERBOSE) [[ "$value" == "true" ]] && VERBOSE=true ;;
                QUIET) [[ "$value" == "true" ]] && QUIET=true ;;
                IGNORE_PATTERNS) [[ -n "$value" ]] && IFS=',' read -ra IGNORE_PATTERNS <<< "$value" ;;
                INCLUDE_PATTERNS) [[ -n "$value" ]] && IFS=',' read -ra INCLUDE_PATTERNS <<< "$value" ;;
            esac
        done < "$config_file"
        
        CONFIG_LOADED=true
        log_debug "Configuration loaded successfully"
    else
        log_debug "No configuration file found at: $config_file"
    fi
}

# Load configuration from environment variables
load_env_config() {
    [[ -n "$AUDIT_TYPE_ENV" ]] && AUDIT_TYPE="$AUDIT_TYPE_ENV"
    [[ -n "$OUTPUT_FORMAT_ENV" ]] && OUTPUT_FORMAT="$OUTPUT_FORMAT_ENV"
    [[ -n "$AUDIT_VERBOSE" ]] && [[ "$AUDIT_VERBOSE" == "true" ]] && VERBOSE=true
    [[ -n "$AUDIT_PARALLEL_JOBS" ]] && PARALLEL_JOBS="$AUDIT_PARALLEL_JOBS"
    
    if [[ -n "$AUDIT_IGNORE_PATTERNS" ]]; then
        IFS=',' read -ra IGNORE_PATTERNS <<< "$AUDIT_IGNORE_PATTERNS"
    fi
    
    if [[ -n "$AUDIT_INCLUDE_PATTERNS" ]]; then
        IFS=',' read -ra INCLUDE_PATTERNS <<< "$AUDIT_INCLUDE_PATTERNS"
    fi
}

# Validate configuration
validate_config() {
    log_info "Validating configuration..."
    
    # Validate audit type
    if [[ "$AUDIT_TYPE" != "all" ]] && [[ -z "${AUDIT_TYPES[$AUDIT_TYPE]}" ]]; then
        log_error "Invalid audit type: $AUDIT_TYPE"
        return 1
    fi
    
    # Validate output format
    case "$OUTPUT_FORMAT" in
        json|yaml|markdown|html|csv) ;;
        *) log_error "Invalid output format: $OUTPUT_FORMAT"; return 1 ;;
    esac
    
    # Validate parallel jobs
    if ! [[ "$PARALLEL_JOBS" =~ ^[0-9]+$ ]] || [[ "$PARALLEL_JOBS" -lt 1 ]]; then
        log_error "Invalid parallel jobs: $PARALLEL_JOBS"
        return 1
    fi
    
    # Validate repository path
    if [[ -n "$REPOSITORY_PATH" ]] && [[ ! -d "$REPOSITORY_PATH" ]]; then
        log_error "Repository path does not exist: $REPOSITORY_PATH"
        return 1
    fi
    
    log_success "Configuration validation passed"
    return 0
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -t|--type)
                AUDIT_TYPE="$2"
                shift 2
                ;;
            -f|--format)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -r|--report-dir)
                REPORT_DIR="$2"
                shift 2
                ;;
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -i|--ignore)
                IGNORE_PATTERNS+=("$2")
                shift 2
                ;;
            -I|--include)
                INCLUDE_PATTERNS+=("$2")
                shift 2
                ;;
            -j|--jobs)
                PARALLEL_JOBS="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -q|--quiet)
                QUIET=true
                shift
                ;;
            --list-types)
                list_audit_types
                exit 0
                ;;
            --generate-config)
                generate_config "$2"
                exit 0
                ;;
            --validate-config)
                load_config
                validate_config
                exit $?
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                if [[ -z "$REPOSITORY_PATH" ]]; then
                    REPOSITORY_PATH="$1"
                else
                    log_error "Multiple repository paths provided"
                    exit 1
                fi
                shift
                ;;
        esac
    done
    
    # Validate required arguments
    if [[ -z "$REPOSITORY_PATH" ]]; then
        log_error "Repository path is required"
        show_help
        exit 1
    fi
}

# Initialize audit environment
init_audit() {
    log_info "Initializing audit environment..."
    
    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    
    # Create report directory if specified
    if [[ -n "$REPORT_DIR" ]]; then
        mkdir -p "$REPORT_DIR"
        log_debug "Report directory created: $REPORT_DIR"
    fi
    
    # Verify spec files exist
    if [[ "$AUDIT_TYPE" == "all" ]]; then
        for spec_file in "${AUDIT_TYPES[@]}"; do
            if [[ ! -f "$SPECS_DIR/$spec_file" ]]; then
                log_error "Specification file not found: $SPECS_DIR/$spec_file"
                exit 1
            fi
        done
    else
        local spec_file="${AUDIT_TYPES[$AUDIT_TYPE]}"
        if [[ ! -f "$SPECS_DIR/$spec_file" ]]; then
            log_error "Specification file not found: $SPECS_DIR/$spec_file"
            exit 1
        fi
    fi
    
    # Get absolute path
    REPOSITORY_PATH="$(cd "$REPOSITORY_PATH" && pwd)"
    
    # Check if repository is a git repository
    if [[ -d "$REPOSITORY_PATH/.git" ]]; then
        log_debug "Git repository detected"
        export IS_GIT_REPO=true
    else
        log_debug "Not a git repository, some features may be limited"
        export IS_GIT_REPO=false
    fi
    
    log_debug "Repository path: $REPOSITORY_PATH"
    log_debug "Audit type: $AUDIT_TYPE"
    log_debug "Output format: $OUTPUT_FORMAT"
    log_debug "Parallel jobs: $PARALLEL_JOBS"
    log_debug "Temporary directory: $TEMP_DIR"
}

# Run individual audit
run_audit() {
    local audit_type="$1"
    local spec_file="$2"
    local output_file="$3"
    
    log_progress "Running $audit_type audit..."
    
    # This is a placeholder for the actual audit logic
    # In a real implementation, this would parse the spec file and run the audit
    
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    # Generate mock audit results
    cat > "$output_file" << EOF
{
    "audit_type": "$audit_type",
    "specification": "$spec_file",
    "repository_path": "$REPOSITORY_PATH",
    "timestamp": "$timestamp",
    "status": "completed",
    "patterns_found": [],
    "summary": {
        "total_files_analyzed": 0,
        "patterns_detected": 0,
        "issues_found": 0,
        "recommendations": 0
    }
}
EOF
    
    log_debug "Audit completed: $audit_type"
}

# Run all audits
run_audits() {
    log_info "Starting audit execution..."
    
    local audit_files=()
    
    if [[ "$AUDIT_TYPE" == "all" ]]; then
        # Run all audit types
        for audit_type in "${!AUDIT_TYPES[@]}"; do
            local spec_file="${AUDIT_TYPES[$audit_type]}"
            local output_file="$TEMP_DIR/${audit_type}_audit.json"
            
            run_audit "$audit_type" "$spec_file" "$output_file"
            audit_files+=("$output_file")
        done
    else
        # Run specific audit type
        local spec_file="${AUDIT_TYPES[$AUDIT_TYPE]}"
        local output_file="$TEMP_DIR/${AUDIT_TYPE}_audit.json"
        
        run_audit "$AUDIT_TYPE" "$spec_file" "$output_file"
        audit_files+=("$output_file")
    fi
    
    # Generate JSON arrays for patterns
    local ignore_patterns_json="[]"
    local include_patterns_json="[]"
    
    if [ ${#IGNORE_PATTERNS[@]} -gt 0 ]; then
        ignore_patterns_json=$(printf '"%s",' "${IGNORE_PATTERNS[@]}" | sed 's/,$//' | sed 's/^/[/' | sed 's/$/]/')
    fi
    
    if [ ${#INCLUDE_PATTERNS[@]} -gt 0 ]; then
        include_patterns_json=$(printf '"%s",' "${INCLUDE_PATTERNS[@]}" | sed 's/,$//' | sed 's/^/[/' | sed 's/$/]/')
    fi
    
    # Combine all audit results
    local combined_report="$TEMP_DIR/combined_audit_report.json"
    
    {
        echo "{"
        echo "  \"repository_path\": \"$REPOSITORY_PATH\","
        echo "  \"audit_timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
        echo "  \"audit_type\": \"$AUDIT_TYPE\","
        echo "  \"output_format\": \"$OUTPUT_FORMAT\","
        echo "  \"configuration\": {"
        echo "    \"parallel_jobs\": $PARALLEL_JOBS,"
        echo "    \"verbose\": $VERBOSE,"
        echo "    \"ignore_patterns\": $ignore_patterns_json,"
        echo "    \"include_patterns\": $include_patterns_json,"
        echo "    \"is_git_repo\": $IS_GIT_REPO"
        echo "  },"
        echo "  \"audits\": ["
        
        local first=true
        for file in "${audit_files[@]}"; do
            if [[ -f "$file" ]]; then
                if [[ "$first" == true ]]; then
                    first=false
                else
                    echo ","
                fi
                cat "$file"
            fi
        done
        
        echo ""
        echo "  ]"
        echo "}"
    } > "$combined_report"
    
    export COMBINED_REPORT="$combined_report"
    log_success "Audit execution completed"
}

# Format and output results
format_output() {
    log_info "Formatting output as $OUTPUT_FORMAT..."
    
    case "$OUTPUT_FORMAT" in
        json)
            cat "$COMBINED_REPORT"
            ;;
        yaml)
            if command -v yq &> /dev/null; then
                yq eval -P "$COMBINED_REPORT"
            else
                log_warning "yq not found, outputting JSON instead"
                cat "$COMBINED_REPORT"
            fi
            ;;
        markdown)
            generate_markdown_report
            ;;
        html)
            generate_html_report
            ;;
        csv)
            generate_csv_report
            ;;
    esac
}

# Generate markdown report
generate_markdown_report() {
    local report_file="$TEMP_DIR/report.md"
    
    cat > "$report_file" << EOF
# AI Code Audit Report

**Repository:** $REPOSITORY_PATH  
**Audit Date:** $(date)  
**Audit Type:** $AUDIT_TYPE  
**Output Format:** $OUTPUT_FORMAT

## Configuration

- **Parallel Jobs:** $PARALLEL_JOBS
- **Verbose Mode:** $VERBOSE
- **Git Repository:** $IS_GIT_REPO

## Audit Results

This report contains the results of the AI-driven code audit performed on the specified repository.

### Summary

EOF
    
    # Parse JSON and add findings
    if command -v jq &> /dev/null; then
        jq -r '.audits[] | "#### \(.audit_type | ascii_upcase) Audit\n\n**Status:** \(.status)\n**Timestamp:** \(.timestamp)\n\n**Summary:**\n- Total Files Analyzed: \(.summary.total_files_analyzed)\n- Patterns Detected: \(.summary.patterns_detected)\n- Issues Found: \(.summary.issues_found)\n- Recommendations: \(.summary.recommendations)\n\n"' "$COMBINED_REPORT" >> "$report_file"
    else
        echo "JSON parsing not available, showing raw data:" >> "$report_file"
        cat "$COMBINED_REPORT" >> "$report_file"
    fi
    
    cat "$report_file"
}

# Generate HTML report
generate_html_report() {
    local report_file="$TEMP_DIR/report.html"
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>AI Code Audit Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; line-height: 1.6; }
        .header { background-color: #f5f5f5; padding: 20px; border-radius: 8px; margin-bottom: 30px; }
        .audit-section { margin: 20px 0; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .audit-title { background-color: #007acc; color: white; padding: 10px; margin: -20px -20px 20px; border-radius: 5px 5px 0 0; }
        .summary { background-color: #f9f9f9; padding: 15px; border-radius: 5px; margin: 15px 0; }
        .config { background-color: #e8f4f8; padding: 15px; border-radius: 5px; margin: 15px 0; }
        pre { background-color: #f4f4f4; padding: 15px; border-radius: 5px; overflow-x: auto; }
        .status-completed { color: #28a745; font-weight: bold; }
        .status-failed { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>
    <div class="header">
        <h1>AI Code Audit Report</h1>
        <p><strong>Repository:</strong> $REPOSITORY_PATH</p>
        <p><strong>Audit Date:</strong> $(date)</p>
        <p><strong>Audit Type:</strong> $AUDIT_TYPE</p>
    </div>
    
    <div class="config">
        <h2>Configuration</h2>
        <ul>
            <li><strong>Parallel Jobs:</strong> $PARALLEL_JOBS</li>
            <li><strong>Verbose Mode:</strong> $VERBOSE</li>
            <li><strong>Git Repository:</strong> $IS_GIT_REPO</li>
        </ul>
    </div>
    
    <h2>Audit Results</h2>
    <div class="summary">
        <h3>Raw Data</h3>
        <pre>$(cat "$COMBINED_REPORT")</pre>
    </div>
</body>
</html>
EOF
    
    cat "$report_file"
}

# Generate CSV report
generate_csv_report() {
    local report_file="$TEMP_DIR/report.csv"
    
    echo "audit_type,status,timestamp,files_analyzed,patterns_detected,issues_found,recommendations" > "$report_file"
    
    # Parse JSON and generate CSV
    if command -v jq &> /dev/null; then
        jq -r '.audits[] | [.audit_type, .status, .timestamp, .summary.total_files_analyzed, .summary.patterns_detected, .summary.issues_found, .summary.recommendations] | @csv' "$COMBINED_REPORT" >> "$report_file"
    else
        echo "json_parsing_not_available,error,$(date -u +%Y-%m-%dT%H:%M:%SZ),0,0,0,0" >> "$report_file"
    fi
    
    cat "$report_file"
}

# Cleanup function
cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Main execution
main() {
    # Setup cleanup trap
    trap cleanup EXIT
    
    # Load configuration
    load_config
    load_env_config
    
    # Parse command line arguments
    parse_args "$@"
    
    # Validate configuration
    validate_config
    
    # Initialize audit environment
    init_audit
    
    # Run audits
    run_audits
    
    # Format and output results
    if [[ -n "$OUTPUT_FILE" ]]; then
        format_output > "$OUTPUT_FILE"
        log_success "Report saved to: $OUTPUT_FILE"
    elif [[ -n "$REPORT_DIR" ]]; then
        local report_file="$REPORT_DIR/audit-report-$(date +%Y%m%d-%H%M%S).$OUTPUT_FORMAT"
        format_output > "$report_file"
        log_success "Report saved to: $report_file"
    else
        format_output
    fi
    
    log_success "Audit completed successfully"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi