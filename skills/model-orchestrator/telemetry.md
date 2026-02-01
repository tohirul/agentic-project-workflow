# Telemetry, Budgeting & Burnout Governance (Authoritative)

This file defines the **mandatory telemetry system** used to enforce:

- Cost control
- Burnout prevention
- Model authority governance
- Lifecycle enforcement
- Escalation accountability

Telemetry is a **control plane**, not logging.

Telemetry is:

- Local
- Deterministic
- Append-only
- Auditable
- Enforcement-driving

Telemetry is **not optional**.
If telemetry cannot be recorded, execution MUST NOT proceed.

---

## Telemetry Scope

Telemetry is captured:

- Per project
- Per session
- Per task
- Per lifecycle phase
- Per model invocation

No model execution is allowed **before telemetry capture is initialized**.

---

## Mandatory Telemetry Fields (Strict)

Each model invocation MUST record **all** of the following fields:

| Field             | Description                                          |
| ----------------- | ---------------------------------------------------- |
| `timestamp`       | UTC execution time                                   |
| `session_id`      | Deterministic session identifier                     |
| `task_id`         | Stable task identifier                               |
| `lifecycle_phase` | Phase number (per `lifecycle.md`)                    |
| `model_name`      | Exact model ID                                       |
| `model_tier`      | Tier-A / Tier-B / Tier-C / Tier-D                    |
| `role`            | router / assistant / reviewer / architect / executor |
| `intent`          | Normalized intent (immutable)                        |
| `token_estimate`  | Input + output token estimate                        |
| `call_index`      | Nth call within the task                             |
| `result`          | success / retry / reject / halt                      |
| `failure_reason`  | REQUIRED if result ≠ success                         |
| `escalation_flag` | true / false                                         |
| `escalation_note` | REQUIRED if escalation_flag = true                   |

Missing **any** field → **execution blocked immediately**.

---

## Burnout & Budget Limits (Hard Caps)

Burnout limits are enforced **per task**, not per session.

Limits are **non-negotiable**.

---

### Tier-C — Gemini 3 (Preview / Pro Preview)

- Max **2 calls per task**
- Max **1 escalation attempt**
- Allowed intents:
  - architecture
  - research
- Allowed role:
  - architect (read-only)
- ZERO tolerance for:
  - retries after policy failure
  - scope creep
  - write operations
  - SAVE / RESTORE attempts

Exceeding limits → **hard halt (no retry)**

---

### Tier-A / Tier-B — Gemini 2 / 2.5

- Max **6 calls per task**
- Max **1 retry**
- Default for:
  - code_generation
  - debugging
  - planning
- Escalation requires:
  - telemetry justification
  - verification failure

Exceeding limits → **forced downgrade or halt**

---

### Tier-B — Gemini Pro (Low-Risk)

- Unlimited calls
- Allowed intents ONLY:
  - chat
  - summarize
  - extract
- NEVER authoritative
- NEVER escalates
- NEVER mutates context

Violation → **immediate downgrade + output discard**

---

### Tier-A — Devstral2

- Max **8 calls per task**
- Preferred for:
  - code_review
  - refactor
  - debugging
- Refactor rules:
  - Canary execution REQUIRED
  - Diff-scoped ONLY
- Retry allowed ONLY on verification failure

Exceeding limits → **halt refactor phase**

---

### Tier-D — Free / Community Models

- Max **3 calls per task**
- Output is ALWAYS **non-authoritative**
- Output MUST be verified by Tier-A or Tier-B
- No retries allowed

Any failure → **discard output immediately**

---

## Automatic Downgrade Rules (Mandatory)

Downgrade is triggered when **ANY** condition occurs:

- More than 1 retry
- Token budget exceeded
- Over-verbosity beyond output contract
- Verification rejection
- Intent complexity lower than model tier
- Lifecycle phase does not justify model authority

Downgrade rules:

- Downgrades MUST follow `selection.md`
- NEVER downgrade into forbidden intent/model pairs
- NEVER auto-promote

Downgrade failure → **hard halt**

---

## Escalation Governance (Strict)

Escalation is **explicitly gated**.

Escalation requires **ALL** of the following:

- Explicit user request OR system approval gate
- Failure of a lower-authority model
- Complete telemetry justification

### Required Escalation Payload (Mandatory)

Escalation telemetry MUST include:

- `intent`
- `previous_model`
- `failure_reason`
- `why_lower_model_failed`
- `expected_gain`

Missing any field → **escalation denied**

---

## Telemetry-Driven Enforcement Actions

Telemetry MAY trigger:

- Forced downgrade
- Retry denial
- Phase rollback
- Task halt
- Session termination
- Temporary model lockout

Telemetry MUST NOT trigger:

- Silent retries
- Silent promotion
- Silent substitution
- Context mutation

---

## Telemetry Invariants (Absolute)

- Telemetry is immutable once written
- No model may read or modify its own telemetry
- Telemetry survives session restarts
- Telemetry cannot be bypassed
- Telemetry outranks convenience
- Telemetry outranks routing
- Telemetry outranks user impatience

---

## Lifecycle Coupling (Hard Rule)

Every telemetry entry MUST include `lifecycle_phase`.

If a model acts outside its allowed phase:

→ Record violation  
→ Halt immediately  
→ Reject output

No retry. No downgrade.

---

## Final Enforcement Rule

If telemetry data is:

- Missing
- Incomplete
- Inconsistent
- Conflicting with lifecycle or intent

→ **Do not execute**
→ **Do not retry**
→ **Do not escalate**
→ **Fail explicitly**

Correctness > speed  
Governance > convenience  
Determinism > creativity
