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
│   ├── feasibility-analysis-spec.yaml # Feasibility analysis specifications
│   ├── security-vulnerabilities-spec.yaml    # Security vulnerability patterns
│   ├── etl-subsystems-spec.yaml    # ETL subsystems specifications
│   ├── cloud-architecture-spec.yaml # Cloud architecture patterns
│   └── repo-discovery-spec.yaml    # Repository discovery specifications
├── docs/                           # Technical reference documentation
│   ├── Design-Patterns-Taxonomy.md # Pattern reference guide
│   ├── Algorithms-DS-Taxonomy.md   # Algorithm and DS reference
│   ├── DataHub-Taxonomy-Reference.md # DataHub entity guide
│   ├── Feasibility-Analysis-Taxonomy.md # Feasibility analysis guide
│   ├── Security-Vulnerabilities-Taxonomy.md  # Security vulnerability guide
│   ├── ETL-Subsystems-Taxonomy.md  # ETL subsystems reference
│   ├── Cloud-Architecture-Taxonomy.md # Cloud architecture guide
│   ├── Repository-Discovery-Taxonomy.md # Repository discovery guide
│   ├── Prompt-Engineering-Guide.md     # How to craft effective prompts
│   ├── Prompt-Validation-Examples.md   # Example outputs for verification
│   ├── Pattern-Cross-Reference.md  # Matrix of relationships across taxonomies
│   └── Complexity-Guide.md          # Implementation difficulty ratings
├── guides/                         # User-focused guides
│   ├── getting-started.md          # Quick start and first audit
│   ├── audit-types-guide.md        # Deep dive into each audit type
│   ├── customization-guide.md      # Customizing specs and prompts
│   ├── integration-guide.md        # CI/CD and workflow integration
│   ├── best-practices.md           # Proven strategies and recommendations
│   └── troubleshooting.md          # Common issues and solutions
├── prompts/                        # AI prompt templates
│   ├── audit-types/                # Prompts organized by audit type
│   ├── scenarios/                  # Scenario specific prompts
│   ├── models/                     # Model optimization prompts
│   └── Prompt-Validation-Examples.md   # Example outputs for verification
├── prompts/                        # AI prompt templates
│   ├── audit-types/                # Prompts organized by audit type
│   ├── scenarios/                  # Scenario specific prompts
│   ├── models/                     # Model optimization prompts
│   ├── design-patterns-prompt.md   # Design pattern analysis prompts
│   ├── algorithms-ds-prompt.md     # Algorithm and DS analysis prompts
│   ├── datahub-prompt.md           # DataHub analysis prompts
│   ├── design-patterns-prompt.md   # Design pattern analysis prompts
│   ├── algorithms-ds-prompt.md     # Algorithm and DS analysis prompts
│   ├── datahub-prompt.md          # DataHub analysis prompts
│   ├── feasibility-audit-prompts.md # Feasibility analysis prompts
│   ├── security-audit-prompts.md   # Security audit prompt library
│   ├── etl-subsystems-prompt.md    # ETL subsystems analysis prompts
│   ├── cloud-audit-prompts.md      # Cloud architecture analysis prompts
│   └── repo-discovery-prompts.md   # Repository discovery prompts
├── templates/                      # Report generation templates
│   └── feasibility-report-template.md # Feasibility analysis report template
├── workflows/                     # Workflow templates
│   ├── ci-cd/                     # CI/CD examples
│   ├── pre-commit/                # Pre-commit hooks
│   └── scheduled/                 # Scheduled audits
├── scripts/                        # Utility scripts
│   ├── repo-discovery.sh           # Repository discovery script
│   ├── relationship_graph.py       # Generate cross-reference graphs
│   └── search_relationships.py     # Search related items
└── README.md                       # This file
```

## Quick Start

**New users**: Start with the [Getting Started Guide](guides/getting-started.md) for a 5-minute walkthrough.

To perform a code audit using an AI agent:

1. **Point your AI agent at the `specs/` folder** - The YAML files contain machine-readable specifications that AI agents can parse and use for pattern detection.

2. **Specify the target codebase** - Provide the path to the code you want to analyze.

3. **Select scan types** - Choose which specifications to use:
   - Design patterns only: `specs/design-patterns-spec.yaml`
   - Algorithms/DS only: `specs/algorithms-data-structures-spec.yaml`
   - DataHub entities only: `specs/datahub-spec.yaml`
   - Feasibility analysis only: `specs/feasibility-analysis-spec.yaml`
   - Security vulnerabilities only: `specs/security-vulnerabilities-spec.yaml`
   - ETL subsystems only: `specs/etl-subsystems-spec.yaml`
   - Cloud architecture only: `specs/cloud-architecture-spec.yaml`
   - Repository discovery only: `specs/repo-discovery-spec.yaml`
   - All patterns: Use all spec files

4. **Review results** - The AI agent will generate reports based on the `report_fields` specified in each pattern.

### Example AI Agent Prompt

```
Please analyze the codebase at [PATH] using the specifications in the ai-code-auditor/specs/ folder.
Focus on detecting design patterns and provide a detailed report including:
- Pattern instances found
- Implementation quality assessment
- Recommendations for improvements
```

### Comprehensive Guides

- **[Getting Started Guide](guides/getting-started.md)** - First steps, quick wins, and understanding reports
- **[Audit Types Guide](guides/audit-types-guide.md)** - Deep dive into each audit type and when to use them
- **[Customization Guide](guides/customization-guide.md)** - Writing custom specifications and extending functionality
- **[Integration Guide](guides/integration-guide.md)** - CI/CD integration, Git hooks, and team workflows
- **[Best Practices Guide](guides/best-practices.md)** - Proven strategies for effective usage
- **[Troubleshooting Guide](guides/troubleshooting.md)** - Common issues and solutions

### Prompt Library

Ready-made prompt templates are available in the [`prompts/`](prompts/) directory. Copy the appropriate file and replace `[CODE_PATH]` with the path to your codebase or metadata repository. The library includes:
* **Audit-type prompts** under `prompts/audit-types/`
* **Scenario prompts** under `prompts/scenarios/`
* **Model optimizations** under `prompts/models/`
* **Base prompts** for design patterns, algorithms, DataHub, ETL, security, cloud architecture, and feasibility analysis

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
    related:
      algorithms: ["AlgorithmName"]
      datahub: ["EntityName"]
      security: ["SecurityConcern"]
      cloud: ["CloudPattern"]
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
    related_patterns: ["DesignPatternName"]
```

