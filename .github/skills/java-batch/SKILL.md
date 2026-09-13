# Java Batch Skill

## Purpose

This Skill defines the standard procedure for implementing or modifying Java batch processing logic in this project.

## Trigger Conditions

Use this Skill when the task involves:

- Batch jobs
- Scheduled processing
- Chunk-based processing
- Item readers, writers, processors, or listeners
- Batch configuration changes
- Job parameter or step configuration updates

## Do Not Use

Do not use this Skill as the primary Skill for:

- REST API implementation
- UI work
- Database schema changes unrelated to batch logic
- General project planning documents

## Required Analysis

Before making changes, identify:

- Job and step definitions
- Input data source
- Output target
- Batch parameters
- Transaction behavior
- Restart and retry behavior
- Existing tests and operational assumptions

## Procedure

### Step 1: Understand the Requirement

Confirm:

- What job or step is affected?
- What data is processed?
- What is the expected output or side effect?
- Is restartability or idempotency required?

### Step 2: Inspect Batch Components

Check:

- Job configuration
- Step configuration
- Reader/processor/writer logic
- Listener or scheduler setup
- Transaction and error handling
- Related tests

### Step 3: Implement the Change

Modify the affected batch components only.

Keep processing behavior consistent with the current project design.

### Step 4: Validate Operational Behavior

Check:

- Parameters and configuration
- Retry and skip behavior
- Transaction boundaries
- Error logging and recovery handling

### Step 5: Update Tests

Add or update tests for:

- Normal processing flow
- Empty input
- Error conditions
- Retry or skip behavior
- Boundary cases

### Step 6: Verification

Verify:

- Batch job compiles
- Relevant tests pass
- Job parameters are valid
- Failure behavior is acceptable
- No unrelated job behavior changed

## Mandatory Rules

- MUST understand the existing batch architecture before making changes.
- MUST preserve restart and recovery behavior unless explicitly changed.
- MUST not introduce unnecessary abstraction.
- MUST validate job parameters and failure handling.
- MUST update relevant tests.

## Output

The implementation report should include:

- Batch job or step changed
- Data flow affected
- Error and retry handling
- Tests updated
- Operational impact
- Remaining risks
