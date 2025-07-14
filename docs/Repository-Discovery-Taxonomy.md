# Repository Discovery Taxonomy

This document provides a comprehensive reference for repository discovery patterns that can be detected by the AI code auditor to understand any codebase structure, practices, and characteristics.

## Overview

Repository discovery provides a systematic approach to analyzing codebases across five key dimensions:
- **Project Structure Analysis**: Understanding the technical foundation
- **Documentation Discovery**: Evaluating knowledge capture and sharing
- **Development Practices**: Assessing workflow and process maturity
- **Code Metrics**: Measuring quantitative aspects
- **Team & Activity Analysis**: Understanding human factors and maintenance patterns

## Project Structure Analysis

Patterns that reveal the technical foundation and organization of a repository.

| Pattern | Category | Key Indicators | Complexity | Use Cases |
|---------|----------|----------------|------------|-----------|
| **Language Detection** | Project Structure | File extensions, syntax patterns, language-specific files | Low | Technology stack assessment, migration planning |
| **Framework Identification** | Project Structure | Package files, configuration files, dependency declarations | Medium | Architecture understanding, upgrade planning |
| **Build System Analysis** | Project Structure | Build files, configuration, automation scripts | Medium | Build process optimization, CI/CD setup |
| **Dependency Management** | Project Structure | Lock files, package manifests, version specifications | Medium | Security assessment, maintenance planning |
| **Module Organization** | Project Structure | Directory structure, import patterns, separation of concerns | High | Code quality assessment, refactoring planning |

### Language Detection Details

**Primary Languages Supported:**
- **Python**: `.py` files, `requirements.txt`, `setup.py`, `pyproject.toml`
- **JavaScript/TypeScript**: `.js`, `.ts` files, `package.json`, `tsconfig.json`
- **Java**: `.java` files, `pom.xml`, `build.gradle`, Maven/Gradle structure
- **C/C++**: `.c`, `.cpp`, `.h` files, `CMakeLists.txt`, `Makefile`
- **Go**: `.go` files, `go.mod`, `go.sum`
- **Rust**: `.rs` files, `Cargo.toml`, `Cargo.lock`
- **Ruby**: `.rb` files, `Gemfile`, `Gemfile.lock`
- **PHP**: `.php` files, `composer.json`, `composer.lock`
- **C#**: `.cs` files, `.csproj`, `.sln` files

**Assessment Criteria:**
- Language distribution by file count and lines of code
- Polyglot complexity (multiple languages in one project)
- Language-specific best practices adherence

### Framework Identification Details

**Web Frameworks:**
- **React**: `package.json` with React dependencies, JSX files
- **Vue**: Vue CLI configuration, `.vue` files
- **Angular**: Angular CLI configuration, TypeScript files with Angular decorators
- **Django**: `settings.py`, Django project structure
- **Flask**: Flask imports, application factory patterns
- **Spring**: Spring Boot annotations, Maven/Gradle Spring dependencies

**Assessment Criteria:**
- Framework version and update currency
- Configuration completeness
- Best practices adherence
- Migration complexity assessment

## Documentation Discovery

Patterns that evaluate how well a repository captures and shares knowledge.

| Pattern | Category | Key Indicators | Complexity | Use Cases |
|---------|----------|----------------|------------|-----------|
| **README Analysis** | Documentation | README files, content structure, completeness | Low | First impression assessment, onboarding evaluation |
| **API Documentation** | Documentation | Swagger/OpenAPI files, docstrings, generated docs | Medium | API usability, developer experience |
| **Code Comments Density** | Documentation | Comment ratios, docstring coverage, inline documentation | Medium | Code maintainability, knowledge transfer |
| **Architecture Documentation** | Documentation | Design docs, ADRs, system diagrams | High | System understanding, architectural decisions |
| **Contributing Guidelines** | Documentation | Contribution process, code standards, community guidelines | Medium | Community health, development process |

### README Analysis Details

**Completeness Indicators:**
- **Project Description**: Clear explanation of what the project does
- **Installation Instructions**: Step-by-step setup process
- **Usage Examples**: Code examples and common use cases
- **API Reference**: Basic API or interface documentation
- **Contributing Guidelines**: How to contribute to the project
- **License Information**: Legal usage terms
- **Contact Information**: How to get help or report issues

