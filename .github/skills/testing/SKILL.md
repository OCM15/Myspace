# Testing Skill

## Purpose

This Skill defines the standard procedure for test design and implementation in this project.

## Trigger Conditions

Use this Skill when the task involves:

- Adding or updating unit tests
- Adding or updating integration tests
- Creating test cases for bug fixes
- Verifying API or business behavior
- Designing test coverage for modified code

## Do Not Use

Do not use this Skill as the primary Skill for:

- Business requirement writing
- Database migration design
- UI implementation
- Production code refactoring unrelated to test coverage

## Required Analysis

Before making changes, identify:

- Changed behavior
- Affected components
- Existing test patterns
- Required test boundaries
- Error conditions and edge cases

## Procedure

### Step 1: Understand the Change

Confirm:

- What behavior is being changed?
- What is the expected correct result?
- Which components are affected?

### Step 2: Inspect Existing Tests

Check:

- Current patterns and conventions
- Similar test cases in the project
- Existing fixtures and utilities

### Step 3: Design the Test Cases

Cover:

- Normal case
- Boundary case
- Error case
- Null/empty case when relevant
- Regression case for the original issue

### Step 4: Implement the Test

Write the minimal test needed to confirm the behavior.

Avoid unnecessary mock complexity; validate the real behavior that matters.

### Step 5: Verification

Run the relevant tests and confirm:

- The targeted behavior passes
- No nearby regressions appear
- Validation is meaningful and not overly broad

## Mandatory Rules

- MUST test real behavior, not mock-only behavior.
- MUST include relevant success and failure cases.
- MUST not add production-only test hooks.
- MUST prefer existing project test conventions.
- MUST verify the affected behavior directly.

## Output

The implementation report should include:

- Test cases added or updated
- Behavior covered
- Validation method used
- Results obtained
- Remaining risks or limitations
