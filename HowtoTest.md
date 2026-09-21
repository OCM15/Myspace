
# Migration Test Skill

## 记录时间：今日 5:44
我利用devin ，copilot把一个旧系统的功能移植到了新系统。怎么做测试来保证用户功能没有变化

可以。你这个场景其实不应该只做普通的“新系统功能测试”，而应该把目标定义成：

证明新系统在相同业务输入、相同数据条件下，用户可观察到的业务行为与旧系统一致。

对于你这种 Devin + GitHub Copilot 把 Java 旧系统迁移到新框架 的项目，我最推荐采用 「旧系统基准测试（Golden Master）＋新旧并行比较＋普通回归测试」 三层方式。这个思路正是遗留系统迁移中常用的 Characterization / Golden Master Testing。

### 先确定环境制约：Devin 不能访问 DB

这个制约不会阻止测试，但需要调整职责边界：

- Devin 不连接旧系统或新系统的 DB，不读取 DB 凭据，也不负责采集 DB 快照。
- 由具备权限的开发者、QA 或受控 CI Job 在测试环境执行 DB 查询和测试用例。
- 执行方只把脱敏后的 `before/after` 快照、API 响应和比较结果交给 Devin。
- Devin 负责生成测试代码、比较 fixture、分析 diff 和生成报告；任何 DB 差异由有权限的人确认。

因此，DB 验证应采用“外部采集、文件比较”的方式，而不是让 Devin 直接执行 SQL。

## 1. 核心思想：不要让 AI 自己判断“功能一样”
最重要的一点：

不要让 Devin 根据旧代码推测新代码是否正确。

而是：

                 同一个测试条件
                       │
             ┌─────────┴─────────┐
             ↓                   ↓
        旧系统 Old             新系统 New
             │                   │
             ↓                   ↓
        实际执行结果          实际执行结果
             │                   │
             └─────────┬─────────┘
                       ↓
                  Diff 比较
                       ↓
              ┌────────┴────────┐
              ↓                 ↓
            一致              不一致
              ↓                 ↓
             PASS          人工确认原因
这比“写很多 JUnit，然后看测试是否通过”可靠得多。

因为旧系统本身就是你这次迁移的 Behavioral Baseline。Characterization Test 的目的就是记录“现在系统实际上怎么工作”，而不是重新定义“理论上应该怎么工作”。

## 2. 我建议你建立 5 层测试
对于你的项目，可以设计成：

| 层 | 测试 | 目的 |
| --- | --- | --- |
| L1 | Unit Test | 新代码本身是否正确 |
| L2 | API/Service Test | Java业务逻辑是否一致 |
| L3 | Old vs New Comparison | 核心：功能是否发生变化 |
| L4 | DB/Data Test | 由有权限的执行方采集快照，再比较业务数据是否一致 |
| L5 | E2E/UI Test | 用户实际操作是否一致 |
其中：

L3 是你这个迁移项目最重要的测试。

## 3. 第一件事：建立“功能清单”
先不要马上让 Devin 写测试。

先建立：

```text
FUNCTION-MATRIX.xlsx
```
例如：

| ID | 功能 | 旧画面 | 新画面 | Input | DB更新 | Output | Priority |
| --- | --- | --- | --- | --- | --- | --- | --- |
| F001 | 交易登记 | 交易登记 | 交易登记 | 正常数据 | INSERT | 完了 | High |
| F002 | 交易修改 | 交易修改 | 交易修改 | 修改数据 | UPDATE | 完了 | High |
| F003 | 交易删除 | 删除 | 删除 | ID | DELETE | 完了 | High |
| F004 | 查询 | 查询 | 查询 | 条件 | SELECT | List | High |
| F005 | CSV输出 | CSV | CSV | 条件 | SELECT | CSV | Medium |
| F006 | 权限检查 | Login | Login | User | - | Allow/Deny | High |
| F007 | 异常处理 | Error | Error | Invalid | - | Message | High |
这里非常重要：

不要只按照 Java class / method 来分类。

要按照 用户功能 / Business Capability 来分类。

因为你的目标是：

用户功能没有变化

而不是：

Java class 没有变化。

## 4. 第二步：给每个功能建立“测试场景”
例如你的交易系统：

F001 交易登记
不要只测试：

正常登记
至少应该：

