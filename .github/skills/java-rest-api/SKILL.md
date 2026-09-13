# Java REST API Skill

## Purpose

This Skill defines the standard procedure for implementing or modifying Java REST APIs in this project.

## Trigger Conditions

Use this Skill when the task involves:

- Creating or changing REST controllers
- Adding or modifying request/response DTOs
- Updating service interfaces and implementations
- Exposing new API endpoints
- Changing HTTP method, path, status code, or validation behavior
- Adjusting API integration with persistence layers

## Do Not Use

Do not use this Skill as the primary Skill for:

- Database schema changes
- Batch processing logic
- Frontend UI changes
- General infrastructure setup

## Required Analysis

Before making changes, identify:

- Endpoint path and method
- Request/response models
- Service layer dependency
- Repository or mapper usage
- Validation rules
- Exception handling
- Existing tests and API contracts

## Procedure

### Step 1: Understand the Requirement

Confirm:

- Which endpoint is affected?
- What input and output are expected?
- Which business logic is responsible?
- Are there backward compatibility concerns?

### Step 2: Inspect Existing API Layers

Check:

- Controller
- DTOs
- Service
- Mapper/Repository
- Validation and exception handlers
- Existing tests

### Step 3: Implement the Change

Update only the affected API-related components.

Keep the change aligned with the current project conventions and response patterns.

### Step 4: Validate Input and Output

Check:

- Required parameters
- Validation behavior
- Response codes
- Error responses
- JSON serialization compatibility

### Step 5: Update Tests

Add or update tests for:

- Normal success case
- Validation failure
- Business error case
- Boundary inputs
- API contract expectations

### Step 6: Verification

Verify:

- Compilation passes
- Relevant API tests pass
- Response contract remains consistent
- Error handling is correct
- No unrelated API behavior changed

## Mandatory Rules

- MUST preserve the existing API contract unless the requirement explicitly changes it.
- MUST validate request data and error handling.
- MUST avoid unnecessary refactoring.
- MUST keep the change within the requested scope.
- MUST update relevant tests.

## Output

The implementation report should include:

- API endpoints changed
- Request/response changes
- Validation and error handling changes
- Tests updated
- Potential impact
- Remaining risks
