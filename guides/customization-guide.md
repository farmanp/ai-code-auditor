# Customization Guide

This guide shows you how to customize the AI Code Auditor for your specific needs, including writing custom specifications, extending existing patterns, creating new audit types, and customizing report formats.

## Overview of Customization Options

The AI Code Auditor is designed to be highly customizable:

| Customization Level | Complexity | Time Required | Use Cases |
|-------------------|------------|---------------|-----------|
| Modify report fields | Low | 10-30 min | Adjust output format |
| Add new patterns | Medium | 1-2 hours | Extend existing audit types |
| Create custom specs | High | 2-4 hours | New audit categories |
| Custom prompts | Low | 30-60 min | Tailor AI agent instructions |

## Understanding the Specification Schema

All audit types follow a consistent YAML schema. Understanding this structure is key to effective customization.

### Core Schema Elements

```yaml
# Generic pattern structure
patterns: # or algorithms_and_data_structures, vulnerabilities, etc.
  - name: "PatternName"           # Unique identifier
    category: "pattern_category"   # Grouping classification
    hints: ["keyword1", "keyword2"] # Detection indicators
    report_fields: ["field1", "field2"] # What to analyze and report
    # Additional type-specific fields
```

### Specification Types

#### 1. Design Patterns (`design-patterns-spec.yaml`)
```yaml
patterns:
  - name: "Observer"
    category: "behavioral"
    hints:
      - "addObserver"
      - "notifyObservers"
      - "Observable"
      - "listener pattern"
    report_fields:
      - "observer_registration"
      - "notification_mechanism"
      - "loose_coupling"
      - "event_handling"
```

#### 2. Security Vulnerabilities (`security-vulnerabilities-spec.yaml`)
```yaml
vulnerabilities:
  - name: "SQL Injection"
    category: "injection"
    owasp_category: "A03:2021 – Injection"
    severity: "Critical"
    detection_hints:
      - "string concatenation in SQL"
      - "dynamic query building"
      - "user input in query"
    report_fields:
      - "location"
      - "severity"
      - "remediation"
      - "affected_data"
```

#### 3. Algorithms & Data Structures (`algorithms-data-structures-spec.yaml`)
```yaml
algorithms_and_data_structures:
  - name: "Binary Search"
    category: "searching"
    time_complexity: "O(log n)"
    space_complexity: "O(1)"
    hints:
      - "divide and conquer"
      - "sorted array"
      - "middle element"
      - "log n complexity"
    report_fields:
      - "implementation_correctness"
      - "edge_case_handling"
      - "complexity_optimization"
```

## Customizing Existing Specifications

### 1. Adding New Report Fields

**Scenario**: You want additional analysis for security vulnerabilities.

**Original**:
```yaml
vulnerabilities:
  - name: "Cross-Site Scripting (XSS)"
    report_fields:
      - "location"
      - "severity"
      - "remediation"
```

**Customized**:
```yaml
vulnerabilities:
  - name: "Cross-Site Scripting (XSS)"
    report_fields:
      - "location"
      - "severity"
      - "remediation"
      - "business_impact"        # New field
      - "compliance_violation"   # New field
      - "exploit_difficulty"     # New field
```

### 2. Extending Detection Hints

**Scenario**: Your team uses custom naming conventions.

**Original**:
```yaml
patterns:
  - name: "Singleton"
    hints:
      - "private constructor"
      - "static instance"
      - "getInstance()"
```

**Customized**:
```yaml
patterns:
  - name: "Singleton"
    hints:
      - "private constructor"
      - "static instance"
      - "getInstance()"
      - "getSharedInstance()"    # Your custom method name
      - "sharedManager"          # Your naming convention
      - "@Singleton"             # Your annotation
```

### 3. Adding Organization-Specific Patterns

```yaml
patterns:
  - name: "CompanyServicePattern"
    category: "architectural"
    hints:
      - "extends BaseCompanyService"
      - "@CompanyService"
      - "implements CompanyServiceInterface"
    report_fields:
      - "service_registration"
      - "dependency_injection"
      - "error_handling_compliance"
      - "logging_standard_adherence"
```

## Creating New Audit Types

### Step 1: Define Your Domain

Let's create a "Mobile App Patterns" audit type for mobile development.

```yaml
# specs/mobile-patterns-spec.yaml
mobile_patterns:
  - name: "Navigation Drawer"
    category: "ui_pattern"
    platform: "android"
    hints:
      - "NavigationView"
      - "DrawerLayout"
      - "ActionBarDrawerToggle"
    report_fields:
      - "accessibility_compliance"
      - "menu_structure"
      - "gesture_handling"

  - name: "Tab Bar Controller"
    category: "ui_pattern"
    platform: "ios"
    hints:
      - "UITabBarController"
      - "tabBarItem"
      - "selectedIndex"
    report_fields:
      - "tab_count"
      - "badge_implementation"
      - "customization_level"

  - name: "Pull to Refresh"
    category: "interaction_pattern"
    platform: "cross_platform"
    hints:
      - "UIRefreshControl"
      - "SwipeRefreshLayout"
      - "pull to refresh"
    report_fields:
      - "refresh_logic"
      - "loading_indicators"
      - "error_handling"
```

