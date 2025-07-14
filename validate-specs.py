#!/usr/bin/env python3
"""
Build Specification Validator Tool

This tool validates YAML specifications and ensures consistency across all audit types.
It validates YAML syntax, schema compliance, checks for duplicates, and ensures
all required fields are present.
"""

import argparse
import json
import os
import sys
from collections import defaultdict
from pathlib import Path
from typing import Any, Dict, List, Optional, Set, Tuple

import yaml
from jsonschema import Draft7Validator, ValidationError


class SpecValidator:
    """Main validator class for specification files."""
    
    def __init__(self, strict: bool = False):
        self.strict = strict
        self.errors: List[str] = []
        self.warnings: List[str] = []
        self.spec_schemas = self._load_schemas()
        
    def _load_schemas(self) -> Dict[str, Dict[str, Any]]:
        """Load JSON schemas for different specification types."""
        return {
            'design_patterns': {
                'type': 'object',
                'properties': {
                    'patterns': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'category', 'hints', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'category': {'type': 'string', 'enum': ['creational', 'structural', 'behavioral', 'architectural']},
                                'hints': {'type': 'array', 'items': {'type': 'string'}},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    }
                },
                'required': ['patterns']
            },
            'security_vulnerabilities': {
                'type': 'object',
                'properties': {
                    'vulnerabilities': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'category', 'owasp_category', 'severity', 'description', 'detection_hints', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'category': {'type': 'string'},
                                'owasp_category': {'type': 'string'},
                                'severity': {'type': 'string', 'enum': ['Critical', 'High', 'Medium', 'Low', 'Varies']},
                                'description': {'type': 'string'},
                                'detection_hints': {'type': 'array', 'items': {'type': 'string'}},
                                'patterns': {'type': 'array', 'items': {'type': 'string'}},
                                'safe_alternatives': {'type': 'array', 'items': {'type': 'string'}},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    },
                    'severity_levels': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['level', 'description', 'response_time'],
                            'properties': {
                                'level': {'type': 'string'},
                                'description': {'type': 'string'},
                                'response_time': {'type': 'string'}
                            }
                        }
                    },
                    'owasp_top_10_2021': {
                        'type': 'array',
                        'items': {'type': 'string'}
                    }
                },
                'required': ['vulnerabilities']
            },
            'algorithms_data_structures': {
                'type': 'object',
                'properties': {
                    'algorithms_and_data_structures': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'category', 'hints', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'category': {'type': 'string'},
                                'paths': {'type': 'array', 'items': {'type': 'string'}},
                                'hints': {'type': 'array', 'items': {'type': 'string'}},
                                'time_complexity': {'type': 'object'},
                                'space_complexity': {'type': 'string'},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    }
                },
                'required': ['algorithms_and_data_structures']
            },
            'datahub': {
                'type': 'object',
                'properties': {
                    'datahub_entities': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'urn_pattern', 'aspect_name', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'urn_pattern': {'type': 'string'},
                                'aspect_name': {'type': 'string'},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    }
                },
                'required': ['datahub_entities']
            },
            'feasibility_analysis': {
                'type': 'object',
                'properties': {
                    'feasibility_analysis': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'category', 'analysis_type', 'hints', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'category': {'type': 'string'},
                                'analysis_type': {'type': 'string'},
                                'hints': {'type': 'array', 'items': {'type': 'string'}},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    }
                },
                'required': ['feasibility_analysis']
            },
            'etl_subsystems': {
                'type': 'object',
                'properties': {
                    'etl_subsystems': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'id', 'category', 'hints', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'id': {'type': 'integer'},
                                'category': {'type': 'string'},
                                'hints': {'type': 'array', 'items': {'type': 'string'}},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    }
                },
                'required': ['etl_subsystems']
            },
            'cloud_architecture': {
                'type': 'object',
                'properties': {
                    'cloud_architecture_patterns': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'category', 'hints', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'category': {'type': 'string'},
                                'hints': {'type': 'array', 'items': {'type': 'string'}},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    }
                },
                'required': ['cloud_architecture_patterns']
            },
            'repo_discovery': {
                'type': 'object',
                'properties': {
                    'repository_discovery': {
                        'type': 'array',
                        'items': {
                            'type': 'object',
                            'required': ['name', 'category', 'hints', 'report_fields'],
                            'properties': {
                                'name': {'type': 'string'},
                                'category': {'type': 'string'},
                                'hints': {'type': 'array', 'items': {'type': 'string'}},
                                'report_fields': {'type': 'array', 'items': {'type': 'string'}}
                            }
                        }
                    }
                },
                'required': ['repository_discovery']
            }
        }
    
    def validate_yaml_syntax(self, file_path: Path) -> bool:
        """Validate YAML syntax of a file."""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                yaml.safe_load(f)
            return True
        except yaml.YAMLError as e:
            self.errors.append(f"YAML syntax error in {file_path}: {e}")
            return False
        except Exception as e:
            self.errors.append(f"Error reading {file_path}: {e}")
            return False
    
    def detect_spec_type(self, data: Dict[str, Any]) -> Optional[str]:
        """Detect the type of specification based on its structure."""
        if 'patterns' in data:
            return 'design_patterns'
        elif 'vulnerabilities' in data:
            return 'security_vulnerabilities'
        elif 'algorithms_and_data_structures' in data:
            return 'algorithms_data_structures'
        elif 'datahub_entities' in data:
            return 'datahub'
        elif 'feasibility_analysis' in data:
            return 'feasibility_analysis'
        elif 'etl_subsystems' in data:
            return 'etl_subsystems'
        elif 'cloud_architecture_patterns' in data:
            return 'cloud_architecture'
        elif 'repository_discovery' in data:
            return 'repo_discovery'
        else:
            return None
    
    def validate_schema(self, file_path: Path, data: Dict[str, Any]) -> bool:
        """Validate data against its schema."""
        spec_type = self.detect_spec_type(data)
        if not spec_type:
            self.errors.append(f"Unknown specification type in {file_path}")
            return False
        
        schema = self.spec_schemas.get(spec_type)
        if not schema:
            self.errors.append(f"No schema defined for spec type: {spec_type}")
            return False
        
        validator = Draft7Validator(schema)
        errors = list(validator.iter_errors(data))
        
        if errors:
            for error in errors:
                path = ' -> '.join(str(p) for p in error.path)
                self.errors.append(f"Schema validation error in {file_path} at {path}: {error.message}")
            return False
        
        return True
    
    def check_duplicate_names(self, specs_data: Dict[str, Dict[str, Any]]) -> None:
        """Check for duplicate pattern names across all specifications."""
        name_to_files = defaultdict(list)
        
        for file_path, data in specs_data.items():
            spec_type = self.detect_spec_type(data)
            if not spec_type:
                continue
            
            # Get the main array key based on spec type
            main_keys = {
                'design_patterns': 'patterns',
                'security_vulnerabilities': 'vulnerabilities',
                'algorithms_data_structures': 'algorithms_and_data_structures',
                'datahub': 'datahub_entities',
                'feasibility_analysis': 'feasibility_analysis',
                'etl_subsystems': 'etl_subsystems',
                'cloud_architecture': 'cloud_architecture_patterns',
                'repo_discovery': 'repository_discovery'
            }
            
            main_key = main_keys.get(spec_type)
            if main_key and main_key in data:
                for item in data[main_key]:
                    if 'name' in item:
                        name_to_files[item['name']].append(file_path)
        
        # Check for duplicates
        for name, files in name_to_files.items():
            if len(files) > 1:
                self.errors.append(f"Duplicate pattern name '{name}' found in: {', '.join(files)}")
    
    def validate_cross_references(self, specs_data: Dict[str, Dict[str, Any]]) -> None:
        """Validate cross-references between specifications."""
        # For now, this is a placeholder for future cross-reference validation
        # Could include checking if referenced patterns exist, etc.
        pass
    
    def validate_report_fields(self, specs_data: Dict[str, Dict[str, Any]]) -> None:
        """Validate report fields consistency."""
        common_fields = {
            'location', 'implementation_quality', 'complexity', 'recommendations',
            'pattern_usage', 'best_practices', 'anti_patterns'
        }
        
        for file_path, data in specs_data.items():
            spec_type = self.detect_spec_type(data)
            if not spec_type:
                continue
            
            main_keys = {
                'design_patterns': 'patterns',
                'security_vulnerabilities': 'vulnerabilities',
                'algorithms_data_structures': 'algorithms_and_data_structures',
                'datahub': 'datahub_entities',
                'feasibility_analysis': 'feasibility_analysis',
                'etl_subsystems': 'etl_subsystems',
                'cloud_architecture': 'cloud_architecture_patterns',
                'repo_discovery': 'repository_discovery'
            }
            
            main_key = main_keys.get(spec_type)
            if main_key and main_key in data:
                for item in data[main_key]:
                    if 'report_fields' in item:
                        # Check if report_fields is not empty
                        if not item['report_fields']:
                            self.warnings.append(f"Empty report_fields in {file_path} for pattern '{item.get('name', 'unknown')}'")
    
    def validate_file(self, file_path: Path) -> bool:
        """Validate a single specification file."""
        if not self.validate_yaml_syntax(file_path):
            return False
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                data = yaml.safe_load(f)
            
            if not isinstance(data, dict):
                self.errors.append(f"Specification file {file_path} must contain a dictionary at root level")
                return False
            
            return self.validate_schema(file_path, data)
        except Exception as e:
            self.errors.append(f"Error validating {file_path}: {e}")
            return False
    
    def validate_all_files(self, specs_dir: Path) -> bool:
        """Validate all specification files in a directory."""
        spec_files = list(specs_dir.glob('*.yaml'))
        if not spec_files:
            self.errors.append(f"No YAML files found in {specs_dir}")
            return False
        
        specs_data = {}
        all_valid = True
        
        for file_path in spec_files:
            if not self.validate_file(file_path):
                all_valid = False
                continue
            
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    data = yaml.safe_load(f)
                specs_data[str(file_path)] = data
            except Exception as e:
                self.errors.append(f"Error loading {file_path}: {e}")
                all_valid = False
        
        # Run cross-file validations
        if specs_data:
            self.check_duplicate_names(specs_data)
            self.validate_cross_references(specs_data)
            self.validate_report_fields(specs_data)
        
        # Return False if there are any errors (from individual files or cross-file checks)
        return all_valid and not self.has_errors()
    
    def print_results(self) -> None:
        """Print validation results."""
        if self.errors:
            print("❌ Validation Errors:")
            for error in self.errors:
                print(f"  - {error}")
        
        if self.warnings:
            print("⚠️  Validation Warnings:")
            for warning in self.warnings:
                print(f"  - {warning}")
        
        if not self.errors and not self.warnings:
            print("✅ All specifications are valid!")
        elif not self.errors:
            print("✅ No errors found, but there are warnings.")
        
        print(f"\nValidation Summary:")
        print(f"  Errors: {len(self.errors)}")
        print(f"  Warnings: {len(self.warnings)}")
    
    def has_errors(self) -> bool:
        """Check if there are any validation errors."""
        return len(self.errors) > 0
    
    def has_warnings(self) -> bool:
        """Check if there are any validation warnings."""
        return len(self.warnings) > 0


