#!/usr/bin/env zsh
set -eu
setopt pipefail

############################################################
# generate-context.zsh
#
# Authority:
# - Creates ai.project.json exactly once
# - Emits ADRs for locked architectural fields
# - NO inference (logic-based guessing)
# - NO acceptance
# - Deterministic + fail-fast
############################################################

FILE="ai.project.json"
TODAY="$(date -u +"%Y-%m-%d")"
TMP_FILE=""
ADR_SCRIPT=""

# --- Contract: Standardized Exit Codes ---
EXIT_SUCCESS=0
EXIT_VALIDATION=1
EXIT_ENV=2
EXIT_EXEC=3

############################################################
# Cleanup
############################################################

cleanup() {
  [[ -n "${TMP_FILE:-}" && -f "$TMP_FILE" ]] && rm -f "$TMP_FILE"
}
trap cleanup EXIT INT TERM

############################################################
# Logging & Guards
############################################################

log_info() { echo "✔ $*"; }
log_warn() { echo "⚠ $*" >&2; }
log_err()  { echo "✖ $*" >&2; }

fatal() {
  local msg="$1"
  local code="${2:-$EXIT_EXEC}"
  log_err "$msg"
  exit "$code"
}

guard_command() {
  command -v "$1" >/dev/null 2>&1 || fatal "$1 is required (Environment Failure)" "$EXIT_ENV"
}

guard_env() {
  [[ -n "${${(P)1}:-}" ]] || fatal "$1 is not set (Environment Failure)" "$EXIT_ENV"
}

guard_absent_file() {
  [[ ! -f "$1" ]] || fatal "$1 already exists. Edit manually or remove to regenerate. (Validation Failure)" "$EXIT_VALIDATION"
}

guard_project_root() {
  [[ -d ".git" ]] || fatal "No .git directory found. strict-mode requires execution at project root. (Validation Failure)" "$EXIT_VALIDATION"
}

############################################################
# Preflight
############################################################

guard_command jq
guard_command git
guard_project_root
guard_absent_file "$FILE"
guard_env OPENCODE_WORKFLOW_SCRIPTS

ADR_SCRIPT="$OPENCODE_WORKFLOW_SCRIPTS/generate-adr.zsh"
[[ -x "$ADR_SCRIPT" ]] || fatal "ADR generator missing or not executable: $ADR_SCRIPT" "$EXIT_ENV"

# Deterministic Owner Resolution
PROJECT_OWNER="$(git config user.name 2>/dev/null || echo "")"
PROJECT_NAME="$(basename "$PWD")"

############################################################
# Create ai.project.json (Safe Construction)
############################################################

TMP_FILE="$(mktemp)"

# We use jq to construct the JSON to ensure validity and safety.
# This prevents syntax errors from unescaped strings.
jq -n \
  --arg date "$TODAY" \
  --arg owner "$PROJECT_OWNER" \
  --arg proj "$PROJECT_NAME" \
  '{
  "meta": {
    "project_name": $proj,
    "description": "",
    "project_type": "web_app",
    "project_stage": "active",
    "owner": $owner,
    "last_updated": $date,
    "stability_target": "high"
  },

  "direction": {
    "primary_goal": "",
    "secondary_goals": [],
    "explicit_non_goals": [],
    "success_metrics": []
  },

  "architecture": {
    "application_style": "modular_monolith",
    "style_locked": true,

    "module_system": "feature_based",
    "module_rules": {
      "cross_module_imports": false,
      "shared_kernel_allowed": true
    },

    "deployment_model": "single_service",
    "monorepo": false,
    "architecture_locked": true
  },

  "runtime": {
    "primary_language": "",
    "secondary_languages": [],
    "execution_environment": [
      "browser",
      "node",
      "server"
    ]
  },

  "tooling": {
    "languages": [],
    "frameworks": [],

    "ui": {
      "framework": "",
      "styling": "",
      "component_library": "",
      "ui_locked": false
    },

    "state_management": {
      "pattern": "",
      "locked": true
    },

    "api": {
      "style": "rest",
      "ownership": "backend_owned",
      "versioning": "url",
      "locked": true
    },

    "data": {
      "storage_type": "",
      "database": "",
      "migration_strategy": "",
      "locked": false
    }
  },

  "workflow": {
    "allowed_operations": [
      "code_review",
      "bug_fix",
      "refactor"
    ],
    "requires_adr_for": [
      "architecture",
      "api_style_change",
      "data_model_change",
      "cross_module_refactor"
    ]
  },

  "ai_constraints": {
    "optimization_priorities": [
      "correctness",
      "maintainability"
    ],
    "explicitly_forbidden_suggestions": [
      "new_framework",
      "new_language",
      "architecture_change"
    ],
    "assumption_policy": "no-assumptions"
  }
}' > "$TMP_FILE"

# Double check validity (redundant with jq -n but good for paranoia)
jq empty "$TMP_FILE" || fatal "Generated JSON is invalid (Execution Failure)" "$EXIT_EXEC"

# Atomic move
mv "$TMP_FILE" "$FILE"
TMP_FILE=""

############################################################
# ADR Enforcement (Proposed Only)
############################################################

require_adr() {
  local value_path="$1"
  local lock_path="$2"
  local slug="$3"

  local value locked

  value="$(jq -r "$value_path // empty" "$FILE")"
  locked="$(jq -r "$lock_path // false" "$FILE")"

  [[ -n "$value" ]] || return 0
  [[ "$locked" == "true" ]] || return 0

  log_info "[Context] Locked architecture detected: $slug = $value"
  "$ADR_SCRIPT" "$slug" "$value" "none" "Proposed" || log_warn "Failed to generate ADR for $slug"
}

# ---- Authoritative ADR Triggers ----
# These fields are locked by default in the template, so ADRs will trigger.

require_adr ".architecture.application_style" ".architecture.style_locked" "application-style"
require_adr ".tooling.api.style"               ".tooling.api.locked"        "api-style"
require_adr ".tooling.data.storage_type"       ".tooling.data.locked"       "data-storage"

############################################################
# Final Output
############################################################

cat <<EOF
✔ ai.project.json created successfully.

IMPORTANT ACTIONS REQUIRED:
1. Open 'ai.project.json'
2. Fill in empty fields ("") explicitly.
3. Review locked fields; generated ADRs are in 'Proposed' state.
EOF

exit "$EXIT_SUCCESS"