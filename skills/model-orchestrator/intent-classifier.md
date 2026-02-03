# Intent Classifier (Authoritative)

This file defines the **single, deterministic mechanism**
for classifying user prompts into **exactly ONE intent**.

Intent classification is **mandatory**, **immutable**, and **non-heuristic**.

No model, agent, plugin, or user instruction may override,
reinterpret, or bypass this classifier.

If intent cannot be resolved deterministically,
**execution MUST NOT proceed**.

---

## Classification Philosophy

- Exactly **one** intent per task
- Intent is resolved **before** model selection
- Intent never changes during execution
- Ambiguity is resolved by **asking the user**, not guessing

Correctness > convenience  
Determinism > flexibility  

---

## Canonical Intent List (Closed Set)

Only the intents listed below are valid.
No other intents may be inferred or invented.

| Intent | Purpose |
|------|---------|
| `generate_context` | Create or initialize `ai.project.json` |
| `classify` | Tagging, routing, or intent detection |
| `summarize` | Condense provided content |
| `code_review` | Review existing code or diffs |
| `code_generation` | Write new code |
| `refactor` | Structural code changes |
| `architecture` | System or architectural decisions |
| `domain` | Business or domain modeling |
| `research` | Comparative or multi-source inquiry |
| `planning` | Ordered execution strategy |
| `debugging` | Root cause analysis |
| `chat` | Low-risk, non-project-bound interaction |

If a prompt does not map to exactly one of the above → **FAIL**.

---

## Intent Resolution Order (Strict Priority)

Intent matching MUST be evaluated in the following order.
Once a match is found, classification stops.

1. `generate_context`
2. `refactor`
3. `architecture`
4. `domain`
5. `code_generation`
6. `code_review`
7. `debugging`
8. `planning`
9. `research`
10. `summarize`
11. `classify`
12. `chat`

This order prevents lower-risk intents from shadowing higher-risk ones.

---

## Intent Definitions & Triggers

### 1️⃣ `generate_context` (BOOTSTRAP EXCEPTION)

**Purpose**
- Initialize a new project
- Create or regenerate `ai.project.json`

**Typical Triggers**
- "initialize project"
- "generate ai.project.json"
- "set up project context"
- "bootstrap project configuration"

**Hard Rules**
- May run WITHOUT existing `ai.project.json`
- Output MUST be `ai.project.json` ONLY
- No other files may be written
- No SAVE / RESTORE
- No model inference authority beyond structure generation

Misuse → **HALT**

---

### 2️⃣ `refactor`

**Purpose**
- Structural or behavioral changes to existing code

**Triggers**
- "refactor"
- "restructure"
- "simplify this code"
- "improve design without changing behavior"

**Hard Rules**
- Requires explicit file list
- Diff-scoped changes only
- Canary execution required
- SAVE forbidden until verification passes

---

### 3️⃣ `architecture`

**Purpose**
- System design decisions
- Technology selection
- Long-term structural changes

**Triggers**
- "design architecture"
- "choose database"
- "system design"
- "define boundaries"

**Hard Rules**
- ADR-compatible output required
- RESTORE required before execution
- No production code generation

---

### 4️⃣ `domain`

**Purpose**
- Business logic modeling
- Schema or domain invariants

**Triggers**
- "define domain model"
- "schema design"
- "business rules"

**Hard Rules**
- ADR-compatible output required
- RESTORE required before execution
- No implementation detail

---

### 5️⃣ `code_generation`

**Purpose**
- Write new code from scratch or specification

**Triggers**
- "implement"
- "create function"
- "write code"

**Hard Rules**
- Explicit file list required
- No architectural decisions
- SAVE forbidden until verification passes

---

### 6️⃣ `code_review`

**Purpose**
- Review existing code or diffs

**Triggers**
- "review this code"
- "check for issues"
- "code review"

**Hard Rules**
- Read-only
- Diff-scoped
- No refactor suggestions unless intent = refactor

---

### 7️⃣ `debugging`

**Purpose**
- Identify root cause of bugs or errors

**Triggers**
- "why is this failing"
- "debug this issue"

**Hard Rules**
- Diagnosis only
- No refactor or architectural changes

---

### 8️⃣ `planning`

**Purpose**
- Ordered steps or execution plans

**Triggers**
- "plan"
- "steps to"
- "roadmap"

**Hard Rules**
- No execution
- No SAVE

---

### 9️⃣ `research`

**Purpose**
- Comparative analysis
- Multi-source information gathering

**Triggers**
- "compare"
- "research"
- "analyze options"

**Hard Rules**
- Read-only
- No decisions
- No SAVE

---

### 🔟 `summarize`

**Purpose**
- Condense provided content

**Triggers**
- "summarize"
- "TL;DR"

**Hard Rules**
- No interpretation
- No decisions

---

### 1️⃣1️⃣ `classify`

**Purpose**
- Label or categorize input

**Triggers**
- "classify"
- "tag this"

**Hard Rules**
- Output labels only

---

### 1️⃣2️⃣ `chat`

**Purpose**
- Low-risk conversational interaction

**Triggers**
- Greetings
- Opinions
- Non-project questions

**Hard Rules**
- No SAVE
- No context mutation
- Non-authoritative

---

## Ambiguity Handling (Mandatory)

If a prompt:
- Matches multiple intents
- Is vague or underspecified
- Requests mixed outcomes

Then:

→ **ASK_USER**
→ Request explicit clarification
→ Do NOT infer or guess

---

## Intent Immutability Rule

Once intent is resolved:

- It MUST NOT change
- It MUST NOT be broadened
- It MUST NOT be narrowed

Any attempt to alter intent mid-execution → **HALT**

---

## Final Rule

If intent cannot be resolved **deterministically and unambiguously**:

→ **ASK USER**
→ **DO NOT PROCEED**

Correct non-execution is compliant behavior.
