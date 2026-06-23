---
name: gh-audit
description: Claude Code skill that produces a read-only GitHub account health report — missing profile fields, repo descriptions, topics and READMEs across a chosen scope (public/private/all) or a single repo. Writes nothing.
---

# gh-audit

Read-only sağlık raporu. **Hiçbir şey yazmaz.** Hesap (profil) + repo (metadata/README)
katmanlarını STANDARDS checklist'lerine göre denetler, önceliklendirilmiş sapma raporu verir.

## 0. Auth preflight
```bash
command -v gh >/dev/null || { echo "→ brew install gh"; exit 1; }
gh auth status >/dev/null 2>&1 || echo "→ login gerek: ! gh auth login --web -s repo,read:org,user"
```

## 1. Hedef çöz
Öncelik: `--repo owner/name` > **cwd git repo + remote** > `--scope public|private|all` > **SOR**.
```bash
# hesap modu:
gh repo list "$(gh api user --jq .login)" --visibility <scope> --limit 200 \
  --json name,description,repositoryTopics,visibility,primaryLanguage
# tek repo modu: --repo verildi ya da: git remote get-url origin
```

## 2. Hesap denetimi (yalnız hesap modunda, 1 kez)
`account-analyzer` agent'ını çalıştır → eksik profil alanları + profil README durumu.

## 3. Repo denetimi (SIRALI — repo başına)
Önce repo listesini tek çağrıda çek (yukarıda). Sonra **her repo için sırayla**:
- `description-analyzer` → desc verdict + öneri
- `tag-analyzer` → topics add/remove
- `readme-analyzer` → README durumu

> Sıralı: paralel/workflow yok. Veri tek seferde çekildiği için her analyzer ön-çekilmiş
> veriyle çalışır (tekrar gh çağrısı minimum).

## 4. Önceliklendirilmiş rapor
Sıra: **profil kimliği → public repo desc/topics → public README → private**.
```
GITHUB AUDIT  (<login>, scope=<scope>)

PROFİL
  - company: EMPTY (opsiyonel) · profile-readme: PRESENT · ...

REPOLAR (n)
  repo                desc      topics              readme
  ----                ----      ------              ------
  awesome-agent-skills  PASS    FAIL (boş!)         PRESENT
  prompt-architect      PASS    WARN (anthropic)    PRESENT
  ...

ÖZET
  X repo desc, Y topics, Z readme sapması · profil: N eksik
```

## Kurallar
- **Read-only**: hiçbir `gh repo edit` / `PATCH` / push YOK.
- Sapma = checklist ihlali; rapor neyin neden sapma olduğunu söyler.
- Düzeltme istenirse → `gh-normalize` (desc/topics) / `profile-bio` / `readme-standard`'a yönlendir.
- Sessiz varsayım yok; tüm sapmalar tek raporda (CLAUDE.md #1/#7).
