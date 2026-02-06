#!/usr/bin/env zsh
set -eu
setopt pipefail

############################################
# select-example.zsh
#
# Purpose:
#   Interactive FZF selector for choosing
#   the correct VS Code + OpenCode example.
#
# Requirements:
#   - fzf
#   - detect-project.zsh
#
# Behavior:
#   - Lists examples with descriptions
#   - Highlights examples relevant to project stack
#   - Opens selected file in $EDITOR
#   - Falls back to stdout if no editor
############################################

SCRIPT_DIR="$(cd "$(dirname "${0:A}")" && pwd)"
export EXAMPLES_DIR="$SCRIPT_DIR/../examples"
DETECT_SCRIPT="$SCRIPT_DIR/detect-project.zsh"

# --- Contract: Standardized Exit Codes ---
EXIT_SUCCESS=0
EXIT_VALIDATION=1
EXIT_ENV=2
EXIT_EXEC=3

############################################
# Preconditions
############################################

if ! command -v fzf >/dev/null 2>&1; then
  echo "ERROR: fzf is not installed" >&2
  exit "$EXIT_ENV"
fi

if [[ ! -x "$DETECT_SCRIPT" ]]; then
  echo "WARNING: detect-project.zsh not found, skipping stack detection" >&2
fi

if [[ ! -d "$EXAMPLES_DIR" ]]; then
  echo "ERROR: examples directory not found" >&2
  exit "$EXIT_ENV"
fi

############################################
# Detect project stack (best-effort)
############################################

PROJECT_STACK="$(
  if [[ -x "$DETECT_SCRIPT" ]]; then
    "$DETECT_SCRIPT" 2>/dev/null \
      | awk -F= '$1=="stack"{print $2}'
  fi
)" || true

# Fallback if detection fails
PROJECT_STACK="${PROJECT_STACK:-unknown}"

############################################
# Example index (explicit, no guessing)
############################################

EXAMPLES=(
  "usage.md|Canonical end-to-end workflow"
  "refactor-component.md|Safe refactor of a component or folder"
  "rtk-query-review.md|RTK Query endpoint review"
  "precommit-diff-review.md|Review staged git diffs only"
  "feature-flag-review.md|Feature flag introduction and safety"
  "production-bug-analysis.md|Read-only production bug analysis"
  "monorepo-boundary-review.md|Enforce monorepo package boundaries"
  "migration-review.md|Database migration safety review"
  "prompt-cheat-sheet.md|High-signal OpenCode prompt patterns"
  "anti-patterns.md|What NOT to do (hard rules)"
)

############################################
# Build FZF input with stack awareness
############################################

FZF_INPUT=""

for entry in "${EXAMPLES[@]}"; do
  file="${entry%%|*}"
  desc="${entry##*|}"
  path="$EXAMPLES_DIR/$file"

  # Default metadata
  META_STACK="universal"

  if [[ -f "$path" ]]; then
    META_STACK="$(grep -E '^<!-- stack:' "$path" \
      | sed -E 's/.*stack:[[:space:]]*([^ ]+).*/\1/' \
      || echo "universal")"
  fi

  if [[ "$META_STACK" == "universal" || "$META_STACK" == "$PROJECT_STACK" ]]; then
    # Highlight relevant examples (Description only, keep filename raw)
    FZF_INPUT+=$(printf "%-30s \033[1;32m%s\033[0m\n" "$file" "$desc")
  else
    # Dim irrelevant examples (Description only, keep filename raw)
    FZF_INPUT+=$(printf "%-30s \033[2m%s\033[0m\n" "$file" "$desc")
  fi
done

############################################
# Selection
############################################

SELECTED_LINE=$(echo "$FZF_INPUT" | fzf \
  --prompt="Select workflow example > " \
  --height=80% \
  --border \
  --ansi \
  --no-multi \
  --preview 'sed -n "1,120p" -- "$EXAMPLES_DIR/{1}"' \
  --preview-window=right:60%) || true

if [[ -z "$SELECTED_LINE" ]]; then
  echo "No example selected."
  exit "$EXIT_SUCCESS"
fi

SELECTED_FILE="$(awk '{print $1}' <<< "$SELECTED_LINE")"
TARGET="$EXAMPLES_DIR/$SELECTED_FILE"

if [[ ! -f "$TARGET" ]]; then
  echo "ERROR: Target file not found: $TARGET" >&2
  exit "$EXIT_EXEC"
fi

############################################
# Open result
############################################

if [[ -n "${EDITOR:-}" ]]; then
  "$EDITOR" "$TARGET"
else
  cat "$TARGET"
fi
