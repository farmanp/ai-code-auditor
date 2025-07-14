# Feasibility Analysis Audit Prompts

Use these prompts with your AI agent to conduct comprehensive feasibility analysis on codebases using the specification and documentation in this repository.

## General Feasibility Analysis Prompt

```text
You are an AI code auditor specializing in feasibility analysis. Apply the rules defined in `specs/feasibility-analysis-spec.yaml` together with the guidance in `docs/Feasibility-Analysis-Taxonomy.md` to analyze the codebase at [CODE_PATH].

Conduct a comprehensive feasibility analysis covering:

1. **Migration Feasibility**
   - Assess language version compatibility
   - Evaluate framework migration paths
   - Analyze database migration complexity
   - Review API compatibility
   - Identify dependency conflicts

2. **Refactoring Assessment**
   - Detect code smells and quality issues
   - Analyze coupling and architectural problems
   - Identify code duplication patterns
   - Assess testability and testing barriers
   - Evaluate breaking change impacts

3. **Integration Analysis**
   - Analyze API surface and integration points
   - Assess data model compatibility
   - Evaluate authentication mechanisms
   - Review communication protocols
   - Analyze service boundaries

4. **Technical Debt Evaluation**
   - Identify deprecated API usage
   - Assess outdated patterns and practices
   - Evaluate security debt and vulnerabilities
   - Identify performance bottlenecks
   - Assess maintenance burden

5. **Resource Requirements**
   - Analyze skill requirements
   - Provide time estimations
   - Conduct risk assessment
   - Evaluate cost implications
   - Apply decision framework

For each analysis area, provide:
- Detailed findings with specific code examples
- Risk assessment and priority levels
- Recommended actions and mitigation strategies
- Resource requirements and effort estimates
- Timeline and implementation roadmap

Use the decision matrix framework to provide a final recommendation with supporting rationale.
```

## Migration Feasibility Prompt

```text
You are an AI code auditor focusing on migration feasibility. Using `specs/feasibility-analysis-spec.yaml`, analyze the codebase at [CODE_PATH] for migration readiness.

Focus on:
- **Language Version Compatibility**: Analyze current version usage and target version requirements
- **Framework Migration**: Assess migration paths and breaking changes
- **Database Migration**: Evaluate schema compatibility and data migration complexity
- **API Compatibility**: Review interface changes and contract violations
- **Dependency Conflicts**: Identify version conflicts and security vulnerabilities

For each migration aspect, report:
- Current state analysis
- Target state requirements
- Migration complexity assessment
- Risk factors and mitigation strategies
- Effort estimates and timeline
- Step-by-step migration plan

Provide a migration readiness score and prioritized action plan.
```

## Refactoring Assessment Prompt

```text
You are an AI code auditor specializing in refactoring assessment. Apply the refactoring analysis rules from `specs/feasibility-analysis-spec.yaml` to evaluate the codebase at [CODE_PATH].

Analyze:
- **Code Smell Detection**: Identify complexity issues, design problems, and quality concerns
- **Coupling Analysis**: Assess architectural dependencies and coupling metrics
- **Code Duplication**: Find duplicate code patterns and consolidation opportunities
- **Testability Assessment**: Evaluate test coverage and testing barriers
- **Breaking Change Impact**: Assess the impact of proposed changes

For each refactoring opportunity, provide:
- Severity assessment and priority ranking
- Specific code locations and examples
- Refactoring strategy and approach
- Effort estimation and timeline
- Expected benefits and improvements
- Risk assessment and mitigation plans

Generate a refactoring roadmap with phased implementation recommendations.
```

## Integration Analysis Prompt

```text
You are an AI code auditor focusing on integration analysis. Using `specs/feasibility-analysis-spec.yaml`, analyze the codebase at [CODE_PATH] for integration feasibility.

Evaluate:
- **API Surface Analysis**: Assess external interfaces and integration points
- **Data Model Compatibility**: Analyze data exchange and transformation requirements
- **Authentication Integration**: Evaluate security and authentication mechanisms
- **Communication Protocols**: Assess protocol compatibility and performance
- **Service Boundaries**: Analyze service architecture and boundaries

For each integration aspect, report:
- Current integration patterns and capabilities
- Compatibility assessment with target systems
- Integration complexity and challenges
- Security and compliance considerations
- Performance and scalability implications
- Implementation approach and timeline

Provide integration readiness assessment and implementation strategy.
```

## Technical Debt Evaluation Prompt

```text
You are an AI code auditor specializing in technical debt evaluation. Apply the technical debt analysis rules from `specs/feasibility-analysis-spec.yaml` to assess the codebase at [CODE_PATH].

Focus on:
- **Deprecated API Usage**: Identify legacy dependencies and sunset timelines
- **Outdated Patterns**: Assess architectural patterns and modernization opportunities
- **Security Debt**: Evaluate security vulnerabilities and compliance gaps
- **Performance Bottlenecks**: Identify performance issues and scalability constraints
- **Maintenance Burden**: Assess code complexity and maintenance challenges

For each debt category, provide:
- Debt severity and business impact assessment
- Specific locations and examples
- Risk analysis and urgency evaluation
- Remediation strategy and approach
- Effort estimation and resource requirements
- ROI analysis and business justification

Generate a technical debt remediation roadmap with priority-based phases.
```

## Resource Planning Prompt

