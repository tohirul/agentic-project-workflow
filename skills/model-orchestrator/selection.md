# Model Selection & Routing Matrix (Authoritative)

This file defines **deterministic, enforceable model routing**.

It is the **single source of truth** for:

- Model eligibility
- Intent-to-model mapping
- Authority boundaries
- Failure behavior

No inference.  
No self-selection.  
No overrides.

If conflict exists, **this file always wins**.

---

## Available Models

### Gemini (Google)

- Gemini 1.5 Pro
- Gemini 2
- Gemini 2 Flash
- Gemini 2.5 Pro
- Gemini 2.5 Flash
- Gemini 3 Flash Preview
- Gemini 3 Pro Preview

### Mistral

- Devstral2
- Mistral Medium
- Mistral Small

### OpenCode / Free-Tier Extensions (Read-Only / Fallback)

- Big Pickle (Free)
- GLM-4.7 Free
- Kimi K2.5 Free
- Minimax M2.1 Free

> Free-tier models are **strictly constrained**:
>
> - Read-only
> - No code writes
> - No refactors
> - No architecture decisions
> - No SAVE / RESTORE
> - No escalation

---

## Canonical Intent Vocabulary

All prompts MUST be normalized to **exactly one** intent:

- `classify`
- `summarize`
- `code_review`
- `refactor`
- `architecture`
- `research`
- `planning`
- `debugging`
- `chat`

If intent cannot be normalized → **HARD FAIL**

---

## Intent → Model Routing (Strict)

### intent: classify

→ Gemini 2 Flash

---

### intent: summarize

→ Gemini 2 Flash  
→ Fallback: Mistral Small  
→ Fallback (free-tier): GLM-4.7 Free

Fallback allowed ONLY if:

- Token limit exceeded
- Latency budget exceeded

---

### intent: code_review

→ Devstral2  
→ Fallback: Mistral Medium

Scope:

- Diff-only
- Read-only
- No architectural changes

---

### intent: refactor

→ Devstral2 **ONLY**

Hard Gates (ALL REQUIRED):

- Canary execution enabled
- Diff-scoped changes
- Explicit file list
- SAVE forbidden until verification passes

❌ Gemini models FORBIDDEN  
❌ Free-tier models FORBIDDEN

---

### intent: architecture

→ Gemini 2.5 Pro  
→ Gemini 3 Pro Preview (**OPT-IN ONLY**)

Hard Gates:

- ADR-compatible output REQUIRED
- RESTORE REQUIRED before execution
- SAVE allowed ONLY via ADR workflow

---

### intent: research

→ Gemini 2  
→ Fallback: Gemini 1.5 Pro  
→ Fallback (free-tier): Kimi K2.5 Free

Scope:

- Read-only
- No decisions
- No code
- No context mutation

---

### intent: planning

→ Gemini 1.5 Pro  
→ Fallback: Gemini 2

Rules:

- Structured steps
- No execution
- No SAVE

---

### intent: debugging

→ Gemini 2  
→ Escalation: Gemini 3 Pro Preview (**explicit user opt-in required**)

Rules:

- No refactors
- No architectural redesign
- Diagnosis only

---

### intent: chat

→ Gemini 1.5 Pro  
→ Fallback: Mistral Small  
→ Fallback (free-tier): Big Pickle

Low-risk, non-project-bound only.

---

## Preview Model Restrictions (Non-Negotiable)

Applies to:

- Gemini 3 Flash Preview
- Gemini 3 Pro Preview

Preview models MAY:

- Reason
- Compare
- Propose options

Preview models MAY NOT:

- Write files
- Modify code
- Perform refactors
- Perform migrations
- Generate tasks
- Trigger SAVE / RESTORE
- Mutate context

Violation → **HARD FAILURE (NO RETRY)**

---

## Free-Tier Model Restrictions (Absolute)

Free-tier models MAY:

- Summarize
- Classify
- Explain concepts

Free-tier models MAY NOT:

- Generate production code
- Review diffs
- Make architectural decisions
- Modify context
- Participate in multi-agent workflows

Violation → **HARD FAILURE**

---

## Forbidden Routes (Global)

The following routes are ALWAYS invalid:

- Flash → refactor ❌
- Flash → architecture ❌
- Preview → implementation ❌
- Preview → SAVE / RESTORE ❌
- Free-tier → code_review ❌
- Free-tier → refactor ❌
- Any model → cross-project context ❌
- Any model → bypass `ai.project.json` ❌
- Any model → self-escalation ❌

---

## Failure & Downgrade Rules

- No automatic promotion to stronger models
- Maximum ONE retry per task
- Retry MUST use the SAME model
- Repeated failure → HALT
- Model unavailable → HALT (no silent substitution)

---

## Final Rule

Model routing is **deterministic**, **auditable**, and **enforceable**.

If a model is not explicitly allowed here,  
it is **not allowed anywhere**.