TC001 正常交易
TC002 必须字段为空
TC003 数值为0
TC004 最大值
TC005 最小值
TC006 日期边界
TC007 不存在的Code
TC008 重复登记
TC009 权限不足
TC010 DB异常
也就是说：

正常路径 + 异常路径 + 边界条件

都要覆盖。

Golden Master 方案尤其适合把旧系统实际运行结果保存下来，再让新系统产生结果进行比较。

## 5. 第三步：最重要——保存旧系统的“基准结果”
例如：

```text
testdata/
 ├─ F001/
 │   ├─ TC001/
 │   │   ├─ input.json
 │   │   ├─ old-response.json
 │   │   ├─ old-db-before.json
 │   │   └─ old-db-after.json
 │   │
 │   ├─ TC002/
 │   └─ TC003/
 │
 ├─ F002/
 └─ F003/
```
例如：

```json
Input
{
  "transactionType": "BUY",
  "amount": 1000000,
  "currency": "JPY"
}
```
旧系统运行以后保存：

```json
Response
{
  "result": "SUCCESS",
  "transactionId": "..."
}
```
同时保存：

DB变化
Before
↓
table A
table B
table C

After
↓
table A +1
table B +1
table C unchanged
这样以后新系统使用完全相同的 input。由于 Devin 无法访问 DB，`old-db-before.json`、`old-db-after.json` 以及新系统对应的快照，应由有权限的执行方生成，并在交给 Devin 前完成脱敏。

## 6. DB比较尤其重要
你这个系统的核心又是：

用户操作 → DB写入交易数据

所以我建议不要只比较 HTTP Response。

而应该由有权限的执行方完成：

Old System / New System
  ↓
DB Snapshot Before
  ↓
Execute
  ↓
DB Snapshot After

然后只把脱敏后的快照文件交给 Devin 做比较：

Devin
  ↓
Fixture Comparator
  ↓
DB Diff Report
最后比较：

Response
+
DB INSERT
+
DB UPDATE
+
DB DELETE
+
业务计算结果
例如：

OLD

transaction
--------------------------------
id       1001
type     BUY
amount   1,000,000
status   ACTIVE


NEW

transaction
--------------------------------
id       1001
type     BUY
amount   1,000,000
status   ACTIVE

                 ↓

             EQUAL
这样比单纯检查画面可靠很多。

## 7. 但是有些东西不能直接比较
这是 Golden Master 很容易踩坑的地方。

例如：

timestamp
transaction ID
UUID
session ID
log timestamp
machine name
user session
sequence number
旧系统：

{
  "id": "ABC123",
  "timestamp": "2026-09-19T10:00:01"
}
新系统：

{
  "id": "XYZ789",
  "timestamp": "2026-09-19T10:00:03"
}
不能直接判定：

FAIL
应该定义：

timestamp → ignore / normalize
UUID       → mapping
sequence   → compare relationship
business fields → exact
所以我建议你建立一个：

```text
comparison-rules.yaml
```
例如：

```yaml
Transaction:
  fields:
    transactionType:
      comparison: EXACT

    amount:
      comparison: EXACT

    status:
      comparison: EXACT

    transactionId:
      comparison: IGNORE

    createdAt:
      comparison: IGNORE
```
默认应该是 EXACT。

只有明确知道为什么不同，才允许 IGNORE / NORMALIZE。

## 8. 然后让 Devin 自动生成比较测试
这一步特别适合 Devin。

你可以让 Devin 做：

1. Read FUNCTION-MATRIX
2. Read test scenarios
3. Generate test inputs and test code
4. 由有权限的执行方执行 legacy system 并保存 baseline
5. 由有权限的执行方执行 new system 并保存 output
6. 将脱敏后的 response/DB fixture 放入测试目录
7. Normalize configured dynamic fields
8. Compare old/new fixture
9. Generate diff report
10. Generate JUnit regression tests

禁止 Devin 执行以下操作：

- 直接连接 DB 或运行 SQL
- 请求、保存或猜测 DB 凭据
- 把真实个人信息、账号或生产数据复制到 fixture
- 把“无法访问 DB”当作 DB 等价性通过
最终得到：

```text
test/
 ├─ functional/
 ├─ integration/
 ├─ equivalence/
 │   ├─ F001Test.java
 │   ├─ F002Test.java
 │   └─ F003Test.java
 │
 └─ testdata/
```
## 9. 我更建议做成“新旧系统比较器”
甚至可以专门做一个：

