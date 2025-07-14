# Specification Validation Guide

This guide explains how to use the Build Specification Validator Tool to maintain high-quality YAML specifications across all audit types.

## Overview

The Build Specification Validator Tool (`validate-specs.py`) is designed to:
- Validate YAML syntax and schema compliance
- Check for duplicate patterns across specifications
- Ensure all required fields are present
- Verify cross-references between specifications
- Maintain consistency in report field definitions

## Usage

### Basic Commands

```bash
# Validate a single specification file
./validate-specs.py --spec specs/security-vulnerabilities-spec.yaml

# Validate all specification files
./validate-specs.py --all

# Use strict mode (warnings become errors)
./validate-specs.py --all --strict

# Specify custom specs directory
./validate-specs.py --all --specs-dir custom-specs/
```

### Command Line Options

- `--spec SPEC`: Path to a specific specification file to validate
- `--all`: Validate all specification files in the specs directory
- `--strict`: Enable strict mode (warnings become errors)
- `--specs-dir SPECS_DIR`: Directory containing specification files (default: specs)

## Validation Rules

### 1. YAML Syntax Validation

The tool checks for proper YAML formatting:
- Correct indentation
- Valid key-value pairs
- Proper list syntax
- No syntax errors

**Common Issues:**
- Mixed tabs and spaces
- Incorrect indentation levels
- Missing colons after keys
- Unmatched quotes

### 2. Schema Validation

Each specification type has a defined schema that must be followed:

#### Design Patterns (`design-patterns-spec.yaml`)
```yaml
patterns:
  - name: "PatternName"           # Required: string
    category: "creational"        # Required: enum (creational, structural, behavioral, architectural)
    hints: ["keyword1"]           # Required: array of strings
    report_fields: ["field1"]     # Required: array of strings
```

#### Security Vulnerabilities (`security-vulnerabilities-spec.yaml`)
```yaml
vulnerabilities:
  - name: "VulnerabilityName"     # Required: string
    category: "Injection"         # Required: string
    owasp_category: "A03:2021"    # Required: string
    severity: "High"              # Required: enum (Critical, High, Medium, Low, Varies)
    description: "Description"    # Required: string
    detection_hints: ["hint1"]    # Required: array of strings
    report_fields: ["field1"]     # Required: array of strings
    patterns: ["pattern1"]        # Optional: array of strings
    safe_alternatives: ["alt1"]   # Optional: array of strings
```

#### Algorithms & Data Structures (`algorithms-data-structures-spec.yaml`)
```yaml
algorithms_and_data_structures:
  - name: "AlgorithmName"         # Required: string
    category: "sorting"           # Required: string
    hints: ["keyword1"]           # Required: array of strings
    report_fields: ["field1"]     # Required: array of strings
    paths: ["path1"]              # Optional: array of strings
    time_complexity: {}           # Optional: object
    space_complexity: "O(1)"      # Optional: string
```

#### DataHub Entities (`datahub-spec.yaml`)
```yaml
datahub_entities:
  - name: "EntityName"            # Required: string
    urn_pattern: "urn:li:*"       # Required: string
    aspect_name: "aspectName"     # Required: string
    report_fields: ["field1"]     # Required: array of strings
```

#### Feasibility Analysis (`feasibility-analysis-spec.yaml`)
```yaml
feasibility_analysis:
  - name: "AnalysisName"          # Required: string
    category: "migration"         # Required: string
    analysis_type: "type"         # Required: string
    hints: ["keyword1"]           # Required: array of strings
    report_fields: ["field1"]     # Required: array of strings
```

#### ETL Subsystems (`etl-subsystems-spec.yaml`)
```yaml
etl_subsystems:
  - name: "SubsystemName"         # Required: string
    id: 1                         # Required: integer
    category: "data_acquisition"  # Required: string
    hints: ["keyword1"]           # Required: array of strings
    report_fields: ["field1"]     # Required: array of strings
```

