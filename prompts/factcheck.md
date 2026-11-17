# ファクトチェックの担当への指示（雛形・3 人に観点を分けて並列）

```
Fact-check the Japanese deck text E:\Github\<slug>-guide\research\deck_text.md (slide text + speaker notes,
slide numbers S1..Sn) from the angle: <標準 | 製品 | 書籍と機関>.
Do not edit files. Open primary sources (standards with section numbers, official product docs, authority
documents; for books use the mapping notes research/notes/10–13 — the book PDFs are in research/books/ and
must not be quoted beyond 15 words).
Angle details:
- 標準: section numbers, MUST/SHOULD vs MAY, draft versions, ordering of steps, what a spec does not say.
- 製品: defaults, limits, lifetimes, names, recent changes; give the doc URL and its last-updated date.
- 書籍と機関: printed page numbers vs claims; whether an authority document is normative or a recommendation
  and for whom; books cited as principle (考え方) vs rule.
Report in Japanese, max 1,200 words: each finding = slide number, the wrong text (short), why (source URL +
section), the corrected text, severity (誤り/不正確/補足). Most important first. List what you did not check.
```

反映した結果は `research/reviews/factcheck-<日付>.md` に残す（指摘ごとに「直した／直さない理由」）。
