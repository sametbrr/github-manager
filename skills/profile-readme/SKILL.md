---
name: profile-readme
description: Creates or updates the GitHub profile README (the login/login repo) from live account data, with configurable sections and optional translated mirrors. Detects generated profile READMEs and edits their source and runs the generator instead of the output. Use when the user wants a new or refreshed GitHub profile README.
disable-model-invocation: true
metadata:
  version: "1.0.0"
---

# profile-readme

Builds or updates `README.md` in the `<login>/<login>` repo (plus mirrors from
`profile.mirrors`). Uses live data. Never pushes without approval.

Run only when the user explicitly asks.

## 0. Preflight

```bash
gh auth status >/dev/null 2>&1 || echo "not logged in"
```

If not logged in, ask the user to run `gh auth login` and wait.

## 1. Config

```bash
cfg="${GITHUB_MANAGER_HOME:-$HOME/.agents/github-manager}/config.json"
[ -f "$cfg" ] && cat "$cfg" || echo '{}'
```

Keys used: `language`, `profile.sections`, `profile.mirrors`, `profile.projectSources`,
`profile.stats`. Schema: `../gh-audit/references/config.md`. Standard and section catalogue:
[references/profile-readme.md](references/profile-readme.md).

## 2. Get a working copy

Use an existing local clone if the user points to one; otherwise clone into a temp or chosen
directory:

```bash
login=$(gh api user --jq .login)
gh repo view "$login/$login" >/dev/null 2>&1 || echo "profile repo missing"
gh repo clone "$login/$login" "<dir>"
```

If the repo doesn't exist, ask whether to create it (public, same name as the login). Creating it
is an outward-facing write: wait for an explicit yes, then `gh repo create "$login/$login" --public`.

## 3. Generated or hand-written?

Check the signals in the standard's "Generated profile READMEs" section, in this order:

```bash
head -5 README.md
jq -r '.scripts // {} | to_entries[] | "\(.key): \(.value)"' package.json 2>/dev/null | grep -i readme
grep -lis 'readme' .github/workflows/*.y*ml 2>/dev/null
ls README.tmpl README.md.tpl templates scripts content data 2>/dev/null
```

- **Generated** → go to step 5.
- **Hand-written or missing** → go to step 4.
- **Unsure** (markers without a clear generator, or a generator you can't run) → stop, show what
  you found and ask the user how to proceed.

## 4. Hand-written: build the README

1. Collect data:
   ```bash
   gh api user --jq '{name,bio,blog,company,location}'
   gh api /user/social_accounts
   gh repo list "$login" --visibility public --source --no-archived --limit 300 \
     --json name,description,primaryLanguage,repositoryTopics,homepageUrl,stargazerCount
   ```
   Plus every entry in `profile.projectSources` (local JSON/YAML/Markdown file or URL listing
   projects with canonical descriptions).
2. Ask the user for content the API can't give (tagline, about text, focus themes) when those
   sections are configured. Never invent it.
3. Render the sections in `profile.sections` order. Keep sections the user wrote by hand that are
   not in the catalogue; ask before removing any.
4. For each code in `profile.mirrors`, write a full translation `README.<code>.md` and link it from
   the primary file after the intro block.

## 5. Generated: edit the source

1. Identify the source files (data files, templates) and the generator command (a `package.json`
   script, `make readme`, a script in `scripts/`, or the workflow's command).
2. Edit only the source files. Never hand-edit the generated README.
3. Install dependencies if needed (ask first if it downloads packages) and run the generator, then
   its check command if one exists (`readme:check`, `--check`, a CI step you can run locally).
4. If the generator fails or the output isn't what the source suggests, stop and report. Don't
   patch the output to make it pass.

## 6. Review and publish

Show `git diff --stat` and the full README diff. Commit and push only after the user explicitly
approves. Use a plain commit message describing the change, with no tool or agent attribution.

## Rules

- Never commit or push without explicit user approval.
- Generated READMEs: source edits only; generator and check must pass.
- Content comes from the account, the repos, configured sources or the user, never invented.
- Keep the user's own sections; no attribution footer.
