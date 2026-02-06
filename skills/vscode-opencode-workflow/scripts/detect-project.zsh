#!/usr/bin/env zsh
set -eu
setopt pipefail

############################################
# detect-project.zsh
#
# Purpose:
#   Deterministically detect project root,
#   primary stack, and VCS for VS Code +
#   OpenCode workflows.
#
# Contract:
#   - Shell-agnostic
#   - Read-only
#   - No environment mutation
#   - No inference or fallback heuristics
#
# Output:
#   key=value lines ONLY (stdout)
#
# Failure:
#   Non-zero exit with single error line
#   on stderr
############################################

VERSION="1.2.0"

# --- Contract: Standardized Exit Codes ---
EXIT_SUCCESS=0
EXIT_VALIDATION=1
EXIT_ENV=2
EXIT_EXEC=3
EXIT_SCOPE=4

############################################
# Help
############################################

print_help() {
  cat <<EOF
detect-project.zsh v${VERSION}

Deterministically detects project root, primary stack, and VCS.

Execution guarantees:
- No assumptions
- No shell dependencies
- No environment mutation
- Idempotent

Search strategy:
- Walks upward from current directory
- Stops strictly at filesystem root

Recognized stacks (priority order):
- node        (package.json)
- python      (pyproject.toml)
- go          (go.mod)
- rust        (Cargo.toml)
- dotnet      (*.csproj)
- php         (composer.json)

Recognized VCS:
- git         (.git directory)

Flags:
  --help        Show this help
  --verbose     Diagnostics to stderr ONLY

Output (stdout only):
  root=<absolute-path>
  stack=<single-value|unknown>
  vcs=<value|none>
  monorepo=true|false
EOF
}

############################################
# Flags
############################################

VERBOSE=false
case "${1:-}" in
  --help)
    print_help
    exit "$EXIT_SUCCESS"
    ;;
  --verbose)
    VERBOSE=true
    ;;
esac

log() {
  if [[ "$VERBOSE" == true ]]; then
    echo "[detect-project] $1" >&2
  fi
}

############################################
# Utilities (pure functions)
############################################

is_fs_root() {
  [[ "$1" == "/" ]]
}

has_file() {
  [[ -f "$1/$2" ]]
}

has_glob() {
  local dir="$1"
  local name="$2"
  [[ -n "$(find "$dir" -maxdepth 1 -name "$name" -print -quit 2>/dev/null)" ]]
}

############################################
# Detection
############################################

START_DIR="$(pwd)"
CURRENT="$START_DIR"

log "Starting detection from: $START_DIR"

PROJECT_ROOT=""
STACK="unknown"
VCS="none"
MONOREPO="false"

while true; do
  log "Inspecting: $CURRENT"

  # ------------------------------
  # Stack detection (FIRST HIT WINS)
  # ------------------------------
  if [[ "$STACK" == "unknown" ]]; then
    if has_file "$CURRENT" "package.json"; then
      STACK="node"
      PROJECT_ROOT="$CURRENT"
    elif has_file "$CURRENT" "pyproject.toml"; then
      STACK="python"
      PROJECT_ROOT="$CURRENT"
    elif has_file "$CURRENT" "go.mod"; then
      STACK="go"
      PROJECT_ROOT="$CURRENT"
    elif has_file "$CURRENT" "Cargo.toml"; then
      STACK="rust"
      PROJECT_ROOT="$CURRENT"
    elif has_glob "$CURRENT" "*.csproj"; then
      STACK="dotnet"
      PROJECT_ROOT="$CURRENT"
    elif has_file "$CURRENT" "composer.json"; then
      STACK="php"
      PROJECT_ROOT="$CURRENT"
    fi
  fi

  # ------------------------------
  # VCS detection (FIRST HIT WINS)
  # ------------------------------
  if [[ "$VCS" == "none" && -d "$CURRENT/.git" ]]; then
    VCS="git"
    log "Detected VCS: git"
  fi

  # ------------------------------
  # Monorepo detection (explicit only)
  # ------------------------------
  if [[ "$STACK" == "node" && -f "$CURRENT/package.json" ]]; then
    if grep -q "\"workspaces\"" "$CURRENT/package.json"; then
      MONOREPO="true"
      log "Detected node monorepo (workspaces)"
    fi
  fi

  # ------------------------------
  # Ascend or stop
  # ------------------------------
  if is_fs_root "$CURRENT"; then
    break
  fi

  CURRENT="$(dirname "$CURRENT")"
done

############################################
# Validation
############################################

if [[ -z "$PROJECT_ROOT" ]]; then
  echo "ERROR: Unable to determine project root" >&2
  exit "$EXIT_VALIDATION"
fi

ROOT_ABS="$(cd "$PROJECT_ROOT" && pwd)"

############################################
# Output (STRICT: stdout only)
############################################

echo "root=$ROOT_ABS"
echo "stack=$STACK"
echo "vcs=$VCS"
echo "monorepo=$MONOREPO"
