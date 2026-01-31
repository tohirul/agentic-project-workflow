# Core Architectural Review Checklist

This checklist is used to perform **structured, repeatable architectural reviews**
for code changes, pull requests, or system design updates.

The checklist MUST be completed explicitly.
Unchecked items indicate incomplete review.

---

## 1. Review Context Verification

- [ ] Review inputs are explicitly provided (diff, PR, files, description)
- [ ] Project root and context are known
- [ ] Relevant architecture or system description is available
- [ ] Review scope is clearly defined (what is in / out of scope)

If any item is missing → halt review and request clarification.

---

## 2. Change Classification

- [ ] Change type identified:
  - [ ] Feature
  - [ ] Bug fix
  - [ ] Refactor
  - [ ] Migration
  - [ ] Breaking change
- [ ] Affected modules / services identified
- [ ] Architectural layers affected are known
- [ ] Data or security-sensitive areas identified (if any)

---

## 3. Architectural Boundaries & Structure

- [ ] Dependency direction is correct (inner layers do not depend on outer layers)
- [ ] No new circular dependencies introduced
- [ ] Module / service boundaries remain clear
- [ ] No leakage across bounded contexts (if applicable)
- [ ] Shared logic is intentional and justified
- [ ] No new global state introduced

---

## 4. SOLID & Design Principles

- [ ] Single Responsibility Principle upheld
- [ ] Open / Closed Principle respected
- [ ] Liskov Substitution violations checked
- [ ] Interfaces are minimal and cohesive
- [ ] Dependency Inversion applied where appropriate
- [ ] No God objects or excessive class responsibilities

---

## 5. API & Contract Integrity

- [ ] API contracts remain backward compatible
- [ ] Breaking changes are explicitly flagged
- [ ] Versioning strategy is appropriate (if applicable)
- [ ] Error handling behavior is consistent
- [ ] Input/output validation is explicit
- [ ] Public interfaces are documented or unchanged

---

## 6. Data & State Management

- [ ] Data ownership is clear
- [ ] No cross-service or cross-module data coupling
- [ ] Transactions are scoped correctly
- [ ] Eventual consistency is handled explicitly (if applicable)
- [ ] Idempotency considered for repeated operations
- [ ] No hidden side effects introduced

---

## 7. Security Review

- [ ] Authentication logic reviewed (if affected)
- [ ] Authorization boundaries enforced
- [ ] Sensitive data handling verified
- [ ] No secrets or credentials exposed
- [ ] Input sanitization and validation checked
- [ ] Security impact classified (None / Low / Medium / High)

---

## 8. Performance & Scalability

- [ ] Obvious performance regressions checked
- [ ] N+1 query patterns checked
- [ ] Blocking I/O or synchronous remote calls identified
- [ ] Caching strategy reviewed (if applicable)
- [ ] Resource usage growth is bounded
- [ ] Scalability assumptions documented

---

## 9. Maintainability & Evolution

- [ ] Code readability maintained or improved
- [ ] Naming reflects domain intent
- [ ] Duplication avoided or justified
- [ ] Complexity is reasonable for the change scope
- [ ] Change supports future evolution
- [ ] Technical debt introduced is acknowledged

---

## 10. Testing & Observability

- [ ] Test coverage added or updated (if applicable)
- [ ] Critical paths are tested
- [ ] Edge cases are handled or documented
- [ ] Logging remains meaningful and non-noisy
- [ ] Observability impact considered

---

## 11. Risk & Severity Assessment

- [ ] Each issue classified by severity:
  - [ ] CRITICAL
  - [ ] HIGH
  - [ ] MEDIUM
  - [ ] LOW
  - [ ] INFO
- [ ] Severity justification provided
- [ ] Remediation effort estimated
- [ ] High-risk issues clearly highlighted

---

## 12. Review Conclusion

- [ ] Review findings summarized
- [ ] Blocking issues explicitly called out
- [ ] Non-blocking recommendations listed
- [ ] Follow-up actions identified (if any)
- [ ] Review outcome declared:
  - [ ] APPROVE
  - [ ] REQUEST CHANGES
  - [ ] COMMENT ONLY

---

## Review Integrity Statement

- [ ] No assumptions were made beyond provided inputs
- [ ] No architectural inference was performed
- [ ] Review adhered to deterministic, project-scoped rules

If this box cannot be checked, the review is invalid.
