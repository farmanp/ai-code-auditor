# Troubleshooting Guide

This guide helps you diagnose and resolve common issues when using the AI Code Auditor, from setup problems to advanced integration challenges.

## Quick Diagnostic Checklist

When experiencing issues, start with this checklist:

- [ ] **AI Agent Access**: Can you successfully communicate with your AI agent?
- [ ] **File Permissions**: Can the tool read your codebase files?
- [ ] **Specification Validity**: Are your YAML specs syntactically correct?
- [ ] **Prompt Formatting**: Are your prompts properly formatted?
- [ ] **API Limits**: Are you hitting rate limits or quotas?
- [ ] **Network Connectivity**: Can you access external resources if needed?

## Setup and Installation Issues

### Problem: Cannot Clone or Access Repository

#### Symptoms
```bash
$ git clone https://github.com/farmanp/ai-code-auditor.git
fatal: could not read Username for 'https://github.com': terminal prompts disabled
```

#### Solutions
```bash
# Option 1: Use HTTPS with token
git clone https://github.com/farmanp/ai-code-auditor.git

# Option 2: Use SSH if configured
git clone git@github.com:farmanp/ai-code-auditor.git

# Option 3: Download ZIP if git unavailable
curl -L https://github.com/farmanp/ai-code-auditor/archive/refs/heads/main.zip -o ai-code-auditor.zip
unzip ai-code-auditor.zip
```

### Problem: File Permission Errors

#### Symptoms
```bash
PermissionError: [Errno 13] Permission denied: '/path/to/code/src/file.java'
```

#### Solutions
```bash
# Fix file permissions
chmod -R 755 /path/to/your/codebase

# Check current permissions
ls -la /path/to/your/codebase

# Run with appropriate user permissions
sudo -u developer python3 audit_runner.py
```

### Problem: YAML Specification Parsing Errors

#### Symptoms
```
yaml.scanner.ScannerError: while scanning for the next token
found character '\t' that cannot start any token
```

#### Solutions
```bash
# Validate YAML syntax
python3 -c "import yaml; yaml.safe_load(open('specs/design-patterns-spec.yaml'))"

# Check for tabs vs spaces (YAML requires spaces)
cat -A specs/design-patterns-spec.yaml | grep -n $'\t'

# Auto-fix common YAML issues
python3 scripts/fix_yaml.py specs/
```

#### YAML Validation Script
```python
# scripts/validate_specs.py
import yaml
import sys
import glob

def validate_yaml_file(filepath):
    try:
        with open(filepath, 'r') as f:
            yaml.safe_load(f)
        print(f"✅ {filepath} is valid")
        return True
    except yaml.YAMLError as e:
        print(f"❌ {filepath} has errors:")
        print(f"   {e}")
        return False

def main():
    spec_files = glob.glob("specs/*.yaml")
    valid_count = 0
    
    for spec_file in spec_files:
        if validate_yaml_file(spec_file):
            valid_count += 1
    
    print(f"\n{valid_count}/{len(spec_files)} specification files are valid")
    
    if valid_count != len(spec_files):
        sys.exit(1)

if __name__ == "__main__":
    main()
```

## AI Agent Integration Issues

### Problem: AI Agent Not Responding

#### Symptoms
- No response from AI agent
- Connection timeouts
- Authentication failures

#### Diagnostic Steps
```python
# Test basic AI agent connectivity
def test_ai_connection():
    try:
        response = your_ai_client.test_connection()
        print("✅ AI agent connection successful")
        return True
    except Exception as e:
        print(f"❌ AI agent connection failed: {e}")
        return False

# Test with simple prompt
def test_simple_prompt():
    try:
        prompt = "Respond with 'OK' if you can process this message."
        response = your_ai_client.send_prompt(prompt)
        
        if "OK" in response:
            print("✅ AI agent responding correctly")
            return True
        else:
            print(f"⚠️ Unexpected response: {response}")
            return False
    except Exception as e:
        print(f"❌ Prompt test failed: {e}")
        return False
```

