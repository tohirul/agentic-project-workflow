# System Configuration (Authoritative)

This file defines the **static configuration layer** for the
Multi-Model AI Orchestrator.

Configuration is **policy**, not preference.
All values here are **authoritative and immutable at runtime**.

If configuration conflicts with any other file,
**this file defers to CONTRACT.md only**.

---

## Configuration Philosophy

- Configuration declares what is allowed, not what is convenient
- Runtime behavior must be derivable from configuration alone
- No heuristic interpretation is permitted
- Explicit is always safer than implicit

Correctness > flexibility  
Governance > autonomy  

---

## Authority Hierarchy (Reminder)

Enforcement precedence:

1. CONTRACT.md
2. This file (`configuration.md`)
3. selection.md
4. lifecycle.md
5. checks / verification
6. plugins
7. scripts
8. user input

Lower layers may **never override** higher layers.

---

## Model Inventory (Logical)

This section declares **logical model identities**
used throughout the system.

Logical IDs MAY be resolved to physical models via
the resolution layer below.

### Tier-A — Primary Authority

- gpt-5.2-codex
- gpt-5.1-codex
- mistral-devstral2
- gemini-2.5-pro

### Tier-B — Secondary Authority

- gemini-2
- gemini-1.5-pro
- gemini-2-flash
- mistral-medium
- mistral-small
- gpt-4o

### Tier-C — Preview / Restricted

- gemini-3-pro-preview
- gemini-3-flash-preview

### Tier-D — Free / Assistive

- kimi-k2.5-free
- minimax-m2.1-free
- big-pickle
- qwen-2.x
- deepseek-coder-community
- glm-4.7-free

If a model is not listed here, it is **not allowed anywhere**.

---

## Model Resolution Layer (Mandatory)

Logical model IDs MUST be resolved to
actual runtime models via this mapping.

No silent substitution is allowed.

```yaml
model_resolution:
  gpt-5.2-codex:
    primary: gpt-5.2-codex
    fallback:
      - gpt-4o
    capability_profile: codex_high

  gpt-5.1-codex:
    primary: gpt-5.1-codex
    fallback:
      - gpt-4o
    capability_profile: codex_high

  gemini-2.5-pro:
    primary: gemini-2.5-pro
    fallback:
      - gemini-1.5-pro
    capability_profile: gemini_mid

  mistral-devstral2:
    primary: mistral-devstral2
    fallback: []
    capability_profile: mistral_exec
```

### Resolution Rules

- If `primary` is unavailable → try `fallback` in order
- If all fail → **HALT**
- Resolved model MUST respect original tier restrictions
- Resolution MUST be logged to telemetry

---

## Capability Profiles (Authoritative)

Capability profiles define **hard runtime limits**
used by telemetry and burnout enforcement.

```yaml
capability_profiles:
  codex_high:
    max_calls_per_task: 6
    max_retries: 1
    max_tokens: 64000

  gemini_mid:
    max_calls_per_task: 4
    max_retries: 1
    max_tokens: 32000

  mistral_exec:
    max_calls_per_task: 8
    max_retries: 1
    max_tokens: 32000

  preview_readonly:
    max_calls_per_task: 2
    max_retries: 0
    max_tokens: 16000

  free_assistive:
    max_calls_per_task: 3
    max_retries: 0
    max_tokens: 16000
```

If capability profile is exceeded → **HALT**

---

## Role Definitions (Closed Set)

Every model invocation MUST declare exactly one role.

| Role | Description |
|----|-------------|
| `router` | Intent resolution and routing only |
| `assistant` | Non-authoritative analysis |
| `reviewer` | Read-only evaluation |
| `architect` | Architectural decision-making |
| `executor` | Code or refactor execution |

Role misuse → **HALT**

---

## Retry & Escalation Policy (Static)

- Max retries per task: **1**
- Retry MUST use the same resolved model
- No automatic escalation
- No automatic promotion to higher tiers
- Escalation requires explicit user approval AND telemetry justification

Violation → **HALT**

---

## SAVE / RESTORE Authority (Reminder)

- SAVE is a system action, never a model action
- SAVE permitted only for:
  - architecture
  - domain
  - refactor
- RESTORE required for:
  - architecture
  - domain
  - refactor

Misuse → **HALT**

---

## Forbidden Configuration Patterns

The following are explicitly forbidden:

- Wildcard model routing
- Implicit fallback
- Dynamic tier reassignment
- Model self-selection
- Runtime mutation of this file

Detection → **HALT**

---

## Final Rule

If configuration is missing, incomplete, or contradictory:

→ **DO NOT EXECUTE**
→ **HALT EXPLICITLY**

Correct refusal is compliant behavior.
