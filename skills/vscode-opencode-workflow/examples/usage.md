<!-- stack: universal -->

> This is the canonical, end-to-end reference workflow.
> All other examples are partial specializations.

# Usage Example — VS Code + OpenCode (Editor-First Workflow)

This document demonstrates the **correct, repeatable usage pattern** for the  
**VS Code + OpenCode Workflow Orchestrator** skill.

The workflow enforces:

- VS Code as the system of record
- OpenCode as a scoped reasoning engine
- One project → one session → one context

---

## Assumptions

The following must already be true:

- VS Code is installed and functional
- `opencode` CLI is installed and in PATH
- You are inside a project directory (or its subdirectory)

Verify OpenCode explicitly:

```bash
opencode --version
```

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
