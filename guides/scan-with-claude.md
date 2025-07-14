# Scanning with Claude

This guide shows how to run a quick audit using Anthropic's Claude.

1. Open your Claude chat interface.
2. Upload the relevant spec file from `specs/` and the code you want to scan.
3. Paste the following instruction block:
   ```
   You are an AI code auditor. Apply the rules in DESIGN_PATTERN_SPEC to the code in CODE_SNIPPET. Report any matches with file names and line numbers.
   ```
4. Replace `DESIGN_PATTERN_SPEC` with the contents of `specs/design-patterns-spec.yaml` and `CODE_SNIPPET` with your code.
5. Review Claude's response for detected patterns and recommendations.

For automated scans, use `scripts/run_scan.py` which implements a minimal spec-driven scanner.
