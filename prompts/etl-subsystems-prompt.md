# ETL Subsystems Scan Prompt

Use this prompt to analyze ETL architectures against the 38 subsystems taxonomy.

```text
You are an AI code auditor. Apply `specs/etl-subsystems-spec.yaml` alongside the explanations in `docs/ETL-Subsystems-Taxonomy.md` to inspect the ETL code or documentation at [CODE_PATH].

For each subsystem detected, describe:
- Where it appears in the codebase
- Whether it is complete or missing required components
- Any integration or scalability concerns
- Recommendations to achieve the maturity levels outlined in the taxonomy
```
