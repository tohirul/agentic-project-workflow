# Model Selection & Routing Matrix (Authoritative)

This file defines **deterministic, enforceable model routing**
for the Multi-Model AI Orchestrator.

Model selection is **policy**, not inference.
Routing is **static**, **auditable**, and **non-negotiable**.

If any conflict exists between files,
`CONTRACT.md` and `configuration.md` take precedence.

---

## Selection Philosophy

- Intent determines _eligibility_, not authority
- Authority tier constrains selection absolutely
- No heuristic routing
- No dynamic optimization
- No silent fallback

Correctness > convenience  
Determinism > creativity

---

## Preconditions (Hard Gate)

Model selection MUST occur ONLY after:

- Intent is resolved and immutable
- Context contract is validated
- Sandbox state is determined
- Telemetry is initialized

If any precondition fails → **HALT**

---

## Authority Tiers (Reminder)

Model authority is tier-based and immutable.

- **Tier-A**: Primary authority (mutative, decision-capable)
- **Tier-B**: Secondary authority (advisory, diagnostic)
- **Tier-C**: Preview / restricted (read-only)
- **Tier-D**: Free / assistive (non-authoritative)

A model may NEVER act outside its tier.

---

## Intent → Eligible Tiers (Strict)

| Intent           | Allowed Tiers           |
| ---------------- | ----------------------- |
| generate_context | Tier-B (structure only) |
| classify         | Tier-B, Tier-C          |
| summarize        | Tier-B, Tier-D          |
| research         | Tier-B                  |
| planning         | Tier-B                  |
| debugging        | Tier-B                  |
| code_review      | Tier-A                  |
| code_generation  | Tier-A                  |
| refactor         | Tier-A                  |
| architecture     | Tier-A                  |
| domain           | Tier-A                  |
| chat             | Tier-B, Tier-D          |

If no tier is allowed → **HALT**

---

## Intent → Model Routing (Deterministic)

The first available model in each list MUST be selected.
Resolution uses `configuration.md` model resolution.

---

### `generate_context`

- gemini-1.5-pro
- gemini-2-flash
- gemini-2

(Role: assistant, structure-only)

---

### `classify`

- gemini-2-flash
- gpt-4o
- gemini-3-pro-preview

Notes:

- Read-only
- No routing side-effects
- No SAVE / RESTORE

---

### `summarize`

- deepseek-coder-community
- glm-4.7-free
- minimax-m2.1-free
- mistral-small
- gemini-2-flash
- gpt-4o

---

### `research`

- gemini-2
- gemini-1.5-pro

---

### `planning`

- gemini-1.5-pro
- gemini-2
- gemini-2-flash

---

### `debugging`

- gemini-2
- gpt-4o

---

### `code_review`

- mistral-devstral2
- gpt-5.1-codex
- gpt-5.2-codex

Scope:

- Read-only
- Diff-scoped
- No architectural changes

---

### `code_generation`

- mistral-devstral2
- gpt-5.2-codex
- gpt-5.1-codex

Hard Gates:

- Explicit file list
- No architectural decisions
- SAVE forbidden until verification passes

---

### `refactor`

- mistral-devstral2 **ONLY**

Hard Gates:

- Explicit file list
- Canary execution required
- Diff-scoped changes
- SAVE forbidden until verification passes

Forbidden:

- Gemini models
- GPT Codex models
- Free-tier models

---

### `architecture`

- gemini-2.5-pro
- gpt-5.2-codex

Hard Gates:

- ADR-compatible output required
- RESTORE required
- SAVE allowed ONLY via ADR workflow

---

### `domain`

- gemini-2.5-pro

Hard Gates:

- ADR-compatible output required
- RESTORE required
- SAVE allowed ONLY via ADR workflow

---

### `chat`

- big-pickle
- qwen-2.x
- kimi-k2.5-free
- mistral-small
- gemini-1.5-pro
- gpt-4o
- gemini-2

Low-risk, non-project-bound only.

---

## Preview Model Restrictions (Absolute)

Applies to:

- gemini-3-pro-preview
- gemini-3-flash-preview

Preview models MAY:

- Analyze
- Compare
- Propose options

Preview models MAY NOT:

- Write files
- Modify code
- Perform refactors
- Trigger SAVE / RESTORE
- Mutate context

Violation → **HALT**

---

## Free-Tier Model Restrictions (Absolute)

Free-tier models MAY:

- Summarize
- Classify
- Explain concepts

Free-tier models MAY NOT:

- Generate production code
- Review diffs
- Make decisions
- Mutate context
- Participate in multi-agent workflows

Violation → **HALT**

---

## Forbidden Routes (Global)

The following routes are ALWAYS invalid:

- Tier-D → code_review
- Tier-D → code_generation
- Tier-D → refactor
- Tier-B → refactor
- Preview → any mutative intent
- Any model → bypass `ai.project.json`
- Any model → self-escalation
- Any model → same-task multi-model chaining

Detection → **HALT**

---

## Fallback & Resolution Rules

- Routing selects logical model first
- Physical resolution handled by `configuration.md`
- If resolved model unavailable → try fallback
- If all resolution fails → **HALT**
- Capability profile remains unchanged after fallback

No silent substitution is permitted.

---

## Final Rule

If a model is not explicitly allowed here,
it is **not allowed anywhere**.

Correct refusal is compliant behavior.
