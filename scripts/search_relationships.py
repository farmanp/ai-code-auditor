#!/usr/bin/env python3
"""Search YAML specifications for a term and show related items."""
import sys
import yaml
from pathlib import Path

SPEC_DIR = Path('specs')


def load_all_specs():
    data = []
    for path in SPEC_DIR.glob('*spec.yaml'):
        with open(path) as fh:
            data.append((path.name, yaml.safe_load(fh)))
    return data


def search(term):
    term_lower = term.lower()
    specs = load_all_specs()
    for name, content in specs:
        for section in content.values():
            if isinstance(section, list):
                for entry in section:
                    if str(entry.get('name', '')).lower() == term_lower:
                        print(f"Found in {name}: {entry['name']}")
                        rel = entry.get('related') or entry.get('related_patterns')
                        if rel:
                            print('  Related:', rel)
                    rel = entry.get('related') or entry.get('related_patterns')
                    if rel:
                        if isinstance(rel, dict):
                            if any(term_lower == str(v).lower() for items in rel.values() for v in items):
                                print(f"Referenced by {entry['name']} in {name}")
                        elif isinstance(rel, list):
                            if any(term_lower == str(v).lower() for v in rel):
                                print(f"Referenced by {entry['name']} in {name}")


def main():
    if len(sys.argv) < 2:
        print("Usage: search_relationships.py <term>")
        return
    search(sys.argv[1])

if __name__ == '__main__':
    main()
