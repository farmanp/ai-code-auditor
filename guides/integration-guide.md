# Integration Guide

This guide covers how to integrate the AI Code Auditor into your development workflows, including CI/CD pipelines, IDEs, Git hooks, and team processes.

## Integration Overview

The AI Code Auditor can be integrated at multiple points in your development lifecycle:

| Integration Point | Timing | Automation Level | Use Cases |
|------------------|--------|------------------|-----------|
| IDE/Editor | Real-time | Manual/Triggered | Development-time feedback |
| Git Hooks | Pre-commit/Push | Automatic | Quality gates |
| CI/CD Pipeline | Build/Deploy | Automatic | Automated quality checks |
| Code Review | PR/MR process | Manual/Automatic | Review assistance |
| Scheduled Scans | Periodic | Automatic | Health monitoring |

## CI/CD Pipeline Integration

### GitHub Actions

#### Basic Workflow

```yaml
# .github/workflows/code-audit.yml
name: AI Code Audit

on:
  pull_request:
    branches: [ main, develop ]
  push:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * 1'  # Weekly Monday 2 AM

jobs:
  security-audit:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup AI Code Auditor
        run: |
          git clone https://github.com/farmanp/ai-code-auditor.git .ai-auditor
          
      - name: Run Security Audit
        env:
          OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}
        run: |
          # Example using OpenAI API
          curl -X POST "https://api.openai.com/v1/chat/completions" \
            -H "Authorization: Bearer $OPENAI_API_KEY" \
            -H "Content-Type: application/json" \
            -d @- << EOF
          {
            "model": "gpt-4",
            "messages": [
              {
                "role": "system",
                "content": "$(cat .ai-auditor/prompts/security-audit-prompts.md)"
              },
              {
                "role": "user", 
                "content": "Analyze the code in this repository: $(find . -name '*.java' -o -name '*.py' -o -name '*.js' | head -10 | xargs cat)"
              }
            ]
          }
          EOF

      - name: Parse Results
        run: |
          # Parse AI response and create GitHub issue for critical findings
          echo "Parsing audit results..."
          
      - name: Comment PR
        if: github.event_name == 'pull_request'
        uses: actions/github-script@v6
        with:
          script: |
            const auditResults = require('./audit-results.json');
            const comment = `## 🔍 AI Code Audit Results
            
            **Security Issues Found:** ${auditResults.criticalCount}
            **Design Pattern Issues:** ${auditResults.patternCount}
            
            See full report in CI logs.`;
            
            github.rest.issues.createComment({
              issue_number: context.issue.number,
              owner: context.repo.owner,
              repo: context.repo.repo,
              body: comment
            });
```

#### Advanced Multi-Audit Workflow

```yaml
# .github/workflows/comprehensive-audit.yml
name: Comprehensive Code Audit

on:
  push:
    branches: [ main ]
    
jobs:
  audit-matrix:
    strategy:
      matrix:
        audit-type: 
          - security-vulnerabilities
          - design-patterns
          - algorithms-ds
          - feasibility-analysis
        include:
          - audit-type: security-vulnerabilities
            priority: critical
            gate: true
          - audit-type: design-patterns
            priority: high
            gate: false
          - audit-type: algorithms-ds
            priority: medium
            gate: false
          - audit-type: feasibility-analysis
            priority: low
            gate: false
            
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Run ${{ matrix.audit-type }} Audit
        run: |
          echo "Running ${{ matrix.audit-type }} audit..."
          # Implementation specific to your AI tool
          
      - name: Quality Gate
        if: matrix.gate == true
        run: |
          # Fail build if critical security issues found
          CRITICAL_COUNT=$(jq '.criticalIssues | length' audit-results.json)
          if [ "$CRITICAL_COUNT" -gt 0 ]; then
            echo "::error::Critical security issues found: $CRITICAL_COUNT"
            exit 1
          fi

  generate-report:
    needs: audit-matrix
    runs-on: ubuntu-latest
    steps:
      - name: Consolidate Results
        run: |
          # Combine all audit results into comprehensive report
          echo "Generating comprehensive audit report..."
          
      - name: Upload Report
        uses: actions/upload-artifact@v3
        with:
          name: audit-report
          path: comprehensive-audit-report.html
```

