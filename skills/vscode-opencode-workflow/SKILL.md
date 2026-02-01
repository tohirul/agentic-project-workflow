---
name: orchestrating-vscode-opencode-workflows
description: Deterministic, script-driven orchestration layer binding VS Code and OpenCode into a strictly project-scoped workflow. Enforces validation, lifecycle sequencing, and editor-first execution with zero inference.
---

# VS Code + OpenCode Workflow Orchestrator (Authoritative)

This skill defines the **only valid orchestration layer** for coordinating
VS Code, OpenCode, scripts, and plugins inside a single project workspace.

This orchestrator:

- **Does not reason**
- **Does not infer**
- **Does not recover**
- **Does not decide**

It **coordinates deterministic execution only**, as defined by contract.

---

## Fixed System Roles

- **VS Code** — system of record  
- **OpenCode** — scoped execution surface  
- **Scripts (`scripts/`)** — filesystem, detection, validation authority  
- **Plugins** — isolated expertise, no autonomy

---

## Core Guarantees

- No cross-project context leakage  
- No inference or fallback behavior  
- No silent plugin activation  
- No autonomous editor control  
- No non-reproducible execution  

Failure → **halt immediately**

---

## Governing Contract

- `CONTRACT.md` is authoritative  
- Conflicts → `CONTRACT.md` wins  
- No reinterpretation or recovery allowed

---

## Canonical Execution Checklist

- Resolve project root  
- Detect stack  
- Verify OpenCode CLI  
- Validate ai.project.json  
- Resolve plugins  
- Bind session  
- Attach to VS Code  
- Enforce scope  

---

## Execution Phases

### Phase 1 — Detection
`scripts/detect-project.zsh`

### Phase 2 — Context Creation
`scripts/generate-context.zsh`

### Phase 3 — Validation
`scripts/validate-context.zsh`

### Phase 4 — Execution
OpenCode attaches to VS Code

---

## Script Authority

Scripts are authoritative.  
No inference. No auto-fix. No guessing.

---

## Memory Rules

This workflow layer NEVER reads or writes memory.

---

## Final Rule

If interpretation is required → **STOP**  
Determinism > convenience
