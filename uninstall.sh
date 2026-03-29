#!/usr/bin/env bash
# uninstall.sh -- Remove SXO Skills from Claude Code
set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills"

echo "Uninstalling SXO Skills..."

for SKILL in seo-sxo-analyzer seo-sxo-builder seo-sxo-page seo-sxo-persona; do
  TARGET="${SKILL_DIR}/${SKILL}"
  if [ -d "${TARGET}" ]; then
    rm -rf "${TARGET}"
    echo "  Removed ${SKILL}"
  else
    echo "  ${SKILL} not found (skipped)"
  fi
done

echo ""
echo "SXO Skills uninstalled."
