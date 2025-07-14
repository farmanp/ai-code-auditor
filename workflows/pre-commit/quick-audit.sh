#!/bin/bash
# Run a quick repository discovery audit
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")/.."

"$REPO_ROOT/scripts/repo-discovery.sh" --format json "$1" >/tmp/quick-audit.json
jq '.' /tmp/quick-audit.json >/dev/null || cat /tmp/quick-audit.json
