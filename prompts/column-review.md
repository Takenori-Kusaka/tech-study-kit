# 一覧表の列の自己レビュー（雛形）

```
Review the column design of a Japanese catalogue (one row per item per defining source; per-case adoption
decisions) for <テーマ>. Inputs: catalog/SCHEMA.md and the user's requested columns:
<ユーザーが指定した列をそのまま>.
Judge: is anything missing that a tech lead needs to decide adoption (who can write the value, mutability,
freshness, authorisation use, personal-data class, logging policy, size limits, comparison rules, uniqueness
scope, vocabulary, synonym group, status/draft, change controller, verification date)? Is anything redundant
or ambiguous? Are the user's terms respected (do not rename user columns to words that clash with the
domain's translation)? Are the value vocabularies for each column closed and well-defined?
Write the review to catalog/reviews/column-review-<日付>.md (Japanese): a table of proposed columns with
meaning, allowed values, and why; plus a terminology table. Report the top 10 recommendations in under 300 words.
```
