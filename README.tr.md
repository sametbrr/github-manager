[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Claude Code plugin](https://img.shields.io/badge/Claude%20Code-plugin-blue)](https://github.com/sametbrr/skill-hub)

# github-manager

Bir GitHub hesabını uçtan uca denetleyip düzelten Claude Code eklentisi — profil alanları, profil README'si, repo açıklamaları, topic'ler ve proje README'leri; etkileşimli ve seçilen kapsama göre.

> 🇬🇧 For English see [README.md](README.md)

---

## Hızlı Başlangıç

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

```
/gh-audit --scope public
```

Bu kadar — eksik ya da standart dışı olanları gösteren salt okuma bir rapor alırsın; ardından `/gh-onboard` bunları adım adım düzeltir.

---

## Özellikler

- **Tüm hesap ya da tek repo** — bir kapsamdaki tüm repoları ya da `--repo` ile verilen veya bulunduğun dizinin remote'undaki repoyu tarar
- **Önce oku, sonra yaz** — `gh-audit` hiçbir şeyi değiştirmez; dışarıya etki eden her değişiklik (repo düzenleme, `PATCH /user`, push) önce onaylatılır
- **Profil** — hesap alanlarını (ad, bio, şirket, konum, blog, sosyal) doldurur, profil README'sini Türkçe kopyasıyla birlikte günceller
- **Repo bilgileri** — açıklamaları ve topic'leri tek repoda ya da toplu olarak standarda getirir
- **README'ler** — içindeki `readme-standard` ile tutarlı bir README.md + README.tr.md yapısı uygular
- **Sürümler** — proje türüne uygun otomatik sürüm yayınlayan bir GitHub Actions iş akışı kurar
- **Kimlik uydurmaz** — eksik profil bilgileri sorulur, tahmin edilmez

---

## Gereksinimler

- Claude Code
- [GitHub CLI](https://cli.github.com) (`gh`), bir kez `gh auth login --web -s repo,read:org,user` ile giriş yapılmış

---

## Kurulum

```bash
claude plugin marketplace add sametbrr/skill-hub
claude plugin install github-manager@skill-hub
```

İlk çalıştırmada tam `gh` yetkisi bir kez istenir; sonrasında her çalıştırmada yalnızca `public`, `private` ya da `all` seçersin.

---

## Kullanım

| Skill | Ne yapar |
|---|---|
| `gh-onboard` | Uçtan uca etkileşimli yönetici: önce denetler, sonra adım adım düzeltir |
| `gh-audit` | Salt okuma hesap sağlık raporu (hiçbir şey yazmaz) |
| `profile-bio` | Hesap alanlarını (ad, bio, şirket, konum, blog, sosyal) API üzerinden doldurur |
| `profile-readme` | `<login>/<login>` profil README'sini ve Türkçe kopyasını oluşturur ve günceller |
| `gh-normalize` | Repo açıklamalarını ve topic'lerini doldurur ve standarda getirir (tek repo ya da toplu) |
| `readme-standard` | Tutarlı bir README.md + README.tr.md yapısı uygular |
| `release-workflow` | Proje türüne uygun otomatik sürüm iş akışı kurar (tek yerel repo) |

Hedefler:

- `--scope public|private|all` — hangi repolar üzerinde çalışılacağı (verilmezse sorulur)
- `--repo owner/name` ya da bulunduğun dizinin remote'u — tek repo modu
- Hesap düzeyindeki skill'ler (`profile-bio`, `profile-readme`) hesap üzerinde bir kez çalışır

Denetimi salt okuma analiz ajanları yapar: `account-analyzer`, `description-analyzer`, `tag-analyzer`, `readme-analyzer`. Denetlenen kurallar `STANDARDS/` altında durur (`description`, `tags`, `profile-bio`, `profile-readme`).

---

## Lisans

MIT — bkz. [LICENSE](LICENSE).
