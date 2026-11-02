[![GitHub release](https://img.shields.io/github/v/release/sametbrr/github-manager?display_name=tag&sort=semver)](https://github.com/sametbrr/github-manager/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)

[Quick Start](#quick-start) • [Installation](#installation) • [Usage](#usage) • [Configuration](#configuration) • [Troubleshooting](#troubleshooting) • [Contributing](#contributing)

# github-manager

Audit and strengthen any GitHub account: profile fields, profile README, repo descriptions, topics, license, project READMEs and release workflows. Read-only audit first, every write confirmed.

> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)

---

## Quick Start

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

```
> audit my public GitHub repos
```

You get a read-only report of what is missing or below standard; `gh-onboard` then fixes it stage by stage.

---

## Features

| | |
|---|---|
| **Read before write** | `gh-audit` changes nothing; every outward-facing change (repo edit, `PATCH /user`, commit, push) waits for your approval |
| **Whole account or one repo** | Scans every repo in a scope, or the one given with `--repo` or the current directory's remote |
| **Generic standards** | Descriptions, topics, license and README rules follow common GitHub practice, not one person's taste |
| **Project families** | npm, NuGet, Python, Go CLI, MCP server, web app, private app, agent skill and Claude/Codex plugin repos each get fitting checks |
| **Profile** | Fills account fields and maintains the profile README, including generated ones (edits the source, runs the generator) |
| **READMEs** | The bundled `readme-standard` enforces one README structure, with optional translations in any language |
| **Releases** | Installs a tag-driven release workflow that publishes to npm, NuGet, PyPI, GoReleaser or the MCP Registry |
| **Configurable** | Mirrors, badges, description style, topic sets and profile sections live in one config file shared by Claude Code and Codex |
| **Nothing invented** | Missing profile values and descriptions are asked for, never guessed |

---

## Requirements

- Claude Code, Codex, or another [Agent Skills](https://agentskills.io) client
- [GitHub CLI](https://cli.github.com) (`gh`), logged in with `gh auth login -s repo,read:org,user`

---

## Installation

```bash
# Claude Code
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
# Codex
codex plugin marketplace add sametbrr/skill-hub
codex plugin add github-manager@skill-hub
# Manual (any Agent Skills client): copy skills/<skill> into ~/.claude/skills/ or ~/.agents/skills/
```

Manual install means copying the whole plugin layout, not single skill folders: `gh-audit`, `gh-onboard`, `gh-normalize` and `profile-readme` read sibling skills' standards (`../<skill>/references/`) and the analyzers in `../../agents/`. Keep `skills/` and `agents/` side by side under one parent folder and point your client at that `skills/` folder. Only `readme-standard`, `release-workflow` and `profile-bio` have no sibling references and work when copied alone.

---

## Usage

```text
/github-manager:gh-audit --scope public            # read-only report, writes nothing
/github-manager:gh-onboard --scope public          # guided session: audit, then fix stage by stage
/github-manager:gh-normalize --repo owner/name     # fix one repo's description and topics
/github-manager:profile-bio                        # fill account fields
/github-manager:profile-readme                     # create or refresh the profile README
/github-manager:release-workflow                   # add release.yml to the current repo
> "audit the README in this repo"                  # readme-standard, audit mode
> "fix readme"                                     # readme-standard, fix mode
```

In Codex, invoke the same skills with `$gh-audit`, `$gh-onboard` and so on.

| Skill | What it does | Writes |
|---|---|---|
| `gh-audit` | Read-only health report for the account or one repo | nothing |
| `gh-onboard` | Guided end-to-end session: audit, then fix stage by stage | via the skills below |
| `profile-bio` | Fills account fields (name, bio, blog, location, company, social accounts) | `PATCH /user` after approval |
| `profile-readme` | Creates or updates the `<login>/<login>` profile README; handles generated READMEs | local files; commit/push after approval |
| `gh-normalize` | Fixes repo descriptions and topics, one repo or a scope | `gh repo edit` after approval |
| `readme-standard` | Creates, audits and fixes project READMEs and their translations | local files after approval |
| `release-workflow` | Installs a project-type-aware `release.yml` | one local file, never commits |

Targets:

- `--scope public|private|all`: which repos to work on (asked if omitted)
- `--repo owner/name`, or the current directory's remote: single-repo mode
- `profile-bio` and `profile-readme` act on the account once

`gh-onboard`, `gh-normalize`, `profile-bio`, `profile-readme` and `release-workflow` run only when you invoke them explicitly. Read-only analyzer agents (`account-analyzer`, `description-analyzer`, `tag-analyzer`, `readme-analyzer`) do the checking; in hosts without subagents the skills follow them inline.

---

## Configuration

Optional. Location: `$GITHUB_MANAGER_HOME/config.json`, else `~/.agents/github-manager/config.json` (shared by Claude Code and Codex).

| Key | Default | Meaning |
|---|---|---|
| `language` | `"en"` | language of READMEs, descriptions and profile README |
| `readme.mirrors` | `[]` | extra full README translations, e.g. `["tr"]` → `README.tr.md` |
| `readme.badges` | `"auto"` | `auto`, `minimal` or `none` |
| `readme.extraSections` | `[]` | project-specific sections, placed after Troubleshooting and before Contributing |
| `description.maxLength` | `160` | description length limit |
| `description.trailingPeriod` | `"optional"` | `required`, `forbidden` or `optional` |
| `description.forms` | `["artifact", "imperative"]` | accepted description grammars |
| `topics.min` | `3` | minimum topics on public repos |
| `topics.core` | `{}` | per-family override of the suggested core topics |
| `topics.always` | `[]` | topics suggested for every repo |
| `topics.agentHosts` | `["claude-code", "codex"]` | host topics for agent skills and plugins that support them |
| `profile.mirrors` | `[]` | profile README translations |
| `profile.sections` | `["intro", "about", "projects", "contact"]` | profile README sections, in order |
| `profile.projectSources` | `[]` | extra files or URLs listing projects with canonical descriptions |
| `profile.stats` | `false` | add third-party stats cards to the profile README |

Example, English READMEs with a Turkish mirror (a heading table for Turkish ships with the plugin):

```json
{ "readme": { "mirrors": ["tr"] }, "profile": { "mirrors": ["tr"] } }
```

Full reference: [skills/gh-audit/references/config.md](skills/gh-audit/references/config.md).

---

## Project Structure

```
github-manager/
├── .claude-plugin/plugin.json   → Claude Code manifest (version source of truth)
├── .codex-plugin/plugin.json    → Codex manifest
├── agents/                      → read-only analyzer subagents
└── skills/
    ├── gh-audit/                → audit + config and license references
    ├── gh-normalize/            → description and topic standards
    ├── gh-onboard/
    ├── profile-bio/             → profile fields standard
    ├── profile-readme/          → profile README standard
    ├── readme-standard/         → README rules, templates, Turkish table
    └── release-workflow/        → release templates + add-release-workflow.sh
```

---

## Troubleshooting

**`gh: command not found` or "not logged in"** — install the [GitHub CLI](https://cli.github.com), then run `gh auth login -s repo,read:org,user`.

**Private repos or social accounts are missing from the audit** — the token lacks scopes. Check with `gh auth status` and add them with `gh auth refresh -s repo,read:org,user`.

**`profile-bio` fails with HTTP 404 or 403 on `PATCH /user`** — the `user` scope is missing: `gh auth refresh -s user`.

---

## Contributing

- Questions and ideas: [Discussions](https://github.com/sametbrr/github-manager/discussions)
- Bugs: [issue tracker](https://github.com/sametbrr/github-manager/issues)
- Pull requests: read the [contribution guide](https://github.com/sametbrr/.github/blob/main/CONTRIBUTING.md) first
- Security reports: follow the [security policy](https://github.com/sametbrr/github-manager/security/policy), not a public issue

---

## License

MIT — see [LICENSE](LICENSE).
