# Sandbox Execution Model (Authoritative)

This file defines the **sandbox execution boundary** for the
Multi-Model AI Orchestrator.

The sandbox is a **hard isolation layer** that prevents unsafe execution,
context mutation, and unauthorized persistence.

Sandboxing is **automatic**, **non-optional**, and **policy-driven**.

---

## Sandbox Philosophy

- Sandbox favors safety over progress
- Sandbox is restrictive by default
- Sandbox does not infer intent or permissions
- Sandbox failure is always explicit

Correctness > convenience  
Safety > speed  

---

## What the Sandbox Is

The sandbox is a **restricted execution environment** where:

- File system access is limited
- Memory mutation is forbidden
- SAVE / RESTORE are disabled (with one exception)
- Outputs are advisory unless explicitly allowed

The sandbox applies **before any trust is established**.

---

## When Sandbox Is Enforced (Mandatory)

Sandbox mode MUST be enabled when **ANY** of the following conditions are true:

- `ai.project.json` is missing
- Context validation has not completed
- Execution is in a bootstrap phase
- Intent is unresolved or ambiguous
- First execution in a new project
- A previous execution ended in failure

There are **no overrides** for these conditions.

---

## Sandbox Permissions (Default)

While sandboxed, the system operates under **read-only** permissions.

### Forbidden Actions (Default)

- Writing files
- Modifying code
- Triggering SAVE
- Triggering RESTORE
- Mutating context
- Escalating model authority
- Performing refactors
- Making architectural decisions

Any forbidden action attempt → **HALT**

---

## Bootstrap Exception — `generate_context`

The intent `generate_context` is the **only permitted sandbox write exception**.

### Allowed While Sandboxed

- Create or overwrite `ai.project.json` ONLY

### Explicitly Forbidden

- Writing any other file
- Creating directories
- Modifying memory
- Triggering SAVE / RESTORE
- Generating code or configuration beyond `ai.project.json`

Violation → **HALT**

---

## Sandbox Output Rules

All sandbox outputs are:

- Non-authoritative
- Non-persistent
- Subject to full verification

Sandbox output MUST NOT:
- Be saved
- Be reused as memory
- Be treated as final decisions

---

## Exiting the Sandbox

The sandbox MAY be exited ONLY when **ALL** conditions below are true:

- Intent is resolved and immutable
- Context validation passed
- `ai.project.json` exists (except during bootstrap)
- Required RESTORE completed (if applicable)
- Explicit scope and permissions declared
- No unresolved failures exist

If any condition is false → remain sandboxed

---

## Re-Entering the Sandbox

Sandbox MUST be re-enabled if:

- Execution halts
- Context changes
- Intent changes
- Verification fails
- User edits scope or permissions
- A new task begins

Sandbox state is **not preserved** across tasks.

---

## Sandbox & Intervention Interaction

If execution enters `INTERVENTION_REQUIRED`:

- Sandbox remains ENABLED
- No additional permissions are granted
- Human corrections are allowed ONLY on produced output
- Verification may be re-run after intervention

Models MAY NOT act during intervention.

---

## Sandbox Violation Handling

| Violation Type | Action |
|---------------|--------|
| Unauthorized write | `HALT` |
| SAVE / RESTORE attempt | `HALT` |
| Authority escalation | `HALT` |
| Context mutation | `HALT` |

No retries are permitted after sandbox violations.

---

## Final Rule

If there is **any uncertainty** about whether an action is safe:

→ Keep sandbox ENABLED  
→ Block the action  
→ Ask the user explicitly  

Safe non-execution is correct behavior.
