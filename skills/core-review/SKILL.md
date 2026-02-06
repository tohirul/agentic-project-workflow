---
name: orchestrating-core-review
description: Strict governance for Architectural Decision Records (ADRs) and high-level domain modeling. Enforces the "No ADR, No Architecture" rule and binds Tier-A models to the architecture lifecycle.
---

# Core Review & Architecture Governance (Authoritative)

This skill defines the **control plane** for all architectural changes, domain modeling, and system design decisions.

It operates under the **"Constitutional Model"**:

1.  Architecture is Law.
2.  ADRs are the Amendments.
3.  No change to Law without an Amendment.

---

## Governing Documents

The following documents are **authoritative** for this skill:

- **`ADR.md`**: Defines the strict protocol for creating and verifying decisions.
  - If `ADR.md` conflicts with this file, **`ADR.md` wins**.

---

## Scope & Applicability

This skill is **MANDATORY** and **AUTOMATICALLY ACTIVATED** when the intent is:

- `architecture`
- `domain`

It MAY be activated for:

- `refactor` (if the refactor crosses module boundaries)

It is **FORBIDDEN** for:

- `chat`
- `debugging`
- `summarize` (except when summarizing existing ADRs)

---

## Core Guarantees

1.  **Immutability:** Once an ADR is `Accepted` and `SAVE`d, it cannot be modified without a superseding ADR.
2.  **Traceability:** Every architectural code change must link back to an ADR slug.
3.  **Tier Enforcement:** Only **Tier-A** models (Gemini 2.5 Pro, GPT-5.2 Codex) may author ADRs.

---

## Execution Lifecycle Binding

This skill injects logic into the following `lifecycle.md` phases:

### Phase 2 — Context Assembly

- **Action:** `RESTORE` existing ADRs from `docs/adr/`.
- **Purpose:** Ensure the model knows the current laws before proposing new ones.

### Phase 5 — Execution

- **Action:** Generate `ADR-YYYYMMDD-slug.md` per the template in `ADR.md`.
- **Constraint:** Output must be strictly structured Markdown.

### Phase 6 — Verification

- **Check:** Does the output follow the `ADR.md` template?
- **Check:** Are all sections (Context, Decision, Consequences) present?
- **Check:** Is the status valid (Proposed/Accepted)?

### Phase 9 — Memory Synchronization (SAVE)

- **Action:** Persist the verified ADR to `docs/adr/`.
- **Constraint:** Filesystem write is allowed **only** if Verification passed.

---

## Failure Modes

- **Missing ADR:** If `architecture` intent yields code but no ADR → **HALT**.
- **Weak Model:** If a Tier-B/C/D model attempts to write an ADR → **HALT**.
- **Template Violation:** If the output misses "Consequences" or "Status" → **REJECT**.

---

## Final Rule

**Code is transient. Decisions are permanent.**
We optimize for the decision record, not the implementation detail.
