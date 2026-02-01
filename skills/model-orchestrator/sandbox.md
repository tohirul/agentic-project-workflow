# Sandbox Execution Mode (Authoritative)

Sandbox mode is a **hard safety boundary**.
It exists to prevent unintended mutations, memory corruption,
and scope violations.

Sandbox is **ENABLED BY DEFAULT**.

No task may assume write access unless Sandbox is explicitly exited.

---

## Sandbox Invariants (Non-Negotiable)

While Sandbox is active:

- NO file writes
- NO refactors
- NO migrations
- NO task generation
- NO SAVE / RESTORE
- NO context mutation
- READ-ONLY analysis ONLY

Violation → **hard failure**

---

## What Sandbox Allows

Sandbox mode MAY:

- Analyze code
- Inspect diffs
- Explain behavior
- Identify risks
- Propose options (non-binding)
- Ask clarifying questions

All output is **advisory only**.

---

## Automatic Sandbox Enforcement (Forced Entry)

Sandbox mode is **FORCED ON** if **any** of the following are true:

- `ai.project.json` is missing
- Context validation failed
- Required RESTORE not performed
- Intent is ambiguous
- First model invocation in a project
- Preview / Tier-D model is selected
- Verification prerequisites unmet

Sandbox cannot be bypassed in these cases.

---

## Sandbox Exit (Explicit & Guarded)

Sandbox may be exited **ONLY** when **all conditions** below are met:

1. Context fully validated
2. Required RESTORE completed
3. Intent is resolved and authorized
4. User explicitly grants permission
5. Scope is declared precisely

### Required User Grant Format

User MUST specify **exact scope**, for example:

- “Allow modifications to `src/schema/*` only”
- “Allow refactor of `UserRepository.ts` only”
- “Allow write access to `migrations/2026_02_*`”

Implicit or vague permission is INVALID.

---

## Scope Locking After Exit

Once Sandbox is exited:

- Scope is **locked**
- Any action outside declared scope → failure
- Scope escalation requires re-authorization

No silent expansion allowed.

---

## Sandbox Output Marking (Mandatory)

While Sandbox is active, **ALL responses MUST be prefixed** with:
