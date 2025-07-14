# AI Code Auditor

An AI-driven code auditor using spec-driven scanning to detect design patterns, algorithms, data structures, and DataHub entities in codebases.

## Overview

This repository contains comprehensive specifications and taxonomies for automated code analysis. The AI code auditor uses these specifications to identify and analyze various software engineering patterns and structures in your codebase.

### What It Detects

- **Design Patterns**: 25+ GoF and architectural patterns including Singleton, Factory, Observer, MVC, and more
- **Algorithms & Data Structures**: Sorting algorithms, search algorithms, trees, graphs, hash tables, and complexity analysis
- **DataHub Entities**: Datasets, ML features, models, lineage, governance aspects, and metadata patterns
- **Feasibility Analysis**: Migration readiness, refactoring assessment, integration analysis, technical debt evaluation, and resource planning
- **Security Vulnerabilities**: OWASP Top 10 vulnerabilities, cryptographic failures, injection attacks, and security misconfigurations
- **ETL Subsystems**: 38 data warehouse subsystems including extraction, transformation, loading, quality management, and workflow orchestration

## Repository Structure

```
ai-code-auditor/
├── specs/                          # Machine-readable specifications
│   ├── design-patterns-spec.yaml   # Design pattern detection rules
│   ├── algorithms-data-structures-spec.yaml  # Algorithm and DS specs
│   ├── datahub-spec.yaml           # DataHub entity and aspect specs
│   └── feasibility-analysis-spec.yaml # Feasibility analysis specifications
│   └── security-vulnerabilities-spec.yaml    # Security vulnerability patterns
├── docs/                           # Human-readable documentation
│   ├── Design-Patterns-Taxonomy.md # Pattern reference guide
│   ├── Algorithms-DS-Taxonomy.md   # Algorithm and DS reference
│   ├── DataHub-Taxonomy-Reference.md # DataHub entity guide
│   └── Feasibility-Analysis-Taxonomy.md # Feasibility analysis guide
├── prompts/                        # Ready-made AI agent prompts
│   ├── design-patterns-prompt.md   # Design pattern analysis prompts
│   ├── algorithms-ds-prompt.md     # Algorithm and DS analysis prompts
│   ├── datahub-prompt.md          # DataHub analysis prompts
│   └── feasibility-audit-prompts.md # Feasibility analysis prompts
├── templates/                      # Report generation templates
│   └── feasibility-report-template.md # Feasibility analysis report template
│   └── Security-Vulnerabilities-Taxonomy.md  # Security vulnerability guide
├── workflows/                     # Workflow templates
│   ├── ci-cd/                     # CI/CD examples
│   ├── pre-commit/                # Pre-commit hooks
│   └── scheduled/                 # Scheduled audits
├── prompts/                        # AI prompt templates
│   └── security-audit-prompts.md   # Security audit prompt library
└── README.md                       # This file
```

## How to Run a Scan

To perform a code audit using an AI agent:

1. **Point your AI agent at the `specs/` folder** - The YAML files contain machine-readable specifications that AI agents can parse and use for pattern detection.

2. **Specify the target codebase** - Provide the path to the code you want to analyze.

3. **Select scan types** - Choose which specifications to use:
   - Design patterns only: `specs/design-patterns-spec.yaml`
   - Algorithms/DS only: `specs/algorithms-data-structures-spec.yaml`
   - DataHub entities only: `specs/datahub-spec.yaml`
   - Feasibility analysis only: `specs/feasibility-analysis-spec.yaml`
   - Security vulnerabilities only: `specs/security-vulnerabilities-spec.yaml`
   - All patterns: Use all spec files
   - ETL subsystems only: `specs/etl-subsystems-spec.yaml`
   - All patterns: Use all four spec files

4. **Review results** - The AI agent will generate reports based on the `report_fields` specified in each pattern.

### Example AI Agent Prompt

```
Please analyze the codebase at [PATH] using the specifications in the ai-code-auditor/specs/ folder.
Focus on detecting design patterns and provide a detailed report including:
- Pattern instances found
- Implementation quality assessment
- Recommendations for improvements
```

### Prompt Library

Ready-made prompt templates are available in the [`prompts/`](prompts/) directory. Copy the appropriate file and replace `[CODE_PATH]` with the path to your codebase or metadata repository. Templates include design pattern scans, algorithm and data structure analysis, DataHub metadata audits, ETL subsystem checks, and comprehensive feasibility analysis.

### Workflow Templates

Reusable examples for CI pipelines, pre-commit hooks, and scheduled tasks live in the [`workflows/`](workflows/) directory. See [Workflow-Customization-Guide](docs/Workflow-Customization-Guide.md) for guidance on adapting them to your environment.
## Specification Schema

Each YAML specification follows a consistent schema:

### Design Patterns
```yaml
patterns:
  - name: "PatternName"
    category: "creational|structural|behavioral|architectural"
    hints: ["keyword1", "keyword2", "signature"]
    report_fields: ["field1", "field2", "quality_metric"]
```

