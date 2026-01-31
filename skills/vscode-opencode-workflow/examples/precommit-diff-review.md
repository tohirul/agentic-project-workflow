<!-- stack: universal -->

> Related:
>
> - Decision tree: README.md
> - Prompt patterns: prompt-cheat-sheet.md
> - Anti-patterns: anti-patterns.md

---

# 📄 examples/precommit-diff-review.md

````markdown
# Example — Pre-Commit Diff Review

## Use When

- Reviewing staged changes only
- Avoiding whole-project context

---

## Preparation

```bash
git diff --staged > /tmp/staged.diff
```
````

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
