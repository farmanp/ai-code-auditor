# ETL Subsystems Taxonomy

This document provides a comprehensive reference for the 38 ETL subsystems that can be detected by the AI code auditor, based on Ralph Kimball's data warehouse architecture framework.

## Overview

Modern ETL systems are complex ecosystems requiring systematic decomposition into specialized subsystems. This taxonomy identifies 38 distinct subsystems organized into 8 major categories, each with specific responsibilities and detection patterns.

## Subsystem Categories

### Data Acquisition & Extraction (Subsystems 1-2)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **1** | **Extract System** | Source adapters, schedulers, staging | job scheduler, data staging, source connector | Medium |
| **2** | **Change Data Capture System** | Log reading, delta detection, incremental loads | CDC, log mining, sequence number filter | High |

#### Data Acquisition Characteristics
- **Extract System**: Handles initial data acquisition from source systems
- **Change Data Capture**: Manages incremental updates and real-time data synchronization
- **Common Patterns**: Batch vs. streaming, push vs. pull mechanisms

### Data Quality & Profiling (Subsystems 3-8)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **3** | **Data Profiling System** | Column analysis, domain inference | data profiling, structure analysis | Medium |
| **4** | **Data Cleansing System** | Parsing, deduplication, standardization | data cleansing, fuzzy matching, deduplication | High |
| **5** | **Data Conformer** | Dimension conformance, integration | conformed dimension, standardization | High |
| **6** | **Audit Dimension Assembler** | Metadata context, audit trails | audit dimension, load metadata | Medium |
| **7** | **Quality Screen Handler** | Validation rules, quality gates | quality screen, validation engine | Medium |
| **8** | **Error Event Handler** | Error processing, notifications | error handler, exception handling | High |

#### Data Quality Characteristics
- **Profiling Systems**: Automated discovery of data characteristics and rules
- **Cleansing Systems**: Dictionary-driven parsing and fuzzy logic matching
- **Quality Control**: Systematic validation and error handling workflows

### Key Management & Dimensions (Subsystems 9-15)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **9** | **Surrogate Key Creation System** | Key generation, distribution | surrogate key, key generation | Medium |
| **10** | **Slowly Changing Dimension Processor** | Slowly changing dimensions | SCD, type 1/2/3, versioning | High |
| **11** | **Late Arriving Dimension Handler** | Out-of-order dimension updates | late arriving, retroactive change | High |
| **12** | **Fixed Hierarchy Dimension Builder** | Many-to-one hierarchies | fixed hierarchy, parent child | Medium |
| **13** | **Variable Hierarchy Dimension Builder** | Ragged hierarchies | variable hierarchy, organization chart | High |
| **14** | **Multivalued Dimension Bridge Table Builder** | Many-to-many relationships | bridge table, multivalued dimension | High |
| **15** | **Junk Dimension Builder** | Flag and indicator management | junk dimension, miscellaneous flags | Low |

#### Dimension Management Characteristics
- **Key Management**: Centralized surrogate key generation and distribution
- **Hierarchy Handling**: Fixed vs. variable depth organizational structures
- **Temporal Aspects**: Historical tracking and slowly changing dimensions

### Fact Table Loading (Subsystems 16-20)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **16** | **Transaction Grain Fact Table Loader** | Atomic transaction facts | transaction grain, append mode | Medium |
| **17** | **Periodic Snapshot Grain Fact Table Loader** | Regular interval snapshots | periodic snapshot, balance snapshot | Medium |
| **18** | **Accumulating Snapshot Grain Fact Table Loader** | Milestone/workflow tracking | accumulating snapshot, milestone tracking | High |
| **19** | **Surrogate Key Pipeline** | Key substitution processing | key pipeline, natural key replacement | High |
| **20** | **Late Arriving Fact Handler** | Out-of-order fact processing | late arriving fact, fact backfill | High |

