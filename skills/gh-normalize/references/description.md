# Repo description standard

Rules for the GitHub `description` field. The description is what people see in search results,
on profile pins and in link previews, so it has to say what the repo is and why it matters in one
line. Defaults below can be changed in the config file (`description.*`, see
`../../gh-audit/references/config.md`).

## Accepted forms

Two forms are accepted by default (`description.forms`):

| Form | Grammar | Example |
|---|---|---|
| `artifact` | `<Artifact type> that\|for <core function> — <2–4 specifics>` | `Go CLI that backs up dotfiles to any S3 bucket — encrypted, incremental, 3 platforms` |
| `imperative` | `<Verb> <object> <qualifier> — <specifics>` (common for CLIs and apps) | `Render accessible charts from CSV in one command — SVG or PNG, 12 chart types` |

- **Artifact type** names what the repo is: `.NET library`, `npm package`, `Go CLI`, `MCP server`,
  `Next.js site`, `Agent Skills plugin`, `Python package`, `VS Code extension`.
- **Core function**: one main job, stated with a verb.
- **Specifics**: 2 to 4 concrete facts after an em dash (`—`) or `with`. Prefer at least one
  number or a named technology ("23 rules", "OpenAPI 3", "PostgreSQL 16").

## Rules

1. One sentence, in the configured `language` (default English).
2. Length ≤ `description.maxLength` (default 160). Longer text is cut in many GitHub views.
3. Trailing period follows `description.trailingPeriod` (default `optional`: both are fine, but be
   consistent within one account; the audit warns when an account mixes both).
4. At least one concrete specific.
5. Don't start by repeating the repo name.
6. Name a vendor or host (Claude, Codex, Copilot) only if the project is specific to it. Tools that
   work with several agents name the standard instead ("Agent Skills plugin", "MCP server").
7. No marketing filler ("awesome", "blazing fast", "the best") without a fact behind it.
8. Repo description is the short canonical text. A profile README or website may expand it.

## Verdicts

- **FAIL**: empty; over the length limit; more than one sentence; no recognisable form.
- **WARN**: no concrete specific; trailing period against the config; mixed period style across
  the account; vendor name on a multi-host tool; repeats the repo name.
- **PASS**: everything else.

## Proposing a fix

Build the proposal from real data only: README first lines, `package.json` `description`,
`*.csproj` `<Description>`, `pyproject.toml` `description`, `go.mod` module path,
`.claude-plugin/plugin.json` `description`, SKILL.md frontmatter, primary language and topics.
Never invent features or numbers. If the data is too thin, return `proposed: (needs input)` and say
what is missing.

## Checklist

- [ ] Not empty
- [ ] One sentence, ≤ `maxLength`
- [ ] Matches an accepted form
- [ ] At least one concrete specific
- [ ] Trailing period follows the config
- [ ] Vendor names only when the project is vendor-specific
