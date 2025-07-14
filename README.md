# AI Code Auditor

An AI-driven code auditor using spec-driven scanning to detect design patterns, algorithms, data structures, and DataHub entities in codebases.

## Overview

This repository contains comprehensive specifications and taxonomies for automated code analysis. The AI code auditor uses these specifications to identify and analyze various software engineering patterns and structures in your codebase.

### What It Detects

- **Design Patterns**: 25+ GoF and architectural patterns including Singleton, Factory, Observer, MVC, and more
- **Algorithms & Data Structures**: Sorting algorithms, search algorithms, trees, graphs, hash tables, and complexity analysis
- **DataHub Entities**: Datasets, ML features, models, lineage, governance aspects, and metadata patterns
- **Repository Discovery**: Comprehensive codebase analysis including project structure, documentation, development practices, code metrics, and team activity patterns

## Repository Structure

```
ai-code-auditor/
├── specs/                          # Machine-readable specifications
│   ├── design-patterns-spec.yaml   # Design pattern detection rules
│   ├── algorithms-data-structures-spec.yaml  # Algorithm and DS specs
│   ├── datahub-spec.yaml           # DataHub entity and aspect specs
│   ├── etl-subsystems-spec.yaml    # ETL subsystem detection rules
│   └── repo-discovery-spec.yaml    # Repository discovery patterns
├── docs/                           # Human-readable documentation
│   ├── Design-Patterns-Taxonomy.md # Pattern reference guide
│   ├── Algorithms-DS-Taxonomy.md   # Algorithm and DS reference
│   ├── DataHub-Taxonomy-Reference.md # DataHub entity guide
│   ├── ETL-Subsystems-Taxonomy.md  # ETL subsystem reference
│   └── Repository-Discovery-Taxonomy.md # Repository discovery guide
├── prompts/                        # AI agent prompt templates
│   ├── design-patterns-prompt.md   # Design pattern analysis prompts
│   ├── algorithms-ds-prompt.md     # Algorithm and DS analysis prompts
│   ├── datahub-prompt.md           # DataHub analysis prompts
│   ├── etl-subsystems-prompt.md    # ETL subsystem analysis prompts
│   └── repo-discovery-prompts.md   # Repository discovery prompts
├── scripts/                        # Automation scripts
│   └── repo-discovery.sh           # Automated repository discovery
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
   - ETL subsystems only: `specs/etl-subsystems-spec.yaml`
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

### Prompt Library

Ready-made prompt templates are available in the [`prompts/`](prompts/) directory. Copy the appropriate file and replace `[CODE_PATH]` with the path to your codebase or metadata repository. Templates include design pattern scans, algorithm and data structure analysis, DataHub metadata audits, ETL subsystem checks, and comprehensive repository discovery.

### Automated Repository Discovery

For comprehensive repository analysis, use the automated discovery script:

```bash
# Complete repository discovery
./scripts/repo-discovery.sh /path/to/repository

# Focus on specific areas
./scripts/repo-discovery.sh --area structure /path/to/repository
./scripts/repo-discovery.sh --area docs /path/to/repository
./scripts/repo-discovery.sh --area practices /path/to/repository

# Different output formats
./scripts/repo-discovery.sh --format json /path/to/repository
./scripts/repo-discovery.sh --format markdown /path/to/repository
./scripts/repo-discovery.sh --format html /path/to/repository

# Save to file
./scripts/repo-discovery.sh --output report.json /path/to/repository
```

The script analyzes:
- **Project Structure**: Languages, frameworks, build systems, dependencies
- **Documentation**: README, API docs, comments, architecture docs
- **Development Practices**: Version control, CI/CD, templates, commit quality
- **Code Metrics**: Repository size, complexity, test coverage
- **Team Activity**: Contributors, maintenance patterns, issue resolution

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

### Repository Discovery
```yaml
repository_discovery:
  - name: "PatternName"
    category: "project_structure|documentation|development_practices|code_metrics|team_activity"
    hints: ["indicator1", "indicator2", "file_pattern"]
    report_fields: ["assessment_field1", "assessment_field2"]
```

## Documentation

The `docs/` folder contains human-readable references:

- **Design-Patterns-Taxonomy.md**: Comprehensive guide to all supported design patterns with complexity ratings and use cases
- **Algorithms-DS-Taxonomy.md**: Reference for algorithms and data structures with time/space complexity analysis
- **DataHub-Taxonomy-Reference.md**: Complete guide to DataHub entities, aspects, and governance patterns
- **ETL-Subsystems-Taxonomy.md**: Reference for ETL subsystem patterns and data pipeline analysis
- **Repository-Discovery-Taxonomy.md**: Complete guide to repository discovery patterns, analysis areas, and assessment criteria

## Key Features

### Pattern Detection
- **Hint-based matching**: Uses keywords and code signatures for pattern identification
- **Quality assessment**: Evaluates implementation quality and best practices
- **Complexity analysis**: Provides time/space complexity information for algorithms
- **Comprehensive coverage**: Supports 25+ design patterns, major algorithms, and DataHub metadata

### Reporting
- **Structured output**: Consistent reporting format across all pattern types
- **Quality metrics**: Implementation quality scores and recommendations
- **Context awareness**: Understands pattern variants and anti-patterns
- **Actionable insights**: Provides specific improvement recommendations

## Use Cases

- **Code Review Automation**: Automatically identify patterns and assess code quality
- **Architecture Analysis**: Understand system design and architectural patterns
- **Technical Debt Assessment**: Identify anti-patterns and improvement opportunities
- **DataHub Governance**: Audit metadata completeness and governance practices
- **Repository Assessment**: Comprehensive codebase analysis and maturity evaluation
- **Development Process Analysis**: Evaluate team practices and workflow efficiency
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

This project is designed for defensive security and code quality analysis purposes only. Use responsibly for improving code quality and security posture.
