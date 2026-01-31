# Context Restore Workflow

This workflow restores a **previously saved, explicit project context**
into the current VS Code + OpenCode session.

Context restoration is:

- Explicit
- Deterministic
- Project-scoped
- Non-inferential

No semantic enrichment, ranking, or reconstruction is performed.

---

## Purpose

Restore **exactly what was saved** so that a project can be resumed
without ambiguity, context drift, or information loss.

This workflow prioritizes **fidelity and safety** over completeness.

---

## Restore Scope

This workflow restores only:

- Project root identity
- Saved project context snapshot
- Active plugins at time of save
- Selected workflow example (if any)
- Timestamp and metadata

It does NOT restore:

- Chat history
- Reasoning traces
- Global memory
- Cross-project knowledge
- Inferred or derived context

---

## Preconditions (All Required)

Before restoration may proceed:

- `.opencode/context.json` exists
- Current project root is known
- Saved project root matches current project root
- User explicitly requested restoration

If any precondition fails → **halt**.

---

## Restore Source

Context is restored from:

- `.opencode/context.json`

---