### Jenkins Pipeline

```groovy
// Jenkinsfile
pipeline {
    agent any
    
    environment {
        AI_AUDITOR_PATH = 'tools/ai-code-auditor'
    }
    
    stages {
        stage('Setup') {
            steps {
                script {
                    // Clone AI Code Auditor if not already present
                    if (!fileExists(env.AI_AUDITOR_PATH)) {
                        sh "git clone https://github.com/farmanp/ai-code-auditor.git ${env.AI_AUDITOR_PATH}"
                    }
                }
            }
        }
        
        stage('Security Audit') {
            steps {
                script {
                    def auditScript = """
                        cd ${env.AI_AUDITOR_PATH}
                        python3 scripts/run_audit.py \\
                            --type security \\
                            --target ${WORKSPACE} \\
                            --output ${WORKSPACE}/security-audit.json
                    """
                    sh auditScript
                }
            }
            post {
                always {
                    archiveArtifacts artifacts: 'security-audit.json'
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    def auditResults = readJSON file: 'security-audit.json'
                    if (auditResults.criticalIssues?.size() > 0) {
                        error "Critical security vulnerabilities found: ${auditResults.criticalIssues.size()}"
                    }
                }
            }
        }
        
        stage('Generate Report') {
            steps {
                publishHTML([
                    allowMissing: false,
                    alwaysLinkToLastBuild: true,
                    keepAll: true,
                    reportDir: '.',
                    reportFiles: 'security-audit.html',
                    reportName: 'Security Audit Report'
                ])
            }
        }
    }
}
```

### GitLab CI

```yaml
# .gitlab-ci.yml
stages:
  - audit
  - report
  - deploy

variables:
  AI_AUDITOR_IMAGE: "python:3.9-slim"

before_script:
  - git clone https://github.com/farmanp/ai-code-auditor.git ai-auditor

security-audit:
  stage: audit
  image: $AI_AUDITOR_IMAGE
  script:
    - cd ai-auditor
    - pip install -r requirements.txt
    - python audit_runner.py --type security --target ../ --output ../security-results.json
  artifacts:
    reports:
      junit: security-results.xml
    paths:
      - security-results.json
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_BRANCH == "main"

design-patterns-audit:
  stage: audit
  image: $AI_AUDITOR_IMAGE
  script:
    - cd ai-auditor  
    - python audit_runner.py --type design-patterns --target ../ --output ../patterns-results.json
  artifacts:
    paths:
      - patterns-results.json
  allow_failure: true

quality-gate:
  stage: report
  script:
    - |
      CRITICAL_COUNT=$(jq '.critical_issues | length' security-results.json)
      echo "Critical issues found: $CRITICAL_COUNT"
      if [ "$CRITICAL_COUNT" -gt 0 ]; then
        echo "Quality gate failed: Critical security issues found"
        exit 1
      fi
  dependencies:
    - security-audit
```

## Git Hooks Integration

### Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

echo "Running AI Code Audit pre-commit checks..."

# Get list of staged files
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(java|py|js|ts)$')

if [ -z "$STAGED_FILES" ]; then
    echo "No relevant files to audit."
    exit 0
fi

# Clone AI auditor if not present
if [ ! -d ".ai-auditor" ]; then
    git clone https://github.com/farmanp/ai-code-auditor.git .ai-auditor
fi

# Create temporary directory for staged files
TEMP_DIR=$(mktemp -d)
echo "Analyzing staged files in $TEMP_DIR..."

# Copy staged files to temp directory
for file in $STAGED_FILES; do
    mkdir -p "$TEMP_DIR/$(dirname "$file")"
    git show ":$file" > "$TEMP_DIR/$file"
done

# Run quick security audit on staged files
CRITICAL_ISSUES=$(python3 .ai-auditor/scripts/quick_audit.py \
    --type security \
    --target "$TEMP_DIR" \
    --filter critical)

# Cleanup
rm -rf "$TEMP_DIR"

if [ "$CRITICAL_ISSUES" -gt 0 ]; then
    echo "❌ Critical security issues found in staged files!"
    echo "Please fix security issues before committing."
    echo "Run: git commit --no-verify to bypass this check (not recommended)"
    exit 1
fi

