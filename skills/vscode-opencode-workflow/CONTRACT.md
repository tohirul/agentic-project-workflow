## Script Authority

All scripts under `scripts/` are authoritative for:

- Filesystem inspection
- Context generation
- Context validation
- Task skeleton emission
- Example discovery

Scripts MUST:

- Operate on explicit inputs only
- Produce deterministic output
- Exit non-zero on failure
- Never mutate files unless explicitly defined

Scripts MUST NOT:

- Select models
- Infer intent
- Read chat history
- Modify memory
- Write editor state

---

## Editor Binding Rules

This workflow assumes:

- VS Code workspace is the **only editor context**
- OpenCode attaches to VS Code, not vice versa

The workflow MUST NOT:

- Launch editors autonomously
- Switch workspaces
- Modify VS Code settings
- Persist editor UI state

---

## Failure Semantics

All failures are **hard failures**.

On failure:

- Emit a single, clear error message
- Exit immediately
- Do not retry
- Do not attempt recovery
- Do not fallback

Silence or partial execution is forbidden.

---

## Standardized Exit Codes

Scripts MUST adhere to the following exit code standards to support
Orchestrator decision logic:

| Code | Meaning                 | Description                                   |
| :--- | :---------------------- | :-------------------------------------------- |
| `0`  | **Success**             | Task completed successfully.                  |
| `1`  | **Validation Failure**  | Input arguments or config validation failed.  |
| `2`  | **Environment Failure** | Missing dependencies (e.g., VS Code, CLI).    |
| `3`  | **Execution Failure**   | Script crashed or encountered an I/O error.   |
| `4`  | **Scope Violation**     | Attempted to access forbidden paths/projects. |

Any other exit code is treated as a generic Execution Failure (Code 3).

---

## Compatibility Guarantees

This workflow guarantees compatibility with:

- Any POSIX-compliant shell environment
- Any OpenCode-supported model
- Any OpenCode plugin

Compatibility is achieved by:

- Zero reliance on shell globals
- Zero reliance on model behavior
- Zero reliance on editor heuristics

---

## Final Contract Rule

If any component cannot operate **exactly** within this contract:

→ Execution MUST halt
→ Responsibility MUST be surfaced
→ No compensating behavior is allowed
