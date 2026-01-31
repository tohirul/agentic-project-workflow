---
name: core-architectural-review
description: Performs deterministic architectural and code reviews for project-scoped changes. Evaluates system design, code diffs, and pull request changes for architectural integrity, scalability, security, and maintainability using explicit inputs only.
---

# Core Architectural Review

This skill provides a **deterministic, project-scoped review workflow** for evaluating
code and design changes against established architectural principles.

It is designed to support:

- Architectural correctness
- Long-term maintainability
- Scalability and security posture
- Explicit, reviewable feedback

This skill **does not execute changes**.
It only analyzes and reports.

---

## When to Use This Skill

Use this skill **only** when one or more of the following apply:

- Reviewing a pull request or diff
- Evaluating architectural impact of changes
- Assessing system design decisions
- Performing security, performance, or scalability reviews
- Reviewing refactors, migrations, or boundary changes

Do **not** use this skill for:

- Code generation
- Refactoring execution
- Automated fixing
- Context inference
- Non-project-bound discussions

---

## Review Scope

This skill operates on **explicit inputs only**, such as:

- Code diffs
- Pull request descriptions
- File paths
- Architecture summaries
- Explicit change descriptions

It does NOT:

- Fetch external data
- Infer missing context
- Assume system architecture
- Modify files or repositories

---

## Execution Model

All reviews follow this **fixed sequence**:

---

### 1. Input Analysis

The agent must explicitly identify:

- Files changed
- Nature of change (feature, bug fix, refactor, breaking)
- Affected architectural layers
- Security-sensitive or data-sensitive areas

If inputs are insufficient → **halt and request clarification**.

---

### 2. Architectural Evaluation

The review must evaluate changes against:

- Clean Architecture / layered boundaries
- Dependency direction and coupling
- SOLID principles
- Bounded context integrity (if applicable)
- API compatibility and versioning
- Data ownership and consistency
- Security boundaries

---

### 3. Risk Classification

Each finding must be classified as one of:

- **CRITICAL** – architectural or security violation
- **HIGH** – scalability, reliability, or correctness risk
- **MEDIUM** – maintainability or design concern
- **LOW** – stylistic or minor improvement
- **INFO** – observation or suggestion

Severity must be justified explicitly.

---

### 4. Recommendation Output

For each finding, the review must provide:

- File path and line reference (if applicable)
- Clear description of the issue
- Architectural principle violated or impacted
- Concrete remediation guidance
- Effort estimate (trivial / easy / medium / hard)

No automatic fixes are applied.

---

## Output Format

All findings must be structured and explicit.

Recommended structure:

```text
- Path: src/auth/login.ts
- Line: 42
- Severity: CRITICAL
- Category: Architecture / Security / Performance / Maintainability
- Issue:
  Short, precise description of the problem.
- Impact:
  Why this matters architecturally or operationally.
- Recommendation:
  Concrete, actionable fix or design adjustment.
```
