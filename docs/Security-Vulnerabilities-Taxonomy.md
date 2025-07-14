# Security Vulnerabilities Taxonomy

This document provides a comprehensive reference for security vulnerability detection patterns used by AI agents to identify potential security issues in codebases.

See the [Complexity Rating Guide](Complexity-Guide.md) for details on implementation difficulty, detection complexity, and performance impact levels mentioned here.

## Overview

The Security Vulnerabilities Taxonomy is designed to help AI agents systematically identify common security flaws based on the OWASP Top 10 2021 and industry best practices. Each vulnerability type includes detection patterns, severity levels, and remediation guidance.

## Vulnerability Categories

### 1. Injection Attacks

#### SQL Injection
**Description**: Direct concatenation or interpolation of user input into SQL queries without proper sanitization.

**Common Patterns**:
- String concatenation: `"SELECT * FROM users WHERE id = " + userId`
- String interpolation: `f"SELECT * FROM {table_name}"`
- Dynamic query building with user input

**Detection Hints**:
- Query concatenation with `+` operator
- String formatting in SQL statements
- `execute()` with string formatting
- Raw SQL construction with user input

**Severity**: Critical

**Safe Alternatives**:
- Parameterized queries/prepared statements
- Stored procedures
- ORM query builders with parameter binding
- Input validation and sanitization

#### Cross-Site Scripting (XSS)
**Description**: Rendering user-controlled data in HTML without proper encoding or escaping.

**Types**:
- **Stored XSS**: Persistent malicious scripts stored in database
- **Reflected XSS**: Scripts reflected from request parameters
- **DOM-based XSS**: Client-side JavaScript manipulation

**Common Patterns**:
- `element.innerHTML = userInput`
- `document.write(userControlledData)`
- `dangerouslySetInnerHTML` in React
- `v-html` in Vue.js without sanitization

**Detection Hints**:
- innerHTML with user data
- Direct DOM manipulation with user input
- Template injection points
- Unescaped output in HTML templates

**Severity**: High

**Safe Alternatives**:
- Use `textContent` or `innerText` instead of `innerHTML`
- HTML encoding/escaping functions
- Template auto-escaping
- Content Security Policy (CSP)
- Input validation and output encoding

#### XML External Entity (XXE)
**Description**: XML parsing with external entity processing enabled, allowing attackers to access local files or internal systems.

**Common Patterns**:
- DOCTYPE declarations with external entities
- XML parsers with default configurations
- External entity references in XML documents

**Detection Hints**:
- `<!DOCTYPE` with `ENTITY` declarations
- `XMLReader` without security features disabled
- `DocumentBuilder` with default factory settings
- External entity processing enabled

**Severity**: High

**Safe Alternatives**:
- Disable external entity processing
- Use JSON instead of XML when possible
- Configure XML parsers securely
- Input validation and schema validation

### 2. Broken Access Control

#### Authorization Flaws
**Description**: Missing, incomplete, or improperly implemented authorization checks.

**Common Issues**:
- Missing permission checks
- Role validation bypass
- Insecure direct object references
- Path traversal vulnerabilities
- Privilege escalation

**Common Patterns**:
- `// TODO: Add authorization` comments
- Conditional checks without role validation
- Direct file access with user input
- Missing resource ownership validation

**Detection Hints**:
- Missing authorization decorators/middleware
- Direct object access without validation
- File path operations with user input
- Administrative functions without role checks

**Severity**: High

**Safe Alternatives**:
- Role-based access control (RBAC)
- Attribute-based access control (ABAC)
- Principle of least privilege
- Centralized authorization mechanisms
- Resource ownership validation

#### Cross-Site Request Forgery (CSRF)
**Description**: State-changing operations that can be triggered by malicious websites without user consent.

**Common Patterns**:
- POST/PUT/DELETE endpoints without CSRF protection
- Disabled CSRF middleware
- GET requests with side effects
- Missing anti-CSRF tokens

**Detection Hints**:
- `@csrf_exempt` decorators
- `csrf: false` in configuration
- State-changing GET requests
- Missing CSRF middleware registration

**Severity**: High

**Safe Alternatives**:
- CSRF tokens (synchronizer token pattern)
- SameSite cookie attributes
- Double submit cookies
- Custom request headers verification

### 3. Cryptographic Failures

#### Weak Cryptography
**Description**: Use of weak, broken, or inappropriate cryptographic algorithms.

**Weak Algorithms**:
- **MD5**: Cryptographically broken, should not be used for security
- **SHA1**: Deprecated for cryptographic purposes
- **DES/3DES**: Insufficient key sizes
- **ECB mode**: Reveals patterns in encrypted data

**Common Patterns**:
- `hashlib.md5()` for password hashing
- `SHA1()` for digital signatures
- `DES.new()` for encryption
- `AES.MODE_ECB` for symmetric encryption