Legacy-New Equivalence Test Framework
结构：

                  Test Case
                      │
                      ↓
              ┌───────────────┐
              │ Test Executor │
              └───────┬───────┘
                      │
            ┌─────────┴─────────┐
            ↓                   ↓
       Legacy Adapter       New Adapter
            ↓                   ↓
       Legacy System        New System
            ↓                   ↓
       Response Old        Response New
            ↓                   ↓
      DB Fixture Old      DB Fixture New
            │                   │
            └─────────┬─────────┘
                      ↓
                 Comparator
                      ↓
                  Diff Report
这样以后你迁移其他模块的时候也可以重复使用。

## 10. 最终测试报告不要只写 PASS/FAIL
建议让 AI 生成：

Equivalence Test Report
例如：

Migration Functional Equivalence Test

Total Test Cases       : 428
PASS                    : 417
FAIL                    : 11
Pending Investigation   : 11

Functional Coverage     : 96.8%
Critical Function Pass  : 100%

--------------------------------

F001 Transaction Entry
  25 / 25 PASS

F002 Transaction Update
  31 / 32 PASS
  TC-032 FAIL

Difference:
OLD:
amount = 1000000

NEW:
amount = 999999

Possible Cause:
Rounding calculation changed

Status:
INVESTIGATION
这个对于你向项目成员、QA、上司说明特别有用。

## 11. 还有一个非常重要的原则
你这次是：

旧系统 → 新架构

所以不要追求：

新系统代码和旧系统代码一致。

而应该追求：

Observable Behavior 一致。

也就是：

                   不要求一致
                         ↓
Old Architecture ≠ New Architecture
Old Java Code    ≠ New Java Code
Old Library     ≠ New Library
Old UI          ≠ New UI
                         │
                         ↓
              但是要求一致
                         ↓
        ┌─────────────────────────┐
        │ Business Behavior       │
        │ DB Business Result      │
        │ API Business Result     │
        │ Validation              │
        │ Authorization           │
        │ Calculation             │
        │ Error Handling          │
        └─────────────────────────┘
这非常符合你之前说的原则：

语言还是 Java，数据库环境不变，架构和 Library 可以改变，画面风格可以改变，但业务功能不能改变。

## 12. 我建议你把整个迁移项目的测试 Gate 定成这样
                 ┌───────────────┐
                 │ Code Migration│
                 └───────┬───────┘
                         ↓
                 ┌───────────────┐
                 │ Build / Unit  │
                 └───────┬───────┘
                         ↓
                 ┌───────────────┐
                 │ API/Service   │
                 └───────┬───────┘
                         ↓
              ┌─────────────────────┐
              │ OLD vs NEW          │
              │ Equivalence Test    │
              └──────────┬──────────┘
                         ↓
              ┌─────────────────────┐
              │ DB Comparison       │
              └──────────┬──────────┘
                         ↓
              ┌─────────────────────┐
              │ E2E / UI Test       │
              └──────────┬──────────┘
                         ↓
              ┌─────────────────────┐
              │ User Acceptance     │
              └──────────┬──────────┘
                         ↓
                       GO
特别是中间的 OLD vs NEW Equivalence Test，我认为应该成为你这次 AI 移行项目的核心。

而且这个方法非常适合你现在的 Devin + GitHub Copilot 工作方式：让 AI 负责大量测试案例、测试代码、Diff、报告的生成，但**“什么算功能一致”由你定义，测试基准来自旧系统实际行为，而不是由 AI 自己判断**。这种“先建立行为基线，再并行比较”的方法也是遗留系统现代化中推荐的做法。

如果你愿意，我下一步可以直接按照你这个 Java Web + Oracle + 旧系统→新框架 的实际情况，给你设计一套 「Devin/Copilot 可直接执行的 Migration Test Skill」，包括 FUNCTION-MATRIX、test-case.yaml、comparison-rules.yaml、JUnit、DB Diff 和最终报告结构。


## 记录时间：今日 8:13
给我设计一套 Devin/Copilot 可直接执行的 Migration Test Skill

可以。结合你前面确定的迁移原则——Java 不变、DB 环境不变、业务功能不变；架构/Library 可以更新，UI 可以现代化——我建议不要只做一个 migration-test.md，而是做成一个可复用的 Migration Test Skill。

核心目标是：

以旧系统实际行为作为 Golden Master，自动执行 Old/New 对比，证明业务行为没有发生非预期变化。

