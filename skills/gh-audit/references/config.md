# github-manager configuration

Every preference in github-manager is optional. With no config file the skills use the defaults
below, which follow common GitHub practice. One file serves Claude Code and Codex alike.

## Location

Resolve in this order and use the first file that exists:

1. `$GITHUB_MANAGER_HOME/config.json`
2. `~/.agents/github-manager/config.json`

```bash
cfg="${GITHUB_MANAGER_HOME:-$HOME/.agents/github-manager}/config.json"
[ -f "$cfg" ] && cat "$cfg" || echo '{}'
```

Missing keys fall back to the defaults. Unknown keys are ignored. Never store the config inside
the plugin or skill folder: reinstalling would wipe it. Skills only read this file. Create or edit
it only when the user asks. If a sandbox blocks writing to the home directory, say so, show the
JSON, and let the user save it.

## Keys and defaults

```json
{
  "language": "en",
  "readme": {
    "mirrors": [],
    "badges": "auto",
    "extraSections": []
  },
  "description": {
    "maxLength": 160,
    "trailingPeriod": "optional",
    "forms": ["artifact", "imperative"]
  },
  "topics": {
    "min": 3,
    "core": {},
    "always": [],
    "agentHosts": ["claude-code", "codex"]
  },
  "profile": {
    "mirrors": [],
    "sections": ["intro", "about", "projects", "contact"],
    "projectSources": [],
    "stats": false
  }
}
```

| Key | Default | Meaning |
|---|---|---|
| `language` | `"en"` | Language of the primary README, repo descriptions and profile README. |
| `readme.mirrors` | `[]` | Extra full translations of each project README, one file per language code: `["tr"]` writes `README.tr.md`. Empty means a single README. |
| `readme.badges` | `"auto"` | `auto`: badges detected from the manifest (version, downloads, license). `minimal`: license and release only. `none`: no badge line. |
| `readme.extraSections` | `[]` | Project-specific `##` sections, placed after Troubleshooting and before Contributing (Rule 10 of readme-standard), for example `["API", "Benchmarks"]`. |
| `description.maxLength` | `160` | Upper limit for repo descriptions. |
| `description.trailingPeriod` | `"optional"` | `required`, `forbidden` or `optional` for the final period. |
| `description.forms` | `["artifact", "imperative"]` | Accepted grammar forms. `artifact`: "Go CLI that syncs …". `imperative`: "Sync agent config across machines …". |
| `topics.min` | `3` | Minimum topic count on a public repo. |
| `topics.core` | `{}` | Per-family override of the suggested core topics, for example `{"agent-plugin": ["agent-skills", "claude-code", "codex"]}`. |
| `topics.always` | `[]` | Topics suggested for every repo (a personal or org tag). |
| `topics.agentHosts` | `["claude-code", "codex"]` | Host topics suggested for agent skills and plugins that really support those hosts. |
| `profile.mirrors` | `[]` | Translations of the profile README, same format as `readme.mirrors`. |
| `profile.sections` | `["intro", "about", "projects", "contact"]` | Ordered section ids of the profile README. Catalogue in `profile-readme/references/profile-readme.md`. |
| `profile.projectSources` | `[]` | Extra local files or URLs that list projects with canonical descriptions, for example a plugin `marketplace.json`. |
| `profile.stats` | `false` | Add third-party stats cards to the profile README. |

## Mirrors

A mirror is a complete translation, never a summary. Rules for mirrors are in
`readme-standard/references/rules.md` (Rules 4 to 7). The plugin ships a heading and phrase
table for Turkish (`readme-standard/references/tr-translations.md`). For other languages the
agent translates headings itself and keeps the same structure.

## Example: an English README with a Turkish mirror

```json
{
  "readme": { "mirrors": ["tr"] },
  "profile": { "mirrors": ["tr"], "sections": ["intro", "about", "projects", "packages", "focus", "contact"] },
  "topics": { "always": [] }
}
```