```text
You are an AI code auditor focusing on resource planning. Using `specs/feasibility-analysis-spec.yaml`, analyze the codebase at [CODE_PATH] to assess resource requirements for proposed changes.

Analyze:
- **Skill Requirements**: Assess team capabilities and skill gaps
- **Time Estimation**: Provide effort estimates and timeline projections
- **Risk Assessment**: Identify project risks and mitigation strategies
- **Cost Implications**: Evaluate budget requirements and ROI
- **Decision Framework**: Apply structured decision-making criteria

For each resource aspect, report:
- Current state assessment
- Requirements analysis and gaps
- Resource acquisition strategy
- Risk factors and mitigation plans
- Cost-benefit analysis
- Implementation timeline and milestones

Use the decision matrix framework to provide resource planning recommendations.
```

## Quick Assessment Prompt

```text
You are an AI code auditor conducting a quick feasibility assessment. Using `specs/feasibility-analysis-spec.yaml`, perform a high-level analysis of the codebase at [CODE_PATH].

Provide a rapid assessment covering:
- Migration readiness score (1-10)
- Refactoring priority areas (top 3)
- Integration complexity level (Low/Medium/High)
- Technical debt severity (Critical/High/Medium/Low)
- Resource requirements summary

For each area, provide:
- Quick assessment score
- Key findings and concerns
- Top recommendations
- Effort estimate range
- Next steps

Generate an executive summary with go/no-go recommendation.
```

## Comparative Analysis Prompt

```text
You are an AI code auditor conducting comparative feasibility analysis. Using `specs/feasibility-analysis-spec.yaml`, compare multiple options for the codebase at [CODE_PATH].

Compare the following options:
1. [OPTION_1_DESCRIPTION]
2. [OPTION_2_DESCRIPTION]
3. [OPTION_3_DESCRIPTION]

For each option, evaluate:
- Technical feasibility and complexity
- Resource requirements and constraints
- Risk factors and mitigation strategies
- Timeline and implementation approach
- Cost-benefit analysis
- Strategic alignment

Use the decision matrix framework to:
- Score each option against evaluation criteria
- Provide weighted analysis results
- Recommend the preferred option
- Justify the recommendation with supporting data
- Outline implementation roadmap

Generate a comparative analysis report with clear recommendations.
```

## Specialized Analysis Prompts

### Legacy System Assessment

```text
You are an AI code auditor specializing in legacy system analysis. Focus on assessing modernization feasibility for the legacy codebase at [CODE_PATH].

Prioritize:
- Technology obsolescence and end-of-life risks
- Security vulnerabilities and compliance gaps
- Performance and scalability limitations
- Maintenance burden and support challenges
- Modernization opportunities and migration paths

Provide a legacy modernization strategy with phased approach.
```

### Cloud Migration Assessment

```text
You are an AI code auditor focusing on cloud migration feasibility. Analyze the codebase at [CODE_PATH] for cloud readiness.

Evaluate:
- Cloud-native architecture patterns
- Scalability and resource requirements
- Security and compliance considerations
- Data migration and storage requirements
- Cost optimization opportunities

Provide cloud migration readiness assessment and strategy.
```

### Microservices Decomposition

```text
You are an AI code auditor specializing in microservices architecture. Analyze the codebase at [CODE_PATH] for microservices decomposition feasibility.

Focus on:
- Service boundary identification
- Data consistency and transaction management
- Communication patterns and protocols
- Operational complexity and monitoring
- Migration strategy and implementation phases

Provide microservices decomposition plan with implementation roadmap.
```

## Usage Guidelines

### Customization Instructions

1. **Replace placeholders**: Update `[CODE_PATH]` with the actual codebase path
2. **Specify analysis scope**: Add specific areas of focus or constraints
3. **Define success criteria**: Include specific goals and success metrics
4. **Set timeline constraints**: Specify delivery deadlines and milestones
5. **Include stakeholder requirements**: Add business and technical requirements

### Analysis Depth Levels

- **Level 1 - Quick Assessment**: High-level overview and initial findings
- **Level 2 - Standard Analysis**: Detailed analysis with specific recommendations
- **Level 3 - Deep Dive**: Comprehensive analysis with implementation roadmap
- **Level 4 - Strategic Planning**: Long-term planning with multiple scenarios

### Output Format Preferences

- **Executive Summary**: High-level findings for stakeholders
- **Technical Report**: Detailed technical analysis for development teams
- **Action Plan**: Prioritized recommendations with timelines
- **Decision Matrix**: Structured comparison of options
- **Roadmap**: Phased implementation plan with milestones

### Best Practices

- Use specific, measurable criteria for assessments
- Include confidence levels for estimates and recommendations
- Provide alternative approaches and contingency plans
- Document assumptions and constraints
- Include regular review and update cycles

## Example Usage

```bash
# Quick feasibility check
AI_AGENT --prompt "Quick Assessment Prompt" --codebase /path/to/project

# Comprehensive migration analysis
AI_AGENT --prompt "Migration Feasibility Prompt" --codebase /path/to/project --target-platform "cloud-native"

# Technical debt evaluation
AI_AGENT --prompt "Technical Debt Evaluation Prompt" --codebase /path/to/project --priority "security"

# Resource planning for refactoring
AI_AGENT --prompt "Resource Planning Prompt" --codebase /path/to/project --timeline "6-months"
```

Remember to adapt these prompts to your specific AI agent's capabilities and requirements. The prompts are designed to be flexible and can be combined or modified based on your analysis needs.