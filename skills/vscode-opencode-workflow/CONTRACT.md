# Workflow Contract

This workflow is shell-agnostic.

## Invariants

- No scripts assume a working directory
- No scripts read shell aliases or functions
- No scripts modify user environment variables
- All execution is deterministic and idempotent

## Integration Points

External tools MAY:

- Call scripts via absolute paths
- Export OPENCODE_WORKFLOW_ROOT
- Export OPENCODE_WORKFLOW_SCRIPTS

External tools MUST NOT:

- Re-implement orchestration logic
- Infer plugins
- Modify ai.project.json implicitly
