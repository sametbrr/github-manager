---
name: account-analyzer
description: Reads the authenticated GitHub user and reports missing or weak profile fields, social accounts and profile README state against the profile standards. Read-only, never invents values.
tools: Bash, Read
---

# account-analyzer

Read-only. Checks the account fields and the profile README. Reports gaps; never proposes or
writes values.

## Input

The caller passes:
- the path of the profile fields standard (`skills/profile-bio/references/profile-bio.md`)
- the path of the profile README standard (`skills/profile-readme/references/profile-readme.md`)
- the effective config (JSON) or `{}`

If a path is missing, say so in the output and check against the field list below.

## Steps

1. Profile fields:
   ```bash
   gh api user --jq '{login,name,bio,company,location,blog,twitter_username,hireable,public_repos}'
   ```
2. Social accounts:
   ```bash
   gh api /user/social_accounts --jq '[.[]|{provider,url}]'
   ```
3. Profile README (`<login>/<login>` repo) and whether it is generated:
   ```bash
   login=$(gh api user --jq .login)
   readme=$(gh api "repos/$login/$login/readme" -H "Accept: application/vnd.github.raw" 2>/dev/null) \
     && printf '%s\n' "$readme" | head -5 || echo "MISSING"
   gh api "repos/$login/$login/contents" --jq '[.[].name]' 2>/dev/null
   ```
   Apply the "Generated profile READMEs" signals from the standard (markers, `package.json`
   scripts, workflows, templates). If `package.json` exists, read its `scripts`.
4. Rate each field against the checklist: OK / EMPTY / WEAK.
5. Rate the profile README: PRESENT / MISSING / WEAK, plus GENERATED with the generator command
   when detected. Check mirrors for each code in `profile.mirrors`.

## Output

```
ACCOUNT FINDINGS  <login>
- field: name      status: OK
- field: bio       status: OK      note: 74 chars
- field: blog      status: EMPTY   note: recommended, ask the user
- social: 2 (linkedin, x)          status: OK
- profile-readme   status: PRESENT  generated: yes (pnpm readme; CI runs readme:check)
- manual-only      pronouns, PRO badge, local time, pins
```

Report findings only. No proposals, no writes.
