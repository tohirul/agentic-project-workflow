# Telemetry, Burnout & Cost Governance (Authoritative)

This file defines the **mandatory telemetry control plane**
for the Multi-Model AI Orchestrator.

Telemetry is **not logging**.
Telemetry is **enforcement infrastructure**.

Telemetry failure is a **policy decision point**, not an implementation detail.

If telemetry cannot be recorded deterministically,
**execution MUST NOT proceed**.

---

## Telemetry Philosophy

- Telemetry outranks convenience
- Telemetry outranks retries
- Telemetry outranks user impatience
- Telemetry is immutable once written
- Telemetry enforces governance, not observability

Correctness > throughput  
Governance > speed

---

## Telemetry Is Mandatory (Absolute)

Telemetry MUST be initialized **before** any model invocation.

If telemetry initialization fails entirely:

→ **HALT**  
→ **DO NOT EXECUTE**  
→ **DO NOT RETRY**

There are no exceptions.

---

## Telemetry Recording vs Telemetry Transport (Critical Distinction)

Telemetry enforcement depends on **recording**, not on **immediate upstream delivery**.

Invariant:

> **Telemetry records MUST exist, be complete, and be immutable  
> before execution may proceed.**

Remote availability is a **mode-dependent constraint**, not a universal requirement.

---

## Telemetry Operating Modes (Authoritative)

Telemetry operates in **exactly ONE mode per task**.

The mode MUST be determined at **driver initialization**
and recorded in telemetry metadata.

Changing mode mid-task is **forbidden**.

---

### Mode A — ENFORCED (Default)

Mode A is the **default and safest mode**.

#### Mode A MUST be used when ANY of the following are true:

- Intent ∈ {architecture, domain, refactor, code_generation, code_review}
- Authority tier ≥ Tier-B
- SAVE / RESTORE is permitted or required
- Escalation is possible
- Execution environment = CI or production

#### Rules (ENFORCED):

- Telemetry MUST be written to durable storage
- Remote persistence MUST be reachable
- Failure to persist or sync → **HALT**
- No buffering beyond local durability
- No execution without confirmed persistence

Mode A is **fail-closed** by design.

---

### Mode B — DEGRADED (Explicit, Restricted)

Mode B exists to preserve **developer experience and resilience**
without weakening governance.

Mode B is **not a fallback**.
It is an **explicitly constrained operating mode**.

#### Mode B MAY be used ONLY when ALL are true:

- Intent ∈ {chat, summarize, classify}
- Authority tier = Tier-D
- No SAVE / RESTORE permitted
- No escalation permitted
- Execution environment = local or dev

#### Rules (DEGRADED):

- Telemetry MUST be recorded locally
- Append-only local storage REQUIRED (SQLite or JSONL)
- Local write failure → **HALT**
- Remote sync MAY be deferred
- Remote unavailability alone MUST NOT halt execution

Mode B still **records everything**.
It merely relaxes **delivery timing**, not **governance**.

---

## Telemetry Mode Guardrail (Absolute)

DEGRADED mode MUST NOT allow:

- Tier-A execution
- Tier-B execution
- Any mutative intent
- SAVE / RESTORE
- Escalation
- Architecture or domain reasoning
- Cross-task or multi-agent workflows

Attempting to enter DEGRADED mode outside permitted scope:

→ **HALT IMMEDIATELY**

---

## Telemetry Persistence (Required)

Telemetry MUST be persisted to durable storage.

Allowed local backends:

- Local SQLite database (preferred)
- Append-only JSONL file

Forbidden:

- In-memory-only telemetry
- Volatile session storage
- Overwriting existing records
- Editable records

Telemetry MUST survive:

- Process restarts
- Session restarts
- System crashes

Failure to persist locally → **HALT**

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

| Field                  | Description                                          |
| ---------------------- | ---------------------------------------------------- |
| `timestamp`            | UTC timestamp                                        |
| `project_id`           | Project identifier                                   |
| `session_id`           | Stable session identifier                            |
| `task_id`              | Stable task identifier                               |
| `telemetry_mode`       | ENFORCED / DEGRADED                                  |
| `lifecycle_phase`      | Phase per `lifecycle.md`                             |
| `intent`               | Locked intent                                        |
| `model_logical_id`     | Declared logical model                               |
| `model_resolved_id`    | Actual resolved model                                |
| `model_tier`           | Tier-A / B / C / D                                   |
| `capability_profile`   | Applied capability profile                           |
| `role`                 | router / assistant / reviewer / architect / executor |
| `call_index`           | Nth call in task                                     |
| `token_estimate`       | Input + output estimate                              |
| `result`               | success / retry / ask_user / intervention / halt     |
| `failure_reason`       | Required if result ≠ success                         |
| `escalation_attempted` | true / false                                         |
| `notes`                | Optional human-readable notes                        |

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

No resets.  
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
- Conflicting with lifecycle, intent, configuration, or mode

→ **DO NOT EXECUTE**  
→ **HALT EXPLICITLY**

Determinism > convenience  
Governance > creativity
