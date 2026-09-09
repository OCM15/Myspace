可以。下面我按**“可以直接交给 GitHub Copilot 作为开发规范”**的方式整理。考虑到你之前的方向是 **Java + Spring Boot + MyBatis + Oracle + Web App**，我会把权限模块设计成独立模块，后面业务画面不断增加也不用推倒重来。

# Web App 权限控制设计规范

## 1. 目的

本系统采用 RBAC（Role-Based Access Control）实现用户权限管理。

权限控制需要支持：

* 用户管理
* 用户组管理
* 一个用户属于多个用户组
* 用户组控制画面访问权限
* 用户组控制按钮/功能权限
* 后端 API 权限控制
* 前端菜单、画面、按钮显示控制
* 数据范围（Data Scope）控制
* 权限缓存
* 权限变更后缓存刷新
* 权限相关单元测试及集成测试

技术前提：

* Java
* Spring Boot
* Spring Security
* MyBatis
* Oracle
* REST API
* Web Frontend

---

# 2. 总体权限模型

采用：

User → Group → Permission → Resource

同时支持：

Permission → Data Scope

整体关系：

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

例如：

User: TANAKA

所属 Group：

* SALES
* APPROVER

权限：

SALES
├─ TRADE_VIEW
├─ TRADE_CREATE
└─ TRADE_UPDATE

APPROVER
├─ TRADE_VIEW
└─ TRADE_APPROVE

最终用户权限为所属所有 Group 权限的 UNION。

---

# 3. DB 表设计

## 3.1 USER

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

STATUS：

```text
ACTIVE
INACTIVE
LOCKED
```

---

# 3.2 USER_GROUP

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

例如：

```text
ADMIN
SALES
ACCOUNTING
APPROVER
VIEWER
```

---

# 3.3 USER_GROUP_MEMBER

用户与 Group 为 N:N。

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

# 3.4 SCREEN

定义系统画面。

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

例如：

```text
TRADE
 ├─ TRADE_SEARCH
 ├─ TRADE_INPUT
 └─ TRADE_APPROVAL

MASTER
 ├─ USER_MAINTENANCE
 └─ GROUP_MAINTENANCE
```

PARENT_CODE 用于构造菜单层级。

---

# 3.5 PERMISSION

定义业务功能权限。

```sql
CREATE TABLE APP_PERMISSION (
    PERMISSION_ID    VARCHAR2(50) PRIMARY KEY,
    PERMISSION_CODE  VARCHAR2(100) NOT NULL UNIQUE,
    PERMISSION_NAME  VARCHAR2(200) NOT NULL,
    DESCRIPTION      VARCHAR2(500),
    STATUS            VARCHAR2(20) NOT NULL
);
```

例如：

```text
TRADE_VIEW
TRADE_CREATE
TRADE_UPDATE
TRADE_DELETE
TRADE_APPROVE
TRADE_EXPORT
```

不要把按钮 ID 作为权限 ID。

例如：

不推荐：

```text
BUTTON_001
BUTTON_002
BUTTON_003
```

推荐：

```text
TRADE_CREATE
TRADE_UPDATE
TRADE_APPROVE
```

因为权限表达的是“业务能力”，而不是 UI 元素。

---

# 3.6 GROUP_PERMISSION

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

例如：

| Group    | Permission    |
| -------- | ------------- |
| SALES    | TRADE_VIEW    |
| SALES    | TRADE_CREATE  |
| SALES    | TRADE_UPDATE  |
| APPROVER | TRADE_VIEW    |
| APPROVER | TRADE_APPROVE |

---

# 3.7 SCREEN_PERMISSION

建议增加这一张表，把“哪个权限对应哪个画面”明确记录下来。

```sql
CREATE TABLE SCREEN_PERMISSION (
    SCREEN_ID       VARCHAR2(50) NOT NULL,
    PERMISSION_ID   VARCHAR2(50) NOT NULL,

    CONSTRAINT PK_SCREEN_PERMISSION
        PRIMARY KEY (SCREEN_ID, PERMISSION_ID)
);
```

例如：

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

这样可以避免一个权限被错误地用于完全不相关的画面。

---

# 3.8 DATA_SCOPE

如果系统以后存在部门、担当者、地区等数据范围控制，增加：

```sql
CREATE TABLE GROUP_DATA_SCOPE (
    GROUP_ID       VARCHAR2(50) NOT NULL,
    RESOURCE_CODE  VARCHAR2(100) NOT NULL,
    SCOPE_TYPE     VARCHAR2(30) NOT NULL,

    CONSTRAINT PK_GROUP_DATA_SCOPE
        PRIMARY KEY (GROUP_ID, RESOURCE_CODE)
);
```

