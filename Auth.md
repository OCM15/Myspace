以下の内容を、元の意味を保ちながら日本語に翻訳し、Markdown の見出しや構造を適切に整えました。

# Web App 権限管理設計規約

## 1. 目的

本システムでは、RBAC（Role-Based Access Control）を用いてユーザー権限を管理します。

権限管理では、次をサポートする必要があります。

- ユーザー管理
- ユーザーグループ管理
- 1人のユーザーが複数のユーザーグループに所属できる
- ユーザーグループによる画面アクセス権限の制御
- ユーザーグループによるボタン／機能権限の制御
- バックエンド API 権限制御
- フロントエンドのメニュー、画面、ボタン表示制御
- データ範囲（Data Scope）制御
- 権限キャッシュ
- 権限変更後のキャッシュ更新
- 権限関連のユニットテストと統合テスト

技術前提:

- Java
- Spring Boot
- Spring Security
- MyBatis
- Oracle
- REST API
- Web Frontend

---

## 2. 全体の権限モデル

採用する関係は次の通りです。

User → Group → Permission → Resource

同時に次もサポートします。

Permission → Data Scope

全体の関係は次のとおりです。

```text
User
↓
User Group
↓
Group Permission
↓
Permission
↓
Screen / Function / API
↓
Data Scope
```

例:

User: TANAKA

所属グループ:

- SALES
- APPROVER

権限:

```text
SALES
├─ TRADE_VIEW
├─ TRADE_CREATE
└─ TRADE_UPDATE

APPROVER
├─ TRADE_VIEW
└─ TRADE_APPROVE
```

最終的なユーザー権限は、所属する全グループの権限の UNION です。

---

## 3. DB テーブル設計

### 3.1 USER

```sql
CREATE TABLE APP_USER (
    USER_ID        VARCHAR2(50) PRIMARY KEY,
    USER_NAME      VARCHAR2(100) NOT NULL,
    PASSWORD_HASH  VARCHAR2(255),
    STATUS         VARCHAR2(20) NOT NULL,
    CREATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP,
    CREATED_BY     VARCHAR2(50),
    UPDATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP,
    UPDATED_BY     VARCHAR2(50)
);
```

STATUS:

```text
ACTIVE
INACTIVE
LOCKED
```

---

### 3.2 USER_GROUP

```sql
CREATE TABLE USER_GROUP (
    GROUP_ID       VARCHAR2(50) PRIMARY KEY,
    GROUP_NAME     VARCHAR2(100) NOT NULL,
    DESCRIPTION    VARCHAR2(500),
    STATUS         VARCHAR2(20) NOT NULL,
    CREATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP,
    CREATED_BY     VARCHAR2(50),
    UPDATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP,
    UPDATED_BY     VARCHAR2(50)
);
```

例:

```text
ADMIN
SALES
ACCOUNTING
APPROVER
VIEWER
```

---

### 3.3 USER_GROUP_MEMBER

ユーザーとグループは N:N 関係です。

```sql
CREATE TABLE USER_GROUP_MEMBER (
    USER_ID        VARCHAR2(50) NOT NULL,
    GROUP_ID       VARCHAR2(50) NOT NULL,
    CREATED_AT     TIMESTAMP DEFAULT SYSTIMESTAMP,
    CREATED_BY     VARCHAR2(50),

    CONSTRAINT PK_USER_GROUP_MEMBER
        PRIMARY KEY (USER_ID, GROUP_ID),

    CONSTRAINT FK_UGM_USER
        FOREIGN KEY (USER_ID)
        REFERENCES APP_USER(USER_ID),

    CONSTRAINT FK_UGM_GROUP
        FOREIGN KEY (GROUP_ID)
        REFERENCES USER_GROUP(GROUP_ID)
);
```

---

### 3.4 SCREEN

システム画面を定義します。

```sql
CREATE TABLE APP_SCREEN (
    SCREEN_ID      VARCHAR2(50) PRIMARY KEY,
    SCREEN_CODE    VARCHAR2(100) NOT NULL UNIQUE,
    SCREEN_NAME    VARCHAR2(200) NOT NULL,
    URL            VARCHAR2(500),
    PARENT_CODE    VARCHAR2(100),
    DISPLAY_ORDER  NUMBER,
    STATUS         VARCHAR2(20) NOT NULL
);
```

例:

```text
TRADE
 ├─ TRADE_SEARCH
 ├─ TRADE_INPUT
 └─ TRADE_APPROVAL

MASTER
 ├─ USER_MAINTENANCE
 └─ GROUP_MAINTENANCE
```

