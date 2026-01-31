<!-- stack: node -->
<!-- requires: typescript, code-review -->
<!-- requires: javascript, code-review -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

# Example — Safe Component Refactor

## Use When

- Refactoring UI or logic
- Reducing duplication
- Improving structure without changing behavior

---

## Scope Declaration

> “Scope is limited to `src/components/sidebar`.  
> Analyze structure and suggest refactors.  
> Do not modify files.”

---

## OpenCode Responsibilities

- Detect duplication
- Suggest extraction points
- Provide diff-style output only

---

## VS Code Responsibilities

- Apply changes manually
- Run:

```bash
npm test
npm run lint
```

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