#### Fact Loading Characteristics
- **Grain Types**: Transaction, periodic snapshot, accumulating snapshot
- **Processing Patterns**: Append vs. update strategies
- **Temporal Handling**: Late-arriving data and historical corrections

### Performance & OLAP (Subsystems 21-23)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **21** | **Aggregate Builder** | Summary tables, query optimization | aggregate, materialized view | Medium |
| **22** | **Multidimensional Cube Builder** | OLAP cube construction | OLAP cube, multidimensional | High |
| **23** | **Real-time Partition Builder** | Hot partitions, streaming | real-time partition, hot partition | High |

#### Performance Optimization Characteristics
- **Aggregation Strategy**: Pre-calculated summaries for query performance
- **OLAP Integration**: Star schema preparation for cube technologies
- **Real-time Capabilities**: In-memory partitions for streaming data

### Administration & Coordination (Subsystems 24-25)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **24** | **Dimension Manager System** | Centralized dimension distribution | dimension manager, conformed dimension | High |
| **25** | **Fact Table Provider System** | Dimension subscription, local adaptation | fact table provider, dimension subscription | High |

#### Administrative Coordination
- **Distributed Architecture**: Centralized dimension management with local fact providers
- **Governance**: Consistent dimension definitions across business units
- **Version Management**: Synchronized updates and dependency tracking

### Workflow & Orchestration (Subsystems 26-30)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **26** | **Job Scheduler** | Workflow orchestration, dependencies | job scheduler, workflow orchestration | Medium |
| **27** | **Workflow Monitor** | Process monitoring, dashboards | workflow monitor, job monitoring | Medium |
| **28** | **Recovery and Restart System** | Failure recovery, checkpointing | recovery system, checkpoint | High |
| **29** | **Parallelizing/Pipelining System** | Performance optimization, scaling | parallel processing, pipelining | High |
| **30** | **Problem Escalation System** | Error escalation, incident management | problem escalation, alert escalation | Medium |

#### Workflow Management Characteristics
- **Orchestration**: Complex dependency management and scheduling
- **Monitoring**: Real-time visibility into ETL process execution
- **Resilience**: Automatic recovery and restart capabilities

### Development & Deployment (Subsystems 31-33)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **31** | **Version Control System** | Code and metadata versioning | version control, ETL versioning | Medium |
| **32** | **Version Migration System** | Environment promotion, deployment | version migration, environment promotion | High |
| **33** | **Lineage and Dependency Analyzer** | Impact analysis, data flow tracking | data lineage, dependency analysis | High |

#### Development Lifecycle Management
- **Version Control**: Comprehensive versioning of code, metadata, and configurations
- **Environment Management**: Systematic promotion through dev/test/production
- **Impact Analysis**: Understanding data flow dependencies and change impacts

### Compliance & Security (Subsystems 34-35)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **34** | **Compliance Reporter** | Regulatory compliance, audit trails | compliance reporting, audit trail | High |
| **35** | **Security System** | Access control, authentication | security system, role-based security | High |

#### Governance & Security
- **Regulatory Compliance**: Automated compliance reporting and validation
- **Security Framework**: Role-based access control and audit logging
- **Data Governance**: Comprehensive tracking of data access and changes

### Infrastructure (Subsystems 36-38)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **36** | **Backup System** | Data and metadata backup | backup system, disaster recovery | Medium |
| **37** | **Metadata Repository Manager** | Comprehensive metadata management | metadata repository, metadata manager | High |
| **38** | **Project Management System** | Development tracking and coordination | project management, development tracking | Low |

#### Infrastructure Foundation
- **Data Protection**: Comprehensive backup and recovery strategies
- **Metadata Management**: Centralized repository for all system metadata
- **Project Coordination**: Development lifecycle and resource management

## Detection Guidelines

### Report Fields for AI Analysis

Each subsystem defines specific report fields that should be included in AI code auditing reports:

#### Data Acquisition & Extraction
- **Extract System**: source_systems, scheduling_mechanism, data_formats, staging_strategy, error_handling
- **Change Data Capture System**: cdc_mechanism, log_processing, change_detection_method, incremental_strategy

#### Data Quality & Profiling
- **Data Profiling System**: profiling_scope, domain_inference, relationship_discovery, rule_validation
- **Data Cleansing System**: cleansing_rules, deduplication_strategy, fuzzy_logic_usage, survivorship_rules, reference_preservation
- **Data Conformer**: conformed_attributes, integration_rules, standardization_logic, cross_source_mapping
- **Audit Dimension Assembler**: audit_attributes, metadata_capture, load_tracking, context_assembly
- **Quality Screen Handler**: quality_rules, validation_scope, rule_engine, quality_metrics
- **Error Event Handler**: error_classification, response_logic, notification_system, error_tracking

#### Key Management & Dimensions
- **Surrogate Key Creation System**: key_generation_strategy, distribution_mechanism, key_uniqueness, performance_characteristics
- **Slowly Changing Dimension Processor**: scd_types_supported, versioning_strategy, change_detection, history_preservation
- **Late Arriving Dimension Handler**: late_arrival_strategy, update_mechanism, impact_analysis, dependency_handling
- **Fixed Hierarchy Dimension Builder**: hierarchy_structure, validation_rules, maintenance_strategy, integrity_checks
- **Variable Hierarchy Dimension Builder**: hierarchy_flexibility, depth_handling, structure_validation, maintenance_complexity
- **Multivalued Dimension Bridge Table Builder**: relationship_modeling, weighting_strategy, allocation_logic, role_management
- **Junk Dimension Builder**: flag_management, combination_strategy, cardinality_optimization, flag_evolution

#### Fact Table Loading
- **Transaction Grain Fact Table Loader**: grain_definition, loading_strategy, index_management, partition_strategy
- **Periodic Snapshot Grain Fact Table Loader**: snapshot_frequency, incremental_updates, overwrite_logic, period_management
- **Accumulating Snapshot Grain Fact Table Loader**: milestone_definition, accumulation_logic, dimension_updates, measure_aggregation
- **Surrogate Key Pipeline**: pipeline_architecture, threading_model, lookup_strategy, performance_optimization
- **Late Arriving Fact Handler**: late_arrival_detection, insertion_strategy, impact_assessment, correction_handling

#### Performance & OLAP
- **Aggregate Builder**: aggregation_strategy, maintenance_schedule, query_rewrite_capability, storage_optimization
- **Multidimensional Cube Builder**: cube_structure, hierarchy_preparation, cube_technology, refresh_strategy
- **Real-time Partition Builder**: partition_strategy, memory_management, real_time_capabilities, merge_strategy

#### Administration & Coordination
- **Dimension Manager System**: distribution_mechanism, version_control, governance_rules, synchronization_strategy
- **Fact Table Provider System**: subscription_mechanism, version_management, local_customization, dependency_tracking

#### Workflow & Orchestration
- **Job Scheduler**: scheduling_capabilities, dependency_management, alert_system, condition_handling
- **Workflow Monitor**: monitoring_scope, dashboard_features, reporting_capabilities, alerting_system
- **Recovery and Restart System**: recovery_strategy, checkpoint_mechanism, rollback_capabilities, restart_granularity
- **Parallelizing/Pipelining System**: parallelization_strategy, pipeline_architecture, resource_utilization, automatic_optimization
- **Problem Escalation System**: escalation_rules, notification_levels, tracking_mechanism, resolution_workflow

#### Development & Deployment
- **Version Control System**: versioning_strategy, metadata_management, comparison_capabilities, archival_system
- **Version Migration System**: migration_process, environment_management, rollback_capability, configuration_management
- **Lineage and Dependency Analyzer**: lineage_scope, dependency_tracking, impact_analysis, visualization_capabilities