PARENT_CODE はメニューレベル構造を作るために使用します。

---

### 3.5 PERMISSION

業務機能権限を定義します。

```sql
CREATE TABLE APP_PERMISSION (
    PERMISSION_ID    VARCHAR2(50) PRIMARY KEY,
    PERMISSION_CODE  VARCHAR2(100) NOT NULL UNIQUE,
    PERMISSION_NAME  VARCHAR2(200) NOT NULL,
    DESCRIPTION      VARCHAR2(500),
    STATUS           VARCHAR2(20) NOT NULL
);
```

例:

```text
TRADE_VIEW
TRADE_CREATE
TRADE_UPDATE
TRADE_DELETE
TRADE_APPROVE
TRADE_EXPORT
```

ボタン ID を権限 ID にしてはいけません。

例:

推奨しない例:

```text
BUTTON_001
BUTTON_002
BUTTON_003
```

推奨する例:

```text
TRADE_CREATE
TRADE_UPDATE
TRADE_APPROVE
```

理由は、権限は「業務上の能力」を表し、UI 要素そのものではないからです。

---

### 3.6 GROUP_PERMISSION

```sql
CREATE TABLE GROUP_PERMISSION (
    GROUP_ID        VARCHAR2(50) NOT NULL,
    PERMISSION_ID   VARCHAR2(50) NOT NULL,
    CREATED_AT      TIMESTAMP DEFAULT SYSTIMESTAMP,
    CREATED_BY      VARCHAR2(50),

    CONSTRAINT PK_GROUP_PERMISSION
        PRIMARY KEY (GROUP_ID, PERMISSION_ID),

    CONSTRAINT FK_GP_GROUP
        FOREIGN KEY (GROUP_ID)
        REFERENCES USER_GROUP(GROUP_ID),

    CONSTRAINT FK_GP_PERMISSION
        FOREIGN KEY (PERMISSION_ID)
        REFERENCES APP_PERMISSION(PERMISSION_ID)
);
```

例:

| Group    | Permission    |
| -------- | ------------- |
| SALES    | TRADE_VIEW    |
| SALES    | TRADE_CREATE  |
| SALES    | TRADE_UPDATE  |
| APPROVER | TRADE_VIEW    |
| APPROVER | TRADE_APPROVE |

---

### 3.7 SCREEN_PERMISSION

「どの権限がどの画面に対応するか」を明確に記録するため、次のテーブルを追加することを推奨します。

```sql
CREATE TABLE SCREEN_PERMISSION (
    SCREEN_ID       VARCHAR2(50) NOT NULL,
    PERMISSION_ID   VARCHAR2(50) NOT NULL,

    CONSTRAINT PK_SCREEN_PERMISSION
        PRIMARY KEY (SCREEN_ID, PERMISSION_ID)
);
```

例:

```text
TRADE_SEARCH
    └─ TRADE_VIEW

TRADE_INPUT
    ├─ TRADE_VIEW
    ├─ TRADE_CREATE
    └─ TRADE_UPDATE

TRADE_APPROVAL
    ├─ TRADE_VIEW
    └─ TRADE_APPROVE
```

これにより、1つの権限が全く無関係な画面に誤って使われることを防げます。

---

### 3.8 DATA_SCOPE

将来、部門、担当者、地域などのデータ範囲制御が必要になる場合は、次を追加します。

```sql
CREATE TABLE GROUP_DATA_SCOPE (
    GROUP_ID       VARCHAR2(50) NOT NULL,
    RESOURCE_CODE  VARCHAR2(100) NOT NULL,
    SCOPE_TYPE     VARCHAR2(30) NOT NULL,

    CONSTRAINT PK_GROUP_DATA_SCOPE
        PRIMARY KEY (GROUP_ID, RESOURCE_CODE)
);
```

SCOPE_TYPE:

```text
OWN
DEPARTMENT
ALL
```

例:

```text
SALES
TRADE
DEPARTMENT

MANAGER
TRADE
ALL
```

このようにすると、同一の権限を持っていても、

```text
TRADE_VIEW
```

を持つ2人でも、見られるデータが異なります。

---

## 4. 権限レベル

権限は3つの層に分けて考えます。

### Layer 1: Screen Access

制御対象:

> ユーザーが画面にアクセスできるかどうか

例:

```text
TRADE_APPROVAL + VIEW
```

この権限がない場合:

```text
メニュー非表示
URL 直接アクセス → 403
```