#### Solutions by AI Agent Type

##### OpenAI GPT Issues
```python
# Common OpenAI troubleshooting
import openai

def troubleshoot_openai():
    # Check API key
    if not openai.api_key:
        print("❌ OpenAI API key not set")
        print("Set: export OPENAI_API_KEY=your_key_here")
        return False
    
    # Check quota
    try:
        response = openai.Completion.create(
            engine="text-davinci-003",
            prompt="test",
            max_tokens=5
        )
        print("✅ OpenAI API working")
        return True
    except openai.error.RateLimitError:
        print("❌ Rate limit exceeded - wait and retry")
        return False
    except openai.error.InvalidRequestError as e:
        print(f"❌ Invalid request: {e}")
        return False
```

##### Claude/Anthropic Issues
```python
def troubleshoot_claude():
    # Check API key format
    api_key = os.getenv("ANTHROPIC_API_KEY")
    if not api_key or not api_key.startswith("sk-ant-"):
        print("❌ Invalid Anthropic API key format")
        return False
    
    # Test basic request
    try:
        response = anthropic.Client(api_key=api_key).completions.create(
            model="claude-instant-1",
            prompt="Human: Hello\n\nAssistant:",
            max_tokens_to_sample=10
        )
        print("✅ Claude API working")
        return True
    except Exception as e:
        print(f"❌ Claude API error: {e}")
        return False
```

### Problem: Poor Quality Audit Results

#### Symptoms
- Too many false positives
- Missing obvious issues
- Inconsistent results across runs
- Vague or unhelpful recommendations

#### Diagnostic Approach
```python
def diagnose_audit_quality(audit_results):
    issues = []
    
    # Check for excessive false positives
    if audit_results.get('false_positive_rate', 0) > 0.2:
        issues.append("High false positive rate - refine detection hints")
    
    # Check for missing critical patterns
    expected_patterns = load_expected_patterns()
    found_patterns = [r['pattern'] for r in audit_results['findings']]
    missing = set(expected_patterns) - set(found_patterns)
    
    if missing:
        issues.append(f"Missing expected patterns: {missing}")
    
    # Check result consistency
    if audit_results.get('confidence_variance', 0) > 0.3:
        issues.append("High variance in results - consider ensemble approach")
    
    return issues
```

#### Solutions for Quality Issues

##### Refine Detection Hints
```yaml
# Before: Too broad
hints:
  - "password"
  - "secret"

# After: More specific
hints:
  - "password\\s*=\\s*[\"'][^\"']+[\"']"
  - "SECRET_KEY\\s*=\\s*[\"'][^\"']+[\"']"
  - "hardcoded.*password"
  - "embedded.*secret"
```

##### Improve Prompt Context
```text
# Poor prompt
"Find security issues in this code"

# Better prompt
"Analyze this Java Spring Boot web application for security vulnerabilities.
Focus on:
1. SQL injection in database queries
2. XSS in web endpoints
3. Authentication/authorization flaws
4. Input validation issues

The application handles financial data and must comply with PCI DSS.
Prioritize findings by severity and provide specific remediation steps."
```

##### Use Multiple Validation Passes
```python
def multi_pass_audit(code_path, audit_type):
    # Pass 1: Broad detection
    initial_results = run_audit(code_path, audit_type, sensitivity="high")
    
    # Pass 2: Validation of findings
    validated_results = []
    for finding in initial_results:
        validation_prompt = f"Validate this finding: {finding}"
        confidence = validate_finding(validation_prompt)
        
        if confidence > 0.7:
            validated_results.append(finding)
    
    # Pass 3: Consolidation and prioritization
    final_results = consolidate_findings(validated_results)
    
    return final_results
```

## Performance and Scaling Issues

### Problem: Slow Audit Execution

