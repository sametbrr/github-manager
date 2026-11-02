[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](../../LICENSE)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)

# readme-standard

Creates, audits and fixes project READMEs against one consistent structure, with badges detected from the project manifest and optional full translations (for example README.tr.md).

> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)

---

## Quick Start

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

```
> "audit readme"      # rule-by-rule checklist, writes nothing
> "create readme"     # README.md from project metadata (+ configured mirrors)
```

This skill ships inside the [github-manager](../../README.md) plugin. Its standalone repo is no longer the source of truth.

---

## Features

- **Four modes** — Create, Audit, Fix and Mirror Sync, triggered in English or Turkish
- **23 rules** — section order, exact heading names, badge patterns, callout forms, divider discipline
- **Project type detection** — `package.json`, `*.csproj`, `pyproject.toml`, `go.mod`, plugin manifests, MCP servers, web apps, `SKILL.md`
- **Conditional sections** — Uninstall, Troubleshooting, Limitations and others appear only when their signal is present
- **Optional mirrors** — any language via `readme.mirrors`; a Turkish heading table ships with the skill
- **Generated READMEs** — detects README generators and edits the source instead of the output

---

## Requirements

- Claude Code, Codex, or another [Agent Skills](https://agentskills.io) client
- A project manifest for auto-detection (otherwise the skill asks)

---

## Installation

```bash
# Claude Code
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
# Codex
codex plugin marketplace add sametbrr/skill-hub
codex plugin add github-manager@skill-hub
# Manual (any Agent Skills client): copy skills/readme-standard into ~/.claude/skills/ or ~/.agents/skills/
# (readme-standard has no sibling references, so it works when copied alone)
```

---

## Usage

| Mode | Trigger examples | What happens |
|---|---|---|
| **Create** | "create readme", "readme oluştur" | Generates README.md (and each configured mirror) from templates and detected metadata |
| **Audit** | "audit readme", "readme kontrol et" | Prints ✅/❌/⚠️ per rule with line references; writes nothing |
| **Fix** | "fix readme", "readme düzelt" | Rewrites existing README(s) to match the standard after confirmation |
| **Mirror Sync** | "sync mirrors", "tr readme güncelle" | Regenerates mirrors only, from the current README.md |

Mirrors and badges are set in `~/.agents/github-manager/config.json` (`readme.mirrors`, `readme.badges`, `readme.extraSections`); see [SKILL.md](SKILL.md). Full rules: [references/rules.md](references/rules.md).

---

## License

MIT — see [LICENSE](../../LICENSE).