**Quality Metrics:**
- Length and detail level
- Code example presence
- Visual elements (badges, screenshots)
- Maintenance currency

### API Documentation Details

**Documentation Formats:**
- **OpenAPI/Swagger**: Machine-readable API specifications
- **JSDoc**: JavaScript documentation comments
- **Javadoc**: Java documentation comments
- **Python docstrings**: PEP 257 compliant documentation
- **Generated Documentation**: Tools like Sphinx, JSDoc, RDoc

**Assessment Criteria:**
- Coverage percentage of public APIs
- Documentation freshness and accuracy
- Interactive examples availability
- Integration with development workflow

## Development Practices

Patterns that assess workflow maturity and process quality.

| Pattern | Category | Key Indicators | Complexity | Use Cases |
|---------|----------|----------------|------------|-----------|
| **Version Control Patterns** | Development Practices | Git configuration, ignore files, commit patterns | Low | Repository hygiene, best practices |
| **Branch Strategies** | Development Practices | Branch naming, protection rules, merge strategies | Medium | Workflow efficiency, release management |
| **Commit Message Quality** | Development Practices | Conventional commits, message structure, consistency | Medium | Change tracking, automated tooling |
| **PR/Issue Templates** | Development Practices | Template completeness, required information, automation | Low | Process standardization, quality gates |
| **CI/CD Configuration** | Development Practices | Pipeline setup, testing integration, deployment automation | High | Development velocity, quality assurance |

### Version Control Patterns Details

**Git Configuration Assessment:**
- **`.gitignore` Completeness**: Language-specific ignores, build artifacts, secrets
- **Commit Patterns**: Frequency, size, atomic changes
- **Branch Naming**: Consistency with conventions (feature/, bugfix/, hotfix/)
- **Tag Usage**: Semantic versioning, release tagging

**Quality Indicators:**
- Repository cleanliness (no committed artifacts)
- Commit message quality and consistency
- Branch protection rule usage
- Merge vs. rebase strategy consistency

### CI/CD Configuration Details

**Pipeline Types:**
- **GitHub Actions**: `.github/workflows/` directory
- **GitLab CI**: `.gitlab-ci.yml` configuration
- **Jenkins**: `Jenkinsfile` pipeline definition
- **Travis CI**: `.travis.yml` configuration
- **CircleCI**: `.circleci/config.yml` setup

**Assessment Criteria:**
- Test automation coverage
- Build and deployment automation
- Security scanning integration
- Performance testing inclusion

## Code Metrics

Quantitative patterns that measure codebase characteristics.

| Pattern | Category | Key Indicators | Complexity | Use Cases |
|---------|----------|----------------|------------|-----------|
| **Repository Size and Growth** | Code Metrics | File count, commit frequency, growth velocity | Low | Resource planning, maintenance complexity |
| **File Count by Type** | Code Metrics | Source/test/config file ratios, organization | Low | Project structure assessment, maintenance focus |
| **Lines of Code** | Code Metrics | Total LOC, comment ratios, language distribution | Low | Project scale, complexity estimation |
| **Complexity Metrics** | Code Metrics | Cyclomatic complexity, nesting depth, function size | High | Code quality, refactoring priorities |
| **Test Coverage Indicators** | Code Metrics | Test file presence, test-to-code ratios | Medium | Quality assurance, testing maturity |

### Repository Size and Growth Details

**Size Metrics:**
- **Total Files**: Count of all files in repository
- **Source Files**: Programming language files only
- **Repository Age**: Time since first commit
- **Growth Velocity**: Files/commits added over time

**Growth Patterns:**
- Linear growth (steady development)
- Exponential growth (rapid development phases)
- Plateau patterns (mature projects)
- Spike patterns (major refactoring/additions)

### Complexity Metrics Details

**Complexity Types:**
- **Cyclomatic Complexity**: Number of linearly independent paths
- **Cognitive Complexity**: How difficult code is to understand
- **Nesting Depth**: Maximum levels of nested constructs
- **Function Length**: Lines of code per function/method
- **Class Size**: Methods and properties per class

