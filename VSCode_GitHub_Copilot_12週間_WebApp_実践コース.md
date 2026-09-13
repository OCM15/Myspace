# VS Code + GitHub Copilot：12週間 Web Application 実践コース

## 1. コースの目標

完全な `Transaction Management System` プロジェクトを通して、以下を体系的に学習します：

- VS Code
- Git / GitHub
- Java
- Maven
- Spring Boot
- REST API
- MyBatis
- Oracle
- HTML / CSS / JavaScript
- ユーザー、ユーザーグループ、画面及ボタン権限
- JUnit / Integration テスト
- GitHub Copilot
- `copilot-instructions.md`
- `AGENTS.md`
- Skills
- GitHub Actions
- コードレビュー / リファクタリング

最終目標：

> VS Code + GitHub Copilotを活用して、エンタープライズシステムとしての基本構造を備えたJava Web Applicationを自力で開発できるようになる。

---

# 2. 実践プロジェクト

## プロジェクト名

`Transaction Management System`

## 業務概要

以下の果物の取引を管理します：

- BUY：果物の仕入れ
- SELL：果物の販売
- DISPOSE：果物の廃棄・破棄

例：リンゴ、ナシ、バナナ

## 最終機能

### Transaction

- 一覧
- 検索
- 新規登録
- 更新
- 削除
- 詳細情報

### User

- ユーザー一覧
- ユーザーグループ管理

### Permission

- 画面権限
- ボタン権限

### システム基本機能

- バリデーション
- 例外処理
- ロギング
- 監査ログ
- 認証 / 認可
- テスト
- CI

---

# 3. 推奨テクノロジースタック

```text
IDE             VS Code
Language        Java
Build           Maven
Framework       Spring Boot
Database        Oracle
DB Access       MyBatis
Frontend        HTML / CSS / JavaScript
API             REST / JSON
テスト            JUnit / Spring Boot テスト
SCM             Git / GitHub
AI              GitHub Copilot
CI              GitHub Actions
```

第1段階では、React、JPA、Dockerなど、多くの技術を同時に学習しないことを推奨します。

まずは Java + Spring Boot + MyBatis + Oracle + ネイティブフロントエンドを一通り完成させます。

---

# 4. AIの利用原則

このコースの目的は「Copilotにコードを全部書かせること」ではありません。

以下の開発サイクルを採用します：

```text
理解
    ↓
設計
    ↓
承認
    ↓
実装
    ↓
テスト
    ↓
レビュー
    ↓
リファクタリング
```

Copilotの主な5つの使い方：

### Explain（説明）

```text
Explain this code.
Do not modify anything.
```

### 設計（設計）

```text
設計 the solution.
Do not write code yet.
```

### 実装（実装）

```text
実装 the approved design.
```

### テスト（テスト）

```text
Create comprehensive test cases
for this implementation.
```

### レビュー（レビュー）

```text
レビュー this implementation.
Find bugs, security issues,
performance issues and design problems.
Do not modify the code.
```

---

# 5. 学習ルール

## Rule 1

Copilotにプロジェクト全体を一度に作成させない。

## Rule 2

まず設計を理解し、その後にAIへ実装を依頼する。

## Rule 3

毎週、実行可能な成果物を完成させる。

## Rule 4

重要な変更はすべてGit commitとして保存する。

## Rule 5

AIが生成したコードは必ず人間がレビューする。

## Rule 6

理解できないコードに遭遇したら、まずCopilotに質問する：

```text
Explain why this implementation is necessary.
```

---

# 6. 12週間コース概要

| 週 | テーマ | 主な成果 |
|---|---|---|
| Week 1 | VS Code / Git / GitHub | プロジェクト作成 |
| Week 2 | Java | Java基礎コード |
| Week 3 | Spring Boot | 最初のWeb API |
| Week 4 | REST / CRUD | Transaction API |
| Week 5 | MyBatis / Oracle | DB接続 |
| Week 6 | HTML / CSS / JavaScript | Web画面 |
| Week 7 | 完全なCRUD | 第1版システム |
| Week 8 | 権限システム | User / Group / Permission |
| Week 9 | エンタープライズ基盤 | Validation / Exception / Logging |
| Week 10 | テスト | Unit / Integration テスト |
| Week 11 | Copilot Engineering | Instructions / Agent / Skills |
| Week 12 | CI / レビュー / リファクタリング | 完成したプロジェクト |