**Detection Hints**:
- Algorithm names in code (MD5, SHA1, DES)
- ECB mode usage
- Custom cryptographic implementations
- Small key sizes

**Severity**: High

**Safe Alternatives**:
- **Hashing**: SHA-256, SHA-3, bcrypt, scrypt, Argon2
- **Symmetric Encryption**: AES-GCM, ChaCha20-Poly1305
- **Asymmetric Encryption**: RSA (2048+ bits), ECC (256+ bits)
- **Key Derivation**: PBKDF2, scrypt, Argon2

#### Hardcoded Secrets
**Description**: Sensitive information like passwords, API keys, or private keys embedded directly in source code.

**Common Patterns**:
- API keys in configuration files
- Database passwords in connection strings
- Private keys in code repositories
- Authentication tokens in client-side code

**Detection Hints**:
- Variable names containing "key", "password", "secret", "token"
- String patterns matching API key formats
- BEGIN PRIVATE KEY markers
- Database connection strings with credentials

**Severity**: Critical

**Safe Alternatives**:
- Environment variables
- Secret management services (HashiCorp Vault, AWS Secrets Manager)
- Configuration files excluded from version control
- Key management systems

#### Insecure Randomness
**Description**: Using predictable random number generation for security-critical purposes.

**Insecure Sources**:
- `Math.random()` in JavaScript
- `rand()` in C
- `Random()` class in Java (for security purposes)
- Time-based seeds

**Common Patterns**:
- Session tokens generated with `Math.random()`
- Cryptographic nonces using weak PRNGs
- Salts generated from timestamps
- Security tokens with predictable patterns

**Detection Hints**:
- Non-cryptographic random functions in security contexts
- Time-based seed initialization
- Simple random number generation for tokens
- Predictable sequence generation

**Severity**: Medium to High

**Safe Alternatives**:
- `crypto.randomBytes()` in Node.js
- `secrets` module in Python
- `SecureRandom` in Java
- `/dev/urandom` in Unix systems

### 4. Authentication and Session Management

#### Weak Authentication
**Description**: Inadequate authentication mechanisms that can be easily bypassed or compromised.

**Common Issues**:
- Weak password requirements
- Missing rate limiting on login attempts
- Session fixation vulnerabilities
- Predictable session tokens
- Default credentials

**Common Patterns**:
- Password length checks with low thresholds
- Missing account lockout mechanisms
- Session IDs based on user information
- Hardcoded default passwords

**Detection Hints**:
- Weak password validation regex
- Missing rate limiting decorators
- Session management without proper randomness
- Default credential patterns

**Severity**: High

**Safe Alternatives**:
- Strong password policies
- Multi-factor authentication (MFA)
- Account lockout mechanisms
- Secure session management
- Regular password rotation

#### Certificate Validation Issues
**Description**: Disabled or improper TLS/SSL certificate validation that allows man-in-the-middle attacks.

**Common Patterns**:
- `verify=False` in HTTP libraries
- `rejectUnauthorized: false` in Node.js
- Disabled certificate verification in curl
- Custom trust managers that accept all certificates

**Detection Hints**:
- SSL/TLS verification disabled
- Certificate validation bypass
- Custom certificate acceptance logic
- Environment variables disabling verification

**Severity**: High

**Safe Alternatives**:
- Proper certificate validation
- Certificate pinning
- CA bundle configuration
- Mutual TLS authentication

### 5. Security Misconfiguration

#### Debug Mode in Production
**Description**: Debug features, verbose error messages, or development settings enabled in production environments.

**Common Issues**:
- Debug flags enabled
- Detailed error messages exposed
- Development middleware in production
- Verbose logging with sensitive data

**Common Patterns**:
- `DEBUG = True` in production
- `display_errors = On` in PHP
- Development environment variables
- Stack traces exposed to users

**Detection Hints**:
- Debug configuration flags
- Error display settings
- Development mode indicators
- Verbose error handling

**Severity**: Medium

**Safe Alternatives**:
- Environment-based configuration
- Generic error pages for production
- Centralized logging systems
- Monitoring and alerting

#### Missing Security Headers
**Description**: HTTP responses lacking important security headers that provide client-side protection.

**Important Headers**:
- **Content-Security-Policy**: Prevents XSS and data injection
- **X-Frame-Options**: Prevents clickjacking
- **Strict-Transport-Security**: Enforces HTTPS
- **X-Content-Type-Options**: Prevents MIME type sniffing
- **Referrer-Policy**: Controls referrer information

**Common Patterns**:
- Missing CSP headers
- Absent frame protection
- No HSTS implementation
- Missing content type protection

**Detection Hints**:
- HTTP response analysis
- Header configuration files
- Middleware registration
- Security header libraries usage

**Severity**: Medium

**Safe Alternatives**:
- Security header middleware (helmet.js)
- Web server configuration
- CDN security settings
- Regular security header audits

### 6. Vulnerable Dependencies