### Algorithms & Data Structures
```yaml
algorithms_and_data_structures:
  - name: "AlgorithmName"
    category: "sorting|searching|data_structure"
    paths: ["implementation_paths"]
    hints: ["characteristic_keywords"]
    time_complexity: "O(n)"
    space_complexity: "O(1)"
    report_fields: ["implementation_quality", "optimization"]
```

### DataHub Entities
```yaml
datahub_entities:
  - name: "EntityName"
    urn_pattern: "urn:li:entityType:*"
    aspect_name: "primaryAspect"
    report_fields: ["metadata_field1", "metadata_field2"]
```

### Feasibility Analysis
```yaml
feasibility_analysis:
  - name: "AnalysisName"
    category: "migration|refactoring|integration|technical_debt|resources"
    analysis_type: "specific_analysis_type"
    hints: ["keyword1", "keyword2", "indicator"]
    report_fields: ["assessment_field1", "assessment_field2"]
```    
   
### Security Vulnerabilities
```yaml
vulnerabilities:
  - name: "VulnerabilityName"
    category: "injection|authentication|authorization"
    owasp_category: "A01:2021 – Category Name"
    severity: "Critical|High|Medium|Low"
    detection_hints: ["pattern1", "pattern2"]
   report_fields: ["location", "severity", "remediation"]
```

### ETL Subsystems
```yaml
etl_subsystems:
  - name: "SubsystemName"
    id: 1
    category: "data_acquisition|data_quality|dimension_management|fact_loading|performance|workflow|development|compliance|infrastructure"
    hints: ["characteristic_keywords", "process_indicators"]
    report_fields: ["implementation_aspect", "integration_quality"]
```

## Documentation

The `docs/` folder contains human-readable references:

- **Design-Patterns-Taxonomy.md**: Comprehensive guide to all supported design patterns with complexity ratings and use cases
- **Algorithms-DS-Taxonomy.md**: Reference for algorithms and data structures with time/space complexity analysis
- **DataHub-Taxonomy-Reference.md**: Complete guide to DataHub entities, aspects, and governance patterns
- **Feasibility-Analysis-Taxonomy.md**: Comprehensive guide to feasibility analysis including migration assessment, refactoring evaluation, and resource planning
- **Security-Vulnerabilities-Taxonomy.md**: Complete guide to security vulnerabilities based on OWASP Top 10 2021
- **ETL-Subsystems-Taxonomy.md**: Reference for 38 ETL subsystems with detection patterns and implementation guidance

## Key Features

### Pattern Detection
- **Hint-based matching**: Uses keywords and code signatures for pattern identification
- **Quality assessment**: Evaluates implementation quality and best practices
- **Complexity analysis**: Provides time/space complexity information for algorithms
- **Feasibility evaluation**: Assesses migration readiness, refactoring opportunities, and integration complexity
- **Comprehensive coverage**: Supports 25+ design patterns, major algorithms, DataHub metadata, and feasibility analysis
- **Security analysis**: Detects OWASP Top 10 vulnerabilities with severity ratings
- **Comprehensive coverage**: Supports 25+ design patterns, major algorithms, DataHub metadata, and security vulnerabilities
- **Comprehensive coverage**: Supports 25+ design patterns, major algorithms, DataHub metadata, and 38 ETL subsystems

### Reporting
- **Structured output**: Consistent reporting format across all pattern types
- **Quality metrics**: Implementation quality scores and recommendations
- **Context awareness**: Understands pattern variants and anti-patterns
- **Actionable insights**: Provides specific improvement recommendations

## Use Cases

- **Code Review Automation**: Automatically identify patterns and assess code quality
- **Security Vulnerability Assessment**: Detect OWASP Top 10 vulnerabilities and security misconfigurations
- **Architecture Analysis**: Understand system design and architectural patterns
- **Technical Debt Assessment**: Identify anti-patterns and improvement opportunities
- **DataHub Governance**: Audit metadata completeness and governance practices
- **Feasibility Assessment**: Evaluate migration readiness, refactoring opportunities, and integration complexity
- **Educational Analysis**: Learn about patterns and algorithms in existing codebases
- **Migration Planning**: Understand current patterns before refactoring

## Next Steps

1. **Extend Specifications**: Add more patterns, algorithms, or domain-specific rules
2. **Custom Report Fields**: Modify report fields to match your analysis needs
3. **Integration**: Integrate with CI/CD pipelines for automated code quality checks
4. **Metrics Dashboard**: Build dashboards to track pattern usage and code quality over time
5. **Team Training**: Use detection results to identify learning opportunities

## Contributing

To add new patterns or improve existing specifications:

1. Update the relevant YAML file in `specs/`
2. Add documentation to the corresponding file in `docs/`
3. Ensure the pattern includes appropriate hints and report fields
4. Test with sample codebases to validate detection accuracy

## License

This project is designed for defensive security and code quality analysis purposes only. Use responsibly for improving code quality and security posture.a
