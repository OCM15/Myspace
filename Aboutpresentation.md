① 明确问题
       ↓
② 得出结论
       ↓
③ 建立逻辑树
       ↓
④ 确定 Storyline
       ↓
⑤ 每页只表达一个核心信息
       ↓
⑥ 用图/表/流程表达
       ↓
⑦ 最后才生成 PPT

              你的原始信息
                    │
                    ▼
          ┌─────────────────┐
          │ ① Consulting    │
          │    Thinking      │
          │ 逻辑/框架/结论    │
          └────────┬────────┘
                   ↓
          ┌─────────────────┐
          │ ② Storyline     │
          │ 章节/页面结构     │
          └────────┬────────┘
                   ↓
          ┌─────────────────┐
          │ ③ Visual Design │
          │ 图/表/流程/矩阵   │
          └────────┬────────┘
                   ↓
          ┌─────────────────┐
          │ ④ PPT Generator │
          │ PowerPoint      │
          └─────────────────┘

.github/
└── skills/
    └── consulting-presentation/
        ├── SKILL.md
        ├── templates/
        ├── examples/
        └── rules/

01 Executive Summary
   ↓
02 Why Change Now?
   ↓
03 Current System Issues
   ↓
04 Business Impact
   ↓
05 Target Architecture
   ↓
06 Migration Options
   ↓
07 Option Comparison
   ↓
08 Recommended Approach
   ↓
09 Migration Roadmap
   ↓
10 Risk & Mitigation
   ↓
11 Project Organization
   ↓
12 Investment / Benefit
   ↓
13 Decision Required


| 信息    | 自动选择           |
| ----- | -------------- |
| 时间    | Timeline       |
| 项目进度  | Gantt          |
| 两个方案  | Comparison     |
| 多因素比较 | Matrix         |
| 因果关系  | Flow           |
| 系统关系  | Architecture   |
| 层级关系  | Pyramid        |
| 四个维度  | 2×2 Matrix     |
| 数字趋势  | Line Chart     |
| 构成比例  | Stacked Bar    |
| KPI   | KPI Cards      |
| 前后变化  | Before / After |
| 问题分析  | Issue Tree     |
| 业务流程  | Process Flow   |
| 决策    | Decision Tree  |



.github/
│
├── copilot-instructions.md
│
└── skills/
    │
    ├── consulting-thinking/
    │
    ├── presentation-storyline/
    │
    ├── presentation-visualization/
    │
    ├── project-management/
    │
    ├── project-progress-report/
    │
    ├── solution-proposal/
    │
    └── executive-report/

其中：

consulting-thinking

负责：

MECE / Issue Tree / Hypothesis / Conclusion

presentation-storyline

负责：

章节结构 / Storyline / 页面逻辑

presentation-visualization

负责：

应该用什么图表达

project-management

负责：

WBS / Schedule / Risk / Issue / Milestone

solution-proposal

负责：

As-Is / To-Be / Architecture / Options / Recommendation

最后再有一个：

ppt-generator

负责真正产生 .pptx。

最终效果

以后你甚至可以只给 Copilot：

项目：Sybase → Oracle迁移

目的：
降低维护成本

期限：
2027年3月Release

当前：
Requirement 100%
Design 80%
Development 45%

主要问题：
性能验证存在风险

要求：
给管理层汇报
15页以内
咨询公司风格
图表优先
文字最少
最后给出需要管理层决策的事项

然后让它按照：

分析 → Storyline → 页面设计 → 图表 → PPT

一路生成。

1. 整体目录

.github/
│
├── copilot-instructions.md
│
└── skills/
    │
    ├── consulting-thinking/
    │   └── SKILL.md
    │
    ├── presentation-storyline/
    │   └── SKILL.md
    │
    ├── presentation-visualization/
    │   └── SKILL.md
    │
    ├── project-management/
    │   └── SKILL.md
    │
    ├── project-progress/
    │   └── SKILL.md
    │
    ├── solution-proposal/
    │   └── SKILL.md
    │
    └── executive-report/
        └── SKILL.md


2. 最核心：consulting-thinking

---
name: consulting-thinking
description: Apply structured consulting thinking to IT project planning, progress reporting, issue analysis, solution proposals, and executive presentations.
---

# Consulting Thinking

## Core Principle

Do not start by creating slides.

