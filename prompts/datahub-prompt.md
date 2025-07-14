# DataHub Metadata Scan Prompt

Use this prompt with your AI agent to audit DataHub entities and aspects.

```text
You are an AI code auditor. Refer to `specs/datahub-spec.yaml` along with `docs/DataHub-Taxonomy-Reference.md` to examine metadata at [CODE_PATH] or within your DataHub instance.

Report on each recognized entity and aspect:
- URNs or file references
- Aspect completeness based on the spec `report_fields`
- Governance or lineage issues
- Suggested improvements to metadata quality
```
