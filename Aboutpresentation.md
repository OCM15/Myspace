# プレゼン資料の作り方と、AI に渡す設計指示

以下は、発表資料を「ただのスライド」ではなく、意思決定に使える構造化資料として作るための考え方です。

## 1. まず問題を明確にする

```text
① 問題を明確化
      ↓
② 結論を導く
      ↓
③ 論理ツリーを作る
      ↓
④ Storyline を決める
      ↓
⑤ 1ページにつき1つの核メッセージだけを伝える
      ↓
⑥ 図・表・フローで表現する
      ↓
⑦ 最後に PPT を生成する
```

```text
元の情報
   │
   ▼
┌────────────────────┐
│ ① Consulting       │
│    Thinking        │
│ 論理・フレーム・結論 │
└──────────┬─────────┘
           ↓
┌────────────────────┐
│ ② Storyline        │
│ 章立て・ページ構成   │
└──────────┬─────────┘
           ↓
┌────────────────────┐
│ ③ Visual Design    │
│ 図・表・フロー・行列 │
└──────────┬─────────┘
           ↓
┌────────────────────┐
│ ④ PPT Generator    │
│ PowerPoint         │
└────────────────────┘
```

---

## 2. 役割分担の基本構造

```text
.github/
└── skills/
    └── consulting-presentation/
        ├── SKILL.md
        ├── templates/
        ├── examples/
        └── rules/
```

次のような構成にしておくと、発表資料の質を安定させやすくなります。

```text
01 エグゼクティブサマリー
   ↓
02 なぜ今変えるのか
   ↓
03 現状の課題
   ↓
04 事業への影響
   ↓
05 目標アーキテクチャ
   ↓
06 移行オプション
   ↓
07 オプション比較
   ↓
08 推奨アプローチ
   ↓
09 移行ロードマップ
   ↓
10 リスクと対策
   ↓
11 プロジェクト体制
   ↓
12 投資と効果
   ↓
13 意思決定が必要な項目
```

| 情報の種類 | 自動選択する視覚化 |
| --- | --- |
| 時間 | Timeline |
| プロジェクト進捗 | Gantt |
| 2つの選択肢 | Comparison |
| 多要因比較 | Matrix |
| 因果関係 | Flow |
| システム関係 | Architecture |
| 階層関係 | Pyramid |
| 4つの観点 | 2×2 Matrix |
| 数字の推移 | Line Chart |
| 構成比 | Stacked Bar |
| KPI | KPI Cards |
| 前後比較 | Before / After |
| 問題分析 | Issue Tree |
| 業務フロー | Process Flow |
| 判断 | Decision Tree |

---

## 3. 推奨する Skill 構成

```text
.github/
│
├── copilot-instructions.md
│
└── skills/
    ├── consulting-thinking/
    ├── presentation-storyline/
    ├── presentation-visualization/
    ├── project-management/
    ├── project-progress-report/
    ├── solution-proposal/
    └── executive-report/
```

役割分担は次の通りです。

### consulting-thinking

担当:

- MECE
- Issue Tree
- 仮説
- 結論

### presentation-storyline

担当:

- 章立て
- Storyline
- ページ論理

### presentation-visualization

担当:

- どの図で表現するか

### project-management

担当:

- WBS
- スケジュール
- リスク
- 課題
- マイルストーン

### solution-proposal

担当:

- As-Is / To-Be
- アーキテクチャ
- オプション
- 推奨案

最後に、

### ppt-generator

が実際に .pptx を作成します。

---

## 4. 目指す最終成果

たとえば、Copilot に次のような入力だけを与えれば、アイデアをまとめた資料として生成できます。

```text
プロジェクト: Sybase → Oracle 移行
目的: 保守コストの削減
期限: 2027年3月リリース
現在: Requirement 100%, Design 80%, Development 45%
主要課題: 性能検証にリスクがある
対象: 経営層向けの報告
ページ数: 15ページ以内
スタイル: コンサル風
図表を優先
文字は最小限
最後に経営層が決定すべき事項を明示
```

その後、Copilot は次の流れで処理します。

```text
分析 → Storyline → ページ設計 → 図表 → PPT
```

---

## 5. 全体ディレクトリ構成

```text
.github/
│
├── copilot-instructions.md
│
└── skills/
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
```

---

## 6. 最重要の Skill: consulting-thinking

```yaml
---
name: consulting-thinking
description: Apply structured consulting thinking to IT project planning, progress reporting, issue analysis, solution proposals, and executive presentations.
---
```

# Consulting Thinking

## 核となる原則

スライドを作り始めてはいけません。

まず最初に次を理解します。

1. 何が問われているのか
2. 何が結論なのか
3. その結論を支える根拠は何か
4. どの判断や行動が必要なのか

## ルール

