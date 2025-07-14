#!/bin/bash

# Repository Discovery Script
# Automated repository analysis tool for comprehensive codebase discovery
# Usage: ./repo-discovery.sh [repository_path] [output_format] [focus_area]

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SPECS_DIR="$REPO_ROOT/specs"
DOCS_DIR="$REPO_ROOT/docs"
TEMP_DIR="/tmp/repo-discovery-$$"
DEFAULT_OUTPUT_FORMAT="json"
DEFAULT_FOCUS_AREA="all"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1" >&2
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Help function
show_help() {
    cat << EOF
Repository Discovery Script

USAGE:
    $0 [OPTIONS] <repository_path>

OPTIONS:
    -f, --format FORMAT     Output format (json|yaml|markdown|html) [default: json]
    -a, --area AREA         Focus area (all|structure|docs|practices|metrics|team|security|performance) [default: all]
    -o, --output FILE       Output file path [default: stdout]
    -v, --verbose           Enable verbose logging
    -h, --help              Show this help message

EXAMPLES:
    $0 /path/to/repo
    $0 --format markdown --area structure /path/to/repo
    $0 -f json -o discovery-report.json /path/to/repo
    $0 --area security --verbose /path/to/repo

FOCUS AREAS:
    all          Complete repository discovery scan
    structure    Project structure analysis only
    docs         Documentation discovery only
    practices    Development practices only
    metrics      Code metrics analysis only
    team         Team & activity analysis only
    security     Security-focused discovery
    performance  Performance-focused discovery
EOF
}

# Parse command line arguments
parse_args() {
    REPOSITORY_PATH=""
    OUTPUT_FORMAT="$DEFAULT_OUTPUT_FORMAT"
    FOCUS_AREA="$DEFAULT_FOCUS_AREA"
    OUTPUT_FILE=""
    VERBOSE=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--format)
                OUTPUT_FORMAT="$2"
                shift 2
                ;;
            -a|--area)
                FOCUS_AREA="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_FILE="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
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

    # Validate repository path
    if [[ ! -d "$REPOSITORY_PATH" ]]; then
        log_error "Repository path does not exist: $REPOSITORY_PATH"
        exit 1
    fi

    # Validate output format
    case "$OUTPUT_FORMAT" in
        json|yaml|markdown|html)
            ;;
        *)
            log_error "Invalid output format: $OUTPUT_FORMAT"
            exit 1
            ;;
    esac

    # Validate focus area
    case "$FOCUS_AREA" in
        all|structure|docs|practices|metrics|team|security|performance)
            ;;
        *)
            log_error "Invalid focus area: $FOCUS_AREA"
            exit 1
            ;;
    esac
}

# Initialize discovery environment
init_discovery() {
    log_info "Initializing repository discovery..."
    
    # Create temporary directory
    mkdir -p "$TEMP_DIR"
    
    # Verify required files exist
    local spec_file="$SPECS_DIR/repo-discovery-spec.yaml"
    if [[ ! -f "$spec_file" ]]; then
        log_error "Specification file not found: $spec_file"
        exit 1
    fi
    
    local taxonomy_file="$DOCS_DIR/Repository-Discovery-Taxonomy.md"
    if [[ ! -f "$taxonomy_file" ]]; then
        log_error "Taxonomy file not found: $taxonomy_file"
        exit 1
    fi
    
    # Check if repository is a git repository
    if [[ -d "$REPOSITORY_PATH/.git" ]]; then
        log_info "Git repository detected"
        export IS_GIT_REPO=true
    else
        log_warning "Not a git repository, some analysis features will be limited"
        export IS_GIT_REPO=false
    fi
    
    # Get absolute path
    REPOSITORY_PATH="$(cd "$REPOSITORY_PATH" && pwd)"
    
    if [[ "$VERBOSE" == true ]]; then
        log_info "Repository path: $REPOSITORY_PATH"
        log_info "Output format: $OUTPUT_FORMAT"
        log_info "Focus area: $FOCUS_AREA"
        log_info "Temporary directory: $TEMP_DIR"
    fi
}

