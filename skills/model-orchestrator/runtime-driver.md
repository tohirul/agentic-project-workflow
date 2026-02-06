# Runtime Driver & Control Loop (Authoritative)

This document defines **how the Multi-Model AI Orchestrator executes**
the policies declared in the control-plane documents.

This file **introduces no new policy**.
It operationalizes existing rules exactly as defined elsewhere.

If this file conflicts with any policy document
(`CONTRACT.md`, `SKILL.md`, `context-contract.md`, `lifecycle.md`,
`selection.md`, `configuration.md`, `telemetry.md`):

→ **Policy documents win**

---

## Purpose of the Runtime Driver

The runtime driver is responsible for:

- Executing the lifecycle finite-state machine
- Selecting and enforcing telemetry mode
- Enforcing CHECKS and verification gates
- Initializing, enforcing, and sealing telemetry
- Managing sandbox state transitions
- Routing execution deterministically
- Halting explicitly and safely on violation

The driver **does not reason**.  
The driver **does not generate content**.  
The driver **does not override policy**.

---

## Execution Model

The runtime driver operates as a **single-task, single-loop controller**.

- No background execution
- No parallel lifecycle phases
- No speculative execution
- No concurrent tasks

Each task is processed to **completion or termination**
before another task may begin.

---

## Bootstrap Safety Invariant (Critical)

The runtime driver MUST obey the following invariant:

> **No policy that depends on intent may be enforced
> before intent is resolved.**

Consequences:

- `ai.project.json` MUST NOT be required or loaded
  before Phase 1 (Intent Classification)
- RESTORE memory MUST NOT be loaded
  before Phase 1
- Plugin context MUST NOT be loaded
  before Phase 1

Violation → **HALT**

---

## Telemetry Mode Selection (Authoritative)

Telemetry mode is a **policy-bound runtime decision**.

The runtime driver MUST select **exactly ONE telemetry mode**
(`ENFORCED` or `DEGRADED`) per task.

### Invariants

Telemetry mode selection MUST:

- Occur during driver initialization
- Occur **before Phase 0**
- Be deterministic
- Be recorded in telemetry metadata
- Remain immutable for the entire task

Failure to select telemetry mode deterministically → **HALT**

---

## Telemetry Mode Selection Algorithm (Normative)

Telemetry mode is selected using the following ordered rules.
The **first matching rule applies**. No later rule may override it.

### Rule 1 — Forced ENFORCED Mode

Telemetry mode MUST be set to `ENFORCED` if ANY are true:

- intent ∈ {architecture, domain, refactor, code_generation, code_review}
- selected authority tier ≥ Tier-B
- SAVE or RESTORE is permitted or required
- escalation is allowed by policy
- execution environment ∈ {ci, production}

If Rule 1 matches:

→ `telemetry_mode = ENFORCED`

---

### Rule 2 — Eligible DEGRADED Mode

Telemetry mode MAY be set to `DEGRADED` ONLY if ALL are true:

- intent ∈ {chat, summarize, classify}
- selected authority tier = Tier-D
- SAVE / RESTORE is forbidden
- escalation is forbidden
- execution environment ∈ {local, dev}
- local durable telemetry backend is available

If ALL conditions hold:

→ `telemetry_mode = DEGRADED`

---

### Rule 3 — Default Fallback

If Rule 1 does not apply AND Rule 2 does not apply:

→ `telemetry_mode = ENFORCED`

There is **no other valid outcome**.

---

## Telemetry Mode Guardrail (Runtime Enforcement)

The runtime driver MUST HALT immediately if:

- `telemetry_mode = DEGRADED` AND
  - authority tier ≠ Tier-D
  - OR intent ∉ {chat, summarize, classify}
  - OR SAVE / RESTORE is attempted
  - OR escalation is attempted
  - OR local telemetry write fails

No downgrade, retry, or fallback is permitted.

---

## Context Loading Model

The driver operates with **two explicit context tiers**.

