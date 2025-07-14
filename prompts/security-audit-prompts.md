# Security Audit Prompts

This document contains AI prompt templates optimized for security vulnerability detection and analysis using the Security Vulnerabilities Specification.

## Quick Security Scan Prompt

```
You are a security expert conducting a code audit. Please analyze the codebase at [CODE_PATH] using the security vulnerability specifications from ai-code-auditor/specs/security-vulnerabilities-spec.yaml.

Focus on identifying:
1. Injection vulnerabilities (SQL injection, XSS, XXE)
2. Authentication and authorization flaws
3. Cryptographic failures
4. Security misconfigurations
5. Vulnerable dependencies

For each vulnerability found, provide:
- Exact location (file:line)
- Vulnerability type and severity
- Code snippet showing the issue
- Specific remediation steps
- OWASP category mapping

Prioritize Critical and High severity issues. Format the output as a structured security report.
```

## Comprehensive Security Analysis Prompt

```
You are conducting a comprehensive security audit of the codebase at [CODE_PATH]. Use the complete security vulnerability taxonomy from ai-code-auditor to perform a thorough analysis.

**Analysis Scope:**
- All source code files
- Configuration files
- Dependency manifests
- Infrastructure as code
- Environment configurations

**Vulnerability Categories to Check:**

1. **Injection Attacks**
   - SQL injection patterns
   - Cross-site scripting (XSS)
   - XML external entity (XXE)
   - Command injection
   - LDAP injection

2. **Broken Access Control**
   - Missing authorization checks
   - Privilege escalation paths
   - Insecure direct object references
   - CSRF vulnerabilities

3. **Cryptographic Failures**
   - Weak encryption algorithms
   - Hardcoded secrets and credentials
   - Insecure random number generation
   - Improper certificate validation

4. **Authentication Issues**
   - Weak password policies
   - Session management flaws
   - Missing rate limiting
   - Default credentials

5. **Security Misconfiguration**
   - Debug mode in production
   - Missing security headers
   - Insecure defaults
   - Excessive permissions

6. **Vulnerable Dependencies**
   - Outdated packages with CVEs
   - Known vulnerable versions
   - Unmaintained libraries

7. **Advanced Threats**
   - Insecure deserialization
   - Server-side request forgery (SSRF)
   - Business logic vulnerabilities

**Output Format:**
Provide a detailed security report with:

## Executive Summary
- Total vulnerabilities found by severity
- Risk assessment overview
- Priority remediation recommendations

## Detailed Findings

### Critical Vulnerabilities
[For each critical vulnerability:]
- **Title**: [Vulnerability Name]
- **Location**: [file:line]
- **OWASP Category**: [A01-A10:2021]
- **Description**: [What the vulnerability is]
- **Code Snippet**: 
  ```language
  [vulnerable code]
  ```
- **Impact**: [Potential consequences]
- **Remediation**: [Specific fix steps]
- **Safe Alternative**: 
  ```language
  [secure code example]
  ```

### High Vulnerabilities
[Same format as Critical]

### Medium Vulnerabilities
[Same format, summarized]

### Low Vulnerabilities
[Brief summary]

## Remediation Roadmap
1. **Immediate Actions** (Critical/High)
2. **Short-term** (Medium)
3. **Long-term** (Low/Preventive)

## Security Recommendations
- Secure coding practices
- Security tools integration
- Training recommendations
```

## Focused Vulnerability Type Prompts

### SQL Injection Detection

```
Analyze the codebase at [CODE_PATH] specifically for SQL injection vulnerabilities.

**Detection Focus:**
- Dynamic SQL query construction
- String concatenation with user input
- String interpolation in SQL statements
- ORM usage patterns
- Stored procedure calls

**Look for these patterns:**
- Query building with + operator
- String formatting in SQL (f-strings, .format(), %)
- execute() calls with concatenated strings
- Raw SQL with request parameters
- Missing parameterized queries

**For each SQL injection found, report:**
- Location and vulnerable code
- Type of injection (classical, blind, time-based)
- User input source
- Database operation type
- Suggested parameterized query fix
- ORM alternative if applicable

**Output Format:**
```json
{
  "sql_injection_vulnerabilities": [
    {
      "location": "file:line",
      "vulnerability_type": "SQL Injection",
      "severity": "Critical",
      "vulnerable_code": "code snippet",
      "user_input_source": "request parameter/form field",
      "database_operation": "SELECT/INSERT/UPDATE/DELETE",
      "suggested_fix": "parameterized query example",
      "safe_alternative": "secure code example"
    }
  ]
}
```
```

