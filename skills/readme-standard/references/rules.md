# Rules Reference

Full detail for each rule. Use during Audit and Fix modes.

---

## Rule 1 — No inline bilingual content

Never write `**EN:** ... **TR:** ...` patterns within a single file. Each file is one language only.

❌ Wrong:
```markdown
**EN:** This library auto-registers services.
**TR:** Bu kütüphane servisleri otomatik kaydeder.
```

✅ Correct: README.md contains only EN prose; README.tr.md contains only TR prose.

---

## Rule 2 — Quick Start is always first

The first `##` section after the description and TR reference link must be `## Quick Start`.

❌ Wrong order:
```markdown
## Features
## Installation
## Quick Start
```

✅ Correct order:
```markdown
## Quick Start
## Features
## Requirements
## Installation
## Usage
...
## License
```

---

## Rule 3 — Quick Start content

Must be copy-paste ready. Maximum 15 lines. Must include an install command and a minimal working example.

❌ Wrong — reads like a tutorial, no copy-paste example:
```markdown
## Quick Start
First you need to install the package. Make sure you have .NET 8 installed.
Then create a new project and add the package...
```

✅ Correct:
```markdown
## Quick Start

```bash
dotnet add package AssemblyServiceRegistrar
```

```csharp
builder.Services.AddServicesFromAssembly(Assembly.GetExecutingAssembly());
```

That's it — no manual registration needed.
```

---

## Rule 4 — TR reference link in README.md

Appears immediately after the one-line description, before the first `---` divider. Exact format, no variation.

✅ Correct:
```markdown
> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)
```

❌ Wrong:
```markdown
[Türkçe](README.tr.md)
**TR:** Türkçe için README.tr.md dosyasına bakın.
> Turkish: [README.tr.md](README.tr.md)
🇹🇷 [README.tr.md](README.tr.md)
```

---

## Rule 5 — EN reference link in README.tr.md

Appears immediately after the one-line Turkish description. Exact format:

✅ Correct:
```markdown
> 🇬🇧 For English see [README.md](README.md)
```

---

## Rule 6 — Code blocks are never translated

Code, shell commands, JSON, XML, YAML — all stay in English in both files.

❌ Wrong in README.tr.md:
```csharp
// Servis arayüzünüzü bir lifetime marker ile işaretleyin
public interface IKullaniciServisi : IScopedService { }
```

✅ Correct in README.tr.md:
```csharp
// Mark your interfaces with a lifetime marker
public interface IUserService : IScopedService { }
```

Note: inline comments inside code are debatable — keep English for consistency unless the user explicitly prefers Turkish comments.

---

## Rule 7 — Tables are monolingual

No bilingual columns anywhere. README.md tables → EN only. README.tr.md tables → TR only.

❌ Wrong (bilingual columns):
```markdown
| Field / Alan | Default / Varsayılan | Description / Açıklama |
```

✅ Correct in README.md:
```markdown
| Field | Default | Description |
```

✅ Correct in README.tr.md:
```markdown
| Alan | Varsayılan | Açıklama |
```

---

## Rule 8 — Section heading emojis

Only add emojis to section headings if the project already uses them consistently throughout. Mixed usage (some sections with, some without) is a failure.

❌ Wrong — inconsistent:
```markdown
## 🚀 Quick Start
## Features
## 📋 Requirements
## Installation
```

✅ Correct — consistent (no emojis):
```markdown
## Quick Start
## Features
## Requirements
```

✅ Correct — consistent (all with emojis):
```markdown
## 🚀 Quick Start
## ✨ Features
## 📋 Requirements
```

---

## Rule 9 — License section format

Always the last `##` section. Always exactly one body line.

✅ Correct:
```markdown
## License

MIT — see [LICENSE](LICENSE).
```

For `.txt` extension: `MIT — see [LICENSE.txt](LICENSE.txt).`
For non-MIT licenses: replace `MIT` with the actual SPDX identifier.

❌ Wrong:
```markdown
## 📄 License | Lisans

**EN:** MIT — see [LICENSE.txt](LICENSE.txt).

**TR:** MIT — bkz. [LICENSE.txt](LICENSE.txt).
```

