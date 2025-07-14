#!/usr/bin/env python3
"""Generate a Graphviz dot file of pattern relationships."""
import yaml
from pathlib import Path

spec_paths = {
    'design': Path('specs/design-patterns-spec.yaml'),
    'algorithms': Path('specs/algorithms-data-structures-spec.yaml'),
    'datahub': Path('specs/datahub-spec.yaml'),
    'cloud': Path('specs/cloud-architecture-spec.yaml'),
    'security': Path('specs/security-vulnerabilities-spec.yaml'),
}

def load_yaml(path):
    with open(path) as fh:
        return yaml.safe_load(fh)

def main():
    design = load_yaml(spec_paths['design'])['patterns']
    edges = []
    for pattern in design:
        rel = pattern.get('related', {})
        for cat, items in rel.items():
            for item in items:
                edges.append((pattern['name'], item))
    with open('pattern_relationships.dot', 'w') as fh:
        fh.write('digraph Patterns {\n')
        for src, dst in edges:
            fh.write(f'  "{src}" -> "{dst}";\n')
        fh.write('}\n')

if __name__ == '__main__':
    main()
