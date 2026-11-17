# 07 公開と記事

**すべて外向きの行為。それぞれ、ユーザーに確認してから行う。**

## 公開前の確認

```bash
grep -rIl -i "users\\\\\|/users/\|gmail\|BEGIN .*PRIVATE" --exclude-dir=node_modules --exclude-dir=.git .
git status --short   # 書籍の PDF・本文、鍵、make.sh のローカルパスが入っていないか
```

README に：ガイド・ケーススタディ・一覧表の相互リンク、調査日、限界、ライセンス（文章 CC BY 4.0／コード MIT）、生成 AI の利用の開示。件数は結果のファイルから数える。

## GitHub と Pages

```bash
gh repo create <owner>/<slug>-guide --public --description "..." --source . --remote origin --push
# Pages：Settings → Pages → main / docs。Web 版は docs/index.html（#sN でスライドに飛べる）
```

## Docswell

- Claude in Chrome で docswell.com を開き、ユーザーがログイン
- PDF をアップロード（file_upload）。タイトル、説明（リポジトリと Web 版へのリンク）、タグ、公開範囲を入れる
- 更新は同じスライドの「差し替え」で URL を保つ

## 記事（publishing-hub）

`E:\Github\publishing-hub` の `AGENTS.md` と `CLAUDE.md` が正本。要点：

1. ブランチを切る（`main` に push しない）
2. 執筆の担当（[prompts/article-writer.md](../prompts/article-writer.md)）が Zenn（正本）・Qiita・note・SNS を書く。正本にない事実を足さない。`lint/policies/review.json` に新しいリポジトリを正本として登録
3. `node scripts/review/pack.mjs <原稿>` で入力を作り、**原稿ごとに事実の査読と読者役を別の担当**に（`scripts/review/prompts/` の指示書）。出力は `.tmp/review/<id>/fact.yaml`・`cold.yaml`
4. 取りまとめ役（自分）が採否を決め、執筆の担当が直す。`meta.yaml` → `node scripts/review/assemble.mjs <原稿>`。**原稿と記録は別のコミット**
5. `npm run check`（review 以外エラー 0、派生物の段階は警告 0）、`npm run social:validate`、`npm test`
6. push して PR。ユーザーがマージすると即時公開。マージ後に Zenn・Qiita・note・SNS の URL が開けることを確かめてから報告

注意：査読の出力が YAML として壊れていたら、書いた担当に直させる（取りまとめ役は中身を書き換えない）。

## Teams の共有文の型

```
**【共有】<タイトル>を公開しました**
<何の資料か、誰向けか、1〜2 文>
<一番伝えたいこと、1〜2 文>

■ ガイド（N 枚のスライド）
- 内容：…
- 根拠：…
- Web 版／Docswell／リポジトリ（調査ノート・書籍の対応表・ファクトチェックの記録）

■ ケーススタディ（実測）
- 題材と測り方、主な結果 3 点、実機と模擬の区別
- リポジトリ

■ 付録：一覧表（Excel、N 行）
- 何が入っているか、どう使えるか、ダウンロードのリンク

■ 記事
- Zenn／Qiita／note

※ 調査日、仕様が変わること、生成 AI の利用の開示
```

**ガイドのリポジトリのリンクを落とさない**（根拠の記録そのもの。JWT の回で落としてユーザーに指摘された）。