---

## Rule 10 — Five core sections are mandatory

Every README.md must contain ALL of these sections, in this order, before any project-specific sections:

1. `## Quick Start`
2. `## Features`
3. `## Requirements`
4. `## Installation`
5. `## Usage`

These are non-negotiable regardless of project type (package, skill, tool, library). If a section's content is brief (e.g., Installation = one git clone line), it still appears as a named section.

❌ Wrong — missing Requirements and Installation:
```markdown
## Quick Start
## Features
## Usage
## License
```

✅ Correct:
```markdown
## Quick Start
## Features
## Requirements
## Installation
## Usage
## License
```

---

## Rule 11 — Section names must match exactly

The five core sections must use these exact English names (README.md) and Turkish names (README.tr.md). No variations, synonyms, or creative titles.

| README.md | README.tr.md |
|---|---|
| `## Quick Start` | `## Hızlı Başlangıç` |
| `## Features` | `## Özellikler` |
| `## Requirements` | `## Gereksinimler` |
| `## Installation` | `## Kurulum` |
| `## Usage` | `## Kullanım` |
| `## License` | `## Lisans` |

❌ Wrong — section name variations:
```markdown
## What it does          ← must be "Features"
## What does this do?    ← must be "Features"
## Getting started       ← must be "Quick Start"
## How to install        ← must be "Installation"
## Available tools       ← must be "Usage"
```

**Approved aliases** — the ONLY permitted deviations, each tied to a condition:

| Core name | Approved alias | Condition | TR alias |
|---|---|---|---|
| `## Usage` | `## Commands` | CLI/plugin project using the per-command template (Rule 21) | `## Komutlar` |
| `## Quick Start` | `## Get Started` | Getting running requires ≥4 sequential numbered steps (see below) | `## Başlarken` |

**"Get Started" trigger, concretely:** use the alias only when the shortest
path to a working setup cannot be expressed as install command + one example
(Rule 3) and instead needs **4 or more ordered steps** (e.g. install → authenticate
→ configure → verify). The section body is then a numbered list, each step with
its own command block, and may exceed Rule 3's 15-line cap. If the steps fit in
3 or fewer, keep `## Quick Start`.

✅ Qualifies for `## Get Started`:
```markdown
1. Install the CLI: `npm i -g tool`
2. Authenticate: `tool login` (opens browser)
3. Create a config: `tool init`
4. Verify: `tool status`
```

Any other variation is still a FAIL. An alias replaces its core name everywhere
(nav line, TR mirror) — never both names in one file.

---

## Rule 12 — Horizontal dividers between all sections

Every `##` section must be preceded by a `---` horizontal rule (with a blank line above and below). This applies to all sections including project-specific ones.

❌ Wrong — missing dividers:
```markdown
## Features

- Feature one

## Requirements

- Node.js
```

✅ Correct:
```markdown
## Features

- Feature one

---

## Requirements

- Node.js
```

---

## Rule 13 — Description is plain text, one line

The project description (between the `# Title` and the TR reference link) must be:
- Plain text — no `>` blockquote formatting
- Exactly one line — no multi-paragraph descriptions

❌ Wrong — blockquote:
```markdown
> A Claude Code skill for building a wiki...
```

❌ Wrong — two paragraphs:
```markdown
An Agent Skill that turns any rough idea into an expert prompt.

Purpose-built for Claude. Follows Anthropic's official prompting practices...
```

✅ Correct:
```markdown
An Agent Skill that turns any rough idea into a domain-classified, quality-reviewed expert prompt.
```

---

## Rule 14 — Nav line for long READMEs

If the README has ≥8 `##` sections OR ≥200 lines, add a single anchor nav line directly below the badges. Max 6 links, `•` separator, links only to `##` sections.

✅ Correct:
```markdown
[Quick Start](#quick-start) • [Installation](#installation) • [Usage](#usage) • [Troubleshooting](#troubleshooting)
```

