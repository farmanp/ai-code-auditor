# Audit Runner Documentation

## Overview

The `audit-runner.sh` script is a comprehensive audit runner that can execute different types of code audits based on user selection and generate structured reports in multiple formats.

## Features

### Core Functionality
- **Multi-Audit Support**: Execute individual audits or combined audits across 8 different audit types
- **Configurable Output**: Generate reports in JSON, Markdown, HTML, and CSV formats
- **Configuration Management**: Support for config files, environment variables, and CLI overrides
- **Progress Tracking**: Real-time progress updates and comprehensive error handling
- **Cross-Platform**: Compatible with bash environments on Linux, macOS, and Windows (via WSL)

### Supported Audit Types

1. **security** - Security vulnerabilities (OWASP Top 10)
2. **patterns** - Design patterns (GoF and architectural)
3. **algorithms** - Algorithms and data structures
4. **datahub** - DataHub entities and governance
5. **feasibility** - Feasibility analysis and migration readiness
6. **etl** - ETL subsystems and data warehouse patterns
7. **cloud** - Cloud architecture patterns
8. **repository** - Repository discovery and analysis
9. **all** - Run all audit types (default)

## Usage

### Basic Usage

```bash
# Run all audits with default settings
./audit-runner.sh /path/to/repo

# Run specific audit type
./audit-runner.sh --type security /path/to/repo

# Generate report in specific format
./audit-runner.sh --type patterns --format markdown /path/to/repo

# Save report to file
./audit-runner.sh --type all --output audit-report.json /path/to/repo
```

### Command Line Options

```bash
Usage: ./audit-runner.sh [OPTIONS] <repository_path>

Options:
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
  -h, --help              Show help message
  --list-types            List all available audit types
  --generate-config       Generate sample configuration file
  --validate-config       Validate configuration file
```

### Advanced Examples

```bash
# Run security audit with custom ignore patterns
./audit-runner.sh --type security --ignore "*.test.*" --ignore "node_modules" /path/to/repo

# Run multiple audits with custom output directory
./audit-runner.sh --type all --report-dir ./custom-reports /path/to/repo

# Run with custom configuration file
./audit-runner.sh --config ./my-audit-config.conf /path/to/repo

# Run with verbose logging and custom format
./audit-runner.sh --type patterns --format html --verbose --output patterns.html /path/to/repo

# Run with parallel processing
./audit-runner.sh --type all --jobs 4 /path/to/repo
```

## Configuration

### Configuration File

Generate a sample configuration file:

```bash
./audit-runner.sh --generate-config
```

Sample configuration (`audit-runner.conf`):

```bash
# Default audit type
AUDIT_TYPE=all

# Default output format
OUTPUT_FORMAT=json

# Default report directory
REPORT_DIR=./reports

# Parallel jobs for faster processing
PARALLEL_JOBS=1

# Verbose logging
VERBOSE=false

# Ignore patterns (comma-separated)
IGNORE_PATTERNS=*.test.*,*.spec.*,node_modules,dist,build,target

# Include patterns (comma-separated)
INCLUDE_PATTERNS=*.java,*.js,*.ts,*.py,*.go,*.rs,*.cpp,*.c,*.cs,*.php,*.rb
```

### Environment Variables

You can override configuration using environment variables:

```bash
export AUDIT_TYPE=security
export OUTPUT_FORMAT=markdown
export AUDIT_VERBOSE=true
export AUDIT_PARALLEL_JOBS=4
export AUDIT_IGNORE_PATTERNS="*.test.*,node_modules"
export AUDIT_INCLUDE_PATTERNS="*.java,*.js,*.py"

./audit-runner.sh /path/to/repo
```

### Configuration Precedence

1. Command-line arguments (highest priority)
2. Environment variables
3. Configuration file
4. Default values (lowest priority)

## Output Formats

### JSON Format
```json
{
  "repository_path": "/path/to/repo",
  "audit_timestamp": "2025-01-14T12:00:00Z",
  "audit_type": "security",
  "audits": [
    {
      "audit_type": "security",
      "status": "completed",
      "patterns_found": [],
      "summary": {
        "total_files_analyzed": 150,
        "patterns_detected": 5,
        "issues_found": 2,
        "recommendations": 3
      }
    }
  ]
}
```