echo "✅ Pre-commit audit passed!"
exit 0
```

### Pre-push Hook

```bash
#!/bin/bash
# .git/hooks/pre-push

echo "Running comprehensive audit before push..."

# Run full audit suite on changed files since last push
git diff --name-only origin/main...HEAD | grep -E '\.(java|py|js|ts)$' > changed_files.txt

if [ ! -s changed_files.txt ]; then
    echo "No relevant files changed."
    exit 0
fi

# Run comprehensive audit
python3 .ai-auditor/scripts/comprehensive_audit.py \
    --files changed_files.txt \
    --output pre-push-audit.json

# Check for blocking issues
BLOCKING_ISSUES=$(jq '.blocking_issues | length' pre-push-audit.json)

if [ "$BLOCKING_ISSUES" -gt 0 ]; then
    echo "❌ Blocking issues found:"
    jq -r '.blocking_issues[].message' pre-push-audit.json
    echo ""
    echo "Please address these issues before pushing."
    echo "Use: git push --no-verify to bypass (requires approval)"
    exit 1
fi

echo "✅ Pre-push audit passed!"
exit 0
```

## IDE Integration

### Visual Studio Code

#### Extension Configuration

```json
// .vscode/settings.json
{
  "aiCodeAuditor.enabled": true,
  "aiCodeAuditor.auditOnSave": true,
  "aiCodeAuditor.auditTypes": [
    "security-vulnerabilities",
    "design-patterns"
  ],
  "aiCodeAuditor.severityThreshold": "medium",
  "aiCodeAuditor.customSpecs": [
    "specs/custom/company-patterns-spec.yaml"
  ],
  "aiCodeAuditor.apiKey": "${env:AI_API_KEY}",
  "aiCodeAuditor.excludePatterns": [
    "**/node_modules/**",
    "**/target/**",
    "**/.git/**"
  ]
}
```

#### Task Configuration

```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "AI Code Audit: Security",
      "type": "shell",
      "command": "python3",
      "args": [
        "${workspaceFolder}/.ai-auditor/scripts/audit_runner.py",
        "--type", "security",
        "--target", "${workspaceFolder}",
        "--output", "${workspaceFolder}/audit-results.json"
      ],
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      },
      "problemMatcher": {
        "pattern": {
          "regexp": "^(.*):(\\d+):(\\d+):\\s+(warning|error):\\s+(.*)$",
          "file": 1,
          "line": 2,
          "column": 3,
          "severity": 4,
          "message": 5
        }
      }
    },
    {
      "label": "AI Code Audit: Full",
      "type": "shell", 
      "command": "python3",
      "args": [
        "${workspaceFolder}/.ai-auditor/scripts/comprehensive_audit.py",
        "--target", "${workspaceFolder}"
      ],
      "group": "build"
    }
  ]
}
```

### IntelliJ IDEA

#### External Tool Configuration

```xml
<!-- File: .idea/tools/AI_Code_Auditor.xml -->
<toolSet name="AI Code Auditor">
  <tool name="Security Audit" description="Run security vulnerability scan">
    <exec>
      <option name="COMMAND" value="python3" />
      <option name="PARAMETERS" value="$ProjectFileDir$/.ai-auditor/scripts/audit_runner.py --type security --target $ProjectFileDir$ --ide-output" />
      <option name="WORKING_DIRECTORY" value="$ProjectFileDir$" />
    </exec>
  </tool>
  
  <tool name="Design Patterns Audit" description="Analyze design patterns">
    <exec>
      <option name="COMMAND" value="python3" />
      <option name="PARAMETERS" value="$ProjectFileDir$/.ai-auditor/scripts/audit_runner.py --type design-patterns --target $FilePath$ --ide-output" />
      <option name="WORKING_DIRECTORY" value="$ProjectFileDir$" />
    </exec>
  </tool>
</toolSet>
```

### Vim/Neovim

#### ALE (Asynchronous Lint Engine) Configuration

```vim
" .vimrc or init.vim
let g:ale_linters = {
\   'python': ['ai-auditor', 'flake8'],
\   'java': ['ai-auditor', 'checkstyle'],
\   'javascript': ['ai-auditor', 'eslint']
\}

