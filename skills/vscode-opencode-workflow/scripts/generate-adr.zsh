#!/usr/bin/env zsh
set -eu
setopt pipefail

# --- Contract: Standardized Exit Codes ---
EXIT_SUCCESS=0
EXIT_VALIDATION=1
EXIT_ENV=2
EXIT_EXEC=3

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <field> <new_value> [old_value] [status]" >&2
  echo "Example: $0 application-style microservices monolith Proposed" >&2
  exit "$EXIT_VALIDATION"
fi

FIELD="$1"
NEW="$2"
OLD="${3:-none}"
STATUS="${4:-Accepted}"

DATE="$(date -u +%Y%m%d)"
ADR_DIR="docs/adr"

case "$FIELD" in
  application-style|architecture.application_style)
    SLUG="application-style"
    ;;
  api-style|tooling.api.style)
    SLUG="api-style"
    ;;
  data-storage|data.storage_type)
    SLUG="data-storage"
    ;;
  *)
    echo "ERROR: ADR not allowed for field: $FIELD" >&2
    exit "$EXIT_VALIDATION"
    ;;
esac

mkdir -p "$ADR_DIR"

INDEX=0
while true; do
  if [[ $INDEX -eq 0 ]]; then
    ADR_ID="ADR-${DATE}-${SLUG}"
  else
    ADR_ID="ADR-${DATE}-${SLUG}-${INDEX}"
  fi

  FILE="$ADR_DIR/${ADR_ID}.md"
  [[ ! -f "$FILE" ]] && break
  INDEX=$((INDEX + 1))
done

cat <<EOF > "$FILE"
# ${ADR_ID}

## Status
$STATUS

## Context
This ADR records a locked-field change in \`ai.project.json\`.

- Trigger Field: \`$FIELD\`
- Previous Value: \`$OLD\`
- New Value: \`$NEW\`
- Governing Contracts:
  - lifecycle.md
  - selection.md
  - context-contract.md

## Decision Drivers
- Enforcement of deterministic architecture
- Prevention of implicit architectural drift
- Alignment with declared project constraints

## Considered Options
- **$NEW** — Selected to align with current architectural intent
- **$OLD** — Rejected due to misalignment with current requirements

## Decision
Adopt \`$NEW\` as the authoritative value for \`$FIELD\`.

## Consequences

### Positive
- Deterministic alignment with declared architecture
- Governance-enforced consistency
- Tooling validation remains stable

### Trade-offs
- Reduced flexibility for future changes

### Risks
- Future requirement changes will require a new ADR

## Validation Plan
- \`oc_validate\` passes without violations
- Context lock enforcement remains intact

## Scope & Boundaries
- Applies only to \`$FIELD\`
- Does not modify runtime behavior or code

## Impacted Areas
- ai.project.json
- Architecture validation
- Tooling enforcement

## Supersedes / Related ADRs
- None

## Approval
- Authorized via governance workflow
- Date: $DATE
EOF

echo "✔ ADR generated: $FILE"