### XSS Detection

```
Scan the codebase at [CODE_PATH] for Cross-Site Scripting (XSS) vulnerabilities.

**XSS Types to Detect:**
1. **Stored XSS**: User input stored and later displayed
2. **Reflected XSS**: Input immediately reflected in response
3. **DOM-based XSS**: Client-side JavaScript manipulation

**Detection Patterns:**
- innerHTML assignments with user data
- document.write() with user input
- dangerouslySetInnerHTML in React
- v-html in Vue.js
- Unescaped template variables
- Direct DOM manipulation

**Context Analysis:**
- HTML context (between tags)
- Attribute context (inside tag attributes)
- JavaScript context (inside script tags)
- CSS context (inside style tags)
- URL context (href, src attributes)

**For each XSS vulnerability, provide:**
- Location and vulnerable code
- XSS type (stored/reflected/DOM)
- Input source and output context
- Potential payload example
- Proper encoding/escaping method
- Framework-specific secure alternative

**Security Headers Check:**
Also verify Content-Security-Policy implementation and other XSS prevention headers.
```

### Cryptographic Vulnerabilities

```
Audit the codebase at [CODE_PATH] for cryptographic failures and weaknesses.

**Cryptographic Areas to Examine:**

1. **Weak Algorithms:**
   - MD5, SHA1 usage for security purposes
   - DES, 3DES encryption
   - RC4 stream cipher
   - Custom cryptographic implementations

2. **Key Management:**
   - Hardcoded encryption keys
   - Weak key generation
   - Insecure key storage
   - Key reuse patterns

3. **Random Number Generation:**
   - Math.random() for security tokens
   - Predictable seed values
   - Non-cryptographic PRNGs
   - Time-based randomness

4. **TLS/SSL Issues:**
   - Certificate validation bypass
   - Weak cipher suites
   - Protocol version issues
   - Man-in-the-middle vulnerabilities

5. **Password Security:**
   - Plain text password storage
   - Weak hashing algorithms
   - Missing salt values
   - Insufficient iteration counts

**Analysis Output:**
For each cryptographic issue:
- Algorithm/method used
- Context and purpose
- Security weakness explanation
- Modern secure alternative
- Migration strategy

**Compliance Check:**
Verify against current cryptographic standards:
- NIST recommendations
- OWASP cryptographic guidelines
- Industry-specific requirements
```

### Authentication & Authorization

```
Examine the codebase at [CODE_PATH] for authentication and authorization vulnerabilities.

**Authentication Analysis:**

1. **Password Security:**
   - Password complexity requirements
   - Storage mechanisms (hashing, salting)
   - Brute force protection
   - Account lockout policies

2. **Session Management:**
   - Session token generation
   - Session storage and transmission
   - Session timeout handling
   - Session fixation prevention

3. **Multi-factor Authentication:**
   - MFA implementation patterns
   - Backup code handling
   - Device registration

**Authorization Analysis:**

1. **Access Control:**
   - Role-based access control (RBAC)
   - Attribute-based access control (ABAC)
   - Resource-level permissions
   - API endpoint protection

2. **Common Flaws:**
   - Missing authorization checks
   - Privilege escalation paths
   - Insecure direct object references
   - Horizontal/vertical privilege escalation

3. **Business Logic:**
   - Workflow bypasses
   - State manipulation
   - Race conditions
   - Time-of-check to time-of-use issues

**For each finding, document:**
- Authentication/authorization mechanism
- Vulnerability description
- Attack scenario
- Impact assessment
- Remediation steps
- Best practice implementation
```

## CI/CD Integration Prompts

### Pre-Commit Security Check