### Step 2: Create Documentation

```markdown
# docs/Mobile-Patterns-Taxonomy.md

# Mobile App Patterns Taxonomy

## Overview
This taxonomy defines mobile-specific patterns for iOS and Android applications...

## UI Patterns
### Navigation Drawer (Android)
- **Purpose**: Provides in-app navigation access
- **Implementation**: Uses NavigationView with DrawerLayout
- **Best Practices**: Follow Material Design guidelines

### Tab Bar Controller (iOS)
- **Purpose**: Organize app content into logical sections
- **Implementation**: UITabBarController with multiple view controllers
- **Best Practices**: Limit to 5 tabs, use appropriate icons
```

### Step 3: Create Prompts

```markdown
# prompts/mobile-patterns-prompt.md

# Mobile Patterns Scan Prompt

You are an AI code auditor specializing in mobile app patterns. Apply the rules defined in `specs/mobile-patterns-spec.yaml` together with the guidance in `docs/Mobile-Patterns-Taxonomy.md` to scan the mobile application at [CODE_PATH].

For each detected mobile pattern, report:
- File locations and line numbers
- Pattern implementation quality
- Platform-specific best practice compliance
- Accessibility considerations
- Performance implications
- User experience assessment
```

## Customizing Report Fields

### Standard Report Field Types

| Field Type | Purpose | Example Values |
|------------|---------|----------------|
| Quality Score | Numeric assessment | 1-10, A-F, Poor/Good/Excellent |
| Compliance | Standards adherence | OWASP compliant, Violates policy |
| Performance | Efficiency metrics | O(n²), Memory leak risk |
| Security | Risk assessment | Critical, High, Medium, Low |
| Maintainability | Code quality | Readable, Complex, Refactor needed |

### Custom Report Field Examples

#### Business-Focused Fields
```yaml
report_fields:
  - "business_value_impact"      # How pattern affects business metrics
  - "user_experience_score"      # UX quality assessment
  - "competitive_advantage"      # Strategic importance
  - "regulatory_compliance"      # Legal/regulatory adherence
```

#### Technical Depth Fields
```yaml
report_fields:
  - "implementation_complexity"  # Development difficulty
  - "testing_coverage"          # Test completeness
  - "documentation_quality"     # Documentation assessment
  - "scalability_concerns"      # Growth limitations
```

#### Team-Specific Fields
```yaml
report_fields:
  - "team_expertise_required"   # Skill level needed
  - "maintenance_burden"        # Ongoing effort
  - "onboarding_difficulty"     # Learning curve
  - "tool_compatibility"       # Integration with current tools
```

## Advanced Customization Scenarios

### Scenario 1: Industry-Specific Compliance

**Healthcare HIPAA Compliance Audit**

```yaml
# specs/hipaa-compliance-spec.yaml
hipaa_compliance:
  - name: "PHI Data Handling"
    category: "data_protection"
    regulation: "HIPAA"
    hints:
      - "patient data"
      - "medical records"
      - "PHI"
      - "encryption"
    report_fields:
      - "encryption_status"
      - "access_controls"
      - "audit_logging"
      - "data_minimization"
      - "consent_management"

  - name: "Authentication Controls"
    category: "access_control"
    regulation: "HIPAA"
    hints:
      - "multi-factor authentication"
      - "session management"
      - "password policy"
    report_fields:
      - "mfa_implementation"
      - "session_timeout"
      - "password_strength"
      - "failed_attempt_handling"
```

### Scenario 2: Technology Stack Specific

**React.js Best Practices Audit**

```yaml
# specs/react-best-practices-spec.yaml
react_patterns:
  - name: "Hook Usage"
    category: "state_management"
    framework: "react"
    hints:
      - "useState"
      - "useEffect"
      - "custom hooks"
    report_fields:
      - "hook_dependency_arrays"
      - "cleanup_functions"
      - "custom_hook_reusability"

  - name: "Component Composition"
    category: "architecture"
    framework: "react"
    hints:
      - "props.children"
      - "render props"
      - "higher-order component"
    report_fields:
      - "prop_drilling_depth"
      - "component_reusability"
      - "separation_of_concerns"
```

### Scenario 3: Performance-Focused

**Database Performance Patterns**

```yaml
# specs/database-performance-spec.yaml
database_patterns:
  - name: "N+1 Query Problem"
    category: "performance_anti_pattern"
    severity: "high"
    hints:
      - "loop with database query"
      - "ORM lazy loading"
      - "repeated similar queries"
    report_fields:
      - "query_count"
      - "performance_impact"
      - "eager_loading_opportunities"
      - "caching_potential"

  - name: "Index Usage"
    category: "optimization"
    hints:
      - "CREATE INDEX"
      - "WHERE clause"
      - "JOIN conditions"
    report_fields:
      - "index_coverage"
      - "query_optimization"
      - "maintenance_overhead"
```

## Customizing AI Agent Prompts

### Basic Prompt Customization