SCOPE_TYPE：

```text
OWN
DEPARTMENT
ALL
```

例如：

```text
SALES
TRADE
DEPARTMENT

MANAGER
TRADE
ALL
```

这样：

同样拥有：

```text
TRADE_VIEW
```

的两个用户，可以看到不同的数据。

---

# 4. 权限层次

权限分为三层。

## Layer 1：Screen Access

控制：

> 用户是否可以访问画面。

例如：

```text
TRADE_APPROVAL + VIEW
```

没有这个权限：

```text
菜单不显示
直接访问 URL → 403
```

---

## Layer 2：Function / Button Access

例如：

```text
TRADE_CREATE
TRADE_UPDATE
TRADE_DELETE
TRADE_APPROVE
TRADE_EXPORT
```

对应：

```text
[新規登録]
[変更]
[削除]
[承認]
[CSV出力]
```

---

## Layer 3：Data Scope

例如：

```text
OWN
DEPARTMENT
ALL
```

最终权限判断：

```text
Can Access Screen?
       ↓
Can Execute Function?
       ↓
Can Access This Data?
```

---

# 5. API 设计

## 5.1 当前用户权限

```http
GET /api/me
```

返回：

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

前端登录后取得权限。

---

# 5.2 当前用户菜单

```http
GET /api/me/menus
```

返回：

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

服务器只返回用户有权限访问的菜单。

因此前端不需要自己计算菜单权限。

---

# 5.3 用户组权限查询

```http
GET /api/admin/groups/{groupId}/permissions
```

---

# 5.4 用户组权限更新

```http
PUT /api/admin/groups/{groupId}/permissions
```

Request：

```json
{
  "permissions": [
    "TRADE_VIEW",
    "TRADE_CREATE",
    "TRADE_UPDATE"
  ]
}
```

更新完成后必须刷新该 Group 相关用户的权限缓存。

---

# 5.5 用户所属 Group

```http
GET /api/admin/users/{userId}/groups
```

---

# 5.6 修改用户 Group

```http
PUT /api/admin/users/{userId}/groups
```

Request：

```json
{
  "groups": [
    "SALES",
    "APPROVER"
  ]
}
```

修改后刷新该用户权限缓存。

---

# 6. Java Annotation

建议定义：

```java
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface RequirePermission {

    String value();

}
```

Controller：

```java
@RequirePermission("TRADE_APPROVE")
@PostMapping("/trade/{id}/approve")
public ResponseEntity<?> approve(
        @PathVariable String id) {

    return ResponseEntity.ok().build();
}
```

这样业务代码非常容易理解。

---

# 7. 推荐使用 Spring Security

权限检查应该集中在 Spring Security。

例如：

```java
@PreAuthorize("hasAuthority('TRADE_APPROVE')")
@PostMapping("/trade/{id}/approve")
public ResponseEntity<?> approve(
        @PathVariable String id) {

    ...
}
```

如果使用自定义 Annotation：

```java
@RequirePermission("TRADE_APPROVE")
```

由 AOP / Method Security 统一处理。

原则：

**Controller 不自己查询 DB 判断权限。**

---

# 8. PermissionService

定义统一接口：

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

业务代码统一通过这个 Service 获取权限。

---

# 9. 权限缓存

每次 API 都查询：

```text
USER
↓
USER_GROUP_MEMBER
↓
GROUP_PERMISSION
↓
PERMISSION
```

会产生大量 DB Access。

因此建议缓存。

## 推荐

如果单机：

```text
Caffeine
```

如果多台 Server：

```text
Redis
```

生产环境推荐：

```text
Spring Boot
    ↓
Redis
    ↓
Oracle
```

---

# 10. Cache Key

例如：

```text
permission:user:U001
```

Value：

```json
[
  "TRADE_VIEW",
  "TRADE_CREATE",
  "TRADE_UPDATE",
  "TRADE_APPROVE"
]
```

Data Scope：

```text
scope:user:U001:TRADE
```

---

# 11. 权限读取流程

第一次请求：

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

以后：

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

# 12. 权限变更后的 Cache Invalidation

这是实现时非常重要的一点。

例如：

管理员修改：

```text
SALES
```

Group 的权限。

不能只刷新管理员自己的 Cache。

必须：

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

用户下次访问时重新从 DB 加载。

---

# 13. 前端权限控制

前端登录后：

```http
GET /api/me
```

取得：

```json
{
  "permissions": [
    "TRADE_VIEW",
    "TRADE_CREATE",
    "TRADE_UPDATE"
  ]
}
```

