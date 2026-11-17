# 01 範囲を決める

## 最初に聞くこと

ヒアリングは 1 回で済ませず、3〜5 回に分けて brief.md を固める（進め方と brief・plan の型は `/tech-study` スキル `.claude/skills/tech-study/SKILL.md`）。下は必ず決めること。

1. **形式**：ガイドだけ／ガイド＋ケーススタディ（推奨）
2. **対象の製品・実装**：主要な 3〜5 製品（例：IdP なら Entra ID・Keycloak・Auth0/Okta・Cognito）。ケーススタディで実機を動かせる OSS を 1 つは入れる
3. **題材**：2〜3（例：マルチテナント SaaS／社内業務システム／AI エージェント）。「3 つとも」が多い
4. **読者**：既定は「新任のテックリーダー」。前提知識の水準を決める

## 認識の齟齬を潰す

ユーザーは途中で焦点を言い直すことがある（JWT の回では「標準クレームを知りたいのではなく、サービス間で共用する**独自クレームの設計**の話」と訂正があった）。最初に次の形で言い換えて確かめる。

> 「〇〇そのものの解説ではなく、〇〇を使って組織で□□を設計・運用するときの判断の材料、という理解で合っていますか。標準や各製品の既定は、重複や衝突を避けるための前提知識として扱います」

ユーザーが挙げた論点は、すべて `research/outline.md` の「扱う論点」に転記し、どの Part で扱うかを対応づける（漏れの検出に使う）。JWT の回の例：権限（システム・サービス・ユーザー）、アクセス元の情報、処理結果の返し方、認証時に付けるか後段で足すか、拡張のフロー、マルチテナント、データアクセス・DB 認証、AI エージェントのポリシー、寿命と更新、機微情報とマスキング。

## outline.md の型

```markdown
# <タイトル> 構成案
## 読者と前提
## 扱う論点（ユーザーの言葉のまま）と対応する Part
## Part 構成（各 Part：問い／結論／主な根拠）
## ケーススタディの方針（題材・共通の基準の候補・重点の候補・見送りの候補・測り方）
## 参考書籍の候補と、どの Part で使うか
## 調査日
```

## ディスクと環境の確認

着手前に `df -h /c /e`。C: は逼迫しやすい。Docker（WSL）のディスク、node_modules、PDF は E: に置く。

## 新しいリポジトリを立ち上げる

範囲が決まったら、テーマごとに**新しいリポジトリを 2 つ**作り、以後の調査資料はすべてそこに集める（過去の回の資料やスライドは持ち込まない。持ち込むのは道具だけ）。

| リポジトリ | 置くもの |
| --- | --- |
| `E:\Github\<slug>-guide` | `research/outline.md`、`research/notes/`（調査ノート）、`research/reviews/`（ファクトチェックの記録）、`research/books/`（書籍の PDF・抽出本文。gitignore）、`deck/`（生成器とパート）、`slides/`（公開する pptx・PDF）、`docs/`（Web 版、GitHub Pages）、`tools/` |
| `E:\Github\<slug>-casestudy` | `cs/`（実験の仕組み）、`results/`、`catalog/`（一覧表を作るなら）、コンテナの設定、`keys/`（試験用の鍵。gitignore） |

手順：

1. `mkdir` → `git init`。最初のコミットは `README.md`（目的・読者・調査日）、`.gitignore`、`research/outline.md`
2. `.gitignore`：`research/books/`、`deck/node_modules/`、`deck/qa/`、`deck/*.pptx`（公開用は `slides/` に置く）、`research/deck_text.md`、手元のパスを含むスクリプト、`keys/`、`.venv/`
3. **道具**は直近の回のリポジトリからコピーする（中身のスライドや調査ノートはコピーしない）：デッキの生成器 `deck/lib.js`・`build.js`・`theme.js`・`qa.ps1`・`export.ps1`、Web 版の `tools/build_web_slides.py`、一覧表の `catalog/scripts/`。テーマの色・パンくずの段階・定数だけを書き換える。どの回のどのコミットから持ってきたかを README に書く
4. 公開するまではローカルだけ。公開は [07](07-publish.md)（その都度確認）
5. 調査のサブエージェントには、書き込み先のパス（`research/notes/<番号>_<名前>.md`）を必ず指定する。散らばった一時ファイル（NIST の PDF など）はリポジトリの外（`E:\Github\_scratch_<slug>\`）へ

直近の道具の場所は [examples/projects.md](../examples/projects.md)。

