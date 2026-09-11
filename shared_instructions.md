# 公司 Java Web 项目 + GitHub Copilot + Devin + 多个 Skills + 日英混用环境

- Instruction = 项目级总规则
- AGENTS.md = AI Agent 的工作规则
- Skills = 某一类任务的专业方法
- Prompt = 当前这一次要做什么

your-project/
│
├─ AGENTS.md
│
├─ .github/
│  ├─ copilot-instructions.md
│  │
│  └─ skills/
│     ├─ database-change/
│     │  ├─ SKILL.md
│     │  ├─ procedure.md
│     │  └─ checklist.md
│     │
│     ├─ java-rest-api/
│     │  └─ SKILL.md
│     │
│     ├─ java-batch/
│     │  └─ SKILL.md
│     │
│     ├─ testing/
│     │  └─ SKILL.md
│     │
│     └─ project-document/
│        └─ SKILL.md
│
└─ docs/
   ├─ requirements/
   ├─ database/
   └─ design/

1. copilot-instructions.md


# Project AI Instructions

## 1. Purpose

This file defines the common development rules for AI coding assistants working on this project.

These rules apply to all development tasks unless a more specific rule has higher priority.

## 2. Language Policy

* Technical instructions and rules should be written in English.
* Business-specific terminology may remain in Japanese.
* Existing source-code names, database names, table names, column names, and API names MUST NOT be translated.
* User-facing documents should use the language requested by the user.
* If the user does not specify a language for a business document, use Japanese.

## 3. Skill Selection

Before starting a task:

1. Analyze the user's request.
2. Identify all applicable Skills.
3. Use every Skill that is relevant to the task.
4. Multiple Skills may be used for a single task.
5. Do not use unrelated Skills.
6. If the applicable Skill is unclear and the decision materially affects the implementation, ask for clarification.

Typical mapping:

| Task                             | Skill            |
| -------------------------------- | ---------------- |
| Database table/column change     | database-change  |
| Spring Boot REST API             | java-rest-api    |
| Java batch processing            | java-batch       |
| Test design or implementation    | testing          |
| Project plan / proposal / report | project-document |

## 4. General Development Rules

* MUST understand the existing implementation before modifying code.
* MUST minimize unnecessary changes.
* MUST preserve existing behavior unless the requirement explicitly changes it.
* MUST follow the existing project architecture and coding conventions.
* MUST NOT introduce a new framework or library without justification.
* MUST NOT modify production data directly.
* MUST provide appropriate tests for code changes.
* MUST consider backward compatibility.
* MUST identify potential impact on existing functions.

## 5. Database Changes

For database-related changes:

* Follow the `database-change` Skill.
* Check related tables, indexes, constraints, SQL, Entity/DTO classes, Mapper, API, and tests.
* Consider existing data and backward compatibility.
* Provide rollback SQL when applicable.

## 6. Java Development

For Java/Spring development:

* Follow the existing project architecture.
* Prefer the existing framework and libraries.
* Follow existing package, naming, exception-handling, logging, and transaction conventions.
* Do not introduce unnecessary abstraction.

## 7. Testing

For implementation changes:

* Identify affected test cases.
* Add or update tests as appropriate.
* Include normal, boundary, and error cases when applicable.
* Do not consider implementation complete until the relevant tests have been considered.

## 8. Change Scope

Before implementation, identify:

* Requirement
* Affected components
* Related database objects
* Related APIs
* Related source code
* Test impact
* Documentation impact

Keep the change within the requested scope.

## 9. Completion Criteria

Before reporting completion:

1. Review the changed files.
2. Check for unintended changes.
3. Run applicable tests if the environment permits.
4. Report test results.
5. Report unresolved issues or assumptions.
6. Summarize the files/components changed.

2. AGENTS.md
# AGENTS.md

## Role

You are an AI software development agent working on this project.

Your responsibility is to analyze requirements, inspect the existing implementation, make controlled changes, and verify the result.

## Working Principles

### 1. Understand Before Modifying

Before changing code:

* Inspect the relevant source code.
* Identify the existing architecture.
* Identify dependencies and callers.
* Check related tests.
* Check related database objects when applicable.

Do not modify code based only on the task description when the existing implementation is available.

### 2. Plan Before Implementation

For non-trivial tasks:

1. Analyze the requirement.
2. Identify affected components.
3. Identify applicable Skills.
4. Create a concise implementation plan.
5. Implement the change.
6. Test the change.
7. Review the result.

### 3. Skill Usage

Skills provide specialized procedures.

Always check whether a Skill applies to the current task.

Use multiple Skills when necessary.

Example:

A task such as:

"Add a STATUS column to CUSTOMER table, expose it through a REST API, and add tests."

should use:

* `database-change`
* `java-rest-api`
* `testing`

### 4. Existing Code Has Priority

Prefer extending or modifying existing implementations rather than creating parallel implementations.

Do not introduce a new design pattern merely because it is theoretically cleaner.

Follow the project's existing conventions unless they conflict with explicit requirements.

### 5. Safety

Never:

* Delete data without explicit authorization.
* Execute destructive production operations.
* Change production configuration without authorization.
* Commit credentials, passwords, tokens, or secrets.
* Disable security controls to make a test pass.
* Ignore failing tests without reporting the reason.

