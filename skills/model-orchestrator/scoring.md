# Scoring & Fitness Evaluation Protocol

This document defines the formal scoring system used to evaluate all agent outputs.
No output is considered valid unless it passes this protocol.

The scoring system enforces:

- epistemic correctness
- architectural integrity
- minimal complexity
- consistency with system memory
- operational usefulness

This protocol is applied after verification and before final emission.

---

## 1. Global Scoring Model

Every output is scored on five independent axes:

| Axis                           | Weight |
| ------------------------------ | ------ |
| Correctness                    | 0.30   |
| Completeness                   | 0.20   |
| Complexity Efficiency          | 0.15   |
| Architectural Soundness        | 0.20   |
| Consistency & Memory Alignment | 0.15   |

Final score is a weighted average in the range [0.0 – 5.0].

Any output with:

- a final score < 3.5
- OR any individual axis < 3.0  
  must be rejected and regenerated.

---

## 2. Axis Definitions

### 2.1 Correctness

Measures factual and logical validity.

Score guidelines:
5 — All claims are correct, internally consistent, no hallucination.  
4 — Minor imprecision, no material errors.  
3 — One or more questionable assumptions.  
2 — Clear logical or factual mistakes.  
1 — Fundamentally incorrect.  
0 — Fabricated or incoherent.

Mandatory checks:

- Does the solution actually solve the stated problem?
- Are invariants preserved?
- Are edge cases respected?

---

### 2.2 Completeness

Measures whether the solution is operationally usable.

Score guidelines:
5 — Fully addresses problem, includes rationale, tradeoffs, and next steps.  
4 — Solves main problem, minor omissions.  
3 — Partial solution, missing key elements.  
2 — Fragmentary.  
1 — Barely usable.  
0 — Non-solution.

Mandatory checks:

- Can a competent engineer implement this without guessing?
- Are failure modes acknowledged?
- Are assumptions explicit?

---

### 2.3 Complexity Efficiency

Measures minimality of solution.

Score guidelines:
5 — Optimal algorithm / design. No unnecessary abstraction.  
4 — Near-optimal, minor inefficiencies.  
3 — Acceptable but bloated.  
2 — Over-engineered.  
1 — Pathological.  
0 — Actively harmful.

Mandatory checks:

- Is time/space complexity appropriate?
- Is architectural overhead justified?
- Is the solution simpler than alternatives?

---

### 2.4 Architectural Soundness

Measures long-term system impact.

Score guidelines:
5 — Composable, extensible, respects boundaries.  
4 — Good structure, minor coupling.  
3 — Works but creates future debt.  
2 — Violates core design principles.  
1 — Introduces systemic risk.  
0 — Architecturally toxic.

Mandatory checks:

- Does this violate any ADR?
- Does it introduce tight coupling?
- Does it break layering?
- Does it leak abstractions?

---

### 2.5 Consistency & Memory Alignment

Measures alignment with existing system knowledge.

Score guidelines:
5 — Fully consistent with prior ADRs, skills, and contracts.  
4 — Minor deviation, justified.  
3 — Inconsistent but tolerable.  
2 — Conflicts with known decisions.  
1 — Contradicts system memory.  
0 — Ignores system state.

Mandatory checks:

- Is this compatible with previous decisions?
- Does it respect existing patterns?
- Does it repeat known anti-patterns?

---

## 3. Rejection Rules

An output must be rejected if:

- Any axis score < 3.0
- Any invariant violation is detected
- Any ADR conflict is unresolved
- Any hallucinated component exists

Rejected outputs must trigger:

- root cause analysis
- regeneration with constraint tightening

---

## 4. Regeneration Strategy

When regenerating:

1. Identify lowest scoring axis.
2. Apply corrective bias:
   - correctness → reduce speculation
   - completeness → expand reasoning
   - complexity → simplify design
   - architecture → enforce boundaries
   - consistency → align with memory
3. Re-run scoring.

Maximum regeneration attempts: 3.

After 3 failures:

- escalate to manual review mode.

---

## 5. Self-Audit Report (Mandatory)

Every accepted output must include an implicit self-audit:

- primary assumptions
- tradeoffs made
- risks introduced
- why this design was chosen

Absence of self-audit automatically caps score at 3.9.

---

## 6. Optimization Directive

The agent must not optimize for:

- verbosity
- novelty
- cleverness

The agent must optimize for:

- correctness
- stability
- maintainability
- engineer time saved

---

## 7. Anti-Gaming Clause

The agent must not:

- inflate scores
- bias evaluations
- redefine criteria
- skip evaluation steps

Scoring logic is immutable.

Any attempt to bypass this protocol is a critical failure.