First understand:
1. What is the question?
2. What is the conclusion?
3. What evidence supports the conclusion?
4. What decision or action is required?

## Rules

### 1. Conclusion First

Every major section must have a clear conclusion.

Avoid:
- Project Status
- Current Issues
- Solution Comparison

Prefer:
- Overall progress remains on track despite two critical risks
- Data migration is currently the largest schedule risk
- Option B provides the best balance of cost, risk and delivery time

### 2. MECE

Organize information using mutually exclusive and collectively exhaustive categories where practical.

### 3. Issue Tree

When the problem is complex:

Problem
├── Business
├── Technology
├── Process
├── Organization
└── Cost

### 4. Fact / Analysis / Recommendation

Clearly distinguish:

Fact
↓
Analysis
↓
Implication
↓
Recommendation

Never present assumptions as facts.

### 5. Executive Perspective

For management presentations always identify:

- Key message
- Business impact
- Major risks
- Required decisions
- Next actions

3. presentation-storyline
---
name: presentation-storyline
description: Create consulting-style presentation storylines for executive reports, project plans, progress reports, research reports and solution proposals.
---

# Presentation Storyline

## Standard Structure

When appropriate, use:

1. Executive Summary
2. Background
3. Current Situation
4. Key Issues
5. Analysis
6. Options
7. Recommendation
8. Roadmap
9. Risks
10. Next Steps / Decision Required

Do not force this structure when another structure is more logical.

## Slide Rule

One slide = one key message.

The slide title must communicate the conclusion.

Bad:
"Project Progress"

Good:
"Overall project progress is 82%, with development remaining on the critical path"

## Slide Content

Each slide should contain:

- Conclusion title
- Supporting evidence
- Visual explanation
- Optional footnote/source

Avoid long paragraphs.

## Storyline Quality

The presentation must answer:

WHY?
→ WHAT?
→ SO WHAT?
→ NOW WHAT?

The audience should understand the conclusion by reading only the slide titles.

4. presentation-visualization
---
name: presentation-visualization
description: Select and design effective consulting-style visualizations, diagrams, charts, matrices, timelines and process flows for PowerPoint and HTML presentations.
---

# Visualization Rules

Always prefer visual representation over unnecessary text.

## Visualization Selection

Use:

Timeline
→ Schedule / Roadmap / Milestones

Gantt
→ Project plan / Progress

Process Flow
→ Business process / System flow

Architecture
→ System relationships

Before / After
→ Transformation

2x2 Matrix
→ Strategic positioning / Risk analysis

Comparison Matrix
→ Option comparison

Issue Tree
→ Problem decomposition

Pyramid
→ Hierarchy / Executive message

Waterfall
→ Cost / Benefit / Financial impact

Line Chart
→ Trend over time

Bar Chart
→ Comparison

Stacked Bar
→ Composition

KPI Cards
→ Important numbers

Heatmap
→ Risk / Priority

Decision Tree
→ Decision logic

## Visualization Principle

Do not add graphics merely for decoration.

Every visual element must communicate information.

## Text Density

Prefer:

1 diagram + 3 key messages

over:

10 bullet points.


5. 项目计划专用 Skill

---
name: project-management
description: Create professional IT project plans including WBS, milestones, schedules, dependencies, resources, risks and governance.
---

# Project Management

Analyze:

- Scope
- Deliverables
- WBS
- Milestones
- Dependencies
- Schedule
- Resources
- Risks
- Issues
- Governance

Preferred visualizations:

WBS
Gantt Chart
Milestone Timeline
Dependency Diagram
RACI
Risk Matrix
Governance Structure

For project plans always identify the critical path.

Highlight:
- Critical activities
- Dependencies
- Decision points
- Major risks

6. 项目进度报告
---
name: project-progress
description: Create executive-level IT project progress reports using schedule, KPI, milestone, risk and issue analysis.
---

# Project Progress

Always analyze:

1. Planned progress
2. Actual progress
3. Variance
4. Root cause
5. Impact
6. Recovery action

Recommended slides:

Executive Summary
Overall Status
Schedule Progress
Deliverable Status
Milestone Status
Issue / Risk
Recovery Plan
Next 2-4 Weeks
Management Decisions

Use RAG status:

Green = On Track
Yellow = Attention Required
Red = Critical
这里可以让 Copilot 自动生成：
Plan       Actual
████████   ████████

