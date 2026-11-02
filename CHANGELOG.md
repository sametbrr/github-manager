# Changelog

## [1.0.1] - 2026-11-02

### Changed
- readme-standard Rule 6: in translated mirrors, comments inside code blocks may and should be
  translated; commands, flags, paths, placeholders, prompts and trigger phrases, directory trees and
  sample output stay byte-identical to README.md.
- readme-standard Rule 21: for agent skills and plugins, a code block of example trigger phrases and
  slash or `$skill` invocations is the Usage cheat sheet; mirrors never translate these inputs. The
  Usage template shows this form.
- Badges: a repo that is both a publishable npm, NuGet or PyPI package and an agent plugin is
  detected as the package; registry badges come first and the agentskills.io badge is optional.
- README.md and README.tr.md: nav line, a trigger cheat sheet at the top of Usage, a Troubleshooting
  section for `gh` auth and scopes, and Turkish code blocks that match the English ones except for
  comments.
- skills/readme-standard README.md and README.tr.md: GitHub release badge, trigger cheat sheet,
  English trigger phrases in the Turkish mirror, and a Configuration section for the `readme.*` keys.

## [1.0.0] - 2026-11-02

First versioned release. github-manager is now a generic tool for any GitHub user and runs as a
plugin in both Claude Code and Codex.

### Added
- Codex manifest (`.codex-plugin/plugin.json`) and `agents/openai.yaml` for the five
  explicit-only skills.
- Config file shared by both hosts (`$GITHUB_MANAGER_HOME` or `~/.agents/github-manager/config.json`):
  README mirrors, badges, extra sections, description style, topic sets, profile sections.
- License check (missing, `NOASSERTION`, manifest mismatch) in `gh-audit`.
- Project families: Go CLI, MCP server, web app, private app, agent skill, Claude/Codex plugin.
- Optional `codex` host topic for repos that really support Codex.
- Release templates for agent plugins, MCP servers (npm + MCP Registry), Go (plain build,
  GoReleaser, Go + npm wrapper); `add-release-workflow.sh --detect/--stdout/--branch`.
- Generated profile README support: detect the generator, edit the source, run generator and check.
- `AGENTS.md`, `CLAUDE.md`, this changelog and a release workflow for the plugin itself.

### Changed
- npm, NuGet and Python templates: version bump or tag push → registry publish (npm with
  `--provenance`, PyPI trusted publishing), default branch detected, notes via `--generate-notes`.
- Every release template refuses to run off the default branch (manual runs must start on it,
  tags must point to a commit on it); the MCP Registry publisher is pinned and checksum-verified;
  PyPI publishing runs in its own job with the `pypi` environment.
- `readme-standard` writes only after the user confirms the file list, and Create mode never
  overwrites an existing README.md.
- README mirrors are opt-in (default: none); the Turkish table ships as a ready option.
- Description standard accepts an imperative form; trailing period configurable.
- Profile README sections are configurable instead of a fixed layout.
- Standards moved from `STANDARDS/` into each skill's `references/`; agents receive paths from
  their callers instead of `${CLAUDE_PLUGIN_ROOT}`.
- All skill descriptions are agent-neutral and say when to use them.

### Removed
- Host-specific rule references, personal examples and the hardcoded marketplace path.
- Release templates that pasted commit messages into shell commands.
