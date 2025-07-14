#!/usr/bin/env python3
"""
Test suite for the Build Specification Validator Tool.
"""

import os
import sys
import tempfile
import unittest
from pathlib import Path

import yaml

# Add the current directory to the Python path so we can import validate_specs
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

# Import the module with the actual file name (dash replaced with underscore for import)
import importlib.util
spec = importlib.util.spec_from_file_location("validate_specs", "validate-specs.py")
validate_specs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validate_specs)


class TestSpecValidator(unittest.TestCase):
    """Test cases for the SpecValidator class."""
    
    def setUp(self):
        """Set up test fixtures."""
        self.validator = validate_specs.SpecValidator()
        self.temp_dir = tempfile.mkdtemp()
        self.temp_path = Path(self.temp_dir)
    
    def tearDown(self):
        """Clean up test fixtures."""
        import shutil
        shutil.rmtree(self.temp_dir)
    
    def create_temp_spec(self, name: str, content: dict) -> Path:
        """Create a temporary specification file."""
        file_path = self.temp_path / f"{name}.yaml"
        with open(file_path, 'w') as f:
            yaml.dump(content, f)
        return file_path
    
    def test_valid_design_patterns_spec(self):
        """Test validation of a valid design patterns specification."""
        spec_content = {
            'patterns': [
                {
                    'name': 'Test Pattern',
                    'category': 'creational',
                    'hints': ['test_hint'],
                    'report_fields': ['test_field']
                }
            ]
        }
        
        file_path = self.create_temp_spec('design_patterns', spec_content)
        self.assertTrue(self.validator.validate_file(file_path))
        self.assertEqual(len(self.validator.errors), 0)
    
    def test_invalid_design_patterns_category(self):
        """Test validation failure for invalid category."""
        spec_content = {
            'patterns': [
                {
                    'name': 'Test Pattern',
                    'category': 'invalid_category',
                    'hints': ['test_hint'],
                    'report_fields': ['test_field']
                }
            ]
        }
        
        file_path = self.create_temp_spec('design_patterns', spec_content)
        self.assertFalse(self.validator.validate_file(file_path))
        self.assertGreater(len(self.validator.errors), 0)
        self.assertIn('invalid_category', self.validator.errors[0])
    
    def test_missing_required_fields(self):
        """Test validation failure for missing required fields."""
        spec_content = {
            'patterns': [
                {
                    'name': 'Test Pattern',
                    'category': 'creational',
                    # Missing 'hints' and 'report_fields'
                }
            ]
        }
        
        file_path = self.create_temp_spec('design_patterns', spec_content)
        self.assertFalse(self.validator.validate_file(file_path))
        self.assertGreater(len(self.validator.errors), 0)
    
    def test_valid_security_vulnerabilities_spec(self):
        """Test validation of a valid security vulnerabilities specification."""
        spec_content = {
            'vulnerabilities': [
                {
                    'name': 'Test Vulnerability',
                    'category': 'Injection',
                    'owasp_category': 'A03:2021 – Injection',
                    'severity': 'High',
                    'description': 'Test vulnerability description',
                    'detection_hints': ['test_hint'],
                    'report_fields': ['test_field']
                }
            ]
        }
        
        file_path = self.create_temp_spec('security_vulnerabilities', spec_content)
        self.assertTrue(self.validator.validate_file(file_path))
        self.assertEqual(len(self.validator.errors), 0)
    
    def test_invalid_severity_level(self):
        """Test validation failure for invalid severity level."""
        spec_content = {
            'vulnerabilities': [
                {
                    'name': 'Test Vulnerability',
                    'category': 'Injection',
                    'owasp_category': 'A03:2021 – Injection',
                    'severity': 'Invalid',
                    'description': 'Test vulnerability description',
                    'detection_hints': ['test_hint'],
                    'report_fields': ['test_field']
                }
            ]
        }
        
        file_path = self.create_temp_spec('security_vulnerabilities', spec_content)
        self.assertFalse(self.validator.validate_file(file_path))
        self.assertGreater(len(self.validator.errors), 0)
        self.assertIn('Invalid', self.validator.errors[0])
    
    def test_duplicate_pattern_names(self):
        """Test detection of duplicate pattern names."""
        spec1_content = {
            'patterns': [
                {
                    'name': 'Duplicate Pattern',
                    'category': 'creational',
                    'hints': ['test_hint'],
                    'report_fields': ['test_field']
                }
            ]
        }
        
        spec2_content = {
            'patterns': [
                {
                    'name': 'Duplicate Pattern',
                    'category': 'structural',
                    'hints': ['test_hint2'],
                    'report_fields': ['test_field2']
                }
            ]
        }
        
        file1 = self.create_temp_spec('spec1', spec1_content)
        file2 = self.create_temp_spec('spec2', spec2_content)
        
        # Validate individual files first
        self.assertTrue(self.validator.validate_file(file1))
        self.assertTrue(self.validator.validate_file(file2))
        
        # Reset validator for cross-file validation
        self.validator = validate_specs.SpecValidator()
        result = self.validator.validate_all_files(self.temp_path)
        self.assertFalse(result)
        self.assertGreater(len(self.validator.errors), 0)
        self.assertIn('Duplicate Pattern', self.validator.errors[0])
    
    def test_empty_report_fields_warning(self):
        """Test warning generation for empty report_fields."""
        spec_content = {
            'patterns': [
                {
                    'name': 'Test Pattern',
                    'category': 'creational',
                    'hints': ['test_hint'],
                    'report_fields': []  # Empty report_fields should generate warning
                }
            ]
        }
        
        file_path = self.create_temp_spec('design_patterns', spec_content)
        self.assertTrue(self.validator.validate_file(file_path))
        
        # Now run cross-file validation to trigger report fields validation
        self.validator = validate_specs.SpecValidator()
        self.validator.validate_all_files(self.temp_path)
        self.assertGreater(len(self.validator.warnings), 0)
        self.assertIn('Empty report_fields', self.validator.warnings[0])
    
    def test_yaml_syntax_error(self):
        """Test detection of YAML syntax errors."""
        file_path = self.temp_path / "invalid.yaml"
        with open(file_path, 'w') as f:
            f.write("invalid: yaml: syntax: error:\n  - unclosed")
        
        self.assertFalse(self.validator.validate_file(file_path))
        self.assertGreater(len(self.validator.errors), 0)
        self.assertIn('YAML syntax error', self.validator.errors[0])
    
    def test_unknown_spec_type(self):
        """Test handling of unknown specification types."""
        spec_content = {
            'unknown_type': [
                {
                    'name': 'Test Item',
                    'category': 'test'
                }
            ]
        }
        
        file_path = self.create_temp_spec('unknown', spec_content)
        self.assertFalse(self.validator.validate_file(file_path))
        self.assertGreater(len(self.validator.errors), 0)
        self.assertIn('Unknown specification type', self.validator.errors[0])
    
    def test_strict_mode_with_warnings(self):
        """Test strict mode treating warnings as errors."""
        spec_content = {
            'patterns': [
                {
                    'name': 'Test Pattern',
                    'category': 'creational',
                    'hints': ['test_hint'],
                    'report_fields': []  # Empty report_fields generates warning
                }
            ]
        }
        
        file_path = self.create_temp_spec('design_patterns', spec_content)
        
        # Test normal mode (warnings don't fail validation)
        self.assertTrue(self.validator.validate_file(file_path))
        
        # Test strict mode
        strict_validator = validate_specs.SpecValidator(strict=True)
        strict_validator.validate_all_files(self.temp_path)
        self.assertTrue(strict_validator.has_warnings())


if __name__ == '__main__':
    unittest.main()