def main():
    """Main entry point for the validation tool."""
    parser = argparse.ArgumentParser(
        description='Validate YAML specifications and ensure consistency across all audit types.'
    )
    parser.add_argument(
        '--spec',
        type=str,
        help='Path to a specific specification file to validate'
    )
    parser.add_argument(
        '--all',
        action='store_true',
        help='Validate all specification files in the specs directory'
    )
    parser.add_argument(
        '--strict',
        action='store_true',
        help='Enable strict mode (warnings become errors)'
    )
    parser.add_argument(
        '--specs-dir',
        type=str,
        default='specs',
        help='Directory containing specification files (default: specs)'
    )
    
    args = parser.parse_args()
    
    if not args.spec and not args.all:
        parser.error("Either --spec or --all must be specified")
    
    validator = SpecValidator(strict=args.strict)
    success = True
    
    if args.spec:
        spec_path = Path(args.spec)
        if not spec_path.exists():
            print(f"❌ Specification file not found: {spec_path}")
            sys.exit(1)
        
        success = validator.validate_file(spec_path)
    
    if args.all:
        specs_dir = Path(args.specs_dir)
        if not specs_dir.exists():
            print(f"❌ Specs directory not found: {specs_dir}")
            sys.exit(1)
        
        success = validator.validate_all_files(specs_dir)
    
    validator.print_results()
    
    # Exit with error code if validation failed
    if not success or validator.has_errors():
        sys.exit(1)
    
    # In strict mode, warnings are treated as errors
    if args.strict and validator.has_warnings():
        sys.exit(1)


if __name__ == '__main__':
    main()