### 6. Verification

After implementation:

* Review the diff.
* Check compilation.
* Run relevant tests.
* Check error handling.
* Check logging.
* Check backward compatibility.
* Check database impact when applicable.

### 7. Final Report

The final response should contain:

1. Summary
2. Changed files
3. Tests executed
4. Test results
5. Remaining issues
6. Assumptions

Use Japanese for the final report unless the user requests another language.


3. SKILL.md
database-change/SKILL.md
# Database Change Skill

## Purpose

This Skill defines the standard procedure for modifying database tables, columns, constraints, indexes, and related application code.

## Trigger Conditions

Use this Skill when the task involves:

* Adding a database column
* Removing a database column
* Renaming a column
* Changing a column data type
* Changing NULL / NOT NULL
* Changing a default value
* Adding or modifying constraints
* Adding or modifying indexes
* Creating database migration SQL

## Do Not Use

Do not use this Skill as the primary Skill for:

* General SQL optimization
* Database performance investigation
* General Java development
* UI development

Use this Skill together with other applicable Skills when the task affects multiple layers.

## Required Analysis

Before making changes, identify:

* Database
* Schema
* Table
* Column
* Data type
* NULL / NOT NULL
* Default value
* Primary key
* Foreign keys
* Indexes
* Existing data
* Related SQL
* Java Entity / Model
* DTO
* Mapper / Repository
* Service
* API
* Tests

## Procedure

### Step 1: Understand the Requirement

Confirm:

* What is being changed?
* Why is it being changed?
* Is existing data affected?
* Is backward compatibility required?

### Step 2: Analyze Database Impact

Check:

* Existing table definition
* Existing indexes
* Existing constraints
* Existing SQL
* Existing data
* Dependent objects

### Step 3: Analyze Application Impact

Check:

* Entity / Model
* DTO
* Mapper / Repository
* Service
* Controller
* Validation
* Serialization
* Tests

### Step 4: Prepare Database Change

Create the required DDL.

When applicable, provide:

* Forward SQL
* Rollback SQL
* Data migration SQL

### Step 5: Modify Application Code

Update only the components affected by the database change.

Do not make unrelated refactoring changes.

### Step 6: Update Tests

Add or modify tests for:

* Normal case
* Existing data
* NULL handling
* Default value
* Boundary cases
* Error cases

### Step 7: Verification

Verify:

* SQL correctness
* Application compilation
* Related tests
* Backward compatibility
* Migration/rollback feasibility

## Mandatory Rules

* MUST NOT directly modify production data.
* MUST NOT delete an existing column without impact analysis.
* MUST consider existing data before changing datatype or NULL constraints.
* MUST provide rollback SQL when feasible.
* MUST update related tests.
* MUST identify affected application components.

## Output

The implementation report should include:

* Database changes
* Application changes
* Test changes
* Migration SQL
* Rollback SQL
* Potential impact
* Remaining risks


4. procedure.md

这里不要塞给 AI 一堆“原则”。

它应该是非常具体的操作手册。

database-change/
├─ SKILL.md
├─ procedure.md
└─ checklist.md

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

5. checklist.md

# Database Change Checklist

## Database

- [ ] Table definition checked
- [ ] Column definition checked
- [ ] Index impact checked
- [ ] Constraint impact checked
- [ ] Existing data checked
- [ ] Migration SQL created
- [ ] Rollback SQL created

## Java

- [ ] Entity updated
- [ ] DTO updated
- [ ] Mapper updated
- [ ] Service checked
- [ ] Controller checked
- [ ] Validation checked

## Test

- [ ] Existing tests checked
- [ ] New tests added
- [ ] Normal case tested
- [ ] Boundary case tested
- [ ] Error case tested

## Review

- [ ] No unrelated changes
- [ ] Compilation successful
- [ ] Tests successful
- [ ] Backward compatibility checked

6. Prompt 怎么办？

Prompt 不要再写成另一套 Rules。

这是非常重要的。

例如不要每次：

Please follow our database rules.
Please check Entity.
Please check Mapper.
Please check DTO.
Please create rollback SQL...

因为这些已经应该存在 Skill 里面。

Prompt 只描述：

这一次我要你做什么。

例如：

Add a STATUS column to CUSTOMER_INFO.

Column:
STATUS VARCHAR(10) NOT NULL

Default:
'ACTIVE'

Please analyze the impact first, then implement the required changes and tests.

AI 自己应该识别：

Task
  ↓
database-change Skill
  ↓
java-rest-api Skill?  ← 如果 API受到影响
  ↓
testing Skill

7. 最终你会得到一个非常清晰的层次
                    ┌─────────────────────┐
                    │       Prompt        │
                    │  What to do now?    │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │      AGENTS.md      │
                    │ How should AI work? │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │   Instructions      │
                    │ Project-wide rules  │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │       Skills        │
                    │ How to do this type │
                    │ of task             │
                    └──────────┬──────────┘
                               ↓
                    ┌─────────────────────┐
                    │ Existing Code/Docs  │
                    │ Actual project      │
                    └─────────────────────┘

                    