#!/usr/bin/env bash
# install.sh -- Install SXO Skills for Claude Code
# Installs seo-sxo-analyzer, seo-sxo-builder, seo-sxo-page, seo-sxo-persona
set -euo pipefail

SKILL_DIR="${HOME}/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing SXO Skills..."

# --- seo-sxo-analyzer (root-level skill) ---
TARGET="${SKILL_DIR}/seo-sxo-analyzer"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/assets/report-template*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/references/*.md "${TARGET}/references/"
echo "  Installed seo-sxo-analyzer"

# --- seo-sxo-builder ---
TARGET="${SKILL_DIR}/seo-sxo-builder"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/sxo-builder/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/sxo-builder/assets/*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/sxo-builder/references/*.md "${TARGET}/references/"
echo "  Installed seo-sxo-builder"

# --- seo-sxo-page ---
TARGET="${SKILL_DIR}/seo-sxo-page"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/sxo-page/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/sxo-page/assets/*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/sxo-page/references/*.md "${TARGET}/references/"
echo "  Installed seo-sxo-page"

# --- seo-sxo-persona ---
TARGET="${SKILL_DIR}/seo-sxo-persona"
mkdir -p "${TARGET}/assets" "${TARGET}/references"
cp "${SCRIPT_DIR}/sxo-persona/SKILL.md" "${TARGET}/SKILL.md"
cp "${SCRIPT_DIR}"/sxo-persona/assets/*.html "${TARGET}/assets/"
cp "${SCRIPT_DIR}"/sxo-persona/references/*.md "${TARGET}/references/"
echo "  Installed seo-sxo-persona"

echo ""
echo "SXO Skills installed successfully!"
echo "  /seo-sxo-analyzer  -- SERP analysis & User Story"
echo "  /seo-sxo-builder   -- Before/after wireframe"
echo "  /seo-sxo-page      -- Production-ready page"
echo "  /seo-sxo-persona   -- Persona feedback dashboard"