**Original Prompt**:
```text
You are an AI code auditor. Apply the rules defined in `specs/design-patterns-spec.yaml`...
```

**Customized for Your Organization**:
```text
You are an AI code auditor for [COMPANY_NAME]. Apply the rules defined in 
`specs/design-patterns-spec.yaml` with special attention to our coding standards 
documented in [STANDARDS_URL].

Additional requirements:
- Flag any violations of our naming conventions
- Assess compatibility with our CI/CD pipeline
- Consider our performance requirements (sub-100ms response times)
- Evaluate maintainability for a team of 5 developers
```

### Advanced Prompt Engineering

#### Context-Aware Prompts
```text
You are analyzing a [PROJECT_TYPE] codebase written in [LANGUAGE] for [INDUSTRY].
The system handles [DATA_SENSITIVITY] data and must comply with [REGULATIONS].

When analyzing patterns:
1. Prioritize security for financial data handling
2. Assess scalability for expected 10x growth
3. Consider mobile-first architecture requirements
4. Evaluate compliance with SOX requirements
```

#### Role-Specific Prompts
```text
# For Security Team
Focus your analysis on security implications of each pattern. Rate security 
posture and provide specific remediation steps for vulnerabilities.

# For Architecture Team  
Emphasize system design quality, maintainability, and scalability concerns.
Provide recommendations for architectural improvements.

# For Performance Team
Concentrate on performance characteristics, complexity analysis, and 
optimization opportunities. Include specific metrics where possible.
```

## Testing Your Customizations

### 1. Validation Checklist

Before deploying custom specifications:

- [ ] **Syntax Check**: Ensure YAML is valid
- [ ] **Hint Effectiveness**: Test detection hints with sample code
- [ ] **Report Field Coverage**: Verify all fields provide useful information
- [ ] **Documentation Alignment**: Ensure specs match documentation
- [ ] **Prompt Compatibility**: Test with your AI agent

### 2. Sample Code Testing

Create test cases for your custom patterns:

```java
// Test case for custom singleton pattern
@Singleton
public class CompanyConfigManager {
    private static CompanyConfigManager sharedInstance;
    
    public static CompanyConfigManager getSharedInstance() {
        if (sharedInstance == null) {
            sharedInstance = new CompanyConfigManager();
        }
        return sharedInstance;
    }
}
```

### 3. Incremental Rollout

1. **Start small**: Test with single team or project
2. **Gather feedback**: Collect input on report usefulness
3. **Iterate**: Refine based on real-world usage
4. **Scale gradually**: Expand to larger teams/projects

## Maintaining Custom Specifications

### Version Control Strategy

```
specs/
├── core/                    # Original specifications (don't modify)
│   ├── design-patterns-spec.yaml
│   └── security-vulnerabilities-spec.yaml
├── custom/                  # Your customizations
│   ├── company-patterns-spec.yaml
│   └── industry-compliance-spec.yaml
└── templates/              # Template for new specifications
    └── new-audit-type-template.yaml
```

### Documentation Updates

Keep documentation synchronized with specification changes:

1. **Update taxonomy docs** when adding new patterns
2. **Revise prompt templates** for new detection capabilities
3. **Update integration guides** for new report fields
4. **Maintain change logs** for specification versions

### Regular Review Process

- **Monthly**: Review hit rates and false positives
- **Quarterly**: Assess report field usefulness
- **Annually**: Evaluate overall customization effectiveness

## Integration with Existing Tools

### IDE Integration

Many teams integrate custom specifications with development environments:

```json
// VS Code settings.json
{
  "aiCodeAuditor.customSpecs": [
    "specs/custom/company-patterns-spec.yaml"
  ],
  "aiCodeAuditor.defaultPrompt": "prompts/custom/company-prompt.md"
}
```

### CI/CD Pipeline Integration

```yaml
# .github/workflows/code-audit.yml
- name: Run Custom Code Audit
  run: |
    ai-agent-cli \
      --specs "specs/custom/" \
      --prompt "prompts/custom/ci-prompt.md" \
      --output "audit-results.json"
```

## Troubleshooting Customizations

### Common Issues

| Problem | Symptoms | Solutions |
|---------|----------|-----------|
| Low detection rate | Few patterns found | Refine hints, add more keywords |
| False positives | Irrelevant matches | Make hints more specific |
| Poor report quality | Vague or unhelpful reports | Improve report field definitions |
| AI agent confusion | Inconsistent results | Simplify prompts, add examples |

### Debug Process

1. **Test individual components**: Validate YAML syntax
2. **Use verbose output**: Enable detailed logging
3. **Manual verification**: Check results against known patterns
4. **Iterative refinement**: Adjust based on feedback

## Next Steps

Once you've mastered customization:

1. **Share with community**: Consider contributing useful patterns back
2. **Automate maintenance**: Create scripts for specification updates
3. **Integrate monitoring**: Track customization effectiveness
4. **Train team**: Ensure team members understand customizations

For integration guidance, see the [Integration Guide](integration-guide.md). For ongoing best practices, consult the [Best Practices Guide](best-practices.md).