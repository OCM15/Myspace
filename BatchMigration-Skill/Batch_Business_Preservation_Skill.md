# Batch Business Preservation Skill

## 1. Purpose

This skill prevents AI-assisted migration from unintentionally changing business behavior.

The AI must treat legacy business behavior as the baseline.

> **Preserve first. Refactor second. Optimize only with explicit approval.**

---

## 2. Priority

When requirements conflict, apply this priority:

1. Business behavior preservation
2. Data integrity
3. Transaction integrity
4. New system control standard
5. Maintainability
6. Performance optimization

Do not sacrifice business compatibility for cleaner code.

---

## 3. Business Preservation Contract

Before changing code, identify and document:

### Input

- input files
- input records
- parameters
- default values
- date/time
- encoding
- record selection
- duplicate input handling

### Processing

- validation
- branching
- calculations
- conversions
- rounding
- ordering
- aggregation
- business rules

### Database

- SELECT conditions
- INSERT behavior
- UPDATE conditions
- DELETE conditions
- generated values
- transaction boundaries
- commit timing
- rollback timing
- isolation level
- lock behavior

### Output

- output records
- output files
- file format
- record order
- status
- result codes
- downstream calls

### Error behavior

Classify errors as:

```text
BUSINESS_ERROR
SYSTEM_ERROR
```

Business-error behavior must remain compatible unless explicitly approved.

---

## 4. Protected Areas

The following areas are considered protected by default:

```text
Business Service
Business Rule
Business Calculation
Business Validation
SQL WHERE conditions
SQL JOIN semantics
Transaction boundary
Commit / rollback
Data conversion
Date calculation
Amount calculation
Status transition
Output business data
External business interface
```

AI must not modify these areas merely to improve code quality.

---

## 5. Allowed Refactoring

The following are generally allowed when behavior is preserved:

- extracting control code
- introducing interfaces
- dependency injection
- replacing startup mechanism
- replacing shutdown mechanism
- standardizing logging
- standardizing exit codes
- standardizing system exception handling
- introducing execution context
- introducing lock manager
- introducing retry manager
- introducing timeout manager
- moving operational configuration
- renaming control-layer classes

---

## 6. Forbidden Refactoring

Do not:

- rewrite business algorithms
- simplify business conditions
- merge business branches
- change SQL without evidence
- replace SQL with another implementation
- change transaction boundaries
- change commit frequency
- change rounding rules
- change date calculations
- change null handling
- change default values
- change external interface parameters
- change record ordering where it can affect results

---

## 7. AI Working Procedure

Before editing:

```text
1. Read legacy implementation.
2. Identify business logic.
3. Identify control logic.
4. Identify transaction boundaries.
5. Identify inputs and outputs.
6. Identify error behavior.
7. Create preservation checklist.
```

During editing:

```text
1. Change control layer first.
2. Keep business code unchanged whenever possible.
3. Avoid unrelated cleanup.
4. Keep SQL unchanged.
5. Keep transaction boundaries unchanged.
6. Keep business exceptions unchanged.
```

After editing:

```text
1. Compare business flow.
2. Compare SQL.
3. Compare transaction boundaries.
4. Compare input handling.
5. Compare output handling.
6. Compare business error behavior.
7. Run compatibility tests.
```

---

## 8. AI Decision Rule

When uncertain whether a change is business or system related:

```text
IF change affects business result
    => DO NOT change without explicit approval.

IF change affects only process execution/control
    => May migrate to new standard.

IF classification is unclear
    => Mark as UNKNOWN and request human review.
```

Never infer that a change is safe merely because the final Java code looks equivalent.

---

## 9. Business Equivalence Criteria

For the same approved input dataset, the migrated Batch should produce equivalent:

- inserted business records
- updated business records
- deleted business records
- calculated values
- status transitions
- output files
- business response
- business error classification

Equivalent does not necessarily mean identical technical implementation.

---

## 10. AI Output Requirements

When modifying a Batch, the AI should report:

```text
### Business Logic Changes
NONE / list explicitly

### Transaction Changes
NONE / list explicitly

### SQL Changes
NONE / list explicitly

### Input/Output Changes
NONE / list explicitly

### Control-Layer Changes
list changes

### Risk Items
list items requiring human review
```

If any Business Logic, Transaction, SQL, or Input/Output change is detected, stop and request explicit approval before proceeding.

---

## 11. Review Questions

Reviewer must confirm:

- Does the same input produce the same business result?
- Are all business conditions unchanged?
- Are calculations unchanged?
- Are SQL semantics unchanged?
- Is transaction scope unchanged?
- Is commit/rollback behavior unchanged?
- Is error classification still compatible?
- Are output files/data unchanged?
- Are only operational controls changed?

---

## 12. Definition of Done

- [ ] Business logic identified
- [ ] Business behavior contract created
- [ ] Protected areas identified
- [ ] SQL reviewed
- [ ] Transaction boundaries reviewed
- [ ] Input/output reviewed
- [ ] Business errors reviewed
- [ ] No unapproved business changes
- [ ] Compatibility tests passed
- [ ] Reviewer approved