---

# Week 1：VS Code + Git + GitHub

## 学習目標

以下を習得する：

- VS Codeの基本操作
- Terminal
- Git
- GitHub Repository
- Branch
- Commit
- Push / Pull
- `.gitignore`

## プロジェクトの作成

```text
transaction-management/
├── README.md
├── .gitignore
└── pom.xml
```

## 演習

1. JDKをインストール
2. VS Codeをインストール
3. Java Extension Packをインストール
4. Gitをインストール
5. GitHub Repositoryを作成
6. RepositoryをClone
7. 最初のJava/Mavenプロジェクトを作成
8. Commit
9. Push

## Copilot演習

```text
Explain this project structure.
Do not modify anything.
```

```text
Explain pom.xml to me.
Assume I know C and VB.NET but
am new to modern Java.
```

## 今週の成果

GitHub上にClone可能なプロジェクトが存在する状態にする。

---

# Week 2：Java

## 学習目標

すべてのプログラミング基礎を最初から学び直すのではなく、モダンJavaを重点的に学習します。

## 学習内容

### Class

```java
public class Transaction {
}
```

### Interface

```java
public interface TransactionRepository {
}
```

### Record

```java
public record TransactionDto(
    Long id,
    String type,
    BigDecimal amount
) {}
```

### Enum

```java
public enum TransactionType {
    BUY,
    SELL,
    DISPOSE
}
```

### Collection

```text
List
Map
Set
```

### Stream

```java
transactions.stream()
```

### Exception

```text
checked exception
unchecked exception
custom exception
```

### Generics

### Annotation

## 演習

まず自分で作成します：

```text
Transaction
Customer
TransactionType
TransactionStatus
TransactionDto
```

## Copilot

まず自分でコードを書き、その後：

```text
レビュー this Java code.
Explain possible improvements.
Do not modify it.
```

## 今週の成果

基本的なJava Domain / DTOを自力で理解・変更できる。

---

# Week 3：Spring Boot

## 学習目標

理解：

```text
Spring Boot
Dependency Injection
Controller
Service
Repository
Configuration
```

## プロジェクト構成

```text
src/main/java/
└── com.example.transaction
    ├── TransactionApplication.java
    ├── controller/
    ├── service/
    ├── repository/
    ├── model/
    └── dto/
```

## 最初のAPI

```http
GET /api/transactions
```

返回：

```json
[
  {
    "id": 1,
    "type": "BUY",
    "amount": 100000
  }
]
```

## 学習ポイント

理解：

```text
Browser
  ↓
HTTP
  ↓
Controller
  ↓
Service
  ↓
Repository
```

## Copilot演習

```text
Explain Spring Dependency Injection
using this project as an example.
Do not modify any files.
```

その後：

```text
実装 the TransactionController
according to the existing project structure.
```

## 今週の成果

Spring Bootを起動し、APIへアクセスできるようにします。

---

# Week 4：REST API + CRUD

## API設計

```http
GET    /api/transactions
GET    /api/transactions/{id}
POST   /api/transactions
PUT    /api/transactions/{id}
DELETE /api/transactions/{id}
```

## 学習内容

- HTTP Method
- HTTP Status
- Request
- Response
- JSON
- DTO
- バリデーション基础
- REST API設計

## 演習

完成：

```text
Search
Detail
Create
Update
Delete
```

## Copilot任务

まず次を依頼します：

```text
設計 the Transaction CRUD API.
Do not write code.
```

設計を確認した後：

```text
実装 the approved API design.
```

## 今週の成果

REST Client / Postman / ブラウザを使って、完全なCRUD APIをテストできる。

---

