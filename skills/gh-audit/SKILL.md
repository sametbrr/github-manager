---
name: gh-audit
description: Produces a read-only health report for a GitHub account or a single repo, covering profile fields, profile README, repo descriptions, topics, license and README structure, across a chosen scope (public, private or all). Writes nothing. Use when the user asks to audit, review or check their GitHub profile or repos, or wants to know what to improve before fixing anything.
metadata:
  version: "1.0.0"
---

# gh-audit

Read-only health report. **Writes nothing**: no `gh repo edit`, no `PATCH`, no push, no file
changes. Checks the account and its repos against the standards bundled in this plugin and returns
one prioritised report.

## 0. Preflight

```bash
command -v gh >/dev/null || echo "gh CLI missing: https://cli.github.com"
gh auth status >/dev/null 2>&1 || echo "not logged in"
```

If `gh` is missing, stop and point to https://cli.github.com. If not logged in, ask the user to run
`gh auth login` (scopes `repo,read:org,user` let the audit see private repos and social accounts)
and wait.

## 1. Config

Read the user config, then use defaults for missing keys. Schema and defaults:
[references/config.md](references/config.md).

```bash
cfg="${GITHUB_MANAGER_HOME:-$HOME/.agents/github-manager}/config.json"
[ -f "$cfg" ] && cat "$cfg" || echo '{}'
```

## 2. Target

Priority: `--repo owner/name` > `--scope public|private|all` > the current directory's git remote
> ask the user and wait for an explicit answer. An explicit `--scope` always means account mode,
even inside a clone.

```bash
login=$(gh api user --jq .login)
# scope=public or private: add --visibility <scope>; scope=all: omit --visibility
# (gh accepts only public, private or internal)
gh repo list "$login" [--visibility <scope>] --limit 300 --no-archived \
  --json name,description,repositoryTopics,visibility,primaryLanguage,isFork,homepageUrl,defaultBranchRef,licenseInfo
```

`licenseInfo` gives `{key, name}`: `null` means no license, key `other` means GitHub couldn't
identify it (the API's `NOASSERTION`). For the SPDX id use
`gh api repos/<owner>/<repo> --jq '.license.spdx_id // "NONE"'`.

Forks are listed separately and only get the license check. Archived repos are skipped. The profile
repo (`<login>/<login>`) is audited as the profile README, not as a project.

## 3. Standards

| Area | Standard (relative to this skill) |
|---|---|
| Profile fields | `../profile-bio/references/profile-bio.md` |
| Profile README | `../profile-readme/references/profile-readme.md` |
| Description | `../gh-normalize/references/description.md` |
| Topics | `../gh-normalize/references/tags.md` |
| README | `../readme-standard/references/rules.md` |
| License | [references/license.md](references/license.md) |

Resolve these paths to absolute paths before passing them on.

## 4. Account check (account mode only, once)

If your environment supports subagents, delegate to `agents/account-analyzer.md` (the plugin's
agent, at `../../agents/account-analyzer.md` from this skill); otherwise read that file and follow
it inline. Pass both profile standard paths and the effective config.

## 5. Repo checks (one repo at a time)

Use the data fetched in step 2. For each repo, run these analyzers the same way: if your
environment supports subagents, delegate to them; otherwise read `../../agents/<name>` and follow
it inline. Pass the matching standard path and the config.

- `description-analyzer.md` → verdict + proposal
- `tag-analyzer.md` → family + add/remove
- `readme-analyzer.md` → README, mirrors, generated state
- license check from [references/license.md](references/license.md)

For large accounts (> 30 repos) check descriptions, topics and license for all repos from the
listing data, and run the README check only for public, non-fork repos unless the user asks for
more.

## 6. Report

Order: profile identity → public repos (description, topics, license) → public READMEs → private
repos.

```
GITHUB AUDIT  <login>  scope=<scope>  config=<path | defaults>

PROFILE
  blog: EMPTY (recommended) · social: 2 · profile README: PRESENT, generated (pnpm readme)

REPOS (n)
  repo              desc   topics          license      readme
  my-cli            PASS   WARN (+cli)     MIT          PRESENT
  web-app           FAIL   FAIL (0)        NONE         MISSING
  lib-x             WARN   PASS            NOASSERTION  PRESENT, mirror tr STALE

SUMMARY
  descriptions: X · topics: Y · license: Z · READMEs: W · profile: N
  next: gh-normalize (descriptions, topics) · readme-standard (READMEs) · profile-bio · profile-readme
```

Each FAIL or WARN states which rule it breaks. Don't hide findings behind assumptions; list them
all in this one report.

## Rules

- Read-only. Fixes go through `gh-normalize`, `profile-bio`, `profile-readme`, `readme-standard`
  or `release-workflow`, each with its own confirmation.
- Report only facts from the API and files. Never invent missing values.
- Keep findings generic: judge against the standards and the user's config, not against personal
  taste.