Overall: 82%

Schedule: 🟢
Quality:  🟢
Cost:     🟡
Risk:     🔴

7. 解决方案提案 Skill
---
name: solution-proposal
description: Create consulting-style IT solution proposals covering current state, problems, target state, architecture, options, recommendation, benefits, costs and roadmap.
---

# Solution Proposal

Standard logic:

Business Background
↓
Current State
↓
Problems
↓
Root Causes
↓
Requirements
↓
Target State
↓
Solution Options
↓
Evaluation
↓
Recommendation
↓
Implementation Roadmap
↓
Risk
↓
Expected Benefits

Always distinguish:

AS-IS
TO-BE
GAP

For multiple options use:

Criteria
Cost
Schedule
Technical Risk
Operational Impact
Scalability
Maintainability

Then provide:

Recommendation
Reason
Trade-offs

8. Executive Report
---
name: executive-report
description: Create concise executive presentations for senior management with strong conclusions, KPI visualization, risks and decision requests.
---

# Executive Report

Senior management should understand the presentation within 3 minutes.

Prioritize:

1. What happened?
2. Why?
3. What does it mean?
4. What should we do?
5. What decision is required?

Limit unnecessary technical details.

Every executive presentation should contain:

Executive Summary
Key Numbers
Major Issues
Business Impact
Recommendation
Decision Required
Next Actions
9. 最关键的一层：PPT Design System

我建议不要把麦肯锡、埃森哲的具体品牌设计直接复制进去，而是定义一个“顶级咨询公司风格”的通用 Design System。

例如：

Consulting Presentation Design System

规定：

页面
16:9
标题
每页一个结论
标题 28~32pt
正文 16~20pt
原则
大标题
↓
一句结论
↓
1个主要视觉
↓
2~4个 supporting points
页面留白

宁可：

████████████████

      图

████████████████

也不要：

████████████████
文字文字文字文字文字
文字文字文字文字文字
图图图图图图图图
文字文字文字文字
文字文字文字文字
████████████████

10. 我特别建议加入“Slide Type Library”
slide-types/

01_title
02_executive-summary
03_key-message
04_kpi-dashboard
05_timeline
06_gantt
07_progress
08_before-after
09_process
10_architecture
11_issue-tree
12_2x2-matrix
13_comparison
14_risk-matrix
15_waterfall
16_benefit
17_roadmap
18_governance
19_decision
20_appendix
11. 最终工作流程

input/
├── meeting-notes.md
├── project-status.xlsx
├── system-overview.docx
└── requirements.md

然后：
              原始资料
                 ↓
        ┌─────────────────┐
        │ Consulting      │
        │ Thinking        │
        └────────┬────────┘
                 ↓
             Conclusion
                 ↓
        ┌─────────────────┐
        │ Storyline       │
        └────────┬────────┘
                 ↓
           Slide Structure
                 ↓
        ┌─────────────────┐
        │ Visualization   │
        └────────┬────────┘
                 ↓
            Slide Design
                 ↓
        ┌────────┴────────┐
        ↓                 ↓
      PPTX              HTML

      12. 我甚至建议规定一个中间格式

      presentation.json

      {
  "title": "Sybase to Oracle Migration",
  "audience": "Management",
  "slides": [
    {
      "id": 1,
      "type": "executive-summary",
      "title": "Oracle migration can reduce long-term maintenance burden while keeping the 2027 release target",
      "key_message": [
        "Maintenance cost reduction",
        "Technology modernization",
        "Migration risk manageable"
      ]
    },
    {
      "id": 2,
      "type": "before-after",
      "title": "The current architecture creates unnecessary operational complexity",
      "visual": "as-is-to-be"
    }
  ]
}

然后：
presentation.json
       │
       ├────→ PPTX
       │
       └────→ HTML


以后你甚至可以给 Copilot 一个非常简单的 Prompt：
请根据 input/ 下的资料，
制作一份管理层用的项目进度报告。

要求：

- 咨询公司风格
- 10页以内
- 结论先行
- 每页一个核心信息
- 尽量用图代替文字
- 自动选择合适的图表
- 突出项目风险
- 突出未来4周计划
- 明确需要管理层决策的事项
- 输出 PPTX
- 同时输出 HTML 版本