# Week 5：Oracle + MyBatis

## データベース

作成するテーブル：

```text
CUSTOMER
TRANSACTION
USER
USER_GROUP
```

主要テーブル：

```sql
TRANSACTION
-------------------------
ID
TRANSACTION_TYPE
CUSTOMER_ID
AMOUNT
TRADE_DATE
STATUS
CREATED_AT
UPDATED_AT
```

## MyBatis结构

```text
Service
   ↓
Mapper
   ↓
SQL
   ↓
Oracle
```

学習項目：

- JDBC基本概念
- Connection Pool
- MyBatis Mapper
- XML Mapper
- SQL
- ResultMap
- Dynamic SQL
- Pagination
- Transaction

## Copilot演習

```text
Analyze the database access design.
Compare the responsibilities of
Service and MyBatis Mapper.
Do not modify code.
```

## 今週の成果

APIから実際にOracleを読み書きできるようにします。

---

# Week 6：HTML + CSS + JavaScript

## 学習目標

Reactは使用せず、まずブラウザの基本的な仕組みを理解する。

## 画面

```text
transaction-list.html
transaction-detail.html
transaction-edit.html
```

## JavaScript

使用：

```javascript
fetch()
```

调用：

```text
GET /api/transactions
POST /api/transactions
PUT /api/transactions/{id}
DELETE /api/transactions/{id}
```

## 学習

```text
HTML
CSS
DOM
JavaScript
Fetch API
JSON
Form
Event
```

## 今週の成果

ブラウザから以下を実行できる：

```text
Search
List
New
Edit
Delete
```

---

# Week 7：完全なCRUD + 第1版システム

ここまでの6週間の内容を統合します。

## 最終アーキテクチャ

```text
                 Browser
                    │
              HTML / JS / CSS
                    │
                 REST API
                    │
              Controller
                    │
                 Service
                    │
                 MyBatis
                    │
                  Oracle
```

## 追加する要素

- DTO
- バリデーション
- Error Response
- Pagination
- Search Condition
- Common Utility

## Copilot任务

```text
レビュー the whole application architecture.

Check:
1. Layering
2. Dependency direction
3. DTO usage
4. Error handling
5. SQL design
6. Security risks
7. テストability

Do not modify code.
```

## 今週の成果

第1版の利用可能なWeb Applicationを完成させます。

---

# Week 8：権限システム

このプロジェクトの重要な段階です。

## データモデル

```text
USER
  ↓
USER_GROUP
  ↓
PERMISSION
  ↓
SCREEN / BUTTON
```

建议表：

```text
USER
USER_GROUP
USER_GROUP_MEMBER

SCREEN
BUTTON

SCREEN_PERMISSION
BUTTON_PERMISSION
```

## 権限の例

```text
                 Admin  Manager  Operator
Transaction List    ✓      ✓         ✓
New                 ✓      ✓         ✓
Edit                ✓      ✓         ×
Delete              ✓      ×         ×
User Management     ✓      ×         ×
```

## API

```http
GET /api/me
GET /api/permissions
```

## 重要なポイント

フロントエンド：

```text
隐藏ボタン
```

これはUX上の制御にすぎません。

本当のセキュリティ制御は必ず：

```text
Backend API
```

で実施します。

## 今週の成果

User Groupごとに利用可能な機能を変え、バックエンドでも権限のない操作を確実に拒否できるようにします。

---

# Week 9：エンタープライズ基盤

## Validation（バリデーション）

例：

```text
Quantity > 0
Fruit Code 必須
Transaction Typeは有効な値でなければならない
```

## Exception Handling（例外処理）

統一的な処理を作成します：

```text
GlobalExceptionHandler
```

例：

```text
400 Validation Error
401 Unauthorized
403 Forbidden
404 Not Found
409 Conflict
500 Internal Server Error
```

## Logging（ログ）

記録する情報：

```text
Request
User
Operation
Error
Duration
```

機密情報をログに記録しないようにします。

## Transaction

理解：

```text
@Transactional
```

