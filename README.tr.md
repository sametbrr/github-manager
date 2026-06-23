# github-manager

Bir GitHub hesabını uçtan uca denetleyip düzelten Claude Code plugin'i — profil alanları, profil README, repo açıklamaları, topics ve proje README'leri; interaktif ve seçilen kapsama göre.

🌐 [Read in English](README.md)

## Ne yapar

Herhangi bir authed GitHub hesabına yöneltirsin. Hesabı baştan aşağı tarar, eksik veya
standart-dışı olanı raporlar ve interaktif düzeltir — infer edemediğini sorar, edebildiğini önerir.
**Tüm hesap** veya **tek repo** üzerinde çalışır.

## Bileşenler

**Skill'ler**
- `gh-onboard` — interaktif uçtan uca orkestratör (tara → düzelt, aşama aşama)
- `gh-audit` — read-only hesap sağlık raporu (hiçbir şey yazmaz)
- `profile-bio` — hesap alanlarını (name, bio, company, location, blog, social) API ile doldur
- `profile-readme` — `<login>/<login>` profil README + Türkçe mirror üret/güncelle
- `gh-normalize` — repo açıklama ve topics'lerini doldur/standartla (tek repo veya batch)
- `readme-standard` — tutarlı README.md + README.tr.md yapısını uygula

**Agent'lar** (read-only analiz): `account-analyzer`, `description-analyzer`, `tag-analyzer`, `readme-analyzer`

**Standartlar** (kanonik kurallar): `STANDARDS/{description,tags,profile-bio,profile-readme}.md`

## Kapsam & hedef

- `--scope public|private|all` — hangi repolar (verilmezse sorar)
- `--repo owner/name` veya cwd remote'u — tek repo modu
- Hesap-seviyesi skill'ler (`profile-bio`, `profile-readme`) hesaba bir kez uygulanır

## Auth

İlk çalıştırmada tam scope bir kez istenir: `gh auth login --web -s repo,read:org,user`.
Sonra her çalıştırmada sadece `public/private/all` seçersin.

## Güvenlik

Önce oku, sonra yaz. Her dışa-dönük değişiklik (repo edit, `PATCH /user`, push) onaylıdır.
Kimlik değerleri asla uydurulmaz — eksik alan sorulur, tahmin edilmez.

## Lisans

MIT