它应该按照：
资料分析
 ↓
Issue Tree
 ↓
Conclusion
 ↓
Storyline
 ↓
Slide Type
 ↓
Visualization
 ↓
PPT

如果是我帮你实际落地，我不会停留在上面的设计层面，而是直接给你做这 4个实际文件：

.github/
├── copilot-instructions.md
│
└── skills/
    ├── consulting-presentation/
    │   └── SKILL.md
    │
    ├── project-progress/
    │   └── SKILL.md
    │
    ├── solution-proposal/
    │   └── SKILL.md
    │
    └── project-plan/
        └── SKILL.md

再配一个：
presentation/
├── presentation.json
├── templates/
├── slide-types/
└── generate-ppt.py


Slide Type Library

我建议你做成 「Slide Type + Layout Rule + Data Schema + Example」 四层。
presentation/
└── slide-library/
    │
    ├── README.md
    │
    ├── 01-title/
    │   ├── definition.md
    │   ├── layout.md
    │   ├── schema.json
    │   └── example.json
    │
    ├── 02-executive-summary/
    │   ├── definition.md
    │   ├── layout.md
    │   ├── schema.json
    │   └── example.json
    │
    ├── 03-kpi-dashboard/
    │
    ├── 04-key-message/
    │
    ├── 05-timeline/
    │
    ├── 06-gantt/
    │
    ├── 07-progress/
    │
    ├── 08-before-after/
    │
    ├── 09-process/
    │
    ├── 10-architecture/
    │
    ├── 11-issue-tree/
    │
    ├── 12-2x2-matrix/
    │
    ├── 13-comparison/
    │
    ├── 14-risk-matrix/
    │
    ├── 15-waterfall/
    │
    ├── 16-benefit/
    │
    ├── 17-roadmap/
    │
    ├── 18-governance/
    │
    └── 19-decision/

    2. 一个 Slide Type 到底包含什么？
    例如：
    03-kpi-dashboard

    不要只有一个 PPT 模板。
    应该包含：
    definition.md
      ↓
什么时候用？

layout.md
      ↓
怎么排版？

schema.json
      ↓
需要什么数据？

example.json
      ↓
实际例子

3. definition.md

比如 KPI Dashboard：

# KPI Dashboard

## Purpose

Use this slide to communicate overall project health
through a small number of important KPIs.

## Best Used For

- Executive reporting
- Project status
- Management review
- Monthly reporting

## Do NOT Use For

- Detailed analysis
- Large datasets
- Complex trends

## Recommended Content

3-6 KPIs.

Each KPI should contain:

- Value
- Unit
- Status
- Comparison
- Short interpretation

## Selection Rule

Use this slide when the audience needs to understand
"How are we doing?" within a few seconds.

## Example

Schedule: 82%
Budget: 76%
Quality: 95%
Risk: 3 Critical

4. layout.md
# Layout

Aspect ratio: 16:9

Structure:

┌──────────────────────────────────────┐
│ Conclusion Title                    │
├────────┬────────┬────────┬──────────┤
│ KPI 01 │ KPI 02 │ KPI 03 │ KPI 04  │
│        │        │        │          │
├────────┴────────┴────────┴──────────┤
│ Key Interpretation                  │
└──────────────────────────────────────┘

Rules:

- 4 KPI cards recommended
- Maximum 6 cards
- Keep cards visually equal
- Use large numbers
- Put interpretation below the KPI
- Do not use paragraphs

注意这里甚至不需要精确到 PowerPoint 坐标。

坐标应该放到真正的 PPT rendering layer。


5. schema.json
这个非常关键。

它规定：

“这个 Slide Type 需要什么数据？”

例如：
{
  "type": "kpi-dashboard",
  "title": "string",
  "kpis": [
    {
      "name": "string",
      "value": "number",
      "unit": "string",
      "status": "green|yellow|red",
      "target": "number",
      "comment": "string"
    }
  ]
}
那么 Copilot 就知道：
KPI Dashboard
    │
    ├── title
    │
    └── kpis[]
          ├── name
          ├── value
          ├── unit
          ├── status
          ├── target
          └── comment