let g:ale_linter_aliases = {
\   'ai-auditor': ['python', 'java', 'javascript', 'typescript']
\}

" Custom AI auditor command
function! RunAIAudit(audit_type)
    let l:cmd = 'python3 .ai-auditor/scripts/audit_runner.py --type ' . a:audit_type . ' --target ' . expand('%:p')
    execute '!' . l:cmd
endfunction

" Key mappings
nnoremap <leader>as :call RunAIAudit('security')<CR>
nnoremap <leader>ap :call RunAIAudit('design-patterns')<CR>
nnoremap <leader>aa :call RunAIAudit('all')<CR>
```

## Team Workflow Integration

### Code Review Process

#### Pull Request Template

```markdown
<!-- .github/pull_request_template.md -->
## Changes Summary
Brief description of changes...

## AI Code Audit Checklist
- [ ] Security audit passed (no critical vulnerabilities)
- [ ] Design patterns audit reviewed
- [ ] Performance implications assessed
- [ ] Custom business rules compliance checked

## Audit Results
<!-- AI audit bot will automatically populate this section -->

## Review Notes
- Security findings addressed: 
- Pattern improvements made:
- Performance optimizations:
```

#### Automated PR Comments

```python
# scripts/pr_audit_bot.py
import json
import requests
from typing import Dict, List

class PRAuditBot:
    def __init__(self, github_token: str):
        self.github_token = github_token
        self.headers = {
            'Authorization': f'token {github_token}',
            'Accept': 'application/vnd.github.v3+json'
        }
    
    def post_audit_comment(self, repo: str, pr_number: int, audit_results: Dict):
        """Post audit results as PR comment"""
        comment_body = self._format_audit_results(audit_results)
        
        url = f"https://api.github.com/repos/{repo}/issues/{pr_number}/comments"
        data = {"body": comment_body}
        
        response = requests.post(url, headers=self.headers, json=data)
        return response.status_code == 201
    
    def _format_audit_results(self, results: Dict) -> str:
        """Format audit results for GitHub comment"""
        security_issues = results.get('security_vulnerabilities', [])
        pattern_issues = results.get('design_patterns', [])
        
        comment = "## 🤖 AI Code Audit Results\n\n"
        
        # Security section
        if security_issues:
            critical = [i for i in security_issues if i['severity'] == 'Critical']
            high = [i for i in security_issues if i['severity'] == 'High']
            
            if critical:
                comment += f"### ⚠️ Critical Security Issues ({len(critical)})\n"
                for issue in critical[:3]:  # Limit to first 3
                    comment += f"- **{issue['name']}** in `{issue['location']}`\n"
                if len(critical) > 3:
                    comment += f"- ... and {len(critical) - 3} more\n"
                comment += "\n"
            
            if high:
                comment += f"### 🔸 High Priority Security Issues ({len(high)})\n"
                for issue in high[:2]:
                    comment += f"- {issue['name']} in `{issue['location']}`\n"
                comment += "\n"
        
        # Design patterns section
        if pattern_issues:
            anti_patterns = [p for p in pattern_issues if p.get('quality_score', 10) < 5]
            if anti_patterns:
                comment += f"### 🏗️ Design Pattern Issues ({len(anti_patterns)})\n"
                for pattern in anti_patterns[:2]:
                    comment += f"- {pattern['name']}: {pattern['recommendation']}\n"
                comment += "\n"
        
        # Summary
        if not security_issues and not pattern_issues:
            comment += "### ✅ No significant issues found!\n"
        else:
            comment += "### 📋 Next Steps\n"
            comment += "1. Address critical security vulnerabilities first\n"
            comment += "2. Review design pattern recommendations\n"
            comment += "3. Re-run audit after fixes\n"
        
        return comment
