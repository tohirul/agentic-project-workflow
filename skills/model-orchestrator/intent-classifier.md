# Intent Classification Contract (Authoritative)

This file defines the **single source of truth** for resolving user intent.

Intent classification is:

- Deterministic
- Rule-ordered
- Single-label only
- Non-probabilistic
- Non-negotiable

**First valid match wins.**
No confidence scoring.
No blending.
No reclassification downstream.

If intent cannot be resolved safely → **HALT**.

---

## Core Invariants

- Exactly ONE intent MUST be assigned
- Intent is IMMUTABLE after classification
- Intent controls:
  - model selection
  - sandbox state
  - plugin eligibility
  - memory permissions
- No model, plugin, or user prompt may override intent once locked

Violation → **hard failure**

---

## Classification Pipeline (Strict Order)

1. Normalize prompt:
   - lowercase
   - strip punctuation
   - collapse whitespace
2. Evaluate rules **top → bottom**
3. Assign first matching intent
4. Lock intent
5. Forward intent to:
   - model routing
   - sandbox enforcement
   - verification

Intent MUST NOT change after step 4.

---

## Canonical Intent Set (Exhaustive)

Only the following intents are valid:

- `architecture`
- `domain`
- `code_review`
- `refactor`
- `debugging`
- `code_generation`
- `planning`
- `research`
- `summarize`
- `classify`
- `chat` (fallback only)

Any other label → **invalid**

---

## Intent Resolution Rules (Priority Ordered)

---

### 1️⃣ architecture (HIGHEST PRIORITY)

This intent governs **long-term system decisions**.

Trigger if ANY condition below matches.

#### Explicit Keywords

- architecture
- design
- system design
- scalability
- boundaries
- long-term
- trade-off
- ADR

#### Architectural Concepts

- microservice
- DDD
- bounded context
- event-driven
- CQRS
- system evolution
- domain modeling

#### Hard Overrides

- Explicit mention of “ADR” → architecture
- Mentions long-term impact, future-proofing, or systemic change → architecture
- Requires decision, not comparison → architecture

---

### 2️⃣ domain

This intent governs **domain modeling and business rules**.

Trigger if ANY condition below matches.

#### Explicit Keywords

- domain model
- domain rules
- business rules
- ubiquitous language
- entity modeling
- schema evolution

#### Hard Overrides

- Explicit mention of “domain” in a modeling context → domain
- Requests to change domain invariants → domain

---

### 3️⃣ code_review

This intent is **read-only by definition**.

Trigger if ANY condition below matches.

#### Keywords

- review
- PR
- pull request
- diff
- changes
- regression

#### Concerns

- security issue
- vulnerability
- performance regression
- code smell

#### Structural Signals

- Mentions plugins: `core-review`, `code-review`
- Mentions specific files + “review”

Hard rule:

- code_review MAY NOT mutate code
- code_review MAY NOT propose refactors

---

### 4️⃣ refactor

This intent governs **structural improvement without redesign**.

Trigger if ANY condition below matches.

#### Keywords

- refactor
- restructure
- cleanup
- reorganize

#### Intent Signals

- reduce coupling
- improve maintainability
- simplify structure

#### Hard Gates

- If new architecture is proposed → architecture instead
- If business/domain rules change → architecture instead

---

### 5️⃣ debugging

This intent assumes **existing behavior is incorrect**.

Trigger if ANY condition below matches.

#### Keywords

- bug
- error
- crash
- failing
- broken

#### Diagnostic Questions

- why is this failing
- what caused this
- root cause

Hard rule:

- Debugging does NOT imply refactor
- Debugging does NOT imply redesign

---

### 6️⃣ code_generation

This intent governs **net-new code creation**.

Trigger if ANY condition below matches.

#### Keywords

- write
- create
- generate
- implement
- add

#### Signals

- explicit function creation
- explicit file creation
- “add a new …”

Hard gates:

- If a diff already exists → NOT code_generation
- If change is structural → refactor instead

---

### 7️⃣ planning

This intent governs **process, not execution**.

Trigger if ANY condition below matches.

#### Keywords

- plan
- steps
- roadmap
- workflow
- approach

#### Signals

- “how should we…”
- multi-step reasoning without implementation

Hard rule:

- Planning MUST NOT generate code
- Planning MUST NOT generate ADRs

---

### 8️⃣ research

This intent governs **exploration without decision**.

Trigger if ANY condition below matches.

#### Keywords

- compare
- evaluate
- research
- investigate

#### Signals

- pros and cons
- alternatives
- best approach (without commitment)

Hard gate:

- If a decision is required → architecture instead

---

### 9️⃣ summarize

This intent governs **condensing provided material**.

Trigger if ANY condition below matches.

#### Keywords

- summarize
- summary
- tl;dr
- recap
- bullet points

#### Signals

- “summarize this”
- “give me a summary”
- “shorten this”

Hard rule:
- Summarize does NOT add new information
- Summarize does NOT infer missing context

---

### 🔟 classify

This intent governs **routing / tagging / labeling** tasks.

Trigger if ANY condition below matches.

#### Keywords

- classify
- categorize
- tag
- label

#### Signals

- “what category is this”
- “which bucket does this belong to”
- “label these items”

Hard rule:
- Classification does NOT analyze beyond the provided text

---

### 1️⃣1️⃣ chat (FALLBACK ONLY)

Assigned ONLY if ALL are true:

- No other intent matched
- No project context required
- No files, code, or decisions involved
- Informational or conceptual only

---

## Ambiguity & Halt Conditions (Mandatory)

The classifier MUST HALT if:

- Multiple intents match at the same priority
- Prompt mixes architecture + refactor
- Prompt mixes refactor + code_generation
- Prompt asks to bypass intent rules
- Prompt explicitly selects a model
- Prompt attempts to override sandbox or memory rules

On halt:

→ Ask user to clarify intent  
→ Do NOT guess  
→ Do NOT escalate  
→ Do NOT proceed

---

## Enforcement Guarantees

- Intent is immutable once locked
- Model selection MUST follow intent
- Sandbox state MUST follow intent
- Plugins MUST enforce intent boundaries
- Verification MUST reject intent drift

---

## Non-Executable Examples

| Prompt                                     | Intent          |
| ------------------------------------------ | --------------- |
| “Design a scalable event-driven platform”  | architecture    |
| “Define the domain model for billing”      | domain          |
| “Review this PR for auth vulnerabilities”  | code_review     |
| “Refactor this service to reduce coupling” | refactor        |
| “Why is this API returning 500?”           | debugging       |
| “Generate a new REST controller”           | code_generation |
| “How should we approach this migration?”   | planning        |
| “Compare Kafka vs NATS”                    | research        |
| “Summarize this document”                  | summarize       |
| “Classify these tickets”                   | classify        |
| “What is DDD?”                             | chat            |

---

## Final Rule

If intent is unclear, mixed, or unsafe:

→ **DO NOT GUESS**  
→ **DO NOT PROCEED**  
→ **ASK OR FAIL**

Determinism > speed  
Correctness > convenience  
Governance > creativity
