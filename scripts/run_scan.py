#!/usr/bin/env python3
import argparse
import os
import json
from pathlib import Path
import yaml


def load_spec(spec_path: str) -> dict:
    with open(spec_path, 'r') as f:
        return yaml.safe_load(f)


def collect_hints(spec: dict):
    hints = []
    if 'patterns' in spec:
        for p in spec['patterns']:
            hints.append((p.get('name'), p.get('hints', [])))
    if 'vulnerabilities' in spec:
        for v in spec['vulnerabilities']:
            hints.append((v.get('name'), v.get('detection_hints', [])))
    if 'algorithms' in spec:
        for a in spec['algorithms']:
            hints.append((a.get('name'), a.get('hints', [])))
    return hints


def scan_file(file_path: Path, hints_map):
    results = []
    try:
        content = file_path.read_text(encoding='utf-8', errors='ignore')
    except Exception:
        return results
    lines = content.splitlines()
    for name, hints in hints_map:
        for hint in hints:
            for idx, line in enumerate(lines, start=1):
                if hint in line:
                    results.append({'file': str(file_path), 'line': idx, 'pattern': name, 'hint': hint})
    return results


def scan_repo(repo_path: Path, hints_map):
    matches = []
    for root, _, files in os.walk(repo_path):
        for file in files:
            path = Path(root) / file
            matches.extend(scan_file(path, hints_map))
    return matches


def main():
    parser = argparse.ArgumentParser(description='Simple spec-driven scanning example')
    parser.add_argument('spec', help='Path to YAML spec file')
    parser.add_argument('repo', help='Path to repository or directory to scan')
    parser.add_argument('-o', '--output', default='scan-results.json', help='Output JSON file')
    args = parser.parse_args()

    spec = load_spec(args.spec)
    hints_map = collect_hints(spec)
    results = scan_repo(Path(args.repo), hints_map)

    output_path = Path(args.output)
    output_path.write_text(json.dumps({'matches': results}, indent=2))
    print(f"Scan completed. Results saved to {output_path}")


if __name__ == '__main__':
    main()
