<!-- stack: universal -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

# Example — Monorepo Boundary Enforcement

## Use When

- Working inside a monorepo
- Preventing cross-package leakage

---

## Scope Declaration

> “Scope limited to `packages/ui-button`.  
> Identify forbidden dependencies.”

---

## OpenCode Responsibilities

- Analyze imports
- Flag boundary violations

---

## VS Code Responsibilities

- Refactor imports
- Update configs if required

---

## Exit Condition

- Package respects boundaries

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
