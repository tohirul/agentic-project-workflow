# Context Contract (Authoritative)

This document defines the **exclusive, non-negotiable rules** for context assembly, validation, immutability, and usage within the Multi-Model AI Orchestrator.

Context is **deterministic**, **hierarchical**, and **file-grounded**.  
Models do not reason about context — they **consume a frozen snapshot**.

If any conflict exists between this document and `CONTRACT.md`:
→ **`CONTRACT.md` wins**

---

## 1. Context Philosophy

- Context is authoritative; output is subordinate
- Context is assembled once, before execution
- Context is immutable during execution
- Context is never inferred
- Context must be traceable to an explicit source

Correctness > convenience  
Determinism > creativity  

---

## 2. What Context Is (Strict Definition)

Context consists **only** of the following explicit sources:

- RESTORE memory (if required)
- `ai.project.json`
- Declared task scope & permissions
- Explicit user prompt
- Explicit plugin contracts (if enabled)

There are **no other context sources**.

---

## 3. What Context Is NOT

Context MUST NOT include:

- Prior chat history (unless restored)
- Cross-project data
- Undeclared assumptions
- Inferred constraints
- “Active architectural constraints”
- “Domain rules” not present in `ai.project.json`
- Model-generated policy interpretations

---

## 4. Canonical Context Hierarchy

This hierarchy is **absolute** and identical to `CONTRACT.md`.

1. RESTORE memory  
2. `ai.project.json`  
3. Declared task scope & permissions  
4. Explicit user prompt  

No additional layers are permitted.

---

## 5. `ai.project.json` Authority

`ai.project.json` is the sole authoritative container for:

- Architectural constraints
- Domain definitions
- Schema rules
- Technology locks
- Invariants and prohibitions

If a rule is not present in this file, it is **not binding**.

---

## 6. Mandatory Requirement for Project-Bound Intents

For intents:
`architecture`, `domain`, `code_generation`, `code_review`,
`refactor`, `debugging`, `planning`

If `ai.project.json` is missing → **HALT**

---

## 7. Bootstrap Exception — `generate_context`

Rules:

- `ai.project.json` may be absent
- Sandbox ENABLED
- Write permission ONLY for `ai.project.json`
- Output exactly one file
- No SAVE / RESTORE

Violation → **HALT**

---

## 8. Context Assembly Rules

Assembly order:

1. RESTORE memory
2. `ai.project.json`
3. Task scope & permissions
4. User prompt

Snapshot is frozen before model selection.

---

## 9. Context Immutability

Once execution begins:
- No additions
- No removals
- No reinterpretation
- No dynamic loading

Any mutation attempt → **HALT**

---

## 10. Context Validation

Before execution, validate:

- Required context present
- No conflicts
- Single project only
- No inferred layers

| Condition | Result |
|---------|--------|
| Missing context | ASK_USER |
| Conflict / inferred context | HALT |

---

## 11. Cross-Project Isolation

Forbidden:
- Other repositories
- Shared schemas
- Unrelated memory

Violation → **HALT**

---

## 12. Plugin Context Rules

Plugins may contribute context ONLY if:
- Explicitly enabled
- Contract loaded
- Scope declared
- Subordinate to core context

Plugins MUST NOT override or invent constraints.

---

## 13. Missing Context Handling

Only allowed response:

"Insufficient context."

---

## 14. Final Rule

If there is any uncertainty:
→ ASK USER  
→ DO NOT GUESS  
→ DO NOT PROCEED