### 1. 結論を先に置く

各大セクションには明確な結論を置きます。

避けるべき書き方:

- Project Status
- Current Issues
- Solution Comparison

推奨する書き方:

- 全体の進捗は順調だが、2つの重大なリスクが残っている
- データ移行が最大のスケジュールリスクである
- オプションBが、コスト・リスク・納期のバランスで最も優れている

### 2. MECE

可能な限り、重複のない独立した観点で整理します。

### 3. Issue Tree

問題が複雑な場合:

```text
Problem
├── Business
├── Technology
├── Process
├── Organization
└── Cost
```

### 4. Fact / Analysis / Recommendation

次の区別を明確にします。

```text
Fact
↓
Analysis
↓
Implication
↓
Recommendation
```

仮説を事実として扱わないこと。

### 5. 経営層の視点

経営層向けのプレゼンでは、次を必ず明確にします。

- 重要メッセージ
- 事業への影響
- 主要リスク
- 必要な意思決定
- 次の行動

---

## 7. presentation-storyline

```yaml
---
name: presentation-storyline
description: Create consulting-style presentation storylines for executive reports, project plans, progress reports, research reports and solution proposals.
---
```

# Presentation Storyline

## 標準構成

必要に応じて、次の構成を使います。

1. エグゼクティブサマリー
2. 背景
3. 現状
4. 主要課題
5. 分析
6. オプション
7. 推奨案
8. ロードマップ
9. リスク
10. 次のアクション / 必要な判断

この構成が最適でない場合は、別の論理構造を使ってよいです。

## スライドのルール

1枚のスライド = 1つの重要メッセージです。

スライド題は結論を伝える必要があります。

悪い例:

```text
Project Progress
```

良い例:

```text
全体の進捗は82%であり、開発は依然としてクリティカルパス上にある
```

## スライドの内容

各スライドには次を含めます。

- 結論タイトル
- 根拠
- 視覚的な説明
- 必要に応じて注記・出典

長い段落は避けます。

## Storyline の品質

プレゼンは次を答えられる必要があります。

```text
WHY?
→ WHAT?
→ SO WHAT?
→ NOW WHAT?
```

聴衆がスライドタイトルだけで結論を理解できる状態を目指します。

---

## 8. presentation-visualization

```yaml
---
name: presentation-visualization
description: Select and design effective consulting-style visualizations, diagrams, charts, matrices, timelines and process flows for PowerPoint and HTML presentations.
---
```

# Visualization Rules

不要なテキストよりも、視覚表現を優先します。

## 視覚化の選択

以下のような図を使い分けます。

- Timeline → スケジュール / ロードマップ / マイルストーン
- Gantt → プロジェクト計画 / 進捗
- Process Flow → 業務プロセス / システムフロー
- Architecture → システム関係
- Before / After → 変革の比較
- 2×2 Matrix → 戦略的な位置づけ / リスク分析
- Comparison Matrix → オプション比較
- Issue Tree → 問題分解
- Pyramid → 階層 / 経営層メッセージ
- Waterfall → コスト / 効果 / 財務影響
- Line Chart → 時系列の変動
- Bar Chart → 比較
- Stacked Bar → 構成比
- KPI Cards → 重要な数字
- Heatmap → リスク / 優先度
- Decision Tree → 判断ロジック

## 視覚化の原則

装飾のために図を加えないこと。

すべての視覚要素は情報伝達の役割を持つ必要があります。

## テキスト密度

推奨:

```text
1つの図 + 3つの重要メッセージ
```

避けるべき:

```text
10個の箇条書き
```

---

## 9. プロジェクト計画向け Skill

```yaml
---
name: project-management
description: Create professional IT project plans including WBS, milestones, schedules, dependencies, resources, risks and governance.
---
```

# Project Management

次を分析します。

- 範囲
- 成果物
- WBS
- マイルストーン
- 依存関係
- スケジュール
- リソース
- リスク
- 課題
- ガバナンス

推奨する視覚化:

- WBS
- Gantt Chart
- Milestone Timeline
- Dependency Diagram
- RACI
- Risk Matrix
- Governance Structure

プロジェクト計画では常にクリティカルパスを特定します。

強調するべき項目:

- 重要な活動
- 依存関係
- 判断ポイント
- 主要リスク

---

## 10. プロジェクト進捗報告

```yaml
---
name: project-progress
description: Create executive-level IT project progress reports using schedule, KPI, milestone, risk and issue analysis.
---
```

# Project Progress

次を常に分析します。

1. 計画進捗
2. 実績進捗
3. 乖離
4. 原因
5. 影響
6. 復旧アクション

推奨スライド:

- エグゼクティブサマリー
- 全体状況
- スケジュール進捗
- 成果物状況
- マイルストーン状況
- 課題 / リスク
- 復旧計画
- 次の2〜4週間
- 経営層の意思決定事項

