[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-blue)](https://github.com/sametbrr/skill-hub)

# github-manager

Claude Code plugin that audits and fixes a GitHub account end-to-end — profile fields, profile README, repo descriptions, topics and project READMEs, interactively and per chosen scope.

> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)

---

## Quick Start

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

```
/gh-audit --scope public
```

That's it — you get a read-only report of what is missing or off-standard; `/gh-onboard` then fixes it stage by stage.

---

## Features

- **Whole account or one repo** — scans every repo in a scope, or the one given with `--repo` or the current directory's remote
- **Read before write** — `gh-audit` changes nothing; every outward-facing change (repo edit, `PATCH /user`, push) is confirmed first
- **Profile** — fills account fields (name, bio, company, location, blog, social) and maintains the profile README with its Turkish mirror
- **Repo metadata** — standardizes descriptions and topics, one repo or in batch
- **READMEs** — enforces a consistent README.md + README.tr.md structure through the bundled `readme-standard`
- **Releases** — installs a project-type-aware auto-release GitHub Actions workflow
- **No invented identity** — missing profile values are asked for, never guessed

---

## Requirements

- Claude Code
- [GitHub CLI](https://cli.github.com) (`gh`), authenticated once with `gh auth login --web -s repo,read:org,user`

---

## Installation

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

The first run asks for the full `gh` scope once; after that you only pick `public`, `private` or `all` per run.

---

## Usage

| Skill | What it does |
|---|---|
| `gh-onboard` | Interactive end-to-end orchestrator: audit, then fix stage by stage |
| `gh-audit` | Read-only account health report (writes nothing) |
| `profile-bio` | Fill account fields (name, bio, company, location, blog, social) through the API |
| `profile-readme` | Generate and maintain the `<login>/<login>` profile README and its Turkish mirror |
| `gh-normalize` | Fill and standardize repo descriptions and topics (single repo or batch) |
| `readme-standard` | Enforce a consistent README.md + README.tr.md structure |
| `release-workflow` | Install a project-type-aware auto-release workflow (single local repo) |

Targets:

- `--scope public|private|all` — which repos to operate on (asks if omitted)
- `--repo owner/name`, or the current directory's remote — single-repo mode
- Account-level skills (`profile-bio`, `profile-readme`) act on the account once

Read-only analyzer agents do the checking: `account-analyzer`, `description-analyzer`, `tag-analyzer`, `readme-analyzer`. The rules they check against live in `STANDARDS/` (`description`, `tags`, `profile-bio`, `profile-readme`).

---

## License

MIT — see [LICENSE](LICENSE).
