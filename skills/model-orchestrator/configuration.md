# Multi-Model Runtime Configuration (Authoritative)

This file defines **runtime-enforceable execution rules**
for the Multi-Model AI Orchestrator.

⚠️ This file does NOT decide model routing.  
Routing authority lives **exclusively** in `selection.md`.

This file governs:

- Execution roles
- Context injection
- Burnout & cost control
- Memory safety
- Verification & failure handling

No inference.  
No silent substitution.  
No dynamic overrides.

---

## Model Inventory (Resolved & Supported)

### Gemini Family (Google)

- gemini-1.5-pro
- gemini-2
- gemini-2-flash
- gemini-2.5-pro
- gemini-2.5-flash
- gemini-3-pro-preview
- gemini-3-flash-preview

---

### OpenAI

- gpt-5.1-codex
- gpt-5.2-codex

---

### Mistral

- mistral-devstral2
- mistral-medium
- mistral-small
- codestral-latest (free-tier constrained)

---

### Free / Assistive Models (Tier-D)

Free-tier models are **assistive only**.

- glm-4.7-free
- kimi-k2.5-free
- minimax-m2.1-free
- big-pickle
- qwen-2.x
- deepseek-coder-community

Restrictions (NON-NEGOTIABLE):

- Read-only
- No code generation beyond snippets
- No diff review
- No refactor
- No architecture
- No SAVE / RESTORE
- No multi-agent participation

Violation → **hard failure**

---

### Legacy / Compatibility Models (Restricted)

- gpt-4o
- claude-sonnet (if exposed by OpenCode)

Rules:

- Tier-B authority at most
- NEVER architectural authority
- NEVER memory authority
- NEVER routing authority

---

## Execution Roles (Strict & Exclusive)

Each model invocation is bound to **exactly ONE role**.

| Role        | Authority Scope                               |
| ----------- | --------------------------------------------- |
| `router`    | intent normalization only                     |
| `assistant` | summarize, explain, draft (non-authoritative) |
| `reviewer`  | diff-only inspection, read-only               |
| `architect` | ADR-compatible reasoning only                 |
| `executor`  | refactor / debugging under hard gates         |

Rules:

- Roles are assigned by orchestrator
- Models MAY NOT change roles
- Role mismatch → **hard failure**

---

## Lifecycle Enforcement

Model invocation is permitted ONLY if the current lifecycle phase
explicitly allows a model for that phase (see `lifecycle.md`).

If a model is selected but the lifecycle phase disallows execution:
→ HALT
→ Do NOT retry
→ Do NOT downgrade

---

## Cost & Burnout Governance

### Global Invariants

- One reasoning model per task
- Maximum ONE retry per task
- No recursive calls
- No background retries
- No chained Pro / Preview models

---

### Gemini 3 (Preview Tier)

Applies to:

- gemini-3-pro-preview
- gemini-3-flash-preview

Limits:

- Max **2 calls per task**
- Advisory output ONLY
- No code writes
- No refactors
- No migrations
- No SAVE / RESTORE
- No context mutation

Violation → **session termination**

---

### Devstral2 (Precision Tier)

Primary use:

- code_review
- refactor
- code_generation
- debugging

Hard Gates:

- Diff-scoped input REQUIRED
- Canary execution REQUIRED for refactor
- Explicit file list REQUIRED
- SAVE forbidden until verification passes

---

### Flash & Free Models

Allowed intents only:

- classify
- summarize

All outputs are **non-authoritative**
until validated by orchestrator.

---

## Context Injection Contract (Mandatory)

All model invocations MUST receive structured context blocks only.
No raw conversation history is permitted.

Before any model invocation, the orchestrator MUST inject
the following governance context block.

This block is authoritative, immutable, and non-negotiable.

```yaml
context_block:
  type: governance
  source: CONTRACT.md
  authority: absolute
  mutable: false
```

### Required Blocks

- `intent`
- `task_scope`
- `constraints`
- `ai.project.json` (filtered slice)
- `plugin_contract` (if applicable)

### Forbidden Inputs

- Raw chat history
- Cross-project memory
- Unbounded file trees
- Hidden agent outputs
- Implicit defaults

Violation → **halt**

---

## Memory & Persistence Policy

### SAVE Rules (Strict)

SAVE is permitted ONLY when ALL are true:

- intent = `architecture`
- ADR generated
- Output validated
- Explicit approval gate passed

Otherwise → **SAVE FORBIDDEN**

---

### RESTORE Rules

RESTORE is REQUIRED when:

- intent = architecture
- intent = refactor
- intent = domain

Failure to RESTORE → **halt**

---

## Verification Contract (Mandatory)

Before returning output, orchestrator MUST verify:

1. Intent alignment
2. Model authorization (tier + role)
3. Context completeness
4. Constraint compliance
5. No hallucinated APIs
6. No scope creep
7. No forbidden operations

### Failure Handling

| Failure Type    | Action                       |
| --------------- | ---------------------------- |
| Hallucination   | Retry once, stricter context |
| Scope creep     | Reject output                |
| Wrong model     | Halt                         |
| Missing context | Ask user                     |
| Policy breach   | Terminate session            |

No silent retries.

---

## Promotion & Downgrade Rules

- Promotion requires **explicit user intent**
- Downgrade allowed after failure
- No self-escalation
- No background fallback

---

## Governance Invariants (Absolute)

- `selection.md` overrides ALL configs
- No model decides routing
- No model mutates constraints
- No implicit memory writes
- No cross-project context access
- No preview or free-tier escalation
- No same-task multi-model chaining
- GPT-5 Codex code generation MUST follow selection hard gates

---

## Final Statement

This configuration exists to ensure that
**once a model is selected**, it:

- stays in scope
- respects context
- preserves memory integrity
- avoids burnout
- never exceeds authority

Violations are **fatal by design**.

```

```