以下も理解します：

```text
Commit
Rollback
```

## Audit（監査）

記録する情報：

```text
Who
When
What
Before
After
```

## 今週の成果

Demoから、企業システムとしての基本特性を備えたApplicationへ発展させる。

---

# Week 10：テスト

## Unit テスト（単体テスト）

重点：

```text
Service
Permission
Validation
```

## Integration テスト（結合テスト）

テスト対象：

```text
API
Database
MyBatis
```

## テストケース

```text
TC-001 Search transaction
TC-002 Search with conditions
TC-003 Create transaction
TC-004 Update transaction
TC-005 Delete transaction
TC-006 Invalid amount
TC-007 Missing customer
TC-008 Operator cannot edit
TC-009 Operator cannot delete
TC-010 Unauthorized API access
```

## Copilot

```text
Analyze this service and create
comprehensive unit test cases.

Include:
- normal cases
- boundary cases
- error cases
- authorization cases
```

## 今週の成果

主要な業務ロジックに自動テストを整備します。

---

# Week 11：GitHub Copilot Engineering

这是本课程的核心。

## 作成

```text
.github/
└── copilot-instructions.md

AGENTS.md

docs/
├── requirements.md
├── architecture.md
├── database-design.md
├── api-design.md
└── development-rules.md

skills/
├── add-db-column/
│   └── SKILL.md
├── add-api/
│   └── SKILL.md
├── add-screen/
│   └── SKILL.md
└── change-permission/
    └── SKILL.md
```

## copilot-instructions.md

定義する内容：

```text
Architecture
Coding conventions
Naming rules
テスト requirements
Security rules
Database rules
API rules
```

## AGENTS.md

記載する内容：

```text
How the AI should work
Project workflow
Important constraints
レビュー requirements
```

## Skills

### add-db-column

AIに次の影響範囲を確認させます：

```text
DB
Entity / Model
DTO
Mapper
Service
API
Frontend
テスト
Documentation
```

### add-api

要求：

```text
Controller
Request DTO
Response DTO
Service
Mapper
Validation
Exception
テスト
```

### add-screen

要求：

```text
HTML
CSS
JavaScript
API
Permission
Validation
テスト
```

### change-permission

要求：

```text
User Group
Screen Permission
Button Permission
Backend
Frontend
テスト
```

## 最重要的演習

提出：

> Add COLLATERAL_AMOUNT to TRANSACTION.

AIにいきなり変更を実施させない。

第一步：

```text
Analyze the impact.
Do not modify files.
```

然后检查：

```text
Affected files
Affected tables
Affected APIs
Affected screens
Affected tests
Risks
```

確認後：

```text
実装 the approved change.
```

## 今週の成果

自分自身のAI-assisted Development Workflowを確立する。

---

# Week 12：CI + Code レビュー + リファクタリング

## GitHub Actions

基本フロー：

```text
Push
 ↓
Build
 ↓
Unit テスト
 ↓
Integration テスト
 ↓
Package
```

## Code レビュー

Copilot：

```text
レビュー this Pull Request.

Focus on:
- bugs
- security
- performance
- maintainability
- architecture
- test coverage
```

## リファクタリング

演習：

```text
Before
 ↓
Identify technical debt
 ↓
設計 refactoring
 ↓
実装
 ↓
Run tests
 ↓
レビュー
```

## 最終成果

GitHubリポジトリ：

```text
transaction-management/
│
├── .github/
│   ├── copilot-instructions.md
│   └── workflows/
│
├── AGENTS.md
│
├── docs/
│   ├── requirements.md
│   ├── architecture.md
│   ├── database-design.md
│   ├── api-design.md
│   └── development-rules.md
│
├── skills/
│   ├── add-db-column/
│   ├── add-api/
│   ├── add-screen/
│   └── change-permission/
│
├── backend/
│
├── frontend/
│
└── README.md
```

---

# 7. 毎週の学習サイクル

毎週、以下の開発サイクルを採用します：