#### Outdated Components
**Description**: Using libraries, frameworks, or components with known security vulnerabilities.

**Common Issues**:
- Outdated package versions
- Known CVE vulnerabilities
- Unmaintained dependencies
- Transitive dependency vulnerabilities

**Detection Patterns**:
- Version specifications in dependency files
- CVE database matching
- Security advisory references
- Deprecated package usage

**Detection Hints**:
- Old version numbers in package.json, requirements.txt, etc.
- Dependencies with known vulnerabilities
- Packages with security advisories
- Long periods without updates

**Severity**: Varies (based on vulnerability)

**Safe Alternatives**:
- Regular dependency updates
- Automated dependency scanning
- Security advisory monitoring
- Dependency management tools

### 7. Advanced Vulnerabilities

#### Insecure Deserialization
**Description**: Deserializing untrusted data without proper validation, potentially leading to remote code execution.

**Common Patterns**:
- `pickle.loads()` in Python with user data
- `unserialize()` in PHP with external input
- Java object deserialization with untrusted data
- `eval()` with serialized data

**Detection Hints**:
- Deserialization functions with external input
- Object reconstruction from user data
- Binary deserialization operations
- Dynamic code execution patterns

**Severity**: Critical

**Safe Alternatives**:
- JSON with schema validation
- Whitelist-based deserialization
- Signed/encrypted serialization
- Input validation and sanitization

#### Server-Side Request Forgery (SSRF)
**Description**: Making server-side requests to user-controlled URLs, potentially accessing internal systems.

**Common Patterns**:
- HTTP requests with user-provided URLs
- File operations with user-controlled paths
- DNS lookups with user input
- Internal service calls with external data

**Detection Hints**:
- HTTP client libraries with user input
- URL parameters in request functions
- File access with dynamic paths
- Network operations with user data

**Severity**: High

**Safe Alternatives**:
- URL allowlisting
- Input validation and sanitization
- Network segmentation
- Request validation middleware

## Severity Classification

### Critical
- **Response Time**: Immediate
- **Characteristics**: High impact, easily exploitable
- **Examples**: SQL injection, hardcoded secrets, insecure deserialization

### High
- **Response Time**: Within current sprint
- **Characteristics**: Significant impact, moderate exploitability
- **Examples**: XSS, broken authorization, weak cryptography

### Medium
- **Response Time**: Within current release
- **Characteristics**: Moderate impact, limited exploitability
- **Examples**: Missing security headers, debug mode, insecure randomness

### Low
- **Response Time**: Backlog
- **Characteristics**: Low impact, difficult to exploit
- **Examples**: Information disclosure, minor configuration issues

## OWASP Top 10 2021 Mapping

1. **A01:2021 – Broken Access Control**: Authorization flaws, CSRF
2. **A02:2021 – Cryptographic Failures**: Weak crypto, hardcoded secrets
3. **A03:2021 – Injection**: SQL injection, XSS, XXE
4. **A04:2021 – Insecure Design**: Design flaws, missing security controls
5. **A05:2021 – Security Misconfiguration**: Debug mode, missing headers
6. **A06:2021 – Vulnerable and Outdated Components**: Dependency vulnerabilities
7. **A07:2021 – Identification and Authentication Failures**: Weak authentication
8. **A08:2021 – Software and Data Integrity Failures**: Insecure deserialization
9. **A09:2021 – Security Logging and Monitoring Failures**: Insufficient logging
10. **A10:2021 – Server-Side Request Forgery**: SSRF vulnerabilities

## Detection Best Practices

### For AI Agents
1. **Context Analysis**: Consider the surrounding code context when identifying patterns
2. **False Positive Reduction**: Validate findings against safe usage patterns
3. **Severity Assessment**: Consider exploitability and impact when assigning severity
4. **Remediation Guidance**: Provide specific, actionable recommendations

### For Security Teams
1. **Regular Scanning**: Implement automated security scanning in CI/CD pipelines
2. **Training**: Keep development teams updated on secure coding practices
3. **Code Review**: Include security-focused reviews in the development process
4. **Monitoring**: Implement security monitoring and incident response procedures

## Remediation Strategies

### Immediate Actions
- Fix critical and high-severity vulnerabilities first
- Remove hardcoded secrets and rotate compromised credentials
- Implement input validation and output encoding
- Update vulnerable dependencies

### Long-term Improvements
- Implement security training programs
- Establish secure coding standards
- Regular security assessments and penetration testing
- Implement security monitoring and logging

### Prevention Measures
- Security-focused code reviews
- Automated security testing in CI/CD
- Regular dependency updates
- Security awareness training

## References

- [OWASP Top 10 2021](https://owasp.org/Top10/)
- [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [CWE (Common Weakness Enumeration)](https://cwe.mitre.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cybersecurity/framework)
- [SANS Top 25 Software Errors](https://www.sans.org/top25-software-errors/)