**Assessment Thresholds:**
- **Low Complexity**: Easy to understand and maintain
- **Medium Complexity**: Moderate maintenance effort
- **High Complexity**: Requires refactoring consideration
- **Critical Complexity**: Immediate attention needed

## Team & Activity Analysis

Patterns that reveal human factors and maintenance characteristics.

| Pattern | Category | Key Indicators | Complexity | Use Cases |
|---------|----------|----------------|------------|-----------|
| **Contributor Patterns** | Team Activity | Author diversity, contribution distribution, maintainer activity | Medium | Team health, knowledge distribution |
| **Maintenance Activity** | Team Activity | Commit frequency, issue resolution, update cadence | Low | Project health, maintenance burden |
| **Issue Resolution Time** | Team Activity | Response time, resolution patterns, escalation handling | Medium | Support quality, process efficiency |
| **Release Frequency** | Team Activity | Tag patterns, version strategy, release automation | Medium | Development velocity, stability |

### Contributor Patterns Details

**Contribution Analysis:**
- **Core Contributors**: Regular, high-volume contributors
- **Occasional Contributors**: Sporadic contributions
- **One-time Contributors**: Single contribution instances
- **Maintainer Activity**: Administrative and review activities

**Health Indicators:**
- Contributor diversity (avoiding single points of failure)
- New contributor onboarding success
- Maintainer response time and engagement
- Contribution quality and review thoroughness

### Maintenance Activity Details

**Activity Types:**
- **Feature Development**: New functionality additions
- **Bug Fixes**: Issue resolution and corrections
- **Dependency Updates**: Library and framework updates
- **Documentation Updates**: Knowledge base maintenance
- **Refactoring**: Code structure improvements

**Assessment Criteria:**
- Maintenance frequency and consistency
- Response time to security issues
- Dependency update lag time
- Code quality improvement trends

## Additional Discovery Areas

### Security Configuration

**Security Patterns:**
- Security policy documentation
- Vulnerability scanning setup
- Dependency security monitoring
- Secret detection and prevention

### Performance Monitoring

**Performance Patterns:**
- Performance test presence
- Benchmarking setup
- Profiling configuration
- Performance regression detection

### Database Schema

**Database Patterns:**
- Migration strategy and management
- Schema documentation
- Database type and ORM usage
- Version control of schema changes

## Usage Guidelines

### For Repository Assessment

1. **Initial Discovery**: Start with project structure analysis
2. **Documentation Review**: Evaluate knowledge capture completeness
3. **Practice Assessment**: Analyze development workflow maturity
4. **Metrics Collection**: Gather quantitative measurements
5. **Team Analysis**: Understand human factors and maintenance patterns

### For Process Improvement

1. **Identify Gaps**: Compare against best practices
2. **Prioritize Issues**: Focus on high-impact improvements
3. **Create Action Plans**: Develop step-by-step improvement strategies
4. **Track Progress**: Monitor improvement metrics over time
5. **Iterate and Refine**: Continuously improve based on results

### For Team Onboarding

1. **Project Overview**: Use discovery results for context
2. **Technology Stack**: Understand tools and frameworks
3. **Development Process**: Learn workflow and practices
4. **Code Quality**: Understand quality standards and metrics
5. **Team Dynamics**: Understand contribution patterns and processes

## Visualization Recommendations

### Dashboard Components

1. **Project Health Score**: Overall repository health indicator
2. **Technology Stack Overview**: Languages, frameworks, and tools
3. **Documentation Coverage**: Knowledge capture completeness
4. **Development Velocity**: Commit frequency and release cadence
5. **Team Activity**: Contributor patterns and maintenance activity
6. **Quality Metrics**: Code complexity, test coverage, and technical debt
7. **Trend Analysis**: Growth patterns and improvement trajectories

### Report Formats

1. **Executive Summary**: High-level findings and recommendations
2. **Technical Deep Dive**: Detailed analysis with specific metrics
3. **Improvement Roadmap**: Prioritized action items with timelines
4. **Comparative Analysis**: Benchmarking against similar projects
5. **Team Performance**: Contribution patterns and collaboration metrics

This taxonomy provides a comprehensive framework for understanding any codebase through systematic discovery and analysis, enabling informed decision-making about development practices, team processes, and technical improvements.