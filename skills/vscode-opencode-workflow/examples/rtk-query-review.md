<!-- stack: node -->
<!-- requires: typescript, code-review -->
<!-- requires: javascript code-review -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

---

# 📄 examples/rtk-query-review.md

````markdown
# Example — RTK Query Endpoint Review

## Use When

- Adding or modifying RTK Query endpoints
- Debugging cache or invalidation issues

---

## Scope Declaration

> “Scope is limited to `src/store/api/opportunityApi.ts`.  
> Review endpoint correctness, caching, and tags.”

---

## OpenCode Responsibilities

- Validate query vs mutation usage
- Inspect tag strategy
- Identify invalidation risks

---

## VS Code Responsibilities

- Apply fixes
- Run:

```bash
npm run typecheck
```
````

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
