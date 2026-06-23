[![GitHub release](https://img.shields.io/github/v/release/sametbrr/readme-standard?display_name=tag&sort=semver)](https://github.com/sametbrr/readme-standard/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)

# README Standard

A Claude Code skill that enforces a consistent README.md + README.tr.md structure across projects — create, audit, fix, and keep the Turkish mirror in sync.

> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)

---

## Quick Start

```bash
git clone https://github.com/sametbrr/readme-standard ~/.claude/skills/readme-standard
```

```
> "create readme"     # generates README.md + README.tr.md from project metadata
> "audit readme"      # prints a rule-by-rule checklist, writes nothing
```

That's it — project type, name, version, and badges are detected automatically.

---

## Features

- **Four modes** — Create, Audit, Fix, and TR Sync, triggered by natural language in Turkish or English
- **23 enforced rules** — section order, exact heading names, badge patterns, callout forms, divider discipline
- **Project type detection** — reads `package.json` / `.csproj` / `pyproject.toml` / `SKILL.md` for badges and metadata, with monorepo tiebreakers
- **Conditional sections** — Uninstall, Troubleshooting, Limitations and others appear only when their detection signal is present
- **Exact Turkish mirror** — README.tr.md with identical badges, translated prose, and untranslated code blocks

---

## Requirements

- Claude Code (or any [agentskills.io](https://agentskills.io)-compatible agent)
- A project with a manifest (`package.json`, `.csproj`, `pyproject.toml`, or `SKILL.md`) for auto-detection — otherwise the skill asks

---

## Installation

```bash
git clone https://github.com/sametbrr/readme-standard ~/.claude/skills/readme-standard
```

Start a new Claude Code session in the project whose README you want to manage.

---

## Usage

| Mode | Trigger examples | What happens |
|---|---|---|
| **Create** | "create readme", "readme oluştur" | Generates both README.md and README.tr.md from templates and detected metadata |
| **Audit** | "audit readme", "readme kontrol et" | Prints ✅/❌/⚠️ per rule with line references — writes no files |
| **Fix** | "fix readme", "readme düzelt" | Rewrites existing README(s) to match the standard, confirming before overwrite |
| **TR Sync** | "sync tr readme", "tr readme güncelle" | Regenerates README.tr.md only, from the current README.md |

The full rule set with correct/wrong examples lives in [references/rules.md](references/rules.md); badge markdown per project type in [references/badge-patterns.md](references/badge-patterns.md); heading and prose translations in [references/tr-translations.md](references/tr-translations.md).

---

## License

MIT — see [LICENSE](LICENSE).
