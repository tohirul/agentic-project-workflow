<!-- stack: universal -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

# Example — Production Bug (Read-Only)

## Use When

- Bug appears only in production
- No code changes yet

---

## Scope Declaration

> “Read-only analysis.  
> Use logs and referenced files only.  
> No speculative fixes.”

---

## OpenCode Responsibilities

- Trace execution paths
- Identify environment differences
- Produce hypotheses only

---

## VS Code Responsibilities

- Add logs
- Prepare fix branch

---

## Exit Condition

- Actionable hypothesis identified

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
