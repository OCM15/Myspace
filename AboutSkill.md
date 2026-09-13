# Skill の整理と使い方

## 1. Skill のディレクトリ構造

以下のような構成が基本です。

```text
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
```

核心は次のルールです。

```text
.github/skills/<skill-name>/SKILL.md
```

---

## 2. SKILL.md には何を書くのか

たとえば Java Swing 開発向けの Skill を作るとします。

```yaml
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
```

ここで最も重要なのは次の2つです。

- name
- description

これらは Skill の識別名と概要を定義します。

---

## 3. Copilot は Skill をどう使うのか

依頼例:

```text
Java Swing のダッシュボードを設計して
```

この流れで動作します。

```text
ユーザー依頼
   ↓
Copilot がタスクを判断
   ↓
java-swing-development Skill を発見
   ↓
SKILL.md を読み込む
   ↓
Skill のルールに従って作業する
```

GitHub 公式の説明にもある通り、Copilot はタスクに応じて Skill が必要かどうかを判断し、必要なら SKILL.md の内容を現在の Agent context に読み込みます。

---

## 4. 他人が作った Skill をどうインストールするか

よく使うコマンドは次のとおりです。

```bash
gh skill search
gh skill preview
gh skill install
gh skill update
```

たとえば次のように使います。

```bash
gh skill search documentation
gh skill install OWNER/REPOSITORY SKILL
```

---

## 5. 自分で Skill を作る方法

他人が提供している Skill が次のような構成だとします。

```text
python-testing/
└── SKILL.md
```

これをプロジェクトに置けば、Copilot の Agent Mode で使えます。

```text
あなたのプロジェクト/
└── .github/
    └── skills/
        └── python-testing/
            └── SKILL.md
```

また、個人用の Skill をすべてのプロジェクトで使いたい場合は次のように置きます。

```text
~/.copilot/skills/python-testing/SKILL.md
```

そうすると、すべてのプロジェクトから利用できます。

---

## 6. Skill と copilot-instructions.md の違い

これは非常に重要です。

| 項目 | Instructions | Skill |
| --- | --- | --- |
| 目的 | グローバル / プロジェクト全体のルール | 専門的な作業能力 |
| 毎回必要か | 通常は必要 | 必要なときだけ読み込まれる |
| 向いている内容 | コーディング規約、プロジェクトルール | Java 開発、テスト、DB 変更など |
| 内容量 | 比較的短い | 比較的詳しい |
| スクリプト/リソース | 通常はなし | 付随することがある |
| 自動選択 | そこまで重視されない | タスクに応じて選ばれる |

GitHub 公式の推奨でも、ほぼすべての作業に共通するルールは custom instructions に置き、特定のタスクにだけ必要な内容は Skill として分離するのがよいとされています。

---

## 7. 推奨される Skill の例

```text
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
```

---

## 8. 実務での Skill 構成例

```text
.github/
├── skills/
│   ├── transaction-field-change/
│   │   └── SKILL.md
│   ├── database-change/
│   │   └── SKILL.md
│   └── api-change/
│       └── SKILL.md
│
└── copilot/
    └── coding-rules.md
```

```text
docs/
├── domain/
│   ├── transaction-types.md
│   └── transaction-rules.md
│
├── architecture/
│   └── system-overview.md
│
└── changes/
    ├── CHG-2026-001.md
    ├── CHG-2026-002.md
    └── ...
```

このような構成では、変更要求とその影響範囲を明確にしながら、Copilot に対して「どの Skill を使ってどこまで確認するべきか」を定義しやすくなります。

---

## 9. 変更要求と Skill の関係

```text
                    本次需求
                       │
                       ▼
              Change Request
              “この変更は何を変えるのか”
                       │
                       ▼
                Development Skill
                “どのように変更すべきか”
                       │
                       ▼
              Repository / 業務ルール
              “現在のシステムはどうなっているか”
                       │
                       ▼
                  Copilot
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
       Impact        Code          Test
       Analysis      Change       Verification
```

たとえば、以下のような Skill を持たせると実務で使いやすくなります。

```text
.github/skills/transaction-field-change/SKILL.md
```

中身としては、次のような観点を明示します。

- テーブルの分析方法
- INSERT / UPDATE / SELECT の探索方法
- Entity / DTO の確認方法
- API の確認方法
- フロントエンド確認方法
- NULL / Default の扱い
- 既存データへの影響確認
- Test の修正方法
- どこを勝手に変えてはいけないか
- 最後に必ず確認する項目

---

## 10. 実例: 変更要求の流れ

### 変更要求の例

```md
# docs/changes/CHG-2026-001.md

Table: TR_TRANSACTION

増加項目:

GUARANTEE_TYPE
VARCHAR(2)
NULL OK

対象:
- TradeTyp1
- TradeTyp2
- TradeTyp3

業務ルール:
- XX 取引は必須入力
- 通常の XX は NULL 可
```

依頼文の例:

```text
Copilot、transaction-field-change Skill に従って CHG-2026-001 を実装してください。
```

関連する設計情報:

- docs/domain/transaction-types.md
- docs/domain/transaction-rules.md

---

## 11. 実施手順の基本形

### Phase 1: Analyze

実施前に次を確認します。

- 要求内容を読み取る
- 取引定義を確認する
- 現在の DB スキーマを確認する
- 対象テーブルの参照箇所を全検索する
- INSERT / UPDATE / SELECT を確認する
- Entity / DTO を確認する
- API を確認する
- UI を確認する
- バリデーションを確認する
- テストを確認する

> ここでは影響分析を出すことが目的であり、コード修正は行いません。

### Phase 2: Implement

- DB を修正する
- Entity を修正する
- DTO を修正する
- SQL を修正する
- Service を修正する
- API を修正する
- UI を修正する
- バリデーションを修正する
- Test を修正する

### Phase 3: Verify

- TradeTyp1
- TradeTyp2
- TradeTyp3
- NULL
- 既存データ
- 既存 API
- 回帰テスト

---

## 12. まとめ

Skill は、単なるメモではなく、Copilot に「この種の作業では何を重視すべきか」を伝えるための専門知識セットです。

重要なのは次の3点です。

1. Skill は特定の作業領域に特化する
2. ルールは構造化して書く
3. タスクに応じて必要な Skill を選ばせる

これにより、Copilot はより一貫した判断と実装を行えるようになります。

---

## 13. 実運用での重要ポイント

- ルールが広すぎないようにする
- 専門性の高い Skill を細かく分ける
- 実案件に即した例を含める
- 影響範囲と検証観点を明確にする
- 変更前に分析を必須化する

このように整理しておくと、Copilot への指示が安定し、変更ミスや見落としを減らせます。
