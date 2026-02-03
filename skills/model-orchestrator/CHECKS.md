# Model Orchestration Checks (Authoritative)

This file defines the **mandatory, non-bypassable guardrails**
enforced by the orchestrator **before**, **during**, and **after**
every model invocation.

Checks are **deterministic**, **binary**, and **enforced by policy**.

No model, plugin, or user instruction may weaken or reinterpret these checks.

---

## Enforcement Philosophy

- **Policy violations are terminal**
- **Ambiguity is never resolved implicitly**
- **Recoverable errors require human intervention**
- **No autonomous recovery is permitted**

Correctness > convenience  
Determinism > throughput  
Safety > speed  

---

## Terminal States (Explicit)

Execution may end in exactly one of the following states:

| State | Meaning |
|-----|--------|
| `HALT` | Non-recoverable failure. Execution stops permanently. |
| `ASK_USER` | Missing or ambiguous input. Await clarification. |
| `INTERVENTION_REQUIRED` | Recoverable structural failure. Human correction required. |

No other terminal states exist.

---

## 1️⃣ Pre-Execution Checks (Hard Gate)

ALL checks below MUST pass **before** any model is invoked.

### Intent & Routing

- Prompt intent classified via `intent-classifier.md`
- Exactly **ONE** intent resolved
- Intent locked (immutable)
- Model selected strictly via `selection.md`
- Selected model tier authorized for intent
- Preview / Tier-D restrictions validated

Failure handling:
- Ambiguous intent → `ASK_USER`
- Unauthorized or multiple intents → `HALT`

---

### Context Integrity

- Context snapshot assembled per `context-contract.md`
- Required RESTORE memory loaded (if applicable)
- `ai.project.json` present unless intent explicitly allows absence
- Context sources applied in correct priority order
- No cross-project context detected
- No missing mandatory context blocks

Failure handling:
- Missing required context → `ASK_USER`
- Cross-project or conflicting context → `HALT`

---

### Scope Declaration

- Task scope explicitly declared
- Allowed actions listed (read / write / diff / analyze)
- File or directory boundaries defined (if applicable)
- Sandbox state resolved and enforced

Failure handling:
- Implicit scope → `HALT`
- Vague permissions → `ASK_USER`

---

### Authority & Role Alignment

- Model assigned **exactly ONE role** (`router`, `assistant`, `reviewer`, `architect`, `executor`)
- Role matches intent
- Role permitted for model tier
- No excess authority granted

Failure handling:
- Role mismatch or tier violation → `HALT`

---

## 2️⃣ Execution-Time Checks (Continuous)

Enforced **during** model execution:

- Prompt hardened via `prompt-hardening.md`
- No forbidden instructions injected
- No self-escalation attempts
- No dynamic context loading
- No implicit memory mutation
- No lifecycle phase violation

Any violation → immediate termination (`HALT`).

---

## 3️⃣ Post-Execution Checks (Mandatory Validation)

ALL outputs MUST pass **every** check below before being returned or saved.

### Intent Compliance

- Output matches locked intent
- No secondary or implicit intent introduced
- No unsolicited planning, refactor, or architecture

Failure → `HALT`

---

### Context Compliance

- Output references ONLY allowed tools, frameworks, APIs
- No invented abstractions or assumptions
- No contradiction with `ai.project.json`
- No override of RESTORE memory

Failure handling:
- Invented context → `HALT`
- Missing grounding → `ASK_USER`

---

### Scope & Mutation Safety

- No file writes if forbidden
- No SAVE proposed if disallowed
- No RESTORE triggered implicitly
- No architectural decision outside ADR workflow

Failure → `HALT`

---

### Structural & Technical Validity

- Output conforms to required format (JSON / Diff / ADR / Markdown)
- Required sections present
- No placeholders or pseudo-APIs
- Review outputs reference exact files / lines (if applicable)

Failure handling:
- Structural / formatting error → `INTERVENTION_REQUIRED`

---

### Hallucination Detection (Intent-Scoped)

Critical intents (`architecture`, `domain`, `refactor`, `code_generation`):
- Invented tools, ungrounded claims, speculative language → `HALT`

Non-critical intents (`research`, `summarize`, `chat`):
- Ungrounded generalizations → warning
- Decision or mutation language → `HALT`

---

## 4️⃣ Failure Classification (Global)

All failures MUST be classified into exactly one category:

| Failure Class | Result |
|--------------|--------|
| Policy / authority violation | `HALT` |
| Hallucination (critical intent) | `HALT` |
| Missing information | `ASK_USER` |
| Structural / formatting error | `INTERVENTION_REQUIRED` |

---

## 5️⃣ Intervention Rules

When in `INTERVENTION_REQUIRED`:

Allowed:
- Human edits output
- Human confirms correction
- Re-run verification only

Forbidden:
- Model retries
- Context mutation
- SAVE / RESTORE
- Model escalation

Failure after intervention → `HALT`

---

## 6️⃣ Retry Policy

- Maximum retries: **1**
- Retry MUST use the **same model**
- Retry context MUST be stricter
- No automatic promotion

Second failure → `HALT`

---

## Final Rule

If checks cannot be completed deterministically:

→ **ASK USER**  
→ **DO NOT GUESS**  
→ **DO NOT PROCEED**

Correct silence is a valid outcome.
