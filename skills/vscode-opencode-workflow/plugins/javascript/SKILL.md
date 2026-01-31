---

# 📁 `plugins/javascript/SKILL.md`

```markdown
---

name: javascript-core-patterns
description: Provides expert guidance on modern JavaScript patterns, runtime behavior, async programming, module systems, and performance best practices. Use when writing or reviewing JavaScript code, designing application logic, or working with Node.js, browsers, or tooling.

---

# JavaScript Core Patterns & Best Practices

This skill defines **correct, modern JavaScript usage** across environments:

- Browser
- Node.js
- CLI tools
- Extensions
- Libraries

It emphasizes **clarity, correctness, and runtime safety** over abstraction.

---

## When to Use This Skill

- Writing or reviewing JavaScript code
- Designing application logic
- Handling async flows
- Working with Node.js or browser APIs
- Building CLI tools or extensions
- Migrating legacy JavaScript
- Preparing codebases for TypeScript adoption

---

## Core Principles

- Prefer **explicitness over cleverness**
- Favor **standard APIs over libraries**
- Keep runtime behavior predictable
- Avoid unnecessary abstractions
- Write code that is easy to type later

---

## Language Fundamentals

### 1. Module System

Use ES Modules exclusively.

```js
import fs from "fs";
export function readConfig() {}
```
