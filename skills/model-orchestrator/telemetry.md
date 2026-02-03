# Telemetry, Burnout & Cost Governance (Authoritative)

This file defines the **mandatory telemetry control plane**
for the Multi-Model AI Orchestrator.

Telemetry is **not logging**.
Telemetry is **enforcement infrastructure**.

If telemetry cannot be recorded deterministically,
**execution MUST NOT proceed**.

---

## Telemetry Philosophy

- Telemetry outranks convenience
- Telemetry outranks retries
- Telemetry outranks user impatience
- Telemetry is immutable once written

Correctness > throughput  
Governance > speed  

---

## Telemetry Is Mandatory

Telemetry MUST be initialized **before** any model invocation.

If telemetry initialization fails:

→ **HALT**
→ **DO NOT EXECUTE**
→ **DO NOT RETRY**

There are no exceptions.

---

## Telemetry Persistence (Required)

Telemetry MUST be persisted to durable storage.

Allowed backends:

- Local SQLite database (preferred)
- Append-only JSONL file

Forbidden:

- In-memory telemetry
- Volatile session-only storage
- Overwriting existing telemetry

Telemetry MUST survive:

- Process restarts
- Session restarts
- System crashes

Failure to persist → **HALT**

---

## Telemetry Scope

Telemetry is recorded **per invocation**, scoped by:

- Project
- Session
- Task
- Lifecycle phase
- Model invocation index

No invocation may occur without a telemetry record.

---

## Mandatory Telemetry Fields (Strict)

Each invocation MUST record **all** fields below.

| Field | Description |
|-----|-------------|
| `timestamp` | UTC timestamp |
| `project_id` | Project identifier |
| `session_id` | Stable session identifier |
| `task_id` | Stable task identifier |
| `lifecycle_phase` | Phase per `lifecycle.md` |
| `intent` | Locked intent |
| `model_logical_id` | Declared logical model |
| `model_resolved_id` | Actual resolved model |
| `model_tier` | Tier-A / B / C / D |
| `capability_profile` | Applied capability profile |
| `role` | router / assistant / reviewer / architect / executor |
| `call_index` | Nth call in task |
| `token_estimate` | Input + output estimate |
| `result` | success / retry / ask_user / intervention / halt |
| `failure_reason` | Required if result ≠ success |
| `escalation_attempted` | true / false |
| `notes` | Optional human-readable notes |

Missing ANY field → **HALT**

---

## Capability Binding (Hard Rule)

Telemetry enforcement is driven by the
**capability profile**, not model name.

Rules:

- Limits are read from `configuration.md`
- Resolved model inherits declared capability profile
- Fallback resolution MUST NOT upgrade capability

Capability overrun → **HALT**

---

## Burnout Enforcement (Per Task)

Burnout limits apply **per task**, not per session.

Enforced metrics:

- Maximum calls per task
- Maximum retries per task
- Maximum token budget per task

If ANY limit is exceeded:

→ **HALT**
→ Task is permanently terminated

No soft resets.
No decay.
No forgiveness.

---

## Retry Accounting

- Retry counter increments on ANY failure
- Retry counter does NOT reset after intervention
- Retry MUST use the same resolved model

Exceeding retry limit → **HALT**

---

## Escalation Governance

Escalation is **explicitly gated**.

Escalation requires ALL of:

- Explicit user approval
- Lower-tier failure
- Telemetry justification recorded

### Required Escalation Fields

- Previous model
- Failure reason
- Expected benefit
- Justification summary

Missing justification → escalation denied

Unauthorized escalation → **HALT**

---

## Telemetry-Driven Actions

Telemetry MAY trigger:

- Forced halt
- Denial of retry
- Denial of escalation
- Phase termination

Telemetry MUST NOT trigger:

- Silent retries
- Silent promotion
- Silent fallback
- Context mutation

---

## Telemetry Immutability

- Telemetry records are append-only
- Records MUST NOT be edited or deleted
- Models MUST NOT read or modify telemetry
- Humans MAY audit telemetry externally

Any mutation attempt → **HALT**

---

## Lifecycle Coupling

Every telemetry record MUST include lifecycle phase.

If a model acts outside its allowed phase:

→ Record violation
→ **HALT IMMEDIATELY**

No retry.
No intervention.

---

## Final Rule

If telemetry data is:

- Missing
- Incomplete
- Inconsistent
- Conflicting with lifecycle, intent, or configuration

→ **DO NOT EXECUTE**
→ **HALT EXPLICITLY**

Determinism > convenience  
Governance > creativity