## 一、推荐的 Skill 目录
建议在项目根目录建立：

```text
.ai/
└── skills/
    └── migration-test/
        ├── SKILL.md
        │
        ├── references/
        │   ├── test-strategy.md
        │   ├── equivalence-rules.md
        │   ├── db-comparison.md
        │   └── test-data-design.md
        │
        ├── templates/
        │   ├── function-matrix.yaml
        │   ├── test-case.yaml
        │   ├── comparison-rules.yaml
        │   └── test-report.yaml
        │
        └── scripts/
            ├── run-old-test
            ├── run-new-test
            ├── compare-result
            └── generate-report
```
如果公司环境不能直接 clone GitHub Skill，你完全可以自己创建这些文件，然后把 Skill 内容放进去。这也比较符合你之前说的公司环境限制。

## 二、最重要的 SKILL.md
我建议 Skill 本身不要写得过于庞大。

核心规则如下：

Migration Test Skill — SKILL.md
Migration Test Skill
### 1. Purpose
This skill is used to verify that a migrated application preserves the business behavior of the legacy application.

The migration may change:

Application architecture

Java framework

Java library versions

Internal implementation

UI design

API implementation

DB access implementation

The migration must NOT unintentionally change:

Business functions

Business rules

Validation rules

Calculation results

Authorization behavior

Database business data

Transaction behavior

Error handling behavior

User-visible business results

The legacy application is the behavioral baseline.

### 2. Fundamental Principle
Never determine equivalence by comparing source code.

Do NOT use:

Old Java code == New Java code

Old class structure == New class structure

Old framework == New framework

Instead compare observable behavior:

Legacy Input
→ Legacy Output

New Input
→ New Output

Then compare the two results.

The default comparison rule is EXACT.

Any difference must be investigated.

### 3. Test Layers
Migration testing consists of the following layers.

Layer 1 — Unit Test
Verify individual classes and methods in the new application.

Layer 2 — Service/API Test
Verify business service behavior.

Layer 3 — Functional Equivalence Test
Execute identical business scenarios against the legacy and new applications.

This is the primary migration test.

Layer 4 — Database Equivalence Test
Compare business-relevant database changes caused by the same operation.

Layer 5 — E2E Test
Verify the user's end-to-end workflow.

### 4. Test Flow
For every migration test case:

Prepare identical initial data.

Prepare identical user/authorization conditions.

Execute the test against the legacy application.

Capture:

response

business output

validation result

error result

DB changes

Reset the test environment.

Execute the same test against the new application.

Capture the same information.

Normalize only explicitly configured dynamic values.

Compare Legacy vs New.

Generate a difference report.

Classify every difference.

Never automatically accept a difference without a documented rule.

### 5. Test Case Requirements
Every test case must define:

- Test Case ID
- Function ID
- Business purpose
- Preconditions
- User/role
- Input
- Expected business behavior
- Legacy result
- New result
- Comparison result

Test cases must include:

- Normal cases
- Boundary cases
- Invalid input
- Missing required values
- Authorization failures
- Duplicate operations
- DB errors where applicable
- Transaction rollback cases
- Business-rule exceptions

### 6. Golden Master
The legacy system is the Golden Master only for behavior that is known to represent the current business requirement.

The AI must NOT assume that every legacy behavior is correct.

If the legacy system produces unexpected behavior:

Record the behavior.

Do not silently reproduce it.

Mark it as LEGACY_BEHAVIOR_REVIEW.

Ask the project owner whether the behavior should be preserved.

### 7. Comparison Rules
Default:

EXACT
Allowed comparison modes:

EXACT
NORMALIZE
IGNORE
RANGE
SET_EQUAL
ORDER_INDEPENDENT
MAPPING
IGNORE must never be used merely to make a test pass.

Every IGNORE rule must include a reason.

Example:

field: createdAt
comparison: IGNORE
reason: "Timestamp is generated independently by each application."
approved: true
### 8. Dynamic Values
The following may require normalization:

- UUID
- generated ID
- timestamp
- session ID
- request ID
- sequence number
- server hostname
- environment-specific path

Business values must NOT be ignored unless explicitly approved.

### 9. Database Comparison
Compare business-impacting changes, not physical implementation details.

Compare:

- INSERT
- UPDATE
- DELETE
- Business column values
- Record count
- Transaction commit/rollback
- Referential relationships

