# Screen Migration Orchestrator Skill

## Purpose

Orchestrate a screen migration from a legacy Java Web application to a new framework while preserving business functionality.

## Non-Negotiable Principle

The new screen may change visual style, layout, component implementation, HTML structure, framework APIs, and libraries.

It must preserve, unless explicitly approved otherwise:

- functional behavior
- business rules
- validation semantics
- interface contracts
- data semantics
- display conditions
- navigation behavior
- error handling
- state transitions

## Required Workflow

### Phase 1 — Discover

1. Identify the legacy screen entry point.
2. Identify JSP/HTML/template files.
3. Identify Controller/Action/Servlet.
4. Identify DTO/Form/Command objects.
5. Identify JavaScript/event handlers.
6. Identify validation implementation.
7. Identify API/service calls.
8. Identify screen-to-screen parameters.
9. Identify session/hidden/URL parameters.
10. Identify permission/display rules.

### Phase 2 — Inventory

Create `OldScreenInventory.md` using the inventory template.

Do not implement before the inventory is sufficiently complete.

### Phase 3 — Contract Analysis

Create:

- Screen Traceability Matrix
- Interface Contract
- Validation Contract
- Behavior Contract

Every item must have a status:

`MATCH | CONDITIONAL | RENAMED | REPLACED | MERGED | SPLIT | OBSOLETE | MISSING | UNKNOWN`

### Phase 4 — Migration

Implement the new screen using the target framework.

Do not introduce business-rule changes merely to fit the new framework.

### Phase 5 — Verification

Run:

1. Static UI comparison
2. Validation comparison
3. Interface comparison
4. Behavior comparison
5. Runtime test
6. Visual comparison where useful

### Phase 6 — Quality Gate

Migration cannot be PASS when any required item remains:

- MISSING
- UNKNOWN
- UNVERIFIED

Exceptions require:

- explicit reason
- impact
- evidence
- approval/reference

## Final Report

Use `Screen-Migration-Report-Template.md`.

Minimum report:

- old item count
- new item count
- matched count
- conditional count
- obsolete count
- missing count
- validation coverage
- screen I/F coverage
- API I/F coverage
- behavior coverage
- test result
- unresolved issues