#### Symptoms
- Audits taking longer than expected
- Timeouts in CI/CD pipelines
- High memory usage
- Network bottlenecks

#### Performance Diagnostics
```python
import time
import psutil
import threading

class AuditProfiler:
    def __init__(self):
        self.start_time = None
        self.metrics = {}
    
    def start_profiling(self):
        self.start_time = time.time()
        self.metrics['start_memory'] = psutil.virtual_memory().used
        self.metrics['start_cpu'] = psutil.cpu_percent()
    
    def end_profiling(self):
        end_time = time.time()
        self.metrics['duration'] = end_time - self.start_time
        self.metrics['end_memory'] = psutil.virtual_memory().used
        self.metrics['memory_delta'] = self.metrics['end_memory'] - self.metrics['start_memory']
        self.metrics['end_cpu'] = psutil.cpu_percent()
    
    def report(self):
        print(f"Audit Duration: {self.metrics['duration']:.2f} seconds")
        print(f"Memory Usage: {self.metrics['memory_delta'] / (1024*1024):.1f} MB")
        print(f"CPU Usage: {self.metrics['end_cpu']}%")

# Usage
profiler = AuditProfiler()
profiler.start_profiling()
# Run audit
audit_results = run_audit(code_path, audit_type)
profiler.end_profiling()
profiler.report()
```

#### Solutions for Performance Issues

##### Implement Caching
```python
import hashlib
import json
import os

class AuditCache:
    def __init__(self, cache_dir=".audit_cache"):
        self.cache_dir = cache_dir
        os.makedirs(cache_dir, exist_ok=True)
    
    def get_cache_key(self, file_path, audit_type):
        with open(file_path, 'r') as f:
            content = f.read()
        
        content_hash = hashlib.md5(content.encode()).hexdigest()
        return f"{content_hash}_{audit_type}"
    
    def get_cached_result(self, cache_key):
        cache_file = os.path.join(self.cache_dir, f"{cache_key}.json")
        if os.path.exists(cache_file):
            with open(cache_file, 'r') as f:
                return json.load(f)
        return None
    
    def cache_result(self, cache_key, result):
        cache_file = os.path.join(self.cache_dir, f"{cache_key}.json")
        with open(cache_file, 'w') as f:
            json.dump(result, f)
```

##### Optimize File Processing
```python
def optimize_file_selection(project_path, audit_type):
    """Select only relevant files for audit type"""
    
    file_patterns = {
        'security': ['*.java', '*.py', '*.js', '*.php', '*.cs'],
        'design_patterns': ['*.java', '*.cs', '*.cpp', '*.py'],
        'algorithms': ['*.java', '*.cpp', '*.py', '*.go'],
        'datahub': ['*.py', '*.sql', '*.yaml', '*.json']
    }
    
    patterns = file_patterns.get(audit_type, ['*'])
    relevant_files = []
    
    for pattern in patterns:
        files = glob.glob(os.path.join(project_path, '**', pattern), recursive=True)
        relevant_files.extend(files)
    
    # Filter out test files, vendor code, etc.
    filtered_files = [
        f for f in relevant_files 
        if not any(exclude in f for exclude in [
            '/test/', '/tests/', '/node_modules/', '/vendor/', '/.git/'
        ])
    ]
    
    return filtered_files[:100]  # Limit for performance
```

##### Parallel Processing
```python
import asyncio
import aiohttp
from concurrent.futures import ThreadPoolExecutor

async def parallel_audit(files, audit_type, max_concurrent=5):
    """Run audits in parallel with concurrency limit"""
    
    semaphore = asyncio.Semaphore(max_concurrent)
    
    async def audit_single_file(file_path):
        async with semaphore:
            return await run_file_audit(file_path, audit_type)
    
    tasks = [audit_single_file(f) for f in files]
    results = await asyncio.gather(*tasks)
    
    return consolidate_results(results)
```

### Problem: API Rate Limiting

