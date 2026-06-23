# Turkish Translations Reference

Section headings, link text, and common prose patterns for README.tr.md generation.

---

## Section headings

| English | Turkish |
|---|---|
| Quick Start | Hızlı Başlangıç |
| Get Started | Başlarken |
| Features | Özellikler |
| Requirements | Gereksinimler |
| Installation | Kurulum |
| Usage | Kullanım |
| Commands | Komutlar |
| Configuration | Yapılandırma |
| How It Works | Nasıl Çalışır |
| Project Structure | Proje Yapısı |
| License | Lisans |
| Build from source | Kaynak koddan derleme |
| Examples | Örnekler |
| Available tools | Mevcut araçlar |
| Security | Güvenlik |
| Best Practices | En İyi Uygulamalar |
| Limitations | Sınırlamalar |
| Troubleshooting | Sorun Giderme |
| Uninstall | Kaldırma |
| Contributing | Katkıda Bulunma |
| Community | Topluluk |
| Documentation | Dokümantasyon |
| Development | Geliştirme |
| Publishing | Yayınlama |
| Sample application | Örnek uygulama |
| Compatibility | Uyumluluk |
| Versioning | Versiyonlama |
| Author | Yazar |
| Links | Bağlantılar |
| Related | İlgili |
| Modes | Modlar |
| Verify installation | Kurulumu doğrulama |
| What it does | Ne yapar |
| What does this package do? | Bu paket ne yapar? |
| What's inside | İçinde neler var |
| Marker interfaces | Marker interface'ler |
| Key design choices | Temel tasarım kararları |
| Multiple environments | Çoklu ortam |
| Environment selection | Ortam seçimi |
| Authentication | Kimlik doğrulama |
| One line (recommended) | Tek satır (önerilen) |
| Flexible variant | Esnek kullanım |
| Options | Seçenekler |
| Disabling scaffold | Otomatik oluşturmayı kapatma |
| Auto-scaffold (file generation) | Otomatik oluşturma (dosya üretimi) |

---

## Table header translations

| English | Turkish |
|---|---|
| Field | Alan |
| Default | Varsayılan |
| Description | Açıklama |
| Required | Zorunlu |
| Scope | Kapsam |
| Type | Tür |
| Example | Örnek |
| Tool | Araç |
| Scenario | Senaryo |
| Where to set it | Nerede Ayarlanır |
| Notes | Notlar |
| Version | Sürüm |
| Mode | Mod |
| Trigger | Tetikleyici |
| What happens | Ne olur |
| You do | Siz yaparsınız |
| The LLM does | LLM yapar |
| Purpose | Amaç |
| Project type | Proje tipi |

---

## Common prose patterns

| English | Turkish |
|---|---|
| That's it — no X needed. | Hepsi bu kadar — X gerekmez. |
| Available on [nuget.org](...). | [nuget.org](...) üzerinde mevcuttur. |
| MIT — see [LICENSE](LICENSE). | MIT — bkz. [LICENSE](LICENSE). |
| Restart your session. | Oturumunuzu yeniden başlatın. |
| In another terminal: | Başka bir terminalde: |
| Note: | Not: |
| Warning: | Uyarı: |
| Tip: | İpucu: |
| See X for details. | Ayrıntılar için X'e bakın. |
| Required | Zorunlu |
| Optional | Opsiyonel |
| Recommended | Önerilen |
| Default | Varsayılan |
| No X needed. | X gerekmez. |
| The server still starts. | Sunucu yine de başlar. |
| Never overwrites existing files. | Var olan dosyaları asla üzerine yazmaz. |
| Auto-detected if omitted. | Belirtilmezse otomatik tespit edilir. |

---

## Callout translations (Rule 18)

| English | Turkish |
|---|---|
| `> **⚠️ Important:**` | `> **⚠️ Önemli:**` |
| `> **Note:**` | `> **Not:**` |
| `> **Heads up:**` | `> **Dikkat:**` |

---

## Nav line anchors (Rule 14)

Anchors in README.tr.md point to the **Turkish** heading slugs (lowercase, spaces → `-`, Turkish characters preserved):

| English nav link | Turkish nav link |
|---|---|
| `[Quick Start](#quick-start)` | `[Hızlı Başlangıç](#hızlı-başlangıç)` |
| `[Installation](#installation)` | `[Kurulum](#kurulum)` |
| `[Usage](#usage)` | `[Kullanım](#kullanım)` |
| `[Troubleshooting](#troubleshooting)` | `[Sorun Giderme](#sorun-giderme)` |

---

## Footer translations (Rule 23)

| English | Turkish |
|---|---|
| `[Report Bug](...)` | `[Hata Bildir](...)` |
| `[Request Feature](...)` | `[Özellik İste](...)` |

URLs stay identical; only the link text is translated.

---

## `<details>` blocks (Rule 16)

Translate only the `<summary>` text; everything inside follows the normal rules (code blocks unchanged, prose translated):

| English | Turkish |
|---|---|
| `<summary><strong>Manual setup (alternative)</strong></summary>` | `<summary><strong>Manuel kurulum (alternatif)</strong></summary>` |
| `<summary><strong>Full benchmark details</strong></summary>` | `<summary><strong>Tüm benchmark ayrıntıları</strong></summary>` |

---

## Per-command template labels (Rule 21)

Bold labels inside per-command `###` subsections:

| English | Turkish |
|---|---|
| **What it does:** | **Ne yapar:** |
| **Usage:** | **Kullanım:** |
| **Example:** | **Örnek:** |
| **Requirements:** | **Gereksinimler:** |
| **When to use:** | **Ne zaman kullanılır:** |
| **Workaround:** | **Geçici çözüm:** |
| **Prerequisite:** | **Ön koşul:** |

---

## Reference link lines (verbatim — do not translate)

In README.tr.md, first line after badges:
```markdown
> 🇬🇧 For English see [README.md](README.md)
```

In README.md, after one-line description:
```markdown
> 🇹🇷 Türkçe için [README.tr.md](README.tr.md)
```

---

## License section (TR)

```markdown
## Lisans

MIT — bkz. [LICENSE](LICENSE).
```

For `.txt` extension: `MIT — bkz. [LICENSE.txt](LICENSE.txt).`

---

## Quick Start section (TR template)

```markdown
## Hızlı Başlangıç

```bash
{{install-command — unchanged}}
```

```{{lang}}
{{code example — unchanged}}
```

{{one-line closing in Turkish — e.g., "Hepsi bu kadar — manuel kayıt gerekmez."}}
```

---

## Turkish style notes for technical writing

1. Keep English proper nouns as-is: `dotnet`, `NuGet`, `.csproj`, `Bearer`, `namespace`, `middleware`.
2. Code-adjacent terms stay English in prose: `endpoint`, `payload`, `controller`, `builder`, `interface`.
3. When a Turkish sentence ends with an English word, add apostrophe + suffix:
   - `package.json'ı okuyun`
   - `assembly'yi tarar`
   - `builder.AddEnvironmentConfiguration()`'ı çağırın`
4. Use modern technical Turkish developers understand naturally. Avoid archaic formal phrasing.
5. "Optional" → "opsiyonel" (not "isteğe bağlı") for technical config fields; either is fine in prose.
6. Passive voice is natural in Turkish tech docs: "kaydedilir", "oluşturulur", "yüklenir".
7. ASCII architecture diagrams are code blocks (Rule 6) — never translated, copied verbatim.