### Markdown Format
```markdown
# AI Code Audit Report

**Repository:** /path/to/repo  
**Audit Date:** Mon Jan 14 12:00:00 UTC 2025  
**Audit Type:** security

## Summary

### SECURITY Audit

**Status:** completed  
**Timestamp:** 2025-01-14T12:00:00Z

**Summary:**
- Total Files Analyzed: 150
- Patterns Detected: 5
- Issues Found: 2
- Recommendations: 3
```

### HTML Format
Generates a styled HTML report with:
- Professional styling and layout
- Structured sections for each audit type
- Configuration details
- Raw JSON data for reference

### CSV Format
```csv
audit_type,status,timestamp,files_analyzed,patterns_detected,issues_found,recommendations
security,completed,2025-01-14T12:00:00Z,150,5,2,3
patterns,completed,2025-01-14T12:00:00Z,85,12,0,5
```

## Integration

### CI/CD Pipeline Integration

#### GitHub Actions
```yaml
name: Code Audit
on: [push, pull_request]

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Run Security Audit
        run: |
          ./audit-runner.sh --type security --format json --output security-report.json .
      - name: Upload Audit Report
        uses: actions/upload-artifact@v2
        with:
          name: security-report
          path: security-report.json
```

#### Jenkins Pipeline
```groovy
pipeline {
    agent any
    stages {
        stage('Code Audit') {
            steps {
                script {
                    sh './audit-runner.sh --type all --format json --output audit-report.json .'
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'audit-report.json', fingerprint: true
                }
            }
        }
    }
}
```

### Git Hooks Integration

#### Pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

./audit-runner.sh --type security --quiet --format json --output /tmp/security-check.json .
if [ $? -ne 0 ]; then
    echo "Security audit failed. Commit aborted."
    exit 1
fi
```

### IDE Integration

The audit runner can be integrated into IDEs as an external tool:

#### VS Code Task
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Run Security Audit",
            "type": "shell",
            "command": "./audit-runner.sh",
            "args": ["--type", "security", "--format", "markdown", "${workspaceFolder}"],
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "shared"
            }
        }
    ]
}
```

## Error Handling

The audit runner includes comprehensive error handling:

- **Configuration Validation**: Validates all configuration parameters before execution
- **File System Checks**: Verifies repository paths and file accessibility
- **Specification Validation**: Ensures all required specification files exist
- **Output Validation**: Validates output directories and file permissions
- **Graceful Cleanup**: Automatic cleanup of temporary files on exit

## Performance Considerations

- **Parallel Processing**: Use `--jobs` parameter to enable parallel audit execution
- **File Filtering**: Use `--ignore` and `--include` patterns to limit scope
- **Output Optimization**: Choose appropriate output format for your use case
- **Memory Management**: Large repositories may require increased system resources

## Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure script has execute permissions (`chmod +x audit-runner.sh`)
2. **Configuration Errors**: Use `--validate-config` to check configuration syntax
3. **Missing Dependencies**: Ensure required tools (bash, jq) are installed
4. **Large Repository Performance**: Use file filtering and parallel processing

### Debug Mode

Enable verbose logging for troubleshooting:
```bash
./audit-runner.sh --verbose --type security /path/to/repo
```

### Validation

Test configuration without running audits:
```bash
./audit-runner.sh --validate-config
```

## Extension Points

The audit runner is designed to be extensible:

1. **Custom Audit Types**: Add new audit types by creating corresponding YAML specs
2. **Output Formats**: Extend format generators for additional output types
3. **Configuration Options**: Add new configuration parameters as needed
4. **Integration Hooks**: Extend for custom CI/CD and tool integrations

## Contributing

When contributing to the audit runner:

1. Follow the existing code style and patterns
2. Add comprehensive error handling for new features
3. Update documentation for any new options or behaviors
4. Test across different environments and use cases
5. Consider backward compatibility when making changes

## License

This audit runner is part of the AI Code Auditor project and follows the same licensing terms.