<!-- stack: universal -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

# OpenCode Prompt Cheat Sheet

## Refactor

“Scope limited to <path>.  
Suggest refactors.  
No file modifications.”

## Review

“Review this diff only.  
Identify risks and improvements.”

## Debug

“Read-only analysis.  
Use logs and referenced files only.”

## Validate

“Validate correctness and edge cases.  
Do not assume unstated behavior.”

## Boundary Check

“Identify violations of package boundaries.  
Suggest safe alternatives.”

## Migration

“Review for data loss, reversibility, and safety.”

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
