#!/usr/bin/env bash
# Optional: make /tech-study available outside this directory too (copies the project skill to the user's skills dir).
# Inside this repository the skill is already available from .claude/skills/tech-study/.
#   bash scripts/install-skill.sh
set -euo pipefail
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}/tech-study"
mkdir -p "$dest"
cp "$here/.claude/skills/tech-study/SKILL.md" "$dest/SKILL.md"
echo "installed: $dest/SKILL.md"
