[![GitHub release](https://img.shields.io/github/v/release/sametbrr/github-manager?display_name=tag&sort=semver)](https://github.com/sametbrr/github-manager/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](../../LICENSE)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)

# readme-standard

Proje README'lerini tek ve tutarlı bir yapıya göre oluşturur, denetler ve düzeltir; badge'leri proje manifestinden tespit eder ve isteğe bağlı tam çeviriler (örneğin README.tr.md) üretir.

> 🇬🇧 For English see [README.md](README.md)

---

## Hızlı Başlangıç

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

```text
> "audit readme"      # kural kural kontrol listesi, hiçbir dosya yazmaz
> "create readme"     # proje metadata'sından README.md (+ yapılandırılmış çeviriler)
```

Bu skill [github-manager](../../README.tr.md) plugin'inin içinde gelir. Ayrı reposu artık asıl kaynak değildir.

---

## Özellikler

- **Dört mod** — Oluştur, Denetle, Düzelt ve Çeviri Senkronu; İngilizce veya Türkçe tetiklenir
- **23 kural** — bölüm sırası, birebir başlık adları, badge desenleri, callout biçimleri, ayırıcı disiplini
- **Proje tipi tespiti** — `package.json`, `*.csproj`, `pyproject.toml`, `go.mod`, plugin manifestleri, MCP sunucuları, web uygulamaları, `SKILL.md`
- **Koşullu bölümler** — Kaldırma, Sorun Giderme, Sınırlamalar gibi bölümler yalnızca sinyalleri varsa eklenir
- **İsteğe bağlı çeviriler** — `readme.mirrors` ile istenen her dil; Türkçe başlık tablosu skill ile birlikte gelir
- **Üretilen README'ler** — README üreticilerini tespit eder, çıktıyı değil kaynağı düzenler

---

## Gereksinimler

- Claude Code, Codex veya başka bir [Agent Skills](https://agentskills.io) istemcisi
- Otomatik tespit için bir proje manifesti (yoksa skill sorar)

---

## Kurulum

```bash
# Claude Code
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
# Codex
codex plugin marketplace add sametbrr/skill-hub
codex plugin add github-manager@skill-hub
# Manuel (herhangi bir Agent Skills istemcisi): skills/readme-standard klasörünü ~/.claude/skills/ veya ~/.agents/skills/ altına kopyalayın
# (readme-standard kardeş referansı içermez, tek başına kopyalandığında çalışır)
```

---

## Kullanım

```text
> "audit readme"           # kural kural kontrol listesi, hiçbir dosya yazmaz
> "create readme"          # proje metadata'sından README.md + yapılandırılmış çeviriler
> "fix readme"             # onaydan sonra README'leri standarda göre yeniden yaz
> "sync mirrors"           # çevirileri mevcut README.md'den yeniden üret
> "readme kontrol et"      # Türkçe tetikleyici, "audit readme" ile aynı
/github-manager:readme-standard   # açık çağrı (Codex: $readme-standard)
```

| Mod | Tetikleyici örnekleri | Ne olur |
|---|---|---|
| **Oluştur** | "create readme", "readme oluştur" | Şablonlardan ve tespit edilen metadata'dan README.md'yi (ve her yapılandırılmış çeviriyi) üretir |
| **Denetle** | "audit readme", "readme kontrol et" | Kural başına ✅/❌/⚠️ ve satır referansı yazdırır; dosya yazmaz |
| **Düzelt** | "fix readme", "readme düzelt" | Onaydan sonra mevcut README'leri standarda göre yeniden yazar |
| **Çeviri Senkronu** | "sync mirrors", "tr readme güncelle" | Yalnızca çevirileri mevcut README.md'den yeniden üretir |

Tüm kurallar: [references/rules.md](references/rules.md). Badge desenleri: [references/badge-patterns.md](references/badge-patterns.md).

---

## Yapılandırma

İsteğe bağlı; `~/.agents/github-manager/config.json` (veya `$GITHUB_MANAGER_HOME/config.json`) içinde:

| Anahtar | Varsayılan | Etkisi |
|---|---|---|
| `language` | `"en"` | README.md'nin dili |
| `readme.mirrors` | `[]` | dil kodları; her biri için tam çeviri `README.<kod>.md` üretilir |
| `readme.badges` | `"auto"` | `auto`, `minimal` veya `none` |
| `readme.extraSections` | `[]` | projeye özel bölümler; Sorun Giderme'den sonra, Katkıda Bulunma'dan önce yer alır |

---

## Lisans

MIT — bkz. [LICENSE](../../LICENSE).
