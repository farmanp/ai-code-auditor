# Getting Started with AI Code Auditor

Welcome to the AI Code Auditor! This guide will walk you through your first steps with the tool, from basic setup to running your first audit and understanding the results.

## What is AI Code Auditor?

AI Code Auditor is a powerful, AI-driven tool that analyzes your codebase to identify:
- **Design patterns** (Singleton, Factory, Observer, MVC, etc.)
- **Algorithms and data structures** with complexity analysis
- **Security vulnerabilities** based on OWASP Top 10
- **DataHub metadata patterns** for data governance
- **ETL subsystems** for data warehouse implementations
- **Cloud architecture patterns** for cloud-native applications
- **Technical debt and feasibility** for migrations and refactoring

## Quick Start (5 Minutes)

### Prerequisites
- An AI agent/tool that can read files and analyze code (ChatGPT, Claude, GitHub Copilot, etc.)
- Access to a codebase you want to analyze
- Basic understanding of your project's technology stack

### Your First Audit

1. **Clone or download this repository**
   ```bash
   git clone https://github.com/farmanp/ai-code-auditor.git
   cd ai-code-auditor
   ```

2. **Choose your audit type**
   - For general code quality: Use `prompts/design-patterns-prompt.md`
   - For security analysis: Use `prompts/security-audit-prompts.md`
   - For performance review: Use `prompts/algorithms-ds-prompt.md`
   - For data projects: Use `prompts/datahub-prompt.md`

3. **Run your first scan**
   - Copy the content from your chosen prompt file
   - Replace `[CODE_PATH]` with your project's path
   - Paste into your AI agent
   - Wait for the analysis results

### Example: Security Audit

Let's do a quick security scan of a web application:

1. **Copy this prompt:**
   ```text
   You are an AI code auditor. Apply the rules defined in `specs/security-vulnerabilities-spec.yaml` 
   together with the guidance in `docs/Security-Vulnerabilities-Taxonomy.md` to scan the target 
   code at /path/to/your/webapp.

   Focus on OWASP Top 10 vulnerabilities and report:
   - Vulnerability locations with file names and line numbers
   - Risk severity (Critical/High/Medium/Low)
   - Specific code snippets showing the issue
   - Recommended remediation steps
   ```

2. **Replace `/path/to/your/webapp` with your actual project path**

3. **Submit to your AI agent and review results**

## Understanding Your First Report

### Report Structure
Every audit report contains these sections:

#### 1. **Executive Summary**
- Total issues found
- Risk distribution (Critical/High/Medium/Low)
- Primary areas of concern

#### 2. **Detailed Findings**
For each detected pattern/issue:
- **Location**: File path and line numbers
- **Description**: What was found
- **Evidence**: Relevant code snippets
- **Assessment**: Quality rating or risk level
- **Recommendations**: Specific improvement suggestions

#### 3. **Metrics and Analysis**
- Pattern distribution
- Complexity metrics (for algorithms)
- Compliance scores (for DataHub/governance)

### Sample Report Excerpt
```
## Security Vulnerabilities Found

### Critical Issues (2)

1. **SQL Injection** in `src/database/UserRepository.java:45`
   - Risk: Critical
   - Evidence: `"SELECT * FROM users WHERE id = " + userId`
   - Recommendation: Use parameterized queries or prepared statements

2. **Hardcoded Credentials** in `config/database.properties:12`
   - Risk: Critical  
   - Evidence: `password=admin123`
   - Recommendation: Use environment variables or secure vault
```

## Quick Wins: Immediate Actions

After your first audit, prioritize these actions:

### Security Audits
1. **Fix Critical vulnerabilities first** - Address SQL injection, hardcoded secrets
2. **Review authentication** - Check for weak password policies, missing 2FA
3. **Validate input handling** - Ensure all user inputs are properly sanitized

### Design Pattern Audits  
1. **Identify anti-patterns** - Look for God objects, spaghetti code
2. **Improve singleton implementations** - Ensure thread safety
3. **Refactor large classes** - Apply Single Responsibility Principle

### Algorithm Audits
1. **Optimize critical paths** - Focus on O(n²) algorithms in hot code paths
2. **Review data structures** - Ensure appropriate choices for use cases
3. **Add complexity documentation** - Document Big O for future maintainers

## Common First-Time Scenarios

### Scenario 1: Legacy Codebase Assessment
**Goal**: Understand technical debt before modernization
**Recommended audits**: 
- Feasibility Analysis (`prompts/feasibility-audit-prompts.md`)
- Design Patterns (`prompts/design-patterns-prompt.md`)
- Security (`prompts/security-audit-prompts.md`)

### Scenario 2: New Team Onboarding
**Goal**: Understand existing architecture and patterns
**Recommended audits**:
- Design Patterns (to understand architecture)
- Repository Discovery (to map codebase structure)
- Algorithms & Data Structures (to understand performance characteristics)

### Scenario 3: Security Review
**Goal**: Identify and fix security vulnerabilities
**Recommended audits**:
- Security Vulnerabilities (comprehensive OWASP scan)
- Design Patterns (to identify security anti-patterns)

### Scenario 4: Data Pipeline Analysis
**Goal**: Assess data processing and governance
**Recommended audits**:
- ETL Subsystems (for data warehouse projects)
- DataHub (for metadata and governance)
- Cloud Architecture (for cloud-based data pipelines)

## Next Steps

Once you're comfortable with basic audits:

1. **Explore Advanced Features** → Read [Audit Types Guide](audit-types-guide.md)
2. **Customize for Your Needs** → See [Customization Guide](customization-guide.md)  
3. **Integrate with Your Workflow** → Check [Integration Guide](integration-guide.md)
4. **Learn Best Practices** → Review [Best Practices](best-practices.md)
5. **Troubleshoot Issues** → Consult [Troubleshooting Guide](troubleshooting.md)

## Getting Help

- **Issues with prompts?** → Check [Troubleshooting Guide](troubleshooting.md)
- **Want to extend functionality?** → See [Customization Guide](customization-guide.md)
- **Integration questions?** → Read [Integration Guide](integration-guide.md)
- **General questions?** → Review the main [README](../README.md) and documentation in [`docs/`](../docs/)

## Summary

You've now learned how to:
- ✅ Run your first AI code audit
- ✅ Understand audit reports  
- ✅ Identify quick wins
- ✅ Choose appropriate audit types for different scenarios

The AI Code Auditor is a powerful tool that becomes more valuable as you learn to use its different capabilities together. Start with simple scans, understand the results, and gradually explore more advanced features as your needs grow.