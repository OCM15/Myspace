# Screen Migration Skills

用于旧 Java Web 系统向新框架迁移时，保障 UI 功能等价性。

## 核心原则

UI 的外观、布局、组件实现方式可以变化；但以下内容原则上必须保持业务功能等价：

- 画面项目
- 输入检查
- 显示条件
- 初期值
- Button / Link 行为
- Screen-to-Screen I/F
- Request / Response / DTO / API I/F
- NULL / empty / blank 等数据语义
- 错误处理
- Session / hidden / URL 参数
- 状态迁移与重复提交行为

任何 `MISSING`、`UNKNOWN`、`UNVERIFIED` 在未记录例外并获得批准前，都不得将画面迁移判定为完成。

## 推荐执行顺序

1. `Screen-Migration-Orchestrator-Skill.md`
2. `Screen-Inventory-Skill.md`
3. `Screen-UI-Equivalence-Skill.md`
4. `Screen-Validation-Skill.md`
5. `Screen-Interface-Migration-Skill.md`
6. `Screen-Behavior-Migration-Skill.md`
7. `Screen-Test-Skill.md`

模板位于 `templates/`，Checklist 位于 `checklists/`。

## AI 执行规则

- 不要在 Inventory 完成前直接修改新画面代码。
- 不要根据截图 alone 判断功能等价。
- 对无法确认的项目标记 `UNKNOWN`，不要猜测。
- 对明确废止的项目记录 `OBSOLETE` 及依据。
- 每个旧项目必须有 New Item、明确的例外状态，或可追溯的废止依据。
- 修改后必须重新执行 Traceability / Contract / Behavior 检查。
