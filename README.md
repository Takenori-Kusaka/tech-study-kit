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

```bash
git clone https://github.com/Takenori-Kusaka/tech-study-kit E:/Github/tech-study-kit   # 初回だけ
cd E:/Github/tech-study-kit && claude
```

Claude Code で `/tech-study <調べたい技術スタック・テーマ>`（例：`/tech-study JWT トークンの基本とカスタムクレーム設計`）。

1. 複数回のヒアリングで、背景・目的・読者・範囲・成果物・制約を固め、`brief.md` を承認する
2. 下調べのうえで計画（Part 構成、ケーススタディの題材と測り方、書籍、公開先）を `plan.md` にまとめ、承認する
3. キットの隣に `<slug>-guide` と `<slug>-casestudy` が作られ、調査 → ガイド → ケーススタディ → レビュー → 公開（GitHub・Pages・Docswell）→ 記事（publishing-hub）→ Teams の共有文、と進む。公開・購入・ログイン・マージはその都度ユーザーが承認・操作する

## 構成

- [playbook/](playbook/) — 手順書（00 全体像 → 08 教訓）。**ここが正本**
- [prompts/](prompts/) — サブエージェントに渡す指示の雛形（調査・ファクトチェック・列の自己レビュー・判定の点検・記事の執筆）
- [.claude/skills/tech-study/SKILL.md](.claude/skills/tech-study/SKILL.md) — `/tech-study` スキル（段階と関門、ヒアリングの進め方、brief・plan の型）
- [CLAUDE.md](CLAUDE.md) — 作業ディレクトリとしての約束
- [principles/](principles/) — ベースとなる考え方（調査・ガイドの設計・ケーススタディ・検証の指針・WSL と Docker のノウハウ・進め方）
- `scripts/install-skill.sh` — キットの外でも `/tech-study` を使いたいときだけ
- [examples/projects.md](examples/projects.md) — これまでの成果物と、それぞれで学んだこと

## 状態（2026-11-18）

このリポジトリは**進め方のノウハウだけ**を置く。過去の回のスライド・調査資料・コードは持ち込まない（道具が要るときは、直近の回のリポジトリから新しいリポジトリへコピーする）。次の技術スタックの回で、この手順どおりに再現できるかを確かめ、直したらこの節を更新する。

## 前提の環境

- Windows 11 + Git Bash、PowerShell、PowerPoint（QA と PDF 出力に COM を使う）
- Node 20 以降（pptxgenjs）、Python 3.12 以降（openpyxl、python-pptx、PyMuPDF、Pillow）
- WSL2 の Docker（ケーススタディで実機の製品を動かすとき。ディスクは E: に置く）
- Claude in Chrome（電子書籍の購入ページの案内、Docswell へのアップロード。ログインと支払いはユーザー本人）
- C: は空きが少ない。成果物・コンテナ・node_modules は E: に置く