### Tier 0 — Bootstrap Context (Pre-Intent)

Available **before Phase 1**:

- User prompt
- Invocation metadata
- System defaults

Forbidden **before Phase 1**:

- `ai.project.json`
- RESTORE memory
- Plugin context
- Any project-bound data

Tier 0 exists **only** to allow intent classification.

---

### Tier 1 — Full Context (Post-Intent)

Loaded **only after Phase 1** and **only as permitted by intent**:

- RESTORE memory (if required)
- `ai.project.json` (if required)
- Declared task scope & permissions
- Explicit plugin contracts (if enabled)

If an intent requires `ai.project.json` and it is missing → **HALT**  
If intent = `generate_context`, `ai.project.json` MUST NOT be required.

---

## High-Level Control Loop (Authoritative)

```
initialize_driver()

// Telemetry mode selection (MANDATORY)
telemetry_mode = select_telemetry_mode()
initialize_telemetry(telemetry_mode)

while task_requested:

    // Phase 0 — State Validation
    phase = Phase0_StateValidation
    run_phase(phase)

    // Phase 1 — Intent Classification
    phase = Phase1_IntentClassification
    intent = run_phase(phase)

    // Phase 2 — Context Assembly (Intent-Aware)
    phase = Phase2_ContextAssembly
    run_phase(phase)

    // Phase 2a — Context Bootstrap (generate_context ONLY)
    if intent == generate_context:
        phase = Phase2a_ContextBootstrap
        run_phase(phase)

    // Phase 3 — Model Selection
    phase = Phase3_ModelSelection
    run_phase(phase)

    // Phase 4 — Delegation
    phase = Phase4_Delegation
    run_phase(phase)

    // Phase 5 — Execution
    phase = Phase5_Execution
    run_phase(phase)

    // Phase 6 — Verification
    phase = Phase6_Verification
    result = run_phase(phase)

    if result == INTERVENTION_REQUIRED:
        phase = Phase7_Intervention
        run_phase(phase)
        phase = Phase6_Verification
        result = run_phase(phase)

    if result != PASS:
        terminate_task()
        continue

    // Phase 8 — Telemetry Finalization
    phase = Phase8_TelemetryFinalization
    run_phase(phase)

    // Phase 9 — Memory Sync (Conditional)
    if intent in {architecture, domain, refactor}:
        phase = Phase9_MemorySync
        run_phase(phase)

    // Phase 10 — Task Termination
    phase = Phase10_TaskTermination
    run_phase(phase)
```

Any exception or invariant breach → **IMMEDIATE HALT**

---

## Phase Execution Rules

Each phase execution MUST:

- Validate its preconditions
- Perform ONLY actions authorized for that phase
- Emit telemetry
- Produce exactly ONE explicit outcome

Phases MUST NOT:

- Skip validation
- Execute actions from other phases
- Modify lifecycle state outside their authority

---

## CHECKS Integration

The runtime driver MUST invoke CHECKS:

- Before model execution
- After model execution
- Before SAVE
- Before sandbox exit

CHECK outcomes are terminal or phase-directed only.

---

## Verification Integration

No output bypasses verification.

Only `PASS` is success.

---

## Sandbox Control

Sandbox is ENABLED by default.

Sandbox MUST be re-enabled on:

- Task boundary
- Failure
- Context change
- Intent change

Inconsistent sandbox state → **HALT**

---

## Telemetry Control

Telemetry is mandatory.

- Mode is selected deterministically
- Records are written per invocation
- Telemetry is sealed in Phase 8

Failure to record telemetry → **HALT**

---

## Error Handling Strategy

The runtime driver recognizes ONLY:

- HALT
- ASK_USER
- INTERVENTION_REQUIRED
- PASS

No implicit retries.  
No silent recovery.  
No background fixes.

---

## Final Rule

If runtime behavior deviates from policy:

→ **STOP**  
→ **HALT**  
→ **SURFACE ERROR EXPLICITLY**

Correct termination is compliant behavior.