6. example.json
{
  "type": "kpi-dashboard",

  "title": "Overall project health remains stable, with schedule as the main area requiring attention",

  "kpis": [
    {
      "name": "Schedule",
      "value": 82,
      "unit": "%",
      "status": "yellow",
      "target": 90,
      "comment": "2 weeks behind plan"
    },
    {
      "name": "Budget",
      "value": 76,
      "unit": "%",
      "status": "green",
      "target": 80,
      "comment": "Within budget"
    },
    {
      "name": "Quality",
      "value": 95,
      "unit": "%",
      "status": "green",
      "target": 95,
      "comment": "Meets target"
    },
    {
      "name": "Critical Risks",
      "value": 3,
      "unit": "",
      "status": "red",
      "target": 0,
      "comment": "Migration performance"
    }
  ]
}

7. 最重要的是建立“选择规则”

这才是 Slide Type Library 真正厉害的地方。

再增加：

slide-library/
└── slide-selection.md

例如：

# Slide Selection Rules

## If the information describes...

### Time
Use:
- timeline
- gantt
- roadmap

### Progress
Use:
- kpi-dashboard
- progress
- gantt

### Comparison
Use:
- comparison
- 2x2-matrix

### Current vs Future
Use:
- before-after
- architecture

### Process
Use:
- process

### Problem decomposition
Use:
- issue-tree

### Risk
Use:
- risk-matrix

### Decision
Use:
- decision

### System relationship
Use:
- architecture

### Financial impact
Use:
- waterfall
- benefit

这样 Copilot 就可以：

“这个内容应该用什么图？”

而不是你自己决定。
8. 再往前一步：给每个 Slide Type 一个“适用度”

例如：

{
  "type": "risk-matrix",

  "use_when": [
    "multiple risks need prioritization",
    "management needs risk visibility"
  ],

  "avoid_when": [
    "only one risk exists",
    "risk data is insufficient"
  ],

  "best_for": [
    "executive",
    "project-manager"
  ]
}
9. 我特别推荐你建立“组合型 Slide”

例如：

Executive Summary

不是一种固定图。

而是：

Executive Summary
│
├── KPI
├── Key Message
├── Risk
└── Decision

可以组合成：

┌──────────────────────────────────┐
│ Conclusion                       │
├─────────┬─────────┬──────────────┤
│ KPI     │ KPI     │ KPI          │
├─────────┴─────────┴──────────────┤
│                                  │
│       Main Visual                │
│                                  │
├─────────────────────┬────────────┤
│ Key Risks           │ Decision   │
└─────────────────────┴────────────┘

所以 Slide Library 最好支持：

atomic components
       ↓
slide types
       ↓
composite slides
       ↓
presentation
10. 最终你的 PPT 就会变成“搭积木”

例如一个系统迁移提案：

01  Title
02  Executive Summary
03  Why Change Now?
04  Issue Tree
05  AS-IS Architecture
06  Key Issues
07  TO-BE Architecture
08  Option Comparison
09  Recommendation
10  Migration Roadmap
11  Risk Matrix
12  Expected Benefits
13  Decision Required

每一页其实都是：

Slide Type
+
Data
+
Conclusion

而不是：

一张空白PPT
+
Copilot自由发挥

稳定性会高非常多。

11. 还有一个非常重要的设计：不要把“样式”放进 Slide Type

例如：

risk-matrix

只负责：

风险矩阵应该表达什么、需要什么数据、怎么组织。

而：

consulting-theme

负责：

字体、字号、间距、边框、图表样式、页眉页脚等。

这样你以后换风格非常容易：

                Slide Type
                    │
          ┌─────────┴─────────┐
          ↓                   ↓
 Consulting Theme        Corporate Theme
          ↓                   ↓
        PPTX                PPTX

甚至以后可以做：

McKinsey-like
Accenture-like
Japanese Corporate
Internal Standard

但内容结构不变。

12. 对你来说，我建议第一版不要做20种

先做 12种最常用的：

#	Slide Type	你使用频率
01	Executive Summary	★★★★★
02	KPI Dashboard	★★★★★
03	Key Message	★★★★★
04	Timeline	★★★★★
05	Gantt / Progress	★★★★★
06	Before / After	★★★★★
07	Process Flow	★★★★★
08	Architecture	★★★★★
09	Comparison	★★★★★
10	Risk Matrix	★★★★☆
11	Roadmap	★★★★☆
12	Decision Required	★★★★★

先把这12个做得非常好。

不要一开始做50种。

