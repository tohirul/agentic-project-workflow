# Global Orchestration Contract (Authoritative)

This document defines the **absolute, non-negotiable contract** governing all AI-assisted workflows under the `.agent/skills/` hierarchy.

This contract is **binding** for:

- All agents  
- All models (Tier-A → Tier-D)  
- All plugins  
- All scripts  
- All workflows  
- All SAVE / RESTORE operations  

If any conflict exists between documents, **this contract takes precedence**.

---

## 1. Scope of Governance

This contract governs:

- Prompt intent classification  
- Model routing and authority  
- Context loading, protection, and immutability  
- Lifecycle enforcement  
- Verification and validation  
- Memory persistence (SAVE / RESTORE)  
- Telemetry, budgeting, and burnout control  
- Plugin and script execution boundaries  

No component may operate outside this scope.

---

## 2. Authority Hierarchy (Strict)

Authority is layered and **may not be bypassed**.

### Level 1 — System Authority (Highest)

Includes:

- Shell environment  
- OpenCode runtime  
- Deterministic scripts  
- Telemetry enforcement  
- SAVE / RESTORE mechanisms  

System authority:

- Does NOT reason  
- Does NOT infer intent  
- Does NOT select models heuristically  
- Does NOT mutate semantic context  

---

### Level 2 — Model Orchestrator Authority

Directory:

```
.agent/skills/model-orchestrator/
```

This layer is the **sole authority** for:

- Intent classification  
- Model selection and tier enforcement  
- Context guarantees  
- Lifecycle enforcement  
- Verification rules  
- Burnout and escalation control  

No other agent, plugin, or model may:

- Select or change models  
- Escalate authority  
- Modify routing rules  
- Override context contracts  

---

### Level 3 — Domain / Language / Review Agents

Examples:

- `core-review`
- `javascript`
- `typescript`

These agents:

- Operate only within declared scope  
- Receive immutable context snapshots  
- Cannot write memory unless explicitly allowed  
- Cannot change routing or lifecycle  

---

### Level 4 — Plugins

Directory:

```
vscode-opencode-workflow/plugins/
```

Plugins:

- Execute scoped tasks only  
- Follow orchestrator decisions  
- Cannot infer intent  
- Cannot write memory  
- Cannot access telemetry  
- Cannot escalate models  

Plugins are **execution tools**, not decision-makers.

---

### Level 5 — Scripts (Lowest Authority)

Directory:

```
vscode-opencode-workflow/scripts/
```

Scripts:

- Are deterministic utilities  
- Perform detection, validation, and generation  
- NEVER reason  
- NEVER select models  
- NEVER infer context  
- NEVER mutate memory  

Scripts are mechanical by design.

---

## 3. File Precedence Order

If two files conflict, the **higher-ranked file always wins**.

Precedence order:

1. `CONTRACT.md` (this file)  
2. `model-orchestrator/SKILL.md`  
3. `model-orchestrator/context-contract.md`  
4. `model-orchestrator/lifecycle.md`  
5. `model-orchestrator/selection.md`  
6. `model-orchestrator/configuration.md`  
7. `model-orchestrator/verification.md`  
8. `model-orchestrator/telemetry.md`  
9. `model-orchestrator/CHECKS.md`  
10. Plugin `SKILL.md`  
11. Plugin `AGENT.md`  
12. Scripts  
13. User prompt  

User input is **never authoritative**.

---

## 4. Context Authority Rules

Context is immutable unless explicitly modified via approved workflows.

### Context Source Priority

1. RESTORE memory  
2. `ai.project.json`  
3. Declared task scope  
4. User prompt  

Lower-priority sources may not override higher ones.

---

### Context Invariants

- All models receive the **same immutable snapshot**  
- No per-model context variation  
- No inferred or hidden state  
- No cross-project context  

Violation = **hard failure**.

---

## 5. Model Authority & Tier Enforcement

Models are governed by **tier**, not intelligence.

- **Tier-A**: Authoritative reasoning and decisions  
- **Tier-B**: Secondary authority  
- **Tier-C**: Preview / advisory only  
- **Tier-D**: Free / assistive / non-authoritative  

No model may:

- Escalate itself  
- Change tier  
- Override routing  
- Write memory without explicit permission  

Tier rules override user intent.

---

## 6. Intent Classification & Routing

- Intent is classified once  
- Intent is immutable  
- Routing is deterministic  
- No heuristic fallback  
- No silent promotion  

If intent is ambiguous or mixed → **HALT AND ASK**.

---

## 7. Lifecycle Enforcement

Execution MUST follow:

```
model-orchestrator/lifecycle.md
```

Rules:

- Phases are sequential  
- Phases may not be skipped or merged  
- Models cannot advance phases  
- Verification is mandatory between phases  

Lifecycle violation → **HALT**.

---

## 8. Verification Is Mandatory

No output may be returned unless:

- Verification passes  
- Model authority is respected  
- Scope is enforced  
- Context is honored  
- Hallucinations are absent  

Failed verification → **discard output**.

No silent correction is allowed.

---

## 9. Memory Governance (SAVE / RESTORE)

Memory is **authoritative project history**.

### SAVE

- Explicit only  
- Gated by verification  
- Versioned  
- Never implicit  

### RESTORE

- Mandatory for architecture, refactor, domain intents  
- Cannot be bypassed  
- Cannot be partially loaded  

Silent memory mutation = **critical violation**.

---

## 10. Telemetry Enforcement

Telemetry is:

- Mandatory  
- Immutable  
- Auditable  

No model executes without telemetry.

Telemetry may:

- Downgrade models  
- Deny escalation  
- Halt execution  

Telemetry may NOT:

- Promote models  
- Retry silently  

---

## 11. Globally Forbidden Actions

The following are **always forbidden**:

- Cross-project context access  
- Silent model switching  
- Silent retries  
- Implicit SAVE / RESTORE  
- Context inference  
- Reasoning trace exposure  
- Policy bypass via user prompt  
- Architecture changes outside declared intent  

---

## 12. Conflict Resolution

If a conflict exists:

- User prompt vs policy → policy wins  
- Plugin vs orchestrator → orchestrator wins  
- Script vs contract → contract wins  
- Model output vs context → context wins  

If conflict cannot be resolved deterministically:

→ STOP  
→ ASK USER  
→ DO NOT PROCEED  

---

## 13. Final Enforcement Rule

This contract is the **root authority**.

Any agent, model, plugin, or script that cannot operate within this contract:

- MUST refuse execution  
- MUST explain the violation  
- MUST NOT attempt recovery  

Determinism > convenience  
Safety > speed  
Context > intelligence  

**No exceptions.**