Do not require:

identical SQL

identical execution plan

identical DB access order

Unless required by the business specification.

### 10. Failure Classification
Every failed comparison must be classified as one of:

- BUSINESS_REGRESSION
- VALIDATION_REGRESSION
- AUTHORIZATION_REGRESSION
- CALCULATION_REGRESSION
- DATABASE_REGRESSION
- TRANSACTION_REGRESSION
- ERROR_HANDLING_REGRESSION
- UI_BEHAVIOR_REGRESSION
- EXPECTED_DIFFERENCE
- LEGACY_BEHAVIOR_REVIEW
- TEST_DATA_PROBLEM
- ENVIRONMENT_PROBLEM
Never mark a difference as EXPECTED_DIFFERENCE without evidence.

### 11. AI Rules
The AI must:

- Prefer existing project test conventions.
- Reuse existing test utilities.
- Avoid modifying production code to make tests pass.
- Never modify expected legacy results simply because the new result is different.
- Never delete a failing test without explicit approval.
- Never weaken a comparison rule to obtain PASS.
- Report every unexplained difference.
- Keep test data reproducible.
- Make tests deterministic whenever possible.
- Preserve evidence for every failure.

### 12. Definition of Done
Migration testing is complete only when:

All critical functions have test cases.

All critical scenarios have been executed.

Legacy/New equivalence tests pass.

All database differences are explained.

All authorization differences are explained.

All validation differences are explained.

All remaining differences are explicitly approved.

No unexplained business regression remains.

A high test-pass percentage alone is NOT sufficient.

Critical functions must have zero unexplained regression.

### 13. Output
Generate:

migration-test-report/
├── summary.html
├── function-coverage.html
├── equivalence-result.html
├── database-diff.html
├── failed-tests.html
└── evidence/
    ├── TC001/
    ├── TC002/
    └── ...
Each failure must include:

Test Case ID

Function ID

Legacy result

New result

Difference

Classification

Evidence

Investigation status


---

## 三、`function-matrix.yaml`

这个文件是整个 Skill 的“地图”。

functions:

  - functionId: F001
    name: Transaction Registration
    category: TRANSACTION
    priority: CRITICAL

    legacyScreen: transaction/register
    newScreen: transaction/register

    operations:
      - CREATE

    requiredTests:
      - NORMAL
      - BOUNDARY
      - INVALID_INPUT
      - AUTHORIZATION
      - DUPLICATE
      - TRANSACTION_ROLLBACK

  - functionId: F002
    name: Transaction Update
    category: TRANSACTION
    priority: CRITICAL

    legacyScreen: transaction/edit
    newScreen: transaction/edit

    operations:
      - UPDATE

    requiredTests:
      - NORMAL
      - BOUNDARY
      - INVALID_INPUT
      - AUTHORIZATION
      - NOT_FOUND
      - CONCURRENT_UPDATE

  - functionId: F003
    name: Transaction Search
    category: SEARCH
    priority: HIGH

    legacyScreen: transaction/search
    newScreen: transaction/search

    operations:
      - SELECT

    requiredTests:
      - NORMAL
      - EMPTY_RESULT
      - MULTI_RESULT
      - BOUNDARY
      - AUTHORIZATION

  - functionId: F004
    name: Transaction Delete
    category: TRANSACTION
    priority: HIGH

    legacyScreen: transaction/delete
    newScreen: transaction/delete

    operations:
      - DELETE

    requiredTests:
      - NORMAL
      - NOT_FOUND
      - AUTHORIZATION
      - ROLLBACK
三、function-matrix.yaml
这个文件是整个 Skill 的“地图”。

function-matrix.yaml
functions:

functionId: F001
name: Transaction Registration
category: TRANSACTION
priority: CRITICAL

legacyScreen: transaction/register
newScreen: transaction/register

operations:

CREATE

requiredTests:

NORMAL

BOUNDARY

INVALID_INPUT

AUTHORIZATION

DUPLICATE

TRANSACTION_ROLLBACK

functionId: F002
name: Transaction Update
category: TRANSACTION
priority: CRITICAL

legacyScreen: transaction/edit
newScreen: transaction/edit

operations:

UPDATE

requiredTests:

NORMAL

BOUNDARY

INVALID_INPUT

AUTHORIZATION

NOT_FOUND

CONCURRENT_UPDATE