---

### Layer 2: Function / Button Access

例:

```text
TRADE_CREATE
TRADE_UPDATE
TRADE_DELETE
TRADE_APPROVE
TRADE_EXPORT
```

対応する UI:

```text
[新規登録]
[変更]
[削除]
[承認]
[CSV出力]
```

---

### Layer 3: Data Scope

例:

```text
OWN
DEPARTMENT
ALL
```

最終的な権限判定:

```text
Can Access Screen?
       ↓
Can Execute Function?
       ↓
Can Access This Data?
```

---

## 5. API 設計

### 5.1 現在のユーザー権限

```http
GET /api/me
```

返却例:

```json
{
  "userId": "U001",
  "userName": "Tanaka",
  "groups": [
    "SALES",
    "APPROVER"
  ],
  "permissions": [
    "TRADE_VIEW",
    "TRADE_CREATE",
    "TRADE_UPDATE",
    "TRADE_APPROVE"
  ]
}
```

フロントエンドはログイン後にこの権限を取得します。

---

### 5.2 現在のユーザーメニュー

```http
GET /api/me/menus
```

返却例:

```json
[
  {
    "screenCode": "TRADE_SEARCH",
    "screenName": "取引検索",
    "url": "/trade/search",
    "children": []
  },
  {
    "screenCode": "TRADE_INPUT",
    "screenName": "取引入力",
    "url": "/trade/input",
    "children": []
  }
]
```

サーバーは、ユーザーがアクセス権を持つメニューのみを返却します。

したがって、フロントエンド側でメニュー権限を自前で計算する必要はありません。

---

### 5.3 ユーザーグループ権限の取得

```http
GET /api/admin/groups/{groupId}/permissions
```

---

### 5.4 ユーザーグループ権限の更新

```http
PUT /api/admin/groups/{groupId}/permissions
```

Request 例:

```json
{
  "permissions": [
    "TRADE_VIEW",
    "TRADE_CREATE",
    "TRADE_UPDATE"
  ]
}
```

更新後は、該当グループに所属するユーザーの権限キャッシュを必ず更新してください。

---

### 5.5 ユーザー所属グループの取得

```http
GET /api/admin/users/{userId}/groups
```

---

### 5.6 ユーザーグループ変更

```http
PUT /api/admin/users/{userId}/groups
```

Request 例:

```json
{
  "groups": [
    "SALES",
    "APPROVER"
  ]
}
```

変更後は、そのユーザーの権限キャッシュを更新します。

---

## 6. Java の Annotation

次のように定義することを推奨します。

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface RequirePermission {

    String value();
}
```

Controller の例:

```java
@RequirePermission("TRADE_APPROVE")
@PostMapping("/trade/{id}/approve")
public ResponseEntity<?> approve(
        @PathVariable String id) {

    return ResponseEntity.ok().build();
}
```

これにより、業務コードが非常に分かりやすくなります。

---

## 7. Spring Security の利用を推奨

権限チェックは Spring Security に集約させるべきです。

例:

```java
@PreAuthorize("hasAuthority('TRADE_APPROVE')")
@PostMapping("/trade/{id}/approve")
public ResponseEntity<?> approve(
        @PathVariable String id) {

    ...
}
```

カスタム Annotation を使う場合:

```java
@RequirePermission("TRADE_APPROVE")
```

AOP / Method Security で一元処理します。

原則:

**Controller が自分で DB を参照して権限判定をしないこと。**

---

## 8. PermissionService

共通インターフェースを定義します。

```java
public interface PermissionService {

    boolean hasPermission(
        String userId,
        String permissionCode
    );

    Set<String> getPermissions(
        String userId
    );

    boolean hasScreenAccess(
        String userId,
        String screenCode
    );

    DataScope getDataScope(
        String userId,
        String resourceCode
    );
}
```

業務コードはこの Service を通じて権限を取得するように統一します。

---

## 9. 権限キャッシュ

API ごとに次のテーブルを毎回参照すると、

```text
USER
↓
USER_GROUP_MEMBER
↓
GROUP_PERMISSION
↓
PERMISSION
```

大量の DB アクセスが発生します。

そのため、キャッシュを導入することを推奨します。

### 推奨方式

単一サーバーの場合:

```text
Caffeine
```

複数サーバーの場合:

```text
Redis
```

本番環境では、通常は次の構成を推奨します。

```text
Spring Boot
    ↓
Redis
    ↓