RAG で状況を示します。

- Green = 問題なし
- Yellow = 注意が必要
- Red = 重大

Copilot で自動生成しやすい例:

```text
Plan       Actual
████████   ████████

Overall: 82%

Schedule: 🟢
Quality:  🟢
Cost:     🟡
Risk:     🔴
```

---

## 11. ソリューション提案 Skill

```yaml
---
name: solution-proposal
description: Create consulting-style IT solution proposals covering current state, problems, target state, architecture, options, recommendation, benefits, costs and roadmap.
---
```

# Solution Proposal

標準的な論理:

```text
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
```

必ず次を区別します。

```text
AS-IS
TO-BE
GAP
```

複数オプションを比較する場合は、次の観点を使います。

- Criteria
- Cost
- Schedule
- Technical Risk
- Operational Impact
- Scalability
- Maintainability

そのうえで、次を提示します。

- Recommendation
- Reason
- Trade-offs

---

## 12. Executive Report

```yaml
---
name: executive-report
description: Create concise executive presentations for senior management with strong conclusions, KPI visualization, risks and decision requests.
---
```

# Executive Report

経営層は3分以内に内容を理解できる必要があります。

優先順位:

1. 何が起きたのか
2. なぜそうなったのか
3. それがどういう意味を持つのか
4. 何をすべきか
5. どの判断が必要か

不要な技術詳細は省きます。

経営層向けの資料には、必ず次を含めます。

- エグゼクティブサマリー
- 主要数字
- 重大な課題
- 事業への影響
- 推奨案
- 決定が必要な事項
- 次のアクション

---

## 13. 重要な設計原則: PPT Design System

コンサルティング会社のブランドデザインをそのまま真似するのではなく、

「上位レベルのコンサル風スタイル」を共通設計として定義するのがよいです。

例:

```text
Consulting Presentation Design System
```

規定:

- 画面比率: 16:9
- タイトル: 1ページ1結論
- タイトルサイズ: 28〜32pt
- 本文サイズ: 16〜20pt
- 原則: 大見出し → 1つの結論 → 1つの主要ビジュアル → 2〜4個の支えとなる要点 → 余白を作る

推奨:

```text
████████████████

       図

████████████████
```

避けるべき:

```text
████████████████
文字文字文字文字文字
文字文字文字文字文字
図図図図図図図図
文字文字文字文字
文字文字文字文字
████████████████
```

---

## 14. Slide Type Library を追加する提案

```text
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
```

---

## 15. 最終的なワークフロー

```text
input/
├── meeting-notes.md
├── project-status.xlsx
├── system-overview.docx
└── requirements.md
```

その後、次の流れで進めます。

```text
元データ
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
PPTX             HTML
```

---

## 16. 途中形式としての定義を推奨

```json
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
```

次のように変換できます。

```text
presentation.json
      │
      ├────→ PPTX
      │
      └────→ HTML
```

---

## 17. 使いやすい Prompt の例

```text
input/ 配下の資料を基に、経営層向けのプロジェクト進捗報告を作成してください。

条件:
- コンサル会社風のデザイン
- 10ページ以内
- まず結論を先に示す
- 1ページにつき1つの重要メッセージ
- 可能な限り図で表現する
- 適切な図表を自動選択する
- プロジェクトのリスクを明確にする
- 次の4週間の計画を強調する
- 経営層が決定すべき事項を明示する
- PPTX 形式で出力する
- 同時に HTML 版も出力する
```

Copilot は次の流れで動作させます。

```text
資料分析
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
```

---

## 18. 実運用での具体例

実際に運用するなら、上の設計だけでなく、次の4つの実ファイルを作る方がよいです。

```text
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
```

さらに次も用意すると実務に向きます。

```text
presentation/
├── presentation.json
├── templates/
├── slide-types/
└── generate-ppt.py
```

---

## 19. Slide Type Library の設計例

「Slide Type + Layout Rule + Data Schema + Example」の4層で構成することを推奨します。

```text
presentation/
└── slide-library/
    ├── README.md
    ├── executive-summary/
    ├── kpi-dashboard/
    ├── timeline/
    ├── before-after/
    ├── issue-tree/
    ├── comparison/
    ├── roadmap/
    └── decision/
```

---

## 20. まとめ

発表資料を成功させるコツは、スライドを作る前に結論を決め、論理構造を整え、視覚表現を選び、最後に資料としてまとめることです。

重要なのは、単に「見た目がいい」資料を作ることではありません。

- 問題を明確にする
- 結論を先に置く
- 1ページ1メッセージにする
- 図で理解させる
- 経営層が決断できる材料にする

この順番を守ることで、AI でも一貫した品質の発表資料を作成できます。