定义：

```javascript
hasPermission("TRADE_UPDATE")
```

例如：

```javascript
if (hasPermission("TRADE_UPDATE")) {
    showEditButton();
}
```

但必须明确：

**前端权限控制不是安全控制。**

前端：

```text
隐藏按钮
```

只是 UX。

真正的安全控制：

```text
Backend API
 ↓
Spring Security
 ↓
Permission Check
```

---

# 14. 推荐前端组件

可以设计：

```text
<Permission permission="TRADE_CREATE">
    <button>新規登録</button>
</Permission>
```

或者：

```text
<button
    v-if="hasPermission('TRADE_CREATE')">
    新規登録
</button>
```

具体写法根据 React / Vue / Angular 决定。

---

# 15. 菜单控制

不要在前端写：

```javascript
if (user.group === "ADMIN")
```

也不要：

```javascript
if (user.group === "SALES")
```

应该根据 Permission：

```text
TRADE_VIEW
TRADE_CREATE
TRADE_APPROVE
```

控制。

这样以后增加 Group：

```text
SALES_MANAGER
OVERSEAS_SALES
SPECIAL_APPROVER
```

前端完全不需要修改。

---

# 16. 403 处理

没有权限：

```http
HTTP 403 Forbidden
```

返回：

```json
{
  "code": "FORBIDDEN",
  "message": "You do not have permission to perform this operation."
}
```

前端统一处理。

---

# 17. 401 与 403

必须区分：

```text
401 Unauthorized
```

表示：

> 没有登录 / Token 无效

```text
403 Forbidden
```

表示：

> 已登录，但是没有权限。

---

# 18. 管理画面

建议至少提供：

## 用户管理

```text
User
 ├─ User ID
 ├─ Name
 ├─ Status
 └─ Groups
```

---

## Group 管理

```text
Group
 ├─ Group Name
 ├─ Description
 └─ Permissions
```

权限画面建议采用 Tree / Checkbox：

```text
□ 交易
   ☑ 交易查询
      ☑ VIEW

   ☑ 交易输入
      ☑ VIEW
      ☑ CREATE
      ☑ UPDATE
      ☐ DELETE

   ☐ 交易承認
      ☐ VIEW
      ☐ APPROVE
```

这样管理员非常容易理解。

---

# 19. 推荐不要设置“Admin = 所有权限字符串”

可以存在：

```text
ADMIN
```

但不要在 Java 代码里大量写：

```java
if (user.isAdmin()) {
    allow();
}
```

更好的方法：

ADMIN Group 拥有：

```text
所有 Permission
```

或者特殊的：

```text
SYSTEM_ADMIN
```

最终仍然进入统一权限机制。

这样可以避免系统里出现两套权限体系。

---

# 20. 数据权限

如果业务数据存在：

```text
COMPANY_CODE
DEPARTMENT_CODE
USER_ID
```

不要仅仅通过前端限制。

例如：

```text
SALES_USER
DATA_SCOPE = DEPARTMENT
```

SQL 应该最终产生类似：

```sql
WHERE DEPARTMENT_CODE = :currentDepartment
```

而：

```text
MANAGER
DATA_SCOPE = ALL
```

则不增加 Department 条件。

数据权限必须在后端实现。

---

# 21. 测试案例

## 21.1 Screen Access

### Case 001

```text
User: U001
Group: SALES
Permission: TRADE_VIEW
```

访问：

```text
/trade/search
```

Expected：

```text
200 OK
```

---

### Case 002

没有：

```text
TRADE_VIEW
```

访问：

```text
/trade/search
```

Expected：

```text
403
```

---

# 22. Button Permission Test

User：

```text
TRADE_VIEW
TRADE_CREATE
```

画面：

```text
[新規登録]
[変更]
[削除]
```

Expected：

```text
新規登録 → Display
変更     → Hidden
削除     → Hidden
```

---

# 23. API Security Test

即使前端隐藏：

```text
[承認]
```

用户仍然直接调用：

```http
POST /api/trade/123/approve
```

如果没有：

```text
TRADE_APPROVE
```

Expected：

```text
403 Forbidden
```

这是必须测试的。

---

# 24. Multiple Group Test

User：

```text
SALES
APPROVER
```

SALES：

```text
TRADE_VIEW
TRADE_CREATE
```

APPROVER：

```text
TRADE_APPROVE
```

Expected：

```text
TRADE_VIEW      = true
TRADE_CREATE    = true
TRADE_APPROVE   = true
```

权限取 UNION。

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
