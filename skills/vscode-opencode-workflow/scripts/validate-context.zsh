#!/usr/bin/env zsh
set -eu
setopt pipefail

############################################################
# validate-context.zsh
#
# Authority:
# - Validates ai.project.json strictly
# - Enforces schema, enums, locks
# - Enforces ADR presence for locked fields
# - NO inference
# - NO mutation
# - Deterministic execution (CI / OpenCode safe)
############################################################

FILE="ai.project.json"
JQ_BIN=""

# --- Contract: Standardized Exit Codes ---
EXIT_SUCCESS=0
EXIT_VALIDATION=1
EXIT_ENV=2
EXIT_EXEC=3

############################################################
# Helpers & Logging
############################################################

log_info() { echo "✔ $*"; }
log_warn() { echo "⚠ $*" >&2; }
log_err()  { echo "✖ $*" >&2; }

fatal() {
  local msg="$1"
  local code="${2:-$EXIT_VALIDATION}"
  log_err "$msg"
  exit "$code"
}

guard_file() {
  [[ -f "$1" ]] || fatal "$1 not found (Run 'generate-context.zsh' first)" "$EXIT_VALIDATION"
}

guard_project_root() {
  [[ -d ".git" ]] || fatal "No .git directory found. strict-mode requires execution at project root." "$EXIT_VALIDATION"
}

############################################################
# Resolve jq deterministically
############################################################

resolve_jq() {
  if command -v jq >/dev/null 2>&1; then
    JQ_BIN="$(command -v jq)"
    return
  fi

  for p in /usr/bin/jq /bin/jq /usr/local/bin/jq; do
    [[ -x "$p" ]] && {
      JQ_BIN="$p"
      return
    }
  done

  fatal "jq not found in PATH or standard locations" "$EXIT_ENV"
}

############################################################
# Preflight
############################################################

guard_project_root
guard_file "$FILE"
resolve_jq

############################################################
# Primitive Validators
############################################################

require_string() {
  local path="$1"
  local value
  value="$("$JQ_BIN" -r "$path // empty" "$FILE")"
  [[ -n "$value" ]] || fatal "Missing or empty string: $path"
}

require_array() {
  local path="$1"
  "$JQ_BIN" -e "$path | type == \"array\"" "$FILE" >/dev/null \
    || fatal "Expected array: $path"
}

require_bool() {
  local path="$1"
  "$JQ_BIN" -e "$path | type == \"boolean\"" "$FILE" >/dev/null \
    || fatal "Expected boolean: $path"
}

require_enum() {
  local path="$1"
  shift
  local allowed=("$@")
  local value
  value="$("$JQ_BIN" -r "$path // empty" "$FILE")"

  for v in "${allowed[@]}"; do
    [[ "$value" == "$v" ]] && return 0
  done

  fatal "Invalid value at $path (got '$value'). Allowed: ${allowed[*]}"
}

############################################################
# Required Fields
############################################################

# ---- meta ----
require_string ".meta.project_name"
require_string ".meta.project_type"
require_string ".meta.project_stage"
require_string ".meta.last_updated"
require_string ".meta.stability_target"

# ---- direction ----
require_string ".direction.primary_goal"
require_array  ".direction.secondary_goals"
require_array  ".direction.explicit_non_goals"
require_array  ".direction.success_metrics"

# ---- architecture ----
require_string ".architecture.application_style"
require_bool   ".architecture.style_locked"
require_string ".architecture.module_system"
require_bool   ".architecture.monorepo"
require_bool   ".architecture.architecture_locked"

# ---- runtime ----
require_string ".runtime.primary_language"
require_array  ".runtime.secondary_languages"
require_array  ".runtime.execution_environment"

# ---- tooling ----
require_array  ".tooling.languages"
require_array  ".tooling.frameworks"

require_string ".tooling.api.style"
require_bool   ".tooling.api.locked"

require_string ".tooling.data.storage_type"
require_bool   ".tooling.data.locked"

# ---- workflow ----
require_array ".workflow.allowed_operations"
require_array ".workflow.requires_adr_for"

# ---- ai constraints ----
require_array  ".ai_constraints.optimization_priorities"
require_array  ".ai_constraints.explicitly_forbidden_suggestions"
require_string ".ai_constraints.assumption_policy"

############################################################
# Enum Enforcement
############################################################

require_enum ".meta.project_type" \
  web_app backend frontend mobile_app cli tool library

require_enum ".meta.project_stage" \
  planning active maintenance deprecated

require_enum ".architecture.application_style" \
  modular_monolith monolith microservices

require_enum ".tooling.api.style" \
  rest graphql fastapi rpc

require_enum ".ai_constraints.assumption_policy" \
  no-assumptions minimal-assumptions

############################################################
# Lock Semantics (Hard)
############################################################

lock_check() {
  local value_path="$1"
  local lock_path="$2"
  local label="$3"

  if "$JQ_BIN" -e "$lock_path == true" "$FILE" >/dev/null; then
    local value
    value="$("$JQ_BIN" -r "$value_path // empty" "$FILE")"
    [[ -n "$value" ]] || fatal "$label is locked but empty"
  fi
}

lock_check ".architecture.application_style" ".architecture.style_locked" "architecture.application_style"
lock_check ".tooling.api.style"               ".tooling.api.locked"        "tooling.api.style"
lock_check ".tooling.data.storage_type"       ".tooling.data.locked"       "tooling.data.storage_type"

############################################################
# Workflow Safety (Warnings Only)
############################################################

"$JQ_BIN" -e '.workflow.allowed_operations | length > 0' "$FILE" >/dev/null \
  || log_warn "workflow.allowed_operations is empty"

"$JQ_BIN" -e '.workflow.requires_adr_for | length > 0' "$FILE" >/dev/null \
  || log_warn "No ADR-triggering operations defined"

############################################################
# ADR Validation (Authoritative)
############################################################

fail_adr() {
  fatal "ADR violation: $*" "$EXIT_VALIDATION"
}

check_adr() {
  local slug="$1"
  local adr
  local adr_dir="docs/adr"
  local adr_status

  [[ -d "$adr_dir" ]] || fail_adr "ADR directory missing: $adr_dir"

  # Find ADR strictly matching the slug
  adr="$(
    find "$adr_dir" \
      -type f \
      -name "ADR-*-${slug}.md" \
      -print \
      -quit
  )"

  [[ -n "$adr" ]] || fail_adr "Missing ADR for locked field: $slug"

  grep -q '^## Status' "$adr" \
    || fail_adr "$adr missing '## Status' section"

  # Strict status extraction
  adr_status="$(
    awk '
      /^## Status/ {
        if (getline <= 0) exit
        while ($0 ~ /^[[:space:]]*$/) {
          if (getline <= 0) exit
        }
        print
        exit
      }
    ' "$adr"
  )"

  case "$adr_status" in
    Proposed|Accepted|Rejected)
      ;;
    *)
      fail_adr "$adr has invalid or missing status value: '$adr_status' (Allowed: Proposed, Accepted, Rejected)"
      ;;
  esac
}

# ---- Required ADRs for locked fields ----

"$JQ_BIN" -e '.architecture.style_locked == true' "$FILE" >/dev/null \
  && check_adr "application-style"

"$JQ_BIN" -e '.tooling.api.locked == true' "$FILE" >/dev/null \
  && check_adr "api-style"

"$JQ_BIN" -e '.tooling.data.locked == true' "$FILE" >/dev/null \
  && check_adr "data-storage"

############################################################
# Final Result
############################################################

log_info "ai.project.json is valid and ADR-compliant"
exit "$EXIT_SUCCESS"