### DataHub Entities
```yaml
datahub_entities:
  - name: "EntityName"
    urn_pattern: "urn:li:entityType:*"
    aspect_name: "primaryAspect"
    report_fields: ["metadata_field1", "metadata_field2"]
    related_patterns: ["DesignPatternName"]
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

### User Guides (Start Here!)
- **[Getting Started Guide](guides/getting-started.md)** - Your first audit in 5 minutes
- **[Audit Types Guide](guides/audit-types-guide.md)** - Comprehensive overview of all audit types
- **[Customization Guide](guides/customization-guide.md)** - Tailor the tool for your organization
- **[Integration Guide](guides/integration-guide.md)** - CI/CD pipelines and team workflows  
- **[Best Practices Guide](guides/best-practices.md)** - Proven strategies for success
- **[Troubleshooting Guide](guides/troubleshooting.md)** - Solutions to common issues

### Technical Reference
The `docs/` folder contains detailed technical references:

- **Design-Patterns-Taxonomy.md**: Comprehensive guide to all supported design patterns with complexity ratings and use cases
- **Algorithms-DS-Taxonomy.md**: Reference for algorithms and data structures with time/space complexity analysis
- **DataHub-Taxonomy-Reference.md**: Complete guide to DataHub entities, aspects, and governance patterns
- **Feasibility-Analysis-Taxonomy.md**: Comprehensive guide to feasibility analysis including migration assessment, refactoring evaluation, and resource planning
- **Security-Vulnerabilities-Taxonomy.md**: Complete guide to security vulnerabilities based on OWASP Top 10 2021
- **ETL-Subsystems-Taxonomy.md**: Reference for 38 ETL subsystems with detection patterns and implementation guidance
- **Cloud-Architecture-Taxonomy.md**: Guide to cloud-native patterns and architecture best practices
- **Repository-Discovery-Taxonomy.md**: Reference for codebase analysis and technology stack discovery
- **Pattern-Cross-Reference.md**: Matrix of relationships across taxonomies
- **Complexity-Guide.md**: Implementation difficulty, detection effort, and performance impact ratings

### Visualization and Search

Run `scripts/relationship_graph.py` to generate a Graphviz `.dot` file showing cross-taxonomy links. Use `scripts/search_relationships.py [TERM]` to list related items for a specific term.

### Complexity Ratings

Complexity ratings help users understand implementation difficulty, detection effort, and performance impact of each pattern. Ratings are defined in the [Complexity Rating Guide](docs/Complexity-Guide.md) and applied consistently across all YAML specifications.

## Key Features

### Pattern Detection
- **Hint-based matching**: Uses keywords and code signatures for pattern identification
- **Quality assessment**: Evaluates implementation quality and best practices
- **Complexity ratings**: Standardized implementation, detection, and performance levels
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