```

### Team Dashboard

```html
<!-- team-dashboard.html -->
<!DOCTYPE html>
<html>
<head>
    <title>AI Code Audit Dashboard</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="dashboard">
        <h1>Team Code Quality Dashboard</h1>
        
        <div class="metrics">
            <div class="metric-card">
                <h3>Security Posture</h3>
                <canvas id="securityChart"></canvas>
            </div>
            
            <div class="metric-card">
                <h3>Design Pattern Quality</h3>
                <canvas id="patternsChart"></canvas>
            </div>
            
            <div class="metric-card">
                <h3>Technical Debt Trend</h3>
                <canvas id="debtChart"></canvas>
            </div>
        </div>
        
        <div class="recent-audits">
            <h3>Recent Audit Results</h3>
            <table id="auditsTable">
                <thead>
                    <tr>
                        <th>Project</th>
                        <th>Date</th>
                        <th>Security</th>
                        <th>Patterns</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody id="auditsTableBody">
                    <!-- Populated by JavaScript -->
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Load and display audit data
        fetch('/api/audit-dashboard')
            .then(response => response.json())
            .then(data => {
                updateCharts(data);
                updateTable(data.recent_audits);
            });
            
        function updateCharts(data) {
            // Security trend chart
            new Chart(document.getElementById('securityChart'), {
                type: 'line',
                data: {
                    labels: data.dates,
                    datasets: [{
                        label: 'Critical Issues',
                        data: data.security_critical,
                        borderColor: 'red'
                    }, {
                        label: 'High Issues', 
                        data: data.security_high,
                        borderColor: 'orange'
                    }]
                }
            });
            
            // Pattern quality chart
            new Chart(document.getElementById('patternsChart'), {
                type: 'doughnut',
                data: {
                    labels: ['Excellent', 'Good', 'Needs Improvement'],
                    datasets: [{
                        data: [
                            data.patterns_excellent,
                            data.patterns_good, 
                            data.patterns_poor
                        ],
                        backgroundColor: ['green', 'yellow', 'red']
                    }]
                }
            });
        }
    </script>
</body>
</html>
```

## Monitoring and Alerting

### Slack Integration

```python
# scripts/slack_alerts.py
import json
import requests
from datetime import datetime

class SlackAuditAlerts:
    def __init__(self, webhook_url: str):
        self.webhook_url = webhook_url
    
    def send_critical_alert(self, audit_results: dict, project: str):
        """Send alert for critical security findings"""
        critical_issues = [
            issue for issue in audit_results.get('security_vulnerabilities', [])
            if issue['severity'] == 'Critical'
        ]
        
        if not critical_issues:
            return
            
        message = {
            "text": f"🚨 Critical Security Issues Found in {project}",
            "attachments": [
                {
                    "color": "danger",
                    "fields": [
                        {
                            "title": "Critical Issues",
                            "value": str(len(critical_issues)),
                            "short": True
                        },
                        {
                            "title": "Project",
                            "value": project,
                            "short": True
                        }
                    ],
                    "actions": [
                        {
                            "type": "button",
                            "text": "View Full Report",
                            "url": f"https://dashboard.company.com/audit/{project}"
                        }
                    ]
                }
            ]
        }
        
        requests.post(self.webhook_url, json=message)

    def send_daily_summary(self, projects_summary: dict):
        """Send daily audit summary"""
        total_critical = sum(p.get('critical', 0) for p in projects_summary.values())
        
        message = {
            "text": f"📊 Daily Code Audit Summary - {datetime.now().strftime('%Y-%m-%d')}",
            "attachments": [
                {
                    "color": "warning" if total_critical > 0 else "good",
                    "fields": [
                        {
                            "title": "Projects Scanned",
                            "value": str(len(projects_summary)),
                            "short": True
                        },
                        {
                            "title": "Total Critical Issues",
                            "value": str(total_critical),
                            "short": True
                        }
                    ]
                }
            ]
        }
        
        requests.post(self.webhook_url, json=message)
```

### Email Reporting

```python
# scripts/email_reports.py
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import json

