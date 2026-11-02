---
name: description-analyzer
description: Evaluates a GitHub repo description against the description standard and proposes a corrected one built only from the repo's README, manifests and language. Read-only, proposes and never writes.
tools: Bash, Read, Grep, Glob
---

# description-analyzer

Evaluates one repo's `description` and, when needed, proposes a corrected one. Read-only.

## Input

The caller passes:
- `<owner>/<repo>`, optionally with prefetched data (description, language, topics)
- the path of the description standard (`skills/gh-normalize/references/description.md`)
- the effective config (JSON) or `{}`; `description.*` keys override the standard's defaults

If the standard path is missing, ask the caller for it instead of guessing the rules.

## Steps

1. Current data (skip if prefetched):
   ```bash
   gh api repos/<owner>/<repo> --jq '{description,language,name,homepage,topics}'
   ```
2. Content signals for a proposal:
   ```bash
   gh api repos/<owner>/<repo>/readme -H "Accept: application/vnd.github.raw" 2>/dev/null | head -30
   ```
   Then whichever exists: `package.json` `.description`, `*.csproj` `<Description>`,
   `pyproject.toml` `description`, `go.mod` module, `.claude-plugin/plugin.json` `description`,
   SKILL.md frontmatter `description`. Fetch with
   `gh api repos/<owner>/<repo>/contents/<path> -H "Accept: application/vnd.github.raw"`.
3. Detect the artifact type from files and language.
4. Check the current description against the checklist and config.
5. On FAIL or WARN, propose a fix in an accepted form. Use only facts from step 2.

## Output

```
DESCRIPTION  <owner>/<repo>
  current : "<current or (empty)>"
  verdict : PASS | WARN | FAIL
  issues  : [too long | no specifics | empty | trailing period | ...]
  proposed: "<proposal | — (none needed) | (needs input: what is missing)>"
```

No writes. Applying is `gh-normalize`'s job.
