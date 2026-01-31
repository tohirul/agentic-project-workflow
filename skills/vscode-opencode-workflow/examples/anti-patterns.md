<!-- stack: universal -->

# Anti-Patterns — Forbidden Usage

❌ Reusing one OpenCode session across projects  
❌ Vague scopes (“review everything”)  
❌ Letting AI assume editor state  
❌ Allowing AI to edit files silently  
❌ Skipping project detection  
❌ Mixing analysis + execution without review  
❌ Long-lived global sessions

If you violate these, expect:

- Context corruption
- Incorrect suggestions
- Unreproducible behavior

## OpenCode Prompt Template

```text
Scope is limited to <PATH>.
<INSTRUCTIONS>
Do not modify files.
```