```text
Day 1
Learn
 ↓
Day 2
Practice
 ↓
Day 3
Build
 ↓
Day 4
Copilot
 ↓
Day 5
テスト
 ↓
Day 6
レビュー
 ↓
Day 7
リファクタリング + Summary
```

---

# 8. 毎週必ず答える5つの質問

毎週の学習終了後、コードを見るだけで終わらせないでください。

次の質問に答えてください：

1. 1. 何を理解したか？
2. 2. どの部分をCopilotが書いたか？
3. 3. どの部分なら自分で書けるか？
4. 4. Copilotがなくても、このコードを説明できるか？
5. 5. 要件が変わった場合、どこを修正すべきか分かるか？

---

# 9. 最終スキルチェックリスト

## VS Code

- [ ] 能使用 Terminal
- [ ] 能 Debug
- [ ] 能検索プロジェクト
- [ ] 能查看 Git Diff
- [ ] 能管理 Branch

## Java

- [ ] Class
- [ ] Interface
- [ ] Record
- [ ] Enum
- [ ] Collection
- [ ] Stream
- [ ] Exception
- [ ] Annotation

## Spring Boot

- [ ] Controller
- [ ] Service
- [ ] Dependency Injection
- [ ] Configuration
- [ ] REST API
- [ ] Exception Handling

## Database

- [ ] Oracle
- [ ] SQL
- [ ] MyBatis
- [ ] Transaction
- [ ] Index
- [ ] Pagination

## Frontend

- [ ] HTML
- [ ] CSS
- [ ] JavaScript
- [ ] DOM
- [ ] Fetch API
- [ ] JSON

## Security

- [ ] Authentication
- [ ] Authorization
- [ ] User Group
- [ ] Screen Permission
- [ ] Button Permission
- [ ] Backend authorization

## テスト

- [ ] Unit テスト
- [ ] Integration テスト
- [ ] Boundary テスト
- [ ] Error テスト
- [ ] Authorization テスト

## GitHub Copilot

- [ ] Explain
- [ ] 設計
- [ ] 実装
- [ ] テスト
- [ ] レビュー
- [ ] リファクタリング
- [ ] Instructions
- [ ] AGENTS.md
- [ ] Skills

## CI/CD

- [ ] GitHub Actions
- [ ] Build
- [ ] テスト
- [ ] Package
- [ ] Pull Request
- [ ] Code レビュー

---

# 10. 12週間終了時の最終チャレンジ

コース終了後も、ここで学んだ開発サイクルを継続してください。

做以下变更：

## Challenge 1

追加：

```text
COUNTERPARTY_CODE
```

AIには次を要求します：

```text
Impact Analysis
→ 設計
→ 実装ation
→ テスト
→ レビュー
```

## Challenge 2

追加：

```text
Fruit Inventory Screen
```

要求：

```text
New Screen
New API
DB Change
Permission
テスト
```

## Challenge 3

新しいUser Groupを追加します：

```text
Auditor
```

許可する操作：

```text
View
Search
Export
```

禁止する操作：

```text
Create
Update
Delete
```

## Challenge 4

Copilotにプロジェクト全体をレビューさせます。

次の観点で確認させます：

```text
Security
Performance
Architecture
Maintainability
テスト
Database
```

---

# 11. 最終的な学習目標

このプロジェクトを完了した後は、次のような要件を見たときに、

> 「Transactionテーブルに1項目を追加し、画面にも表示する。ただし、Manager以上の権限を持つユーザーだけが更新できる。」

然后自己迅速拆成：

```text
Requirement
    ↓
Impact Analysis
    ↓
Database
    ↓
Java
    ↓
MyBatis
    ↓
Service
    ↓
API
    ↓
Frontend
    ↓
Permission
    ↓
テスト
    ↓
レビュー
    ↓
Git Commit / PR
```

そのうえで、GitHub Copilotに実装作業の大部分を支援させられるようになることを目指します。

**このコースで本当に身につけたい能力は、「Javaを書けること」ではなく、「AIを活用して完全なWeb Applicationを開発・保守できること」です。**
