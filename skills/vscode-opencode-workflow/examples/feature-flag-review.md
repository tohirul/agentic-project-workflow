<!-- stack: universal -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

---

# 📄 examples/feature-flag-review.md

```markdown
# Example — Feature Flag Introduction

## Use When

- Adding feature flags
- Planning safe rollouts

---

## Scope Declaration

> “Scope includes `featureFlags.ts` and its new usages.  
> Validate defaults and safety.”

---

## OpenCode Responsibilities

- Validate naming
- Check default behavior
- Identify unsafe branching

---

## VS Code Responsibilities

- Ensure safe disabled state
- Add fallbacks

---

## Exit Condition

- Feature deployable with flag OFF
```

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
