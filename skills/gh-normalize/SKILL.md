---
name: gh-normalize
description: Claude Code skill that fills and standardizes GitHub repo descriptions and topics — single repo or batch across a chosen scope, with per-repo confirmation.
disable-model-invocation: true
---

# gh-normalize

Repo `description` + `topics` alanlarını standarda çeker. Tek repo ya da batch.
Repo-başına onaylı yazar.

## Kullanım
```
gh-normalize [--scope public|private|all] [--repo owner/name] [--confirm each|all] [--only desc|topics] [--dry-run]
```

## 0. Auth preflight
```bash
gh auth status >/dev/null 2>&1 || echo "→ ! gh auth login --web -s repo,read:org,user"
```

## 1. Hedef çöz (öncelik sırası)
1. `--repo owner/name` → tek repo
2. cwd git repo + remote → tek repo (`git remote get-url origin`)
3. `--scope` → `gh repo list <login> --visibility <scope> --limit 200 --json name,description,repositoryTopics,primaryLanguage`
4. Hiçbiri → **SOR**: tek repo mu? hangi kapsam (public/private/all)?
> Profil repo'su (`<login>/<login>`) hariç tutulur.

## 2. Analiz (repo başına SIRALI)
- `--only` desc değilse → `description-analyzer` çalıştır → öneri.
- `--only` topics değilse → `tag-analyzer` çalıştır → add/remove.
Veriyi 1'de tek çağrıda çektiysen analyzer'lara ön-çekilmiş veriyle ver (tekrar gh çağrısı az).

## 3. Onay kapısı
- `--confirm each` (varsayılan): repo başına `mevcut → öneri` diff göster, onayla/atla.
- `--confirm all`: tüm öneri tablosunu göster, topluca onayla.
- `--dry-run`: sadece rapor, **yazma yok** (= gh-audit).

## 4. Uygula
```bash
gh repo edit <owner>/<repo> --description "<yeni>"
gh repo edit <owner>/<repo> --add-topic a,b,c
gh repo edit <owner>/<repo> --remove-topic x,y
```

## 5. Özet
```
NORMALIZE özet (scope=<scope>)
  değişen : <n>   atlanan : <n>   hata : <n>
  repo                desc        topics
  ----                ----        ------
  look-again          ✎ (181→152)  -
  prompt-architect    -            -anthropic
```

## Kurallar
- Her yazma onaylı (CLAUDE.md #8); `--confirm each` varsayılan.
- Sadece hedef repo'nun desc/topics'i; başka alana/repoya dokunma (CLAUDE.md #6).
- Öneriler `description-analyzer`/`tag-analyzer` çıktısı — uydurma değil, standarttan.
