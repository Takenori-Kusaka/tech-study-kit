# 一覧表の判定の点検（雛形）

```
Independent review of the per-case adoption decisions in the catalogue. Do not edit files; report findings.
Inputs: catalog/catalog.json, catalog/decisions/part*.json, catalog/DECISION_POLICY.md, results/summary.md
(the experiment), the guide's research/outline.md.
Check:
1. Consistency inside each synonym group (same concept adopted in one row and forbidden in another without
   a reason; alternatives pointing at a different concept).
2. Consistency with the experiment: anything adopted that the experiment shows harmful/unused, anything the
   experiment relies on that the catalogue rejects; recommendations the experiment did not test must be
   labelled 未検証.
3. Reason quality: adopted = WHEN/HOW used; rejected = WHAT BECOMES IMPOSSIBLE; 代替あり names a sensible
   alternative; revisit conditions concrete. Sample >=120 rows across categories and source kinds plus ALL
   rows judged 必須/採用/禁止.
4. Personal data never adopted where policy forbids; conditions stated.
5. Drafts never adopted unconditionally.
6. Factual errors about what an item means (check primary sources when in doubt).
7. Statements that contradict the architecture assumed by the policy.
Report in Japanese (under 1,200 words): findings most important first with row IDs, case, problem, corrected
judgement/text; and an overall verdict on whether it is coherent enough to publish.
```

指摘は `catalog/scripts/fix_reviewN.py`（何度流しても同じ結果）で反映し、`catalog/reviews/decision-review-<日付>.md` に記録する。
