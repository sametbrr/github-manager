---
name: gh-normalize
description: Fills in and standardizes GitHub repo descriptions and topics for one repo or a whole scope (public, private or all), with a current-to-proposed diff and confirmation per repo. Use when the user wants to fix, fill or clean up repo descriptions or topics after an audit.
disable-model-invocation: true
metadata:
  version: "1.0.1"
---

# gh-normalize

Brings repo `description` and `topics` in line with the standards in `references/`. One repo or a
batch, confirmed per repo.

Run only when the user explicitly asks.

## Usage

```
gh-normalize [--scope public|private|all] [--repo owner/name] [--confirm each|all] [--only desc|topics] [--dry-run]
```

## 0. Preflight

```bash
gh auth status >/dev/null 2>&1 || echo "not logged in"
```

If not logged in, ask the user to run `gh auth login` (scope `repo` is needed to edit repos) and
wait.

## 1. Config

```bash
cfg="${GITHUB_MANAGER_HOME:-$HOME/.agents/github-manager}/config.json"
[ -f "$cfg" ] && cat "$cfg" || echo '{}'
```

`description.*` and `topics.*` keys override the defaults. Schema:
`../gh-audit/references/config.md`.

## 2. Target (first match wins)

1. `--repo owner/name` → one repo
2. `--scope` → all repos in that scope, even when run inside a clone:
   `gh repo list <login> [--visibility public|private] --limit 300 --no-archived --source --json name,description,repositoryTopics,primaryLanguage,visibility`
   (for `all`, omit `--visibility`; gh accepts only public, private or internal)
3. current directory's git remote → one repo (`git remote get-url origin`)
4. none → ask the user (one repo or which scope) and wait for an explicit answer

Skip the profile repo (`<login>/<login>`), forks and archived repos unless the user names them.

## 3. Analyse (one repo at a time)

Standards: [references/description.md](references/description.md) and
[references/tags.md](references/tags.md). Pass their absolute paths and the config.

- unless `--only topics`: if your environment supports subagents, delegate to
  `agents/description-analyzer.md`; otherwise read `../../agents/description-analyzer.md` and
  follow it inline.
- unless `--only desc`: same for `agents/tag-analyzer.md`.

Hand prefetched data from step 2 to the analyzers to avoid extra API calls.

## 4. Confirmation gate

- `--confirm each` (default): show `current → proposed` per repo; apply, edit or skip on the
  user's answer.
- `--confirm all`: show the full proposal table, then apply all after one explicit approval.
- `--dry-run`: report only, no writes.

Never write a proposal marked `(needs input)` without the user's text.

## 5. Apply

Pass values as separate arguments; never build the command by pasting text into a shell string.

```bash
gh repo edit "<owner>/<repo>" --description "$new_description"
gh repo edit "<owner>/<repo>" --add-topic "a,b,c"
gh repo edit "<owner>/<repo>" --remove-topic "x,y"
```

## 6. Summary

```
NORMALIZE  scope=<scope>
  changed: <n>   skipped: <n>   errors: <n>
  repo            desc            topics
  my-cli          ✎ (181→142)     +cli
  lib-x           -               -javascript
```

## Rules

- Every write needs explicit approval; `--confirm each` is the default.
- Touch only the description and topics of the target repos. No other fields, no other repos.
- Proposals come from the analyzers and the standards, built from real repo data. Nothing invented.
