# Workflow Customization Guide

This guide explains how to adapt the provided workflow templates to fit your environment.

## Directory Structure

```
workflows/
  ci-cd/                 # CI pipeline examples
  pre-commit/            # Local pre-commit hooks
  scheduled/             # Scheduled audit jobs
```

## CI/CD Templates

Each file in `workflows/ci-cd` demonstrates how to integrate auditing into a popular CI system. Replace notification variables such as `SLACK_WEBHOOK` with your own credentials. You may call additional scripts or adjust trigger rules as needed.

- **github-actions.yml** – runs on pull requests using GitHub Actions.
- **gitlab-ci.yml** – example stage for GitLab pipelines.
- **jenkins-pipeline** – declarative Jenkins pipeline script.
- **azure-devops.yml** – Azure DevOps job configuration.

## Pre-commit Hooks

Scripts in `workflows/pre-commit` can be invoked locally or from CI jobs.

1. `security-check.sh` – fails when critical vulnerabilities are found.
2. `pattern-validation.sh` – verifies design pattern quality.
3. `quick-audit.sh` – lightweight discovery script.

Add these to your `.git/hooks/pre-commit` or call them from pipeline steps.

## Scheduled Workflows

Files under `workflows/scheduled` show how to run recurring audits using GitHub Actions. Modify the cron expressions to match your cadence or port the commands to another scheduler.

- `weekly-security-scan.yml` – posts results to a GitHub issue every Monday.
- `monthly-tech-debt.yml` – reports low-quality patterns monthly.
- `quarterly-architecture-review.yml` – archives a summary every quarter.

## Notification Integrations

The templates use a `SLACK_WEBHOOK` environment variable to send status updates. Replace this with the notification system of your choice (Slack, Teams, email, etc.).

## Extending Workflows

- Add more script steps to analyze additional focus areas.
- Connect to issue trackers to open or update tasks automatically.
- Generate documentation artifacts and publish them to your documentation site.

These examples are starting points. Tweak them to align with your existing version control and CI environment.