最终架构

我会把整个系统设计成：

                    原始资料
                       │
                       ▼
              Consulting Thinking
                       │
                       ▼
                   Storyline
                       │
                       ▼
              ┌────────────────┐
              │ Slide Selector │
              └───────┬────────┘
                      │
        ┌─────────────┼─────────────┐
        ▼             ▼             ▼
     KPI         Process Flow    Risk Matrix
        │             │             │
        └─────────────┼─────────────┘
                      ▼
                Presentation
                      │
              ┌───────┴───────┐
              ▼               ▼
             PPTX            HTML

这套架构特别适合你，因为你之前已经在考虑 HTML 项目概要 + PPT + GitHub Copilot。实际上可以让 Slide Type Library 同时服务 PPT 和 HTML，以后维护一套内容、两种输出。

Slide Type Library不是ppt模板，对吧？

对，不是传统意义上的 PPT 模板。而且这个区别非常重要。

你可以把它理解成：

PPT模板 = “长什么样”
Slide Type Library = “这一页应该怎么表达信息”

举个最直观的例子

你要汇报项目风险。

传统 PPT 模板可能是：

┌──────────────────────────────┐
│ 项目风险                      │
│                              │
│ 文字框                        │
│ 文字框                        │
│ 文字框                        │
│                              │
└──────────────────────────────┘

它只告诉你：

标题放这里、文字放这里。

而 Slide Type = Risk Matrix 告诉 Copilot：

这个页面的目的：
→ 让管理层快速看到哪些风险最重要

应该包含：
→ 风险
→ Impact
→ Likelihood
→ Owner
→ Mitigation

最佳视觉：
→ 2×2 Risk Matrix

页面结论：
→ 最大风险是什么
→ 为什么
→ 怎么处理

然后 Copilot 才根据实际项目数据生成：

             Impact
               ↑
               │
        R2     │      R1
               │
───────────────┼──────────────→
               │
        R4     │      R3
               │

所以它更接近：

“咨询公司的页面设计方法论 + 信息结构模板”

而不是 PPT 文件。

但是，最后还是需要 PPT Template

实际上你最终应该有两个东西：

Slide Type Library
        │
        │ 决定“表达什么、怎么表达”
        ▼
Presentation Design System
        │
        │ 决定“长什么样”
        ▼
PPTX Template / Renderer
        │
        ▼
      PPT
例如

Slide Type

Risk Matrix

规定：

2×2 Matrix
X轴 = Likelihood
Y轴 = Impact
显示 Top Risks
标记 Critical Risk
下方放 Mitigation

↓

Design System

规定：

16:9
字体
标题大小
页面边距
图形圆角
线条
图表字体
页码
页眉

↓

PPT Template / Renderer

真正把它画成：

PowerPoint Slide
所以我建议你最终做成三层
┌─────────────────────────────────┐
│ ① Consulting Methodology        │
│                                  │
│ MECE / Issue Tree / Pyramid      │
│ Conclusion First / Storyline     │
└───────────────┬─────────────────┘
                ↓
┌─────────────────────────────────┐
│ ② Slide Type Library             │
│                                  │
│ Risk Matrix                      │
│ Gantt                            │
│ Architecture                     │
│ Comparison                       │
│ Before / After                   │
│ Process Flow                     │
│ KPI Dashboard                    │
└───────────────┬─────────────────┘
                ↓
┌─────────────────────────────────┐
│ ③ Design System / PPT Template  │
│                                  │
│ Font / Layout / Spacing          │
│ Shape / Chart / Header / Footer  │
└───────────────┬─────────────────┘
                ↓
              PPTX

这才是比较完整的体系。

更进一步

其实 Slide Type Library 甚至不应该只服务 PPT。

例如同一个：

Risk Matrix

可以渲染成：

       ┌──────────────┐
       │     PPT      │
       └──────────────┘

       ┌──────────────┐
       │     HTML     │
       └──────────────┘ｓ

       ┌──────────────┐
       │    PDF       │
       └──────────────┘

这就是为什么我建议你先设计 Slide Type，再设计 PPT 模板。

对你这个需求来说，下一步其实应该先把 12个核心 Slide Type 的“标准定义”设计出来，然后再做 PowerPoint 的视觉模板。这样 Copilot 才真正能稳定地产出你想要的公司资料”。