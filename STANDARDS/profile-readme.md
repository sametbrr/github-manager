# Profile README Standard

`<login>/<login>` repo'sundaki `README.md` (+ `README.tr.md` mirror) için bölüm şeması.
Kaynak: sametbrr'ın mevcut profil README'si.

## Bölüm şeması (sıra önemli)

1. **Hero** (ortalı, `<div align="center">`)
   - `# <Ad Soyad>`
   - `### <rol tagline>` (ör. "Full Stack Developer · Skill & MCP Builder · Enterprise Architect")
   - tek satır misyon cümlesi
   - **badge sırası**: Website → LinkedIn → X → npm → NuGet (+ blog) — `for-the-badge` stili
   - profile-views badge
   - `🌐 [Türkçe için tıklayın](README.tr.md)` linki
2. **About Me** — `txt` code-block alıntı + giriş paragrafı + odak madde listesi
3. **What I Build** — gruplu:
   - alt-başlık + `<table>` (Project | What it does) — LLM tooling / skill'ler
   - **Published Packages** tablosu (indirme badge'li: NuGet/npm)
4. **Current Focus** — 2–4 tema (kalın başlık + 1 paragraf)
5. **GitHub Analytics** — summary-cards, tema `tokyonight`
6. **Contribution Activity** — activity-graph, tema `tokyo-night`
7. **Philosophy** — blockquote kapanış

## Veri kaynağı

- Proje tabloları **canlı veriden** üretilir: `skill-hub/marketplace.json` + `gh repo list`
  (audit'ten geçmiş **kanonik description**'larla).
- Gruplama: "LLM Tooling & MCP" (skill'ler/MCP) vs "Published Packages" (NuGet/npm).

## Kurallar

1. README.md **İngilizce**; README.tr.md tam **Türkçe mirror** (aynı badge'ler, kod blokları çevrilmez).
2. Badge sırası ve tema sabit (tutarlılık).
3. Push'tan önce diff + **onay** (CLAUDE.md #8).
4. **"Claude" / co-author footer YOK** (CLAUDE.md #9).

## Checklist (profile-readme bunu kullanır)

- [ ] Hero: ad + tagline + misyon + badge sırası + TR link
- [ ] About Me bölümü
- [ ] What I Build: skill/MCP tablosu + Packages tablosu
- [ ] Current Focus
- [ ] Analytics + Activity (tokyonight)
- [ ] Philosophy
- [ ] README.tr.md mirror güncel
- [ ] Claude/co-author ibaresi yok
