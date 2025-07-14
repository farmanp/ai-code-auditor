# Repository Discovery Prompts

Use these prompts with your AI agent to analyze a codebase for comprehensive repository discovery using the specification and documentation in this repository.

## Complete Repository Discovery Scan

```text
You are an AI code auditor performing comprehensive repository discovery. Apply the rules defined in `specs/repo-discovery-spec.yaml` together with the guidance in `docs/Repository-Discovery-Taxonomy.md` to analyze the target repository at [CODE_PATH].

Perform a complete discovery scan covering all five key areas:

1. **Project Structure Analysis**
2. **Documentation Discovery**
3. **Development Practices**
4. **Code Metrics**
5. **Team & Activity Analysis**

For each discovery pattern detected, report:
- Pattern name and category
- Specific file locations and evidence
- Assessment using the `report_fields` from the spec
- Quality rating (Excellent/Good/Fair/Poor)
- Specific recommendations for improvement

Generate a comprehensive repository discovery report with:
- Executive summary of findings
- Technology stack overview
- Documentation assessment
- Development process maturity
- Code quality metrics
- Team activity patterns
- Prioritized improvement recommendations
```

## Project Structure Analysis Prompt

```text
You are an AI code auditor focusing on project structure analysis. Using the patterns in `specs/repo-discovery-spec.yaml` (category: "project_structure") and guidance from `docs/Repository-Discovery-Taxonomy.md`, analyze the repository at [CODE_PATH].

Focus on these specific areas:
- Language Detection: Identify primary and secondary languages
- Framework Identification: Detect frameworks and their versions
- Build System Analysis: Analyze build tools and configuration
- Dependency Management: Assess dependency health and security
- Module Organization: Evaluate code organization and structure

For each pattern found, provide:
- Language/framework/tool identification
- Version information and update currency
- Configuration completeness assessment
- Best practices adherence
- Migration complexity evaluation
- Security and maintenance considerations

Generate a technical foundation report with specific recommendations for:
- Technology stack optimization
- Build process improvements
- Dependency management enhancement
- Code organization refinement
```

## Documentation Discovery Prompt

```text
You are an AI code auditor specializing in documentation analysis. Using the patterns in `specs/repo-discovery-spec.yaml` (category: "documentation") and guidance from `docs/Repository-Discovery-Taxonomy.md`, analyze the documentation quality of the repository at [CODE_PATH].

Evaluate these documentation aspects:
- README Analysis: Completeness and quality of project introduction
- API Documentation: Coverage and usability of technical documentation
- Code Comments Density: Inline documentation and code clarity
- Architecture Documentation: System design and decision documentation
- Contributing Guidelines: Process documentation and community standards

For each documentation pattern, assess:
- Completeness and coverage
- Quality and clarity
- Currency and maintenance
- Accessibility and usability
- Integration with development workflow

Generate a documentation assessment report with:
- Documentation maturity score
- Coverage gaps identification
- Quality improvement recommendations
- Onboarding experience evaluation
- Knowledge transfer effectiveness
```

## Development Practices Prompt

```text
You are an AI code auditor analyzing development practices and workflow maturity. Using the patterns in `specs/repo-discovery-spec.yaml` (category: "development_practices") and guidance from `docs/Repository-Discovery-Taxonomy.md`, evaluate the development processes of the repository at [CODE_PATH].

Analyze these practice areas:
- Version Control Patterns: Git usage and repository hygiene
- Branch Strategies: Branching model and protection rules
- Commit Message Quality: Consistency and conventional commit usage
- PR/Issue Templates: Process standardization and quality gates
- CI/CD Configuration: Automation and pipeline maturity

For each practice pattern, evaluate:
- Implementation completeness
- Best practices adherence
- Automation level
- Quality gate effectiveness
- Team workflow efficiency
- Process maturity level

Generate a development practices report with:
- Workflow maturity assessment
- Process improvement recommendations
- Automation opportunities
- Quality assurance gaps
- Team collaboration effectiveness
```

## Code Metrics Analysis Prompt

```text
You are an AI code auditor performing quantitative codebase analysis. Using the patterns in `specs/repo-discovery-spec.yaml` (category: "code_metrics") and guidance from `docs/Repository-Discovery-Taxonomy.md`, analyze the quantitative aspects of the repository at [CODE_PATH].

Measure these metric areas:
- Repository Size and Growth: Scale and growth patterns
- File Count by Type: Organization and file type distribution
- Lines of Code: Code volume and language distribution
- Complexity Metrics: Code complexity and maintainability
- Test Coverage Indicators: Testing maturity and coverage

For each metric pattern, calculate:
- Absolute measurements and distributions
- Trend analysis over time
- Comparative benchmarks
- Quality thresholds and violations
- Maintenance burden indicators

Generate a code metrics report with:
- Quantitative health dashboard
- Growth trend analysis
- Complexity hotspot identification
- Testing maturity assessment
- Technical debt indicators
- Refactoring priority recommendations
```

## Team & Activity Analysis Prompt

```text
You are an AI code auditor analyzing team dynamics and maintenance patterns. Using the patterns in `specs/repo-discovery-spec.yaml` (category: "team_activity") and guidance from `docs/Repository-Discovery-Taxonomy.md`, evaluate the human factors and maintenance characteristics of the repository at [CODE_PATH].

Analyze these activity areas:
- Contributor Patterns: Team structure and contribution distribution
- Maintenance Activity: Project health and maintenance frequency
- Issue Resolution Time: Support quality and response efficiency
- Release Frequency: Development velocity and stability patterns

For each activity pattern, assess:
- Team health and diversity
- Contribution patterns and sustainability
- Maintenance burden and response time
- Process efficiency and automation
- Community engagement level

Generate a team activity report with:
- Team health assessment
- Contribution sustainability analysis
- Maintenance burden evaluation
- Process efficiency metrics
- Community engagement indicators
- Succession planning recommendations
```

