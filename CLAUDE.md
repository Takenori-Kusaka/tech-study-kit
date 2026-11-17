# tech-study-kit（作業ディレクトリ）

このディレクトリで Claude Code を起動し、`/tech-study <調べたい技術スタック・テーマ>` を実行すると、ヒアリング → 計画の承認 → guide／casestudy リポジトリの作成 → 公開・記事、まで進む（`.claude/skills/tech-study/SKILL.md`）。

- 考え方は `principles/`、手順は `playbook/`、担当への指示は `prompts/` が正本
- 成果物はこのリポジトリに入れない。キットと同じ親ディレクトリに `<slug>-guide` と `<slug>-casestudy` を作る
- 応答は日本語。外向きの行為は毎回確認。ログイン・購入・支払いはユーザー本人
- 回の途中で中断したら、`<slug>-guide/research/plan.md` の「進捗」から再開する
- 回が終わったら、新しく得た考え方・教訓だけをこのリポジトリに足して push する
