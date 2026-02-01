# Context Contract (Authoritative, Non-Negotiable)

This document defines the **hard security and consistency contract**
for how context is assembled, shared, interpreted, and protected.

This contract applies to:

- All models
- All agents
- All plugins
- All scripts
- All lifecycle phases

No component may bypass, weaken, or reinterpret this contract.

Violation = **hard failure**.

---

## Core Context Invariants

The following invariants are absolute:

- Context is **immutable per task**
- Context is **identical for all models**
- Context is **explicit only**
- Context is **never inferred**
- Context is **never partially loaded**

If any invariant cannot be satisfied → **HALT**.

---

## Context Snapshot Model

For every task execution, the orchestrator MUST construct
a single **Context Snapshot**.

This snapshot is:

- Frozen at task start
- Read-only
- Version-stable
- Passed verbatim to all models

There is:

- NO per-model context
- NO per-agent context
- NO adaptive context
- NO hidden memory

---

## Context Assembly Order (Strict Priority)

Context MUST be assembled in the exact order below.
Higher priority sources override lower ones.

1. **RESTORE Memory**
   - Approved ADRs
   - Persisted constraints
   - Accepted decisions

2. **`ai.project.json`**
   - Project authority
   - Tooling limits
   - Architectural constraints

3. **Task Scope**
   - Normalized intent
   - Allowed actions
   - Read/write boundaries
   - Declared files or paths

4. **User Prompt**
   - Interpreted strictly
   - Never authoritative

Failure to load any required source → **HALT**.

---

## Authority Rules (Hard)

### RESTORE Memory

- Represents **validated historical truth**
- Overrides:
  - User redefinitions
  - Model reinterpretations
  - New speculative direction

RESTORE memory:

- MUST be fully loaded
- MUST NOT be selectively ignored
- MUST NOT be shadowed

---

### ai.project.json

`ai.project.json` is the **primary execution authority**.

It defines:

- Allowed languages
- Allowed tools
- Forbidden patterns
- Architectural constraints
- Module system
- Application style

Any output violating `ai.project.json` → **hard failure**.

---

### Task Scope

Task scope:

- MUST be explicit
- MUST be immutable
- MUST include:
  - intent
  - permissions
  - boundaries

Task scope MAY NOT:

- Expand implicitly
- Be reinterpreted by models
- Be overridden by user phrasing

Scope expansion requires **explicit user approval**.

---

### User Prompt

User prompt has **lowest authority**.

It MAY:

- Ask questions
- Request clarification
- Operate within scope

It MAY NOT:

- Override constraints
- Select models
- Modify memory
- Bypass sandbox
- Redefine architecture

---

## Model Permissions

Models MAY:

- Read context snapshot
- Quote context verbatim
- Validate outputs against context
- Report conflicts or missing data

Models MAY NOT:

- Modify context
- Invent missing fields
- Assume defaults
- Infer intent
- Fill gaps creatively
- Normalize ambiguity
- Rewrite history

---

## Missing Context Handling (Mandatory)

If any required context element is missing:

The model MUST:

1. STOP execution
2. Explicitly name the missing context
3. Ask the user OR fail safely

The model MUST NOT:

- Guess
- Assume industry defaults
- Import patterns from training data
- Proceed conditionally

Ambiguity ≠ permission.

---

## Conflict Resolution Rules (Deterministic)

| Conflict                        | Resolution              |
| ------------------------------- | ----------------------- |
| User prompt vs ai.project.json  | ai.project.json         |
| User prompt vs RESTORE          | RESTORE                 |
| Task scope vs user prompt       | Task scope              |
| SAVE vs existing RESTORE        | RESTORE                 |
| Model suggestion vs constraints | Constraints             |
| Model disagreement              | Highest-authority model |
| Unresolvable conflict           | HALT + ask user         |

No silent resolution is allowed.

---

## Context Mutation Rules

Context mutation is **forbidden by default**.

The ONLY valid mutation paths are:

- SAVE (post-verification, milestone-based)
- ADR workflow (architecture intent only)

Forbidden mutation paths include:

- Model output
- Plugin side effects
- Script execution
- Suggested changes
- “Recommended updates”

Silent mutation = **critical violation**.

---

## Tier-Specific Context Restrictions

### Tier-D / Free / Community Models

- Context is strictly read-only
- Output MUST be marked non-authoritative
- Output MUST be verified by Tier-A or Tier-B
- Cannot introduce new concepts or constraints

---

### Preview Models

Preview models MAY:

- Reason
- Compare
- Propose options

Preview models MAY NOT:

- Write files
- Generate tasks
- Trigger SAVE / RESTORE
- Declare decisions
- Mutate context

Violation → **hard failure, no retry**.

---

## Enforcement Guarantees

The following principles always apply:

- Context integrity > output quality
- Explicit state > inferred state
- Determinism > creativity
- Verification > convenience
- Safety > speed

---

## Final Enforcement Rule

If a model, agent, or plugin cannot operate
**entirely within this contract**:

→ It MUST refuse execution  
→ It MUST explain the blocking issue  
→ It MUST NOT proceed

There are **no exceptions**.
