#!/bin/bash
# Validate design patterns in the codebase
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")/.."

"$REPO_ROOT/scripts/repo-discovery.sh" --area structure "$1" >/tmp/pattern-report.json

jq '.patterns[] | select(.quality_score < 5)' /tmp/pattern-report.json >/tmp/low-quality.json || true
if [ -s /tmp/low-quality.json ]; then
  echo "Low quality pattern implementations found" >&2
  exit 1
fi

exit 0