functionId: F003
name: Transaction Search
category: SEARCH
priority: HIGH

legacyScreen: transaction/search
newScreen: transaction/search

operations:

SELECT

requiredTests:

NORMAL

EMPTY_RESULT

MULTI_RESULT

BOUNDARY

AUTHORIZATION

functionId: F004
name: Transaction Delete
category: TRANSACTION
priority: HIGH

legacyScreen: transaction/delete
newScreen: transaction/delete

operations:

DELETE

requiredTests:

NORMAL

NOT_FOUND

AUTHORIZATION

ROLLBACK


## 画面功能怎么测呢？

画面功能要测，而且你这个项目里我建议把**“画面测试”和“业务等价测试”分开**。

因为你已经明确了：

新系统画面风格可以变，但用户功能不能变。

所以不能做“像素完全一致”的测试，而应该做 User Behavior Equivalence Test（用户操作行为等价测试）。

### 1. 我建议的画面测试结构
                    Migration UI Test
                           │
          ┌────────────────┼────────────────┐
          ↓                ↓                ↓
     UI Structure      User Operation     Business Result
       测试               测试                测试
          │                │                │
     ┌────┴────┐      ┌────┴────┐      ┌────┴────┐
     │         │      │         │      │         │
   Button    Field   Click    Input    DB      API
   Menu      Display Submit   Search   Result   Result
其中最重要的是：

不要比较旧画面和新画面的 HTML 是否一样。

而是比较：

用户能不能完成原来能完成的事情。

### 2. 用“用户操作流程”定义测试
例如旧系统：

交易登记画面

① 打开画面
② 输入交易种类
③ 输入金额
④ 输入交易日期
⑤ 点击「登録」
⑥ 显示确认
⑦ 点击「OK」
⑧ 显示登记完成
新系统可能完全换成：

现代化 UI

① 打开画面
② 选择交易种类
③ 输入金额
④ 选择日期
⑤ 点击「保存」
⑥ Dialog
⑦ 点击「确定」
⑧ Toast
UI长得不一样完全没关系。

测试应该判断：

旧系统                       新系统

打开登记画面          →      打开登记画面
输入交易种类          →      选择交易种类
输入金额              →      输入金额
输入日期              →      选择日期
登记                  →      保存
确认                  →      确定
登记完成              →      登记完成
        ↓                      ↓
             Business Result
                    ↓
              DB结果一致
### 3. 给每个画面定义 UI Contract
这是我特别建议你增加到前面的 Skill 里的。

例如：

```yaml
screenId: SCR-001
name: Transaction Registration

elements:

  - id: transactionType
    type: SELECT
    required: true

  - id: amount
    type: NUMBER
    required: true

  - id: tradeDate
    type: DATE
    required: true

  - id: save
    type: BUTTON
    action: CREATE
    required: true

  - id: cancel
    type: BUTTON
    action: CANCEL
    required: true
```
注意这里：

id
type
required
action
比：

x=100
y=200
width=120
color=#123456
重要得多。

因为你的新系统允许 UI 改版。

### 4. 画面测试分成 6 类
我建议你的 Migration UI Skill 固定要求这六类。

① Element Test
确认必要控件存在：

□ 交易种类
□ 金额
□ 日期
□ 登记按钮
□ 取消按钮
② Input Test
测试用户输入。

例如：

金额

1000       → OK
0          → ?
-1         → ?
999999999  → ?
ABC        → ERROR
空         → ERROR
这些必须与旧系统的业务行为比较。

③ Action Test
测试按钮真正做了什么：

登録
 ↓
Validation
 ↓
Confirmation
 ↓
DB Update
 ↓
Success Message
不能只测试：

按钮存在。

必须测试：

按钮点击以后产生的业务行为。

④ Navigation Test
例如：

Menu
 ↓
Transaction
 ↓
Search
 ↓
Detail
 ↓
Edit
 ↓
Back
比较：

旧系统 Navigation Flow
        VS
新系统 Navigation Flow
⑤ Permission Test
这个对你之前设计的用户组 × Button权限 × Screen权限尤其重要。

例如：

| User Group | Screen | Search | Edit | Delete |
| --- | --- | --- | --- | --- |
| A | Yes | Yes | Yes | Yes |
| B | Yes | Yes | Yes | No |
| C | Yes | Yes | No | No |
| D | No | - | - | - |
必须同时测试：

