---
name: profile-bio
description: Fills in GitHub account profile fields (name, bio, company, location, blog, social accounts) through the GitHub API, asking for every missing value instead of inventing one and confirming before any write. Use when the user wants to complete or update their GitHub profile details.
disable-model-invocation: true
metadata:
  version: "1.0.2"
---

# profile-bio

Fills in GitHub account fields (`PATCH /user` and social accounts) interactively. **Never invents a
value**; asks for what is missing. Writes only after approval.

Run only when the user explicitly asks.

## 0. Preflight

The `user` scope is required for writes.

```bash
gh auth status 2>&1 | grep -i "token scopes"   # must list 'user'
```

If not logged in or the scope is missing, ask the user to run
`gh auth refresh -s user` (or `gh auth login -s user`) and wait.

## 1. Read the current state

```bash
gh api user --jq '{login,name,bio,company,location,blog,twitter_username,hireable}'
gh api /user/social_accounts --jq '[.[]|{provider,url}]'
```

## 2. Evaluate

Standard: [references/profile-bio.md](references/profile-bio.md). List empty and weak fields
(recommended: name, bio ≤ 160, blog, ≥ 1 social account; optional: location, company).

## 3. Ask for missing values

- Recommended field empty → ask the user and wait for an explicit answer.
- Optional field empty → ask once whether they want to fill it; empty is fine.
- Never guess any value, including `company` and `location`.
- Fields the API can't set (pronouns, PRO badge, local time, pins, avatar) → list them as manual
  steps; don't touch them.

## 4. Diff and approval

Show `current → new` for every field that changes. Don't write before an explicit yes.

## 5. Apply

Send only the changed fields. Pass values as separate `-f` arguments.

```bash
gh api -X PATCH /user -f name="$name" -f bio="$bio" -f blog="$blog"
gh api -X POST /user/social_accounts -f "account_urls[]=$url"
gh api -X DELETE /user/social_accounts -f "account_urls[]=$url"   # only when the user asks
```

## Rules

- Never invent values; a skipped field stays empty.
- Every write needs explicit approval; never send unchanged fields.
- Never delete existing social accounts unless the user asks.
