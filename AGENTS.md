# github-manager — agent guide

Agent Skills plugin (Claude Code and Codex) that audits and strengthens any GitHub account:
profile fields, profile README, repo descriptions, topics, license, project READMEs and release
workflows. Standards are generic; user preferences come from a config file.

## Layout
- `skills/<name>/SKILL.md`: seven skills (`gh-audit`, `gh-onboard`, `gh-normalize`, `profile-bio`,
  `profile-readme`, `readme-standard`, `release-workflow`). Each keeps its standard in its own
  `references/`; skills reach siblings with `../<skill>/references/...`.
- `skills/gh-audit/references/config.md`: the config schema and defaults. Update it, both READMEs
  and the readme-standard SKILL.md table together when a key changes.
- `skills/*/agents/openai.yaml`: Codex policy for the five write-capable skills
  (`allow_implicit_invocation: false`, matching `disable-model-invocation: true`).
- `agents/*.md`: read-only analyzer subagents. Callers pass them the standard path and the config;
  no `${CLAUDE_PLUGIN_ROOT}` in skill or agent bodies.
- `skills/release-workflow/assets/templates/release-*.yml` + `scripts/add-release-workflow.sh`:
  release templates and the installer (placeholders `__DEFAULT_BRANCH__`, `__CSPROJ__`, …).
- `.claude-plugin/plugin.json` (version source of truth) and `.codex-plugin/plugin.json`.
- `.github/workflows/release.yml`: tags `v<version>` from `.claude-plugin/plugin.json` on push to main.

## Rules
- Host-neutral wording; no hardcoded `~/.claude/...` paths, no host tool names, no personal data
  or account-specific examples in the standards.
- User config lives in `$GITHUB_MANAGER_HOME` or `~/.agents/github-manager/`, never in the plugin dir.
- Skills never write to GitHub or commit/push without explicit user approval; templates never
  paste commit text into shell commands.
- Keep `version` equal in both manifests and every SKILL.md `metadata.version`; add a
  `CHANGELOG.md` entry and update both READMEs (EN + TR mirror) with every bump.
- Never commit or push without explicit approval from the maintainer.

## Checks
- `claude plugin validate .`
- `plans/tools/codex_smoke.sh . <skills…>` from the skill-hub workspace (skills with
  `allow_implicit_invocation: false` are installed but not listed in the implicit skill list).
- `bash -n skills/release-workflow/scripts/add-release-workflow.sh`, then run it with `--detect`
  and `--stdout` against temp clones under `/tmp`; lint the output with `actionlint`.
