# DataHub Taxonomy Reference

This document provides a comprehensive reference for DataHub entities and aspects that can be detected by the AI code auditor.

See the [Complexity Rating Guide](Complexity-Guide.md) for explanations of implementation, detection, and performance ratings used in these specifications.

## Core Platform Entities

### Data Assets

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **Dataset** | `urn:li:dataset:*` | datasetProperties | platform, name, description, tags | Tables, files, streams, APIs |
| **Container** | `urn:li:container:*` | containerProperties | name, platform, env, description | Databases, folders, buckets |
| **SchemaField** | `urn:li:schemaField:*` | schemaFieldInfo | fieldPath, type, description | Column metadata, field documentation |

### Data Processing

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **DataJob** | `urn:li:dataJob:*` | dataJobInfo | name, type, flowUrn, description | ETL jobs, pipelines, tasks |
| **DataFlow** | `urn:li:dataFlow:*` | dataFlowInfo | name, project, description | Workflows, DAGs, orchestration |

### Analytics & Visualization

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **Chart** | `urn:li:chart:*` | chartInfo | title, type, chartUrl, lastRefreshed | Reports, visualizations, metrics |
| **Dashboard** | `urn:li:dashboard:*` | dashboardInfo | title, charts, datasets, dashboardUrl | Business intelligence, monitoring |

## Machine Learning Entities

### ML Features

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **MLFeatureTable** | `urn:li:mlFeatureTable:*` | mlFeatureTableProperties | name, mlFeatures, mlPrimaryKeys | Feature stores, ML datasets |
| **MLFeature** | `urn:li:mlFeature:*` | mlFeatureProperties | name, dataType, version, sources | Individual features, transformations |

### ML Models

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **MLModel** | `urn:li:mlModel:*` | mlModelProperties | name, type, version, groups | Trained models, model versions |
| **MLModelGroup** | `urn:li:mlModelGroup:*` | mlModelGroupProperties | name, platform, description | Model families, collections |

## Governance Entities

### Business Context

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **Domain** | `urn:li:domain:*` | domainProperties | name, description, parentDomain | Business domains, organization |
| **DataProduct** | `urn:li:dataProduct:*` | dataProductProperties | name, assets, domain | Data products, offerings |

### Glossary & Taxonomy

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **GlossaryTerm** | `urn:li:glossaryTerm:*` | glossaryTermInfo | name, definition, termSource | Business terms, definitions |
| **GlossaryNode** | `urn:li:glossaryNode:*` | glossaryNodeInfo | name, definition, parentNode | Term hierarchy, categories |
| **Tag** | `urn:li:tag:*` | tagProperties | name, description, colorHex | Labels, classifications |

### Quality & Testing

| Entity | URN Pattern | Primary Aspect | Key Properties | Use Cases |
|--------|-------------|----------------|----------------|-----------|
| **Test** | `urn:li:test:*` | testInfo | name, type, category, definition | Data quality tests, assertions |

## Core Aspects

### Ownership & Governance

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **ownership** | owners, lastModified | Asset ownership tracking | Owner assignments, responsibility |
| **globalTags** | tags | Asset classification | Tag applications, labeling |
| **glossaryTerms** | terms, auditStamp | Business term associations | Term assignments, definitions |
| **domains** | domains | Domain assignments | Business context, organization |

### Schema & Structure

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **schemaMetadata** | fields, primaryKeys, foreignKeys | Data structure definition | Schema definitions, relationships |
| **editableSchemaMetadata** | editableSchemaFieldInfo | User-editable schema info | Field descriptions, custom metadata |

### Lineage & Relationships

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **upstreamLineage** | upstreams, fineGrainedLineages | Data source tracking | Dependency mappings, transformations |
| **downstreamLineage** | downstreams | Data consumption tracking | Usage patterns, impact analysis |
| **inputFields** | fields, schemaFieldUrns | Input field mapping | Field-level lineage, transformations |
| **outputFields** | fields, schemaFieldUrns | Output field mapping | Generated fields, derived data |

