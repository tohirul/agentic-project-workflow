# Unified Verification & Response Validation (Authoritative)

This file defines the **final, non-bypassable verification gate**
for **all AI-generated outputs** under the Multi-Model AI Orchestrator.

No output may be:
- Returned to the user
- Persisted via SAVE
- Used by another agent or plugin
- Used to trigger execution

unless it passes **every rule in this document**.

Verification is **deterministic**, **fail-closed**, and **policy-driven**.

---

## Verification Philosophy

- Verification is stricter than generation
- Policy always outranks output quality
- Silence is preferable to unsafe output
- Recoverable errors require human intervention, not autonomy

Correctness > completeness  
Governance > convenience  
Safety > speed  

---

## Terminal Outcomes (Aligned with CHECKS.md)

Verification MAY end in exactly one outcome:

| Outcome | Meaning |
|-------|--------|
| `PASS` | Output is valid and may proceed |
| `HALT` | Non-recoverable violation |
| `ASK_USER` | Missing or ambiguous information |
| `INTERVENTION_REQUIRED` | Recoverable structural failure |

No other outcomes are permitted.

---

## Validation Order (STRICT, NON-SKIPPABLE)

Validation MUST be executed in the exact order below.
Failure at any step immediately stops evaluation.

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

- Matches the **single locked intent**
- Does NOT introduce secondary or implicit intents
- Does NOT drift across lifecycle phases

### Immediate HALT if output includes:
- Mixed intents (e.g. review + refactor)
- Unrequested planning or architectural decisions
- Execution guidance during research
- Refactor or code changes without proper intent

Failure → `HALT`

---

## 2️⃣ Model Authority Validation (Hard Gate)

Confirm that the output is valid for:

- Selected model (per `selection.md`)
- Model tier & role (per `configuration.md`)
- Declared intent (per `intent-classifier.md`)

### Immediate HALT if:
- Preview model performs write, refactor, or SAVE actions
- Tier-D or Flash model produces authoritative output
- Any model escalates its own authority
- Role boundaries are violated

Failure → `HALT` (NO retry)

---

## 3️⃣ Context Compliance Validation (Hard Gate)

The output MAY reference ONLY entities present in:

1. RESTORE memory
2. `ai.project.json`
3. Declared task scope
4. Explicit user prompt
5. Active plugin contracts (if any)

### Forbidden (Zero Tolerance):

- Invented tools, frameworks, APIs, services
- Assumed defaults or “industry standard” claims
- Cross-project or prior-project knowledge
- Rewriting accepted architecture or history

### Failure Classification:

| Condition | Result |
|--------|--------|
| Missing required context | `ASK_USER` |
| Invented or conflicting context | `HALT` |

---

## 4️⃣ Scope & Mutation Safety

The output MUST NOT:

- Modify files when scope is read-only
- Propose SAVE when SAVE is disallowed
- Trigger RESTORE implicitly
- Introduce ADRs outside ADR workflow
- Mutate routing, memory, or context indirectly

Silent mutation is a **critical violation**.

Failure → `HALT`

---

## 5️⃣ Structural Integrity Validation

### For ALL Outputs

- Output matches the required format (Markdown / JSON / Diff / ADR)
- Required sections are present
- No placeholders or pseudo-content
- No “assume this exists” patterns

### Additional Rules

**Code Outputs**
- Syntactically valid
- Uses only real, existing APIs
- No TODOs or stubs unless explicitly allowed

**Code Review Outputs**
- Diff-scoped only
- Exact file paths and line numbers required
- No refactor suggestions unless intent = refactor

**Architecture / Domain Outputs**
- ADR-compatible structure when required
- Clear separation of:
  - Context
  - Constraints
  - Decisions
  - Trade-offs
- No implementation detail when forbidden

### Failure Classification:

| Failure | Result |
|------|--------|
| Malformed format | `INTERVENTION_REQUIRED` |
| Missing required sections | `INTERVENTION_REQUIRED` |

---

## 6️⃣ Hallucination Detection (Intent-Scoped)

Hallucination enforcement depends on **intent criticality**.

### Critical Intents
`architecture`, `domain`, `refactor`, `code_generation`

Immediate **HALT** if output contains:
- Invented APIs, tools, or frameworks
- Ungrounded assumptions
- Speculative language (“maybe”, “likely”, “typically”) without citation
- Assumed defaults or future tooling

### Non-Critical Intents
`research`, `summarize`, `chat`, `planning`

- Ungrounded generalizations → allowed but flagged
- Any decision, mutation, or recommendation beyond scope → `HALT`

No retry is permitted for hallucination in critical intents.

---

## 7️⃣ Output Contract Validation

The output MUST strictly match the declared output contract:

- Correct format
- Allowed sections ONLY
- Correct verbosity
- No reasoning traces
- No orchestration or policy references
- No speculative or advisory language where forbidden

### Failure Classification:

| Failure | Result |
|------|--------|
| Contract mismatch | `INTERVENTION_REQUIRED` |
| Forbidden content | `HALT` |

---

## Retry Policy (Global, Strict)

- Maximum retries per task: **1**
- Retry MUST:
  - Use the SAME model
  - Apply stricter constraints
- No automatic promotion
- No silent substitution

Second failure → `HALT`

---

## Standardized Verification Responses

On failure, respond with EXACTLY ONE of:

- **"Insufficient context."**
- **"Request exceeds allowed scope."**
- **"Model authority violation detected."**
- **"Response failed verification."**

No additional explanation unless explicitly requested.

---

## Enforcement Invariants (Absolute)

- No output without passing verification
- No model validates itself
- No partial acceptance
- No silent correction
- No advisory enforcement

---

## Final Enforcement Rule

If verification cannot be completed deterministically due to:

- Missing context
- Ambiguous intent
- Policy conflict

→ **ASK USER**
→ **DO NOT GUESS**
→ **DO NOT PROCEED**

Correct silence is a valid and compliant outcome.
