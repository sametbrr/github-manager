# Repo topics standard

Rules for GitHub repo `topics`. Topics drive GitHub search and the topic pages, so they should
describe the stack and the domain. Core sets are suggestions, not requirements: the audit flags
gaps and the user decides. Override per family with `topics.core`, add account-wide tags with
`topics.always` (see `../../gh-audit/references/config.md`).

## Families and suggested core topics

Detect the family from files first, then the primary language. First match wins, top to bottom.

| Family | Detection signal | Suggested core | Add |
|---|---|---|---|
| `agent-plugin` | `.claude-plugin/plugin.json` or `.codex-plugin/plugin.json` | `agent-skills` + each host in `topics.agentHosts` the plugin really supports | 2–4 domain topics |
| `agent-skill` | `SKILL.md` at root or `skills/*/SKILL.md`, no plugin manifest | `agent-skills` + supported hosts | `python` etc. if scripts are bundled; 2–4 domain |
| `mcp-server` | dependency `@modelcontextprotocol/sdk`, `mcp` (Python), `mark3labs/mcp-go`, or `"mcpServers"` in docs | `mcp`, `model-context-protocol` + language (`typescript`, `python`, `go`) | domain (`openapi`, `postgres`) |
| `go-cli` | `go.mod` plus `package main` / `cmd/` | `go`, `cli` | domain (`encryption`, `git`) |
| `dotnet-package` | `*.csproj` with `<PackageId>` or `GeneratePackageOnBuild` | `csharp`, `dotnet`, `nuget` | 3–5 domain (`dependency-injection`) |
| `npm-package` | `package.json` without `"private": true` | `nodejs` + `typescript` or `javascript` | domain; `cli` if it has `bin` |
| `python-package` | `pyproject.toml` or `setup.py` | `python` (+ `pypi` if published) | domain |
| `web-app` | `next.config.*`, `vite.config.*`, `astro.config.*`, `nuxt.config.*`, `svelte.config.*` | framework (`nextjs`, `react`, `astro`…) + `typescript`/`javascript` | purpose (`portfolio`, `dashboard`, `landing-page`) |
| `cli-tool` | `bin` field, root binary, `cmd/` (non-Go) | `cli` + language | domain |
| `private-app` | private repo, none of the above or an app (`Dockerfile`, mobile project) | none required | optional; topics help your own search only |
| `profile` | repo name equals the owner login | `github-profile-readme` (optional) | none |

`agent-plugin`/`agent-skill`: add a host topic only when the repo really supports that host (for
example `codex` only with a `.codex-plugin/` manifest or documented Codex install steps). Vendor
topics such as `claude` or `anthropic` are optional extras, never core.

## Rules

1. Lowercase kebab-case only (GitHub enforces `a-z0-9-`, max 50 chars).
2. At most 20 topics (GitHub limit).
3. Public repos: at least `topics.min` topics (default 3). Private repos: no minimum.
4. Don't repeat the repo name as a topic.
5. Drop redundant pairs: keep the more specific one (`nextjs` over `react` is not redundant;
   `javascript` next to `typescript` usually is; `anthropic` next to `claude` is).
6. Domain topics should be specific (`prompt-engineering` beats `tool`, `tools`, `misc`).
7. Prefer established topics with existing GitHub topic pages over invented spellings
   (`dotnet`, not `dot-net`).

## Verdicts

- **FAIL**: public repo below `topics.min`; invalid format; over 20.
- **WARN**: core set mostly missing; repo-name topic; redundant pair; vague topic; host topic
  without real support.
- **PASS**: everything else.

## Checklist

- [ ] ≥ `topics.min` topics (public)
- [ ] kebab-case, lowercase
- [ ] ≤ 20
- [ ] Family core mostly present
- [ ] No repo-name topic
- [ ] No redundant or vague topics
- [ ] Host topics only for real host support
