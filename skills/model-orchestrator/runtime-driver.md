# Runtime Driver & Control Loop (Authoritative)

This document defines **how the Multi-Model AI Orchestrator executes**
the policies declared in the control-plane documents.

This file does **not introduce new rules**.
It operationalizes existing ones.

If this file conflicts with any policy document,
**policy documents win**.

---

## Purpose of the Runtime Driver

The runtime driver is responsible for:

- Executing the lifecycle state machine
- Enforcing CHECKS and verification gates
- Initializing and sealing telemetry
- Managing sandbox transitions
- Routing execution deterministically
- Halting safely and explicitly

The driver **does not reason**.
The driver **does not generate content**.
The driver **does not override policy**.

---

## Execution Model

The runtime driver operates as a **single-task, single-loop controller**.

There is **no background execution**.
There is **no parallel lifecycle progression**.
There is **no speculative execution**.

Each task is processed to completion or termination
before another task begins.

---

## High-Level Control Loop

Pseudocode representation:

```
initialize_driver()

while task_requested:
    phase = Phase0_StateValidation
    run_phase(phase)

    phase = Phase1_IntentClassification
    run_phase(phase)

    phase = Phase2_ContextAssembly
    run_phase(phase)

    if intent == generate_context:
        phase = Phase2a_ContextBootstrap
        run_phase(phase)

    phase = Phase3_ModelSelection
    run_phase(phase)

    phase = Phase4_Delegation
    run_phase(phase)

    phase = Phase5_Execution
    run_phase(phase)

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

    phase = Phase8_TelemetryFinalization
    run_phase(phase)

    if intent in {architecture, domain, refactor}:
        phase = Phase9_MemorySync
        run_phase(phase)

    phase = Phase10_TaskTermination
    run_phase(phase)
```

Any exception or policy violation → immediate HALT.

---

## Phase Execution Rules

Each phase execution MUST:

- Validate preconditions
- Perform only phase-authorized actions
- Emit telemetry
- Produce a single, explicit outcome

Phases MUST NOT:

- Skip validation
- Modify other phase state
- Execute actions belonging to other phases

---

## CHECKS Integration

The driver MUST invoke checks:

- Before model execution
- After model execution
- Before SAVE
- Before exiting sandbox

CHECK failures are mapped to:

- HALT
- ASK_USER
- INTERVENTION_REQUIRED

As defined in `CHECKS.md`.

---

## Verification Integration

The driver MUST:

- Pass all outputs through `verification.md`
- Accept ONLY `PASS` as success
- Handle `INTERVENTION_REQUIRED` via Phase 7
- Reject and terminate on HALT

No output bypasses verification.

---

## Sandbox Control

The driver controls sandbox state transitions.

Rules:

- Sandbox enabled by default
- Sandbox disabled ONLY when exit conditions are met
- Sandbox re-enabled on:
  - Task boundary
  - Failure
  - Context change
  - Intent change

The driver MUST refuse execution
if sandbox state is inconsistent.

---

## Telemetry Control

The driver MUST:

- Initialize telemetry before Phase 0
- Record telemetry for every invocation
- Enforce capability profiles
- Seal telemetry in Phase 8

If telemetry cannot be written:

→ HALT immediately

---

## Error Handling Strategy

The driver recognizes only these terminal outcomes:

- HALT
- ASK_USER
- INTERVENTION_REQUIRED
- PASS

No implicit retries.
No silent recovery.
No background fixes.

---

## Concurrency & Parallelism

The runtime driver explicitly forbids:

- Parallel task execution
- Concurrent lifecycle phases
- Multi-model same-task chaining
- Background retries

This is a **deliberate safety constraint**.

---

## Restart & Recovery

On process restart:

- Telemetry is reloaded
- Incomplete tasks are marked TERMINATED
- No task resumes automatically
- User must explicitly restart work

This prevents partial-state corruption.

---

## Implementation Notes (Non-Normative)

The driver MAY be implemented as:

- Node.js CLI
- Shell-based orchestrator
- VS Code extension backend

Implementation choice does NOT affect policy.

---

## Final Rule

If driver behavior deviates from policy:

→ **STOP**
→ **HALT**
→ **SURFACE ERROR EXPLICITLY**

Correct termination is compliant behavior.
