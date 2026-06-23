---
name: profile-readme
description: Claude Code skill that generates and maintains the GitHub profile README (login/login repo) as README.md plus a Turkish mirror, built from live account data.
disable-model-invocation: true
---

# profile-readme

`<login>/<login>` repo'sundaki profil README.md (+ README.tr.md mirror) üretir/günceller.
Veri canlıdır (hesap + repolar + marketplace). Yazma onaylıdır.

## 0. Auth preflight
```bash
gh auth status >/dev/null 2>&1 || echo "→ ! gh auth login --web -s repo,read:org,user"
```

## 1. Veri topla
```bash
login=$(gh api user --jq .login)
gh api user --jq '{name,bio,blog,company,location}'                       # kimlik (profile-bio ile aynı kaynak)
gh api /user/social_accounts                                             # badge linkleri
gh repo list "$login" --visibility public --limit 200 \
  --json name,description,primaryLanguage,repositoryTopics               # projeler
```
Skill listesi/kanonik açıklamalar: `~/Projects/skill-hub/.claude-plugin/marketplace.json` (varsa).

## 2. README.md kur (şema sabit)
Oku: `${CLAUDE_PLUGIN_ROOT}/STANDARDS/profile-readme.md`. 7 bölüm:
Hero(ad+tagline+misyon+badge sırası Website→LinkedIn→X→npm→NuGet+TR link) → About Me →
What I Build (LLM tooling `<table>` + Published Packages tablo) → Current Focus →
GitHub Analytics(tokyonight) → Activity Graph → Philosophy.
- Proje tablolarını **kanonik description**'larla doldur (audit'ten geçmiş).
- Gruplama: LLM tooling/skill vs NuGet/npm paket.

## 3. README.tr.md mirror
Aynı yapı, tam Türkçe; badge'ler aynı, kod blokları çevrilmez.

## 4. Hedef + diff + onay
Profil repo yerel kopyası (ör. `~/Projects/<login>`); yoksa:
```bash
gh repo clone "$login/$login"
```
Dosyaları yaz, `git diff` göster. **Onaysız commit/push yok.**

## 5. Yayınla (onaylı)
Onay → commit + push (no-auto-commit hook prompt'u — beklenen).

## Kurallar
- Push **onaylı** (CLAUDE.md #8).
- **"Claude"/co-author ibaresi YOK** (CLAUDE.md #9).
- Badge sırası + tema sabit; mevcut elle eklenmiş bölümleri gereksiz silme (CLAUDE.md #6).
