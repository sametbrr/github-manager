[![GitHub release](https://img.shields.io/github/v/release/sametbrr/github-manager?display_name=tag&sort=semver)](https://github.com/sametbrr/github-manager/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Agent Skills](https://img.shields.io/badge/agentskills.io-compatible-blue)](https://agentskills.io)

# github-manager

Herhangi bir GitHub hesabını denetler ve güçlendirir: profil alanları, profil README'si, repo açıklamaları, topic'ler, lisans, proje README'leri ve release workflow'ları. Önce salt okuma denetim, her yazma onaylı.

> 🇬🇧 For English see [README.md](README.md)

---

## Hızlı Başlangıç

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

```
> public GitHub repolarımı denetle
```

Eksik veya standart altı olanların salt okuma raporunu alırsınız; ardından `gh-onboard` bunları aşama aşama düzeltir.

---

## Özellikler

| | |
|---|---|
| **Önce oku, sonra yaz** | `gh-audit` hiçbir şeyi değiştirmez; dışa dönük her değişiklik (repo düzenleme, `PATCH /user`, commit, push) onayınızı bekler |
| **Tüm hesap veya tek repo** | Bir kapsamdaki tüm repoları ya da `--repo` ile verilen veya bulunduğunuz dizinin remote'undaki repoyu tarar |
| **Genel standartlar** | Açıklama, topic, lisans ve README kuralları tek bir kişinin zevkine değil, yaygın GitHub pratiğine dayanır |
| **Proje aileleri** | npm, NuGet, Python, Go CLI, MCP sunucusu, web uygulaması, özel uygulama, agent skill ve Claude/Codex plugin repoları kendilerine uygun kontrolleri alır |
| **Profil** | Hesap alanlarını doldurur ve profil README'sini yönetir; üretilen README'lerde kaynağı düzenleyip üreticiyi çalıştırır |
| **README'ler** | Birlikte gelen `readme-standard` tek bir README yapısı uygular; istenen her dilde isteğe bağlı çeviri üretir |
| **Release'ler** | npm, NuGet, PyPI, GoReleaser veya MCP Registry'ye yayınlayan, tag tabanlı bir release workflow'u kurar |
| **Yapılandırılabilir** | Çeviriler, badge'ler, açıklama stili, topic setleri ve profil bölümleri Claude Code ile Codex'in paylaştığı tek bir config dosyasında durur |
| **Uydurma yok** | Eksik profil değerleri ve açıklamalar sorulur, asla tahmin edilmez |

---

## Gereksinimler

- Claude Code, Codex veya başka bir [Agent Skills](https://agentskills.io) istemcisi
- [GitHub CLI](https://cli.github.com) (`gh`), `gh auth login -s repo,read:org,user` ile giriş yapılmış

---

## Kurulum

```bash
# Claude Code
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
# Codex
codex plugin marketplace add sametbrr/skill-hub
codex plugin add github-manager@skill-hub
# Manuel (herhangi bir Agent Skills istemcisi): skills/<skill> klasörünü ~/.claude/skills/ veya ~/.agents/skills/ altına kopyalayın
```

Manuel kurulum, tek tek skill klasörlerini değil plugin yapısının tamamını kopyalamak demektir: `gh-audit`, `gh-onboard`, `gh-normalize` ve `profile-readme` kardeş skill'lerin standartlarını (`../<skill>/references/`) ve `../../agents/` içindeki analiz ajanlarını okur. `skills/` ve `agents/` klasörlerini aynı üst klasörde yan yana tutun ve istemcinizi o `skills/` klasörüne yönlendirin. Yalnızca `readme-standard`, `release-workflow` ve `profile-bio` kardeş referansı içermez ve tek başına kopyalandığında çalışır.

---

## Kullanım

| Skill | Ne yapar | Yazar |
|---|---|---|
| `gh-audit` | Hesap veya tek repo için salt okuma sağlık raporu | hiçbir şey |
| `gh-onboard` | Uçtan uca rehberli oturum: denetim, ardından aşama aşama düzeltme | aşağıdaki skill'ler üzerinden |
| `profile-bio` | Hesap alanlarını doldurur (ad, bio, blog, konum, şirket, sosyal hesaplar) | onaydan sonra `PATCH /user` |
| `profile-readme` | `<login>/<login>` profil README'sini oluşturur veya günceller; üretilen README'leri ele alır | yerel dosyalar; onaydan sonra commit/push |
| `gh-normalize` | Repo açıklamalarını ve topic'leri tek repoda veya bir kapsamda düzeltir | onaydan sonra `gh repo edit` |
| `readme-standard` | Proje README'lerini ve çevirilerini oluşturur, denetler, düzeltir | onaydan sonra yerel dosyalar |
| `release-workflow` | Proje tipine uygun bir `release.yml` kurar | tek yerel dosya, asla commit atmaz |

Hedefler:

- `--scope public|private|all`: hangi repolar üzerinde çalışılacağı (verilmezse sorulur)
- `--repo owner/name` veya bulunduğunuz dizinin remote'u: tek repo modu
- `profile-bio` ve `profile-readme` hesap üzerinde bir kez çalışır

`gh-onboard`, `gh-normalize`, `profile-bio`, `profile-readme` ve `release-workflow` yalnızca açıkça çağırdığınızda çalışır. Kontrolleri salt okuma analiz ajanları (`account-analyzer`, `description-analyzer`, `tag-analyzer`, `readme-analyzer`) yapar; alt ajan desteği olmayan ortamlarda skill'ler bu talimatları kendi içinde uygular.

---

## Yapılandırma

İsteğe bağlı. Konum: `$GITHUB_MANAGER_HOME/config.json`, yoksa `~/.agents/github-manager/config.json` (Claude Code ve Codex ortak kullanır).

| Anahtar | Varsayılan | Anlamı |
|---|---|---|
| `language` | `"en"` | README'lerin, açıklamaların ve profil README'sinin dili |
| `readme.mirrors` | `[]` | ek tam README çevirileri, ör. `["tr"]` → `README.tr.md` |
| `readme.badges` | `"auto"` | `auto`, `minimal` veya `none` |
| `readme.extraSections` | `[]` | projeye özel bölümler; Sorun Giderme'den sonra, Katkıda Bulunma'dan önce yer alır |
| `description.maxLength` | `160` | açıklama uzunluk sınırı |
| `description.trailingPeriod` | `"optional"` | `required`, `forbidden` veya `optional` |
| `description.forms` | `["artifact", "imperative"]` | kabul edilen açıklama kalıpları |
| `topics.min` | `3` | public repolarda en az topic sayısı |
| `topics.core` | `{}` | aile bazında önerilen çekirdek topic'lerin yerine geçer |
| `topics.always` | `[]` | her repoya önerilen topic'ler |
| `topics.agentHosts` | `["claude-code", "codex"]` | bu ortamları destekleyen agent skill ve plugin'ler için ortam topic'leri |
| `profile.mirrors` | `[]` | profil README çevirileri |
| `profile.sections` | `["intro", "about", "projects", "contact"]` | profil README bölümleri, sırasıyla |
| `profile.projectSources` | `[]` | projeleri kanonik açıklamalarıyla listeleyen ek dosyalar veya URL'ler |
| `profile.stats` | `false` | profil README'sine üçüncü taraf istatistik kartları ekler |

Örnek: Türkçe çevirisi olan İngilizce README'ler (Türkçe başlık tablosu plugin ile birlikte gelir):

```json
{ "readme": { "mirrors": ["tr"] }, "profile": { "mirrors": ["tr"] } }
```

Tam başvuru: [skills/gh-audit/references/config.md](skills/gh-audit/references/config.md).

---

## Proje Yapısı

```
github-manager/
├── .claude-plugin/plugin.json   → Claude Code manifesti (sürümün tek kaynağı)
├── .codex-plugin/plugin.json    → Codex manifesti
├── agents/                      → salt okuma analiz alt ajanları
└── skills/
    ├── gh-audit/                → denetim + config ve lisans başvuruları
    ├── gh-normalize/            → açıklama ve topic standartları
    ├── gh-onboard/
    ├── profile-bio/             → profil alanları standardı
    ├── profile-readme/          → profil README standardı
    ├── readme-standard/         → README kuralları, şablonlar, Türkçe tablo
    └── release-workflow/        → release şablonları + add-release-workflow.sh
```

---

## Lisans

MIT — bkz. [LICENSE](LICENSE).