#### Symptoms
```
Rate limit exceeded. Please wait before making more requests.
HTTP 429 Too Many Requests
```

#### Solutions
```python
import time
import random
from functools import wraps

def rate_limited(max_calls_per_minute=30):
    """Decorator to implement rate limiting"""
    min_interval = 60.0 / max_calls_per_minute
    last_called = [0.0]
    
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            elapsed = time.time() - last_called[0]
            left_to_wait = min_interval - elapsed
            
            if left_to_wait > 0:
                time.sleep(left_to_wait)
            
            result = func(*args, **kwargs)
            last_called[0] = time.time()
            return result
        
        return wrapper
    return decorator

def exponential_backoff(max_retries=3):
    """Implement exponential backoff for retries"""
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            for attempt in range(max_retries):
                try:
                    return func(*args, **kwargs)
                except RateLimitError:
                    if attempt == max_retries - 1:
                        raise
                    
                    wait_time = (2 ** attempt) + random.uniform(0, 1)
                    print(f"Rate limited. Waiting {wait_time:.1f}s before retry {attempt + 1}")
                    time.sleep(wait_time)
        
        return wrapper
    return decorator

@rate_limited(max_calls_per_minute=20)
@exponential_backoff(max_retries=3)
def call_ai_api(prompt, code):
    # Your AI API call here
    pass
```

## CI/CD Integration Issues

### Problem: Pipeline Failures

#### Symptoms
- Build failures during audit steps
- Timeout errors in CI/CD
- Authentication issues in automated environments
- Inconsistent results between local and CI

#### Common CI/CD Issues and Solutions

##### GitHub Actions
```yaml
# Common issue: API key not accessible
- name: Run Security Audit
  env:
    OPENAI_API_KEY: ${{ secrets.OPENAI_API_KEY }}  # ✅ Correct
    # OPENAI_API_KEY: $OPENAI_API_KEY              # ❌ Wrong
  run: |
    if [ -z "$OPENAI_API_KEY" ]; then
      echo "❌ API key not set"
      exit 1
    fi
    python3 audit_runner.py --type security

# Common issue: Timeout with large repos
- name: Run Audit with Timeout
  timeout-minutes: 10  # ✅ Set appropriate timeout
  run: |
    # Limit scope for large repos
    python3 audit_runner.py --type security --max-files 50
```

##### Jenkins
```groovy
pipeline {
    agent any
    
    environment {
        // ✅ Proper secret handling
        AI_API_KEY = credentials('ai-api-key')
    }
    
    stages {
        stage('Audit') {
            steps {
                script {
                    try {
                        sh '''
                            # ✅ Validate environment
                            if [ -z "$AI_API_KEY" ]; then
                                echo "❌ AI API key not configured"
                                exit 1
                            fi
                            
                            # ✅ Run with error handling
                            python3 audit_runner.py --type security || {
                                echo "❌ Audit failed"
                                exit 1
                            }
                        '''
                    } catch (Exception e) {
                        // ✅ Proper error handling
                        currentBuild.result = 'FAILURE'
                        error "Audit failed: ${e.getMessage()}"
                    }
                }
            }
        }
    }
}
```

##### GitLab CI
```yaml
# Common issue: Docker image compatibility
audit-job:
  image: python:3.9-slim  # ✅ Specify exact version
  
  before_script:
    # ✅ Install dependencies explicitly
    - pip install --upgrade pip
    - pip install pyyaml requests
    
  script:
    # ✅ Validate setup before running
    - python3 --version
    - python3 -c "import yaml; print('YAML OK')"
    - python3 audit_runner.py --type security
    
  # ✅ Handle failures gracefully
  allow_failure: false
  retry:
    max: 2
    when: runner_system_failure
```

### Problem: Environment Configuration Issues

#### Symptoms
- Works locally but fails in CI
- Missing dependencies
- Path resolution issues
- Permission problems