#### Compliance & Security
- **Compliance Reporter**: regulatory_scope, audit_capabilities, proof_generation, compliance_validation
- **Security System**: security_model, access_controls, audit_logging, change_tracking

#### Infrastructure
- **Backup System**: backup_strategy, recovery_capabilities, retention_policy, restore_procedures
- **Metadata Repository Manager**: metadata_scope, repository_structure, metadata_integration, search_capabilities
- **Project Management System**: project_scope, tracking_capabilities, resource_management, development_lifecycle

### Architectural Patterns

#### Layered Architecture
- **Source Layer**: Extract and CDC systems
- **Staging Layer**: Profiling and cleansing systems
- **Integration Layer**: Conformance and dimension management
- **Presentation Layer**: Fact loading and performance optimization

#### Service-Oriented Patterns
- **Key Services**: Centralized surrogate key generation
- **Dimension Services**: Conformed dimension distribution
- **Monitoring Services**: Centralized workflow monitoring

### Technology Indicators

#### ETL Tool Patterns
- **Commercial Tools**: Informatica, DataStage, SSIS patterns
- **Open Source**: Talend, Pentaho, Apache frameworks
- **Cloud Native**: AWS Glue, Azure Data Factory patterns
- **Custom Built**: Framework and library usage patterns

#### Database Integration
- **Data Warehouse Patterns**: Star schema, dimension modeling
- **Big Data Patterns**: Hadoop, Spark, streaming architectures
- **Cloud Patterns**: Snowflake, Redshift, BigQuery integration

### Quality Assessment Metrics

#### Subsystem Maturity Levels
- **Level 1 - Basic**: Manual processes, limited automation
- **Level 2 - Managed**: Systematic processes, some automation
- **Level 3 - Defined**: Standardized processes, comprehensive automation
- **Level 4 - Optimized**: Continuous improvement, advanced analytics

#### Integration Completeness
- **Horizontal Integration**: Cross-subsystem communication and coordination
- **Vertical Integration**: End-to-end data flow automation
- **Metadata Integration**: Consistent metadata across all subsystems

## Implementation Recommendations

### Essential Subsystems (Must Have)
1. Extract System (#1)
2. Data Cleansing System (#4)
3. Surrogate Key Creation System (#9)
4. Slowly Changing Dimension Processor (#10)
5. Transaction Grain Fact Table Loader (#16)
6. Periodic Snapshot Grain Fact Table Loader (#17)
7. Accumulating Snapshot Grain Fact Table Loader (#18)
8. Job Scheduler (#26)
9. Error Event Handler (#8)
10. Metadata Repository Manager (#37)

### Advanced Subsystems (Should Have)
- Change Data Capture System (#2)
- Data Profiling System (#3)
- Quality Screen Handler (#7)
- Aggregate Builder (#21)
- Workflow Monitor (#27)
- Version Control System (#31)

### Specialized Subsystems (Nice to Have)
- Multivalued Dimension Bridge Table Builder (#14)
- Real-time Partition Builder (#23)
- Dimension Manager System (#24)
- Parallelizing/Pipelining System (#29)
- Compliance Reporter (#34)

## Anti-Patterns and Issues

### Common Missing Subsystems
- **No Error Handling**: Missing error event handler leads to silent failures
- **Manual Key Management**: Lack of surrogate key automation
- **No Quality Gates**: Missing quality screens allow bad data propagation
- **Poor Monitoring**: Insufficient workflow visibility

### Integration Problems
- **Siloed Development**: Subsystems developed in isolation
- **Inconsistent Metadata**: Different metadata models across subsystems
- **Poor Coordination**: Missing dimension manager and fact provider coordination

### Scalability Issues
- **No Parallelization**: Single-threaded processing bottlenecks
- **Missing Aggregates**: Poor query performance without aggregation layer
- **No Real-time Support**: Batch-only architectures limiting responsiveness