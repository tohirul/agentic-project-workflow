# Context Contract (Authoritative)

This file defines the **authoritative rules for context assembly, validation,
and usage** for the Multi-Model AI Orchestrator.

Context is **frozen**, **deterministic**, and **hierarchical**.
Models do not reason about context — they **obey it**.

No model, agent, plugin, or user instruction may bypass,
reinterpret, or expand context rules defined here.

---

## Context Philosophy

- Context is authoritative; output is subordinate
- Context is assembled **before** execution
- Context is immutable during execution
- Missing context is never inferred

Correctness > convenience  
Determinism > creativity  

---

## What Is Context

Context is the **complete, frozen information set**
provided to a model for a single task.

Context MAY include:
- RESTORE memory (if required)
- `ai.project.json`
- Explicit task scope
- Explicit user prompt
- Active plugin contracts (if any)

Context MUST NOT include:
- Prior chat history (unless explicitly restored)
- Cross-project information
- Model-inferred assumptions
- Undeclared defaults

---

## Context Assembly Order (Strict)

Context MUST be assembled in the following order.
Higher-priority context overrides lower-priority context.

1. RESTORE memory (approved, versioned only)
2. Active architectural constraints
3. Domain & schema definitions
4. `ai.project.json`
5. Task scope & permissions
6. Explicit user prompt

Any deviation → **HALT**

---

## Context Immutability Rule

Once context is assembled and execution begins:

- No additions
- No removals
- No reinterpretation
- No dynamic loading

Any attempt to mutate context mid-execution → **HALT**

---

## `ai.project.json` Requirement

For **project-bound intents**, `ai.project.json` is **mandatory**.

Project-bound intents include:
- `architecture`
- `domain`
- `code_generation`
- `code_review`
- `refactor`
- `debugging`
- `planning`

If `ai.project.json` is missing → **HALT**

---

## Bootstrap Exception — `generate_context`

The intent `generate_context` is a **single, explicit exception**
to the `ai.project.json` requirement.

### Rules

- `ai.project.json` MAY be absent
- Sandbox remains **ENABLED**
- Write permission is granted **ONLY** for `ai.project.json`
- Output MUST be exactly one file: `ai.project.json`
- No SAVE / RESTORE
- No additional context mutation

Any violation → **HALT**

---

## Context Validation Rules

Before execution, the orchestrator MUST validate that:

- Context is complete for the intent
- Context contains no conflicts
- Context does not contradict RESTORE memory
- Context does not violate architectural constraints
- Context is scoped to exactly ONE project

### Failure Classification

| Condition | Result |
|--------|--------|
| Missing required context | `ASK_USER` |
| Conflicting context | `HALT` |
| Cross-project context | `HALT` |

---

## Cross-Project Isolation (Absolute)

Context MUST be isolated per project.

Forbidden:
- Referencing other repositories
- Reusing schemas from other projects
- Assuming shared infrastructure
- Using historical memory from unrelated work

Violation → **HALT**

---

## Plugin Context Rules

Plugins MAY contribute context ONLY if:

- Plugin is explicitly enabled
- Plugin contract is loaded
- Plugin scope is declared
- Plugin context does not override core context

Plugins MUST NOT:
- Mutate core context
- Inject hidden instructions
- Load external memory

Violation → **HALT**

---

## Missing Context Handling

If required context is missing and cannot be inferred:

The ONLY allowed response is:

> **"Insufficient context."**

No assumptions.
No extrapolation.
No partial execution.

---

## Final Rule

If there is **any uncertainty** about:

- Whether context is sufficient
- Whether context applies
- Whether context conflicts exist

→ **ASK USER**
→ **DO NOT GUESS**
→ **DO NOT PROCEED**

Correct non-execution is compliant behavior.
