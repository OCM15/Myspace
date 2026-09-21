# Batch Migration Strategy

## 背景

有一个旧系统定期 batch 功能，我想保持业务功能不变，但 batch 的启动停止、出错时的控制等偏向系统功能，按新系统标准重构。该怎么做？

## 结论

可以。这个场景不建议定义为 “Batch 功能迁移”，而应定义为：

> 业务处理语义保持 100% 不变，Batch 运行控制层按新系统标准重构。

这是一个非常典型的 Legacy Batch Modernization / Control Layer Refactoring。

关键在于把 “业务逻辑” 和 “运行控制” 彻底分层，否则 Devin / Copilot 很容易在重构时顺手改变业务行为。

---

## 1. 先确定重构边界

建议把旧 Batch 拆成以下 4 层：
┌────────────────────────────────────────────┐
│          新系统 Batch Control Layer        │
│                                            │
│  起动 / 停止 / 参数 / 排他 / Retry /       │
│  Timeout / Error Handling / Logging        │
└─────────────────────┬──────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────┐
│          Batch Application Layer           │
│                                            │
│  BatchController / BatchService            │
│  ↓                                         │
│  业务处理流程                               │
└─────────────────────┬──────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────┐
│          Business Logic Layer              │
│                                            │
│  原来的业务计算、DB更新、文件处理等         │
│                                            │
│  ★ 原则：业务规则不改变                     │
└────────────────────────────────────────────┘
                      │
                      ▼
┌────────────────────────────────────────────┐
│              DB / File / External          │
└────────────────────────────────────────────┘

其中最重要的是：

- 上面两层可以大幅重构；
- 下面的业务处理必须受到严格保护。

---

## 2. 把“业务功能”和“系统功能”明确分开

| 功能 | 旧系统 | 新系统 |
| --- | --- | --- |
| Batch 启动 | shell / scheduler | 新标准 |
| Batch 停止 | kill / shell | 新标准 |
| 参数取得 | 独自方式 | 新标准 |
| 多重启动防止 | 独自控制 | 新标准 |
| 排他控制 | 独自控制 | 新标准 |
| Timeout | 不统一 | 新标准 |
| Retry | 不统一 | 新标准 |
| Error handling | Batch 内部处理 | 新标准 |
| Exit Code | 各 Batch 不同 | 统一 |
| Log | 各 Batch 不同 | 统一 |
| Alert | shell / monitor | 新标准 |
| DB transaction | 原有 | **原则上不改变** |
| 数据处理 | 原有 | **不改变** |
| 业务判断 | 原有 | **不改变** |
| 文件格式 | 原有 | **不改变** |
| DB 更新内容 | 原有 | **不改变** |

由此可以明确：

- System Behavior 可以改变；
- Business Behavior 不可以改变。

---

## 3. 建议定义一个「Behavior Contract」

这是这个项目最重要的部分。

不要只写：

> “业务功能不变。”

这个对 AI 来说太模糊。

更应该定义成机器可以检查的 Contract。

### 示例：Behavior Contract
batch:
  name: XXXBatch

business_invariants:

  input:
    - same input file selection rule
    - same parameter interpretation
    - same record filtering

  processing:
    - same business calculation
    - same validation rule
    - same branching condition

  database:
    - same tables
    - same insert/update/delete semantics
    - same transaction boundary
    - same commit/rollback behavior

  output:
    - same output records
    - same output file format
    - same business result

  error:
    business_error:
      behavior: SAME_AS_LEGACY

    system_error:
      behavior: NEW_STANDARD
                                
### Business Error vs. System Error

#### Business Error

例如：

- 客户不存在
- 交易状态不正确
- 数据格式违反业务规则
- 金额超过业务限制

这些必须保持原系统行为。

#### System Error

例如：

- DB connection failure
- File system failure
- OutOfMemory
- Timeout
- Unexpected Exception
- Process killed
- Dependency unavailable

这些可以按新系统标准重新设计。

---

## 4. Batch Control Layer 建议标准化

BatchLauncher
      │
      ▼
BatchExecutionManager
      │
      ├── ParameterManager
      ├── LockManager
      ├── ExecutionContext
      ├── TransactionManager
      ├── ErrorHandler
      ├── RetryManager
      ├── TimeoutManager
      └── BatchLogger
              │
              ▼
         BatchService
              │
              ▼
       Business Logic

                                                                                                                                          
---

## 5. 启动控制

例如：

```bash
batch-start XXX
```

不要让每个 Batch 自己处理一堆 shell。

统一流程：
Scheduler
   ↓
Batch Launcher
   ↓
Check parameter
   ↓
Check environment
   ↓
Check duplicate execution
   ↓
Create execution ID
   ↓
Start Batch
   ↓
Execute business
   ↓
Result
   ↓
Exit Code
建议统一 Exit Code：

