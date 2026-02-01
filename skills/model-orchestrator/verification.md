### Phase 0 — Lifecycle State Validation (Mandatory)

Confirm that:

- Output corresponds to the current lifecycle phase
- Model used is permitted in this phase
- Actions performed are allowed in this phase

Failure conditions:

- Model acts outside its lifecycle phase
- Write occurs in read-only phase
- SAVE attempted outside Phase 10

❌ Failure → Reject output (no retry)

# Unified Verification & Response Validation (Authoritative)

This file defines the **final, non-bypassable enforcement gate**
for **all AI-generated outputs**.

No output may be:

- Returned to the user
- Persisted via SAVE
- Used by another agent
- Used to trigger execution

unless it passes **every phase** in this document.

Validation is **mandatory**, **deterministic**, and **fail-closed**.

---

## Scope of Enforcement

This validator applies to:

- All models (Tier-A → Tier-D)
- All intents
- All plugins
- All agents
- All lifecycle phases

There are **no exceptions**.

---

## Validation Order (STRICT, NON-SKIPPABLE)

Validation MUST be executed in the following order.
Failure at any step immediately aborts evaluation.

1. Intent Alignment
2. Model Authority Validation
3. Context Compliance Validation
4. Scope & Mutation Safety
5. Structural Integrity Validation
6. Hallucination Detection
7. Output Contract Validation

---

## 1️⃣ Intent Alignment (Hard Gate)

Confirm that the output:

- Matches the **single normalized intent**
- Does NOT introduce secondary or implicit intents
- Does NOT drift across lifecycle phases

### Immediate FAIL if output includes:

- Mixed intents (e.g. review + refactor)
- Unrequested planning or architectural opinion
- Decision-making during research
- Refactor guidance without refactor intent

❌ Failure → **Reject output**

---

## 2️⃣ Model Authority Validation (Hard Gate)

Confirm that the output is valid for:

- Selected model (per `selection.md`)
- Model tier & role (per `configuration.md`)
- Declared intent (per `intent-classifier.md`)

### Immediate HARD FAIL if:

- Preview model performs write, refactor, or SAVE actions
- Flash or Tier-D model produces authoritative output
- Research model makes decisions
- Any model escalates its own authority
- Any model violates role boundaries

❌ Failure → **Reject output (NO retry)**

---

## 3️⃣ Context Compliance Validation (Hard Gate)

The output MAY reference ONLY entities present in:

1. RESTORE memory
2. `ai.project.json`
3. Detected project stack
4. Active plugin contracts
5. Explicit user prompt

### Forbidden (Zero Tolerance):

- Invented tools, frameworks, APIs, services
- Assumed defaults or “industry standard” claims
- Cross-project or prior-project knowledge
- Rewriting architecture history
- Creative gap-filling

If required context is missing, the ONLY allowed response is:

> **"Insufficient context."**

❌ Any violation → **Reject output**

---

## 4️⃣ Scope & Mutation Safety

The output MUST NOT:

- Modify files when scope is read-only
- Propose SAVE when SAVE is disallowed
- Trigger RESTORE implicitly
- Introduce ADRs outside ADR workflow
- Mutate routing, memory, or context indirectly

Silent mutation = **critical violation**

❌ Failure → **Reject output**

---

## 5️⃣ Structural Integrity Validation

### For Code Outputs

The output MUST:

- Be syntactically valid for the target language
- Use only real, existing APIs
- Compile logically (no pseudo-code unless requested)
- Avoid placeholders such as:
  - `TODO`
  - `assume this exists`
  - `someService`
  - `your implementation here`

### For Code Review Outputs

- Must reference exact files and line numbers
- Must remain diff-scoped
- Must not suggest refactors unless intent = refactor

### For Architecture / Domain Outputs

- Must be ADR-compatible when required
- Must separate:
  - Facts
  - Constraints
  - Decisions
  - Trade-offs
- Must avoid implementation details when forbidden

❌ Failure → **Reject output**

---

## 6️⃣ Hallucination Detection (Zero Tolerance)

Immediate, non-recoverable FAIL if output contains:

- “You could use X” where X is not in context
- “Typically / usually / commonly” without grounding
- Undeclared abstractions or patterns
- Non-existent APIs or libraries
- Speculative future tooling
- Security or architectural hallucinations

### Retry Rules

| Hallucination Type               | Action                 |
| -------------------------------- | ---------------------- |
| Architecture / Security          | Reject, NO retry       |
| Refactor-related                 | Reject, NO retry       |
| Minor descriptive (non-critical) | Retry once, same model |

❌ Failure → **Reject output**

---

## 7️⃣ Output Contract Validation

The output MUST strictly match the declared contract:

- Correct format (Markdown / JSON / Diff / ADR)
- Allowed sections ONLY
- Correct verbosity
- No reasoning traces
- No orchestration or policy references
- No speculative language (“maybe”, “likely”, “I think”)

❌ Failure → **Reject output**

---

## Retry Policy (GLOBAL, STRICT)

- Maximum retries per task: **1**
- Retry MUST:
  - Use the SAME model
  - Apply stricter constraints
  - Reduce scope or verbosity
- No automatic promotion
- No silent substitution

Second failure → **HALT**

---

## Tier-Specific Enforcement

### Tier-D (Free / Community Models)

- Output MUST be marked **non-authoritative**
- MUST be verified by Tier-A or Tier-B
- MUST NOT be final

Missing verification → **Discard output**

---

### Preview Models

Preview models MAY:

- Reason
- Compare
- Propose options

Preview models MAY NOT:

- Write files
- Modify code
- Trigger SAVE / RESTORE
- Generate tasks
- Declare decisions

Violation → **Hard failure, NO retry**

---

## Standardized Rejection Responses

On validation failure, respond with EXACTLY ONE:

- **"Insufficient context."**
- **"Request exceeds allowed scope."**
- **"Model authority violation detected."**
- **"Response failed validation."**

No additional explanation unless explicitly requested.

---

## Enforcement Invariants (Absolute)

- No output without passing validation
- No model validates itself
- No partial acceptance
- No silent correction
- No advisory policy

---

## Final Enforcement Rule

If validation cannot be completed deterministically due to:

- Missing context
- Ambiguous intent
- Policy conflict

→ **ASK the user explicitly**  
→ **DO NOT GUESS**  
→ **DO NOT PROCEED**

Correct silence is preferable to incorrect output.
