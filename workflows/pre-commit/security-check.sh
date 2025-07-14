#!/bin/bash
# Simple security scan using repo-discovery script security mode
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")/.."

"$REPO_ROOT/scripts/repo-discovery.sh" --area security "$1" >/tmp/security-report.json

if grep -q '"severity": "Critical"' /tmp/security-report.json; then
  echo "Critical vulnerabilities detected" >&2
  exit 1
fi

exit 0
