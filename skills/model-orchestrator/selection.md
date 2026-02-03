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

- Gemini 1.5 Pro (gemini-1.5-pro)
- Gemini 2 (gemini-2)
- Gemini 2 Flash (gemini-2-flash)
- Gemini 2.5 Pro (gemini-2.5-pro)
- Gemini 2.5 Flash (gemini-2.5-flash)
- Gemini 3 Flash Preview (gemini-3-flash-preview)
- Gemini 3 Pro Preview (gemini-3-pro-preview)

### OpenAI

- GPT-5.1 Codex (gpt-5.1-codex)
- GPT-5.2 Codex (gpt-5.2-codex)
- GPT-4o (gpt-4o) [legacy / compatibility]

Notes:

- GPT-5.1 Codex is review-focused; GPT-5.2 Codex is authorized for architecture.

### Mistral

- Devstral2 (mistral-devstral2)
- Mistral Medium (mistral-medium)
- Mistral Small (mistral-small)
- Codestral (codestral-latest, free-tier: planning guidance only)

### OpenCode / Free-Tier Extensions (Read-Only / Fallback)

- Big Pickle (big-pickle, free-tier)
- GLM-4.7 Free (glm-4.7-free)
- Kimi K2.5 Free (kimi-k2.5-free)
- Minimax M2.1 Free (minimax-m2.1-free)
- Qwen-2.x (qwen-2.x, free-tier)
- DeepSeek-Coder (deepseek-coder-community, free-tier)

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
- `code_generation`
- `refactor`
- `architecture`
- `domain`
- `research`
- `planning`
- `debugging`
- `chat`

If intent cannot be normalized → **HARD FAIL**

---

## Intent → Model Routing (Strict)

### intent: classify

→ Gemini 2 Flash (gemini-2-flash)

---

### intent: summarize

→ Gemini 2 Flash (gemini-2-flash)  
→ Fallback: Mistral Small (mistral-small)  
→ Fallback (free-tier): GLM-4.7 Free (glm-4.7-free)

Fallback allowed ONLY if:

- Token limit exceeded
- Latency budget exceeded

---

### intent: code_review

→ Devstral2 (mistral-devstral2)  
→ GPT-5.2 Codex (gpt-5.2-codex)  
→ GPT-5.1 Codex (gpt-5.1-codex)  
→ Fallback: Mistral Medium (mistral-medium)

Scope:

- Diff-only
- Read-only
- No architectural changes

---

### intent: refactor

→ Devstral2 (mistral-devstral2) **ONLY**

Hard Gates (ALL REQUIRED):

- Canary execution enabled
- Diff-scoped changes
- Explicit file list
- SAVE forbidden until verification passes

❌ Gemini models FORBIDDEN  
❌ GPT-5 Codex (gpt-5.1-codex, gpt-5.2-codex) FORBIDDEN  
❌ Free-tier models FORBIDDEN

---

### intent: code_generation

→ Devstral2 (mistral-devstral2)  
→ GPT-5.2 Codex (gpt-5.2-codex)  
→ GPT-5.1 Codex (gpt-5.1-codex)

Hard Gates (ALL REQUIRED):

- Explicit file list
- Scope-limited changes only
- No architectural decisions
- SAVE forbidden until verification passes

❌ Gemini models FORBIDDEN  
❌ Free-tier models FORBIDDEN

---

### intent: architecture

→ Gemini 2.5 Pro (gemini-2.5-pro)  
→ GPT-5.2 Codex (gpt-5.2-codex)  
→ Gemini 3 Pro Preview (gemini-3-pro-preview) (**OPT-IN ONLY**)

Hard Gates:

- ADR-compatible output REQUIRED
- RESTORE REQUIRED before execution
- SAVE allowed ONLY via ADR workflow

---

### intent: domain

→ Gemini 2.5 Pro (gemini-2.5-pro)

Hard Gates:

- ADR-compatible output REQUIRED
- RESTORE REQUIRED before execution
- SAVE allowed ONLY via ADR workflow

---

### intent: research

→ Gemini 2 (gemini-2)  
→ GPT-5.2 Codex (gpt-5.2-codex)  
→ GPT-5.1 Codex (gpt-5.1-codex)  
→ Fallback: Gemini 1.5 Pro (gemini-1.5-pro)  
→ Fallback (free-tier): Kimi K2.5 Free (kimi-k2.5-free)

Scope:

- Read-only
- No decisions
- No code
- No context mutation

---

### intent: planning

→ Gemini 1.5 Pro (gemini-1.5-pro)  
→ GPT-5.2 Codex (gpt-5.2-codex)  
→ GPT-5.1 Codex (gpt-5.1-codex)  
→ Codestral (codestral-latest, free-tier: planning guidance only)  
→ Fallback: Gemini 2 (gemini-2)

Rules:

- Structured steps
- No execution
- No SAVE

---

### intent: debugging

→ Gemini 2 (gemini-2)  
→ Fallback: GPT-5.2 Codex (gpt-5.2-codex)  
→ Escalation: Gemini 3 Pro Preview (gemini-3-pro-preview) (**explicit user opt-in required**)

Rules:

- No refactors
- No architectural redesign
- Diagnosis only

---

### intent: chat

→ Gemini 1.5 Pro (gemini-1.5-pro)  
→ Fallback: Mistral Small (mistral-small)  
→ Fallback (free-tier): Big Pickle (big-pickle)

Low-risk, non-project-bound only.

---

## Preview Model Restrictions (Non-Negotiable)

Applies to:

- Gemini 3 Flash Preview (gemini-3-flash-preview)
- Gemini 3 Pro Preview (gemini-3-pro-preview)

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

## Image Scan / Content Extraction (Strict)

Image-based scanning and content extraction (OCR, captioning, or visual parsing)
MUST use Gemini 3 Preview models:

- Gemini 3 Flash Preview (gemini-3-flash-preview)
- Gemini 3 Pro Preview (gemini-3-pro-preview)

Rules:

- Read-only output only
- No file writes, code generation, or refactors
- Output must be used for summarize/classify only

Fallback:

- If Gemini 3 Preview is unavailable → use GPT-5.1 Codex (gpt-5.1-codex) in read-only mode

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
- Any model → same-task multi-model chaining ❌

See `SKILL.md` for allowed and forbidden handoff examples.

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
