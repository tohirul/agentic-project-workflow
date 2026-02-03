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

## Authority Tier Definitions

Each model belongs to **exactly one authority tier**.
Intent does **not** override tier.

### Tier-A — Primary Authority

- Gemini 2.5 Pro (gemini-2.5-pro)
- Devstral2 (mistral-devstral2)
- GPT-5.1 Codex (gpt-5.1-codex)
- GPT-5.2 Codex (gpt-5.2-codex)

Capabilities:

- Architectural decisions
- Refactors (with gates)
- Code generation (with gates)
- Memory writes (SAVE)

Notes:

- GPT-5.1 Codex is review-focused; GPT-5.2 Codex is authorized for architecture.

### Tier-B — Secondary Authority

- Gemini 2 (gemini-2)
- Gemini 1.5 Pro (gemini-1.5-pro)
- Gemini 2 Flash (gemini-2-flash)
- Gemini 2.5 Flash (gemini-2.5-flash)
- Mistral Medium (mistral-medium)
- Mistral Small (mistral-small)
- GPT-4o (gpt-4o) [legacy / compatibility]

Capabilities:

- Debugging
- Planning
- Verified summaries
- Assisted decisions (no unilateral SAVE)

### Tier-C — Preview / Restricted

- Gemini 3 Pro Preview (gemini-3-pro-preview)
- Gemini 3 Flash Preview (gemini-3-flash-preview)

Capabilities:

- Read-only reasoning
- Option comparison
- Advisory output only

**No mutation. No SAVE. No refactor.**

### Tier-D — Free / Assistive (Non-Authoritative)

- KIMI K2.5 Free (kimi-k2.5-free)
- Minimax M2.1 Free (minimax-m2.1-free)
- Big Pickle (big-pickle)
- Qwen-2.x (qwen-2.x)
- DeepSeek-Coder (deepseek-coder-community)
- GLM-4.7 Free (glm-4.7-free)

Capabilities:

- Pre-work
- Drafting
- Extraction
- Idea surfacing

All Tier-D output is **non-final** and **must be verified**.

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
| `code_generation` | Write new code                      |
| `code_review`     | Review diffs or files               |
| `debugging`       | Root cause analysis                 |
| `refactor`        | Structural code changes             |
| `architecture`    | System / domain design decisions    |
| `domain`          | Business or domain modeling         |
| `research`        | Comparative or multi-source inquiry |
| `planning`        | Ordered execution strategy          |
| `chat`            | Low-risk, non-project-bound only    |

If intent is ambiguous or mixed → **HALT and ask user**

Intent is **immutable** for the entire execution.

---

## Phase 2 — Context Assembly (Mandatory)

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

## Phase 3 — Model Selection (Deterministic)

Model routing MUST:

- Follow `selection.md` exactly
- Respect authority tier restrictions

## Phase 4 — Delegation Contract

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

## Phase 5 — Verification & Enforcement (Mandatory)

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

## Phase 6 — Burnout & Cost Governance

The orchestrator enforces:

- Rate limits per tier
- No chained reasoning models
- No recursive escalation
- Downgrade on repeated failure
- Summarization before escalation

Cost efficiency is enforced **by policy**, not discretion.

---

## Cross-Model Collaboration (Strict)

“Partnering” between GPT-5 Codex (gpt-5.1-codex, gpt-5.2-codex) and Gemini models (gemini-2, gemini-2.5-pro) is permitted **only** as:

- An explicit user-requested handoff to a **new task**
- After verification and lifecycle reset

Cross-model chaining **within the same task** remains forbidden.

### Example (Allowed Handoff)

1. Task A (research): GPT-5.2 Codex (gpt-5.2-codex) produces verified research summary.
2. Task A ends after verification.
3. Task B (architecture): user explicitly requests Gemini 2.5 Pro (gemini-2.5-pro) using Task A’s verified summary.

This is a **new task boundary**, not same-task chaining.

### Example (Not Allowed)

1. Task A (research): GPT-5.2 Codex (gpt-5.2-codex) produces a summary.
2. Without ending Task A or resetting lifecycle, the system calls Gemini 2 (gemini-2) for follow-up.

This is **same-task chaining** and is forbidden.

---

## Image Scan / Content Extraction (Strict)

All image-based scanning and content extraction MUST use:

- Gemini 3 Flash Preview (gemini-3-flash-preview)
- Gemini 3 Pro Preview (gemini-3-pro-preview)

Rules:

- Read-only output only
- No file writes, code generation, or refactors
- Output must be used for summarize/classify only

Fallback:

- If Gemini 3 Preview is unavailable → use GPT-5.1 Codex (gpt-5.1-codex) in read-only mode

---

## Multi-Model Workflow (Task-Bound, Allowed)

This workflow is **allowed only with explicit task boundaries** at each handoff.

1. **Task A — Planning (Tier-A + Tier-B)**
   - GPT-5.2 Codex (gpt-5.2-codex) produces system + solution design guidance.
   - Codestral (codestral-latest, free-tier constrained) prepares a structured plan using GPT-5.2 guidance.
   - Codestral use is limited to evaluation / non-production planning.
   - Task ends after verification.

1a. **If Codestral fails (Task A fails)**

- Start a NEW Task A with **Gemini 2.5 Pro (gemini-2.5-pro) + GPT-5.2 Codex (gpt-5.2-codex)** co-planning.
- This is a new task boundary and remains compliant with no same-task chaining.

2. **Task B — Implementation (Tier-A)**
   - Devstral2 (mistral-devstral2) analyzes the approved plan and implements the solution.
   - Task ends after review.

3. **Task C — Review (Tier-A)**
   - GPT-5.2 Codex (gpt-5.2-codex) reviews the solution.
   - Findings are sent to Gemini 2.5 Pro (gemini-2.5-pro) for feature lock confirmation.
   - Task ends after verification.

4. **Task D — Feature Lock (Tier-A)**
   - Gemini 2.5 Pro (gemini-2.5-pro) confirms feature scope/updates.
   - If adjustments are required, a **new Task A** is started.

---

## Phase 7 — Memory Synchronization (SAVE / RESTORE)

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
