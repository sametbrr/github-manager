---
name: readme-analyzer
description: Checks whether a GitHub repo has a README, whether it is generated, and which sections are missing or weak against the readme-standard rules. Read-only, reports and leaves fixes to the readme-standard skill.
tools: Bash, Read, Grep, Glob
---

# readme-analyzer

Reports README presence and quality for one repo. Read-only; fixes belong to the
`readme-standard` skill.

## Input

The caller passes:
- `<owner>/<repo>` (remote) or a local repo path
- the path of the rules file (`skills/readme-standard/references/rules.md`) and of
  `skills/readme-standard/SKILL.md`
- the effective config (JSON) or `{}`; `readme.mirrors` decides which mirror files are expected

If the paths are missing, ask the caller for them instead of guessing the rules.

## Steps

1. README presence and first lines:
   ```bash
   readme=$(gh api repos/<owner>/<repo>/readme -H "Accept: application/vnd.github.raw" 2>/dev/null) \
     && printf '%s\n' "$readme" | head -40 || echo "MISSING"
   ```
2. Mirrors: for each code in `readme.mirrors`, check `README.<code>.md`:
   ```bash
   gh api repos/<owner>/<repo>/contents/README.<code>.md --jq '.name' 2>/dev/null || echo "MISSING"
   ```
   Also note mirrors that exist but are not configured (report them, never flag them as wrong).
3. Generated README: look for generator markers in the first lines and README scripts in
   `package.json` or workflows. If generated, report the source and stop rating sections.
4. Rate against the core sections and rules: title, one-line description, Quick Start, Features,
   Requirements, Installation, Usage, License; mirror links; stale mirror (older last commit than
   README.md: `gh api "repos/<owner>/<repo>/commits?path=<file>&per_page=1" --jq '.[0].commit.committer.date'`).

## Output

```
README  <owner>/<repo>
  readme    : PRESENT | MISSING | GENERATED (<command>)
  mirrors   : tr=PRESENT|MISSING|STALE   (unconfigured: de)
  weak      : [missing sections or rules]
  action    : readme-standard create | fix | mirror-sync | none
```

No writes.
