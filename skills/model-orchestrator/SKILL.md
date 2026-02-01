---
name: orchestrating-multi-model-ai
description: Deterministic orchestration of multiple AI models based on intent, authority tier, context guarantees, lifecycle phase, and cost governance. Enforces routing, verification, memory safety, and burnout prevention across long-running workflows.
---

# Multi-Model AI Orchestrator (Authoritative)

This skill defines the **control plane** for environments where **multiple AI models coexist**.

The orchestrator does **not** reason.
The orchestrator **governs reasoning**.

Its sole responsibility is to decide:

- **Which model may act**
- **In what role**
- **With which context**
- **Under which constraints**
- **At which lifecycle phase**

No model, agent, or plugin may bypass this orchestration layer.

---

## Governing Principles (Absolute)

The following principles are non-negotiable:

- **Context is authoritative, not the model**
- **Routing is deterministic, never heuristic**
- **Authority is tier-based, not intent-based**
- **Free models are assistive, never final**
- **Preview models are advisory, never mutative**
- **No model may escalate itself**
- **No output is accepted without verification**

Violation of any principle → **hard failure**

---

## When This Skill Applies

This skill MUST be activated when **any** of the following are true:

- More than one AI model is available
- Cost, latency, or burnout must be controlled
- Context must persist across agents or sessions
- SAVE / RESTORE memory is involved
- Architectural or domain correctness matters
- The task spans multiple steps or lifecycle phases

### This skill MUST NOT be used for

- Single-turn casual chat
- Trivial, isolated code snippets
- Non-project questions
- Freeform brainstorming without validation

---

## Lifecycle Binding

All execution under this skill MUST follow the lifecycle defined in:

→ `lifecycle.md`

No agent, model, or plugin may:

- Skip phases
- Reorder phases
- Execute outside the current phase

Lifecycle violations are treated as **policy violations** and result in immediate halt.

---

## Execution Lifecycle (Strict, Ordered)

Every execution MUST follow **all phases below**.
No phase may be skipped, merged, or reordered.

---

## Phase 1 — Intent Classification (Single-Label)

The prompt MUST be classified into **exactly ONE intent** using
`intent-classifier.md`.

Valid intents only:

| Intent            | Description                         |
| ----------------- | ----------------------------------- |
| `classify`        | Routing / detection / tagging       |
| `summarize`       | Condense existing material          |
| `extract`         | Structured extraction               |
| `draft`           | Non-authoritative generation        |
| `code_generation` | Write new code                      |
| `code_review`     | Review diffs or files               |
| `debugging`       | Root cause analysis                 |
| `refactor`        | Structural code changes             |
| `architecture`    | System / domain design decisions    |
| `domain`          | Business or domain modeling         |
| `research`        | Comparative or multi-source inquiry |
| `planning`        | Ordered execution strategy          |

If intent is ambiguous or mixed → **HALT and ask user**

Intent is **immutable** for the entire execution.

---

## Phase 2 — Authority Tier Resolution

Each model belongs to **exactly one authority tier**.
Intent does **not** override tier.

### Tier-A — Primary Authority

- Gemini 2.5 Pro
- Devstral2

Capabilities:

- Architectural decisions
- Refactors (with gates)
- Memory writes (SAVE)

---

### Tier-B — Secondary Authority

- Gemini 2
- Gemini 1.5 Pro
- Mistral Medium
- GLM-4.7 (Fee)

Capabilities:

- Debugging
- Planning
- Verified summaries
- Assisted decisions (no unilateral SAVE)

---

### Tier-C — Preview / Restricted

- Gemini 3 Pro Preview
- Gemini 3 Flash Preview

Capabilities:

- Read-only reasoning
- Option comparison
- Advisory output only

**No mutation. No SAVE. No refactor.**

---

### Tier-D — Free / Assistive (Non-Authoritative)

- KIMI K2.5 Free
- Minimax M2.1 Free
- Big Pickle
- Qwen-2.x (Free)
- DeepSeek-Coder (Community)

Capabilities:

- Pre-work
- Drafting
- Extraction
- Idea surfacing

All Tier-D output is **non-final** and **must be verified**.

---

## Phase 3 — Model Selection (Deterministic)

Model routing MUST:

- Follow `selection.md` exactly
- Respect authority tier restrictions
- Respect preview and free-tier limits
- Never fallback implicitly

If no valid model exists for intent + tier → **HALT**

---

## Phase 4 — Context Assembly (Mandatory)

Before execution, the orchestrator MUST assemble a **frozen context snapshot**
per `context-contract.md`.

Required inputs (priority order):

1. RESTORE memory (if applicable)
2. `ai.project.json`
3. Task scope (intent, boundaries, permissions)
4. User prompt

### Hard Stop Conditions

Execution MUST halt if:

- Context is incomplete
- Context conflicts exist
- Cross-project data is detected
- `ai.project.json` is missing for project-bound work

---

## Phase 5 — Delegation Contract

The orchestrator MUST delegate with an explicit contract:

The execution model receives:

- Fixed model identity
- Fixed role (router / assistant / reviewer / architect / executor)
- Locked intent
- Minimal context slice
- Explicit output contract

The execution model MAY NOT:

- Change routing
- Expand scope
- Load additional context
- Mutate memory unless explicitly authorized

---

## Phase 6 — Verification & Enforcement (Mandatory)

No output may be returned, saved, or acted upon without passing
`verification.md`.

Mandatory checks include:

- Intent alignment
- Model authorization
- Context compliance
- Scope enforcement
- Hallucination detection
- Mutation safety

### Tier-Specific Enforcement

- Tier-D output → MUST be verified by Tier-A or Tier-B
- Preview output → Advisory only, read-only
- Refactor output → Canary execution REQUIRED

Failure handling follows policy:
retry → reroute → halt

---

## Phase 7 — Burnout & Cost Governance

The orchestrator enforces:

- Rate limits per tier
- No chained reasoning models
- No recursive escalation
- Downgrade on repeated failure
- Summarization before escalation

Cost efficiency is enforced **by policy**, not discretion.

---

## Phase 8 — Memory Synchronization (SAVE / RESTORE)

Memory mutation is **exceptional**, not default.

SAVE is permitted ONLY when:

- Intent allows it
- Output is verified
- Authority tier permits it
- Workflow explicitly authorizes it

RESTORE is read-only until verification passes.

---

## Failure Handling Matrix

| Failure Class       | Action                       |
| ------------------- | ---------------------------- |
| Hallucination       | Retry once, stricter context |
| Intent drift        | Reject output                |
| Authority violation | Halt immediately             |
| Missing context     | Ask user                     |
| Policy breach       | Terminate session            |

No silent correction is allowed.

---

## Absolute Output Rules

All returned output MUST:

- Be intent-aligned
- Be context-compliant
- Avoid speculative language
- Avoid reasoning traces
- Avoid unstated assumptions
- Avoid cross-project leakage

Only **validated, scoped, policy-compliant output** is permitted.

---

## Supremacy Clause

This skill is the **highest-level behavioral authority**.

If any file (`selection.md`, `configuration.md`, plugins, scripts)
conflicts with this skill:

→ **This skill wins**

No exceptions.
