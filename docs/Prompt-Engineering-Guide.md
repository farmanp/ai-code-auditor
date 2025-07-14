# Prompt Engineering Guide

This guide outlines best practices for crafting prompts when auditing codebases with AI models.

## Variables
- `[CODE_PATH]` – the path to the repository or module being scanned
- `[SPEC_PATH]` – optional path to a YAML specification to apply

## Chain-of-Thought
Encourage models to reason step by step when identifying complex issues. Include phrases like:
```
Think through each file systematically before answering.
```

## Output Formatting
Specify whether you expect JSON, Markdown tables, or free-form text. Clear formatting instructions improve consistency.

## Context Management
When scanning large repositories, limit excerpts to the most relevant lines to stay within model context limits. Summarize less important sections.

## Customization
Combine audit-type prompts with scenario prompts and model optimizations to build targeted instructions for your analysis.