```
Perform a focused security check on the changed files in this commit. Analyze only the modified code for:

1. **High-Impact Vulnerabilities:**
   - SQL injection in new database queries
   - XSS in new user input handling
   - Hardcoded secrets in configuration
   - Authentication bypasses

2. **Configuration Issues:**
   - Debug mode settings
   - Security header configurations
   - Environment variable usage

3. **Dependency Changes:**
   - New packages with known vulnerabilities
   - Version downgrades with security implications

**Output Format:**
- PASS/FAIL status
- List of security issues found
- Specific files and lines affected
- Blocking issues (Critical/High severity)
- Warnings (Medium/Low severity)

**Integration Notes:**
- Focus on changed lines +/- 10 lines of context
- Prioritize blocking vulnerabilities
- Provide actionable remediation steps
```

### Pull Request Security Review

```
Conduct a security review of the pull request changes at [PR_URL] or [CODE_PATH].

**Review Scope:**
- All modified files in the PR
- New dependencies or version changes
- Configuration file modifications
- Infrastructure as code changes

**Security Checklist:**

1. **Input Validation:**
   - New user input properly validated
   - Sanitization applied correctly
   - Type checking implemented

2. **Output Encoding:**
   - User data properly encoded for context
   - Template escaping enabled
   - API responses secured

3. **Authentication/Authorization:**
   - New endpoints properly protected
   - Role checks implemented
   - Permission boundaries respected

4. **Data Security:**
   - Sensitive data properly handled
   - Encryption applied where needed
   - Secure storage mechanisms used

5. **Dependencies:**
   - New packages vetted for vulnerabilities
   - Versions updated to secure releases
   - License compliance maintained

**Review Output:**
Provide security approval status and specific feedback for:
- Security improvements made
- Remaining security concerns
- Recommendations for enhancement
- Required changes before merge
```

## Language-Specific Security Prompts

### JavaScript/Node.js Security

```
Analyze the JavaScript/Node.js codebase at [CODE_PATH] for security vulnerabilities specific to the platform.

**Node.js Specific Checks:**

1. **Server-Side Issues:**
   - Prototype pollution vulnerabilities
   - Command injection through child_process
   - Path traversal in file operations
   - Regex DoS (ReDoS) patterns

2. **Express.js Security:**
   - Missing helmet.js security headers
   - CORS misconfiguration
   - Trust proxy settings
   - Static file serving security

3. **Package Security:**
   - npm audit findings
   - Known vulnerable packages
   - Malicious package detection
   - Supply chain security

**Client-Side JavaScript:**
- DOM-based XSS vulnerabilities
- Client-side storage security
- Third-party script integration
- CSRF token handling

**Modern JavaScript Patterns:**
- async/await error handling
- Promise rejection security
- Module import security
- Webpack security configurations
```

### Python Security

```
Examine the Python codebase at [CODE_PATH] for security vulnerabilities common in Python applications.

**Python-Specific Vulnerabilities:**

1. **Serialization Issues:**
   - pickle.loads() with untrusted data
   - yaml.load() without safe loading
   - eval() and exec() usage
   - Code injection through imports

2. **Web Framework Security:**
   - Django: CSRF, SQL injection, template injection
   - Flask: Session management, route security
   - FastAPI: Authentication, input validation

3. **Library-Specific Issues:**
   - requests library SSL verification
   - subprocess command injection
   - XML parsing vulnerabilities
   - Regular expression DoS

**Configuration Security:**
- Environment variable handling
- Secret management
- Database connection security
- Logging sensitive information

**Best Practices Check:**
- Type hints for security-critical functions
- Input validation decorators
- Error handling patterns
- Security testing frameworks
```

## Specialized Security Audits

### API Security Audit

```
Conduct a comprehensive API security audit of the application at [CODE_PATH].

**API Security Framework:**

1. **Authentication & Authorization:**
   - JWT token security
   - OAuth 2.0 implementation
   - API key management
   - Rate limiting and throttling

2. **Input Validation:**
   - Request body validation
   - Parameter tampering protection
   - File upload security
   - Content-type validation

3. **Output Security:**
   - Response data filtering
   - Error message sanitization
   - Information disclosure prevention
   - Status code appropriateness

4. **API Design Security:**
   - RESTful security principles
   - GraphQL query complexity limits
   - API versioning security
   - Documentation exposure

**OWASP API Security Top 10 Mapping:**
- Broken object level authorization
- Broken user authentication
- Excessive data exposure
- Lack of resources & rate limiting
- Broken function level authorization
- Mass assignment
- Security misconfiguration
- Injection
- Improper assets management
- Insufficient logging & monitoring
```