❌ Wrong:
```markdown
## Table of Contents          ← no TOC section; use the nav line
- [Quick Start](#quick-start)
- [Installation](#installation)
```

In README.tr.md, anchors point to the Turkish heading slugs:
```markdown
[Hızlı Başlangıç](#hızlı-başlangıç) • [Kurulum](#kurulum) • [Kullanım](#kullanım)
```

---

## Rule 15 — Troubleshooting and Limitations patterns

**Troubleshooting** — short pattern (default): bold symptom, em-dash, one-paragraph solution.

✅ Correct:
```markdown
## Troubleshooting

**"command not found" after install** — open a new terminal so PATH changes take effect, or run `source ~/.zshrc`.

**Push fails with 401** — re-authenticate: `gh auth login`.
```

Long pattern (alternative — for complex multi-step fixes): `### Symptom` → `**Issue:**` → `**Solution:**`. Never mix the two patterns in one README.

**Limitations** — each constraint states what + why + workaround:

✅ Correct:
```markdown
## Limitations

Sessions are indexed by absolute path, so the same repo cloned to different
paths is treated as a different project.

**Workaround:** clone repos to the same path (e.g. `~/Projects/`) on every machine.
```

❌ Wrong — constraint with no workaround or reason:
```markdown
## Limitations

- Doesn't work across devices sometimes.
```

---

## Rule 16 — `<details>` only for secondary depth

Alternative install paths, per-provider instructions, methodology, and long reference tables go inside `<details>`. The primary path is never collapsed. `<summary>` text is bold; blank lines after `<summary>` and before `</details>` are required for markdown rendering.

✅ Correct:
```markdown
<details>
<summary><strong>Manual setup (alternative)</strong></summary>

```bash
npm install -g tool
```

</details>
```

❌ Wrong — primary path collapsed:
```markdown
<details>
<summary>Installation</summary>
...
</details>
```

In README.tr.md the `<summary>` text is translated; all other rules apply unchanged.

---

## Rule 17 — Conditional sections: omit when condition unmet

The conditional sections (value paragraph, Uninstall, Configuration, How It Works, Project Structure, Limitations, Troubleshooting, Contributing, Community, Documentation, footer — see SKILL.md **Conditional sections** for conditions and signals) are included only when their detection signal is present.

- Condition unmet → section is **absent**. Empty sections, "N/A" bodies, and placeholders are FAIL.
- User instruction overrides detection in both directions.
- Audit: section↔signal mismatches are ⚠️ WARN, never ❌ FAIL.
- README.tr.md contains exactly the same section set as README.md.

❌ Wrong:
```markdown
## Troubleshooting

N/A — no known issues yet.
```

✅ Correct: the `## Troubleshooting` section simply does not exist in that README.

---

## Rule 18 — Approved callouts only

Exactly three callout forms, all blockquote-bold:

```markdown
> **⚠️ Important:** critical security/trust warning — may appear directly below the description
> **Note:** contextual information
> **Heads up:** unexpected behavior / platform difference
```

TR equivalents: `> **⚠️ Önemli:**`, `> **Not:**`, `> **Dikkat:**`

❌ Wrong:
```markdown
**WARNING:** do not run as root
:::note
> NOTE - this is important
```

---

## Rule 19 — Features table at ≥7 features

≥7 features: 2-column table is mandatory. 4–6 features: table recommended, bullets acceptable. <4: bullets. Never mix both forms in one README.

✅ Correct (≥7 features):
```markdown
| | |
|---|---|
| **Cross-device sync** | Continue conversations on any laptop |
| **End-to-end encryption** | Files encrypted with age before upload |
```

✅ Correct (<7 features):
```markdown
- **Cross-device sync** — continue conversations on any laptop
- **End-to-end encryption** — files encrypted with age before upload
```

---

## Rule 20 — Value paragraph for published packages

Only when the project is a published package/product (npm/NuGet/PyPI badge generated, not `private`). One paragraph, ≤4 sentences, bold one-sentence claim as opener. Placed after the TR link, before the first `---`. Rule 13 still applies — this paragraph is *in addition to* the one-line description, never instead of it.

