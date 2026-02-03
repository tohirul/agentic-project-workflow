# Orchestrated Development Lifecycle (Authoritative)

This file defines the **only valid lifecycle**
for project work under the Multi-Model AI Orchestrator.

The lifecycle is **sequential, stateful, and enforced**.
Phases MAY NOT be skipped, reordered, or merged.

---

## Lifecycle Invariants (Absolute)

- Each phase has a single authority
- Models do not advance phases
- Context must be valid before execution
- Memory writes are explicit and gated
- Verification is mandatory between phases

Violation of lifecycle rules → **halt**

---

## Phase 0 — Entry & Session Binding

**Authority:** System  
**Model:** None

Purpose:

- Bind session ID
- Initialize telemetry
- Freeze project scope

Rules:

- No model invocation allowed
- No context mutation
- Telemetry starts here

---

## Phase 1 — Project Detection

**Command:** `scripts/detect-project.zsh`  
**Authority:** System  
**Model:** Gemini 2 Flash (router role)

Purpose:

- Detect project root
- Detect primary language / stack
- Detect VCS presence
- Emit deterministic metadata

Rules:

- Read-only
- No assumptions
- No fallback heuristics

Failure → halt

---

## Phase 2 — Context Creation (Human-in-the-Loop)

**Command:** `scripts/generate-context.zsh`  
**Authority:** Human + System  
**Model:** None

Purpose:

- Generate `ai.project.json` template
- Human fills required fields

Rules:

- AI MAY NOT infer missing fields
- AI MAY NOT auto-complete intent
- Incomplete file → validation failure

This phase MUST complete before any reasoning model is used.

---

## Phase 3 — Context Validation

**Command:** `scripts/validate-context.zsh`  
**Authority:** System  
**Model:** None

Purpose:

- Validate schema
- Validate constraints
- Validate forbidden patterns
- Validate lifecycle readiness

Rules:

- No model invocation
- No auto-fixes
- No silent defaults

Failure → return to Phase 2

---

## Phase 4 — Context Restoration (If Applicable)

**Authority:** System  
**Model:** None

Triggered when:

- intent = architecture
- intent = refactor
- intent = domain

Purpose:

- RESTORE prior memory
- Rehydrate ADRs and decisions

Rules:

- RESTORE precedes all reasoning
- Missing memory → ask or halt
- No SAVE allowed here

---

## Phase 5 — Architecture / Domain Intent

**Authority:** Architect Agent  
**Model:** Gemini 2.5 Pro  
**Role:** architect (read-only)

Purpose:

- Produce architectural decisions
- Generate ADR-compatible output

Hard Gates:

- Output MUST be ADR-structured
- No code generation
- No implementation detail
- SAVE permitted ONLY via ADR workflow

Failure → reject output

---

## Phase 6 — Planning (Optional, Explicit)

**Authority:** Assistant Agent  
**Model:** Gemini Pro or Gemini 2

Purpose:

- Break approved architecture into steps
- Define execution boundaries

Rules:

- No code writes
- No refactors
- No SAVE
- Must reference approved ADR

Skipped unless explicitly requested.

---

## Phase 7 — Implementation / Refactor / Code Generation

**Authority:** Executor Agent  
**Model:** Devstral2  
**Role:** executor

Purpose:

- Apply scoped changes
- Implement approved plan

Hard Gates:

- Canary execution REQUIRED
- Diff-scoped only
- RESTORE already completed
- SAVE forbidden until review passes

Violation → hard halt

---

## Phase 8 — Review & Verification

**Authority:** Reviewer Agent  
**Model:** Devstral2  
**Role:** reviewer

Purpose:

- Review diffs only
- Enforce architectural integrity
- Enforce constraints

Rules:

- Read-only
- No new changes
- No refactor suggestions outside scope

Failure → return to Phase 7

---

## Phase 9 — Verification Gate (Mandatory)

**Authority:** System  
**Model:** None

Purpose:

- Run `verification.md`
- Validate:
  - intent alignment
  - model authority
  - context compliance
  - scope integrity
  - hallucination absence

Failure → reject output or halt

---

## Phase 10 — Memory Sync (SAVE)

**Authority:** System  
**Model:** None

Triggered ONLY when:

- Verification passed
- Output approved
- Explicit SAVE allowed

Purpose:

- Persist ADRs
- Persist architectural decisions
- Persist validated milestones

Rules:

- No implicit SAVE
- No partial SAVE
- No overwrite without versioning

---

## Phase 11 — Exit

**Authority:** System

Purpose:

- Close task
- Finalize telemetry
- Release model locks

---

## Lifecycle Enforcement Summary

| Phase | Model Allowed | Memory  | Writes     |
| ----- | ------------- | ------- | ---------- |
| 1–3   | Flash / None  | ❌      | ❌         |
| 4     | None          | RESTORE | ❌         |
| 5     | Gemini 2.5    | ❌      | ❌         |
| 7     | Devstral2     | ❌      | ✔ (canary) |
| 8     | Devstral2     | ❌      | ❌         |
| 10    | None          | SAVE    | ✔          |

---

## Final Rule

If lifecycle state is ambiguous:

→ **STOP**
→ **ASK**
→ **DO NOT PROCEED**