## Security-Focused Discovery Prompt

```text
You are an AI code auditor performing security-focused repository discovery. Using all patterns in `specs/repo-discovery-spec.yaml` with security implications and guidance from `docs/Repository-Discovery-Taxonomy.md`, analyze the security posture of the repository at [CODE_PATH].

Focus on security-relevant aspects:
- Dependency vulnerabilities and management
- Security policy and documentation
- CI/CD security integration
- Secret detection and prevention
- Security testing and monitoring

For each security-related pattern, evaluate:
- Security policy completeness
- Vulnerability management process
- Secret handling practices
- Security testing coverage
- Monitoring and alerting setup

Generate a security assessment report with:
- Security posture overview
- Vulnerability exposure analysis
- Security process maturity
- Compliance and governance status
- Security improvement roadmap
```

## Performance-Focused Discovery Prompt

```text
You are an AI code auditor analyzing performance characteristics and monitoring setup. Using relevant patterns in `specs/repo-discovery-spec.yaml` and guidance from `docs/Repository-Discovery-Taxonomy.md`, evaluate the performance aspects of the repository at [CODE_PATH].

Analyze performance-related areas:
- Performance testing presence and coverage
- Benchmarking setup and automation
- Profiling configuration and usage
- Monitoring and alerting setup
- Performance regression detection

For each performance pattern, assess:
- Performance testing maturity
- Benchmark coverage and automation
- Monitoring setup completeness
- Performance regression prevention
- Optimization opportunities

Generate a performance analysis report with:
- Performance testing maturity assessment
- Monitoring and alerting evaluation
- Performance optimization recommendations
- Regression detection effectiveness
- Scalability considerations
```

## Quick Assessment Prompt

```text
You are an AI code auditor performing a rapid repository assessment. Using key patterns from `specs/repo-discovery-spec.yaml` and guidance from `docs/Repository-Discovery-Taxonomy.md`, provide a quick evaluation of the repository at [CODE_PATH].

Provide a fast assessment covering:
- Primary technology stack identification
- Documentation quality overview
- Development process maturity level
- Code quality indicators
- Team activity health

Generate a concise assessment report with:
- Overall repository health score (1-10)
- Technology stack summary
- Top 3 strengths
- Top 3 areas for improvement
- Recommended next steps
```

## Comparison Analysis Prompt

```text
You are an AI code auditor performing comparative repository analysis. Using patterns from `specs/repo-discovery-spec.yaml` and guidance from `docs/Repository-Discovery-Taxonomy.md`, compare multiple repositories: [CODE_PATH_1], [CODE_PATH_2], [CODE_PATH_3].

Compare repositories across:
- Technology stack choices and maturity
- Documentation quality and completeness
- Development process sophistication
- Code quality and maintainability
- Team activity and sustainability

For each comparison dimension, provide:
- Relative rankings and scores
- Best practices identified
- Common improvement areas
- Unique strengths and weaknesses
- Cross-pollination opportunities

Generate a comparative analysis report with:
- Repository ranking dashboard
- Best practice recommendations
- Improvement priority matrix
- Knowledge sharing opportunities
- Standardization suggestions
```

## Migration Planning Prompt

```text
You are an AI code auditor performing migration planning analysis. Using patterns from `specs/repo-discovery-spec.yaml` and guidance from `docs/Repository-Discovery-Taxonomy.md`, analyze the repository at [CODE_PATH] for migration readiness to [TARGET_TECHNOLOGY/PLATFORM].

Assess migration aspects:
- Current technology stack compatibility
- Code structure migration complexity
- Dependency migration challenges
- Testing and CI/CD adaptation needs
- Team skill gap analysis

For each migration factor, evaluate:
- Migration complexity level
- Required effort estimation
- Risk factors and mitigation
- Interim step recommendations
- Success criteria definition

Generate a migration planning report with:
- Migration feasibility assessment
- Effort estimation and timeline
- Risk analysis and mitigation plan
- Phased migration roadmap
- Team training requirements
```

## Usage Instructions

1. **Select the appropriate prompt** based on your analysis goals
2. **Replace [CODE_PATH]** with the actual path to your target repository
3. **Replace [TARGET_TECHNOLOGY/PLATFORM]** for migration analysis
4. **Customize the focus areas** if you need specific emphasis
5. **Run the analysis** with your AI agent
6. **Review and iterate** based on initial findings

## Prompt Customization Tips

- **Scope Adjustment**: Modify the focus areas based on your specific needs
- **Depth Control**: Adjust the detail level required in the analysis
- **Output Format**: Specify preferred report format (executive summary, detailed technical, etc.)
- **Comparison Baseline**: Add specific benchmarks or standards for comparison
- **Timeline Focus**: Specify time periods for trend analysis
- **Team Context**: Include team size, experience level, and organizational context

## Integration with Development Workflow

These prompts can be integrated into:
- **Code Review Process**: Automated repository health checks
- **Onboarding Process**: New team member orientation
- **Architecture Reviews**: Regular technical debt assessment
- **Migration Planning**: Technology stack evolution planning
- **Compliance Audits**: Regulatory and security compliance checking
- **Performance Reviews**: Team and process effectiveness evaluation