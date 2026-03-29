#!/usr/bin/env bash
# install.sh -- Install SXO Skills for Claude Code
# Installs sxo-analyze, sxo-wireframe, sxo-prototype, sxo-persona
set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing SXO Skills..."

# --- sxo-analyze (root-level skill) ---
TARGET="${SKILL_DIR}/sxo-analyze"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/assets/report-template*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/references/*.md "${TARGET}/references/"
echo "  Installed sxo-analyze"

# --- sxo-wireframe ---
TARGET="${SKILL_DIR}/sxo-wireframe"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/sxo-builder/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/sxo-builder/assets/*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/sxo-builder/references/*.md "${TARGET}/references/"
echo "  Installed sxo-wireframe"

# --- sxo-prototype ---
TARGET="${SKILL_DIR}/sxo-prototype"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/sxo-page/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/sxo-page/assets/*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/sxo-page/references/*.md "${TARGET}/references/"
echo "  Installed sxo-prototype"

# --- sxo-persona ---
TARGET="${SKILL_DIR}/sxo-persona"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/sxo-persona/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/sxo-persona/assets/*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/sxo-persona/references/*.md "${TARGET}/references/"
echo "  Installed sxo-persona"

echo ""
echo "SXO Skills installed successfully!"
echo "  /sxo-analyze  -- SERP analysis & User Story"
echo "  /sxo-wireframe   -- Before/after wireframe"
echo "  /sxo-prototype      -- Production-ready page"
echo "  /sxo-persona   -- Persona feedback dashboard"
