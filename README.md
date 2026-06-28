# github-manager

Claude Code plugin that audits and fixes a GitHub account end-to-end — profile fields, profile README, repo descriptions, topics and project READMEs, interactively and per chosen scope.

🌐 [Türkçe için tıklayın](README.tr.md)

## What it does

Point it at any authenticated GitHub account. It scans the account top to bottom,
reports what's missing or off-standard, and fixes it interactively — asking where it
can't infer, proposing where it can. Works on the **whole account** or a **single repo**.

## Components

**Skills**
- `gh-onboard` — interactive end-to-end orchestrator (audit → fix, stage by stage)
- `gh-audit` — read-only account health report (writes nothing)
- `profile-bio` — fill account fields (name, bio, company, location, blog, social) via the API
- `profile-readme` — generate/maintain the `<login>/<login>` profile README + Turkish mirror
- `gh-normalize` — fill and standardize repo descriptions and topics (single repo or batch)
- `readme-standard` — enforce a consistent README.md + README.tr.md structure
- `release-workflow` — install a project-type-aware auto-release GitHub Actions workflow (single local repo)

**Agents** (read-only analyzers): `account-analyzer`, `description-analyzer`, `tag-analyzer`, `readme-analyzer`

**Standards** (canonical rules): `STANDARDS/{description,tags,profile-bio,profile-readme}.md`

## Scope & target

- `--scope public|private|all` — which repos to operate on (asks if omitted)
- `--repo owner/name` or the current directory's remote — single-repo mode
- Account-level skills (`profile-bio`, `profile-readme`) act on the account once

## Auth

First run requests full scope once: `gh auth login --web -s repo,read:org,user`.
After that you only pick `public/private/all` per run.

## Safety

Read before write. Every outward-facing change (repo edit, `PATCH /user`, push) is confirmed.
Identity values are never invented — missing fields are asked, not guessed.

## License

MIT
