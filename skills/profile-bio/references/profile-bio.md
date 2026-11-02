# Profile fields standard

GitHub account fields set through `PATCH /user` and `/user/social_accounts`.
**Never invent a value.** Report what is missing, ask the user, and leave a field empty if they
skip it.

## Fields

| Field | API | Status | Note |
|---|---|---|---|
| `name` | PATCH /user | recommended | the name the user wants to be known by |
| `bio` | PATCH /user | recommended | ≤ 160 chars, one line |
| `location` | PATCH /user | optional | city, region or "Remote" |
| `blog` | PATCH /user | recommended | personal site, portfolio or main project URL |
| `company` | PATCH /user | optional | may stay empty |
| `twitter_username` | PATCH /user | optional | overlaps with social accounts |
| `email`, `hireable` | PATCH /user | optional | privacy choice; never change without asking |
| social accounts | POST/DELETE /user/social_accounts | recommended ≥ 1 | LinkedIn, X, Mastodon, npm, NuGet, YouTube… |

## Bio

One line, ≤ 160 characters, says what the person does and with what. Any separator style is fine
(`·`, `|`, `,`). Examples:

- `Backend engineer · Go & PostgreSQL · building developer tools`
- `Data scientist working on climate models. Python, R, Julia.`

The audit only warns about a bio over 160 chars or a bio that is just a single word.

## Not settable through the API (report as manual)

- Pronouns
- Display PRO badge
- Display current local time
- Pinned repositories (GraphQL can read them, but pinning is UI only)
- Profile picture

## Rules

1. Missing recommended field: report it and ask; never guess.
2. Missing optional field: mention it once; fill only if the user wants to.
3. Social accounts: never delete an existing one unless the user asks.
4. Writing is outward facing: show `current → new` and wait for explicit approval.
5. Send only the fields that change.

## Checklist

- [ ] name set
- [ ] bio set, ≤ 160 chars
- [ ] blog set (recommended)
- [ ] ≥ 1 social account (recommended)
- [ ] optional fields left to the user, nothing invented
