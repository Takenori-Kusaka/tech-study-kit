#!/usr/bin/env bash
# Copy the tech-study skill into the user's Claude Code skills directory (small text file only).
#   bash scripts/install-skill.sh
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}/tech-study"
mkdir -p "$dest"
cp "$here/skill/tech-study/SKILL.md" "$dest/SKILL.md"
echo "installed: $dest/SKILL.md"
