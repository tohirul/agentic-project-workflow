# VS Code + OpenCode — Example Selector

Use this decision tree to choose the correct workflow.
Do not improvise.

---

## Are you changing code?

### ❌ No

→ Use **production-bug-analysis.md**

### ✅ Yes

## ↓

## Are you modifying files directly?

### ❌ No (analysis / validation only)

- Reviewing staged changes → **precommit-diff-review.md**
- Reviewing architecture → **refactor-component.md**
- Reviewing migrations → **migration-review.md**

### ✅ Yes

## ↓

## Is the change localized?

### ✅ Single folder or file

- UI or components → **refactor-component.md**
- RTK Query / API layer → **rtk-query-review.md**
- Feature flag logic → **feature-flag-review.md**

### ❌ Cross-package or repo-wide

- Monorepo concerns → **monorepo-boundary-review.md**

---

## Special Cases

- Production-only issues → **production-bug-analysis.md**
- Schema or data risk → **migration-review.md**

---

## If unsure

Default to the **narrowest scope example**.
Never start broad.

## Reading Order (Recommended)

1. usage.md
2. prompt-cheat-sheet.md
3. anti-patterns.md
4. Task-specific examples
