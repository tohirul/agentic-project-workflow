# Architecture Decision Record (ADR) — Authoritative Protocol

This file defines the **only valid mechanism** for creating, validating,
storing, and enforcing architectural decisions under the
Multi-Model AI Orchestrator.

ADRs are **mandatory**, **versioned**, and **governance-bound**.

No ADR → No architecture.

---

## When ADRs Are REQUIRED

An ADR MUST be created when **intent = architecture** or **intent = domain**.

Triggers include (non-exhaustive):

- System or service design
- Architectural refactor proposals
- Domain model changes
- Technology adoption or replacement
- Long-term scalability decisions
- Boundary or ownership changes
- Trade-off analysis with a final decision

If architecture intent is detected and no ADR is produced → **output is INVALID**.

---

## ADR Authority & Model Rules

- ADRs may be generated ONLY by:
  - **Gemini 2.5 Pro** (Tier-A)
  - **Gemini 3 Pro Preview** (Tier-C, read-only, OPT-IN)

- Preview models:
  - MAY draft ADRs
  - MAY NOT finalize or SAVE without Tier-A verification

- Free / Tier-D models:
  - MAY NOT generate ADRs
  - MAY NOT influence decisions

---

## ADR Lifecycle Integration

ADR creation is bound to the orchestrated lifecycle:

| Phase    | Action                         |
| -------- | ------------------------------ |
| Phase 4  | RESTORE prior ADRs (mandatory) |
| Phase 5  | Generate ADR (read-only)       |
| Phase 9  | Verify ADR                     |
| Phase 10 | SAVE ADR (explicit gate)       |

Any ADR created outside this flow is **non-authoritative**.

---

## ADR File Naming (Strict)

ADR-YYYYMMDD-short-slug.md

---

## ADR Template (MANDATORY)

# ADR-YYYYMMDD-short-slug

## Status

Proposed | Accepted | Rejected | Superseded

## Context

Describe the current factual state.
Must reference ai.project.json and prior ADRs.

## Decision Drivers

List business, technical, and operational forces.

## Considered Options

At least one rejected alternative is mandatory.

## Decision

Single chosen approach with explicit trade-offs.

## Consequences

Positive outcomes and accepted risks.

## Validation Plan

Observable and testable validation steps.

## Scope & Boundaries

What is included and excluded.

## Impacted Areas

Code, services, teams, data, infra.

## Supersedes / Related ADRs

If applicable.

## Approval

Authority and date.

---

## Enforcement Rules

- No ADR → architecture output rejected
- No implementation code allowed
- Must reference ai.project.json
- Must include trade-offs

---

## Final Rule

ADRs are law, not documentation.
