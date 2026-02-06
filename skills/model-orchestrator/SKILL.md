---
name: orchestrating-multi-model-ai
description: Deterministic orchestration of multiple AI models based on intent, context, lifecycle phase, authority tier, and cost governance. Enforces routing, verification, memory safety, and burnout prevention across long-running workflows.
---

# Multi-Model AI Orchestrator — Authoritative Skill

## 1. Purpose and Scope

This skill defines the control plane for environments where multiple AI models coexist.

The orchestrator does not reason.  
The orchestrator governs reasoning.

Its responsibility is to deterministically enforce:

- Which model may act
- In what role
- With which context
- Under which constraints
- At which lifecycle phase

No model, agent, plugin, or runtime component may bypass this skill.

---

## 2. Absolute Governing Principles

- Context is authoritative, not the model
- Lifecycle order is absolute
- Routing is deterministic, never heuristic
- Authority is model-based, not intent-based
- Free models are assistive, never final
- Preview models are advisory, never mutative
- No model may escalate itself
- No output is accepted without verification

Violation of any principle → HARD HALT

---

## 3. Applicability Rules

### MUST be activated when:
- More than one AI model is available
- Cost, latency, or burnout must be governed
- Context must persist across steps or sessions
- SAVE / RESTORE memory is involved
- Architectural or domain correctness matters
- The task spans multiple lifecycle phases

### MUST NOT be used for:
- Single-turn casual chat
- Trivial, isolated snippets
- Non-project-bound questions
- Freeform brainstorming without validation

---

## 4. Lifecycle Supremacy

The execution lifecycle is defined exclusively in `lifecycle.md`.

This file defines policy and enforcement, not phase order.

If any conflict exists:
→ lifecycle.md wins

---

## 5. Canonical Lifecycle Alignment

All tasks follow the lifecycle defined in lifecycle.md:

0. State Validation  
1. Intent Classification  
2. Context Assembly  
2a. Context Bootstrap (conditional)  
3. Model Selection  
4. Delegation  
5. Execution  
6. Verification  
7. Intervention (conditional)  
8. Telemetry Finalization  
9. Memory Synchronization (SAVE)  
10. Task Termination  

No deviation is permitted.

---

## 6. Intent Classification (Phase 1)

Exactly ONE intent is resolved using intent-classifier.md.

Intent is immutable after resolution.

Ambiguous intent → ASK_USER  
Invalid intent → HALT

---

## 7. Context Assembly (Phase 2)

Context assembly is mandatory and occurs before any model or authority decision.

Inputs:
1. RESTORE memory (read-only)
2. ai.project.json
3. Task scope
4. User prompt

Context is frozen after assembly.

Failures:
- Missing context → ASK_USER
- Conflicts or leakage → HALT

---

## 8. Context Bootstrap (Phase 2a)

Entered only when intent = generate_context.

Rules:
- Sandbox enabled
- Write only ai.project.json
- No SAVE / RESTORE
- No other writes

Violation → HALT

---

## 9. Model Selection (Phase 3)

Model selection occurs after context assembly.

Rules:
- Follow selection.md
- Deterministic only
- Single resolved model
- No silent fallback

Failure → HALT

---

## 10. Authority Enforcement (After Phase 3)

Authority is a property of the selected model.

No authority checks may occur before model selection.

Early enforcement → lifecycle violation → HALT

---

## 11. Authority Tiers

### Tier-A — Primary
gemini-2.5-pro  
mistral-devstral2  
gpt-5.1-codex  
gpt-5.2-codex  

Capabilities: architecture, refactor, code generation, SAVE (when allowed)

### Tier-B — Secondary
gemini-2  
gemini-1.5-pro  
gemini-2-flash  
gemini-2.5-flash  
mistral-medium  
mistral-small  
gpt-4o  

Capabilities: debugging, planning, verified summaries

### Tier-C — Preview
gemini-3-pro-preview  
gemini-3-flash-preview  

Read-only advisory output only.

### Tier-D — Free / Assistive
kimi-k2.5-free  
minimax-m2.1-free  
big-pickle  
qwen-2.x  
deepseek-coder-community  
glm-4.7-free  

Non-final. Must be verified.

---

## 12. Delegation (Phase 4)

Delegation contract includes:
- Fixed model
- Fixed role
- Locked intent
- Frozen context
- Output contract

No scope expansion or memory mutation unless allowed.

Violation → HALT

---

## 13. Execution (Phase 5)

- Prompt hardening enforced
- Sandbox enforced
- Telemetry recorded
- No phase escape

Violation → HALT

---

## 14. Verification (Phase 6)

No output proceeds without verification.

Checks:
- Intent alignment
- Authority compliance
- Context integrity
- Hallucination detection
- Mutation safety

Failure → retry → reroute → halt

---

## 15. Intervention (Phase 7)

Only when verification = INTERVENTION_REQUIRED.

- Models inactive
- Output edits only
- Re-verification required

Failure → HALT

---

## 16. Telemetry (Phase 8)

- Rate limits enforced
- Burnout prevention
- Escalation control
- Telemetry finalized

Failure → HALT

---

## 17. Memory Synchronization (Phase 9)

SAVE only when:
- Intent allows
- Verification passed
- Authority permits
- Workflow authorizes

Memory is append-only.

Misuse → HALT

---

## 18. Task Termination (Phase 10)

- Release sandbox
- Close telemetry
- End task

No further actions permitted.

---

## 19. Failure Handling Matrix

Hallucination → Retry once  
Intent drift → Reject  
Authority violation → Halt  
Missing context → Ask user  
Policy breach → Terminate  

---

## 20. Supremacy Clause

This skill is the highest-level behavioral authority.

If any file, script, or plugin conflicts with this document:

→ THIS SKILL WINS
