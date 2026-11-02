---
name: release-workflow
description: Installs a project-type-aware GitHub Actions release workflow (.github/workflows/release.yml) into a local repo. Detects npm, MCP server, NuGet, Python, Go (plain, GoReleaser or with an npm wrapper), agent plugin, single skill and VERSION-file projects plus the default branch, then tags, publishes to the registry and creates a GitHub release. Use when the user wants automated releases or publishing for a repo. Never commits.
disable-model-invocation: true
metadata:
  version: "1.0.1"
---

# release-workflow

Writes `.github/workflows/release.yml` for one local repo. After the user commits it, the repo
releases itself: tag, registry publish where there is one, and a GitHub release with notes.

Run only when the user explicitly asks.

## Usage

```
release-workflow [--repo-dir <path>] [--type <type>] [--branch <name>] [--audit] [--force]
```

`--repo-dir` defaults to the current directory. `--type` and `--branch` default to detection.

## 1. Detect

The script lives in this skill's folder, but you run it while the target repo is the working
directory. Resolve `scripts/add-release-workflow.sh` against this skill's directory to an absolute
path first and use that (`$SCRIPT` below).

```bash
bash "$SCRIPT" <repo-dir> --detect
```

Detection order (first match wins):

| Type | Signal | Trigger | Publishes to |
|---|---|---|---|
| `goreleaser` | `go.mod` + `.goreleaser.yaml` | tag push `v*` | GoReleaser (GitHub release + its publishers) |
| `go-npm` | `go.mod` + `npm/package.json` wrapper | tag push `v*` | GitHub release binaries + npm wrapper |
| `go` | `go.mod` | tag push `v*` | GitHub release with 6 cross-compiled binaries + checksums |
| `mcp` | public `package.json` with `@modelcontextprotocol/sdk` or `server.json` | version bump or tag push | npm (provenance) + MCP Registry if `server.json` |
| `npm` | public `package.json` with a version | version bump or tag push | npm (provenance) |
| `plugin` | `.claude-plugin/plugin.json` | bump of its `version` | GitHub release only; cross-checks `.codex-plugin` and `skills/*/SKILL.md` versions |
| `nuget` | packable `*.csproj` | `<Version>` bump or tag push | nuget.org |
| `python` | `pyproject.toml` | version bump or tag push | PyPI (trusted publishing) |
| `skill` | one `SKILL.md` (root or `skills/<name>/`) | frontmatter version bump | GitHub release only |
| `generic` | `VERSION` file | change of `VERSION` | GitHub release only |
| `npm` (private) | `package.json` with `"private": true` | version bump | GitHub release only |

The release branch is the remote default branch (`origin/HEAD`), then the current branch, then
`main`. Show the detection output to the user. If nothing is detected, ask for `--type` or suggest
a `VERSION` file.

## 2. Mode

- `--audit`: no writes. Report whether `release.yml` exists, whether it matches the detected type,
  and whether other workflows already publish (the script warns about them). Check existing
  workflows for unsafe patterns: commit text pasted into `run:` (for example
  `--notes "${{ steps.x.outputs.notes }}"`), hardcoded `main` on a repo whose default branch
  differs, publishing without a tag/version check.
- add (default): write `release.yml` if it doesn't exist.
- `--force`: overwrite the existing file after the user confirms.

Preview first when useful: `bash "$SCRIPT" <repo-dir> --stdout`.

## 3. Apply

```bash
bash "$SCRIPT" <repo-dir> [--type <type>] [--branch <name>] [--force]
```

The script writes one file and never commits, pushes or calls the GitHub API.

## 4. Tell the user what the workflow needs

- **Version field**: npm/mcp → `package.json` `version`; nuget → `<Version>`; python →
  `[project] version` (dynamic versions: release by tag push); plugin →
  `.claude-plugin/plugin.json` `version` (keep `.codex-plugin/plugin.json` and every SKILL.md
  `metadata.version` equal); skill → frontmatter version; generic → `VERSION`; Go → tags only.
- **Secrets / publisher setup**: npm → `NPM_TOKEN` or npm trusted publishing; nuget →
  `NUGET_API_KEY`; python → a PyPI trusted publisher with environment `pypi`; MCP Registry →
  `mcpName` in `package.json` and a `server.json`.
- **Private repos**: remove `--provenance` from npm templates.
- **Existing publishers**: if another workflow already publishes, suggest removing one of them to
  avoid double publishing.

## 5. Summary

```
RELEASE-WORKFLOW  <repo>
  type: <type>   branch: <branch>   release.yml: written | skipped | audit
  next: bump the version (or push a tag) after committing the workflow
```

## Rules

- One local repo per run. Batch installs across remote repos are out of scope.
- Write only `.github/workflows/release.yml` in the target repo. Never commit or push without
  explicit user approval.
- Templates never paste commit messages into shell commands; notes come from
  `--generate-notes` or a notes file.
- Every template refuses to release from anything but the default branch: a manual run must start
  on it, and a pushed tag must point to a commit reachable from it.
