# Context Save Workflow

This workflow captures and persists an **explicit snapshot of the current project context**
for later restoration.

Context saving is:

- Manual
- Deterministic
- Project-scoped
- Non-inferential

No semantic analysis, enrichment, or compression is performed.

---

## Purpose

Persist the **current, explicit context state** so a project can be resumed
without ambiguity, drift, or reliance on memory.

This workflow records **what is known**, not **what can be inferred**.

---

## Save Scope

This workflow captures **only explicit, declared state**, including:

- Project root identity
- `ai.project.json` contents (verbatim)
- Active plugins
- Active workflow example (if any)
- Timestamp and metadata

It does NOT capture:

- Chat history
- Reasoning traces
- Architectural inference
- Implicit knowledge
- Cross-project references
- Global or long-term memory

---

## Preconditions (All Required)

Before saving context:

- Project root is known
- `ai.project.json` exists
- Active OpenCode session exists
- User explicitly requested context save

If any precondition fails → **halt**.

---

## Save Target

Context is written to:

- `.opencode/context.json`

---