### Cloud Security Configuration

```
Analyze the cloud infrastructure configuration at [CODE_PATH] for security misconfigurations.

**Cloud Provider Checks:**

1. **AWS Security:**
   - S3 bucket permissions and public access
   - IAM role and policy configurations
   - Security group and NACL rules
   - CloudTrail and monitoring setup

2. **Azure Security:**
   - Storage account access controls
   - Azure AD and RBAC configurations
   - Network security group rules
   - Key Vault usage patterns

3. **GCP Security:**
   - Cloud Storage IAM policies
   - Compute Engine security settings
   - VPC firewall rules
   - Cloud KMS implementation

**Infrastructure as Code:**
- Terraform security best practices
- CloudFormation template security
- Kubernetes security configurations
- Docker container security

**Compliance Frameworks:**
- CIS Benchmarks alignment
- SOC 2 compliance requirements
- GDPR data protection measures
- Industry-specific standards
```

## Report Templates

### Executive Security Summary

```
Based on the security audit of [PROJECT_NAME], here is the executive summary:

## Security Posture Overview
- **Total Vulnerabilities**: [COUNT] ([Critical: X, High: Y, Medium: Z, Low: W])
- **Risk Level**: [Low/Medium/High/Critical]
- **Compliance Status**: [Compliant/Non-compliant with specific standards]

## Key Findings
1. **Most Critical Issue**: [Brief description]
2. **Most Common Vulnerability**: [Pattern observed]
3. **Security Strengths**: [Positive observations]

## Business Impact
- **Data at Risk**: [Types and sensitivity]
- **Potential Damage**: [Financial, reputational, operational]
- **Compliance Implications**: [Regulatory requirements]

## Remediation Priority
1. **Immediate (0-7 days)**: [Critical vulnerabilities]
2. **Short-term (1-4 weeks)**: [High severity issues]
3. **Medium-term (1-3 months)**: [Medium severity issues]
4. **Long-term (3+ months)**: [Infrastructure improvements]

## Investment Recommendations
- **Security Tools**: [Recommended security solutions]
- **Training**: [Team skill development needs]
- **Process Improvements**: [SDLC security integration]
```

### Technical Security Report

```
# Technical Security Audit Report

## Methodology
- **Audit Scope**: [Components analyzed]
- **Tools Used**: AI Code Auditor + [additional tools]
- **Standards Applied**: OWASP Top 10 2021, CWE, [others]
- **Audit Date**: [Date]

## Vulnerability Summary

### Critical Vulnerabilities (Immediate Action Required)
[Detailed findings with code examples and fixes]

### High Vulnerabilities (Fix Within Sprint)
[Detailed findings with remediation guidance]

### Medium Vulnerabilities (Address in Current Release)
[Summary with grouped recommendations]

### Low Vulnerabilities (Backlog Items)
[Brief overview and preventive measures]

## Security Controls Assessment
- **Input Validation**: [Effectiveness rating]
- **Output Encoding**: [Implementation status]
- **Authentication**: [Strength assessment]
- **Authorization**: [Coverage analysis]
- **Cryptography**: [Algorithm review]
- **Configuration**: [Security settings audit]

## Recommendations
1. **Immediate Actions**
2. **Process Improvements**
3. **Tool Integration**
4. **Training Programs**
5. **Monitoring Enhancement**

## Appendices
- A: Vulnerability Details
- B: Code Examples
- C: Remediation Scripts
- D: Security Testing Procedures
```

## Usage Instructions

1. **Select appropriate prompt** based on audit scope and depth required
2. **Replace placeholders** like [CODE_PATH] with actual values
3. **Customize detection patterns** for specific technologies in use
4. **Adjust output format** based on reporting requirements
5. **Combine prompts** for comprehensive analysis across multiple dimensions

## Best Practices for AI Security Audits

1. **Context Awareness**: Provide sufficient code context for accurate analysis
2. **False Positive Management**: Verify findings manually for complex patterns
3. **Continuous Learning**: Update prompts based on new vulnerability patterns
4. **Tool Integration**: Combine AI analysis with traditional security tools
5. **Human Oversight**: Always have security experts review AI-generated findings