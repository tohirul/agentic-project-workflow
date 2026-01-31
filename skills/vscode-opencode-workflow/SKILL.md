---
name: orchestrating-vscode-opencode-workflows
description: Orchestrates deterministic, project-scoped development workflows between VS Code and OpenCode. Use when the user requests editor-aware automation, context-bound coding, session restoration, or multi-step workflows tied to a project root.
---

# VS Code + OpenCode Workflow Orchestrator

This skill defines a **deterministic, editor-first execution model** where:

- **VS Code** is the single system of record
- **OpenCode** is a scoped execution and reasoning assistant
- **Plugins** provide isolated expertise without autonomy
- **Scripts** perform all environment detection and validation

The orchestrator **coordinates** these components.  
It does not improvise, infer, or compensate for missing state.

---

## Core Guarantees

This skill explicitly enforces the following guarantees:

- No global or cross-project context leakage
- No implicit assumptions about language, stack, or tooling
- No silent plugin activation
- No autonomous editor manipulation
- No non-reproducible execution paths
- No inference-based recovery behavior

If a requirement is unmet, the system **halts**.

---

## When to Use This Skill

Trigger this skill **only** when at least one of the following is true:

- The user explicitly references **VS Code**
- The user explicitly references **OpenCode**
- The task requires **project-aware or context-sensitive** execution
- The task involves bootstrapping, restoring, or synchronizing sessions
- The task spans multiple steps that must share a stable project context

Do **not** use this skill for:

- Isolated code snippets
- Purely conversational reasoning
- Tasks not bound to a project root

---

## Execution Model

All execution MUST follow the sequence below.  
Steps may **not** be skipped, reordered, or merged.

---

## Canonical Checklist

The agent MUST track progress using this checklist:

- [ ] Resolve absolute project root directory
- [ ] Detect primary language or stack
- [ ] Verify OpenCode CLI availability
- [ ] Validate project context (`ai.project.json`, if present)
- [ ] Resolve plugin compatibility
- [ ] Construct deterministic session identity
- [ ] Attach OpenCode to the VS Code workspace
- [ ] Enforce explicit task scope boundaries

Checklist state must be updated as execution proceeds.

---

## Plan → Validate → Execute

### 1. Plan

The agent must determine the following **without inference**:

- Absolute project root path
- Primary language or stack (single value)
- Presence of version control
- Presence of a project context file (`ai.project.json`)

No execution is permitted until all values are known explicitly.

---

### 2. Validate

The agent must validate all prerequisites using scripts and contracts:

- `opencode` CLI exists and is executable
- Project root contains at least one recognized marker
- `ai.project.json` (if present) passes validation
- Required plugins for the task exist
- Session identity is deterministic and non-colliding

If any validation fails:

- **Halt immediately**
- Report the failure clearly
- Do not attempt fallback, guessing, or recovery

---

### 3. Execute

Execution is strictly limited to:

- Launching or attaching OpenCode sessions
- Loading explicitly required plugins
- Synchronizing validated context with the active VS Code workspace

All execution must be:

- Idempotent
- Project-scoped
- Explicitly authorized

---

## Script Contracts

The orchestrator relies on the following scripts.  
They MUST be executed exactly as defined.

### Project Detection

```bash
scripts/detect-project.zsh
```
