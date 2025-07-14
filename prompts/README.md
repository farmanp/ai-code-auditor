# Prompt Library

This folder contains prompt templates for guiding an AI code auditor.

## Base Templates
- **design-patterns-prompt.md** – analyze code for GoF and architectural design patterns
- **algorithms-ds-prompt.md** – detect algorithms and data structures with complexity analysis
- **datahub-prompt.md** – audit metadata against DataHub entity and aspect standards
- **etl-subsystems-prompt.md** – inspect ETL implementations for Kimball subsystems

## Audit-Type Prompts
Located under `audit-types/`:
- `security-audit-prompts.md` – security vulnerability detection
- `cloud-audit-prompts.md` – cloud architecture analysis
- `repo-discovery-prompts.md` – repository discovery scans
- `feasibility-prompts.md` – feasibility and migration analysis

## Scenario Prompts
Located under `scenarios/`:
- `quick-scan-prompts.md`
- `deep-analysis-prompts.md`
- `migration-assessment-prompts.md`
- `compliance-check-prompts.md`

## Model Optimizations
Located under `models/`:
- `claude-optimized.md`
- `gpt-optimized.md`
- `general-purpose.md`

Copy the contents of any prompt file into your AI tool and replace `[CODE_PATH]` with the path to the code or metadata you want to analyze.
