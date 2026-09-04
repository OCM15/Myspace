Skill 的目录结构
MyProject/
├─ .github/
│  └─ skills/
│     ├─ java-development/
│     │  └─ SKILL.md
│     │
│     ├─ python-testing/
│     │  └─ SKILL.md
│     │
│     └─ project-design/
│        └─ SKILL.md
│
├─ src/
└─ README.md

核心就是：
.github/skills/<skill-name>/SKILL.md

2. SKILL.md 里面写什么？
例如你做一个 Java Swing 开发 Skill：
---
name: java-swing-development
description: Develop modern Java Swing desktop applications with clean architecture and modern UI patterns.
---

# Java Swing Development

When developing Java Swing applications:

1. Use MVC or MVVM-like separation.
2. Keep UI code separate from business logic.
3. Use SwingWorker for long-running operations.
4. Avoid blocking the Event Dispatch Thread.
5. Prefer reusable UI components.
6. Use consistent spacing and typography.
7. Provide error handling for user operations.
8. Add unit tests for business logic.

这里最重要的是：
name:
description:

3. Copilot 是怎么使用 Skill 的？
你：
    帮我设计一个 Java Swing Dashboard

             ↓

Copilot 判断任务

             ↓

发现 java-swing-development Skill
             ↓

加载 SKILL.md
             ↓

按照 Skill 中的方法工作

GitHub 官方说明也是：Copilot 会根据任务判断是否需要使用 Skill，然后把 SKILL.md 的内容加载到当前 Agent context 中。


4. 怎么安装别人做好的 Skill？
gh skill search
gh skill preview
gh skill install
gh skill update

例如：
gh skill search documentation

gh skill search documentation
gh skill install OWNER/REPOSITORY SKILL

    5. 也可以自己直接安装

例如别人给你一个：

python-testing/
└── SKILL.md

你可以把它放到：

你的项目/
└── .github/
    └── skills/
        └── python-testing/
            └── SKILL.md

然后 Copilot Agent Mode 就可以使用。

个人 Skill 则可以放：

~/.copilot/skills/python-testing/SKILL.md

这样你所有项目都可以使用。

6. Skill 和 copilot-instructions.md 有什么区别？

这个非常值得你注意。

	Instructions	Skill
目的	全局/项目规则	专业工作能力
是否每次都需要	通常需要	需要时才加载
适合	编码规范、项目规则	Java开发、测试、DB迁移等
内容	比较短	可以比较详细
脚本/资源	通常没有	可以带
自动选择	不强调	Copilot会根据任务选择

GitHub 官方也建议：简单、几乎所有任务都适用的规则放 custom instructions；复杂且只有特定任务需要的内容放 Skill。

.github/
├─ copilot-instructions.md
│
└─ skills/
   ├─ java-desktop-development/
   ├─ java-swing-ui/
   ├─ python-automation/
   ├─ playwright-testing/
   ├─ oracle-database/
   ├─ excel-vba/
   ├─ system-design/
   └─ html-project-documentation/

   