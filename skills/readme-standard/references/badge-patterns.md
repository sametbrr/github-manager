# Badge Patterns

Exact shields.io badge markdown per project type. Replace `{username}`, `{repo}`, `{package-name}` with actual values extracted during project type detection.

`readme.badges` in the config picks the set: `auto` (default, the per-type block below), `minimal`
(license + GitHub release only), `none` (no badge line). The license badge always shows the
detected SPDX id; with no recognised license, omit it rather than guess.

---

## NuGet Package

```markdown
[![NuGet](https://img.shields.io/nuget/v/{package-name}.svg)](https://www.nuget.org/packages/{package-name})
[![Downloads](https://img.shields.io/nuget/dt/{package-name}.svg)](https://www.nuget.org/packages/{package-name})
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE.txt)
```

**Metadata source:** `*.csproj`

| Need | Look for |
|---|---|
| Package name | `<PackageId>` → fallback `<AssemblyName>` → fallback: directory name |
| Version | `<Version>` |
| Description | `<Description>` |
| License file | `<PackageLicenseExpression>` or `LICENSE.txt` in root |

---

## npm Package

```markdown
[![npm version](https://badge.fury.io/js/{package-name}.svg)](https://badge.fury.io/js/{package-name})
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
```

**Metadata source:** `package.json`

| Need | Look for |
|---|---|
| Package name | `name` field |
| Version | `version` field |
| Description | `description` field |
| GitHub username | Parse from `repository.url` |

Scoped packages (`@scope/name`): encode the `@` and `/` in the badge URL:
`@myorg/pkg` → `%40myorg%2Fpkg`

---

## Python Package

```markdown
[![PyPI](https://img.shields.io/pypi/v/{package-name}.svg)](https://pypi.org/project/{package-name}/)
[![Python](https://img.shields.io/pypi/pyversions/{package-name}.svg)](https://pypi.org/project/{package-name}/)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
```

**Metadata source:** `pyproject.toml` (`[project] name`, `version`, `description`, `license`)

---

## Go Module / Go CLI

```markdown
[![Go Reference](https://pkg.go.dev/badge/{module-path}.svg)](https://pkg.go.dev/{module-path})
[![GitHub release](https://img.shields.io/github/v/release/{username}/{repo}?display_name=tag&sort=semver)](https://github.com/{username}/{repo}/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
```

**Metadata source:** `go.mod` `module` line (`{module-path}`, e.g. `github.com/{username}/{repo}`).
Add the npm badge too when the binary is also published as an npm wrapper.

---

## MCP Server

Use the badge block of the package registry it ships through (npm or PyPI) plus the license badge.
No separate "MCP" badge unless the server is listed in the official MCP Registry, then:

```markdown
[![MCP Registry](https://img.shields.io/badge/MCP%20Registry-listed-blue)](https://registry.modelcontextprotocol.io)
```

---

## Agent Skill / Agent Plugin

Only for repos that ship a `SKILL.md` or a plugin manifest. A plain CLI tool uses the Generic
block (plus its registry badge if published); it never gets the agentskills.io badge.

```markdown
[![GitHub release](https://img.shields.io/github/v/release/{username}/{repo}?display_name=tag&sort=semver)](https://github.com/{username}/{repo}/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)
```

The `agentskills.io` badge already covers multi-agent compatibility (Claude Code, GitHub Copilot VS Code, OpenAI Codex, Cursor, Gemini CLI). Do NOT add a separate "Works with Claude Code" badge — it implies exclusivity when the skill works with all agentskills.io-compatible tools.

**Metadata source:** `.claude-plugin/plugin.json` or `.codex-plugin/plugin.json` (plugins), else
`SKILL.md` frontmatter

| Need | Look for |
|---|---|
| Name | plugin `name`, else SKILL.md `name:` field |
| Description | `description:` field |
| Username/repo | `git remote get-url origin` |

---

## Generic Library / Tool

```markdown
[![GitHub release](https://img.shields.io/github/v/release/{username}/{repo}?display_name=tag&sort=semver)](https://github.com/{username}/{repo}/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
```

**Metadata source:** directory name + `git remote get-url origin`

---

## Anchor-linked badges (optional)

A badge may link to a section **inside the README** instead of an external URL — useful for platform/compatibility badges that have a detail section:

```markdown
[![Windows](https://img.shields.io/badge/Windows-supported-blue.svg)](#requirements)
[![macOS](https://img.shields.io/badge/macOS-supported-blue.svg)](#requirements)
```

In a mirror the anchor points to that language's slug (Turkish: `(#gereksinimler)`).

---

## Badge wall layout (hero blocks only — Rule 22)

When a hero block is used, group badges into rows by purpose, one markdown line per row:

```markdown
Row 1 — identity:      version + downloads + license
Row 2 — platforms:     OS/runtime support (anchor-linked to Requirements)
Row 3 — compatibility: agentskills.io / framework / integration badges
```

Without a hero block, keep the single flat badge line (default).

---

## Optional third-party badges

Include only if the project actually has them — never fabricate:

| Badge | When |
|---|---|
| npm downloads (`img.shields.io/npm/dm/{package}`) | published npm package with meaningful traffic |
| Socket security (`badge.socket.dev/npm/package/{package}/{version}`) | npm package, security-sensitive audience |
| Docs badge linking to external docs site | Documentation conditional section is present |

Badge style is always shields.io flat (default style). Never use `style=for-the-badge` — it clashes with the flat badges generated from metadata.

---

## Getting username and repo from git

```bash
git remote get-url origin
# https://github.com/octocat/my-project.git   → username=octocat, repo=my-project
# git@github.com:octocat/my-project.git        → username=octocat, repo=my-project
```

Strip `.git` suffix. If no remote exists, ask the user.

---

## License badge color guide

Color follows the **project type**, matching the per-type badge blocks above:

| Project type | MIT badge color | Badge fragment |
|---|---|---|
| npm package | yellow | `License-MIT-yellow.svg` |
| Agent skill / plugin | yellow | `License-MIT-yellow.svg` |
| NuGet package | blue | `License-MIT-blue.svg` |
| Python package | blue | `License-MIT-blue.svg` |
| Go module / CLI | blue | `License-MIT-blue.svg` |
| Generic library / tool | blue | `License-MIT-blue.svg` |

Non-MIT licenses are always **blue** regardless of project type
(`License-Apache%202.0-blue.svg`, `License-GPLv3-blue.svg`).

Detect the license from: `package.json → license`, `*.csproj → <PackageLicenseExpression>`, `pyproject.toml → license`, GitHub's detected SPDX id (`gh api repos/{username}/{repo} --jq .license.spdx_id`), or the root `LICENSE` file first line. `NOASSERTION` or no file → no license badge, report it.
