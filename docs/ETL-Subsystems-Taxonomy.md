# ETL Subsystems Taxonomy

This document provides a comprehensive reference for the 38 ETL subsystems that can be detected by the AI code auditor, based on Ralph Kimball's data warehouse architecture framework.

## Overview

Modern ETL systems are complex ecosystems requiring systematic decomposition into specialized subsystems. This taxonomy identifies 38 distinct subsystems organized into 8 major categories, each with specific responsibilities and detection patterns.

## Subsystem Categories

### Data Acquisition & Extraction (Subsystems 1-2)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **1** | **Extract System** | Source adapters, schedulers, staging | job scheduler, data staging, source connector | Medium |
| **2** | **Change Data Capture** | Log reading, delta detection, incremental loads | CDC, log mining, sequence number filter | High |

#### Data Acquisition Characteristics
- **Extract System**: Handles initial data acquisition from source systems
- **Change Data Capture**: Manages incremental updates and real-time data synchronization
- **Common Patterns**: Batch vs. streaming, push vs. pull mechanisms

### Data Quality & Profiling (Subsystems 3-8)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **3** | **Data Profiling** | Column analysis, domain inference | data profiling, structure analysis | Medium |
| **4** | **Data Cleansing** | Parsing, deduplication, standardization | data cleansing, fuzzy matching, deduplication | High |
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
| **9** | **Surrogate Key Creation** | Key generation, distribution | surrogate key, key generation | Medium |
| **10** | **SCD Processor** | Slowly changing dimensions | SCD, type 1/2/3, versioning | High |
| **11** | **Late Arriving Dimension** | Out-of-order dimension updates | late arriving, retroactive change | High |
| **12** | **Fixed Hierarchy Builder** | Many-to-one hierarchies | fixed hierarchy, parent child | Medium |
| **13** | **Variable Hierarchy Builder** | Ragged hierarchies | variable hierarchy, organization chart | High |
| **14** | **Bridge Table Builder** | Many-to-many relationships | bridge table, multivalued dimension | High |
| **15** | **Junk Dimension Builder** | Flag and indicator management | junk dimension, miscellaneous flags | Low |

#### Dimension Management Characteristics
- **Key Management**: Centralized surrogate key generation and distribution
- **Hierarchy Handling**: Fixed vs. variable depth organizational structures
- **Temporal Aspects**: Historical tracking and slowly changing dimensions

### Fact Table Loading (Subsystems 16-20)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **16** | **Transaction Grain Loader** | Atomic transaction facts | transaction grain, append mode | Medium |
| **17** | **Periodic Snapshot Loader** | Regular interval snapshots | periodic snapshot, balance snapshot | Medium |
| **18** | **Accumulating Snapshot Loader** | Milestone/workflow tracking | accumulating snapshot, milestone tracking | High |
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
| **22** | **Cube Builder** | OLAP cube construction | OLAP cube, multidimensional | High |
| **23** | **Real-time Partition Builder** | Hot partitions, streaming | real-time partition, hot partition | High |

#### Performance Optimization Characteristics
- **Aggregation Strategy**: Pre-calculated summaries for query performance
- **OLAP Integration**: Star schema preparation for cube technologies
- **Real-time Capabilities**: In-memory partitions for streaming data

### Administration & Coordination (Subsystems 24-25)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **24** | **Dimension Manager** | Centralized dimension distribution | dimension manager, conformed dimension | High |
| **25** | **Fact Table Provider** | Dimension subscription, local adaptation | fact table provider, dimension subscription | High |

#### Administrative Coordination
- **Distributed Architecture**: Centralized dimension management with local fact providers
- **Governance**: Consistent dimension definitions across business units
- **Version Management**: Synchronized updates and dependency tracking

### Workflow & Orchestration (Subsystems 26-30)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **26** | **Job Scheduler** | Workflow orchestration, dependencies | job scheduler, workflow orchestration | Medium |
| **27** | **Workflow Monitor** | Process monitoring, dashboards | workflow monitor, job monitoring | Medium |
| **28** | **Recovery & Restart** | Failure recovery, checkpointing | recovery system, checkpoint | High |
| **29** | **Parallelizing/Pipelining** | Performance optimization, scaling | parallel processing, pipelining | High |
| **30** | **Problem Escalation** | Error escalation, incident management | problem escalation, alert escalation | Medium |

#### Workflow Management Characteristics
- **Orchestration**: Complex dependency management and scheduling
- **Monitoring**: Real-time visibility into ETL process execution
- **Resilience**: Automatic recovery and restart capabilities

### Development & Deployment (Subsystems 31-33)

| ID | Subsystem | Key Functions | Detection Patterns | Complexity |
|----|-----------|---------------|-------------------|------------|
| **31** | **Version Control** | Code and metadata versioning | version control, ETL versioning | Medium |
| **32** | **Version Migration** | Environment promotion, deployment | version migration, environment promotion | High |
| **33** | **Lineage & Dependency Analyzer** | Impact analysis, data flow tracking | data lineage, dependency analysis | High |

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
| **38** | **Project Management** | Development tracking and coordination | project management, development tracking | Low |

#### Infrastructure Foundation
- **Data Protection**: Comprehensive backup and recovery strategies
- **Metadata Management**: Centralized repository for all system metadata
- **Project Coordination**: Development lifecycle and resource management

## Detection Guidelines

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
3. Surrogate Key Creation (#9)
4. SCD Processor (#10)
5. Fact Table Loaders (#16-18)
6. Job Scheduler (#26)
7. Error Event Handler (#8)
8. Metadata Repository (#37)

### Advanced Subsystems (Should Have)
- Change Data Capture (#2)
- Data Profiling (#3)
- Quality Screen Handler (#7)
- Aggregate Builder (#21)
- Workflow Monitor (#27)
- Version Control (#31)

### Specialized Subsystems (Nice to Have)
- Bridge Table Builder (#14)
- Real-time Partition Builder (#23)
- Dimension Manager (#24)
- Parallelizing System (#29)
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