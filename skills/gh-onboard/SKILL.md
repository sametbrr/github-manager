---
name: gh-onboard
description: Guides a GitHub account from audit to fixes end to end, interactively and stage by stage, covering profile fields, profile README, repo descriptions and topics, project READMEs and release workflows, with every write confirmed. Use when the user wants to set up, clean up or strengthen their whole GitHub presence in one guided session.
disable-model-invocation: true
metadata:
  version: "1.0.0"
---

# gh-onboard

Interactive orchestrator for a whole GitHub account. Runs the other skills of this plugin in a
fixed order; every write stage is opt-in and confirmed.

Run only when the user explicitly asks.

## 0. Preflight

```bash
command -v gh >/dev/null || echo "gh CLI missing: https://cli.github.com"
gh auth status >/dev/null 2>&1 || echo "not logged in"
```

If `gh` is missing, point to https://cli.github.com and stop. If not logged in, ask the user to run
`gh auth login -s repo,read:org,user` and wait.

## 1. Preferences

Read the config (`${GITHUB_MANAGER_HOME:-$HOME/.agents/github-manager}/config.json`). If none
exists, show the defaults from `../gh-audit/references/config.md` and ask whether they fit. Typical
questions: README mirrors in another language? Description period style? Profile README sections?
If the user wants changes, show the JSON and offer to save it to `~/.agents/github-manager/` (or
`$GITHUB_MANAGER_HOME`) after an explicit yes. If writing there is blocked, say so and let the user
save it.

## 2. Scope

If `--scope public|private|all` wasn't given, ask the user and wait for an explicit answer.

## 3. Audit (read-only)

Follow `../gh-audit/SKILL.md` with `--scope <chosen scope>` (account mode, even when run inside a
clone). Show the report and ask which stages to run. Pass the same `--scope` to `gh-normalize`.

## 4. Stages (each optional, in this order)

| Stage | Skill | Runs when |
|---|---|---|
| Profile fields | `../profile-bio/SKILL.md` | the audit lists empty or weak fields |
| Profile README | `../profile-readme/SKILL.md` | missing, weak or out of date |
| Repo metadata | `../gh-normalize/SKILL.md` | description or topic findings |
| Project READMEs | `../readme-standard/SKILL.md` (audit, then create or fix per repo) | README findings; needs a local clone per repo |
| Release workflows | `../release-workflow/SKILL.md` | the user wants automated releases for chosen repos; needs a local clone |
| License | `../gh-audit/references/license.md` | public repos without a recognised license; only report and ask |

Before each stage, say what it will change and ask whether to run it, skip it, or stop.

## 5. Wrap-up

List what changed, what was skipped, and the manual steps the API can't do (pronouns, PRO badge,
local time, pinned repos, avatar). Remind the user that local file changes (READMEs, workflows)
are not committed until they approve.

## Flow rules

- Order: identity → public repo metadata → public READMEs → releases → private repos (optional).
- Read first, write later. No outward-facing step (API write, commit, push) without explicit
  approval.
- Works for any account: read the login from `gh api user`; nothing about a specific user is
  hardcoded.
