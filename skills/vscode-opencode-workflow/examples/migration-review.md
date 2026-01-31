<!-- stack: universal -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

# Example — Schema / Migration Review

## Use When

- Adding database migrations
- High risk of data loss

---

## Scope Declaration

> “Scope limited to the new migration file.  
> Review safety and reversibility.”

---

## OpenCode Responsibilities

- Detect destructive operations
- Validate rollback strategy

---

## VS Code Responsibilities

- Split unsafe migrations
- Add guards

---

## Exit Condition

- Migration safe for production

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