#### Cloud Architecture (`cloud-architecture-spec.yaml`)
```yaml
cloud_architecture_patterns:
  - name: "PatternName"           # Required: string
    category: "aws"               # Required: string
    hints: ["keyword1"]           # Required: array of strings
    report_fields: ["field1"]     # Required: array of strings
```

#### Repository Discovery (`repo-discovery-spec.yaml`)
```yaml
repository_discovery:
  - name: "AnalysisName"          # Required: string
    category: "project_structure" # Required: string
    hints: ["keyword1"]           # Required: array of strings
    report_fields: ["field1"]     # Required: array of strings
```

### 3. Duplicate Pattern Detection

The validator checks for duplicate pattern names across all specification files:
- Pattern names must be unique across all specifications
- Case-sensitive matching
- Helps prevent conflicts during analysis

### 4. Required Field Validation

All patterns must include the required fields for their specification type:
- `name`: Human-readable pattern name
- `category`: Categorization of the pattern
- `hints`: Keywords or signatures that help identify the pattern
- `report_fields`: Fields that should be included in analysis reports

### 5. Cross-Reference Validation

The validator checks for:
- Referenced patterns that don't exist
- Broken internal links
- Inconsistent naming conventions

### 6. Report Field Consistency

The validator ensures:
- All patterns have non-empty report_fields
- Report fields follow naming conventions
- Common fields are used consistently

## Integration

### Pre-commit Hook

The validator includes a pre-commit hook that automatically runs validation before each commit:

```bash
# The hook is automatically installed at .git/hooks/pre-commit
# It runs validation on all staged specification files
```

### GitHub Actions CI/CD

The repository includes a GitHub Actions workflow that:
- Runs validation on pull requests
- Generates validation reports
- Prevents merging of invalid specifications

Workflow file: `.github/workflows/validate-specs.yml`

## Error Messages

### Schema Validation Errors
```
Schema validation error in specs/design-patterns-spec.yaml at patterns -> 0 -> category: 'invalid_category' is not one of ['creational', 'structural', 'behavioral', 'architectural']
```

### Duplicate Pattern Errors
```
Duplicate pattern name 'Singleton' found in: specs/design-patterns-spec.yaml, specs/custom-patterns-spec.yaml
```

### YAML Syntax Errors
```
YAML syntax error in specs/broken-spec.yaml: expected ':', but found '\n'
```

## Best Practices

### 1. Consistent Naming
- Use clear, descriptive pattern names
- Follow established naming conventions
- Avoid abbreviations when possible

### 2. Comprehensive Hints
- Include multiple keywords that identify the pattern
- Add language-specific indicators
- Include both positive and negative indicators

### 3. Meaningful Report Fields
- Define fields that provide actionable insights
- Include quality metrics where appropriate
- Consider the end user's needs

### 4. Regular Validation
- Run validation frequently during development
- Use strict mode for production deployments
- Review validation warnings regularly

## Testing

The validator includes a comprehensive test suite:

```bash
# Run all tests
python3 -m unittest test_validate_specs.py -v

# Run specific test
python3 -m unittest test_validate_specs.TestSpecValidator.test_duplicate_pattern_names
```

## Troubleshooting

### Common Issues

1. **Import Errors**: Ensure all required Python packages are installed
   ```bash
   pip install pyyaml jsonschema
   ```

2. **Permission Errors**: Make sure the script is executable
   ```bash
   chmod +x validate-specs.py
   ```

3. **Path Issues**: Run the validator from the project root directory

4. **YAML Formatting**: Use a YAML linter to catch syntax errors early

### Getting Help

If you encounter issues:
1. Check the error message carefully
2. Verify your YAML syntax
3. Review the schema requirements
4. Run the validator with a single file to isolate issues
5. Check the test suite for examples of valid specifications

## Contributing

When adding new validation rules:
1. Update the appropriate schema in `validate-specs.py`
2. Add test cases to `test_validate_specs.py`
3. Update this documentation
4. Test thoroughly with existing specifications