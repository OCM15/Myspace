# Database Change Procedure

## 1. Collect Current Definition

Obtain the current table definition before creating DDL.

## 2. Check Existing Data

For a new NOT NULL column:

1. Check row count.
2. Determine whether a default value is required.
3. Determine whether existing rows require data migration.

## 3. Application Changes

Typical dependency chain:

DB
 ↓
Entity
 ↓
Mapper
 ↓
Service
 ↓
DTO
 ↓
Controller
 ↓
Test

## 4. Required Review

Before finalizing the change, confirm:

- Schema is correct
- Data migration is safe
- Rollback SQL is available
- Related code is updated
- Tests cover the affected behavior