✅ Correct:
```markdown
An Agent Skill that enforces a consistent README structure.

> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)

**The only README tool with a built-in audit mode.** It detects your project
type, generates badges from metadata, and keeps an exact Turkish mirror in
sync — without you writing a single heading.

---
```

❌ Wrong — value paragraph replacing the one-line description, or >4 sentences.

---

## Rule 21 — CLI/plugin Usage: cheat sheet + per-command template

For CLI / plugin / skill projects, Usage (or its approved alias `Commands`) opens with a single cheat-sheet code block (every command, end-of-line comments), followed by `###` subsections only for commands needing explanation. Full template: [../assets/templates/usage-cli-command.tmpl](../assets/templates/usage-cli-command.tmpl)

Cheat-sheet conventions:

- **Order:** workflow order, not alphabetical — setup commands first, daily-use
  commands next, maintenance/destructive commands last.
- **Size:** list every public command up to **12**. Beyond 12, split the single
  block into grouped blocks with a comment header per group (`# Setup`,
  `# Daily use`, `# Maintenance`) — still one cheat sheet, never a prose list.
- Every command in a `###` subsection must also appear in the cheat sheet;
  the cheat sheet may contain commands that have no subsection.

✅ Correct:
````markdown
## Commands

```bash
tool init      # Set up configuration
tool push      # Upload changes
tool status    # Show pending changes
```

### `tool init`

Interactive setup wizard.

**What it does:**
1. Selects a storage provider
2. Verifies credentials

**Example:**
```bash
tool init
# Wizard will:
# - test the connection
# - write ~/.tool/config.yaml
```
````

❌ Wrong: prose-only Usage for a CLI ("First run the init command, then..."), or per-command sections without the cheat-sheet block.

---

## Rule 22 — Visual assets and hero block

Only if visual assets exist under `assets/` (never invent or reference missing images):

- **Banner**: first element of a centered hero block.
- **Demo GIF / screenshot**: centered, between Features and the section after it.
- **Hero block** order inside `<div align="center">`: banner? → `# Name` → `### tagline` → metric line? → badges → nav line → `</div>`. The TR link stays as the first line after the hero (Rule 4 unchanged).
- ASCII architecture diagram: optional inside How It Works, fenced code block (no language), ≤25 lines.

❌ Wrong: hero block without assets, mixed centered/uncentered header elements, diagram as an image when ASCII suffices.

---

## Rule 23 — Footer

Only for GitHub-hosted projects with README ≥200 lines. After License, as the file's last element:

```markdown
---

<div align="center">

[Report Bug](https://github.com/{user}/{repo}/issues) · [Request Feature](https://github.com/{user}/{repo}/issues)

</div>
```

TR mirror: `[Hata Bildir](...) · [Özellik İste](...)` (same URLs).

---

## Audit checklist output format

When running Audit mode, output exactly this structure:

```
README Standard Audit — <project-name>
======================================

README.md
  ✅ Rule 1: No inline bilingual content
  ❌ Rule 2: Quick Start is not the first section (found: Features → Quick Start)
  ✅ Rule 3: Quick Start is ≤15 lines and copy-paste ready
  ✅ Rule 4: TR reference link present and correctly formatted
  ✅ Rule 6: Code blocks not translated
  ⚠️ Rule 7: Table in "Configuration" section has bilingual columns
  ✅ Rule 8: Section heading emojis consistent (none)
  ✅ Rule 9: License section is last
  ✅ Rule 14: Nav line present (9 sections detected)
  ❌ Rule 18: Freeform callout at line 42 (`**WARNING:**`) — use approved callouts
  ⚠️ Rule 19: 8 features as bullets — 2-column table required at ≥7

Conditional sections
  ⚠️ Project installs globally (npm -g); 'Uninstall' section recommended
  ⚠️ 'Community' present but no community channel link detected

README.tr.md
  ❌ File missing

Summary: 3 failures, 4 warnings
```

Use ⚠️ WARN for issues that are stylistic but not critical (e.g., inconsistent spacing). Use ❌ FAIL for rule violations that should be fixed.
