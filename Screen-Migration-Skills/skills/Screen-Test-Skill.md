# Screen Test Skill

## Purpose

Provide layered evidence that a migrated screen preserves functionality.

## Test Levels

### Level 1 — Static

Compare source-derived inventories.

Check:

- item coverage
- hidden fields
- parameters
- buttons
- validation definitions
- display conditions

### Level 2 — Contract

Compare:

- screen I/F
- API I/F
- DTO/Form
- data types
- null semantics
- conversions

### Level 3 — Runtime

Execute:

- normal input
- boundary input
- invalid input
- conditional display
- button operations
- navigation
- error handling
- duplicate submission
- refresh/back scenarios

### Level 4 — Visual

Use screenshot/DOM comparison as supporting evidence.

Visual differences are not automatically defects if the target framework intentionally changes style.

## Pass Criteria

A screen is PASS only when:

- required coverage is complete
- no unresolved MISSING exists
- no unresolved UNKNOWN exists
- no required item is UNVERIFIED
- all critical test cases pass
- documented exceptions are approved

## Test Evidence

Record:

- test case ID
- input
- action
- expected old behavior
- expected new behavior
- actual result
- evidence/reference
