# Model Orchestration Checks (Authoritative)

This file defines **mandatory guardrails** enforced by the orchestrator
**before**, **during**, and **after** every model invocation.

Checks are **binary** (pass / fail).
No warnings. No soft failures. No best-effort execution.

Failure at any stage → **halt by default**.

---

## 1️⃣ Pre-Execution Checks (Hard Gate)

ALL checks below MUST pass before any model is invoked.

### Intent & Routing

- [ ] Prompt intent classified via `intent-classifier.md`
- [ ] Exactly ONE intent resolved
- [ ] Intent locked (immutable for execution)
- [ ] Model selected strictly via `selection.md`
- [ ] Selected model tier authorized for intent
- [ ] Preview / Tier-D restrictions validated

❌ Any failure → HALT

---

### Context Integrity

- [ ] Context snapshot assembled per `context-contract.md`
- [ ] RESTORE memory loaded when required
- [ ] `ai.project.json` present (if project-bound)
- [ ] Context sources applied in correct priority order
- [ ] No cross-project context detected
- [ ] No missing mandatory context blocks

❌ Any failure → ASK USER or HALT

---

### Scope Declaration

- [ ] Task scope explicitly declared
- [ ] Allowed actions listed (read / write / diff / analyze)
- [ ] File or directory boundaries defined (if applicable)
- [ ] Sandbox state determined (enabled / disabled)

❌ Implicit scope → HALT

---

### Authority & Role Alignment

- [ ] Model assigned exactly ONE role:
      (`router`, `assistant`, `reviewer`, `architect`, `executor`)
- [ ] Role matches intent
- [ ] Role permitted for model tier
- [ ] Model not granted excess authority

❌ Mismatch → HALT

---

## 2️⃣ Execution-Time Checks (Continuous)

These checks are enforced **during model execution**.

- [ ] Prompt hardened per `prompt-hardening.md`
- [ ] No forbidden instructions injected
- [ ] No model attempts self-escalation
- [ ] No attempt to load additional context
- [ ] No attempt to mutate memory implicitly

❌ Any violation → TERMINATE execution immediately

---

## 3️⃣ Post-Execution Checks (Mandatory Validation)

ALL outputs MUST pass **every** check below
before being returned, saved, or acted upon.

---

### Intent Compliance

- [ ] Output matches normalized intent
- [ ] No secondary or implicit intent introduced
- [ ] No unsolicited planning, refactor, or architecture

❌ Failure → REJECT output

---

### Context Compliance

- [ ] Output references only allowed tools, frameworks, APIs
- [ ] No invented abstractions or assumptions
- [ ] No contradiction with `ai.project.json`
- [ ] No override of RESTORE memory

❌ Failure → REJECT output

---

### Scope & Mutation Safety

- [ ] No file writes if forbidden
- [ ] No SAVE proposed if disallowed
- [ ] No RESTORE triggered implicitly
- [ ] No architectural decision outside ADR workflow

❌ Failure → REJECT output

---

### Structural & Technical Validity

- [ ] Code (if any) is syntactically coherent
- [ ] No pseudo-APIs or placeholders
- [ ] No “assume this exists” patterns
- [ ] Review output references exact files / lines (if applicable)

❌ Failure → REJECT output

---

### Hallucination Detection (Zero Tolerance)

Immediate FAIL if output contains:

- Unlisted tools or frameworks
- Generic advice detached from context
- “Typically / usually / in systems like this…” without grounding
- Speculative language (“likely”, “maybe”, “I think”)

❌ Failure → REJECT output

---

## 4️⃣ Tier-Specific Enforcement

### Tier-D (Free / Community Models)

Additional REQUIRED checks:

- [ ] Output explicitly marked **non-authoritative**
- [ ] Output verified by Tier-A or Tier-B
- [ ] Output not treated as final

❌ Missing verification → DISCARD output

---

### Preview Models

Additional REQUIRED checks:

- [ ] Read-only compliance
- [ ] No code or file generation
- [ ] No SAVE / RESTORE
- [ ] No task or migration generation

❌ Any violation → HARD FAILURE (no retry)

---

## 5️⃣ Escalation Rules (Strict)

Escalation is **exceptional**, never default.

Escalation MAY occur ONLY if **all** are true:

- [ ] Model failed **once** after retry
- [ ] Failure reason documented
- [ ] Context verified as sufficient
- [ ] Higher-tier model is authorized for intent
- [ ] Escalation permitted by `selection.md`

Escalation is FORBIDDEN if:

- Context incomplete
- Failure is policy-related
- Failure is hallucination-based
- User did not request higher authority

❌ Unauthorized escalation → HALT

---

## 6️⃣ Retry Policy (Global)

- Maximum retries: **1**
- Retry MUST use the same model
- Retry context MUST be stricter
- No automatic promotion

Second failure → **HALT**

---

## Enforcement Invariants

The following rules are absolute:

- No execution without passing pre-checks
- No output without passing post-checks
- No model validates itself
- No silent correction of violations
- No policy is advisory

---

## Final Rule

If checks cannot be completed deterministically due to
missing context, ambiguity, or policy conflict:

→ **ASK the user explicitly**  
→ **DO NOT GUESS**  
→ **DO NOT PROCEED**

Determinism > convenience.
