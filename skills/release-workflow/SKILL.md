---
name: release-workflow
description: Claude Code skill that installs a project-type-aware auto-release GitHub Actions workflow (.github/workflows/release.yml) into a repo — reads the version from SKILL.md / package.json / *.csproj / pyproject.toml / VERSION and cuts a tag plus GitHub release on every version bump. Manually invoked, single local repo, never commits.
disable-model-invocation: true
---

# release-workflow

Bir repoya **otomatik release** workflow'u kurar: `main`'e push'ta proje tipinin version
dosyası değişince, version'ı okur, tag yoksa tag + GitHub Release oluşturur. Üreten skill
budur; otomasyon bir kez kurulunca repo kendi release'ini açar.

## Kullanım
```
release-workflow [--repo-dir <path>] [--type skill|npm|nuget|python|generic] [--audit] [--force]
```
- `--repo-dir` yoksa cwd kullanılır.
- `--type` yoksa otomatik tespit edilir.

## 0. Auth/araç preflight
```bash
command -v gh >/dev/null || echo "→ ! gh gerekli (workflow gh release create kullanır)"
```

## 1. Hedef + tip
- Hedef dizin: `--repo-dir` ya da cwd. Git repo olmalı (release.yml orada anlamlı).
- Tip tespiti (öncelik): `package.json`→npm · `*.csproj`→nuget · `pyproject.toml`→python · `SKILL.md`→skill · `VERSION`→generic.
- Tespit edilemezse → kullanıcıya SOR (`--type`) ya da `VERSION` dosyası öner.

## 2. Mod
- **--audit** (yazma yok): release.yml var mı, tespit edilen tiple uyumlu mu raporla. = dry-run.
- **add** (varsayılan): release.yml yoksa kur.
- **--force**: var olanı tespit edilen tipin template'iyle üzerine yaz.

## 3. Uygula
```bash
bash scripts/add-release-workflow.sh <repo-dir> [--type <t>] [--force]
```
- Idempotent: dosya varsa `--force` olmadan dokunmaz.
- **Commit/push YOK** (CLAUDE.md #8) — workflow dosyasını kullanıcı onaylı commit'ler.

## 4. Version alanı kontrolü
release.yml seçilen version dosyasını okur; o dosyada geçerli version yoksa workflow boş `v`
üretir. Kullanıcıya version eklemesini hatırlat:
- skill → SKILL.md frontmatter `version:` · npm → package.json `version` · nuget → `<Version>`
  · python → pyproject.toml `version` · generic → `VERSION` dosyası.

## 5. Özet
```
RELEASE-WORKFLOW: <repo>
  tip: <skill|npm|nuget|python|generic>   release.yml: <yazıldı|atlandı|audit:var/yok>
  sonraki: version artır + main'e push → otomatik tag + release
```

## Kurallar
- Tek repo, yerel dizin. Batch (uzak repolara toplu kurulum) kapsam dışı.
- Yazma onaylı; commit/push kullanıcıya bırakılır (CLAUDE.md #8).
- Sadece hedef reponun `.github/workflows/release.yml`'i; başka dosyaya dokunma (CLAUDE.md #6).
