# Long-Term Memory Synchronization (Authoritative)

Memory is **authoritative and durable**.  
Conversation is **ephemeral and disposable**.

No decision is considered real until it is **explicitly persisted**.
No memory may be written without passing verification.

---

## Memory Invariants (Non-Negotiable)

- Memory is **append-only**
- Memory is **versioned**
- Memory is **project-scoped**
- Memory is **human-reviewable**
- Memory is **never inferred**

Violation → **hard failure**

---

## Memory Domains

Memory is logically separated into the following domains:

1. **Architecture**
   - ADRs
   - System boundaries
   - Long-term design decisions

2. **Domain & Schema**
   - Domain models
   - Schema definitions
   - Invariants and constraints

3. **Constraints**
   - Forbidden patterns
   - Technology locks
   - Compliance rules

4. **Decision History**
   - Accepted decisions
   - Rejected alternatives
   - Trade-offs and rationale

No other memory domains are permitted.

---

## SAVE Policy (Strict)

SAVE is a **system action**, not a model action.

SAVE may occur **ONLY** when **all conditions** below are met.

### Mandatory Preconditions

All must be true:

- Verification phase passed
- Output intent ∈ {architecture, domain, refactor}
- Output is final and approved
- No unresolved conflicts exist
- SAVE is explicitly allowed by lifecycle phase

If any precondition fails → **SAVE is forbidden**

---

## Explicit SAVE Triggers

SAVE is permitted ONLY for:

- Approved ADR generation
- Accepted architectural decisions
- Approved refactors (post-review)
- Domain or schema evolution
- Constraint updates

SAVE is **NOT** permitted for:

- Planning
- Research
- Debugging notes
- Suggestions
- Drafts
- Partial implementations

---

## What Gets Saved (Allowed)

Only the following artifacts may be persisted:

- ADR documents
- Decision statements with rationale
- Explicit constraints
- Trade-off analyses
- Rejected alternatives (with reasons)
- Versioned schema or domain changes

All saved content MUST be:

- Deterministic
- Human-readable
- Traceable to verification

---

## What Is NEVER Saved (Forbidden)

Under no circumstances may the following be persisted:

- Raw chat transcripts
- Chain-of-thought or reasoning traces
- Model speculation
- Unverified outputs
- Intermediate drafts
- Canary results
- Tool logs

Attempted SAVE of forbidden data → **hard halt**

---

## RESTORE Policy (Mandatory)

RESTORE is a **blocking prerequisite** for certain intents.

### RESTORE is REQUIRED when:

- intent = architecture
- intent = domain
- intent = refactor
- resuming an existing project session

Failure to RESTORE → **halt execution**

---

## RESTORE Load Order (Deterministic)

Context is restored in the following strict order:

1. Approved ADRs
2. Active architectural constraints
3. Domain & schema definitions
4. Recent accepted decisions
5. Explicit TODOs (if present)

No other ordering is allowed.

---

## Conflict Detection & Handling

A conflict exists if restored memory:

- Contradicts current `ai.project.json`
- Contradicts detected stack
- Conflicts with user instruction
- Overlaps with incompatible changes

### Conflict Resolution Rules

If a conflict is detected:

1. STOP execution
2. Surface conflict clearly
3. Identify conflicting artifacts
4. Ask user to resolve

Models MAY NOT:

- Auto-resolve conflicts
- Prefer newer memory implicitly
- Discard memory silently

---

## Versioning Rules

- Every SAVE increments version
- No destructive overwrite
- Previous versions remain accessible
- ADRs are immutable once accepted

---

## Memory Safety Guarantees

- No cross-project memory access
- No implicit memory mutation
- No model-initiated SAVE
- No background memory writes
- No partial persistence

---

## Failure Matrix

| Failure Condition             | Action            |
| ----------------------------- | ----------------- |
| SAVE without verification     | Reject + halt     |
| RESTORE skipped when required | Halt              |
| Conflict detected             | Ask user          |
| Forbidden data in SAVE        | Terminate session |
| Memory corruption attempt     | Hard stop         |

---

## Final Rule

If there is **any uncertainty** about:

- what to save
- when to restore
- whether memory applies

→ **DO NOT SAVE**
→ **ASK THE USER**
→ **DO NOT PROCEED**