#### Environment Validation Script
```python
#!/usr/bin/env python3
# scripts/validate_environment.py

import os
import sys
import subprocess
import importlib

def check_python_version():
    """Validate Python version"""
    if sys.version_info < (3, 7):
        print("❌ Python 3.7+ required")
        return False
    print(f"✅ Python {sys.version.split()[0]}")
    return True

def check_dependencies():
    """Check required Python packages"""
    required_packages = ['yaml', 'requests', 'json']
    missing = []
    
    for package in required_packages:
        try:
            importlib.import_module(package)
            print(f"✅ {package} available")
        except ImportError:
            missing.append(package)
            print(f"❌ {package} missing")
    
    return len(missing) == 0

def check_file_permissions():
    """Check file access permissions"""
    test_files = [
        'specs/design-patterns-spec.yaml',
        'prompts/security-audit-prompts.md'
    ]
    
    for file_path in test_files:
        if os.path.exists(file_path) and os.access(file_path, os.R_OK):
            print(f"✅ Can read {file_path}")
        else:
            print(f"❌ Cannot read {file_path}")
            return False
    
    return True

def check_api_connectivity():
    """Test API connectivity"""
    api_key = os.getenv('OPENAI_API_KEY') or os.getenv('ANTHROPIC_API_KEY')
    
    if not api_key:
        print("⚠️ No AI API key configured")
        return False
    
    print("✅ AI API key configured")
    return True

def main():
    print("🔍 Environment Validation")
    print("=" * 40)
    
    checks = [
        ("Python Version", check_python_version),
        ("Dependencies", check_dependencies),
        ("File Permissions", check_file_permissions),
        ("API Configuration", check_api_connectivity)
    ]
    
    results = []
    for check_name, check_func in checks:
        print(f"\n{check_name}:")
        result = check_func()
        results.append(result)
    
    print("\n" + "=" * 40)
    if all(results):
        print("✅ Environment validation passed")
        sys.exit(0)
    else:
        print("❌ Environment validation failed")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

## Advanced Troubleshooting

### Debug Mode Implementation

```python
import logging
import json
from datetime import datetime

class AuditDebugger:
    def __init__(self, debug_level='INFO'):
        self.debug_mode = debug_level == 'DEBUG'
        self.setup_logging(debug_level)
        self.session_data = {
            'start_time': datetime.now().isoformat(),
            'operations': [],
            'errors': [],
            'performance_metrics': {}
        }
    
    def setup_logging(self, level):
        logging.basicConfig(
            level=getattr(logging, level),
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
            handlers=[
                logging.FileHandler(f'audit_debug_{datetime.now().strftime("%Y%m%d_%H%M%S")}.log'),
                logging.StreamHandler()
            ]
        )
        self.logger = logging.getLogger('ai_auditor')
    
    def log_operation(self, operation, details):
        """Log detailed operation information"""
        self.logger.debug(f"Operation: {operation}")
        self.logger.debug(f"Details: {json.dumps(details, indent=2)}")
        
        self.session_data['operations'].append({
            'timestamp': datetime.now().isoformat(),
            'operation': operation,
            'details': details
        })
    
    def log_error(self, error, context):
        """Log error with context"""
        self.logger.error(f"Error: {error}")
        self.logger.error(f"Context: {context}")
        
        self.session_data['errors'].append({
            'timestamp': datetime.now().isoformat(),
            'error': str(error),
            'context': context
        })
    
    def save_debug_session(self):
        """Save debug session data"""
        filename = f'debug_session_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json'
        with open(filename, 'w') as f:
            json.dump(self.session_data, f, indent=2)
        
        self.logger.info(f"Debug session saved to {filename}")

# Usage example
debugger = AuditDebugger('DEBUG')

try:
    debugger.log_operation('file_scan', {'path': '/src', 'file_count': 150})
    # Run audit operations
    result = run_audit()
    debugger.log_operation('audit_complete', {'findings': len(result)})
    
