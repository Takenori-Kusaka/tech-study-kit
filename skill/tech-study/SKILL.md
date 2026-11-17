---
name: tech-study
description: 新しい技術スタック・技術領域について、新任テックリーダー向けの日本語ガイド（根拠つきスライド 120〜150 枚）、実測のケーススタディ（共通の基準＋重点＋見送りを攻撃と除去実験で測る）、付録の網羅的な一覧表（xlsx）、記事（publishing-hub 経由の Zenn・Qiita・note・SNS）、Teams の共有文を作る。「前回と同じように資料を作って」「〇〇についてガイドとケーススタディを」「新任のテックリーダー向けに〇〇の資料」と頼まれたとき、または /tech-study で呼ばれたときに使う。
---

# tech-study

正本は **E:\Github\tech-study-kit**（GitHub: Takenori-Kusaka/tech-study-kit）。このスキルは入口です。

## 最初にすること

1. `E:\Github\tech-study-kit` が無ければ `gh repo clone Takenori-Kusaka/tech-study-kit E:/Github/tech-study-kit`。あれば `git -C E:/Github/tech-study-kit pull`
2. `playbook/00-overview.md` を読み、フェーズと関門に沿って進める。各フェーズに入るときにその章（01〜07）を読む。`playbook/08-lessons.md` は着手前に必ず読む
3. `df -h /c /e` でディスクを確かめる（成果物・コンテナ・node_modules は E:）

## 進め方の要点

- 範囲を AskUserQuestion で 1 回にまとめて聞き、焦点を言い換えて齟齬を潰す（01）
- 根拠は一次資料・権威ある機関・日本語の書籍（章・節・印刷ページ）。書籍はユーザーが買う（02）
- 雛形は `bash E:/Github/tech-study-kit/scripts/new-project.sh <slug> "<タイトル>"`（03）
- 書いた本人と別の担当がレビューする：ファクトチェック 3 観点、列の自己レビュー、判定の点検、記事の査読（prompts/）
- ケーススタディは N・B・BE と除去実験。測っていないものは「未検証」（05）
- 一覧表は空欄を残さない。修正はスクリプトで（06）
- 公開・Docswell・記事の公開は外向きの行為。その都度確認。publishing-hub は main に push しない（07）

## 終わったら

- `examples/projects.md` に今回の成果物の URL と、新しく学んだ教訓を足す。教訓は `playbook/08-lessons.md` にも足す
- 雛形やスクリプトを改良したら、キットに戻してコミット・push する（次の回が楽になるように）