### Operations & Status

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **operation** | operationType, timestampMillis, actor | Change tracking | CRUD operations, audit trails |
| **status** | removed | Asset lifecycle status | Deletion, archival states |
| **deprecation** | deprecated, decommissionTime, note | Deprecation management | Sunset planning, migration |

### Data Quality & Profiling

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **datasetProfile** | rowCount, columnCount, fieldProfiles | Data profiling statistics | Data quality metrics, statistics |
| **datasetUsageStatistics** | totalSqlQueries, userCounts, fieldCounts | Usage analytics | Access patterns, popularity |
| **testResults** | passing, failing, tests | Quality test outcomes | Test execution, validation |

### ML-Specific Aspects

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **mlModelProperties** | hyperParameters, trainingMetrics | Model metadata | Training configs, performance |
| **mlFeatureTableProperties** | mlFeatures, mlPrimaryKeys | Feature store metadata | Feature definitions, keys |
| **mlFeatureProperties** | dataType, version, sources | Feature characteristics | Feature evolution, lineage |

### Discovery & Navigation

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **browsePaths** | paths | Asset hierarchy | Navigation structure, organization |
| **browsePathsV2** | path | Enhanced browsing | Improved navigation, categorization |
| **institutionalMemory** | elements | Knowledge capture | Documentation, tribal knowledge |

### Platform Integration

| Aspect | Key Fields | Purpose | Detection Patterns |
|--------|------------|---------|-------------------|
| **dataPlatformInstance** | platform, instance | Platform identification | Source system tracking |
| **subTypes** | typeNames | Asset categorization | Type classification, variants |
| **embed** | renderUrl | Embedded content | External integrations, previews |

## Detection Guidelines

### Entity Recognition Patterns

#### URN Pattern Matching
- **Consistent Structure**: `urn:li:entityType:(platform,dataset_name,env)`
- **Platform Identification**: Extract platform information from URNs
- **Hierarchy Detection**: Parent-child relationships in URNs

#### Aspect Analysis
- **Aspect Presence**: Which aspects are attached to entities
- **Field Completeness**: Coverage of required vs optional fields
- **Consistency Patterns**: Standard field usage across entities

### Quality Assessment Metrics

#### Metadata Completeness
- **Description Coverage**: Percentage of entities with descriptions
- **Tag Application**: Consistency of tagging strategies
- **Owner Assignment**: Ownership coverage across assets

#### Lineage Quality
- **Lineage Depth**: Number of upstream/downstream connections
- **Field-Level Lineage**: Granularity of lineage tracking
- **Freshness**: Currency of lineage information

#### Governance Maturity
- **Domain Assignment**: Business domain coverage
- **Glossary Integration**: Term usage and definitions
- **Data Quality**: Test coverage and results

### Common Implementation Patterns

#### Platform Integration
- **Ingestion Patterns**: How different platforms map to DataHub
- **Custom Properties**: Platform-specific metadata extensions
- **Aspect Extensions**: Custom aspect implementations

#### Organizational Patterns
- **Naming Conventions**: Consistent entity naming strategies
- **Hierarchy Design**: Container and domain organization
- **Access Patterns**: Ownership and permission models

### Anti-Patterns and Issues

#### Metadata Debt
- **Missing Descriptions**: Undocumented assets
- **Orphaned Entities**: Assets without ownership
- **Stale Lineage**: Outdated dependency information

#### Inconsistent Usage
- **Tag Sprawl**: Inconsistent tagging strategies
- **Domain Confusion**: Unclear domain boundaries
- **Duplicate Entities**: Same asset represented multiple times

## Integration Recommendations

### Best Practices
- **Consistent URN Patterns**: Standardize naming conventions
- **Complete Metadata**: Ensure all critical aspects are populated
- **Regular Updates**: Keep lineage and ownership current
- **Quality Monitoring**: Implement data quality testing

### Automation Opportunities
- **Schema Evolution**: Automatic schema change detection
- **Lineage Discovery**: Automated dependency analysis
- **Quality Scoring**: Metadata completeness metrics
- **Compliance Reporting**: Governance adherence tracking