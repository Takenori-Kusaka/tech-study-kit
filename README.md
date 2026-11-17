# tech-study-kit

新しい技術スタックに向き合うたびに、**新任のテックリーダーがそのまま使える日本語の資料一式**を作るための手順書と雛形です。セッションが失われても、このリポジトリだけで同じ品質の成果物を再現できることを目的にしています。

## 作るもの（1 テーマあたり）

| 成果物 | 中身 | 公開先 |
| --- | --- | --- |
| ガイド（前提編） | 120〜150 枚のスライド。各スライドに根拠（仕様・権威ある機関・日本語の書籍の章とページ）と発表者ノート | GitHub（`<slug>-guide`）、GitHub Pages の Web 版、Docswell |
| ケーススタディ（実測） | 2〜3 の題材で「共通の基準」「題材ごとの重点」「見送り」を決め、攻撃・正規の要求と除去実験で効果を測る | GitHub（`<slug>-casestudy`） |
| 付録の一覧表（任意） | 対象の項目（クレーム・設定・API など）を出典ごとに 1 行で網羅し、題材ごとの採否と理由を付けた xlsx | ケーススタディのリポジトリ |
| 記事 | Zenn（正本）・Qiita・note・SNS | publishing-hub 経由（PR のマージで公開） |
| 共有文 | Teams に貼る紹介文 | ユーザーが貼る |

## 使い方

1. スキルを入れる（初回だけ）: `bash scripts/install-skill.sh`（`~/.claude/skills/tech-study/` に SKILL.md を写す）
2. Claude Code で「〇〇について、前回と同じようにガイドとケーススタディを作って」と頼むか、`/tech-study <テーマ>` を呼ぶ
3. スキルが [playbook/](playbook/) の手順を順に進める。雛形は `bash scripts/new-project.sh <slug> "<日本語タイトル>"` で作る

## 構成

- [playbook/](playbook/) — 手順書（00 全体像 → 08 教訓）。**ここが正本**
- [prompts/](prompts/) — サブエージェントに渡す指示の雛形（調査・ファクトチェック・列の自己レビュー・判定の点検・記事の執筆）
- [skill/tech-study/SKILL.md](skill/tech-study/SKILL.md) — Claude Code のスキル（手順書への入口）
- `templates/` — デッキの生成器（pptxgenjs）、QA（PowerPoint COM）、Web 版の生成、リポジトリの雛形、一覧表のパイプライン、除去実験の骨組み
- `scripts/` — 新しいテーマの作成、スキルのインストール
- [examples/projects.md](examples/projects.md) — これまでの成果物と、それぞれで学んだこと

## 前提の環境

- Windows 11 + Git Bash、PowerShell、PowerPoint（QA と PDF 出力に COM を使う）
- Node 20 以降（pptxgenjs）、Python 3.12 以降（openpyxl、python-pptx、PyMuPDF、Pillow）
- WSL2 の Docker（ケーススタディで実機の製品を動かすとき。ディスクは E: に置く）
- Claude in Chrome（電子書籍の購入ページの案内、Docswell へのアップロード。ログインと支払いはユーザー本人）
- C: は空きが少ない。成果物・コンテナ・node_modules は E: に置く