class EmailReporter:
    def __init__(self, smtp_server: str, smtp_port: int, username: str, password: str):
        self.smtp_server = smtp_server
        self.smtp_port = smtp_port
        self.username = username
        self.password = password
    
    def send_weekly_report(self, team_email: str, audit_summary: dict):
        """Send weekly audit summary to team"""
        
        msg = MIMEMultipart()
        msg['From'] = self.username
        msg['To'] = team_email
        msg['Subject'] = f"Weekly Code Audit Report - {audit_summary['week']}"
        
        # Create HTML email body
        html_body = self._create_html_report(audit_summary)
        msg.attach(MIMEText(html_body, 'html'))
        
        # Attach detailed JSON report
        json_report = json.dumps(audit_summary, indent=2)
        attachment = MIMEBase('application', 'octet-stream')
        attachment.set_payload(json_report.encode())
        encoders.encode_base64(attachment)
        attachment.add_header(
            'Content-Disposition',
            f'attachment; filename=audit-report-{audit_summary["week"]}.json'
        )
        msg.attach(attachment)
        
        # Send email
        server = smtplib.SMTP(self.smtp_server, self.smtp_port)
        server.starttls()
        server.login(self.username, self.password)
        server.send_message(msg)
        server.quit()
    
    def _create_html_report(self, summary: dict) -> str:
        """Create HTML email report"""
        return f"""
        <html>
        <body>
            <h2>Weekly Code Audit Summary</h2>
            <h3>Security Overview</h3>
            <ul>
                <li>Critical Issues: {summary['security']['critical']}</li>
                <li>High Issues: {summary['security']['high']}</li>
                <li>Medium Issues: {summary['security']['medium']}</li>
            </ul>
            
            <h3>Design Pattern Quality</h3>
            <ul>
                <li>Average Quality Score: {summary['patterns']['avg_score']}</li>
                <li>Anti-patterns Found: {summary['patterns']['anti_patterns']}</li>
            </ul>
            
            <h3>Recommendations</h3>
            <ol>
                {"".join(f"<li>{rec}</li>" for rec in summary['recommendations'])}
            </ol>
        </body>
        </html>
        """
```

## Scaling Considerations

### Large Codebase Strategies

1. **Incremental Scanning**: Focus on changed files only
2. **Parallel Processing**: Run multiple audit types simultaneously
3. **Caching**: Cache AI responses to avoid redundant analysis
4. **Sampling**: Audit representative portions of very large codebases

### Performance Optimization

```python
# scripts/optimized_audit.py
import asyncio
import aiohttp
from typing import List, Dict
import hashlib
import json
import os

class OptimizedAuditor:
    def __init__(self, cache_dir: str = ".audit_cache"):
        self.cache_dir = cache_dir
        os.makedirs(cache_dir, exist_ok=True)
    
    async def audit_files_parallel(self, files: List[str], audit_types: List[str]) -> Dict:
        """Run audits in parallel with caching"""
        tasks = []
        
        for file_path in files:
            for audit_type in audit_types:
                task = self._audit_file_cached(file_path, audit_type)
                tasks.append(task)
        
        results = await asyncio.gather(*tasks)
        return self._consolidate_results(results)
    
    async def _audit_file_cached(self, file_path: str, audit_type: str) -> Dict:
        """Audit single file with caching"""
        # Create cache key based on file content and audit type
        with open(file_path, 'r') as f:
            file_content = f.read()
        
        cache_key = hashlib.md5(
            f"{file_content}:{audit_type}".encode()
        ).hexdigest()
        
        cache_file = os.path.join(self.cache_dir, f"{cache_key}.json")
        
        # Check cache first
        if os.path.exists(cache_file):
            with open(cache_file, 'r') as f:
                return json.load(f)
        
        # Run audit if not cached
        result = await self._run_ai_audit(file_path, audit_type)
        
        # Save to cache
        with open(cache_file, 'w') as f:
            json.dump(result, f)
        
        return result
```

## Troubleshooting Integration Issues

### Common Problems

| Issue | Symptoms | Solutions |
|-------|----------|-----------|
| API rate limits | Slow/failed audits | Implement backoff, use caching |
| Large file handling | Timeouts, memory issues | Split files, use streaming |
| CI/CD timeouts | Build failures | Optimize audit scope, parallel processing |
| False positives | Irrelevant alerts | Tune specifications, add filters |

### Debug Mode

```bash
# Enable verbose logging for troubleshooting
export AI_AUDITOR_DEBUG=true
export AI_AUDITOR_LOG_LEVEL=debug

# Run audit with detailed output
python3 audit_runner.py \
    --type security \
    --target ./src \
    --verbose \
    --debug-output debug-log.txt
```

This comprehensive integration guide should help you successfully incorporate the AI Code Auditor into your development workflows. For best practices on usage patterns, see the [Best Practices Guide](best-practices.md).