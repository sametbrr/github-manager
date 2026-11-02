# Rules Reference

Full detail for each rule. Use during Audit and Fix modes.

**Terms.** The *primary README* is `README.md`, written in the configured `language` (default
English). A *mirror* is a full translation `README.<code>.md` for each language code in
`readme.mirrors` (default: none). Rules marked **(mirrors)** apply only when at least one mirror is
configured or already exists. The examples use a Turkish mirror (`README.tr.md`), which ships with
a heading table in [tr-translations.md](tr-translations.md); other languages follow the same
pattern.

---

## Rule 1 — No inline bilingual content

Never write `**EN:** ... **TR:** ...` patterns within a single file. Each file is one language
only. This applies with or without mirrors: a README never mixes two languages.

❌ Wrong:
```markdown
**EN:** This library auto-registers services.
**TR:** Bu kütüphane servisleri otomatik kaydeder.
```

✅ Correct: README.md contains only primary-language prose; each mirror contains only its own language.

---

## Rule 2 — Quick Start is always first

The first `##` section after the description (and the mirror link line, if any) must be `## Quick Start`.

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
npm install acme-widget
```

```js
import { widget } from "acme-widget";
widget.render("#app");
```

That's it — no configuration needed.
```

---

## Rule 4 — Mirror link line in README.md (mirrors)

Only when mirrors exist. One blockquote line immediately after the one-line description, before
the first `---` divider, linking every mirror. No line at all when there are no mirrors.

Format per language: use the "link from primary" line of that language's translation table if one
exists, otherwise the generic form. Several mirrors share one line, separated by ` · `.

✅ Correct (Turkish, from [tr-translations.md](tr-translations.md)):
```markdown
> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)
```

✅ Correct (generic, several mirrors):
```markdown
> 🌐 [Türkçe](README.tr.md) · [Deutsch](README.de.md)
```

❌ Wrong:
```markdown
[Türkçe](README.tr.md)                        ← not a blockquote, placed elsewhere
**TR:** Türkçe için README.tr.md dosyasına bakın.
> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)   ← in a README with no README.tr.md
```

---

## Rule 5 — Back link in each mirror (mirrors)

Immediately after the translated one-line description of a mirror, link back to the primary
README. Use the table's "link back" line or the generic `> 🌐 [English](README.md)`.

✅ Correct (Turkish mirror):
```markdown
> 🇬🇧 For English see [README.md](README.md)
```

---

## Rule 6 — Code blocks: only comments are translated (mirrors)

In a mirror, a code block keeps everything that a reader copies or compares byte-identical to the
primary README: commands, flags, paths, placeholders (`<repo-dir>`, `{{name}}`), code, JSON/YAML
keys and values, prompts and trigger phrases, slash invocations, directory trees and sample output.
Only comments (`# ...`, `// ...`, `-- ...`, `<!-- ... -->`) may be translated, and they **should**
be, so the mirror reads in one language.

✅ Correct in README.tr.md:
```bash
npm install acme-widget        # paketi kur
acme-widget init --dir ./app   # yapılandırma dosyasını oluştur
```

❌ Wrong in README.tr.md (command, flag and path translated):
```bash
npm kur acme-widget            # paketi kur
acme-widget baslat --dizin ./uygulama
```

❌ Wrong in README.tr.md (prompt translated; the agent is triggered by the English phrase shown
in README.md, and both files must show the same input):
```
> README'yi denetle
```
✅ Correct: `> audit readme` stays as is; a translated comment may follow it.

---

## Rule 7 — Tables are monolingual

No bilingual columns anywhere. README.md tables use the primary language only; each mirror's tables use its own language only.

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
For other licenses: use the detected SPDX identifier (`Apache-2.0 — see [LICENSE](LICENSE).`).
No license file: don't invent one. Write the section only after the user names a license, and
report the missing file (Audit: ❌ FAIL for a public repo).

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

These are non-negotiable regardless of project type (package, skill, tool, library, app). If a section's content is brief (e.g., Installation = one git clone line), it still appears as a named section.

**Project-specific sections.** Sections that are not in the core or conditional lists (for example
`## API`, `## Benchmarks`, `## Deployment`, `## Environment Variables` for a web app, `## MCP Tools`
for an MCP server) go in one slot: after Troubleshooting, before Contributing. When Troubleshooting
or Contributing is absent, the placement rule of the conditional sections applies (after the nearest
present section that precedes the slot). Names listed in `readme.extraSections` are always accepted there. Others are accepted
when they hold project-specific content; Audit reports them as ⚠️ WARN only if a core or
conditional name would fit (Rule 11).

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

The core sections must use these exact names in README.md, and the translated names from the
language's translation table in each mirror. No variations, synonyms, or creative titles.

| README.md | README.tr.md (example mirror) |
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

| Core name | Approved alias | Condition | TR alias (mirror) |
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
(nav line, mirrors) — never both names in one file.

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

