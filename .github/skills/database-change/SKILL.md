# Database Change Skill

## Purpose

This Skill defines the standard procedure for modifying database tables, columns, constraints, indexes, and related application code.

## Trigger Conditions

Use this Skill when the task involves:

- Adding a database column
- Removing a database column
- Renaming a column
- Changing a column data type
- Changing NULL / NOT NULL
- Changing a default value
- Adding or modifying constraints
- Adding or modifying indexes
- Creating database migration SQL

## Do Not Use

Do not use this Skill as the primary Skill for:

- General SQL optimization
- Database performance investigation
- General Java development
- UI development

Use this Skill together with other applicable Skills when the task affects multiple layers.

## Required Analysis

Before making changes, identify:

- Database
- Schema
- Table
- Column
- Data type
- NULL / NOT NULL
- Default value
- Primary key
- Foreign keys
- Indexes
- Existing data
- Related SQL
- Java Entity / Model
- DTO
- Mapper / Repository
- Service
- API
- Tests

## Procedure

### Step 1: Understand the Requirement

Confirm:

- What is being changed?
- Why is it being changed?
- Is existing data affected?
- Is backward compatibility required?

### Step 2: Analyze Database Impact

Check:

- Existing table definition
- Existing indexes
- Existing constraints
- Existing SQL
- Existing data
- Dependent objects

### Step 3: Analyze Application Impact

Check:

- Entity / Model
- DTO
- Mapper / Repository
- Service
- Controller
- Validation
- Serialization
- Tests

### Step 4: Prepare Database Change

Create the required DDL.

When applicable, provide:

- Forward SQL
- Rollback SQL
- Data migration SQL

### Step 5: Modify Application Code

Update only the components affected by the database change.

Do not make unrelated refactoring changes.

### Step 6: Update Tests

Add or modify tests for:

- Normal case
- Existing data
- NULL handling
- Default value
- Boundary cases
- Error cases

### Step 7: Verification

Verify:

- SQL correctness
- Application compilation
- Related tests
- Backward compatibility
- Migration/rollback feasibility

## Mandatory Rules

- MUST NOT directly modify production data.
- MUST NOT delete an existing column without impact analysis.
- MUST consider existing data before changing datatype or NULL constraints.
- MUST provide rollback SQL when feasible.
- MUST update related tests.
- MUST identify affected application components.

## Output

The implementation report should include:

- Database changes
- Application changes
- Test changes
- Migration SQL
- Rollback SQL
- Potential impact
- Remaining risks