# Language detection analysis
analyze_language_detection() {
    log_info "Analyzing language detection..."
    
    local lang_data="$TEMP_DIR/language_analysis.json"
    
    # Count files by extension
    find "$REPOSITORY_PATH" -type f -name "*.py" | wc -l > "$TEMP_DIR/python_count"
    find "$REPOSITORY_PATH" -type f -name "*.js" | wc -l > "$TEMP_DIR/javascript_count"
    find "$REPOSITORY_PATH" -type f -name "*.ts" | wc -l > "$TEMP_DIR/typescript_count"
    find "$REPOSITORY_PATH" -type f -name "*.java" | wc -l > "$TEMP_DIR/java_count"
    find "$REPOSITORY_PATH" -type f -name "*.cpp" -o -name "*.c" -o -name "*.h" | wc -l > "$TEMP_DIR/cpp_count"
    find "$REPOSITORY_PATH" -type f -name "*.go" | wc -l > "$TEMP_DIR/go_count"
    find "$REPOSITORY_PATH" -type f -name "*.rs" | wc -l > "$TEMP_DIR/rust_count"
    find "$REPOSITORY_PATH" -type f -name "*.rb" | wc -l > "$TEMP_DIR/ruby_count"
    find "$REPOSITORY_PATH" -type f -name "*.php" | wc -l > "$TEMP_DIR/php_count"
    find "$REPOSITORY_PATH" -type f -name "*.cs" | wc -l > "$TEMP_DIR/csharp_count"
    
    # Calculate total lines of code if available
    if command -v wc &> /dev/null; then
        python_lines=$(find "$REPOSITORY_PATH" -name "*.py" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' 2>/dev/null || echo "0")
        javascript_lines=$(find "$REPOSITORY_PATH" -name "*.js" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' 2>/dev/null || echo "0")
        typescript_lines=$(find "$REPOSITORY_PATH" -name "*.ts" -exec wc -l {} + 2>/dev/null | tail -1 | awk '{print $1}' 2>/dev/null || echo "0")
    else
        python_lines="0"
        javascript_lines="0"
        typescript_lines="0"
    fi
    
    # Ensure we have numeric values
    [[ "$python_lines" =~ ^[0-9]+$ ]] || python_lines="0"
    [[ "$javascript_lines" =~ ^[0-9]+$ ]] || javascript_lines="0"
    [[ "$typescript_lines" =~ ^[0-9]+$ ]] || typescript_lines="0"
    
    # Generate language analysis report
    cat > "$lang_data" << EOF
{
    "pattern": "Language Detection",
    "category": "project_structure",
    "findings": {
        "python": {
            "files": $(cat "$TEMP_DIR/python_count"),
            "lines": $python_lines
        },
        "javascript": {
            "files": $(cat "$TEMP_DIR/javascript_count"),
            "lines": $javascript_lines
        },
        "typescript": {
            "files": $(cat "$TEMP_DIR/typescript_count"),
            "lines": $typescript_lines
        },
        "java": {
            "files": $(cat "$TEMP_DIR/java_count"),
            "lines": 0
        },
        "cpp": {
            "files": $(cat "$TEMP_DIR/cpp_count"),
            "lines": 0
        },
        "go": {
            "files": $(cat "$TEMP_DIR/go_count"),
            "lines": 0
        },
        "rust": {
            "files": $(cat "$TEMP_DIR/rust_count"),
            "lines": 0
        },
        "ruby": {
            "files": $(cat "$TEMP_DIR/ruby_count"),
            "lines": 0
        },
        "php": {
            "files": $(cat "$TEMP_DIR/php_count"),
            "lines": 0
        },
        "csharp": {
            "files": $(cat "$TEMP_DIR/csharp_count"),
            "lines": 0
        }
    }
}
EOF
    
    echo "$lang_data"
}

# Framework identification analysis
analyze_framework_identification() {
    log_info "Analyzing framework identification..."
    
    local framework_data="$TEMP_DIR/framework_analysis.json"
    local frameworks_found=()
    
    # Check for common framework indicators
    [[ -f "$REPOSITORY_PATH/package.json" ]] && frameworks_found+=("nodejs")
    [[ -f "$REPOSITORY_PATH/requirements.txt" ]] && frameworks_found+=("python")
    [[ -f "$REPOSITORY_PATH/pom.xml" ]] && frameworks_found+=("maven")
    [[ -f "$REPOSITORY_PATH/build.gradle" ]] && frameworks_found+=("gradle")
    [[ -f "$REPOSITORY_PATH/Cargo.toml" ]] && frameworks_found+=("rust")
    [[ -f "$REPOSITORY_PATH/go.mod" ]] && frameworks_found+=("go")
    [[ -f "$REPOSITORY_PATH/Gemfile" ]] && frameworks_found+=("ruby")
    [[ -f "$REPOSITORY_PATH/composer.json" ]] && frameworks_found+=("php")
    [[ -f "$REPOSITORY_PATH/CMakeLists.txt" ]] && frameworks_found+=("cmake")
    
    # Check for specific frameworks in package.json
    if [[ -f "$REPOSITORY_PATH/package.json" ]]; then
        if grep -q "react" "$REPOSITORY_PATH/package.json"; then
            frameworks_found+=("react")
        fi
        if grep -q "vue" "$REPOSITORY_PATH/package.json"; then
            frameworks_found+=("vue")
        fi
        if grep -q "angular" "$REPOSITORY_PATH/package.json"; then
            frameworks_found+=("angular")
        fi
        if grep -q "express" "$REPOSITORY_PATH/package.json"; then
            frameworks_found+=("express")
        fi
    fi
    
    # Check for Python frameworks
    if [[ -f "$REPOSITORY_PATH/requirements.txt" ]]; then
        if grep -q "django" "$REPOSITORY_PATH/requirements.txt"; then
            frameworks_found+=("django")
        fi
        if grep -q "flask" "$REPOSITORY_PATH/requirements.txt"; then
            frameworks_found+=("flask")
        fi
        if grep -q "fastapi" "$REPOSITORY_PATH/requirements.txt"; then
            frameworks_found+=("fastapi")
        fi
    fi
    
    # Generate framework analysis report
    if [ ${#frameworks_found[@]} -eq 0 ]; then
        frameworks_json="[]"
    else
        frameworks_json=$(printf '%s\n' "${frameworks_found[@]}" | jq -R . | jq -s . 2>/dev/null || echo "[]")
    fi
    cat > "$framework_data" << EOF
{
    "pattern": "Framework Identification",
    "category": "project_structure",
    "findings": {
        "frameworks": $frameworks_json,
        "count": ${#frameworks_found[@]}
    }
}
EOF
    
    echo "$framework_data"
}

# Documentation analysis
analyze_documentation() {
    log_info "Analyzing documentation..."
    
    local doc_data="$TEMP_DIR/documentation_analysis.json"
    local readme_found=false
    local contributing_found=false
    local license_found=false
    local changelog_found=false
    local docs_dir_found=false
    
    # Check for README files
    for readme in README.md README.rst README.txt readme.md Readme.md; do
        if [[ -f "$REPOSITORY_PATH/$readme" ]]; then
            readme_found=true
            break
        fi
    done
    
    # Check for contributing guidelines
    for contrib in CONTRIBUTING.md CONTRIBUTE.md docs/contributing.md; do
        if [[ -f "$REPOSITORY_PATH/$contrib" ]]; then
            contributing_found=true
            break
        fi
    done
    
    # Check for license
    for license in LICENSE LICENSE.txt LICENSE.md license.txt; do
        if [[ -f "$REPOSITORY_PATH/$license" ]]; then
            license_found=true
            break
        fi
    done
    
    # Check for changelog
    for changelog in CHANGELOG.md CHANGELOG.txt CHANGES.md HISTORY.md; do
        if [[ -f "$REPOSITORY_PATH/$changelog" ]]; then
            changelog_found=true
            break
        fi
    done
    
    # Check for docs directory
    if [[ -d "$REPOSITORY_PATH/docs" ]]; then
        docs_dir_found=true
    fi
    
    # Generate documentation analysis report
    cat > "$doc_data" << EOF
{
    "pattern": "Documentation Discovery",
    "category": "documentation",
    "findings": {
        "readme": $readme_found,
        "contributing": $contributing_found,
        "license": $license_found,
        "changelog": $changelog_found,
        "docs_directory": $docs_dir_found
    }
}
EOF
    
    echo "$doc_data"
}

# CI/CD analysis
analyze_cicd() {
    log_info "Analyzing CI/CD configuration..."
    
    local cicd_data="$TEMP_DIR/cicd_analysis.json"
    local ci_systems=()
    
    # Check for various CI/CD systems
    [[ -d "$REPOSITORY_PATH/.github/workflows" ]] && ci_systems+=("github_actions")
    [[ -f "$REPOSITORY_PATH/.gitlab-ci.yml" ]] && ci_systems+=("gitlab_ci")
    [[ -f "$REPOSITORY_PATH/Jenkinsfile" ]] && ci_systems+=("jenkins")
    [[ -f "$REPOSITORY_PATH/.travis.yml" ]] && ci_systems+=("travis")
    [[ -f "$REPOSITORY_PATH/circle.yml" ]] && ci_systems+=("circle_ci")
    [[ -f "$REPOSITORY_PATH/azure-pipelines.yml" ]] && ci_systems+=("azure_pipelines")
    [[ -f "$REPOSITORY_PATH/.buildkite/pipeline.yml" ]] && ci_systems+=("buildkite")
    [[ -f "$REPOSITORY_PATH/.drone.yml" ]] && ci_systems+=("drone")
    
    # Generate CI/CD analysis report
    local ci_systems_json=$(printf '%s\n' "${ci_systems[@]}" | jq -R . | jq -s .)
    cat > "$cicd_data" << EOF
{
    "pattern": "CI/CD Configuration",
    "category": "development_practices",
    "findings": {
        "ci_systems": $ci_systems_json,
        "count": ${#ci_systems[@]}
    }
}
EOF
    
    echo "$cicd_data"
}

# Repository metrics analysis
analyze_repository_metrics() {
    log_info "Analyzing repository metrics..."
    
    local metrics_data="$TEMP_DIR/metrics_analysis.json"
    local total_files=0
    local total_directories=0
    local git_commits=0
    local git_contributors=0
    
    # Count files and directories
    total_files=$(find "$REPOSITORY_PATH" -type f | wc -l)
    total_directories=$(find "$REPOSITORY_PATH" -type d | wc -l)
    
    # Git metrics (if available)
    if [[ "$IS_GIT_REPO" == true ]]; then
        cd "$REPOSITORY_PATH"
        git_commits=$(git rev-list --all --count 2>/dev/null || echo "0")
        git_contributors=$(git shortlog -sn --all | wc -l 2>/dev/null || echo "0")
    fi
    
    # Generate metrics analysis report
    cat > "$metrics_data" << EOF
{
    "pattern": "Repository Metrics",
    "category": "code_metrics",
    "findings": {
        "total_files": $total_files,
        "total_directories": $total_directories,
        "git_commits": $git_commits,
        "git_contributors": $git_contributors
    }
}
EOF
    
    echo "$metrics_data"
}

# Run discovery analysis based on focus area
run_discovery() {
    log_info "Running repository discovery analysis..."
    
    local analysis_files=()
    
    if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "structure" ]]; then
        analysis_files+=("$(analyze_language_detection)")
        analysis_files+=("$(analyze_framework_identification)")
    fi
    
    if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "docs" ]]; then
        analysis_files+=("$(analyze_documentation)")
    fi
    
    if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "practices" ]]; then
        analysis_files+=("$(analyze_cicd)")
    fi
    
    if [[ "$FOCUS_AREA" == "all" || "$FOCUS_AREA" == "metrics" ]]; then
        analysis_files+=("$(analyze_repository_metrics)")
    fi
    
    # Combine all analysis results
    local combined_report="$TEMP_DIR/combined_report.json"
    
    # Create combined JSON report
    {
        echo "{"
        echo "  \"repository_path\": \"$REPOSITORY_PATH\","
        echo "  \"analysis_timestamp\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
        echo "  \"focus_area\": \"$FOCUS_AREA\","
        echo "  \"patterns\": ["
        
        local first=true
        for file in "${analysis_files[@]}"; do
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
    esac
}

# Generate markdown report
generate_markdown_report() {
    local report_file="$TEMP_DIR/report.md"
    
    cat > "$report_file" << EOF
# Repository Discovery Report

**Repository:** $REPOSITORY_PATH  
**Analysis Date:** $(date)  
**Focus Area:** $FOCUS_AREA

## Summary

This report provides a comprehensive analysis of the repository structure, documentation, development practices, and metrics.

## Findings

EOF
    
    # Parse JSON and add findings
    if command -v jq &> /dev/null; then
        jq -r '.patterns[] | "### \(.pattern)\n\n**Category:** \(.category)\n\n**Findings:**\n\n\(.findings | to_entries | map("- **\(.key):** \(.value)") | join("\n"))\n"' "$COMBINED_REPORT" >> "$report_file"
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
    <title>Repository Discovery Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background-color: #f5f5f5; padding: 20px; border-radius: 5px; }
        .pattern { margin: 20px 0; padding: 15px; border-left: 4px solid #007acc; }
        .findings { background-color: #f9f9f9; padding: 10px; border-radius: 3px; }
        pre { background-color: #f4f4f4; padding: 10px; border-radius: 3px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Repository Discovery Report</h1>
        <p><strong>Repository:</strong> $REPOSITORY_PATH</p>
        <p><strong>Analysis Date:</strong> $(date)</p>
        <p><strong>Focus Area:</strong> $FOCUS_AREA</p>
    </div>
    
    <h2>Analysis Results</h2>
    <pre>$(cat "$COMBINED_REPORT")</pre>
</body>
</html>
EOF
    
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
    
    # Parse arguments
    parse_args "$@"
    
    # Initialize discovery
    init_discovery
    
    # Run discovery analysis
    run_discovery
    
    # Format and output results
    if [[ -n "$OUTPUT_FILE" ]]; then
        format_output > "$OUTPUT_FILE"
        log_success "Report saved to: $OUTPUT_FILE"
    else
        format_output
    fi
    
    log_success "Repository discovery completed successfully"
}

# Check if script is being sourced or executed
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi