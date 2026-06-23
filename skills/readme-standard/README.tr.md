[![GitHub release](https://img.shields.io/github/v/release/sametbrr/readme-standard?display_name=tag&sort=semver)](https://github.com/sametbrr/readme-standard/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)

# README Standard

Projeler arasında tutarlı bir README.md + README.tr.md yapısı dayatan bir Claude Code skill'i — oluştur, denetle, düzelt ve Türkçe aynayı senkron tut.

> 🇬🇧 For English see [README.md](README.md)

---

## Hızlı Başlangıç

```bash
git clone https://github.com/sametbrr/readme-standard ~/.claude/skills/readme-standard
```

```
> "create readme"     # generates README.md + README.tr.md from project metadata
> "audit readme"      # prints a rule-by-rule checklist, writes nothing
```

Hepsi bu kadar — proje tipi, ad, sürüm ve badge'ler otomatik tespit edilir.

---

## Özellikler

- **Dört mod** — Create, Audit, Fix ve TR Sync; Türkçe veya İngilizce doğal dille tetiklenir
- **23 zorunlu kural** — bölüm sırası, birebir başlık adları, badge desenleri, callout biçimleri, ayraç disiplini
- **Proje tipi tespiti** — badge ve metadata için `package.json` / `.csproj` / `pyproject.toml` / `SKILL.md` okur; monorepo eşitlik bozucu kuralları içerir
- **Koşullu bölümler** — Kaldırma, Sorun Giderme, Sınırlamalar ve diğerleri yalnızca tespit sinyali varken eklenir
- **Birebir Türkçe ayna** — aynı badge'ler, çevrilmiş metin ve çevrilmemiş kod bloklarıyla README.tr.md

---

## Gereksinimler

- Claude Code (veya herhangi bir [agentskills.io](https://agentskills.io) uyumlu agent)
- Otomatik tespit için manifest'i olan bir proje (`package.json`, `.csproj`, `pyproject.toml` veya `SKILL.md`) — yoksa skill sorar

---

## Kurulum

```bash
git clone https://github.com/sametbrr/readme-standard ~/.claude/skills/readme-standard
```

README'sini yönetmek istediğiniz projede yeni bir Claude Code oturumu başlatın.

---

## Kullanım

| Mod | Tetikleyici örnekler | Ne olur |
|---|---|---|
| **Create** | "create readme", "readme oluştur" | Şablonlardan ve tespit edilen metadata'dan hem README.md hem README.tr.md üretir |
| **Audit** | "audit readme", "readme kontrol et" | Kural başına ✅/❌/⚠️ ve satır referansı yazdırır — dosya yazmaz |
| **Fix** | "fix readme", "readme düzelt" | Mevcut README'leri standarda göre yeniden yazar, üzerine yazmadan önce onay alır |
| **TR Sync** | "sync tr readme", "tr readme güncelle" | Yalnızca README.tr.md'yi, güncel README.md'den yeniden üretir |

Doğru/yanlış örnekli tam kural seti [references/rules.md](references/rules.md) içinde; proje tipi başına badge markdown'ı [references/badge-patterns.md](references/badge-patterns.md) içinde; başlık ve metin çevirileri [references/tr-translations.md](references/tr-translations.md) içinde.

---

## Lisans

MIT — bkz. [LICENSE](LICENSE).
