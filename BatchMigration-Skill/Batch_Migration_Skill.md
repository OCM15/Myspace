# Batch Migration Skill

## 1. Purpose

This skill defines the standard procedure for migrating a legacy scheduled Batch application to the new system framework while preserving business behavior.

### Core principle

> **Business behavior MUST remain unchanged. Operational control behavior MAY be redesigned according to the new system standard.**

This migration is a **control-layer modernization**, not a business-function redesign.

---

## 2. Scope

### In scope for modernization

- Batch startup
- Batch shutdown / graceful stop
- Process lifecycle management
- Parameter framework
- Duplicate execution prevention
- Lock management
- Timeout management
- Retry management
- Exit codes
- Error classification
- Logging
- Monitoring / alert integration
- Execution status management
- Recovery / restart control
- Operational configuration

### Out of scope unless explicitly approved

- Business rules
- Business calculations
- Business validation rules
- Business branching
- Business data transformation
- SQL business semantics
- Transaction boundaries
- Input/output business semantics
- External business interface semantics

---

## 3. Mandatory Rules

### Rule 1 — Preserve business behavior

The migrated Batch must produce the same business result as the legacy Batch for equivalent inputs.

### Rule 2 — Separate control logic from business logic

Use the new system's standard Batch control framework around the existing business processing.

Recommended structure:

```text
Scheduler
   |
   v
Batch Launcher
   |
   v
Batch Execution Manager
   |
   +-- Parameter Manager
   +-- Lock Manager
   +-- Timeout Manager
   +-- Retry Manager
   +-- Error Handler
   +-- Execution Context
   +-- Batch Logger
   |
   v
Batch Application
   |
   v
Business Service
   |
   v
DAO / Repository
   |
   v
DB / File / External System
```

### Rule 3 — Do not optimize business logic during migration

Do not perform unrelated refactoring, SQL optimization, algorithm changes, data-model changes, or performance tuning unless separately approved.

### Rule 4 — Transaction behavior is protected

Do not change:

- transaction boundary
- commit timing
- rollback timing
- isolation level
- lock behavior
- retry scope
- restart position

unless explicitly approved.

### Rule 5 — System errors may use the new standard

The following may be redesigned:

- system exception handling
- retry policy
- timeout policy
- logging
- alerting
- process termination
- exit code
- duplicate execution handling

However, the resulting behavior must be documented and tested.

---

## 4. Migration Procedure

### Step 1 — Inventory the legacy Batch

Identify:

- Batch name
- Entry point
- Scheduler
- Startup command
- Shutdown command
- Parameters
- Configuration files
- Environment variables
- Lock files / DB locks
- Input files
- Output files
- DB tables
- SQL
- External systems
- Transaction boundaries
- Error handling
- Retry behavior
- Exit codes
- Logs
- Alerts
- Restart/recovery procedure

Create a Legacy Batch Inventory before modifying code.

### Step 2 — Analyze business behavior

Identify:

- business processing sequence
- business conditions
- validation rules
- calculations
- DB operations
- file operations
- external calls
- success criteria
- business-error behavior

Store these as Business Behavior Contracts.

### Step 3 — Classify legacy logic

Classify every relevant component as:

```text
CONTROL
BUSINESS
SHARED
UNKNOWN
```

`UNKNOWN` must be reviewed before migration.

### Step 4 — Create Legacy → New Mapping

For each legacy component document:

| Legacy Component | New Component | Classification | Change |
|---|---|---|---|
| old shell | Batch Launcher | CONTROL | Replace |
| old lock logic | Lock Manager | CONTROL | Replace |
| business service | Business Service | BUSINESS | Preserve |
| DAO | DAO / Repository | BUSINESS/SHARED | Preserve unless approved |
| old log | Batch Logger | CONTROL | Replace |

### Step 5 — Implement the new control layer

Implement the new standard for:

1. startup
2. parameter validation
3. execution ID
4. duplicate execution prevention
5. lock
6. execution context
7. business execution
8. error classification
9. retry
10. timeout
11. final status
12. exit code
13. logging
14. monitoring / alert

### Step 6 — Protect business code

Prefer wrapping existing business services rather than rewriting them.

Preferred:

```java
public BatchResult execute(BatchRequest request) {
    executionManager.start(request);

    try {
        return businessService.execute(request);
    } catch (BusinessException e) {
        return errorHandler.handleBusinessError(e);
    } catch (Exception e) {
        return errorHandler.handleSystemError(e);
    } finally {
        executionManager.finish();
    }
}
```

Do not silently alter the implementation of `businessService`.

### Step 7 — Test

Run:

- business compatibility tests
- system control tests
- error handling tests
- restart/recovery tests
- regression tests

### Step 8 — Review

Migration cannot be considered complete until:

- all Business Preservation checks pass
- all Migration Checklist items are complete
- test evidence exists
- all intentional behavior changes are documented
- reviewers approve the remaining differences

---

## 5. Required Deliverables

Every migrated Batch must have:

```text
docs/
  batch/
    <batch-name>/
      legacy-inventory.md
      business-behavior-contract.md
      legacy-new-mapping.md
      migration-design.md
      migration-test-cases.md
      migration-test-results.md
```

---

## 6. Forbidden Changes

Do NOT make these changes implicitly:

- change SQL meaning
- change filtering conditions
- change sorting that affects business behavior
- change calculation precision
- change rounding
- change date/time interpretation
- change timezone
- change null handling
- change default values
- change transaction scope
- change commit/rollback behavior
- change file encoding
- change file record order where business-sensitive
- change duplicate handling
- change external API semantics
- change business exception semantics

If necessary, create an explicit change request.

---

## 7. Definition of Done

A Batch migration is complete only when:

- [ ] Legacy behavior is documented
- [ ] Business/system boundary is documented
- [ ] New control framework is implemented
- [ ] Business logic is preserved
- [ ] Transaction behavior is verified
- [ ] Business compatibility tests pass
- [ ] New control tests pass
- [ ] Error handling is verified
- [ ] Retry/timeout behavior is verified
- [ ] Startup/stop behavior is verified
- [ ] Duplicate execution is verified
- [ ] Logs and exit codes are verified
- [ ] Test evidence is stored
- [ ] Code review is complete
- [ ] No undocumented business behavior change remains
