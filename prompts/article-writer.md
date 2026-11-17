# 記事の執筆の担当への指示（雛形・publishing-hub）

```
Write a Zenn article (canonical) and its derivatives (Qiita, note, SNS) in E:\Github\publishing-hub for the
newly published guide + case study on <テーマ>.
MANDATORY: read AGENTS.md and CLAUDE.md first and follow them exactly (new branch feat/<slug>-article; never
push to main; LF; AI disclosure at the top; no work-environment paths; Co-Authored-By trailer; run
npm run check / social:validate / npm test; do NOT write fact_review / cold_read records). Read
docs/social-editorial-guide.md, lint/policies/*.json, and the previous pair as a model
(articles/<前回の slug>.md + its derivatives + social post + review records). Register the two new repos in
lint/policies/review.json like the previous entry.
Sources (the only allowed facts): the guide repo (README, deck text, research/notes, research/reviews) and the
case-study repo (README, results/summary.md, results/*.json, catalog docs). Count numbers from the result
files, say what a count counts, keep conditions attached to numbers, distinguish real products from mocks,
label untested recommendations, and do not claim artefacts that do not exist.
Content: problem and incidents, what the guide covers, case-study headline results (baseline vs emphasis vs
deferral, ablation insight), the appendix and how to use it, limitations, links (web slides, Docswell embed,
both repos, the xlsx). Set publication switches on the branch (Zenn published: true; Qiita private: false;
note status: ready; SNS status: ready) — publishing happens only when the human merges.
Commit on the branch, do not push. Report: branch, files, check results, uncertainties (under 300 words).
```

査読（事実の査読・読者役）は原稿ごとに別の担当へ。指示書は publishing-hub の `scripts/review/prompts/`。