The project description (between the `# Title` and the mirror link line or the first `---`) must be:
- Plain text — no `>` blockquote formatting
- Exactly one line — no multi-paragraph descriptions

❌ Wrong — blockquote:
```markdown
> A small library for rendering widgets...
```

❌ Wrong — two paragraphs:
```markdown
A library for rendering widgets.

Built for modern browsers. Follows the latest web standards...
```

✅ Correct:
```markdown
A dependency-free library that renders accessible widgets — 12 components, 4 KB gzipped.
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

In a mirror, anchors point to that language's heading slugs (Turkish example):
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

The cache is keyed by absolute path, so the same project in two folders is
indexed twice.

**Workaround:** keep projects at the same path on every machine, or run `widget cache clear`.
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

In a mirror the `<summary>` text is translated; all other rules apply unchanged.

---

## Rule 17 — Conditional sections: omit when condition unmet

The conditional sections (value paragraph, Uninstall, Configuration, How It Works, Project Structure, Limitations, Troubleshooting, Contributing, Community, Documentation, footer — see SKILL.md **Conditional sections** for conditions and signals) are included only when their detection signal is present.

- Condition unmet → section is **absent**. Empty sections, "N/A" bodies, and placeholders are FAIL.
- User instruction overrides detection in both directions.
- Audit: section↔signal mismatches are ⚠️ WARN, never ❌ FAIL.
- Every mirror contains exactly the same section set as README.md.

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

Mirror equivalents come from the translation table (Turkish: `> **⚠️ Önemli:**`, `> **Not:**`, `> **Dikkat:**`).

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
| **Zero dependencies** | Ships as a single 4 KB module |
| **Accessible** | Every component passes WCAG 2.2 AA checks |
```

✅ Correct (<7 features):
```markdown
- **Zero dependencies** — ships as a single 4 KB module
- **Accessible** — every component passes WCAG 2.2 AA checks
```

---

## Rule 20 — Value paragraph for published packages

Only when the project is a published package/product (npm/NuGet/PyPI badge generated, not `private`). One paragraph, ≤4 sentences, bold one-sentence claim as opener. Placed after the description (and the mirror link line, if any), before the first `---`. Rule 13 still applies — this paragraph is *in addition to* the one-line description, never instead of it.

✅ Correct:
```markdown
A dependency-free library that renders accessible widgets — 12 components, 4 KB gzipped.

> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)

**Accessible widgets without a framework.** Drop one 4 KB module into any page
and get keyboard support, screen-reader labels and theming out of the box.

---
```

❌ Wrong — value paragraph replacing the one-line description, or >4 sentences.

---

## Rule 21 — CLI/plugin Usage: cheat sheet + per-command template

For CLI / plugin / skill projects, Usage (or its approved alias `Commands`) opens with a single cheat-sheet code block (every command, end-of-line comments), followed by `###` subsections only for commands needing explanation. Full template: [../assets/templates/usage-cli-command.tmpl](../assets/templates/usage-cli-command.tmpl)

**Agent skills and plugins** that are triggered by natural language or slash commands use the same
rule with their own "commands": the cheat sheet is one code block of example trigger phrases and
slash or `$skill` invocations, one per line, with a short end-of-line comment. These are inputs,
so mirrors never translate them (Rule 6); only the comments are translated.

✅ Correct (agent plugin):
````markdown
## Usage

```text
/acme-docs:audit              # read-only check, writes nothing
/acme-docs:fix --dry-run      # preview fixes
> "audit the docs in this repo"
> "fix the changelog"
```
````

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
- **Hero block** order inside `<div align="center">`: banner? → `# Name` → `### tagline` → metric line? → badges → nav line → `</div>`. The mirror link line, if any, stays as the first line after the hero (Rule 4 unchanged).
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

Mirrors translate the link text, same URLs (Turkish: `[Hata Bildir](...) · [Özellik İste](...)`).

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
  ✅ Rule 4: Mirror link line present and correctly formatted (mirrors: tr)
  ✅ Rule 6: Code blocks identical to README.md except translated comments
  ⚠️ Rule 7: Table in "Configuration" section has bilingual columns
  ✅ Rule 8: Section heading emojis consistent (none)
  ✅ Rule 9: License section is last
  ✅ Rule 14: Nav line present (9 sections detected)
  ❌ Rule 18: Freeform callout at line 42 (`**WARNING:**`) — use approved callouts
  ⚠️ Rule 19: 8 features as bullets — 2-column table required at ≥7

Conditional sections
  ⚠️ Project installs globally (npm -g); 'Uninstall' section recommended
  ⚠️ 'Community' present but no community channel link detected

README.tr.md   (configured mirror)
  ❌ File missing

Summary: 3 failures, 4 warnings
```

Use ⚠️ WARN for issues that are stylistic but not critical (e.g., inconsistent spacing). Use ❌ FAIL for rule violations that should be fixed.
