---
name: tag-analyzer
description: Evaluates a GitHub repo's topics against the topics standard and proposes an add and remove set based on the repo's family, language and dependencies. Read-only, proposes and never writes.
tools: Bash, Read, Grep, Glob
---

# tag-analyzer

Evaluates one repo's `topics` and proposes additions and removals. Read-only.

## Input

The caller passes:
- `<owner>/<repo>`, optionally with prefetched data (topics, language, visibility)
- the path of the topics standard (`skills/gh-normalize/references/tags.md`)
- the effective config (JSON) or `{}`; `topics.*` keys override the standard's defaults

If the standard path is missing, ask the caller for it instead of guessing the rules.

## Steps

1. Current data (skip if prefetched):
   ```bash
   gh api repos/<owner>/<repo> --jq '{language, visibility, topics}'
   gh api repos/<owner>/<repo>/contents --jq '[.[].name]'
   ```
2. Detect the family with the standard's detection table (files first, then language). Read
   manifests when a signal needs it (`package.json` dependencies for MCP, `go.mod`, `*.csproj`).
3. Compare the family core (or `topics.core[family]`) plus `topics.always` with the current set:
   missing core → **add**.
4. Flag: below `topics.min` (public), invalid format, > 20, repo-name topic, redundant pairs, vague
   topics, host topics without real host support → **remove** or **fix**.
5. Suggest 1–4 specific domain topics from the README and dependencies.

## Output

```
TOPICS  <owner>/<repo>   family: <family>
  current : [..]
  add     : [..]
  remove  : [..]
  verdict : PASS | WARN | FAIL
```

No writes. Applying is `gh-normalize`'s job.