Oracle
```

---

## 10. Cache Key

例:

```text
permission:user:U001
```

Value:

```json
[
  "TRADE_VIEW",
  "TRADE_CREATE",
  "TRADE_UPDATE",
  "TRADE_APPROVE"
]
```

Data Scope:

```text
scope:user:U001:TRADE
```

---

## 11. 権限取得フロー

初回アクセス時:

```text
API
 ↓
PermissionService
 ↓
Redis
 ↓
Cache Miss
 ↓
Oracle
 ↓
Redis
 ↓
Permission Check
```

以後:

```text
API
 ↓
PermissionService
 ↓
Redis
 ↓
Permission Check
```

---

## 12. 権限変更後のキャッシュ無効化

これは実装時に非常に重要なポイントです。

例:

管理者が `SALES` グループの権限を変更したとします。

単に管理者自身のキャッシュだけを更新してはなりません。必ず次を行います。

```text
GROUP_PERMISSION changed
        ↓
Find all users in Group
        ↓
Invalidate
permission:user:U001
permission:user:U002
permission:user:U003
...
```

ユーザーが次にアクセスした時に、DB から再ロードされます。

---

## 13. フロントエンドの権限制御

フロントエンドログイン後:

```http
GET /api/me
```

次のような権限情報を取得します。

```json
{
  "permissions": [
    "TRADE_VIEW",
    "TRADE_CREATE",
    "TRADE_UPDATE"
  ]
}
```

定義例:

```javascript
hasPermission("TRADE_UPDATE")
```

使用例:

```javascript
if (hasPermission("TRADE_UPDATE")) {
    showEditButton();
}
```

ただし、次を明確に理解しておく必要があります。

**フロントエンドの権限制御は安全制御ではありません。**

フロントエンドで行うのは:

```text
ボタンを非表示にする
```

という UX 制御のみです。

本当の安全制御は次です。

```text
Backend API
 ↓
Spring Security
 ↓
Permission Check
```

---

## 14. 推奨フロントエンドコンポーネント

次のような構成にできます。

```jsx
<Permission permission="TRADE_CREATE">
    <button>新規登録</button>
</Permission>
```

または:

```html
<button v-if="hasPermission('TRADE_CREATE')">
    新規登録
</button>
```

具体的な実装方法は React / Vue / Angular に応じて決めます。

---

## 15. メニュー制御

フロントエンドで次のように書かないでください。

```javascript
if (user.group === "ADMIN")
```

または

```javascript
if (user.group === "SALES")
```

代わりに、次のような Permission ベースで制御してください。

```text
TRADE_VIEW
TRADE_CREATE
TRADE_APPROVE
```

これにより、将来次のようなグループが増えても、

```text
SALES_MANAGER
OVERSEAS_SALES
SPECIAL_APPROVER
```

フロントエンド側をほぼ変更せずに対応できます。

---

## 16. 403 の扱い

権限がない場合:

```http
HTTP 403 Forbidden
```

返却例:

```json
{
  "code": "FORBIDDEN",
  "message": "You do not have permission to perform this operation."
}
```

フロントエンドでは共通処理でハンドリングします。

---

## 17. 401 と 403 の区別

次の区別を明確にしてください。

```text
401 Unauthorized
```

意味:

> ログインしていない / Token が無効

```text
403 Forbidden
```

意味:

> ログイン済みだが権限がない

---

## 18. 管理画面

最低限、次の管理画面は用意することを推奨します。

### ユーザー管理

```text
User
 ├─ User ID
 ├─ Name
 ├─ Status
 └─ Groups
```

### グループ管理

```text
Group
 ├─ Group Name
 ├─ Description
 └─ Permissions
```

権限画面は Tree / Checkbox の形式にすると管理しやすくなります。

```text
□ 取引
   ☑ 取引検索
      ☑ VIEW

   ☑ 取引入力
      ☑ VIEW
      ☑ CREATE
      ☑ UPDATE
      ☐ DELETE

   ☐ 取引承認
      ☐ VIEW
      ☐ APPROVE