except Exception as e:
    debugger.log_error(e, {'operation': 'audit_execution'})
    
finally:
    debugger.save_debug_session()
```

### Memory and Resource Monitoring

```python
import psutil
import threading
import time

class ResourceMonitor:
    def __init__(self, interval=5):
        self.interval = interval
        self.monitoring = False
        self.metrics = []
        
    def start_monitoring(self):
        """Start resource monitoring in background thread"""
        self.monitoring = True
        self.monitor_thread = threading.Thread(target=self._monitor_loop)
        self.monitor_thread.daemon = True
        self.monitor_thread.start()
        
    def stop_monitoring(self):
        """Stop monitoring and return metrics"""
        self.monitoring = False
        if hasattr(self, 'monitor_thread'):
            self.monitor_thread.join()
        return self.metrics
        
    def _monitor_loop(self):
        """Background monitoring loop"""
        while self.monitoring:
            metric = {
                'timestamp': time.time(),
                'memory_percent': psutil.virtual_memory().percent,
                'memory_used_mb': psutil.virtual_memory().used / (1024 * 1024),
                'cpu_percent': psutil.cpu_percent(),
                'disk_io': psutil.disk_io_counters()._asdict() if psutil.disk_io_counters() else {}
            }
            self.metrics.append(metric)
            time.sleep(self.interval)
    
    def analyze_metrics(self):
        """Analyze collected metrics for issues"""
        if not self.metrics:
            return "No metrics collected"
        
        issues = []
        
        # Check memory usage
        max_memory = max(m['memory_percent'] for m in self.metrics)
        if max_memory > 80:
            issues.append(f"High memory usage detected: {max_memory:.1f}%")
        
        # Check CPU usage
        avg_cpu = sum(m['cpu_percent'] for m in self.metrics) / len(self.metrics)
        if avg_cpu > 70:
            issues.append(f"High CPU usage detected: {avg_cpu:.1f}%")
        
        return issues if issues else "No resource issues detected"

# Usage
monitor = ResourceMonitor()
monitor.start_monitoring()

# Run your audit
try:
    audit_result = run_comprehensive_audit()
finally:
    metrics = monitor.stop_monitoring()
    issues = monitor.analyze_metrics()
    
    if issues:
        print("⚠️ Resource Issues:")
        for issue in issues:
            print(f"  - {issue}")
```

## Getting Help and Support

### Self-Service Resources

1. **Check Logs**: Always start with the most recent log files
2. **Validate Configuration**: Use the environment validation script
3. **Test Incrementally**: Start with simple audits before complex ones
4. **Check Documentation**: Review relevant guide sections

### Community Support

- **GitHub Issues**: Report bugs and feature requests
- **Discussion Forums**: Community Q&A and best practices
- **Documentation**: Comprehensive guides and examples

### Creating Effective Bug Reports

```markdown
## Bug Report Template

### Environment
- Operating System: [e.g., Ubuntu 20.04]
- Python Version: [e.g., 3.9.7]
- AI Agent: [e.g., OpenAI GPT-4, Claude]
- Integration: [e.g., GitHub Actions, Jenkins]

### Issue Description
[Clear description of the problem]

### Steps to Reproduce
1. [First step]
2. [Second step]
3. [Third step]

### Expected Behavior
[What you expected to happen]

### Actual Behavior
[What actually happened]

### Error Messages
```
[Paste any error messages here]
```

### Configuration Files
```yaml
# Relevant YAML specs or configuration
```

### Additional Context
[Any other relevant information]
```

### Escalation Path

1. **Level 1**: Self-service troubleshooting using this guide
2. **Level 2**: Community support via GitHub issues or forums
3. **Level 3**: Enterprise support (if applicable)

This troubleshooting guide should help you resolve most common issues. For additional support or to report bugs not covered here, please use the community resources or create detailed bug reports using the template provided.