```text
0   SUCCESS
10  BUSINESS_ERROR
20  SYSTEM_ERROR
30  TIMEOUT
40  DUPLICATE_EXECUTION
50  INVALID_PARAMETER
```

---

## 6. 停止控制也应统一

旧系统中容易出现各种各样的停止方式，常常比较乱。

不要让使用者直接执行多个不同机制。

建议采用统一方式：

batch-stop XXX
       │
       ▼
Request Stop
       │
       ▼
BatchExecutionManager
       │
       ├── graceful stop
       │
       ├── timeout
       │
       └── forced termination

                                                                      
然后明确状态：

STOP_REQUESTED
     ↓
STOPPING
     ↓
STOPPED

          
而不是简单规定：

> process disappeared = stopped

---

## 7. Error Control 建议重新设计

建议把异常分成三类：

                    Exception
                       │
             ┌─────────┴─────────┐
             ↓                   ↓
       Business Error        System Error
             │                   │
             ↓                   ↓
      Legacy behavior       New standard
                                 │
                    ┌────────────┼────────────┐
                    ↓            ↓            ↓
                  Retry       Abort        Alert

                                                                                                                                                                                                       
### 示例：异常分类

| Error | Retry | Batch 状态 | Alert |
| --- | --- | --- | --- |
| Business validation | No | BUSINESS_ERROR | 根据旧规则 |
| DB connection | Yes | RETRYING | 最终失败时 |
| Deadlock | Yes | RETRYING | 最终失败时 |
| File I/O | Yes/No | SYSTEM_ERROR | Yes |
| Invalid parameter | No | CONFIG_ERROR | Yes |
| Timeout | No | TIMEOUT | Yes |
| Unexpected exception | No | SYSTEM_ERROR | Yes |

这里千万不要让 AI 自己决定 Retry。

> Retry 本身可能改变业务结果。

---

## 8. Transaction Boundary 尤其重要

这是 Migration 中最容易“看起来没改业务，实际上改了业务”的地方。

### 例子：旧系统

Read 100 records
   ↓
Process
   ↓
UPDATE
   ↓
UPDATE
   ↓
COMMIT

### 例子：新系统

```text
record 1 → COMMIT
record 2 → COMMIT
record 3 → COMMIT
```

虽然最终业务代码完全一样，但业务行为已经发生变化。

因此在 Skill 中应明确：

> Transaction boundary MUST remain unchanged unless explicitly approved.

同样需要保护：

- commit timing
- rollback timing
- isolation level
- lock behavior
- batch restart position
- duplicate processing behavior

---

## 9. 最关键的是建立「Legacy → New Mapping」

每个旧 Batch 都应该做一张映射表。

### 示例：Legacy → New Mapping

| Legacy | New | Change |
| --- | --- | --- |
| XXX.sh | BatchLauncher | Replace |
| XXXMain.java | XXXBatch | Refactor |
| Lock shell | LockManager | Replace |
| Error shell | ErrorHandler | Replace |
| businessService() | businessService() | Preserve |
| DAO | DAO | Preserve |
| SQL | SQL | Preserve |
| Transaction | TransactionManager | Preserve behavior |
| Log | BatchLogger | Replace |
| Exit code | BatchResult | Replace |

### 风险分级

#### GREEN — 可以重构

- 启动
- 停止
- Logging
- Monitoring
- Alert
- Parameter framework
- Lock framework
- Retry framework
- Error framework

#### YELLOW — 必须 Review

- Transaction
- Concurrency
- Timeout
- Restart
- File handling
- External system call

#### RED — 默认禁止修改

- Business rule
- Calculation
- DB business data
- Business validation
- Business branching
- Output business result

---

## 10. 对 Devin / Copilot，建议分成两个 Skill

你之前已经在做 Migration Skill，这个场景非常适合继续拆。

### Skill ①: batch-migration-control.skill

负责：

Legacy Batch
     ↓
Analyze
     ↓
Identify control logic
     ↓
Map to New Batch Framework
     ↓
Generate new control layer

                    ```
                    
#### 主要规则

DO:
- replace startup mechanism
- replace stop mechanism
- standardize exit code
- standardize logging
- standardize error handling
- standardize retry
- standardize timeout
- standardize lock
- standardize monitoring

DO NOT:
- change business rules
- change SQL semantics
- change transaction boundary
- change calculation
- change input/output business semantics

                      
### Skill ②: batch-business-preservation.skill

这个反而更重要。

它的任务不是“开发”，而是监督 AI 不要改业务。

#### Before modification

1. Extract business behavior
2. Identify business methods
3. Identify SQL
4. Identify transaction boundaries
5. Identify input/output
6. Identify error behavior

#### During modification

1. Protect business code
2. Do not rewrite business logic
3. Do not optimize SQL
4. Do not change transaction
5. Do not change data conversion

#### After modification

1. Compare business flow
2. Compare SQL
3. Compare transaction
4. Compare input/output
5. Compare error cases

---

## 11. 测试也要分成两条线

                 Migration
                    │
          ┌─────────┴─────────┐
          ↓                   ↓
 Business Compatibility   System Behavior
          Test                   Test
          │                       │
          ↓                       ↓
   Legacy == New          New Standard

### A. Business Compatibility Test

目标：

> New Batch 的业务结果 == Legacy Batch

### 示例

same input
      ↓
Legacy Batch
      ↓
DB / Output

same input
      ↓
New Batch
      ↓
DB / Output

        ↓
Compare

        ```
        