```

この形式だと、管理者が権限構成を理解しやすくなります。

---

## 19. 「Admin = すべての権限文字列」を設定しないことを推奨

```text
ADMIN
```

のようなグループは存在してよいですが、Java コード内で大量に次のような分岐を書いてはいけません。

```java
if (user.isAdmin()) {
    allow();
}
```

より良い方法は、ADMIN グループに次の権限を持たせることです。

```text
すべての Permission
```

または、特殊なグループを用意して、

```text
SYSTEM_ADMIN
```

のようにしても最終的には統一権限仕組みに入ります。

これにより、権限体系が2重化されるのを防げます。

---

## 20. データ権限

業務データに次のような列がある場合:

```text
COMPANY_CODE
DEPARTMENT_CODE
USER_ID
```

フロントエンドでのみ制限してはいけません。

例:

```text
SALES_USER
DATA_SCOPE = DEPARTMENT
```

SQL は最終的に次のような条件を生成すべきです。

```sql
WHERE DEPARTMENT_CODE = :currentDepartment
```

一方、

```text
MANAGER
DATA_SCOPE = ALL
```

なら Department 条件は追加しません。

データ権限は必ずバックエンド側で実装してください。

---

## 21. テストケース

### 21.1 Screen Access

#### Case 001

```text
User: U001
Group: SALES
Permission: TRADE_VIEW
```

アクセス先:

```text
/trade/search
```

期待結果:

```text
200 OK
```

---

#### Case 002

権限がない場合:

```text
TRADE_VIEW
```

アクセス先:

```text
/trade/search
```

期待結果:

```text
403
```

---

## 22. Button Permission Test

User:

```text
TRADE_VIEW
TRADE_CREATE
```

画面:

```text
[新規登録]
[変更]
[削除]
```

期待結果:

```text
新規登録 → 表示
変更     → 非表示
削除     → 非表示
```

---

## 23. API Security Test

フロントエンドでボタンを隠していても、ユーザーが直接次の API を呼び出す可能性があります。

```http
POST /api/trade/123/approve
```

もし `TRADE_APPROVE` 権限がない場合:

```text
403 Forbidden
```

これは必ずテストする必要があります。

---

## 24. Multiple Group Test

User:

```text
SALES
APPROVER
```

SALES の権限:

```text
TRADE_VIEW
TRADE_CREATE
```

APPROVER の権限:

```text
TRADE_APPROVE
```

期待結果:

```text
TRADE_VIEW      = true
TRADE_CREATE    = true
TRADE_APPROVE   = true
```

権限は UNION で結合されます。

---

## 25. まとめ

本設計の要点は、権限を「画面アクセス」「機能権限」「データ範囲」の3層で整理し、バックエンドで厳密に制御することです。

- フロントエンドは UX 向けに表示を制御する
- バックエンド API は Spring Security と PermissionService で制御する
- 権限変更時はキャッシュを必ず無効化する
- ユーザーは Group を通じて権限を保持し、権限の増減を柔軟に管理する
- 多数のグループが存在しても、権限判断は一貫した仕組みで行う

これにより、将来の画面や機能が増えても、権限体系を破壊せずに拡張できます。
---

# 25. Cache Test

第一次：

```text
Redis MISS
Oracle SELECT
Redis SET
```

第二次：

```text
Redis HIT
Oracle SELECT = 0
```

Expected：

> 不应该每次请求都查询 Oracle。

---

# 26. Cache Invalidation Test

原来：

```text
SALES
 ├─ TRADE_VIEW
 └─ TRADE_CREATE
```

修改为：

```text
SALES
 └─ TRADE_VIEW
```

Expected：

```text
SALES Group users
        ↓
Permission Cache invalidated
        ↓
下一次请求重新读取 DB
        ↓
TRADE_CREATE = false
```

---

# 27. User Group Change Test

原来：

```text
U001
 └─ SALES
```

修改：

```text
U001
 └─ APPROVER
```

Expected：

```text
U001 permission cache invalidated
```

重新登录/重新读取后：

```text
SALES permissions → gone
APPROVER permissions → available
```

---

# 28. Data Scope Test

User A：

```text
TRADE_VIEW
DATA_SCOPE = OWN
```

查询：

```text
TRADE
```

Expected：

> 只能看到自己的数据。

User B：

```text
TRADE_VIEW
DATA_SCOPE = DEPARTMENT
```

Expected：

> 可以看到本部门数据。

User C：

```text
TRADE_VIEW
DATA_SCOPE = ALL
```

Expected：

> 可以看到全部数据。

---

# 29. 安全设计原则

必须遵守：

### Rule 1

前端隐藏按钮 ≠ Security。

### Rule 2

所有 REST API 必须进行后端权限检查。

### Rule 3

权限代码不能由前端提交决定。

错误：

```http
POST /api/trade
{
    "permission": "TRADE_CREATE"
}
```

服务器不能相信这个字段。

---

### Rule 4

当前用户必须从 Security Context / Token 获取。

不能：

```http
GET /api/trade?userId=U001
```

然后直接把 U001 当成当前用户。

---

### Rule 5

Data Scope 必须后端控制。

---

# 30. 推荐项目结构

```text
src/main/java
└── com.example.app
    │
    ├── security
    │   ├── SecurityConfig.java
    │   ├── PermissionService.java
    │   ├── PermissionServiceImpl.java
    │   ├── RequirePermission.java
    │   ├── PermissionAspect.java
    │   └── CurrentUser.java
    │
    ├── user
    │   ├── UserController.java
    │   ├── UserService.java
    │   ├── UserMapper.java
    │   └── User.java
    │
    ├── group
    │   ├── GroupController.java
    │   ├── GroupService.java
    │   └── GroupMapper.java
    │
    ├── permission
    │   ├── PermissionController.java
    │   ├── PermissionService.java
    │   └── PermissionMapper.java
    │
    └── trade
        ├── TradeController.java
        ├── TradeService.java
        └── TradeMapper.java
