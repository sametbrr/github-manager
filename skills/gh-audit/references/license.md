# License check

A repo without a recognised license is "all rights reserved" by default: others may view it but
not reuse it. GitHub detects the license with `licensee` and reports an SPDX id.

## Data

```bash
gh api repos/<owner>/<repo> --jq '.license.spdx_id // "NONE"'
```

In bulk, `gh repo list --json licenseInfo` returns `{key, name}` per repo: `null` = `NONE`,
key `other` = `NOASSERTION`, any other key = a recognised license.

## Verdicts

| Value | Verdict | Meaning and advice |
|---|---|---|
| an SPDX id (`MIT`, `Apache-2.0`, `GPL-3.0`…) | PASS | recognised license |
| `NOASSERTION` | WARN | a LICENSE file exists but GitHub can't parse it (edited template, several licenses in one file, unusual wording). Suggest the unmodified template text from https://choosealicense.com or `gh api licenses/<id>` |
| `NONE`, public repo | FAIL | no license file. Ask which license the user wants; never pick one for them |
| `NONE`, private repo | PASS (info) | private apps often have no license on purpose |
| `NONE`, fork | info | the upstream license applies; mention only |

Also check consistency when a manifest declares a license: `package.json` `license`,
`*.csproj` `<PackageLicenseExpression>`, `pyproject.toml` `license`. A mismatch with the detected
SPDX id is a WARN.

Adding or changing a license is a file change in the repo and a legal choice. The audit only
reports. Create the file only when the user explicitly asks and names the license.