画面是否显示
+
按钮是否显示
+
按钮是否可操作
+
后端 API 是否拒绝非法操作
尤其不能只测试前端隐藏。

### 5. 最有价值的是“录制旧系统操作流程”
我建议你让 Devin/Copilot 做一个：

UI Test Scenario
例如：

UI Test Scenario Example
UI Test Case
TC-UI-001
Function
Transaction Registration

User
Normal transaction operator

Preconditions
User is logged in.

User has transaction registration permission.

Required master data exists.

Steps
Open transaction registration screen.

Select transaction type = BUY.

Enter amount = 1,000,000.

Enter transaction date.

Click Register.

Confirm registration.

Verify success message.

Open transaction search.

Search for the created transaction.

Expected Behavior
Registration screen can be opened.

Required fields are available.

Invalid input is rejected.

Register action is available.

Confirmation is displayed.

Transaction is registered.

Success message is displayed.

Registered transaction can be searched.

Migration Comparison
The following must be equivalent between Legacy and New:

Available user operations

Validation behavior

Navigation result

Confirmation behavior

Success/failure behavior

Business result

Authorization behavior

The following may differ:

Layout

CSS

Color

Font

Component appearance

Button position

Dialog appearance

Navigation implementation

### 6. 技术上，我建议用 Playwright
如果你的新系统是 Java Web，我会优先考虑：

Java Backend
      │
      ↓
Browser
      │
      ↓
Playwright
      │
      ├── Legacy
      │
      └── New
而不是让 Devin 用截图一个一个判断。

Playwright 可以做：

open page
click
fill
select
assert
screenshot
例如：

Open transaction screen

↓
Fill amount

↓
Click Register

↓
Check confirmation

↓
Click OK

↓
Check success message

↓
Query DB
### 7. 但是不要让 AI 生成这种测试
不推荐：

assertEquals(
    oldHtml,
    newHtml
);
也不推荐：

Screenshot Old
      ↓
Screenshot New
      ↓
Pixel Diff
因为你的 UI 本来就允许改变。

### 8. 应该测试“语义”
例如旧系统：

<button>登録</button>
新系统：

<button>保存</button>
如果业务动作一样：

旧：登録
新：保存
应该：

PASS
但是：

旧：登録 → INSERT
新：保存 → 只是保存画面状态
应该：

FAIL
所以 AI 应该识别：

这个控件的 Business Action 是什么？

而不是只比较文字。

### 9. UI Test 最好加入 Action ID
如果你正在改新系统，我非常建议你要求开发规范：

<button
    data-testid="transaction-register"
    data-action="TRANSACTION_CREATE">
    保存
</button>
或者 React：

data-testid="transaction-register"
这样 Playwright 不需要依赖：

第几个 button
CSS position
button文字
XPath
测试会稳定很多。

### 10. 最终我建议你的 Migration Test Skill 形成 4 个比较
                  Legacy vs New
                       │
       ┌───────────────┼────────────────┐
       ↓               ↓                ↓
   UI Structure    User Workflow    Business Result
       │               │                │
       ↓               ↓                ↓
   控件/权限        操作顺序         API/DB
   必填/状态        Navigation       Calculation
再加：

             Security / Permission
                    ↓
        Screen + Button + API
所以最终不是单纯的：

UI Test

而是：

UI → Workflow → API → DB 的完整链路测试。

对你的项目，我尤其推荐这个最终模型
                    Migration Test
                          │
       ┌──────────────────┼──────────────────┐
       │                  │                  │
       ↓                  ↓                  ↓
    Screen Test       Workflow Test      API Test
       │                  │                  │
       │                  │                  ↓
       │                  │              DB Test
       │                  │                  │
       └──────────────────┴──────────────────┘
                          ↓
                   Legacy / New Diff
                          ↓
                    PASS / DIFF
                          ↓
                  Human Investigation
这样你就可以让 Devin 负责从旧系统提取测试场景、生成 Playwright 测试、执行新旧系统、收集截图/API/DB结果、生成 Diff 报告；Copilot 则主要负责根据项目规范补充测试代码和修正测试。

下一步最值得做的是把这个真正落成一个可执行的 migration-test Skill。 我可以直接给你完整的目录和 SKILL.md + UI-test规范 + Playwright规范 + test-case.yaml + screen-contract.yaml + comparison-rules.yaml + Devin执行指令 + Copilot instructions，让你直接复制到项目里使用。