```

---

# 31. Copilot 开发原则

Copilot 必须遵守：

1. 不在 Controller 中直接查询权限 DB。
2. 权限判断统一经过 PermissionService / Spring Security。
3. 不在业务代码中直接判断 Group Name。
4. 不使用 `if (group == "ADMIN")` 作为权限控制。
5. 使用 Permission Code。
6. 前端只负责 UX 层面的显示/隐藏。
7. 后端必须再次验证权限。
8. 权限缓存必须有明确的 invalidation 机制。
9. 权限变更必须使相关用户缓存失效。
10. Data Scope 必须在后端执行。
11. 所有权限 API 必须有测试。
12. 新增业务画面时必须同时定义 Screen Code 和 Permission Code。
13. 新增 API 时必须定义所需 Permission。
14. 新增按钮时必须关联已有 Permission；如没有合适 Permission，先新增 Permission。
15. 不允许为了方便而创建 `ALLOW_ALL` 之类绕过权限检查的代码。

---

# 32. 新增一个业务画面的标准流程

以后新增：

```text
交易承認画面
```

必须按以下步骤：

### Step 1

创建：

```text
SCREEN:
TRADE_APPROVAL
```

### Step 2

定义：

```text
TRADE_VIEW
TRADE_APPROVE
```

### Step 3

建立：

```text
SCREEN_PERMISSION
```

关系：

```text
TRADE_APPROVAL
 ├─ TRADE_VIEW
 └─ TRADE_APPROVE
```

### Step 4

给 Group：

```text
APPROVER
```

增加：

```text
TRADE_VIEW
TRADE_APPROVE
```

### Step 5

Controller：

```java
@PreAuthorize("hasAuthority('TRADE_APPROVE')")
```

### Step 6

前端：

```text
hasPermission("TRADE_APPROVE")
```

控制：

```text
[承認]
```

### Step 7

增加测试：

```text
有 TRADE_APPROVE → 200
没有 TRADE_APPROVE → 403
```

---

# 33. 最终架构

```text
                         ┌──────────────┐
                         │    User      │
                         └──────┬───────┘
                                │
                                ▼
                         ┌──────────────┐
                         │    Group     │
                         └──────┬───────┘
                                │
                                ▼
                     ┌─────────────────────┐
                     │  Group Permission   │
                     └──────────┬──────────┘
                                │
                                ▼
                         ┌──────────────┐
                         │  Permission  │
                         └──────┬───────┘
                                │
                ┌───────────────┼───────────────┐
                ▼               ▼               ▼
             Screen          Function          API
                │               │               │
                ▼               ▼               ▼
             Menu            Button          Security
                                                │
                                                ▼
                                          Data Scope
```

核心原则：

```text
DB
 ↓
定义权限

Spring Security
 ↓
执行权限

Redis
 ↓
缓存权限

Frontend
 ↓
显示/隐藏 UI

Backend
 ↓
最终安全控制
```

这样可以形成一套统一的、可扩展的权限体系。

这套设计我建议你**先作为独立的 `security/permission` 模块做出来，再开始做具体业务画面**。尤其是 `Permission Code + @PreAuthorize + Redis/Caffeine Cache + Data Scope` 这四个部分，先定下来，后面的业务开发会顺很多。

如果你现在准备正式让 **GitHub Copilot 开始开发**，下一步最好再把这份规范拆成 **`01_requirements.md`、`02_database.sql`、`03_api.md`、`04_security.md`、`05_frontend.md`、`06_testcases.md`、`AGENTS.md`** 这种 Copilot 容易执行的文件结构。