比较项：

- DB records
- INSERT
- UPDATE
- DELETE
- output files
- calculated values
- status
- error result

### B. System Behavior Test

专门测试新功能：

- Start
- Stop
- Duplicate start
- Invalid parameter
- Timeout
- DB failure
- File failure
- Unexpected exception
- Retry
- Recovery
- Restart
- Alert
- Exit code
- Log

这样就不会出现一个很常见的问题：

> “业务测试全部通过，所以 Migration 成功。”

实际上，Batch Control 可能已经存在严重问题。

---

## 12. 如果 DB 环境不能让 Devin 访问

如果之前提到过这个限制，这种情况下我会采用：
Devin
 │
 ├── Source code
 ├── Test data
 ├── Mock DB
 ├── Golden files
 ├── Expected result
 └── Test scripts
       
真正的 DB Integration Test 由：
CI/CD or human-controlled environment
             ↓
       Integration Test
             ↓
       Legacy vs New

                                        
也就是说：

> Devin 负责生成和执行“可自动验证的测试”，而不是让 Devin 直接控制生产/真实 DB。

---

## 13. 最后形成一个完整的 Migration 流程

建议项目直接采用下面这个流程：

1. Legacy Batch Analysis
2. Business / System Boundary Identification
3. Business Behavior Contract
4. Legacy → New Mapping
5. New Batch Control Framework
6. Migrate Control Layer
7. Freeze Business Logic
8. Business Compatibility Test
9. New System Control Test
10. Legacy / New Comparison
11. Code Review
12. Production Migration

### 最核心的一句话

> 这次不是“把旧 Batch 改造成新 Batch”，而是“在保持 Business Behavior Compatibility 的前提下，将 Legacy Batch 的 Operational Control 重构为 New Batch Standard”。

这个定义非常适合交给 Devin + GitHub Copilot，因为 AI 最容易犯的错误就是把“重构”理解成“顺便优化业务代码”。

---

## 进一步建议

如果你愿意，我下一步可以直接按照你现在的 Java + 新框架 + Devin / Copilot 环境，给你做一份可以直接放进项目里的：

- Batch_Migration_Skill.md
- Batch_Business_Preservation_Skill.md
- Batch_Migration_Checklist.md
- Batch_Migration_TestCase_Template.md

### 建议目录结构

```text
project/
├─ .github/
│  └─ copilot-instructions.md
│
├─ skills/
│  ├─ batch-migration/
│  │  └─ Batch_Migration_Skill.md
│  │
│  └─ batch-business-preservation/
│     └─ Batch_Business_Preservation_Skill.md
│
├─ docs/
│  └─ batch/
│     └─ <batch-name>/
│        ├─ legacy-inventory.md
│        ├─ business-behavior-contract.md
│        ├─ legacy-new-mapping.md
│        ├─ migration-design.md
│        ├─ migration-test-cases.md
│        └─ migration-test-results.md
│
└─ templates/
   ├─ Batch_Migration_Checklist.md
      └─ Batch_Migration_TestCase_Template.md
      ```
      
其中最关键的是两种 Skill 的组合：

- Batch_Migration_Skill：告诉 AI「怎么迁移」
- Batch_Business_Preservation_Skill：告诉 AI「哪些绝对不能动」

这特别适合你现在的 Devin + GitHub Copilot + 新 Java Framework 的 Migration 方式。

### 额外建议：Batch Behavior Contract Template
Legacy Batch
    ↓
Business Flow
    ↓
Input / Output
    ↓
SQL
    ↓
Transaction
    ↓
Error
    ↓
Expected Business Result

                        
在每一个 Batch 开始 Migration 前，先自动生成 Contract，并在 Migration 完成后拿它做 Legacy vs New 差异检查。这样比单纯依赖测试 Case 更能防止 AI 改掉业务功能。

---

## 最后总结

这次的关键不是“把 Batch 迁到新平台”，而是：

- 保住业务语义；
- 重构运行控制；
- 用 Contract + Mapping + Test 双重约束 AI；
- 明确哪些部分可以重构，哪些部分必须冻结。

真正的目标是：

> 在不改变业务行为的前提下，把旧系统的 Batch 运行机制升级为新标准的运维控制模型。
