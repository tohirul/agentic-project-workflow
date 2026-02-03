# Execution Lifecycle (Authoritative)

This file defines the **strict, non-skippable execution lifecycle**
for the Multi-Model AI Orchestrator.

The lifecycle is a **finite-state machine**.
Every task MUST progress through the phases defined here
in the exact order specified.

No phase may be skipped, merged, reordered, or repeated
unless explicitly stated.

---

## Lifecycle Philosophy

- Lifecycle enforces discipline over speed
- Each phase has exclusive authority boundaries
- Earlier phases constrain later phases
- Failure never advances the lifecycle

Correctness > convenience  
Governance > autonomy  

---

## Lifecycle Overview

Each task proceeds through the following phases:

0. State Validation  
1. Intent Classification  
2. Context Assembly  
2a. Context Bootstrap (conditional)  
3. Model Selection  
4. Delegation  
5. Execution  
6. Verification  
7. Intervention (conditional)  
8. Telemetry Finalization  
9. Memory Synchronization (SAVE)  
10. Task Termination  

Not all phases are entered for every task,
but order is always preserved.

---

## Phase 0 — State Validation (Mandatory)

**Purpose**
- Ensure the system is in a valid state to begin execution

**Checks**
- No unresolved previous failures
- Sandbox state determined
- Telemetry backend available

**Failure**
- Any failure → `HALT`

---

## Phase 1 — Intent Classification (Mandatory)

**Purpose**
- Resolve exactly ONE intent using `intent-classifier.md`

**Rules**
- Intent must be deterministic
- Intent becomes immutable after resolution

**Failure Handling**
- Ambiguous or mixed intent → `ASK_USER`
- Invalid intent → `HALT`

---

## Phase 2 — Context Assembly (Mandatory)

**Purpose**
- Assemble the frozen execution context per `context-contract.md`

**Actions**
- Load RESTORE memory (if required)
- Load `ai.project.json`
- Apply task scope and permissions

**Failure Handling**
- Missing context → `ASK_USER`
- Conflicting context → `HALT`

---

## Phase 2a — Context Bootstrap (`generate_context` ONLY)

**Entry Condition**
- intent = `generate_context`

**Purpose**
- Create or regenerate `ai.project.json` safely

**Rules**
- Sandbox remains ENABLED
- Write permission limited to `ai.project.json`
- No SAVE / RESTORE
- No other file writes

**Exit Condition**
- Valid `ai.project.json` produced

**Failure**
- Any violation → `HALT`

---

## Phase 3 — Model Selection (Mandatory)

**Purpose**
- Select an eligible model via `selection.md`
- Resolve physical model via `configuration.md`

**Rules**
- Deterministic selection only
- No heuristic routing
- No silent fallback

**Failure**
- No eligible model → `HALT`

---

## Phase 4 — Delegation (Mandatory)

**Purpose**
- Delegate execution with an explicit contract

**Delegation Contract Includes**
- Fixed model identity
- Fixed role
- Locked intent
- Frozen context snapshot
- Explicit output contract

**Rules**
- Model may not expand scope
- Model may not load additional context
- Model may not mutate memory unless allowed

Violation → `HALT`

---

## Phase 5 — Execution

**Purpose**
- Perform the task under strict constraints

**Rules**
- Prompt hardening applied
- Sandbox rules enforced
- Telemetry recorded per invocation
- No lifecycle phase escape

**Failure**
- Policy violation → `HALT`

---

## Phase 6 — Verification (Mandatory)

**Purpose**
- Validate output per `verification.md`

**Possible Outcomes**
- PASS
- HALT
- ASK_USER
- INTERVENTION_REQUIRED

No output proceeds without passing this phase.

---

## Phase 7 — Intervention (Conditional)

**Entry Condition**
- Verification result = `INTERVENTION_REQUIRED`

**Purpose**
- Allow human correction of recoverable errors

**Rules**
- Models are inactive
- Sandbox remains ENABLED
- Only output edits allowed
- No context mutation
- No SAVE / RESTORE

**Exit Conditions**
- Verification re-run
- PASS → proceed
- Failure → `HALT`

---

## Phase 8 — Telemetry Finalization (Mandatory)

**Purpose**
- Seal telemetry for the task

**Rules**
- Telemetry is append-only
- Burnout limits enforced
- Escalation records finalized

Failure → `HALT`

---

## Phase 9 — Memory Synchronization (SAVE) (Conditional)

**Entry Condition**
- Intent ∈ {architecture, domain, refactor}
- Verification PASSED
- SAVE explicitly permitted

**Rules**
- SAVE is a system action
- Memory is append-only
- Conflicts require user resolution

Misuse → `HALT`

---

## Phase 10 — Task Termination (Mandatory)

**Purpose**
- Cleanly terminate the task

**Actions**
- Release sandbox state
- Close telemetry scope
- Prevent further execution

No further actions permitted.

---

## Lifecycle Invariants (Absolute)

- No phase skipping
- No backward movement
- No concurrent phases
- No phase-specific authority leaks
- Failure never advances lifecycle

---

## Final Rule

If lifecycle progression cannot be determined unambiguously:

→ **HALT**
→ **DO NOT PROCEED**

Correct termination is compliant behavior.
