# Project AI Instructions

## 1. Purpose

This file defines the common development rules for AI coding assistants working on this project.

These rules apply to all development tasks unless a more specific rule has higher priority.

## 2. Language Policy

- Technical instructions and rules should be written in English.
- Business-specific terminology may remain in Japanese.
- Existing source-code names, database names, table names, column names, and API names MUST NOT be translated.
- User-facing documents should use the language requested by the user.
- If the user does not specify a language for a business document, use Japanese.

## 3. Skill Selection

Before starting a task:

1. Analyze the user's request.
2. Identify all applicable Skills.
3. Use every Skill that is relevant to the task.
4. Multiple Skills may be used for a single task.
5. Do not use unrelated Skills.
6. If the applicable Skill is unclear and the decision materially affects the implementation, ask for clarification.

Typical mapping:

| Task | Skill |
| --- | --- |
| Database table/column change | database-change |
| Spring Boot REST API | java-rest-api |
| Java batch processing | java-batch |
| Test design or implementation | testing |
| Project plan / proposal / report | project-document |

## 4. General Development Rules

- MUST understand the existing implementation before modifying code.
- MUST minimize unnecessary changes.
- MUST preserve existing behavior unless the requirement explicitly changes it.
- MUST follow the existing project architecture and coding conventions.
- MUST NOT introduce a new framework or library without justification.
- MUST NOT modify production data directly.
- MUST provide appropriate tests for code changes.
- MUST consider backward compatibility.
- MUST identify potential impact on existing functions.

## 5. Database Changes

For database-related changes:

- Follow the `database-change` Skill.
- Check related tables, indexes, constraints, SQL, Entity/DTO classes, Mapper, API, and tests.
- Consider existing data and backward compatibility.
- Provide rollback SQL when applicable.

## 6. Java Development

For Java/Spring development:

- Follow the existing project architecture.
- Prefer the existing framework and libraries.
- Follow existing package, naming, exception-handling, logging, and transaction conventions.
- Do not introduce unnecessary abstraction.

## 7. Testing

For implementation changes:

- Identify affected test cases.
- Add or update tests as appropriate.
- Include normal, boundary, and error cases when applicable.
- Do not consider implementation complete until the relevant tests have been considered.

## 8. Change Scope

Before implementation, identify:

- Requirement
- Affected components
- Related database objects
- Related APIs
- Related source code
- Test impact
- Documentation impact

Keep the change within the requested scope.

## 9. Completion Criteria

Before reporting completion:

1. Review the changed files.
2. Check for unintended changes.
3. Run applicable tests if the environment permits.
4. Report test results.
5. Report unresolved issues or assumptions.
6. Summarize the files/components changed.
